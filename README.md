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
remotes::install_github("ddotta/parquetize")
```

``` r
library(parquetize)
```

## Why this package ?

This package is a simple wrapper of some very useful functions from the [haven](https://github.com/tidyverse/haven), [readr](https://github.com/tidyverse/readr/) and [arrow](https://github.com/apache/arrow) packages.

While working, I realized that I was often repeating the same operation when working with parquet files : 

- I import the file in R with "haven" or "readr".
- And I export the file in parquet format

As a fervent of the DRY principle (don't repeat yourself) the 2 exported functions of this package make my life easier and **execute these operations within the same function** :

- [csv_to_parquet()](https://ddotta.github.io/parquetize/reference/csv_to_parquet.html)
    - **The other benefit of this function** is that it allows you to convert csv files whether they are stored locally or available on the internet directly to csv format or inside a zip.
- [table_to_parquet()](https://ddotta.github.io/parquetize/reference/table_to_parquet.html)
    - **The other benefit of this function**is that it handles SAS, SPSS and Stata files in a same function. There is only one function to use for these 3 cases.  
    
**The last benefit** of using package `{parquetize}` is that its functions allow to create single parquet files or partitioned files depending on the arguments chosen in the functions.

For more details, see the documentation and examples :  
- [csv_to_parquet()](https://ddotta.github.io/parquetize/reference/csv_to_parquet.html#ref-examples).  
- [table_to_parquet()](https://ddotta.github.io/parquetize/reference/table_to_parquet.html#ref-examples).

## Contribution

Feel welcome to contribute to add features that you find useful in your daily work. Ideas are welcomed in [the issues](https://github.com/ddotta/parquetize/issues).
