#!/usr/bin/env ruby

if RUBY_PLATFORM !~ /darwin/
  STDERR.puts "Sorry, this script only works on Mac OS X."
  exit 1
end

require 'yaml'
require 'open-uri'
require 'tmpdir'
require 'dcf'
require 'pp'

# Deploy a new app; root is the site's root directory, and source_url is the
# gist or github URL of the app's source code. This function will download the
# source, (re)deploy it to shinyapps, and import it.
def new_app(root, source_url)
  download_spec = url_to_download_spec source_url
  execute_download_spec(download_spec) do |source_dir|
    puts "Source dir: #{source_dir}"
    puts "Deploying app:"
    app_url = deploy_app(source_dir)
    puts "Sleeping for 20 seconds..."
    sleep 20
    puts "Importing app:"
    import_app(root, source_dir, app_url, source_url)
  end
end

# Redeploy the app; root is the site's root directory, and app is the shortname
# of the app. This function will figure out the app's current source URL,
# download the source, redeploy it to shinyapps, and re-import it.
def existing_app(root, app)
  file = find_post_for_app(root, app)
  frontmatter = YAML.load_file(file)

  source_url = frontmatter["source_url"]

  download_spec = url_to_download_spec source_url

  execute_download_spec(download_spec) do |source_dir|
    puts "Source dir: #{source_dir}"
    puts "Deploying app:"
    app_url = deploy_app(source_dir)
    puts "Sleeping for 20 seconds..."
    sleep 20
    puts "Importing app:"
    import_app(root, source_dir, app_url, source_url)
    if get_slug(source_dir) != app
      # Delete the old files if the name changed
      File.unlink(file)
      File.unlink(File.join(root, "gallery/images/screenshots", frontmatter["thumbnail"]))
      File.unlink(File.join(root, "gallery/images/thumbnails", frontmatter["thumbnail"]))
    end
  end
end

# Deploys the app in the given directory to ShinyApps.io under the "gallery"
# account. The name of the app will be based on the title, but tag-ified. For
# example, "My Example" would be https://gallery.shinyapps.io/my-example/.
def deploy_app(source_dir)
  account = "gallery"
  slug = get_slug(source_dir)
  runcmd %Q`cd "#{source_dir}" && R --slave -e "shinyapps::deployApp(appName='#{slug}', account='#{account}')"`
  return "https://#{account}.shinyapps.io/#{slug}/"
end

# Executes import.R with the given parameters
def import_app(root_dir, source_dir, app_url, source_url)
  importR = File.join(root_dir, "_scripts", "import.R")
  runcmd %Q`"#{importR}" "#{source_dir}" "#{app_url}" "#{source_url}"`
end

# Run any shell command, passing stdout/stderr through to this process; wait for
# the command to complete; and if the exit code isn't 0, then exit THIS process
# with the same exit code.
def runcmd(cmd)
  pid = spawn(cmd)
  Process.wait(pid)
  if $?.exitstatus != 0
    exit $?.exitstatus
  end
end

def get_slug(source_dir)
  desc = get_desc(source_dir)
  slug = tag_from_string(desc[0]["Title"].downcase)
  return(slug)
end

# Given a source directory, return a hash table with the DESCRIPTION info. If
# the DESCRIPTION doesn't exist then an exception will be raised.
def get_desc(source_dir)
  Dcf.parse open(File.join(source_dir, "DESCRIPTION")).read
end

# tag-ify the given string (doesn't convert to lowercase, do that yourself if
# you want that).
def tag_from_string(str)
  str.gsub(/\W/, "-")
     .gsub(/-+/, "-")
     .gsub(/^-+|-+$/, "")
end

# Find the .md file under gallery/_posts for the given shortname; either return
# the one file that matches, or raise an exception.
def find_post_for_app(site_dir, name)
  pattern = File.join(site_dir, "gallery/_posts", "????-??-??-#{name}.md")
  matches = Dir[pattern]
  if matches.length == 0
    raise "App \"#{name}\" not found in gallery/_posts"
  end
  if matches.length != 1
    raise "App \"#{name}\" occurs more than once in gallery/_posts"
  end

  # The path to the .md file
  return(matches[0])
end

# Given the URL to a gist, a GitHub repo, or a subdirectory within a GitHub
# repo, figure out the correct:
#   1) Archive URL
#   2) Command to extract the file at the archive URL
#   3) Subdirectory in the archive in which the desired files are located
def url_to_download_spec(source_url)
  case source_url
  when /^https:\/\/gist.github.com\//
    {url: "#{source_url}/download", subdir: nil, cmd: "tar xzvf"}
  when /^(https:\/\/github.com\/[^\/]+\/[^\/]+\/)tree\/([^\/]+)\/(.+)/
    baseurl = $1
    branch = $2
    subdir = $3
    {url: "#{baseurl}archive/#{branch}.zip", subdir: subdir, cmd: "unzip --"}
  when /^(https:\/\/github.com\/[^\/]+\/[^\/]+)\/?$/
    {url: "#{$1}/archive/master.zip", subdir: nil, cmd: "unzip --"}
  else
    raise "Don't know how to handle URL: #{source_url}"
  end
end

# Executes the download spec and yields to the given block with the path to the
# extracted (subdirectory of the) archive. Cleans up any downloaded/extracted
# files before it returns.
def execute_download_spec(download_spec)
  Dir.mktmpdir do |workdir|
    puts "Downloading from: #{download_spec[:url]}"
    open(File.join(workdir, "archive"), 'wb') do |file|
      file << open(download_spec[:url]).read
    end
    puts "Extracting archive:"
    runcmd %Q`cd "#{workdir}" && #{download_spec[:cmd]} archive && rm archive`

    dir = Dir[File.join(workdir, "*")][0]
    dir = File.join(dir, download_spec[:subdir]) if download_spec[:subdir]
    yield(dir)
  end
end



if ARGV.length != 1
  STDERR.puts <<EOD
Usage:
  # To redeploy/reimport an existing app:
  #{$0} <app-name>

  # To deploy/import a new app:
  #{$0} <gist-or-github-url>
EOD
  exit 1
end

root = File.dirname(File.dirname(File.absolute_path($0)))
app = ARGV[0]
if app =~ /^https?:/
  new_app(root, app)
else
  existing_app(root, app)
end
