# frozen_string_literal: true

image_name = "mini-cinema-bot"

desc 'Build docker image'
task :build do
  exec("docker build -t #{image_name} .")
end

desc 'Run bot'
task :run do
  exec("docker run --rm --it -p 3000:3000 #{image_name} server")
end

namespace :lambda do
  desc 'Build docker image for Lambda'
  task :build do
    exec("docker build -t #{image_name}-lambda -f lambda/Dockerfile .")
  end

  desc 'Run bot under Lambda environment'
  task :run do
    exec("docker run --rm -it #{image_name}-lambda sh")
  end
end
