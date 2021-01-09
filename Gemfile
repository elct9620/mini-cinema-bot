# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "rails"

gem "nokogiri", "~> 1.10"
gem "line-bot-api", "~> 1.17"
gem "oj", "~> 3.10"

group :web do
  gem "puma", "~> 5.1"
  gem "rack", "~> 2.2"
end

group :development, :test do
  gem "rspec"
end

group :development do
  gem "rake"
end
