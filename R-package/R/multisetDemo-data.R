#' Demo data set from mulset package.
#' This data is used in this package examples. It consist of 4x4 feature matrix + additional dummy columns that can be used for testing.
#' 
#' @docType data
#'
#' @usage data(mulsetDemo)
#'
#' @keywords datasets
#'
#' @examples
#' data(mulsetDemo)
#' print(head(mulsetDemo))
#' resamples <- mulset(mulsetDemo, exclude = c("outcome", "age", "gender"))
#' 
"mulsetDemo"
