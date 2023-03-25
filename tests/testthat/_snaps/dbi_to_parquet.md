# Checks simple query generate a parquet file with good messages

    Code
      dbi_to_parquet(dbi_connection = dbi_connection, sql_query = "SELECT * FROM iris",
        path_to_parquet = path_to_parquet, parquetname = parquetname)
    Message <cliMessage>
      Reading data...
      Writing data...
      v The request 'SELECT * FROM iris' from your dbi_connection is available in parquet format under Data_test/dbi-simple
      Writing data...

---

    Code
      dbi_to_parquet(dbi_connection = dbi_connection, sql_query = "SELECT * FROM iris WHERE `Petal.Width` = ?",
        sql_params = list(0.2), path_to_parquet = path_to_parquet, parquetname = parquetname,
        partition = "yes", partitioning = "Species")
    Message <cliMessage>
      Reading data...
      Writing data...
      v The request 'SELECT * FROM iris WHERE `Petal.Width` = ?' from your dbi_connection is available in parquet format under Data_test/dbi-partition-simple
      Writing data...

# Checks simple query generate a chunk parquet files with good messages

    Code
      dbi_to_parquet(dbi_connection = dbi_connection, sql_query = "SELECT * FROM iris WHERE [Petal.Width] = $width",
        sql_params = list(width = c(0.2)), path_to_parquet = path_to_parquet,
        parquetname = parquetname, chunk_memory_size = 2 / 1024)
    Message <cliMessage>
      Reading data...
      v The request 'SELECT * FROM iris WHERE [Petal.Width] = $width' is available in parquet format under Data_test/dbi-partition-chunked/iris1-25.parquet
      Reading data...
      v The request 'SELECT * FROM iris WHERE [Petal.Width] = $width' is available in parquet format under Data_test/dbi-partition-chunked/iris26-29.parquet
      Reading data...

# Checks simple query works by chunk

    Code
      dbi_to_parquet(dbi_connection = dbi_connection, sql_query = "SELECT * FROM iris",
        path_to_parquet = path_to_parquet, chunk_size = 49)
    Message <cliMessage>
      ! Argument 'parquetname' is missing, using 'SELECT_FROM_iris'
      Reading data...
      v The request 'SELECT * FROM iris' is available in parquet format under Data_test/dbi-dataset/SELECT_FROM_iris1-49.parquet
      Reading data...
      v The request 'SELECT * FROM iris' is available in parquet format under Data_test/dbi-dataset/SELECT_FROM_iris50-98.parquet
      Reading data...
      v The request 'SELECT * FROM iris' is available in parquet format under Data_test/dbi-dataset/SELECT_FROM_iris99-147.parquet
      Reading data...
      v The request 'SELECT * FROM iris' is available in parquet format under Data_test/dbi-dataset/SELECT_FROM_iris148-150.parquet
      Reading data...

