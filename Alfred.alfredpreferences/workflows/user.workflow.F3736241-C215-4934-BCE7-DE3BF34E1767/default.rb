string = ARGV[0]
default = `cat userdefault`

if string.include? '@'
	s = string.split('@')
	item = s[0]
	info = s.last
end

if info == 'type'

	`osascript ./alfred.scpt "#{item}" "type"`

else
	if default == 'serebii'
		`ruby ./serebii.rb "#{string}"`
	elsif default == 'pokemondb'
		`ruby ./pokemondb.rb "#{string}"`
	elsif default == 'bulbapedia'
		`ruby ./bulbapedia.rb "#{string}"`
	else
		`ruby ./setdefault.rb "serebii"`
	end
end