link_to_issue_or_pr <- function(full_hash, number, repo = "rstudio/shiny") {
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
}
news_for_version <- function(pkg_path = "shiny_sym", ver = as.character(packageVersion(basename(shiny_copy), dirname(shiny_copy)))) {

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
  news_txt <- paste0(ret$text[ret$version == ver], collapse = "\n")
  news_txt <- sub("^shiny [^\n]+\n", "", news_txt)
  news_txt <- sub("^=+\n", "", news_txt)
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
ans <- utils::menu(
  head(tags, 5),
  graphics = FALSE,
  title = "Which tag would you like to make docs for?"
)
ver <- sub("v", "", tags[ans])

local({
  cur_branch <- system("cd shiny_sym; git branch --show-current", intern = TRUE)
  on.exit({
    message("Switching back to branch: `", cur_branch, "`")
    system(paste0("cd shiny_sym; git checkout ", cur_branch))
  }, add = TRUE)

  message("Checking out tag: `", cur_branch, "`")
  system(paste0("cd shiny_sym; git checkout v", ver))

  message("Deleting `reference/shiny/", ver, "`")
  unlink(paste0("reference/shiny/", ver), recursive = TRUE)

  message("Deleting `reference/shiny/latest`")
  unlink("reference/shiny/latest", recursive = TRUE)
  dir.create("reference/shiny/latest", recursive = TRUE, showWarnings = FALSE)

  message("Generating docs")
  source("_scripts/generate-pkgdown-reference.R")

  message("Copying NEWS contents")
  # shiny_news <- news(db = tools:::.news_reader_default("./shiny_sym/NEWS.md"))
  # shiny_news_txt <- paste0(shiny_news$Text[shiny_news$Version == ver], collapse = "\n")
  shiny_news_txt <- news_for_version("./shiny_sym", ver)

  message("Creating reference/shiny/latest/upgrade.md")
  cat(
    file = "reference/shiny/latest/upgrade.md",
    sep = "",
    "---\n",
    "layout: upgrade-note\n",
    "title: Upgrade notes for Shiny ", ver, "\n",
    "---\n",
    "\n",
    "\n",
    shiny_news_txt,
    "\n"
  )

  message("Copying ./reference/shiny/latest to ./reference/shiny/", ver)
  system(paste0("cp -R reference/shiny/latest reference/shiny/", ver))

  message("Creating ./reference/shiny/index.md")
  shiny_dirs <- list.dirs("reference/shiny", recursive = FALSE, full.names = FALSE)
  shiny_dirs <- setdiff(shiny_dirs, "latest")
  # Don't include very old links on page
  shiny_dirs <- shiny_dirs[numeric_version(shiny_dirs) >= "0.11"]
  shiny_dirs <- sort(numeric_version(shiny_dirs), decreasing = TRUE)
  max_ver <- as.character(shiny_dirs[[1]])
  shiny_dirs <- shiny_dirs[-1]
  cat(
    file = "reference/shiny/index.md",
    sep = "",
    "---\n",
    "layout: default\n",
    "title: Reference\n",
    "categories: reference\n",
    "---\n",
    "\n",
    "# Reference\n",
    "\n",
    "Below you can find upgrade notes and function references for latest and previous versions of the Shiny package.\n",
    "\n",
    "## Latest version\n",
    "\n",
    "| shiny ", max_ver, " | - | [Upgrade notes](/reference/shiny/", max_ver, "/upgrade.html) | - | [Function reference](/reference/shiny/", max_ver, "/) |\n",
    "\n",
    "## Previous versions\n",
    "\n",
    paste0(
      "| shiny ", shiny_dirs, " | - | [Upgrade notes](/reference/shiny/", shiny_dirs, "/upgrade.html) | - | [Function reference](/reference/shiny/", shiny_dirs, "/) |\n",
      collapse = ""
    )
  )

})
