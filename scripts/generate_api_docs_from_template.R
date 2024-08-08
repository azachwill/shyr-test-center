#!/usr/bin/env Rscript

# Continue past this part only if building entire site.
called_from_quarto <- Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR") != ""
quarto_rendering_all <- Sys.getenv("QUARTO_PROJECT_RENDER_ALL") != ""
if (called_from_quarto && !quarto_rendering_all) {
  cat("script/generate_api_docs_from_template.R:\n\tSkipping copying r/reference/shiny reference docs\n\tCall `quarto render` or `Rscript script/generate_api_docs_from_template.R` to copy reference docs")
  quit()
}

if (!dir.exists("r/reference/shiny/")) {
  stop(
    "This script must be run from the top level of the repository, as in\n",
    "  _scripts/generate_reference_docs_from_template.R"
  )
}

if (!file.exists("_build/r/reference/shiny/template/template.html")) {
  stop(
    "This script must be run after running quarto, which will generate\n",
    "  _build/r/reference/shiny/template/template.html"
  )
}


template_content <- readLines(
  "_build/r/reference/shiny/template/template.html",
  # readLines will warn about an incomplete final line, because that's how Quarto
  # outputs the fule; suppress that message.
  warn = FALSE
)


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


apply_template <- function(values, template, destfile) {
  tryCatch(
    for (name in names(values)) {
      template <- gsub(name, values[[name]], template, fixed = TRUE)
    },
    error = function(e) {
      str(list(values, template, destfile))
      stop(e)
    }
  )

  writeLines(template, destfile)
}



extract_values <- function(file) {
  src <- readLines(file)
  dest <- string_builder()

  res <- list(
    TITLE_PLACEHOLDER = "",
    PAGE_TITLE_HOLDER = NULL,
    CONTENT_PLACEHOLDER = NULL
  )

  state <- "START"
  i <- 1
  while (i < length(src)) {
    if (state == "START") {
      if (src[i] != "---") {
        stop(sprintf("File %s does not start with '---'", file))
      }
      state <- "HEADER"
    } else if (state == "HEADER") {
      if (src[i] == "---") {
        state <- "BODY"
      } else if (src[i] == "") {
        # Ignore blank lines
      } else if (startsWith(src[i], "title:")) {
        res$TITLE_PLACEHOLDER <- sub('title: *"(.*)"', "\\1", src[i])
      } else if (startsWith(src[i], "pagetitle:")) {
        res$PAGE_TITLE_HOLDER <- sub('pagetitle: *"(.*)"', "\\1", src[i])
      }
    } else if (state == "BODY") {
      if (startsWith(src[i], "```{=html}")) {
        state <- "BODY_HTML_CONTENT"
      } else if (src[i] != "") {
        stop("Unexpected line in body _before ```{=html} marker: ", src[i])
      }
    } else if (state == "BODY_HTML_CONTENT") {
      if (startsWith(src[i], "```{=html}")) {
        state <- "END"
      } else {
        dest$add(src[i])
      }
    }

    i <- i + 1
  }

  if (!is.null(res$TITLE_PLACEHOLDER)) {
    if (grepl("^Function reference \\(version", res$TITLE_PLACEHOLDER)) {
      # Turn _title_ from `Function reference (version 1.6.0)` to `Function reference — 1.6.0
      res$TITLE_PLACEHOLDER <- sub(" (version ", " — ", res$TITLE_PLACEHOLDER, fixed = TRUE)
      res$TITLE_PLACEHOLDER <- sub(")", "", res$TITLE_PLACEHOLDER, fixed = TRUE)
    }
  }

  # If there's no page title, use the title.
  if (is.null(res$PAGE_TITLE_HOLDER)) {
    res$PAGE_TITLE_HOLDER <- res$TITLE_PLACEHOLDER
  }

  res$CONTENT_PLACEHOLDER <- dest$as_string("\n")
  res
}


process_dir <- function(srcdir, destdir) {
  if (!dir.exists(destdir)) {
    dir.create(destdir, recursive = TRUE)
  }

  files <- list.files(srcdir, full.names = TRUE)
  files <- files[grepl("\\.qmdfragment$", files)]

  if (!called_from_quarto) {
    p <- progress::progress_bar$new(
      total = length(files),
      format = ":current/:total | :src -> :dest",
      show_after = 0,
      clear = FALSE,
      force = TRUE
    )
  }

  for (srcfile in files) {
    destfile <- sub("\\.qmdfragment$", ".html", basename(srcfile))
    destfile <- file.path(destdir, destfile)
    if (called_from_quarto) {
      cat(sprintf("Rendering %s -> %s\n", srcfile, destfile))
    } else {
      p$tick(tokens = list(
        tag = basename(srcdir),
        src = srcfile,
        dest = destfile
      ))
    }
    values <- extract_values(srcfile)
    apply_template(values, template_content, destfile)
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
    }
  }
}


# Also called in `generate_docs.R`: `main()`
# process_top_dir("r/reference/shiny", "_build/r/reference/shiny")

# If called from quarto, render the qmdfragments to html
if (called_from_quarto) {
  process_top_dir("r/reference/shiny", "_build/r/reference/shiny")
}
