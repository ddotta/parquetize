# Checks arguments are filled in

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), encoding = "utf-8")
    Message <cliMessage>
      x Be careful, the argument path_to_parquet must be filled in
    Error <simpleError>
      argument "path_to_parquet" is missing, with no default

---

    Code
      table_to_parquet(path_to_parquet = "Data_test", encoding = "utf-8")
    Message <cliMessage>
      x Be careful, the argument path_to_table must be filled in
    Error <simpleError>
      argument "path_to_table" is missing, with no default

---

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), path_to_parquet = "Data_test", encoding = "utf-8",
      by_chunk = TRUE)
    Message <cliMessage>
      x Be careful, if you want to do a conversion by chunk then the argument chunk_size must be filled in
    Error <simpleError>
      argument "chunk_size" is missing, with no default

---

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), path_to_parquet = "Data_test", encoding = "utf-8",
      by_chunk = TRUE, chunk_size = 50, skip = -100)
    Message <cliMessage>
      x Be careful, if you want to do a conversion by chunk then the argument skip must be must be greater than 0
    Error <simpleError>
      

# Checks argument columns is a character vector

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), path_to_parquet = "Data_test", columns = matrix(1:10))
    Message <cliMessage>
      x Be careful, the argument columns must be a character vector
      Reading data...
    Warning <lifecycle_warning_deprecated>
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(columns)
      
        # Now:
        data %>% select(all_of(columns))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
    Error <vctrs_error_subscript_type>
      Can't subset columns with `columns`.
      x Subscript `columns` must be a simple vector, not a matrix.

# Checks message is displayed when we select a few columns

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), path_to_parquet = "Data_test", columns = all_of(c(
        "Species", "Petal_Length")))
    Warning <lifecycle_warning_deprecated>
      Using `all_of()` outside of a selecting function was deprecated in tidyselect 1.2.0.
      i See details at <https://tidyselect.r-lib.org/reference/faq-selection-context.html>
    Message <cliMessage>
      Reading data...
    Warning <lifecycle_warning_deprecated>
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(columns)
      
        # Now:
        data %>% select(all_of(columns))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
    Message <cliMessage>
      Writing data...
      v The SAS file is available in parquet format under Data_test
      Writing data...

---

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sav", package = "haven"),
      path_to_parquet = "Data_test", columns = all_of(c("Species", "Petal.Length")))
    Warning <lifecycle_warning_deprecated>
      Using `all_of()` outside of a selecting function was deprecated in tidyselect 1.2.0.
      i See details at <https://tidyselect.r-lib.org/reference/faq-selection-context.html>
    Message <cliMessage>
      Reading data...
    Warning <lifecycle_warning_deprecated>
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(columns)
      
        # Now:
        data %>% select(all_of(columns))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
    Message <cliMessage>
      Writing data...
      v The SPSS file is available in parquet format under Data_test
      Writing data...

---

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.dta", package = "haven"),
      path_to_parquet = "Data_test", columns = all_of(c("species", "petallength")))
    Warning <lifecycle_warning_deprecated>
      Using `all_of()` outside of a selecting function was deprecated in tidyselect 1.2.0.
      i See details at <https://tidyselect.r-lib.org/reference/faq-selection-context.html>
    Message <cliMessage>
      Reading data...
    Warning <lifecycle_warning_deprecated>
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(columns)
      
        # Now:
        data %>% select(all_of(columns))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
    Message <cliMessage>
      Writing data...
      v The Stata file is available in parquet format under Data_test
      Writing data...

# Checks message is displayed with by adding chunk_size to TRUE and encoding argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), path_to_parquet = "Data_test", by_chunk = TRUE,
      chunk_size = 50, encoding = "utf-8")
    Message <cliMessage>
      v The SAS file is available in parquet format under Data_test/iris1-50.parquet
      v The SAS file is available in parquet format under Data_test/iris51-100.parquet
      v The SAS file is available in parquet format under Data_test/iris101-150.parquet

# Checks message is displayed with by adding partition and partitioning argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), path_to_parquet = "Data_test", partition = "yes",
      partitioning = "Species")
    Message <cliMessage>
      Reading data...
      Writing data...
      v The SAS file is available in parquet format under Data_test
      Writing data...

# Checks message is displayed with SAS by adding chunk_size, partition and partitioning argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), path_to_parquet = "Data_test", by_chunk = TRUE,
      chunk_size = 50, partition = "yes", partitioning = "Species")
    Message <cliMessage>
      v The SAS file is available in parquet format under Data_test/iris1-50.parquet
      v The SAS file is available in parquet format under Data_test/iris51-100.parquet
      v The SAS file is available in parquet format under Data_test/iris101-150.parquet

# Checks message is displayed with SAS by adding chunk_size argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), path_to_parquet = "Data_test", by_chunk = TRUE,
      chunk_size = 50)
    Message <cliMessage>
      v The SAS file is available in parquet format under Data_test/iris1-50.parquet
      v The SAS file is available in parquet format under Data_test/iris51-100.parquet
      v The SAS file is available in parquet format under Data_test/iris101-150.parquet

# Checks message is displayed with SPSS by adding nb_rows, partition and partitioning argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sav", package = "haven"),
      path_to_parquet = "Data_test", partition = "yes", partitioning = "Species")
    Message <cliMessage>
      Reading data...
      Writing data...
      v The SPSS file is available in parquet format under Data_test
      Writing data...

# Checks message is displayed with Stata file and only path_to_table and path_to_parquet argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.dta", package = "haven"),
      path_to_parquet = "Data_test")
    Message <cliMessage>
      Reading data...
      Writing data...
      v The Stata file is available in parquet format under Data_test
      Writing data...

# Checks message is displayed with Stata by adding partition and partitioning argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.dta", package = "haven"),
      path_to_parquet = "Data_test", partition = "yes", partitioning = "species")
    Message <cliMessage>
      Reading data...
      Writing data...
      v The Stata file is available in parquet format under Data_test
      Writing data...

