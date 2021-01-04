# frozen_string_literal: true

image_name = "mini-cinema-bot"

desc 'Build docker image'
task :build do
  system("docker build -t #{image_name} .")
end

desc 'Run bot'
task run: :build do
  exec("docker run --rm -p 3000:3000 #{image_name} server")
end

namespace :lambda do
  desc 'Build docker image for Lambda'
  task :build do
    system("docker build -t #{image_name}-lambda -f lambda/Dockerfile .")
  end

  desc 'Run bot under Lambda environment'
  task run: :build do
    exec("docker run --rm -it #{image_name}-lambda sh")
  end

  desc 'Package Lambda'
  task package: :build do
    exec("docker run --rm -v #{Dir.pwd}/dist:/dist #{image_name}-lambda zip -r /dist/package.zip . -x '*.git*' -x 'dist/*' -x '.bundle/*'")
  end
end
