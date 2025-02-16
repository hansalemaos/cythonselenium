from collections import OrderedDict
from functools import partial
from time import sleep
from typing import Union
import regex
import os
import pandas as pd
cimport numpy as np
import numpy as np
from pandas.core.base import PandasObject
from pandas.core.frame import DataFrame, Series, Index
cimport cython
from contextlib import suppress as contextlib_suppress
import cython
from pandas import NA as pdNA
from numpy import isnan as np_isnan
from pandas import isna as pd_isna
from pandas import isnull as pd_isnull
from math import isnan as math_isnan
import sys
import traceback
import os
################################################# START Pandas Printer ####################################################################

cdef:
    object regexstart = regex.compile(r"^(?:(?:aa)|(?:bb)|(?:ff))_")
    object regexstart_sub = regexstart.sub
    object regex_compiled_functions = regex.compile("^FFFF,([^,]+),")
    object regex_compiled_functions_findall= regex_compiled_functions.findall
    str getmet = """function getMethods(obj) {
      var result4 = [];
      if([false, 0, "", null, undefined, NaN].includes(obj)){
      return result4;
      }
      for (var id in obj) {
        if(![false, 0, "", null, undefined, NaN].includes(obj[id])){
        try {
        if (typeof(obj[id]) != "function") {
            result4.push(["AAAA",id,"AAAA",obj[id]]);
          }
          if (typeof(obj[id]) == "function") {
            result4.push(["FFFF",id,"FFFF",obj[id]]);
          }
        } catch (err) {
          result4.push(["FFFF","id","FFFF","obj[id]"]);
          continue;
        }}
      }
      return result4;
    }"""
    object asciifunc = np.frompyfunc(ascii, 1, 1)
    object reprfunc = np.frompyfunc(repr, 1, 1)
    str ResetAll = "\033[0m"
    str LightRed = "\033[91m"
    str LightGreen = "\033[92m"
    str LightYellow = "\033[93m"
    str LightBlue = "\033[94m"
    str LightMagenta = "\033[95m"
    str LightCyan = "\033[96m"
    str White = "\033[97m"
    list[str] colors2rotate=[
        LightRed,
        LightGreen,
        LightYellow,
        LightBlue,
        LightMagenta,
        LightCyan,
        White,
        ]





class JustColors:
    def __init__(self):
        self.BOLD = "\033[1m"
        self.ITALIC = "\033[3m"
        self.UNDERLINE = "\033[4m"
        self.UNDERLINE_THICK = "\033[21m"
        self.HIGHLIGHTED = "\033[7m"
        self.HIGHLIGHTED_BLACK = "\033[40m"
        self.HIGHLIGHTED_RED = "\033[41m"
        self.HIGHLIGHTED_GREEN = "\033[42m"
        self.HIGHLIGHTED_YELLOW = "\033[43m"
        self.HIGHLIGHTED_BLUE = "\033[44m"
        self.HIGHLIGHTED_PURPLE = "\033[45m"
        self.HIGHLIGHTED_CYAN = "\033[46m"
        self.HIGHLIGHTED_GREY = "\033[47m"
        self.HIGHLIGHTED_GREY_LIGHT = "\033[100m"
        self.HIGHLIGHTED_RED_LIGHT = "\033[101m"
        self.HIGHLIGHTED_GREEN_LIGHT = "\033[102m"
        self.HIGHLIGHTED_YELLOW_LIGHT = "\033[103m"
        self.HIGHLIGHTED_BLUE_LIGHT = "\033[104m"
        self.HIGHLIGHTED_PURPLE_LIGHT = "\033[105m"
        self.HIGHLIGHTED_CYAN_LIGHT = "\033[106m"
        self.HIGHLIGHTED_WHITE_LIGHT = "\033[107m"
        self.STRIKE_THROUGH = "\033[9m"
        self.MARGIN_1 = "\033[51m"
        self.MARGIN_2 = "\033[52m"
        self.BLACK = "\033[30m"
        self.RED_DARK = "\033[31m"
        self.GREEN_DARK = "\033[32m"
        self.YELLOW_DARK = "\033[33m"
        self.BLUE_DARK = "\033[34m"
        self.PURPLE_DARK = "\033[35m"
        self.CYAN_DARK = "\033[36m"
        self.GREY_DARK = "\033[37m"
        self.BLACK_LIGHT = "\033[90m"
        self.RED = "\033[91m"
        self.GREEN = "\033[92m"
        self.YELLOW = "\033[93m"
        self.BLUE = "\033[94m"
        self.PURPLE = "\033[95m"
        self.CYAN = "\033[96m"
        self.WHITE = "\033[97m"
        self.DEFAULT = "\033[0m"


mycolors = JustColors()


def printincolor(values, color=None, print_to_stderr=False):
    s1 = "GOT AN ERROR DURING PRINTING"
    if color:
        try:
            s1 = "%s%s%s" % (color, values, mycolors.DEFAULT)
        except Exception:
            if isinstance(values, bytes):
                s1 = "%s%s%s" % (
                    color,
                    values.decode("utf-8", "backslashreplace"),
                    mycolors.DEFAULT,
                )
            else:
                s1 = "%s%s%s" % (color, repr(values), mycolors.DEFAULT)
        if print_to_stderr:
            sys.stderr.flush()
            sys.stderr.write(f"{s1}\n")
            sys.stderr.flush()
        else:
            print(s1)

    else:
        try:
            s1 = "%s%s" % (values, mycolors.DEFAULT)
        except Exception:
            if isinstance(values, bytes):
                s1 = "%s%s" % (
                    values.decode("utf-8", "backslashreplace"),
                    mycolors.DEFAULT,
                )
            else:
                s1 = "%s%s" % (repr(values), mycolors.DEFAULT)
        if print_to_stderr:
            sys.stderr.flush()
            sys.stderr.write(f"{s1}\n")
            sys.stderr.flush()
        else:
            print(s1)


