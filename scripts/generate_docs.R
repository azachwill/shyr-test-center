stopifnot(packageVersion("pkgdown") >= "2.0.6")
library(pkgdown)

min_shiny_version <- "0.11"
min_shiny_render_version <- "1.7.0"




stop_if_not_empty <- function(...) {
  stopifnot(length(list(...)) == 0)
}

shiny_version <- function(..., shiny_copy) {
  stop_if_not_empty(...)
  packageVersion(basename(shiny_copy), dirname(shiny_copy))
}

# Cache the results of hash links
link_to_issue_or_pr <- memoise::memoise(function(full_hash, number, repo = "rstudio/shiny") {
  u <- paste0("https://github.com/", repo)
  issue_url <- paste0(u, "/issues/", number)
  pr_url <- paste0(u, "/pull/", number)

  url_exists <- function(x) {
    !httr::http_error(httr::GET(x))
  }

  if (url_exists(issue_url)) {
    return(paste0("[", full_hash, "](", issue_url, ")"))
  }
  if (url_exists(pr_url)) {
    return(paste0("[", full_hash, "](", pr_url, ")"))
  }
  full_hash
})
# Cache the results of consistent news for a given version
news_for_version <- memoise::memoise(
  function(pkg_path = "shiny_sym",
           tag_ver = as.character(shiny_version(shiny_copy = pkg_path))) {
    lines <- readLines(file.path(pkg_path, "NEWS.md"), warn = FALSE)

    ret <- data.frame(
      version = "",
      text = lines
    )
    for (i in seq_along(lines)) {
      line <- lines[i]
      if (grepl("^(# shiny|shiny) ", line)) {
        version <- sub("^(# shiny|shiny) ", "", line)
      }
      ret$version[i] <- version
    }
    news_txt <- paste0(ret$text[ret$version == tag_ver], collapse = "\n")
    # Remove header: `# shiny 1.2.3` or `shiny 1.2.3\n==========\n`
    news_txt <- sub("(^|\n)shiny [^\n]+\n=+\n", "\n", news_txt)
    news_txt <- sub("(^|\n)# shiny[^\n]*\n", "\n", news_txt)
    # Remove leading whitespace
    news_txt <- sub("^\\s+", "", news_txt)

    # Setup downlit options
    pkgdown:::local_options_link(pkgdown::as_pkgdown(pkg_path), depth = 1L)
    news_txt <-
      withr::with_options(
        # Overrride downlit topic path
        list(downlit.topic_path = "./"),
        downlit::downlit_md_string(news_txt)
      )

    # Replace issue / PR links
    news_txt <-
      stringr::str_replace_all(
        news_txt,
        "[^\\s(]*#\\d+",
        function(x) {
          # Remove leading `\\` if it exists
          x <- gsub("^\\\\", "", x)
          x_info <- strsplit(x, "#")[[1]]
          repo <- x_info[1]
          number <- x_info[2]
          if (!nzchar(repo)) repo <- "rstudio/shiny"
          link_to_issue_or_pr(full_hash = x, number = number, repo = repo)
        }
      )

    news_txt
  }
)

copy_pkg_and_templates <- function() {
  message("\nAttempting to copy ./shiny_sym to temp directory")
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
  message("Copying ./shiny_sym to temp directory")
  file.copy("./shiny_sym", tmpd, recursive = TRUE)
  shiny_copy <- file.path(tmpd, "shiny_sym")

  # Copy templates
  message("Copying template files")
  file.copy("_pkgdown_templates", shiny_copy, recursive = TRUE)

  message("Copying _pkgdown.yml")
  shiny_tools_documentation_pkgdown_yml <-
    file.path(shiny_copy, "tools", "documentation", "pkgdown.yml")
  shiny_inst_pkgdown_yml <- file.path(shiny_copy, "inst", "_pkgdown.yml")
  src_pkgdown_yml <-
    if (file.exists(shiny_tools_documentation_pkgdown_yml)) {
      shiny_tools_documentation_pkgdown_yml
    } else if (file.exists(shiny_inst_pkgdown_yml)) {
      shiny_inst_pkgdown_yml
    } else {
      stop(
        "No pkgdown.yml file found in:",
        paste0("\n* ", c(
          "shiny/tools/documentation/pkgdown.yml",
          "shiny/inst/_pkgdown.yml"
        ))
      )
    }

  # Make sure the tool's pkgdown.yml exists
  stopifnot(file.exists(src_pkgdown_yml))
  file.copy(
    src_pkgdown_yml,
    file.path(shiny_copy, "_pkgdown.yml")
  )

  shiny_copy
}

