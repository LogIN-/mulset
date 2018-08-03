#' A intersection function
#'
#' `intersection()` returns all intersections it found.
#'
# Computes the intersection of vector values
# intersection() returns an vector containing all the values of input1 that are present in all other the arguments A ∩ B.
#' 
#' @param ... Vector with master values to check and vector to compare values against
#' @keywords intersect, intersection
#' @return Character vector of all common attributes
#' @examples
#' input1 <- seq(50, 100, by=10)
#' input2 <- seq(70, 130, by=10)
#' intersection(input1, input2)
#' @export intersection
intersection <- function(...){
	## Retrieve arguments as a list
    args <- list(...)
    l <- length(args)
    ## Get the first argument
    list1 <- args[1][[1]]

    ## Remove first one
    args <- args[-1];
    output <- c()
    c <- 1
    for (val_pos in 1:length(list1)) {
        val <- list1[val_pos]
        for (i in seq_along(args)) {
            value <- args[i][[1]]
            for (val_s in value) {
                if (val_s == val) {
                    if (i == l-1) {
                        output <- c(output, val_s)
                        c = c +1
                    }
                    break
                }
            }
            next
        }
    }
    return(output)
}

#' input1 <- seq(50, 100, by=10)
#' input2 <- seq(70, 130, by=10)
#' intersection(input1, input2)