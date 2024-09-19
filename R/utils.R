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

#' Snapshot all tutorial files
#'
#' Create an renv.lock file for each tutorial
#'
#' @param dir Directory containing the tutorials. Each should be in its own
#' subdirectory; see `system.file("tutorials", package = "joholearnr")`
#' @return Nothing. Externally, the renv files will be written to disk.
#' @examples
#' if (interactive()) {
#'   tutorials_folder <- system.file("tutorials", package = "joholearnr")
#'   temp_tutorials_folder <- fs::path(tempdir(), "tutorials")
#'   fs::dir_copy(tutorials_folder, temp_tutorials_folder, overwrite = TRUE)
#'   snapshot_tutorials(temp_tutorials_folder)
#'   fs::dir_delete(temp_tutorials_folder)
#' }
#' @export
snapshot_tutorials <- function(dir = "./tutorials") {
  tutorial_dirs <- fs::dir_ls(dir)
  lapply(
    tutorial_dirs,
    function(x) withr::with_dir(x, renv::snapshot())
  )
  invisible()
}