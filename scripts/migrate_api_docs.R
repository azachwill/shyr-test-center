#!/usr/bin/env Rscript

# This script does the following:
#
# * Copies files from "_legacy/r-shiny-reference" to "r/reference/shiny"
# * For .html files:
#   * Renames .html files to .qmdfragment
#   * In YAML header, remove unneeded entries: `layout`, `categories`
#   * Adds ```{=html} in body, as well as trailing ```
#   * Removes first <h1> tag
# * For .md files:
#   * Renames .md to .qmd
#   * In YAML header, remove unneeded entries: `layout`, `categories`
#   * For the index.md file at the top level, this also changes the links from
#     "/reference/shiny/0.14.1/upgrade.html" to "0.14.1/upgrade.html"
# * For subdirectories, like `css` or `figures`:
#   * Recursively copies the directory.
# * Creates a file "r/reference/shiny/template/template.qmd" that contains a template.
#   Each .qmdfragment file will use this template to generate a .html file. The
#   reason that this system is necessary is because Quarto is slow to render the
#   ~5000 files in the reference directory.
#
# A separate script, `/_scripts/generate_api_docs_from_template.R` is used to
# generate the .html files from the .qmdtemplate files. It must be run after
# Quarto is used to build the template.qmd file.



if (!dir.exists("_legacy/r-shiny-reference/")) {
  stop(
    "This script must be run from the top level of the repository, as in\n",
    "  _old_site/scripts/migrate_api_docs.R"
  )
}


# Fast string accumulator "class".
string_builder <- function(n = 1e2) {
  output <- vector("character", n)
  i <- 0

  add <- function(text) {
    i <<- i + 1
    if (i > n) {
      n <<- 2 * n
      length(output) <<- n
    }
    output[i] <<- text
  }

  as_vector <- function() {
    output[seq_len(i)]
  }

  as_string <- function(sep = "") {
    paste(output[seq_len(i)], collapse = sep)
  }

  list(
    add = add,
    as_vector = as_vector,
    as_string = as_string
  )
}



process_html_file <- function(srcfile, destfile) {
  src <- readLines(srcfile, warn = FALSE)
  dest <- string_builder()


  state <- "START"
  i <- 1
  while (i <= length(src)) {
    if (state == "START") {
      if (src[i] != "---") {
        stop(sprintf("File %s does not start with '---'", srcfile))
      }
      state <- "HEADER"
      dest$add(src[i])
    } else if (state == "HEADER") {
      if (src[i] == "---") {
        state <- "BODY"
        dest$add(src[i])
        dest$add("")
        dest$add("```{=html}")
      } else {
        if (
          src[i] == "" ||
            startsWith(src[i], "layout:") ||
            startsWith(src[i], "categories:")
        ) {
          # skip
        } else {
          dest$add(src[i])
        }
      }
    } else if (state == "BODY") {
      if (grepl("^ *<h1>", src[i])) {
        state <- "BODY_AFTER_FIRST_H1"
      } else {
        dest$add(src[i])
      }
    } else if (state == "BODY_AFTER_FIRST_H1") {
      if (!grepl("{% assign", src[i], fixed = TRUE)) {
        dest$add(src[i])
      }
    }

    i <- i + 1
  }

  dest$add("```")

  writeLines(dest$as_vector(), destfile)
  NULL
}



process_md_file <- function(srcfile, destfile) {
  src <- readLines(srcfile, warn = FALSE)
  dest <- string_builder()

  state <- "START"
  i <- 1
  while (i < length(src)) {
    if (state == "START") {
      if (src[i] != "---") {
        stop(sprintf("File %s does not start with '---'", srcfile))
      }
      state <- "HEADER"
      dest$add(src[i])
    } else if (state == "HEADER") {
      if (src[i] == "---") {
        state <- "BODY"
        dest$add(src[i])
      } else {
        if (
          src[i] == "" ||
            startsWith(src[i], "layout:") ||
            startsWith(src[i], "categories:")
        ) {
          # skip
        } else {
          dest$add(src[i])
        }
      }
    } else if (state == "BODY") {
      dest$add(src[i])
    }

    i <- i + 1
  }

  writeLines(dest$as_vector(), destfile)
  NULL
}


replace_in_file <- function(file, pattern, replacement) {
  text <- readLines(file)
  text <- gsub(pattern, replacement, text)
  writeLines(text, file)
  NULL
}


process_dir <- function(srcdir, destdir) {
  if (!dir.exists(destdir)) {
    dir.create(destdir, recursive = TRUE)
  }

  files <- list.files(srcdir, full.names = TRUE)
  p <- progress::progress_bar$new(
    total = length(files),
    format = ":current/:total] | :from -> :to",
    clear = FALSE,
    show_after = 0
  )
  for (srcfile in files) {
    if (grepl("\\.html$", srcfile)) {
      destfile <- sub("\\.html$", ".qmdfragment", basename(srcfile))
      destfile <- file.path(destdir, destfile)
      p$tick(tokens = list(from = srcfile, to = destfile))
      process_html_file(srcfile, destfile)
    } else if (grepl("\\.md$", srcfile)) {
      destfile <- sub("\\.md$", ".qmd", basename(srcfile))
      destfile <- file.path(destdir, destfile)
      p$tick(tokens = list(from = srcfile, to = destfile))
      process_md_file(srcfile, destfile)
    } else if (dir.exists(srcfile)) {
      p$tick(tokens = list(from = paste0("dir: ", srcfile), to = destdir))
      file.copy(srcfile, destdir, recursive = TRUE)
    } else {
      stop("Don't know what to do with file: ", srcfile)
    }
  }
}


process_top_dir <- function(srcdir, destdir) {
  if (!dir.exists(destdir)) {
    dir.create(destdir, recursive = TRUE)
  }

  files <- list.files(srcdir, full.names = TRUE)
  for (srcfile in files) {
    if (dir.exists(srcfile)) {
      dest_subdir <- file.path(destdir, basename(srcfile))
      process_dir(srcfile, dest_subdir)
    } else if (grepl("\\.md$", srcfile)) {
      destfile <- sub("\\.md$", ".qmd", basename(srcfile))
      destfile <- file.path(destdir, destfile)
      cat(sprintf("%s  ->  %s\n", srcfile, destfile))
      process_md_file(srcfile, destfile)
      replace_in_file(destfile, "/reference/shiny/", "")
    } else {
      stop("Don't know what to do with file: ", srcfile)
    }
  }
}

process_top_dir("_legacy/r-shiny-reference", "r/reference/shiny")


# Create template file

template_content <-
  "---
pagetitle: PAGE_TITLE_HOLDER
title: TITLE_PLACEHOLDER
---

```{=html}
CONTENT_PLACEHOLDER
```"

if (!dir.exists("r/reference/shiny/template")) {
  dir.create("r/reference/shiny/template", recursive = TRUE)
}

cat("Creating template file: r/reference/shiny/template/template.qmd\n")
writeLines(template_content, "r/reference/shiny/template/template.qmd")