def errwrite(*args, **kwargs):
    symbol_top = kwargs.pop("symbol_top", "╦")
    symbol_bottom = kwargs.pop("symbol_bottom", "╩")
    len_top = kwargs.pop("len_top", "60")
    len_bottom = kwargs.pop("len_bottom", "60")
    color_top = kwargs.pop("color_top", "YELLOW_DARK")
    color_bottom = kwargs.pop("color_bottom", "RED_DARK")
    print_to_stderr = kwargs.pop("print_to_stderr", False)
    color_exception = kwargs.pop("color_exception", "CYAN")
    color2print_top = None
    color2print_bottom = None
    color_exceptionmiddle = None
    try:
        color2print_top = mycolors.__dict__.get(
            color_top, mycolors.__dict__.get("YELLOW_DARK")
        )
        color2print_bottom = mycolors.__dict__.get(
            color_bottom, mycolors.__dict__.get("RED_DARK")
        )
        color_exceptionmiddle = mycolors.__dict__.get(
            color_exception, mycolors.__dict__.get("CYAN")
        )
    except Exception as e:
        print(e)

    printincolor(
        values="".join(symbol_top * int(len_top)),
        color=color2print_top,
        print_to_stderr=print_to_stderr,
    )
    etype, value, tb = sys.exc_info()
    lines = traceback.format_exception(etype, value, tb)
    try:
        if print_to_stderr:
            sys.stderr.flush()

            sys.stderr.write("".join(lines))
            sys.stderr.flush()
        else:
            printincolor(
                "".join(lines),
                color=color_exceptionmiddle,
                print_to_stderr=print_to_stderr,
            )
    except Exception:
        print("".join(lines))
    printincolor(
        "".join(symbol_bottom * int(len_bottom)),
        color=color2print_bottom,
        print_to_stderr=print_to_stderr,
    )



class Tuppsub(tuple):
    """Protects tuples internally from being flattened, same as ProtectedTuple"""

    pass

class ProtectedList(list):
    """Protects lists from being flattened"""

    pass

def flatt_dict(
    v,
    forbidden=(list, tuple, set, frozenset),
    allowed=(
        str,
        int,
        float,
        complex,
        bool,
        bytes,
        type(None),
        ProtectedList,
    ),
):

    if isinstance(v, dict):
        if isinstance(v, allowed):
            yield v
        else:
            for k, v2 in v.items():
                if isinstance(v2, allowed):
                    yield v2
                else:
                    yield from flatt_dict(v2, forbidden=forbidden, allowed=allowed)
    elif isinstance(v, forbidden):
        for v2 in v:
            if isinstance(v2, allowed):
                yield v2
            else:
                yield from flatten_everything(v2, forbidden=forbidden, allowed=allowed)
    elif isinstance(v, allowed):
        yield v
    else:
        try:
            for v2 in v:
                try:
                    if isinstance(v2, allowed):
                        yield v2
                    else:
                        yield from flatt_dict(v2, forbidden=forbidden, allowed=allowed)
                except Exception:
                    yield v2
        except Exception:
            yield v


def flatten_everything(
    item,
    forbidden=(list, tuple, set, frozenset),
    allowed=(
        str,
        int,
        float,
        complex,
        bool,
        bytes,
        type(None),
        ProtectedList,
    ),
):
    if isinstance(item, allowed):
        yield item
    elif isinstance(item, forbidden) and not isinstance(item, allowed):
        for xaa in item:
            if isinstance(xaa, allowed):
                yield xaa
            else:
                try:
                    yield from flatten_everything(
                        xaa,
                        forbidden=forbidden,
                        allowed=allowed,
                    )
                except Exception:

                    yield xaa
    elif isinstance(item, dict):
        if isinstance(item, allowed):
            yield item
        else:
            yield from flatt_dict(item, forbidden=forbidden, allowed=allowed)
    elif isinstance(item,OrderedDict):
        if isinstance(item, allowed):
            yield item
        else:
            yield from flatt_dict(dict(item), forbidden=forbidden, allowed=allowed)

    else:
        try:
            for xaa in (item):
                try:
                    if isinstance(xaa, allowed):
                        yield xaa

                    elif isinstance(xaa, dict):

                        if isinstance(xaa, allowed):
                            yield xaa
                        else:
                            yield from flatt_dict(
                                item, forbidden=forbidden, allowed=allowed
                            )

                    else:
                        yield from flatten_everything(
                            xaa,
                            forbidden=forbidden,
                            allowed=allowed,
                        )
                except Exception:

                    yield from flatten_everything(
                        xaa,
                        forbidden=forbidden,
                        allowed=allowed,
                    )
        except Exception:

            yield item




cdef bint qq_s_isnan(
    object x,
) :

    if isinstance(x, type(None)):
        return True
    try:
        if np_isnan(x):
            return True
    except Exception:
        pass
    try:
        if pd_isna(x):
            return True
    except Exception:
        pass
    try:
        if pd_isnull(x):
            return True
    except Exception:
        pass
    try:
        if math_isnan(x):
            return True
    except Exception:
        pass
    try:
        if x != x:
            return True
    except Exception:
        pass
    return False


