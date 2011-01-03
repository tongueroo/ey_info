class TextInjector
  def initialize(options={})
    @options = options

    @options[:file] ||= raise "required :file option missing"
    @identifier ||= (@options[:identifier] || default_identifier)
    @content ||= @options[:content]

    if @options[:update] && !File.exists?(@options[:file])
      warn("[fail] Can't find file: #{@options[:file]}")
      exit(1)
    end

    if @options[:update] && @options[:write]
      warn("[fail] Can't update AND write. choose one.")
      exit(1)
    end
  end

  # both setter and getter for the dsl
  def content(text = nil)
    text.nil? ? @content : @content = text
  end
  def identifier(id = nil)
    id.nil? ? @identifier : @identifier = id
  end

  def run
    if @options[:update]
      write_file(updated_file)
    elsif @options[:write]
      write_file(marked_content)
    else
      puts marked_content
      exit
    end
  end

protected

  def default_identifier
    File.expand_path(@options[:file])
  end

  def marked_content
    @marked_content ||= [comment_open, @content, comment_close].join("\n")
  end

  def read_file
    return @current_file if @current_file
    results = ''
    File.open(@options[:file], 'r') {|f| results = f.readlines.join("") }
    @current_file = results
  end

  def write_file(contents)
    File.open(@options[:file], 'w') do |file|
      file.write(contents)
    end
  end

  def updated_file
    # Check for unopened or unclosed identifier blocks
    if read_file.index(comment_open) && !read_file.index(comment_close)
      warn "[fail] Unclosed indentifier; Your file contains '#{comment_open}', but no '#{comment_close}'"
      exit(1)
    elsif !read_file.index(comment_open) && read_file.index(comment_close)
      warn "[fail] Unopened indentifier; Your file contains '#{comment_close}', but no '#{comment_open}'"
      exit(1)
    end

    # If an existing identifier block is found, replace it with the content text
    if read_file.index(comment_open) && read_file.index(comment_close)
      read_file.gsub(Regexp.new("#{comment_open}.+#{comment_close}", Regexp::MULTILINE), marked_content)
    else # Otherwise, append the new content after
      [read_file, marked_content].join("\n\n")
    end
  end

  def comment_base
    "TextInjector marker for: #{@identifier}"
  end

  def comment_open
    "# Begin #{comment_base}"
  end

  def comment_close
    "# End #{comment_base}"
  end

end
