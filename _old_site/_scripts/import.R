#! /usr/bin/env Rscript

if (!grepl("^darwin", version$os)) {
  stop("The import script must be run on Mac OS X.\n",
    "(Otherwise the screenshot won't look right.)")
}

# Given a string, return a tag-safe equivalent.
# In: "Hello, World!"  -> Out: "hello-world"
tagFromString <- function(str) {
  tag <- gsub("\\W", "-", str)
  tag <- gsub("-+", "-", tag)
  tag <- gsub("^-+|-+$", "", tag)
  return(tag)
}

# Given a tag, return a friendly string equivalent
# In: "application-layout"  -> Out: "Application Layout"
stringFromTag <- function(tag) {
  str <- gsub("-", " ", tag)
  str <- gsub("\\s+", " ", str)
  str <- gsub("(^|\\s)(.)", "\\1\\U\\2\\E", str, perl = TRUE)
  return(str)
}

# utility: download 'url' to tempfile() and return the first n lines as a
# character vector
firstNLines <- function(url, n) {
  filename <- tempfile()
  curl::curl_download(url, filename, quiet = TRUE)
  readLines(filename, n, warn = FALSE)
}

# utility: return a data frame containing the contents of the YAML from the
# given .md file (the YAML is presumed to be in a section beginning and ending
# with ---)
yamlFromMd <- function(filename) {
  lines <- readLines(filename, warn = FALSE)
  sectionEndpoints <- which(lines == '---')
  if (length(sectionEndpoints) < 2)
    return(data.frame())
  yaml::yaml.load(paste(lines[sectionEndpoints[1] + 1:sectionEndpoints[2] - 2],
                        collapse = "\n"))
}

# figure out where we're being run from
allArgs <- commandArgs(FALSE)
scriptsDir <- dirname(sub("--file=", "", allArgs[grep("--file=", allArgs)]))
galleryDir <- dirname(scriptsDir)

# read appUrl argument
args <- commandArgs(TRUE)
# check run location (look for ruby gist gem)
if (length(args) < 3 && nchar(Sys.which("gist")) == 0) {
  stop("Can't find ruby 'gist' utility. Try running again from inside '",
       galleryDir, "', and make sure all dependencies are installed.")
}

if (length(args) < 2)
  stop("Usage: import.R <code-path> <application-url> [<code-url>]\n",
       "   code-path - path to application on disk (local)\n",
       "   application-url - URL to deployed application (http or https) \n",
       "   code-url - optional; URL to hosted code. If missing, a gist will be created.")
codePath <- args[1]
appUrl <- args[2]

# Emit an error if the file is missing required fields or has values
# incompatible with the gallery (i.e. the app must be set to be visible
# in showcase mode)
message("Checking DESCRIPTION... ", appendLF = FALSE)
descFile <- file.path(codePath, "DESCRIPTION")
if (!file.exists(descFile)) {
  stop("Shiny Gallery applications must have a DESCRIPTION file (expected at ",
       descFile, ")")
}
desc <- read.dcf(descFile)
requiredCols <- c("Title", "Author", "AuthorUrl", "License",
                  "Type", "Tags")
missingCols <- setdiff(requiredCols, colnames(desc))
if (length(missingCols) > 0) {
  stop("DESCRIPTION file is missing required field(s): ",
       paste(missingCols, collapse = ", "))
}

requiredVals <- list(
  License = "MIT",
  Type = "Shiny")

for (i in 1:length(requiredVals)) {
  if (desc[1,names(requiredVals)[i]] != requiredVals[i]) {
    stop("Incorrect value for ", names(requiredVals)[i], ": expected ",
         requiredVals[i], ", actual ", desc[1, names(requiredVals[i])])
  }
}

message("OK")

appKey <- tagFromString(tolower(desc[1,"Title"]))

# Hit the app URL to make sure it returns something that looks vaguely
# like a Shiny app.
message("Testing app URL... ", appendLF = FALSE)
# try a few times before we declare failure, because ShinyApps.io may take a
# few seconds to launch an app
ntry <- 5
for (i in seq_len(ntry)) {
  contents <- firstNLines(appUrl, -1)
  # initially, there is <title>ShinyApps.io</title>, but no shiny.js
  if (length(grep("shiny.css", contents)) == 0) {
    if (length(grep("ShinyApps.io", contents)) > 0 && i < ntry) {
      Sys.sleep(5)  # normally 5 seconds should make ShinyApps ready
    } else stop(appUrl, " doesn't appear to be a Shiny application.")
  } else break
}
message("OK")

# Check the formatting of each of the .R files in the application
message("Checking code formatting: ")
files <- file.path(codePath, list.files(path = codePath, pattern = "\\.[rR]$"))
for (file in files) {
  message("    ", file, "... ", appendLF = FALSE)
  # Treat tabs as two spaces for indent
  lines <- gsub("\t", "  ", readLines(file))
  chars <- nchar(lines)
  if (any(i <- chars > 65)) {
    warning("code line(s) too wide in ", file, ":\n\n",
         paste(" ", which(i), ":", lines[i], collapse = "\n"),
         "\n\n", "Lines longer than 65 characters may be wrapped in side-by-side view.")
  } else message("OK")
}

