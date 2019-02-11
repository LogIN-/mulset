
<!-- README.md is generated from README.Rmd. Please edit that file -->

<h1>

<img src="images/intersect_32.png"
  width="32"
  height="32"
  style="float:left;"> \# mulset

</h1>

> Is an R package that allows you to generate specific type of multi-set
> intersections. It searches for multi set intersections between rows
> and corresponding column identifiers.

## Installation

You need to have [R](https://cloud.r-project.org/) preinstalled on your
system. After you have R installed you can install **mulset** directly
from **github** with use of following commands:

``` r
install.packages("devtools")
devtools::install_github("LogIN-/mulset", subdir = 'R-package')
```

## How it works?

This is a basic example which shows you how to solve a common problem.
Demo data used with an example looks like
this:

| outcome | age | gender | Feature 7 | Feature 3 | Feature 4 | Feature 5 |
| ------- | --- | ------ | --------- | --------- | --------- | --------- |
| low     | 77  | male   | NA        | 0         | 28        | 5         |
| high    | 61  | female | 7         | NA        | 28        | 5         |
| low     | 58  | female | 91        | 10        | NA        | 18        |
| high    | 90  | male   | 20        | 0         | 5         | NA        |

The goal is to create **resamples** from this data above

-----

Such data as shown in example above would produce 10 **resamples** in
following
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

## proof of principle:

![Pseudo code graph](images/mulset.png)

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

## Citation

    @article {Tomic545186,
        author = {Tomic, Adriana and Tomic, Ivan and Rosenberg-Hasson, Yael and Dekker, Cornelia L. and Maecker, Holden T. and Davis, Mark M.},
        title = {SIMON, an automated machine learning system reveals immune signatures of influenza vaccine responses},
        elocation-id = {545186},
        year = {2019},
        doi = {10.1101/545186},
        publisher = {Cold Spring Harbor Laboratory},
        abstract = {Machine learning holds considerable promise for understanding complex biological processes such as vaccine responses. Capturing interindividual variability is essential to increase the statistical power necessary for building more accurate predictive models. However, available approaches have difficulty coping with incomplete datasets which is often the case when combining studies. Additionally, there are hundreds of algorithms available and no simple way to find the optimal one. Here, we developed Sequential Iterative Modelling "OverNight" or SIMON, an automated machine learning system that compares results from 128 different algorithms and is particularly suitable for datasets containing many missing values. We applied SIMON to data from five clinical studies of seasonal influenza vaccination. The results reveal previously unrecognized CD4+ and CD8+ T cell subsets strongly associated with a robust antibody response to influenza antigens. These results demonstrate that SIMON can greatly speed up the choice of analysis modalities. Hence, it is a highly useful approach for data-driven hypothesis generation from disparate clinical datasets. Our strategy could be used to gain biological insight from ever-expanding heterogeneous datasets that are publicly available.},
        URL = {https://www.biorxiv.org/content/early/2019/02/10/545186},
        eprint = {https://www.biorxiv.org/content/early/2019/02/10/545186.full.pdf},
        journal = {bioRxiv}
    }
