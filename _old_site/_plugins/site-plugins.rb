require 'pp'
require 'ostruct'

module SitePlugins

  class AnswerTag < Liquid::Block
    def initialize(tag_name, prompt, tokens)
      super
      @prompt = prompt == "" ? "Reveal answer" : prompt
    end

    def render(context)
      content = Kramdown::Document.new(super).to_html
      "<div class=\"answer\"><a class=\"btn btn-default answer-toggle\" href=\"#\">#{@prompt}</a><div class=\"answer-content\">#{content}</div></div>"
    end
  end


  module Filters
    def incr(input)
      input.to_i + 1
    end

    def decr(input)
      input.to_i - 1
    end

    def sorted_tags(input)
      input.keys.sort do |a, b|
        result = input[b].length - input[a].length
        result = a.casecmp(b) if result == 0
        result
      end
    end

    def length(input)
      input.length
    end

    def pp(input)
      pp::pp(input)
      input
    end

    # It's super slow to iterate over all the docs, so build a cache each time
    # we render the site.
    @@post_cache = {}
    Jekyll::Hooks.register :site, :pre_render do |site|
      @@post_cache.clear()
      # Build post cache
      site.posts.docs.each do |x|
        @@post_cache[x.url] = {
          "title" => x.data["title"],
          "description" => x.data["description"],
          "url" => x.url,
          "data" => x.data,
          "content" => x.content
        }
      end
    end

    def find_post(name)
      where = @context.registers[:page]["child_scope"] || "/articles/"
      qualified_name = "#{where}#{name}.html"
      @@post_cache[qualified_name] || raise("Couldn't find article '#{qualified_name}'")
    end

    def find_app_story(name)
      where = @context.registers[:page]["child_scope"] || "/app-stories/"
      qualified_name = "#{where}#{name}.html"
      @@post_cache[qualified_name] || raise("Couldn't find case study '#{qualified_name}'")
    end

    def find_blog_post(name)
      where = @context.registers[:page]["child_scope"] || "/blog/"
      qualified_name = "#{where}#{name}.html"
      @@post_cache[qualified_name] || raise("Couldn't find blog post '#{qualified_name}'")
    end

    def identifier(input)
      input.downcase.gsub(/ /, '-').gsub(/[^\w\-]/, '')
    end
  end

  class TagPage < Jekyll::Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(base, "_layouts"), "tag.html")
      self.data["tag"] = tag

      self.data["title"] = "Gallery - #{tag}"
    end
  end

  class TagPageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      if site.layouts.key? "tag"
        dir = "gallery/tags"
        site.tags.keys.each do |tag|
          site.pages << TagPage.new(site, site.source, File.join(dir, tag), tag)
        end
      end
    end
  end

  class RecentAppsPage < Jekyll::Page
    def initialize(site, base, dir, paginator)
      @site = site
      @base = base
      @dir = dir
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(base, "_layouts"), "recentapps.html")
      self.data["paginator"] = paginator
      self.data["title"] = "Recent Apps - Page #{paginator.page}"
      self.data["page"] = paginator.page
      self.data["posts"] = paginator.posts
      self.data["total_posts"] = paginator.total_posts
      self.data["total_pages"] = paginator.total_pages
      self.data["previous_page"] = paginator.previous_page
      self.data["previous_page_path"] = paginator.previous_page_path
      self.data["next_page"] = paginator.next_page
      self.data["next_page_path"] = paginator.next_page_path
    end
  end

  # class ArticleIndex < Jekyll::Generator
  #   safe true

  #   def find_post(site, pattern)
  #     site.posts.find do |x|
  #       x.path =~ pattern
  #     end
  #   end

  #   def generate(site)
  #     site.data["articles"].each do |group|
  #       group["pages"].collect! do |page|
  #         return page unless page.is_a? String
  #         this_page = find_post site, /articles\/_posts\/\d{4}-\d{2}-\d{2}-#{Regexp::escape(page)}\.md/
  #         raise "Page not found: #{page}" unless this_page
  #         { "title" => this_page.data["title"], "filename" => page }
  #       end
  #     end
  #   end
  # end

  class RecentAppsGenerator < Jekyll::Generator
    safe true

    def link_for_page(site, page)
      if (page == 1)
        "#{site.baseurl}/gallery/recent/"
      else
        "#{site.baseurl}/gallery/recent/page#{page}"
      end
    end

    def generate(site)
      if site.layouts.key? "recentapps"
        dir = "gallery/recent"
        paginate = site.config["apps_per_page"] || 12
        pages = (site.categories["gallery"].length / paginate.to_f).ceil
        for pagenum in 0...pages
          this_dir = pagenum == 0 ? dir : File.join(dir, "page#{pagenum+1}")
          site.pages << RecentAppsPage.new(site, site.source, this_dir,
            OpenStruct.new(
              page: pagenum+1,
              per_page: paginate,
              posts: site.categories["gallery"][(pagenum * paginate)...((pagenum+1) * paginate)],
              total_posts: site.categories["gallery"].length,
              total_pages: pages,
              previous_page: pagenum == 0 ? nil : pagenum,
              previous_page_path: pagenum == 0 ? nil : link_for_page(site, pagenum),
              next_page: pagenum == pages-1 ? nil : pagenum+2,
              next_page_path: pagenum == pages-1 ? nil : link_for_page(site, pagenum+2)
            )
          )
        end
      end
    end
  end

  Jekyll::Hooks.register :site, :post_write do |site|
    `afplay done.mp3` if File.exists? "done.mp3"
  end
end

Liquid::Template.register_tag('answer', SitePlugins::AnswerTag)
Liquid::Template.register_filter(SitePlugins::Filters)
