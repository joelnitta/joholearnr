test_that("processing user-provided text works", {
  # chickens_lines_path <- system.file(
  #   "test-data", "chickens-lines.txt", package = "joholearnr")
  chickens_lines_path <- "/Users/joelnitta/repos/joholearnr/inst/test-data/chickens-lines.txt"
  chickens_code <- readLines(chickens_lines_path)[[1]]
  expect_equal(
    last_user_code_call(chickens_code), "chickens"
  )
})
