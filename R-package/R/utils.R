# Finds whether a variable is a number or a numeric string 
isNumeric <- function(x) {
	is.numeric(x) & !is.na(x)
}