# Cache to reduce duplicated GitHub API calls
gh_latest_tag_name <- memoise::memoise(function(..., repo) {
  stop_if_not_empty(...)

  # requires a GITHUB_PAT token
  gh::gh(paste0("GET /repos/", repo, "/tags"))[[1]]$name
})
# Cache to reduce duplicated `readLines()` calls
gh_man_file_lines <- memoise::memoise(
  function(..., repo, man_file) {
    stop_if_not_empty(...)

    latest_tag_name <- gh_latest_tag_name(repo = repo)
    github_man_location <- paste0("https://raw.githubusercontent.com/", repo, "/", latest_tag_name, "/man/")

    readLines(paste0(github_man_location, man_file))
  }
)
collect_reexports_man_files <- function(..., shiny_copy) {
  stop_if_not_empty(...)

  reexports_file <-
    file.path(
      shiny_copy,
      "tools",
      "documentation",
      "reexports.json"
    )
  shiny_man_folder <- file.path(shiny_copy, "man")
  reexports_man_file <- file.path(shiny_man_folder, "reexports.Rd")

  if (!file.exists(reexports_file)) {
    message("\nNo reexports.json file found, skipping")
    if (file.exists(reexports_man_file)) {
      message(
        "Shiny ", shiny_version(shiny_copy = shiny_copy),
        " `man/reexports.Rd` exists with no `reexports.json` file!"
      )
    }
    return()
  }

  message("\nCollecting reexports:")
  alias_info <-
    jsonlite::fromJSON(reexports_file, simplifyDataFrame = FALSE)

  lapply(alias_info, function(alias_pkg_info) {
    files_to_copy <- vapply(alias_pkg_info$exports, `[[`, character(1), "file")

    # download all latest htmltools tag man files
    lapply(files_to_copy, function(man_file) {
      save_location <- file.path(shiny_man_folder, man_file)
      if (file.exists(save_location)) {
        stop("File '", save_location, "' already exists!")
      }
      writeLines(
        # read from GitHub
        gh_man_file_lines(repo = alias_pkg_info$repo, man_file = man_file),
        # save to disk
        save_location
      )
      message("* ", alias_pkg_info$name, "::", man_file)
    })
  })

  message("Deleting: shiny::reexports.Rd")
  unlink(reexports_man_file)
}

make_man_file_internal <- function(..., shiny_copy, man_file) {
  stop_if_not_empty(...)
  stopifnot(grepl("\\.Rd$", man_file))

  man_file_path <- file.path(shiny_copy, "man", man_file)
  if (file.exists(man_file_path)) {
    has_keyword_internal <-
      any(
        grepl(
          "keyword{internal}",
          readLines(man_file_path),
          fixed = TRUE
        )
      )
    if (!has_keyword_internal) {
      message("\nMaking man file internal: ", man_file_path)
      cat("\\keyword{internal}\n", file = man_file_path, append = TRUE)
    }
  }
}
make_man_files_internal <- function(..., shiny_copy) {
  stop_if_not_empty(...)
  make_man_file_internal(shiny_copy = shiny_copy, man_file = "shiny-package.Rd")
  make_man_file_internal(shiny_copy = shiny_copy, man_file = "knitr_methods.Rd")
}

