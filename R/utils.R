#' List all tutorials
#'
#' Lists all tutorials (Rmd files) in joholearnr
#'
#' @return Character vector
#' @examples
#' list_tutorials()
#' @export
list_tutorials <- function() {
  tutorials_dir <- system.file(
    "tutorials",
    package = "joholearnr")
  fs::dir_ls(
    path = tutorials_dir,
    regexp = "*.Rmd",
    recurse = TRUE) |>
    fs::path_file() |>
    sort()
}

#' Write out a tutorial file
#'
#' Write out a tutorial (Rmd) file to disk
#'
#' @param tutorial Name of the tutorial file. The .Rmd extension may be omitted.
#' @param dir Directory to write the file.
#' @return Nothing. Externally, the file will be written to disk.
#' @examples
#' write_tutorial("00-learnr", tempdir())
#' list.files(tempdir())
#' @export
write_tutorial <- function(tutorial, dir = ".") {
  file_name <-
    fs::path_ext_remove(tutorial) |>
    fs::path_ext_set("Rmd")
  assertthat::assert_that(
    file_name %in% list_tutorials(),
    msg = "Selected tutorial not detected. See list_tutorials()."
  )
  dest <- fs::path(dir, file_name)
  joholearnr_rmd <- system.file(
    "tutorials",
    tutorial,
    file_name,
    package = "joholearnr")
  fs::file_copy(
    path = joholearnr_rmd, new_path = dest, overwrite = TRUE)
  invisible()
}

#' Write out all tutorial files
#'
#' Write out all tutorial files (Rmd) file to disk
#'
#' @param dir Directory to write the files.
#' @param delete_html Logical; should HTML files in the tutorials directory
#'   be deleted after copying?
#' @return Nothing. Externally, the file will be written to disk. (Subfolders
#' may be used)
#' @examples
#' target_dir <- fs::path(tempdir(), "tutorials")
#' write_all_tutorials(target_dir)
#' fs::dir_ls(target_dir)
#' fs::dir_delete(target_dir)
#' @export
write_all_tutorials <- function(dir = ".", delete_html = TRUE) {
  tutorial_dir <- joholearnr_rmd <- system.file(
    "tutorials",
    package = "joholearnr")
  fs::dir_copy(path = tutorial_dir, new_path = dir, overwrite = TRUE)
  if (delete_html) {
    html_files <- fs::dir_ls(
      dir,
      recurse = TRUE,
      regexp = "*.html"
    )
    fs::file_delete(html_files)
  }
  invisible()
}