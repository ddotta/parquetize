#' @keywords internal
#' @importFrom DBI dbClearResult dbConnect dbDisconnect dbFetch dbHasCompleted dbListTables dbReadTable dbSendQuery
#' @importFrom RSQLite SQLite
#' @importFrom arrow open_dataset read_json_arrow read_parquet write_dataset write_parquet
#' @importFrom cli cli_abort cli_alert_danger cli_alert_info cli_alert_success cli_alert_warning cli_progress_bar cli_progress_message
#' @importFrom curl curl_download
#' @importFrom fst read.fst
#' @importFrom glue glue glue_sql
#' @importFrom haven read_dta read_sas read_sav
#' @importFrom jsonlite read_json
#' @importFrom lifecycle deprecate_warn deprecated
#' @importFrom readr locale read_delim
#' @importFrom tidyselect all_of everything
#' @importFrom tools file_ext file_path_sans_ext
#' @importFrom utils object.size unzip
#' @importFrom rlang inject
#' @import dplyr
"_PACKAGE"
