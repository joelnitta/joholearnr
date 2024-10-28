#' Get last call in user code, excluding comments
#'
#' @param .user_code User-provided code in a learnr tutorial
#' @return The last string provided by the user in their code
#' @export
last_user_code_call <- function(.user_code) {
  # Convert single string into code lines
  code_lines <- unlist(.user_code) |>
    paste(collapse = " ") |>
    strsplit("\\n|\\\\n")
  code_lines <- code_lines[[1]]
  # Get last code line
  last_code_string <- code_lines[length(code_lines)]
  # Remove trailing comments
  last_code_string <- gsub(" *#.*$", "", last_code_string)
  # Remove any extra whitespace
  trimws(gsub("\\s+", " ", last_code_string))
}
