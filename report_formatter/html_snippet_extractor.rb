class HtmlSnippetExtractor
  # @private
  module NullConverter
    def self.convert(code)
      %Q(#{code}\n<span class="comment"># Install the coderay gem to get syntax highlighting</span>)
    end
  end

  # @private
  module CoderayConverter
    def self.convert(code)
      CodeRay.scan(code, :ruby).html(:line_numbers => false)
    end
  end

  @@converter = NullConverter
  begin
    require 'coderay'
    @@converter = CoderayConverter
  rescue LoadError
    
  end

  def snippet(backtrace)
    raw_code, line = snippet_for(backtrace[0])
    highlighted = @@converter.convert(raw_code)
    post_process(highlighted, line)
  end
  
  def snippet_for(error_line)
    if error_line =~ /(.*):(\d+)/
      file = Regexp.last_match[1]
      line = Regexp.last_match[2].to_i
      [lines_around(file, line), line]
    else
      ["# Couldn't get snippet for #{error_line}", 1]
    end
  end

  def lines_around(file, line)
    if File.file?(file)
      lines = File.read(file).split("\n")
      describes_contexts = lines.each_index.select { |i| lines[i].include? "context" or lines[i].include? "describe" or lines[i].include? 'it "' }
      diff = line - describes_contexts.select { |n| n < line }.last
      @offset = diff - 3
      min = [0, line - diff].max
      max = [line + 1, lines.length - 1].min
      selected_lines = []
      selected_lines.join("\n")
      lines[min..max].join("\n")
    else
      "# Couldn't get snippet for #{file}"
    end
  rescue SecurityError
    "# Couldn't get snippet for #{file}"
  end

  def post_process(highlighted, offending_line)
    new_lines = []
    highlighted.split("\n").each_with_index do |line, i|
      new_line = "<span class=\"linenum\">#{offending_line + i - (2 + @offset)}</span>#{line}"
      new_line = "<span class=\"offending\">#{new_line}</span>" if i == (2 + @offset)
      new_lines << new_line
    end
    new_lines.join("\n")
  end
end