build_shiny_site <- function(..., shiny_copy) {
  stop_if_not_empty(...)

  # Make sure the docs directory is empty before building
  docs_dir <- file.path(shiny_copy, "docs")
  if (dir.exists(docs_dir)) {
    message("\nDeleting docs directory: ", docs_dir)
    unlink(docs_dir, recursive = TRUE)
  }

  message("\nBuilding site")
  tryCatch(
    pkgdown::build_site(
      pkg = shiny_copy,
      # TODO Figure out why build hangs with examples = TRUE
      examples = FALSE,
      seed = 1337,
      preview = FALSE
    ),
    error = function(e) {
      rlang::abort(paste0("Error trying to call `pkgdown::build_site()` in `shiny_sym` folder. Please check out the Shiny git tag ", shiny_version(shiny_copy = shiny_copy), " and run `pkgdown::build_site()` manually to debug."), parent = e)
    }
  )
}

rename_html_to_qmdfragment <- function(..., shiny_copy) {
  stop_if_not_empty(...)

  message("\nRename .html files to .qmdfragment")
  ref_path <- file.path(shiny_copy, "docs", "reference")
  ref_files <- list.files(ref_path)
  lapply(file.path(ref_path, ref_files), function(ref_file) {
    file.rename(ref_file, sub("\\.html$", ".qmdfragment", ref_file))
  })
}

remove_unwanted_html <- function(..., shiny_copy) {
  stop_if_not_empty(...)
  ref_path <- file.path(shiny_copy, "docs", "reference")

  message("Removing unwanted html formatting")
  ref_files <- list.files(ref_path)
  tag_version <- shiny_version(shiny_copy = shiny_copy)
  lapply(file.path(ref_path, ref_files), function(ref_file) {
    if (dir.exists(ref_file)) {
      return()
    }
    content <- readLines(ref_file)
    # Remove first two lines of `DOCTYPE` and `html`, `head`, and `body` tags
    content <- content[-(1:2)]
    # Remove closing tags
    content <- content[content != "</body></html>"]
    # Trim multiple white spaces
    while (all(tail(content, 2) == c("", ""))) {
      content <- content[-length(content)]
    }

    # Override `title` for index.qmdfragment to `pagetitle`
    # The template will make a nice title and should use `title` from the qmd
    if (basename(ref_file) == "index.qmdfragment") {
      title_pos <- tolower(content) == "title: \"function reference\""
      if (!any(title_pos)) {
        print(content)
        stop("Could not find title in index.qmdfragment")
      }
      message("\nUpdating `title` to `pagetitle` in index.qmdfragment")
      content[title_pos] <- paste0("pagetitle: \"Function reference — ", tag_version, "\"")
    }

    # Update source links to tagged location
    content <- gsub(
      "github.com/rstudio/shiny/blob/HEAD/",
      paste0("github.com/rstudio/shiny/blob/v", tag_version, "/"),
      content
    )

    content_txt <- paste0(content, collapse = "\n")
    content_txt <- sub("\n\n---\n\n", "\n---\n\n", content_txt, fixed = TRUE)
    content_txt <- sub("\n\n```\n", "\n```\n", content_txt, fixed = TRUE)

    # Write file
    cat(content_txt, file = ref_file)
  })
}

move_docs <- function(..., shiny_copy, dest_folder) {
  stop_if_not_empty(...)

  latest_dir <- file.path(shiny_copy, "docs", "latest")
  file.rename(
    file.path(shiny_copy, "docs", "reference"),
    latest_dir
  )
  file.copy(
    latest_dir,
    dest_folder,
    recursive = TRUE
  )
}

generate_pkgdown_reference <- function() {
  stopifnot(grepl("^shyr-test-center", basename(getwd())))

  shiny_copy <- copy_pkg_and_templates()

  collect_reexports_man_files(shiny_copy = shiny_copy)

  make_man_files_internal(shiny_copy = shiny_copy)

  build_shiny_site(shiny_copy = shiny_copy)

  rename_html_to_qmdfragment(shiny_copy = shiny_copy)

  remove_unwanted_html(shiny_copy = shiny_copy)


  move_docs(
    shiny_copy = shiny_copy,
    dest_folder = file.path("r", "reference", "shiny")
  )
}

