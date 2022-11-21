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

## Installation and load

``` r
# install.packages("remotes")
remotes::install_github("ddotta/parquetize")
```

``` r
library(parquetize)
```

## Content

This package contains only 2 functions:  

- csv_to_parquet
- table_to_parquet

See [this vignette](https://ddotta.github.io/parquetize/articles/aa-conversions.html) for more details.

## About

This package is a simple wrapper of some very useful functions from the "haven", "readr" and "arrow" packages.

Feel welcome to contribute to add features that you find useful in your daily work.
