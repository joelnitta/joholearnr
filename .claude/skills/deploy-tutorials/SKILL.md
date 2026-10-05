---
name: deploy-tutorials
description: Redeploy one or more learnr tutorials in inst/tutorials/ to shinyapps.io (account joelnitta) with rsconnect. Use when the user asks to deploy, redeploy, publish, or push tutorials/modules to shinyapps.io.
---

# Deploy tutorials to shinyapps.io

Each tutorial lives in `inst/tutorials/<NN-name>/<NN-name>.Rmd` and has an `rsconnect/` folder holding its deployment record, so redeploying updates the existing app at the same URL.

## Steps

1. Work out which tutorials to deploy from the user's request (e.g. "01-intro", "all"). If unclear, ask. Tutorials are `00-learnr`, `01-intro`, `02-vectors`, `03-load`, `04-tidy-1`, `05-tidy-2`, `06-plot-1`, `07-plot-2`.
2. Check the account is authorized:
   ```
   Rscript -e 'print(rsconnect::accounts())'
   ```
   If empty, stop and tell the user to run `rsconnect::setAccountInfo()` with their token from the shinyapps.io dashboard. Don't ask them to paste the secret into chat.
3. Check that the tutorial's `rsconnect/` deployment record exists (`rsconnect/documents/<name>.Rmd/shinyapps.io/joelnitta/<name>.dcf`). If missing, warn the user that this would create a new app with a new URL, and confirm before continuing.
4. Deploy each selected tutorial from the repo root:
   ```
   Rscript -e 'rsconnect::deployDoc("inst/tutorials/<NN-name>/<NN-name>.Rmd", forceUpdate = TRUE)'
   ```
   Always pass `account = "joelnitta", server = "shinyapps.io"` (there are several accounts) and `dependencyResolution = "library"` (the tutorial `renv.lock` files drift out of sync with installed versions, and without this rsconnect errors with "Library and lockfile are out of sync"). If it errors with `subscript out of bounds` or "no package ... was found", the needed packages (learnr, gradethis, learnrhash, joholearnr, etc.) aren't installed locally: install them first (CRAN, plus `rstudio/gradethis`, `rundel/learnrhash`, `joelnitta/joholearnr` from GitHub).
   For "all", loop over every directory in `inst/tutorials/`. Run them sequentially and keep going if one fails.
5. Report per tutorial: success or failure (with the error), and the deployed URL printed by rsconnect.

## Notes

- Use `deployDoc()`, not `deployApp()`; these are `.Rmd` tutorials.
- Do not commit or edit the `rsconnect/*.dcf` files unless the user asks.
- Local packages (e.g. joholearnr, gradethis) must be up to date before deploying, since rsconnect bundles what is installed locally.
- shinyapps.io is planned to migrate to Posit Connect Cloud in 2027; the user will handle that later, so don't suggest migrating.
