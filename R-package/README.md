mulset
================
Ivan Tomic <info@ivantomic.com>

<!-- README.md is generated from README.Rmd. Please edit that file -->

The goal of mulset is to generate specific type of multi-set
intersections. It searches for multi set intersections between rows and
corresponding column identifiers.

## Installation

You can install the released version of mulset from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("mulset")
```

Or you can install **mulset** directly from **github** with use of
following commands:

``` r
install.packages("devtools")
devtools::install_github("LogIN-/mulset", subdir = 'R-package')
```

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
