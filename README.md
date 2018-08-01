
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mulset

Is an R package that allows you to generate specific type of multi-set
intersections. It searches for multi set intersections between rows and
corresponding column identifiers.

## Installation

You need to have [R](https://cloud.r-project.org/) preinstalled on your
system. After you have R installed you can install **mulset** directly
from **github** with use of following commands:

``` r
install.packages("devtools")
devtools::install_github("LogIN-/mulset")
```

## How it works?

This is a basic example which shows you how to solve a common problem:
Demo data used with an example looks like
this:

| outcome | age | gender | Feature 7 | Feature 3 | Feature 4 | Feature 5 |
| ------- | --- | ------ | --------- | --------- | --------- | --------- |
| low     | 77  | male   | NA        | 0         | 28        | 5         |
| high    | 61  | female | 7         | NA        | 28        | 5         |
| low     | 58  | female | 91        | 10        | NA        | 18        |
| high    | 90  | male   | 20        | 0         | 5         | NA        |

The goal is to create **resamples** from this data above. Such data as
shown in example above would produce 10 **resamples** in following
way:

| feature\_count | features                        | samples | samples\_count | datapoints |
| :------------- | :------------------------------ | :------ | :------------- | :--------- |
| 3              | Feature 3, Feature 4, Feature 5 | 1       | 1              | 3          |
| 3              | Feature 4, Feature 5, Feature 7 | 2       | 1              | 3          |
| 2              | Feature 4, Feature 5            | 1,2     | 2              | 4          |
| 2              | Feature 5, Feature 7            | 2,3     | 2              | 4          |
| 2              | Feature 3, Feature 5            | 1,3     | 2              | 4          |
| 3              | Feature 3, Feature 5, Feature 7 | 3       | 1              | 3          |
| 2              | Feature 4, Feature 7            | 2,4     | 2              | 4          |
| 2              | Feature 3, Feature 4            | 1,4     | 2              | 4          |
| 2              | Feature 3, Feature 7            | 3,4     | 2              | 4          |
| 3              | Feature 3, Feature 4, Feature 7 | 4       | 1              | 3          |

<p align="center">

![Pseudo graph](mulset.png)

</p>

## Usage Example

``` r
library("mulset")
## Using provided demo data
data(mulsetDemo)
resamples <- mulset(mulsetDemo, exclude = c("outcome", "age", "gender"), 250)

## or from CSV file
## mulsetDemo <-fread("./data/mulsetDemo.csv", header = T, sep = ',', stringsAsFactors = FALSE, data.table = FALSE)
## exclude <- c("come_column")
## resamples <- mulset(mulsetDemo, exclude = exclude, include = c("samples_count", "datapoints"), maxIntersections = 250, hashMethod = "sha1")
```

## Support and Bugs

If you are having trouble, have found a bug, or want to contribute don’t
be shy. [Open a ticket](https://github.com/LogIN-/mulset/issues) on
GitHub.

## License

**mulset** source-code uses the EUROPEAN UNION PUBLIC LICENCE, see our
**LICENSE** file.