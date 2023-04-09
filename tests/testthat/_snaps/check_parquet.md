# check_parquet works on good dataset/file

    Code
      check_parquet(parquetize_example("iris_dataset"))
    Message <cliMessage>
      i checking: 
      v loading dataset:   ok
      v number of lines:   150
      v number of columns: 5
    Output
      # A tibble: 5 x 2
        name         type  
        <chr>        <chr> 
      1 Sepal.Length double
      2 Sepal.Width  double
      3 Petal.Length double
      4 Petal.Width  double
      5 Species      utf8  

---

    Code
      check_parquet(parquetize_example("iris.parquet"))
    Message <cliMessage>
      i 
      v loading dataset:   ok
      v number of lines:   150
      v number of columns: 5
    Output
      # A tibble: 5 x 2
        name         type      
        <chr>        <chr>     
      1 Sepal.Length double    
      2 Sepal.Width  double    
      3 Petal.Length double    
      4 Petal.Width  double    
      5 Species      dictionary