class Iframes:
    __slots__=("alltagsonpage","By","WebDriverWait","expected_conditions","driver","seperator_for_duplicated_iframe","iframes","ignore_google_ads","mainframegemacht")
    def __init__(
        self,
        object driver,
        object By,
        object WebDriverWait,
        object expected_conditions,
        str seperator_for_duplicated_iframe="Ç",
        bint ignore_google_ads=True,
    ):
        self.alltagsonpage = {}
        self.By = By
        self.WebDriverWait = WebDriverWait
        self.expected_conditions = expected_conditions
        self.driver = driver
        self.seperator_for_duplicated_iframe = seperator_for_duplicated_iframe
        self.iframes = {}
        self.driver.switch_to.default_content()
        self.ignore_google_ads = ignore_google_ads
        self.iframes["mainframe"] = ""
        self.mainframegemacht = True
        self.__map__([])
        self.driver.switch_to.default_content()

    def __map__(self, path):
        cdef:
            list iframesn,iframes2
            list[str] allatributes
            Py_ssize_t tagframeidx,tempnummer
            str tagname
            object iframe
            str allat
            str key
        iframesn = self.driver.find_elements(self.By.TAG_NAME, "iframe")
        iframesn = [("iframe", x) for x in iframesn]
        iframes2 = self.driver.find_elements(self.By.TAG_NAME, "frame")
        iframes2 = [("frame", x) for x in iframes2]
        iframesn.extend(iframes2)
        allatributes = []
        for tagframeidx in range(len(iframesn)):
            tagname=iframesn[tagframeidx][0]
            iframe=iframesn[tagframeidx][1]
            with contextlib_suppress(Exception):
                for attr in iframe.get_property("attributes"):
                    allat = rf"""[{attr['name']}="{attr['value']}"]"""
                    allatributes.append(allat)
            #except Exception:
            #    errwrite()

            with contextlib_suppress(Exception):
                key = tagname + "".join(allatributes)
                if self.ignore_google_ads:
                    if "google_ads_iframe" in key:
                        continue
                tempnummer = 0
                tempkey = key
                while key in self.iframes:
                    key = (
                        tempkey
                        + self.seperator_for_duplicated_iframe
                        + str(tempnummer).zfill(6)
                    )
                    tempnummer = tempnummer + 1
                if not self.mainframegemacht:
                    self.iframes["mainframe"] = path + [iframe]
                    self.mainframegemacht = True
                elif self.mainframegemacht:
                    self.iframes[key] = path + [iframe]
                self.driver.switch_to.frame(iframe)
                self.__map__(self.iframes[key])
        self.driver.switch_to.parent_frame()

    def switch_to(self, key):
        self.driver.switch_to.default_content()
        if key == "mainframe":
            self.driver.switch_to.default_content()

        if key not in self.iframes:
            self.__map__([])

        if key not in self.iframes:
            try:
                wait = self.WebDriverWait(self.driver, 20)
                regex.sub(rf"{self.seperator_for_duplicated_iframe}\d{{6}}$", "", key)
                wait.until(
                    self.expected_conditions.frame_to_be_available_and_switch_to_it(
                        (self.By.CSS_SELECTOR, key)
                    )
                )
            except Exception:
                errwrite()

        else:
            for iframe in self.iframes[key]:
                try:
                    self.driver.switch_to.frame(iframe)
                except Exception:
                    errwrite()


