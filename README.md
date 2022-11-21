<!-- badges: start -->
![GitHub top
language](https://img.shields.io/github/languages/top/ddotta/parquetize)
[![R check
status](https://github.com/ddotta/parquetize/workflows/R-CMD-check/badge.svg)](https://github.com/ddotta/fmtsas/actions/workflows/check-release.yaml)
[![codecov](https://codecov.io/gh/ddotta/parquetize/branch/main/graph/badge.svg?token=25MHI8O62M)](https://codecov.io/gh/ddotta/parquetize)
<!-- badges: end -->

:package: Package `parquetize` <img src="man/figures/hex_parquetize.png" width=110 align="right"/>
======================================

R package that allows to convert databases of different formats (csv, SAS, SPSS and Stata) to [parquet](https://parquet.apache.org/) format in a same function.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("ddotta/parquetize")
```

``` r
library(parquetize)
```

## Why this package ?

While working, I realized that I was often repeating the same operation when working with parquet files : 

- I import the file in R with "haven" or "readr".
- And I export the file in parquet format

As a fervent of the DRY principle (don't repeat yourself) the 2 main functions of this package make my life easier and execute these operations within the same function :

- `csv_to_parquet()`
- `table_to_parquet()`

See [this vignette](https://ddotta.github.io/parquetize/articles/aa-conversions.html) for more details.

## About and contribution

This package is a simple wrapper of some very useful functions from the `haven`, `readr` and `arrow` packages.

Feel welcome to contribute to add features that you find useful in your daily work.
