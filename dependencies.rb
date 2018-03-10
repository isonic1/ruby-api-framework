def ruby_version
  `ruby -v`.split[1][0..4].to_f
end

def ruby_version_ok? version = 2.2
  ruby_version >= version
end

def remove_gemfile_lock file = "Gemfile.lock"
  File.delete file if File.exists? file
end

def install_dependencies
  remove_gemfile_lock
  system("gem install bundler")
  require 'bundler'
  Bundler.with_clean_env do
    `bundle install`
    `bundle update`
  end
end

if ruby_version_ok?
  install_dependencies
else
  puts "\nIt appears your Ruby version #{ruby_version} is outdated. Please install Ruby 2.2 or greater"
  puts "It's HIGHLY recommended to use a Ruby package manager like RVM or RBENV."
  puts "See here: https://www.ruby-lang.org/en/documentation/installation/\n"
  abort
end