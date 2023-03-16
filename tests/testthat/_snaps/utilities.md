# tests get_read_function_by_extension fails when needed

    Code
      get_read_function_for_file("/some/bad/file/without_extension")
    Message <cliMessage>
      x Be careful, unable to find a read method for "/some/bad/file/without_extension", it has no extension
    Error <simpleError>
      

---

    Code
      get_read_function_for_file("/some/bad/file/with_bad_extension")
    Message <cliMessage>
      x Be careful, unable to find a read method for "/some/bad/file/with_bad_extension", it has no extension
    Error <simpleError>
      

