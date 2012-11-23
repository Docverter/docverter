require "bundler/gem_tasks"

task :server do
  sh "jruby -S rackup -Ilib -s mizuno -p 9595"
end

task :build_examples do
  sh "mkdir -p public/examples"
  Dir.chdir('examples') do
    Dir.glob('*') do |example_name|
      next unless File.directory?(example_name)
      puts example_name

      Dir.chdir(example_name) do
        sh "zip ../../public/examples/#{example_name}.zip *"
        output = `./convert.sh #{args[:api_key]}`.strip
        sh "mv #{output} ../../public/examples"
      end
    end
  end
end


