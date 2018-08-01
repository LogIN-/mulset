#' A list_intersect function
#'
#' `list_intersect()` returns all intersections it found.
#'
# Computes the intersection of vector values
# list_intersect() returns an vector containing all the values of vect1 that are present in all other the arguments. Please note value positions are NOT preserved.
#' 
#' @param vect1 Vector of string to make comparison by.
#' @param vect2  Vector of string to make comparison against.
#' @keywords intersect
#' @return Character vector of all common attributes
#' @examples
#' numb1 <- seq(50, 100, by=10)
#' numb2 <- seq(70, 130, by=10)
#' list_intersect(numb1, numb2)
list_intersect <- function(...){
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

# Finds whether a variable is a number or a numeric string 
isNumeric <- function(x) {
	is.numeric(x) & !is.na(x)
}