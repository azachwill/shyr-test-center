# Scripts to generate R reference

When trying to recreate documentation, it is best to call the scripts in this order:

1. `migrate_api_docs.R`
   * Alters `.html` files from `_legacy/r-shiny-reference` to `r/reference/shiny` and changes the file extension to `.qmdfragment`
2. `generate_docs.R`
   * Calling `main()` will ask the user to select a version of Shiny to generate documentation for. It will then generate the `.qmdfragment` files in `r/reference/shiny` and the `.qmd` files in `docs/reference/shiny` for the versions selected.
   * This will automatically cally `generate_api_docs_from_template.R` to generate the `.html` files in `_build/r/reference/shiny`
3. `generate_api_docs_from_template.R`
   * This script is used to generate the `_build/r/reference/shiny` `.html` files using the `.qmdfragment` files in `r/reference/shiny`
