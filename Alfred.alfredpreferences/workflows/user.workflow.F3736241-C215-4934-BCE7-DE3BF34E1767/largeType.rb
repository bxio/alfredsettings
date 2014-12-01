string = ARGV[0]

s = string.split('@')
large = s[1]

if s[1] == s.last
	large = s[0]
elsif s.length > 3
	large = s[2]
end

puts large