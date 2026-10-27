# Run with: Rscript -e 'testthat::test_dir("tests/tutorials")' from the repo root.
# Not part of R CMD check (only tests/testthat is).

library(testthat)

options(device = function(...) grDevices::pdf(NULL))

tutorial_dir <- if (dir.exists("inst/tutorials")) "inst/tutorials" else "../../inst/tutorials"
source("fixtures.R", local = TRUE)

# Example chunks that deliberately show an error message
expected_error <- c("character-error-example")

for (rmd in list.files(tutorial_dir, pattern = "\\.Rmd$", recursive = TRUE, full.names = TRUE)) {
  tutorial <- sub("\\.Rmd$", "", basename(rmd))
  chunks <- read_chunks(rmd)
  withr::with_dir(dirname(rmd), eval(parse(text = chunks[["setup"]]$code), globalenv()))

  for (label in exercise_labels(chunks)) {
    code <- chunks[[label]]$code
    has_check <- paste0(label, "-check") %in% names(chunks)
    solution <- chunks[[paste0(label, "-solution")]]$code
    known <- c(split_alternatives(solution), fixtures[[tutorial]][[label]])

    if (has_check) {
      test_that(paste0(tutorial, " / ", label, ": starter code is graded without crashing"), {
        graded <- withr::with_dir(dirname(rmd), grade_exercise(chunks, label, code, solution))
        expect_s3_class(graded, "gradethis_graded")
        if (has_blanks(code)) expect_false(isTRUE(graded$correct))
      })
      test_that(paste0(tutorial, " / ", label, ": known-good input passes"), {
        skip_if(is.null(known), "no known-good input (add one to tests/tutorials/fixtures.R)")
        for (k in known) {
          graded <- withr::with_dir(dirname(rmd), grade_exercise(chunks, label, k, k))
          expect_true(graded$correct, info = paste(k, "->", graded$message))
        }
      })
    } else if (!has_blanks(code) && !is_empty_code(code) && !label %in% expected_error) {
      test_that(paste0(tutorial, " / ", label, ": example code runs"), {
        result <- withr::with_dir(dirname(rmd), run_exercise(chunks, label, code))
        expect_false(inherits(result, "error"), info = conditionMessage(result))
      })
    }
  }
}
