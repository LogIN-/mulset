#' Demo data from mulset package.
#' Used in examples, regarding missing value columns.
#' 
#' @docType data
#'
#' @usage data(mulsetDemo)
#'
#' @keywords datasets
#'
#' @examples
#' data(mulsetDemo)
#' resamples <- mulset(mulsetDemo, exclude = c("outcome", "age", "gender"), 250)
#' 
"mulsetDemo"