# Check to see if the app's source contains a screenshot.png, and take a
# snapshot with phantom.js if it doesn't; either way, save the screenshot to
# images/screenshots
screenshotSrc <- file.path(codePath, "screenshot.png")
screenshotDest <- file.path(galleryDir, "gallery", "images", "screenshots",
                           paste(appKey, ".png", sep=""))
thumbnailDest <- file.path(galleryDir, "gallery", "images", "thumbnails",
                           paste(appKey, ".png", sep=""))

if (file.exists(screenshotSrc)) {
  message("Using included screenshot ", screenshotSrc, "... ", appendLF = FALSE)
  file.copy(screenshotSrc, screenshotDest, overwrite = TRUE)
  message("OK")
} else {
  message("Taking a screenshot (takes 20 seconds)... ", appendLF = FALSE)
  result <- system(paste(file.path(galleryDir, "_dependencies", "phantomjs-2.1.1"),
                         " ",
                         file.path(scriptsDir, "screenshot.js"),
                         " ",
                         appUrl, "?showcase=0 ", screenshotDest, sep = ""),
                   intern = TRUE, ignore.stderr = TRUE, ignore.stdout = TRUE)
  if (!file.exists(screenshotDest)) {
    stop(result)
  }
  message("OK")
}
# Make a shrunken version of the image for the gallery page. Relies on
# the sips utility that is bundled with Mac OS X.
result <- system(sprintf("sips -Z 370 \"%s\" --out \"%s\"",
  screenshotDest, thumbnailDest))
if (!file.exists(thumbnailDest)) {
  stop(result)
}

message("Checking for existing gallery entry... ", appendLF = FALSE)
# Check to see if the app key already exists
existingFiles <- list.files(file.path(galleryDir, "gallery", "_posts"))

# Create a list of keys from files (YYYY-MM-DD-key-name.md => key-name)
existingKeys <- substring(existingFiles, 12,
                          unlist(lapply(existingFiles, nchar)) - 3)
message("OK")

if (appKey %in% existingKeys) {
  appFileName <- existingFiles[which(existingKeys == appKey, arr.ind = TRUE)]
  message("    Using existing post '", appFileName, "'")
} else {
  appFileName <- paste(format(Sys.time(), "%Y-%m-%d"), "-", appKey, ".md",
                       sep = "")
  message("    Creating new post '", appFileName, "'")
}
appFilePath <- file.path(galleryDir, "gallery", "_posts", appFileName)

if (length(args) > 2) {
  # Manually specified source URL: use as-is, just be sure it's a legit URL
  sourceUrl <- args[3]
  message("Testing source URL... ", appendLF = FALSE)
  contents <- firstNLines(sourceUrl, 25)
  # Don't try to validate that this is a real document, just make sure it
  # returned some nontrivial data
  if (length(contents) < 1) {
    stop(sourceUrl, " looks empty")
  }
  message("OK")
} else {
  message("Uploading code... ", appendLF = FALSE)
  cmdStem <- paste('gist -d "', desc[1,"Title"], '\nLicense: MIT"', sep = "")
  sourceUrl <- ""
  cmd <- cmdStem
  method <- "Created"
  # If there might already be a gist for this app, and the user is logged in to
  # the gist utility (and therefore might have permissions to update the gist),
  # try an update.
  if (file.exists(appFilePath) &&
      file.exists("~/.gist")) {
    appDetails <- yamlFromMd(appFilePath)
    if (length(appDetails) > 0) {
      gistUrl <- regmatches(appDetails$source_url,
                            regexpr("gist.github.com/\\d+", appDetails$source_url))
      if (length(gistUrl) > 0) {
        cmd <- paste(cmd, "-u", regmatches(gistUrl, regexpr("\\d+", gistUrl)))
        method <- "Updated"
        # Unfortunately there is not a straightforward mechanism for determining
        # whether we have permission to update this gist; we'll try below and
        # if a failure occurs we'll fall back on create.
      }
    }
  }
  cmd <- paste(cmd, file.path(codePath, "*.R"))
  tryCatch({
      sourceUrl <- system(cmd, intern = TRUE, ignore.stderr = TRUE)
    },
    warning = function(e) {
      # In the special case where we failed while updating, (in which case
      # the 'gist' utility exits with a nonzero status, creating a warning),
      # try again, but this time create a new gist instead of updating the
      # existing one.
      if (identical(method, "Updated")) {
        method <<- paste("Couldn't update ", gistUrl, "; created",
                         sep = "")
        sourceUrl <<- system(paste(cmdStem, file.path(codePath, "*.R")),
                             intern = TRUE, ignore.stderr = TRUE)
      }
    })
  message("OK\n",
          "    ", method, " ", sourceUrl)
}

# Write the post .md file based on the contents of DESCRIPTION.

conn <- file(appFilePath, open = "wt")
writeLines('---', con = conn)
cat(yaml::as.yaml(list(layout = "app",
                       title = desc[1,"Title"],
                       date = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
                       tags = desc[1,"Tags"],
                       app_url = appUrl,
                       source_url = sourceUrl,
                       license = desc[1,"License"],
                       thumbnail = paste(appKey, '.png', sep = ""))),
    file = conn)
writeLines('---', con = conn)
close(conn)

message("Import successfully completed.")

