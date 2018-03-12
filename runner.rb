require 'os'
require_relative 'merge_reports'

#set the report name for merged parallel reports.
REPORT = "rspec.html"

#merge parallel_rspec reports into one report...
def merge_rspec_reports
  reports = Dir.glob("./output/rspec*.html")
  unless reports.empty?
    report_merger reports, REPORT if reports.count > 1
  end
end

#delete old test reports
reports = Dir.glob("./output/rspec*")
reports.each { |report| File.delete(report) } unless reports.empty?
File.delete("failures.txt") if File.exists? "failures.txt" unless ARGV[0] == "failures"

specs = Dir["spec/*_spec.rb*"]
spec_list = specs.map { |x| x.split("/").last }

args = ARGV
if args.empty?
  puts "Running tests: #{spec_list}"
  system("rspec spec")
elsif ARGV[0] == "specs"
  puts spec_list
elsif ARGV[0] == "parallel"
  puts "Running tests: #{spec_list}"
  system("parallel_rspec spec")
  merge_rspec_reports
elsif ARGV[0] == "failures"
  system("rspec spec --only-failures")
else
  tests = []
  args[0..100].each do |arg|
    spec = arg.downcase
    test = specs.find_all { |x| x.include? spec }
    if test.empty?
      puts "Unknown spec(s) #{spec}. Please specify a valid spec: #{spec_list}\n or service: #{services}"
      abort
    else
      tests << test
    end
  end
  tests = tests.join(" ")
  puts "Running tests: #{tests}"
  system("rspec #{tests}")
end

if OS.mac?
  %x(open output/#{REPORT}) unless File.zero? "output/#{REPORT}"
end