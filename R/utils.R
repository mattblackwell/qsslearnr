#' Checks if a function is called optionally with certains args
#'
#' Checks if a function is called in code
#'
#' @param code quosure list of input code
#' @param fn name of function to search for
#' @param index which instance of the call to the function should we
#' look for the args
#' @param has_args character vector of args to check that are called
#' in the function call
#' @param arg_values named list of character vectors of the exact arguments
#' values some arguments should take
#'
#' @return logical, `TRUE` if all conditions are met, `FALSE` otherwise
#' @export
function_called <- function(code, fn, index = 1, has_args = NULL, arg_values = NULL) {
  parsed_code <- parse(text = code)
  calls <- lapply(parsed_code, rlang::call_standardise)
  call_names <- lapply(calls, rlang::call_name)
  found <- fn %in% call_names
  if (found & !is.null(has_args)) {
    this_call <- calls[which(call_names == fn)[index]]
    these_args <- rlang::call_args(this_call[[1]])
    arg_names <- names(these_args)
    found <- found & all(has_args %in% arg_names)
    if (found & !is.null(arg_values)) {
      arg_text <- lapply(these_args, rlang::expr_text)
      found <- found & all(names(arg_values) %in% arg_names)
      if (found) {
        found <- found & identical(arg_values, arg_text[names(arg_values)])
      }
    }
  }
  return(found)
}
