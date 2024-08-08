#!/usr/bin/env Rscript

stopifnot(packageVersion("pkgdown") >= "2.0.6")

library(pkgdown)

stopifnot(grepl("^shiny-dev-center", basename(getwd())))

message("Copying ./shiny_sym to temp directory")
shiny_copy <- local({
  tmpd <- tempdir()
  if (!dir.exists("shiny_sym")) {
    stop(
      "Please symlink `./shiny_sym` to the `{shiny}` folder",
      "`ln -s PATH_TO_SHINY shiny_sym`"
    )
  }
  if (dir.exists(file.path(tmpd, "shiny_sym"))) {
    message("Deleting old temp directory")
    unlink(file.path(tmpd, "shiny_sym"), recursive = TRUE)
  }
  file.copy("./shiny_sym", tmpd, recursive = TRUE)
  file.path(tmpd, "shiny_sym")
})

file.copy("_pkgdown_templates", shiny_copy, recursive = TRUE)
file.copy(
  file.path(shiny_copy, "tools", "documentation", "pkgdown.yml"),
  file.path(shiny_copy, "_pkgdown.yml")
)

local({

  alias_info <- jsonlite::fromJSON(file.path(shiny_copy, "tools", "documentation", "reexports.json"), simplifyDataFrame = FALSE)
  shiny_man_folder <- file.path(shiny_copy, "man")

  lapply(alias_info, function(alias_pkg_info) {
    # requires a GITHUB_PAT token
    latest_tag_name <- gh::gh(paste0("GET /repos/", alias_pkg_info$repo, "/tags"))[[1]]$name
    github_man_location <- paste0("https://raw.githubusercontent.com/", alias_pkg_info$repo, "/", latest_tag_name, "/man/")

    files_to_copy <- vapply(alias_pkg_info$exports, `[[`, character(1), "file")

    # download all latest htmltools tag man files
    lapply(files_to_copy, function(man_file) {
      save_location <- file.path(shiny_man_folder, man_file)
      if (file.exists(save_location)) {
        stop("File '", save_location, "' already exists!")
      }
      writeLines(
        # read from GitHub
        readLines(paste0(github_man_location, man_file)),
        # save to disk
        save_location
      )
      cat("Adding: ", alias_pkg_info$name, " ", man_file, "\n", sep = "")
    })
  })

  reexports_man_file <- file.path(shiny_man_folder, "reexports.Rd")
  cat("Deleting: shiny reexports.Rd\n", sep = "")
  unlink(reexports_man_file)

  # build the site
  message("Building site")
  pkgdown::build_site(
    pkg = shiny_copy,
    # TODO Figure out why build hangs with examples = TRUE
    examples = FALSE,
    seed = 1337,
    preview = FALSE
  )

  message("Removing unwanted html formatting")
  ref_path <- file.path(shiny_copy, "docs", "reference")
  ref_files <- list.files(ref_path)
  tag_version <- packageVersion(basename(shiny_copy), dirname(shiny_copy))
  lapply(file.path(ref_path, ref_files), function(ref_file) {
    if (dir.exists(ref_file)) return()
    content <- readLines(ref_file)
    # Remove first two lines of `DOCTYPE` and `html`, `head`, and `body` tags
    content <- content[-(1:2)]
    # Remove closing tags
    content <- content[content != "</body></html>"]
    # Trim multiple white spaces
    while (all(tail(content, 2) == c("", ""))) {
      content <- content[-length(content)]
    }

    # Update source links to tagged location
    content <- gsub(
      "github.com/rstudio/shiny/blob/HEAD/",
      paste0("github.com/rstudio/shiny/blob/v", tag_version, "/"),
      content
    )

    # Write file
    cat(paste0(content, collapse = "\n"), file = ref_file)
  })
})


latest_dir <- file.path(shiny_copy, "docs", "latest")
file.rename(
  file.path(shiny_copy, "docs", "reference"),
  latest_dir
)
file.copy(
  latest_dir,
  file.path("reference", "shiny"),
  recursive = TRUE
)
