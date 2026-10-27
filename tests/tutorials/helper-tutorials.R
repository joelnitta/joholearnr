# Helpers for testing the learnr tutorials in inst/tutorials/ without a browser.
#
# For each exercise chunk, we run the code a student could submit (the starter
# code, or a known-good answer) through gradethis::mock_this_exercise() and the
# tutorial's own `-check` chunk, mirroring what learnr does in the app.

# Read the chunks of an Rmd: label, options, code
read_chunks <- function(rmd) {
  lines <- readLines(rmd, warn = FALSE)
  starts <- grep("^```\\{r", lines)
  chunks <- lapply(starts, function(s) {
    e <- s + which(lines[(s + 1):length(lines)] == "```")[1]
    header <- sub("\\}\\s*$", "", sub("^```\\{r,? *", "", lines[s]))
    label <- trimws(strsplit(header, ",")[[1]][1])
    opts_text <- trimws(sub("^[^,]*,?", "", header))
    opts <- if (nzchar(opts_text)) eval(parse(text = paste0("list(", opts_text, ")"))) else list()
    code <- if (e - s > 1) lines[(s + 1):(e - 1)] else character()
    list(label = label, opts = opts, code = paste(code, collapse = "\n"), line = s)
  })
  names(chunks) <- vapply(chunks, function(x) x$label, character(1))
  chunks
}

# Code of the exercise setup chunk chain (outermost first), as a single string
exercise_setup_code <- function(chunks, label) {
  setup_label <- chunks[[label]]$opts$exercise.setup
  if (is.null(setup_label)) return("")
  paste(
    exercise_setup_code(chunks, setup_label),
    chunks[[setup_label]]$code,
    sep = "\n"
  )
}

# Exercises: chunks with exercise = TRUE
exercise_labels <- function(chunks) {
  names(Filter(function(x) isTRUE(x$opts$exercise), chunks))
}

# A solution chunk may hold several acceptable answers, each under a
# `# description ----` header
split_alternatives <- function(code) {
  if (is.null(code)) return(NULL)
  lines <- strsplit(code, "\n")[[1]]
  group <- cumsum(grepl("^#.*-{4,}\\s*$", lines))
  alts <- vapply(split(lines, group), function(x) {
    trimws(paste(x[!grepl("^#.*-{4,}\\s*$", x)], collapse = "\n"))
  }, character(1))
  unname(alts[nzchar(alts)])
}

# Only comments / whitespace
is_empty_code <- function(code) !nzchar(trimws(gsub("(^|\n)\\s*#[^\n]*", "", code)))

has_blanks <- function(code) grepl("_{2,}", code)

# mock_this_exercise() captures its setup arguments unevaluated, so pass values
# with do.call()
mock_exercise <- function(chunks, label, user_code, solution_code = NULL) {
  setup_exercise <- trimws(exercise_setup_code(chunks, label))
  if (!nzchar(setup_exercise)) setup_exercise <- NULL
  do.call(gradethis::mock_this_exercise, list(
    .user_code = user_code,
    .solution_code = solution_code,
    .label = label,
    setup_global = chunks[["setup"]]$code,
    setup_exercise = setup_exercise
  ))
}

# Build the checker (a function of the check environment) from a `-check` chunk
make_checker <- function(chunk_code, setup_exercise) {
  env <- new.env(parent = globalenv())
  eval(parse(text = setup_exercise), env)
  check_env <- new.env(parent = env)
  checker <- eval(parse(text = chunk_code), check_env)
  stopifnot(is.function(checker))
  checker
}

# Grade `user_code` the way the app would; returns the gradethis_graded object
grade_exercise <- function(chunks, label, user_code, solution_code = NULL) {
  setup_exercise <- exercise_setup_code(chunks, label)
  check_label <- paste0(label, "-check")
  checker <- make_checker(chunks[[check_label]]$code, setup_exercise)
  # gradethis prints parse errors for unfinished starter code; keep output quiet
  graded <- NULL
  utils::capture.output(suppressMessages({
    mock <- mock_exercise(chunks, label, user_code, solution_code)
    graded <- checker(mock)
  }))
  graded
}

# Run code with the exercise's setup, return the result (or the error)
run_exercise <- function(chunks, label, user_code) {
  mock_exercise(chunks, label, user_code)$.result
}
