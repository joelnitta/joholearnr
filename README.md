## joholearnr

This is an R package with [learnr](https://rstudio.github.io/learnr/) tutorials for the 情報処理演習 class at Chiba University.

### Running tutorials locally

Use `rmarkdown::run()`.

For example:

```
library(rmarkdown)
run("inst/tutorials/00-learnr/00-learnr.Rmd")
```

### Deploying tutorials

Open the .Rmd file in RStudio, then click "File -> Publish". The first time you do this, you will need to log in to your shinyapps.io account and set up login credentials.

Developer note: Use `joholeanr::snapshot_tutorials()` as necessary to update the `renv.lock` file in each tutorial.

### Rmarkdown format

In addition to the `-check` and `-solution` code chunk labels of `gradethis`, add `-example` to the label of any exercise code chunk that should not be graded, nor appear in the summary of question statuses provided before submission.