@cython.nonecheck(True)
def pdp(
    object df,
    Py_ssize_t column_rep=70,
    Py_ssize_t max_lines=0,
    Py_ssize_t max_colwidth=300,
    Py_ssize_t ljust_space=2,
    str sep=" | ",
    bint vtm_escape=True,
):
    cdef:
        dict[Py_ssize_t, np.ndarray] stringdict= {}
        dict[Py_ssize_t, Py_ssize_t] stringlendict= {}
        list[str] df_columns, allcolumns_as_string
        Py_ssize_t i, len_a, len_df_columns, lenstr, counter, j, len_stringdict0, k, len_stringdict
        str stringtoprint, dashes, dashesrep
        np.ndarray a
    if vtm_escape:
        print('\033[12:2p')
    if len(df) > max_lines and max_lines > 0:
        a = df.iloc[:max_lines].reset_index(drop=False).T.__array__()
    else:
        a = df.iloc[:len(df)].reset_index(drop=False).T.__array__()
    try:
        df_columns = ["iloc"] + [str(x) for x in df.columns]
    except Exception:
        try:
            df_columns = ["iloc",str(df.name)]
        except Exception:
            df_columns = ["iloc",str(0)]
    len_a=len(a)
    for i in range(len_a):
        try:
            stringdict[i] = reprfunc(a[i]).astype("U")
        except Exception:
            stringdict[i] = asciifunc(a[i]).astype("U")
        stringlendict[i] = (stringdict[i].dtype.itemsize // 4) + ljust_space
    for i in range(len_a):
        lenstr = len(df_columns[i])
        if lenstr > stringlendict[i]:
            stringlendict[i] = lenstr + ljust_space
        if max_colwidth > 0:
            if stringlendict[i] > max_colwidth:
                stringlendict[i] = max_colwidth

    allcolumns_as_string = []
    len_df_columns=len(df_columns)
    for i in range(len_df_columns):
        stringtoprint = str(df_columns[i])[: stringlendict[i]].ljust(stringlendict[i])
        allcolumns_as_string.append(stringtoprint)
    allcolumns_as_string_str = sep.join(allcolumns_as_string) + sep
    dashes = "-" * (len(allcolumns_as_string_str) + 2)
    dashesrep = dashes + "\n" + allcolumns_as_string_str + "\n" + dashes
    counter = 0
    len_stringdict0 = len(stringdict[0])
    len_stringdict=len(stringdict)
    for j in range(len_stringdict0):
        if column_rep > 0:
            if counter % column_rep == 0:
                print(dashesrep)
        counter += 1
        for k in range(len_stringdict):
            print((
                colors2rotate[k % len(colors2rotate)] + stringdict[k][j][: stringlendict[k]].replace("\n",
            "\\n").replace("\r", "\\r").ljust(stringlendict[k]) + ResetAll
            ), end=sep)
        print()
    return ""

def print_col_width_len(df):
    try:
        pdp(
            pd.DataFrame(
                [df.shape[0], df.shape[1]], index=["rows", "columns"]
            ).T.rename(
                {0: "DataFrame"},
            ),
        )
    except Exception:
        pdp(
            pd.DataFrame([df.shape[0]], index=["rows"]).T.rename({0: "Series"}),
        )


def pandasprintcolor(self):
    pdp(pd.DataFrame(self.reset_index().__array__(), columns=['index']+[str(x) for x in self.columns],copy=False))
    print_col_width_len(self.__array__())

    return ""


def copy_func(f):
    g = lambda *args: f(*args)
    t = list(filter(lambda prop: not ("__" in prop), dir(f)))
    i = 0
    while i < len(t):
        setattr(g, t[i], getattr(f, t[i]))
        i += 1
    return g


def pandasprintcolor_s(self):
    return pandasprintcolor(self.to_frame())

def pandasindexcolor(self):
    pdp(pd.DataFrame(self.__array__()[: self.print_stop].reshape((-1, 1))))
    return ""


def reset_print_options():
    PandasObject.__str__ = copy_func(PandasObject.old__str__)
    PandasObject.__repr__ = copy_func(PandasObject.old__repr__)
    DataFrame.__repr__ = copy_func(DataFrame.old__repr__)
    DataFrame.__str__ = copy_func(DataFrame.old__str__)
    Series.__repr__ = copy_func(Series.old__repr__)
    Series.__str__ = copy_func(Series.old__str__)
    Index.__repr__ = copy_func(Index.old__repr__)
    Index.__str__ = copy_func(Index.old__str__)


def substitute_print_with_color_print(
    print_stop: int = 69, max_colwidth: int = 300, repeat_cols: int = 70
):
    if not hasattr(pd, "color_printer_active"):
        PandasObject.old__str__ = copy_func(PandasObject.__str__)
        PandasObject.old__repr__ = copy_func(PandasObject.__repr__)
        DataFrame.old__repr__ = copy_func(DataFrame.__repr__)
        DataFrame.old__str__ = copy_func(DataFrame.__str__)
        Series.old__repr__ = copy_func(Series.__repr__)
        Series.old__str__ = copy_func(Series.__str__)
        Index.old__repr__ = copy_func(Index.__repr__)
        Index.old__str__ = copy_func(Index.__str__)

    PandasObject.__str__ = lambda x: pandasprintcolor(x)
    PandasObject.__repr__ = lambda x: pandasprintcolor(x)
    PandasObject.print_stop = print_stop
    PandasObject.max_colwidth = max_colwidth
    PandasObject.repeat_cols = repeat_cols
    DataFrame.__repr__ = lambda x: pandasprintcolor(x)
    DataFrame.__str__ = lambda x: pandasprintcolor(x)
    DataFrame.print_stop = print_stop
    DataFrame.max_colwidth = max_colwidth
    DataFrame.repeat_cols = repeat_cols
    Series.__repr__ = lambda x: pandasprintcolor_s(x)
    Series.__str__ = lambda x: pandasprintcolor_s(x)
    Series.print_stop = print_stop
    Series.max_colwidth = max_colwidth
    Series.repeat_cols = repeat_cols
    Index.__repr__ = lambda x: pandasindexcolor(x)
    Index.__str__ = lambda x: pandasindexcolor(x)
    Index.print_stop = print_stop
    Index.max_colwidth = max_colwidth
    Index.repeat_cols = 10000000
    pd.color_printer_activate = substitute_print_with_color_print
    pd.color_printer_reset = reset_print_options
    pd.color_printer_active = True

def qq_ds_print_nolimit(self, **kwargs):
    try:
        pdp(
            pd.DataFrame(self.reset_index().__array__(), columns=['index']+[str(x) for x in self.columns],copy=False),
            max_lines=0,
            **kwargs,
        )
        print_col_width_len(self.__array__())
    except Exception:
        try:
            pdp(
                pd.DataFrame(self.reset_index().__array__(), columns=['index',self.name],copy=False),
                max_lines=0,
            )
        except Exception:
            pdp(
                pd.DataFrame(self.__array__(),copy=False),
                max_lines=0,
            )
        print_col_width_len(self.__array__())
    return ""


def qq_d_print_columns(self, **kwargs):
    pdp(
        pd.DataFrame(self.columns.__array__().reshape((-1, 1))),
        max_colwidth=0,
        max_lines=0,
        **kwargs,
    )
    return ""


def qq_ds_print_index(self, **kwargs):
    pdp(pd.DataFrame(self.index.__array__().reshape((-1, 1))),    max_lines=0, max_colwidth=0, **kwargs)
    return ""


def add_printer(overwrite_pandas_printer=False):

    PandasObject.ds_color_print_all = qq_ds_print_nolimit
    DataFrame.d_color_print_columns = qq_d_print_columns
    DataFrame.d_color_print_index = qq_ds_print_index
    if overwrite_pandas_printer:
        substitute_print_with_color_print()

add_printer(True)

cdef class NamedFunction:
    cdef:
        object f

    def __init__(
        self,
        execute_function,
    ):
        self.f = execute_function

    def __call__(self, *args, **kwargs):

        return self.f(*args, **kwargs)

    def __str__(self):
        return "()"

    def __repr__(self):
        return "()"

def _selenium_functions_(
    func, driver_, webelement, frame, iframes_, arguments, add_arguments
):

    if not isinstance(arguments, list):
        arguments = [arguments]
    try:
        iframes_.switch_to(frame)
        if add_arguments:
            executefunction = getattr(webelement, func)(*arguments)

        else:
            executefunction = getattr(webelement, func)()

        driver_.switch_to.default_content()
        if qq_s_isnan(executefunction):
            executefunction = True
        return executefunction
    except Exception:
        errwrite()
        driver_.switch_to.default_content()
        return pdNA


def _selenium_functions_no_args_partial(
    func, driver_, webelement, frame, iframes_, arguments="", add_arguments=False
):
    return NamedFunction(
        execute_function=partial(
            _selenium_functions_,
            func,
            driver_,
            webelement,
            frame,
            iframes_,
            arguments=arguments,
            add_arguments=add_arguments,
        ),
    )


def _selenium_functions_with_args_partial(
    func, driver_, webelement, frame, iframes_, add_arguments=True
):
    return NamedFunction(
        execute_function=partial(
            _selenium_functions_,
            func,
            driver_,
            webelement,
            frame,
            iframes_,
            add_arguments=add_arguments,
        ),
    )


def get_all_elements(driver_, By, WebDriverWait, expected_conditions, queryselector):
    cdef:
        list all_attributes = []
        object iframes
        list attributes
    driver_.switch_to.default_content()
    iframes = Iframes(
        driver=driver_,
        By=By,
        WebDriverWait=WebDriverWait,
        expected_conditions=expected_conditions,
    )
    for x in iframes.iframes.items():
        iframes.switch_to(x[0])
        attributes = driver_.execute_script(
            rf"""

                {getmet}

                var result = [];
                var all = document.querySelectorAll(`{queryselector}`);
                for (var i=0, max=all.length; i < max; i++) {{
            try {{
                result.push([all[i],getMethods(all[i]).join("ÇÇÇÇÇÇÇÇÇÇ")]);
                     }}           catch (err) {{
                    result.push([all[i],`ERROR`]);
              continue;

            }}
            }};
                return result;
            """
        )
        all_attributes.append((x[0], attributes))
    return iframes, all_attributes, list(iframes.iframes.keys())


cdef list _normalize_result_dict(dict allelements, list normalize_functions, list normalize_attributes):
    cdef:
        list ganzeliste = []
        list ganzeliste_tmp1,ganzeliste_tmp,attribdict_list
        object functiondict
        object attribdict
        object newvalue
        Py_ssize_t all_attributes
        str str_newvalue
        object webelement
        str key2
        object key3,functions,aa
    for key in (allelements):
        ganzeliste_tmp1 = []
        for key2 in allelements[key]:
            if key2 == "all_data":
                continue
            ganzeliste_tmp = []
            for key3 in allelements[key][key2]:
                if key2 == "webelements":
                    webelement = key3
                    ganzeliste_tmp.append({key: webelement})
                if key2 == "functions":
                    ganzeliste_tmp.append(OrderedDict(
                        {k: k if k in key3 else pdNA for k in normalize_functions}
                    ))

                if key2 == "attributes":
                    attrib = key3
                    attribdict_list = []

                    for aa in attrib:
                        attribdict = OrderedDict()

                        for aa_ in aa:
                            newvalue = aa_[1]
                            if (aa_[0]) not in normalize_attributes:
                                attribdict[(aa_[0])] = newvalue
                            str_newvalue=str(newvalue)
                            if str_newvalue == "true":
                                newvalue = True
                            elif str_newvalue == "false":
                                newvalue = False
                            elif str_newvalue.isdigit():
                                newvalue = int(newvalue)
                            elif str_newvalue.replace(".", "").isdigit() and len(
                                str_newvalue.replace(".", "")
                            ) + 1 == len(str_newvalue):
                                newvalue = float(newvalue)
                            attribdict[(aa_[0])] = newvalue
                        for all_attributes in range(len(normalize_attributes)):
                            if normalize_attributes[all_attributes] not in attribdict:
                                attribdict[normalize_attributes[all_attributes]] = pdNA
                        attribdict_list.append(attribdict)
                    ganzeliste_tmp.append([attribdict_list])
            ganzeliste_tmp1.append(ganzeliste_tmp)
        ganzeliste.append(ganzeliste_tmp1)
    return ganzeliste


def _search_result_to_dict(all_attributes, iframes, iframenames):
    cdef:
        dict allelements = {}
        list normalize_attributes = []
        list normalize_functions = []
        list all_data,webelements,attributes,attributes_,functions
        Py_ssize_t number
    for number in range(len(iframes.iframes)):
        all_data = [
            [x for x in (all_attributes[number][1][z][1]).split("ÇÇÇÇÇÇÇÇÇÇ")]
            for z in range(len(all_attributes[number][1]))
        ]
        webelements = [
            [
                (all_attributes[number][1][z][0])
                for z in range(len(all_attributes[number][1]))
            ]
        ]
        attributes = [
            [a if a.startswith("AAAA") else None for a in all_data[b]]
            for b in range(len(all_data))
        ]
        attributes = [[y for y in x if y is not None] for x in attributes]
        attributes = [
            [y.split("AAAA,", maxsplit=2)[1:][::1] for y in x] for x in attributes
        ]
        attributes_ = [
            [
                ([[z.strip().strip(""""\',""") for z in y][0] for y in x])
                for x in attributes
            ]
        ]
        attributes = [
            [
                ProtectedList([[z.strip().strip(""""\',""") for z in y] for y in x])
                for x in attributes
            ]
        ]

        functions = [
            [a if a.startswith("FFFF") else None for a in all_data[b]]
            for b in range(len(all_data))
        ]
        functions = [
            list(
                flatten_everything(
                    [regex_compiled_functions_findall(y) for y in x if y is not None]
                )
            )
            for x in functions
        ]
        normalize_attributes.extend(attributes_)
        normalize_functions.extend(functions)

        allelements[iframenames[number]] = {
            "all_data": all_data,
            "webelements": webelements,
            "attributes": attributes,
            "functions": functions,
        }
    return allelements, list(
        dict.fromkeys(list(flatten_everything(normalize_functions)))
    ), list(
        dict.fromkeys(list(flatten_everything(normalize_attributes)))
    )


def _result_dict_to_dataframe(ganzeliste):
    cdef:
        list dfs,adjustedframesall,adjustedframes
        Py_ssize_t ini2
        object each_frameadjusted,each_frame_
        list columnstodrop
        object concatelements
        object df
    dfs = []
    for fra in ganzeliste:
        dfs.append([pd.DataFrame(_,dtype=object) for _ in fra])
    adjustedframesall = []
    for dframestemp in dfs:
        adjustedframes = []

        for ini2 in range(len(dframestemp)):
            each_frame=dframestemp[ini2]
            if ini2 == 0:
                each_frameadjusted = each_frame.explode(each_frame.columns[0])
                each_frameadjusted[
                    "frame"
                ] = each_frameadjusted.columns.to_list() * len(each_frameadjusted)
                each_frameadjusted["elements_in_frame"] = len(each_frameadjusted)

                adjustedframes.append(each_frameadjusted.reset_index(drop=True))
            elif ini2 == 1:
                each_frame_ = (
                    each_frame.explode(0)[0].apply(lambda x: pd.Series(x))
                )
                each_frame_.columns = [f"aa_{x}" for x in each_frame_.columns.to_list()]
                adjustedframes.append(each_frame_.reset_index(drop=True))

            else:
                each_frame_ = each_frame.copy()
                each_frame_.columns = [f"js_{x}" for x in each_frame_.columns.to_list()]

                adjustedframes.append(each_frame_.reset_index(drop=True))
        concatelements = pd.concat(adjustedframes, axis=1)
        concatelements.columns = ["element"] + concatelements.columns.to_list()[1:]
        adjustedframesall.append(concatelements)
    df = (
        pd.concat(adjustedframesall, ignore_index=True)
        .dropna(subset=["element"]).reset_index(drop=True)
    )
    columnstodrop = []
    for _ in [
        x for x in df.columns if x.startswith("aa_") or x.startswith("js_")
    ]:
        with contextlib_suppress(Exception):
            if (df[_].nunique()) == 1 and _.startswith("aa_"):
                columnstodrop.append(_)
            if (df[_].nunique()) == 1 and _.startswith("js_"):
                if qq_s_isnan(df[_].iloc[0]):
                    columnstodrop.append(_)
    if "aa_0" in df.columns:
        columnstodrop.append("aa_0")

    return df.drop(columns=columnstodrop)


def execute_jsript_function(
    driver_,
    webelement,
    frame,
    iframes_,
    function_name: str,
    arguments: Union[list, str] = "",
):
    if isinstance(arguments, list):
        ", ".join(arguments).strip(" ,")
    try:
        iframes_.switch_to(frame)
        jscriptresult = driver_.execute_script(
            f"return arguments[0].{function_name}({arguments});", webelement
        )
        driver_.switch_to.default_content()
        return jscriptresult
    except Exception:
        driver_.switch_to.default_content()
        return pdNA


def create_function(driver_, webelement, frame, function_name, iframes_):

    return NamedFunction(
        execute_function=partial(
            execute_jsript_function, driver_, webelement, frame, iframes_, function_name
        ),
    )


def wheel_element(
    driver_,
    webelement,
    iframes_,
    frame,
    deltaY=120,
    offsetX=0,
    offsetY=0,
    script_timeout=1,
):
    # https://stackoverflow.com/questions/55371752/how-do-i-use-multi-line-scripts-in-selenium-to-execute-a-script

    oldvalue = driver_.__dict__["caps"]["timeouts"]["script"]
    driver_.set_script_timeout(script_timeout)

    try:
        iframes_.switch_to(frame)
        jscriptresult = webelement._parent.execute_script(
            """
        var element = arguments[0];
        var deltaY = arguments[1];
        var box = element.getBoundingClientRect();
        var clientX = box.left + (arguments[2] || box.width / 2);
        var clientY = box.top + (arguments[3] || box.height / 2);
        var target = element.ownerDocument.elementFromPoint(clientX, clientY);

        for (var e = target; e; e = e.parentElement) {
          if (e === element) {
            target.dispatchEvent(new MouseEvent('mouseover', {view: window, bubbles: true, cancelable: true, clientX: clientX, clientY: clientY}));
            target.dispatchEvent(new MouseEvent('mousemove', {view: window, bubbles: true, cancelable: true, clientX: clientX, clientY: clientY}));
            target.dispatchEvent(new WheelEvent('wheel',     {view: window, bubbles: true, cancelable: true, clientX: clientX, clientY: clientY, deltaY: deltaY}));
            return;
          }
        }
        return "Element is not interactable";
        """,
            webelement,
            deltaY,
            offsetX,
            offsetY,
        )
        driver_.switch_to.default_content()
        driver_.set_script_timeout(oldvalue)
        if jscriptresult is None:
            return True
        return False
    except Exception:
        driver_.switch_to.default_content()
        return pdNA


def switch_to_window(driver, cwh):
    return NamedFunction(
        execute_function=partial(driver.switch_to.window, cwh),
    )


def change_html_code_of_element(
    driver, element, iframes_, frame, htmlcode, script_timeout=2
):
    iframes_.switch_to(frame)
    oldvalue = driver.__dict__["caps"]["timeouts"]["script"]
    driver.set_script_timeout(script_timeout)
    driver.execute_script(f"arguments[0].innerHTML = `{htmlcode}`;", element)
    driver.switch_to.default_content()
    driver.set_script_timeout(oldvalue)


def _switch_to_frame(frame, iframes_):
    iframes_.switch_to(frame)


def _location_once_scrolled_into_view(driver_, webelement, frame, iframes_):
    try:
        iframes_.switch_to(frame)

        webelement.location_once_scrolled_into_view
        driver_.switch_to.default_content()
        return True

    except Exception:
        errwrite()
        return pdNA


def location_once_scrolled_into_view_partial(driver_, webelement, frame, iframes_):
    return NamedFunction(
        execute_function=partial(
            _location_once_scrolled_into_view, driver_, webelement, frame, iframes_
        ),
    )


cdef void _functions_to_dataframe(object df, object driver_, object iframes):
    cdef:
        str folder
    for col in df.columns:
        if str(col).startswith("js_"):
            df.loc[:,col] = df.apply(
                lambda x: create_function(driver_, x.element, x.frame, x[col], iframes),
                axis=1,
            )

    df.loc[:,"js_wheel"] = df.apply(
        lambda x: NamedFunction(
            execute_function=partial(
                wheel_element, driver_, x.element, iframes, x.frame
            ),
        ),
        axis=1,
    )

    df.loc[:,"js_change_html_value"] = df.apply(
        lambda x: NamedFunction(
            execute_function=partial(
                change_html_code_of_element, driver_, x.element, iframes, x.frame
            ),
        ),
        axis=1,
    )

    df.loc[:,"se_send_keys"] = df.apply(
        lambda x: _selenium_functions_with_args_partial(
            "send_keys", driver_, x.element, x.frame, iframes
        ),
        axis=1,
    )

    df.loc[:,"se_find_elements"] = df.apply(
        lambda x: _selenium_functions_with_args_partial(
            "find_elements", driver_, x.element, x.frame, iframes
        ),
        axis=1,
    )
    df.loc[:,"se_find_element"] = df.apply(
        lambda x: _selenium_functions_with_args_partial(
            "find_element", driver_, x.element, x.frame, iframes
        ),
        axis=1,
    )
    df.loc[:,"se_is_displayed"] = df.apply(
        lambda x: _selenium_functions_no_args_partial(
            "is_displayed", driver_, x.element, x.frame, iframes
        ),
        axis=1,
    )
    df.loc[:,"se_is_enabled"] = df.apply(
        lambda x: _selenium_functions_no_args_partial(
            "is_enabled", driver_, x.element, x.frame, iframes
        ),
        axis=1,
    )
    df.loc[:,"se_is_selected"] = df.apply(
        lambda x: _selenium_functions_no_args_partial(
            "is_selected", driver_, x.element, x.frame, iframes
        ),
        axis=1,
    )
    df.loc[:,"se_clear"] = df.apply(
        lambda x: _selenium_functions_no_args_partial(
            "clear", driver_, x.element, x.frame, iframes
        ),
        axis=1,
    )

    df.loc[:,"se_click"] = df.apply(
        lambda x: _selenium_functions_no_args_partial(
            "click", driver_, x.element, x.frame, iframes
        ),
        axis=1,
    )

    df.loc[:,"se_switch_to_frame"] = df.apply(
        lambda x: _switch_to_frame(x.frame, iframes),
        axis=1,
    )
    df.loc[:,"se_location_once_scrolled_into_view"] = df.apply(
        lambda x: location_once_scrolled_into_view_partial(
            driver_, x.element, x.frame, iframes
        ),
        axis=1,
    )

    folder = os.getcwd()
    folder = os.path.join(folder, "seleniumpictures")
    if not os.path.exists(folder):
        os.makedirs(folder)
    df.loc[:,"se_get_screenshot_as_file"] = df.index.astype(str) + ".png"
    df.loc[:,"se_get_screenshot_as_file"] = df["se_get_screenshot_as_file"].apply(
        lambda x: os.path.join(folder, x)
    )
    df.loc[:,"se_screenshot"] = df.apply(
        lambda x: _selenium_functions_no_args_partial(
            "screenshot",
            driver_,
            x.element,
            x.frame,
            iframes,
            x.se_get_screenshot_as_file,
            True,
        ),
        axis=1,
    )


cdef get_df(
    object driver_,
    object By,
    object WebDriverWait,
    object expected_conditions,
    str queryselector="*",
    object repeat_until_element_in_columns=None,
    Py_ssize_t max_repeats=1,
    bint with_methods=True,
):
    cdef:
        Py_ssize_t howmanyloops = max_repeats if repeat_until_element_in_columns is not None else 1
        object df
        object iframes
        list all_attributes,iframenames
        dict allelements
        list normalize_attributes
        list normalize_functions
        list allcollis
        list ganzeliste
        object cwh
    df = pd.DataFrame()
    for _ in range(howmanyloops):
        iframes, all_attributes, iframenames = get_all_elements(
            driver_=driver_,
            By=By,
            WebDriverWait=WebDriverWait,
            expected_conditions=expected_conditions,
            queryselector=queryselector,
        )
        allelements, normalize_functions, normalize_attributes = _search_result_to_dict(
            all_attributes, iframes, iframenames
        )
        ganzeliste = _normalize_result_dict(
            allelements, normalize_functions, normalize_attributes
        )
        df = _result_dict_to_dataframe(ganzeliste)
        if with_methods:
            _functions_to_dataframe(df, driver_, iframes)
        if repeat_until_element_in_columns is not None:
            allcollis = [
                x
                for x in df.columns
                if regexstart_sub("", str(x)).strip()
                == regexstart_sub("", str(repeat_until_element_in_columns)).strip()
            ]
            if any(allcollis):
                break
            else:
                sleep(1)

    cwh = driver_.current_window_handle
    return df.assign(aa_window_handle=cwh, aa_window_switch=[switch_to_window(driver_, cwh) for _ in range(len(df))])


cdef class SeleniumFrame:
    """
    A class to encapsulate the functionality of retrieving and manipulating HTML elements
    within a web page using Selenium WebDriver. This class provides a structured way to access
    and interact with web elements, including the ability to execute JavaScript functions and
    handle dynamic content loaded within iframes.

    Attributes:
        driver (WebDriver): The Selenium WebDriver instance used to control the browser.
        By (By): Selenium By class used to locate elements on a web page.
        WebDriverWait (WebDriverWait): Selenium WebDriverWait class used for implementing explicit waits.
        expected_conditions (expected_conditions): Module in Selenium used to set expected conditions for explicit waits.
        queryselector (str): CSS selector used to query and return elements from the DOM. Defaults to '*' which selects all elements.
        repeat_until_element_in_columns (optional): Specific element to be checked for its presence in the dataframe columns before stopping the query. Useful for waiting on AJAX or dynamically loaded content.
        max_repeats (int): Maximum number of iterations to perform when checking for the presence of 'repeat_until_element_in_columns'. Defaults to 1.
        with_methods (bool): Flag to determine if JavaScript methods should be attached to the elements in the resulting dataframe. Defaults to True.

    Methods:
        __call__(queryselector=None, with_methods=None, repeat_until_element_in_columns=None, max_repeats=None, driver=None, By=None, WebDriverWait=None, expected_conditions=None):
            Generates a dataframe of web elements based on the specified query selector. The dataframe can include methods attached to these elements if 'with_methods' is True. This method allows for overriding class attributes during its call for flexibility in querying different elements without needing to create multiple instances of the class.
    Advantages:
        - Provides a structured DataFrame format for web elements, simplifying data manipulation.
        - Seamlessly integrates with Selenium WebDriver for robust browser interactions.
        - Capable of handling dynamic content and content within iframes, crucial for modern web applications.
        - Enables execution of JavaScript functions directly on web elements.
        - Offers customizable CSS selectors, waiting conditions, and method attachments for flexible web scraping.
        - Incorporates explicit waits to enhance the reliability of web interactions.
        - Supports repeat queries for dealing with asynchronously loaded content.
        - Automatically switches to the correct frame before performing actions like clicking, ensuring seamless interaction with elements across multiple frames.
        - Retrieves all elements in a single request to optimize performance and reduce the load on the web server.
    """
    cdef:
        object driver
        object By
        object WebDriverWait
        object expected_conditions
        str queryselector
        object repeat_until_element_in_columns
        Py_ssize_t max_repeats
        bint with_methods

    def __init__(
        self,
        object driver,
        object By,
        object WebDriverWait,
        object expected_conditions,
        str queryselector="*",
        object repeat_until_element_in_columns=None,
        Py_ssize_t max_repeats=1,
        bint with_methods=True,
    ):
        self.driver = driver
        self.By = By
        self.WebDriverWait = WebDriverWait
        self.expected_conditions = expected_conditions
        self.queryselector = queryselector
        self.repeat_until_element_in_columns=repeat_until_element_in_columns
        self.max_repeats=max_repeats
        self.with_methods=with_methods

    def __call__(self,
        object queryselector=None,
        object with_methods=None,
        object repeat_until_element_in_columns=None,
        object max_repeats=None,
        object driver=None,
        object By=None,
        object WebDriverWait=None,
        object expected_conditions=None,
        ):

        return get_df(
            driver_=driver if driver is not None else self.driver,
            By=By if By is not None else self.By,
            WebDriverWait=WebDriverWait if WebDriverWait is not None else self.WebDriverWait,
            expected_conditions=expected_conditions if expected_conditions is not None else self.expected_conditions,
            queryselector=queryselector if queryselector is not None else self.queryselector,
            repeat_until_element_in_columns=repeat_until_element_in_columns if repeat_until_element_in_columns is not None else self.repeat_until_element_in_columns,
            max_repeats=max_repeats if max_repeats is not None else self.max_repeats,
            with_methods=with_methods if with_methods is not None else self.with_methods,
        )