build_docs <- function(tag_name) {
  tag_ver <- sub("v", "", tag_name)

  if (numeric_version(tag_ver) < min_shiny_render_version) {
    message(
      "\nSkipping shiny docs for: `", tag_ver, "`.",
      " Any changes should be made in `scripts/migrate_api_docs.R`."
    )
    return()
  }

  cur_branch <- system("cd shiny_sym; git branch --show-current", intern = TRUE)
  on.exit(
    {
      message("\nSwitching back to branch: `", cur_branch, "`")
      system(paste0("cd shiny_sym; git checkout ", cur_branch))
    },
    add = TRUE
  )

  node_modules <- file.path("shiny_sym", "node_modules")
  if (dir.exists(node_modules)) {
    message("\nDeleting `shiny_sym/node_modules")
    unlink(node_modules, recursive = TRUE)
  }

  message("\nChecking out tag: `", tag_name, "`")
  system(paste0("cd shiny_sym; git checkout ", tag_name))

  message("Deleting `r/reference/shiny/", tag_ver, "`")
  unlink(paste0("r/reference/shiny/", tag_ver), recursive = TRUE)

  message("Deleting `r/reference/shiny/latest`")
  unlink("r/reference/shiny/latest", recursive = TRUE)
  dir.create("r/reference/shiny/latest", recursive = TRUE, showWarnings = FALSE)

  message("\nGenerating docs")
  generate_pkgdown_reference()

  message("\nCopying NEWS contents")
  # shiny_news <- news(db = tools:::.news_reader_default("./shiny_sym/NEWS.md"))
  # shiny_news_txt <- paste0(shiny_news$Text[shiny_news$Version == tag_ver], collapse = "\n")
  shiny_news_txt <- news_for_version("./shiny_sym", tag_ver)

  message("\nCreating r/reference/shiny/latest/upgrade.qmd")
  cat(
    file = "r/reference/shiny/latest/upgrade.qmd",
    sep = "",
    "---\n",
    # "layout: upgrade-note\n",
    "title: Upgrade notes for Shiny ", tag_ver, "\n",
    "---\n",
    "\n",
    shiny_news_txt,
    "\n"
  )

  message("\nCopying ./r/reference/shiny/latest to ./r/reference/shiny/", tag_ver)
  system(paste0("cp -R r/reference/shiny/latest r/reference/shiny/", tag_ver))
}

create_index_qmd <- function() {
  message("\nCreating ./r/reference/shiny/index.qmd")
  shiny_dirs <- list.dirs("r/reference/shiny", recursive = FALSE, full.names = FALSE)
  shiny_dirs <- setdiff(shiny_dirs, c("latest", "template"))
  # Don't include very old links on page
  shiny_dirs <- shiny_dirs[numeric_version(shiny_dirs) >= min_shiny_version]
  shiny_dirs <- sort(numeric_version(shiny_dirs), decreasing = TRUE)
  max_ver <- as.character(shiny_dirs[[1]])
  shiny_dirs <- shiny_dirs[-1]
  cat(
    file = "r/reference/shiny/index.qmd",
    sep = "",
    "---\n",
    # "layout: default\n",
    "title: Reference\n",
    # "categories: reference\n",
    "---\n",
    "\n",
    # "# Reference\n",
    # "\n",
    ":::{.lead}\n",
    "Below you can find upgrade notes and function references for latest and previous versions of the Shiny package.\n",
    ":::\n",
    "\n",
    "## Latest version\n",
    ":::{.table-spacing-md .shiny-version-table}\n",
    "\n",
    "|  |  |  |\n",
    "| --- | :---: | :---: |\n",
    "| shiny ", max_ver, " | [Upgrade notes](latest/upgrade.html) | [Function reference](latest/) |\n",
    ":::\n",
    "\n",
    "### Previous versions{.mt-5 .mb-4}\n",
    "\n",
    ":::{.table-spacing-md .table-simple .shiny-version-table }\n",
    "\n",
    "|  |  |  |\n",
    "| --- | :---: | :---: |\n",
    paste0(
      "| shiny ", shiny_dirs, " | [Upgrade notes](", shiny_dirs, "/upgrade.html) | [Function reference](", shiny_dirs, "/) |\n",
      collapse = ""
    ),
    ":::\n"
  )
}





