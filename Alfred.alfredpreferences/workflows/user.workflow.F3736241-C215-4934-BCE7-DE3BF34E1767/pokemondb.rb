string = ARGV[0]

items = []

s = string.split('@')
info = s.last

if info == 'multiple' or info == 'type'
	
	if string.include? ','
		s = string.split(',')
	
		if info == 'multiple'
			link = 'http://www.pokemondb.net/pokedex/'
		else
			link = 'http://pokemondb.net/type/'
		end
	
		s.each do |type|
			array = type.split('@')
			items.push(array[0])
		end
		
		items.each {|p| `open #{link}#{p}`}
	else
		item = s[0]
		`open http://pokemondb.net/type/#{item}`
	end
else 

	item = s[0]

	i = item.split(' ')
	dashedName = i.join('-')
	dashedName.delete!("'")

	if info == 'pkm'
		`open http://www.pokemondb.net/pokedex/#{item}`

	elsif info == 'move'
		`open http://pokemondb.net/move/#{dashedName}`
	
	elsif info == 'ability'
		`open http://pokemondb.net/ability/#{dashedName}`

	elsif info == 'item'
		`open http://pokemondb.net/item/#{dashedName}`

	end
end

