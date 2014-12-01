default = ARGV[0]
File.open(File.join(File.dirname(__FILE__), 'userdefault'), 'w') {|f| f.write(default.to_s) }