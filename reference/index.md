# Package index

## Functions

The conversion functions available in this package

- [`csv_to_parquet()`](csv_to_parquet.md) : Convert a csv or a txt file
  to parquet format
- [`json_to_parquet()`](json_to_parquet.md) : Convert a json file to
  parquet format
- [`rds_to_parquet()`](rds_to_parquet.md) : Convert a rds file to
  parquet format
- [`fst_to_parquet()`](fst_to_parquet.md) : Convert a fst file to
  parquet format
- [`table_to_parquet()`](table_to_parquet.md) : Convert an input file to
  parquet format
- [`sqlite_to_parquet()`](sqlite_to_parquet.md) : Convert a sqlite file
  to parquet format
- [`dbi_to_parquet()`](dbi_to_parquet.md) : Convert a SQL Query on a DBI
  connection to parquet format

## Other functions

- [`get_parquet_info()`](get_parquet_info.md) : Get various info on
  parquet files
- [`get_partitions()`](get_partitions.md) : get unique values from
  table's column
- [`check_parquet()`](check_parquet.md) : Check if parquet file or
  dataset is readable and return basic informations
- [`download_extract()`](download_extract.md) : download and uncompress
  file if needed
- [`rbind_parquet()`](rbind_parquet.md) : Function to bind multiple
  parquet files by row
- [`parquetize_example()`](parquetize_example.md) : Get path to
  parquetize example

## Developers

- [`write_parquet_by_chunk()`](write_parquet_by_chunk.md) :

  read input by chunk on function and create dataset  

- [`write_parquet_at_once()`](write_parquet_at_once.md) :

  write parquet file or dataset based on partition argument  