main <- function(tag_names = NULL, ..., build_latest = TRUE) {
  stop_if_not_empty(...)

  # Make sure shiny symlink exists
  if (!file.exists("shiny_sym/DESCRIPTION")) {
    stop(
      "Is `./shiny_sym` linking to the Shiny directory?",
      "`ln -s PATH_TO_SHINY shiny_sym`"
    )
  }

  # Get latest tags from `{shiny}`
  tags <- system(
    paste0(
      "cd shiny_sym; ",
      "git tag -l 'v*.*.*' --sort=-creatordate"
    ),
    intern = TRUE
  )
  # Remove tags like `v0.10.0-staticdocs`
  tags <- tags[!grepl("-", tags)]
  # Remove patch tags like `v0.10.2.1`
  tags <- tags[!grepl("(\\d+\\.){3}", tags)]

  tag_vers <- sub("v", "", tags)
  tag_vers <- sub("-.*$", "", tag_vers)
  tag_vers <- numeric_version(tag_vers)
  tags <- tags[tag_vers >= min_shiny_render_version]
  tag_vers <- tag_vers[tag_vers >= min_shiny_render_version]
  all_str <- "(All)"
  none_str <- "(None)"
  if (is.null(tag_names)) {
    tag_names <-
      utils::select.list(
        c(all_str, none_str, tags),
        multiple = TRUE,
        graphics = FALSE,
        title = "Which tag would you like to make docs for?"
      )
    # Try to have `latest` last to render
    tag_names <- rev(tag_names)
  }
  if (is.character(tag_names)) {
    if (tolower(none_str) %in% tolower(tag_names)) {
      tag_names <- character(0)
    } else if (tolower(all_str) %in% tolower(tag_names)) {
      tag_names <- tags[tag_vers >= min_shiny_render_version]
      tag_names <- rev(tag_names)
    } else if (!all(tag_names %in% tags)) {
      cat("Possible tag names:\n")
      print(tags)
      stop(
        "Invalid tag name(s): ",
        paste0(tag_names[!tag_names %in% tags], collapse = ", "),
        call. = FALSE
      )
    }
  }

  if (length(tag_names) > 0) {

    p <- progress::progress_bar$new(
      total = length(tag_names),
      format = "\n\n`:tag_name` :current/:total [:bar] eta::eta\n\n",
      show_after = 0,
      clear = FALSE
    )
    lapply(tag_names, function(tag_name) {
      p$tick(tokens = list(tag_name = tag_name))
      build_docs(tag_name)
    })

    if (isTRUE(build_latest)) {
      last_tag <- tag_names[length(tag_names)]
      if (last_tag != tags[1]) {
        latest_tag <- tags[1]
        message(
          "\n\nBuilding `latest` with the latest tag: ", latest_tag,
          "\nDisable with `main(build_latest = FALSE)`"
        )
        build_docs(latest_tag)
        tag_names <- c(tag_names, latest_tag)
      }
    }
  }

  create_index_qmd()

  # Copy to quarto build folder
  message("\nCopying to quarto build folder")
  local({
    # Used at end of `main()`
    source("scripts/generate_api_docs_from_template.R", local = environment())
    process_top_dir("r/reference/shiny", "_build/r/reference/shiny")
  })

  tag_names
}

# if (interactive()) {
#   main()
# }
