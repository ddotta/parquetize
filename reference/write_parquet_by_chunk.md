# read input by chunk on function and create dataset 

Low level function that implements the logic to to read input file by
chunk and write a dataset.  

It will:

- calculate the number of row by chunk if needed;

- loop over the input file by chunk;

- write each output files.

## Usage

``` r
write_parquet_by_chunk(
  read_method,
  input,
  path_to_parquet,
  max_rows = NULL,
  max_memory = NULL,
  chunk_memory_sample_lines = 10000,
  compression = "snappy",
  compression_level = NULL,
  ...
)
```

## Arguments

- read_method:

  a method to read input files. This method take only three arguments

  `input` : some kind of data. Can be a `skip` : the number of row to
  skip `n_max` : the number of row to return

  This method will be called until it returns a dataframe/tibble with
  zero row.

- input:

  that indicates the path to the input. It can be anything you want but
  more often a file's path or a data.frame.

- path_to_parquet:

  String that indicates the path to the directory where the output
  parquet file or dataset will be stored.

- max_rows:

  Number of lines that defines the size of the chunk. This argument can
  not be filled in if max_memory is used.

- max_memory:

  Memory size (in Mb) in which data of one parquet file should roughly
  fit.

- chunk_memory_sample_lines:

  Number of lines to read to evaluate max_memory. Default to 10 000.

- compression:

  compression algorithm. Default "snappy".

- compression_level:

  compression level. Meaning depends on compression algorithm.

- ...:

  Additional format-specific arguments, see
  [arrow::write_parquet()](https://arrow.apache.org/docs/r/reference/write_parquet.html)

## Value

a dataset as return by arrow::open_dataset

## Examples

``` r
# example with a dataframe

# we create the function to loop over the data.frame

read_method <- function(input, skip = 0L, n_max = Inf) {
  # if we are after the end of the input we return an empty data.frame
  if (skip+1 > nrow(input)) { return(data.frame()) }

  # return the n_max row from skip + 1
  input[(skip+1):(min(skip+n_max, nrow(input))),]
}

# we use it

write_parquet_by_chunk(
  read_method = read_method,
  input = mtcars,
  path_to_parquet = tempfile(),
  max_rows = 10,
)
#> Reading data...
#> Writing file195128673913-1-10.parquet...
#> Reading data...
#> Writing file195128673913-11-20.parquet...
#> Reading data...
#> Writing file195128673913-21-30.parquet...
#> Reading data...
#> Writing file195128673913-31-32.parquet...
#> ✔ Data are available in parquet dataset under /tmp/Rtmp5JozyA/file195128673913/
#> Writing file195128673913-31-32.parquet...


#
# Example with haven::read_sas
#

# we need to pass two argument beside the 3 input, skip and n_max.
# We will use a closure :

my_read_closure <- function(encoding, columns) {
  function(input, skip = OL, n_max = Inf) {
    haven::read_sas(data_file = input,
                    n_max = n_max,
                    skip = skip,
                    encoding = encoding,
                    col_select = all_of(columns))
  }
}

# we initialize the closure

read_method <- my_read_closure(encoding = "WINDOWS-1252", columns = c("Species", "Petal_Width"))

# we use it
write_parquet_by_chunk(
  read_method = read_method,
  input = system.file("examples","iris.sas7bdat", package = "haven"),
  path_to_parquet = tempfile(),
  max_rows = 75,
)
#> Reading data...
#> Writing file1951abf66f4-1-75.parquet...
#> Reading data...
#> Writing file1951abf66f4-76-150.parquet...
#> Reading data...
#> ✔ Data are available in parquet dataset under /tmp/Rtmp5JozyA/file1951abf66f4/
#> Reading data...
```
