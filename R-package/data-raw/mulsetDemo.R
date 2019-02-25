library(data.table)

mulsetDemo <- fread("./data-raw/mulsetDemo.csv", header = T, sep = ',', stringsAsFactors = FALSE, data.table = FALSE)
usethis::use_data(mulsetDemo, overwrite = TRUE)