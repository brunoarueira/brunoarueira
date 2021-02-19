# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'rss'
end

require 'open-uri'

FEED_URL = 'https://www.brunoarueira.com/feed.xml'
README_FILE = 'README.md'
LATEST_BLOG_POSTS_REGEX = /^<!-- blog starts -->.*<!-- blog ends -->$/im.freeze

def blog_entries
  entries = []

  URI.open(FEED_URL) do |rss|
    feed = RSS::Parser.parse(rss)

    feed.items.each do |item|
      entries << ["[#{item.title}](#{item.link})"]
    end
  end

  entries
end

latest_blog_posts = <<~REPLACE
  <!-- blog starts -->
  #{blog_entries.join("\n\n")}
  <!-- blog ends -->
REPLACE

readme_content = File.read(README_FILE)

readme_content.gsub!(LATEST_BLOG_POSTS_REGEX, latest_blog_posts)

File.open(README_FILE, 'w') do |f|
  f.write(readme_content)
end
