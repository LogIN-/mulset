install.packages('Rcpp', repos='http://cran.us.r-project.org')

devtools::install_github("klutometis/roxygen")
library(roxygen2)
library(knitr)
library(Rcpp)

setwd("/mnt/projects/mulset/R-package/")


devtools::load_all()
devtools::document()
devtools::build()
devtools::check()

# usethis::use_data_raw()
# devtools::use_readme_rmd()



roxygen2::roxygenise()

devtools::release()
rmarkdown::render("README.Rmd")
devtools::install()


library("mulset")
data(mulsetDemo, package = "mulset") 
print(head(mulsetDemo))
resamples <- mulset(mulsetDemo, exclude = c("outcome", "age", "gender"), maxIntersections = 250)