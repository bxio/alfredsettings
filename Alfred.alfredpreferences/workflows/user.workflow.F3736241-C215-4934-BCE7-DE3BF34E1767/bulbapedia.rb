string = ARGV[0]

items = []
link = '"http://bulbapedia.bulbagarden.net/wiki/'

s = string.split('@')
info = s.last

if info == 'multiple' or info == 'type'
	
	if string.include? ','
		s = string.split(',')
	
		if info == 'multiple'
			complement = '_(Pokémon)"'
		else
			complement = '_(type)"'
		end
	
		s.each do |type|
			array = type.split('@')
			items.push(array[0])
		end
	
		items.each {|p| `open #{link}#{p}#{complement}`}
	else
		item = s[0]
		`open #{link}#{item}_(type)"`
	end

else 

	item = s[0]

	if item == 'nidoran-m'
		item = 'Nidoran♂'
	elsif item == 'nidoran-f'
		item = 'Nidoran♀'
	end
	
	# item = item.force_encoding("UTF-8")

	i = item.split(' ')
	dashedName = i.join('_')

	if info == 'pkm'
		`open #{link}#{item}_(Pokémon)"`

	elsif info == 'move'
		`open #{link}#{dashedName}_(move)"`
	
	elsif info == 'ability'
		`open #{link}#{dashedName}_(Ability)"`

	elsif info == 'item'
		`open #{link}#{dashedName}"`

	end
end
