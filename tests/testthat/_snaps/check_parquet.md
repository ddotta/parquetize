# check_parquet works on good dataset/file

    Code
      check_parquet(parquetize_example("iris_dataset"))
    Message <cliMessage>
      i checking: 
      v loading dataset:   ok
      v number of lines:   150
      v number of columns: 5
    Output
      # A tibble: 5 x 3
        name         type   nullable
        <chr>        <chr>  <lgl>   
      1 Sepal.Length double TRUE    
      2 Sepal.Width  double TRUE    
      3 Petal.Length double TRUE    
      4 Petal.Width  double TRUE    
      5 Species      utf8   TRUE    

---

    Code
      check_parquet(parquetize_example("iris.parquet"))
    Message <cliMessage>
      i 
      v loading dataset:   ok
      v number of lines:   150
      v number of columns: 5
    Output
      # A tibble: 5 x 3
        name         type       nullable
        <chr>        <chr>      <lgl>   
      1 Sepal.Length double     TRUE    
      2 Sepal.Width  double     TRUE    
      3 Petal.Length double     TRUE    
      4 Petal.Width  double     TRUE    
      5 Species      dictionary TRUE    

