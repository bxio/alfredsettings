string = ARGV[0]

items = []

s = string.split('@')
info = s.last

if info == 'multiple' or info == 'type'
	
	if string.include? ','
		s = string.split(',')
		index = 0
		
		if info == 'multiple'
			index = 1
		end
		
		s.each do |type|
			array = type.split('@')
			items.push(array[index])
		end
		
		items.each {|p| `open http://www.serebii.net/pokedex-xy/#{p.downcase}.shtml`}
	else
		item = s[0]
		`open http://www.serebii.net/pokedex-xy/#{item.downcase}.shtml`
	end
	
else 

	item = s[0]
	number = s[1]

	if info == 'pkm'
		`open http://www.serebii.net/pokedex-xy/#{number}.shtml`

	elsif info == 'move'
		item.delete!(' ')
		`open http://www.serebii.net/attackdex-xy/#{item.downcase}.shtml`
	
	elsif info == 'ability'
		item = item.delete(' ')
		`open http://www.serebii.net/abilitydex/#{item.downcase}.shtml`

	elsif info == 'item'
		item.delete!(' ')
		item.delete!("'")
		`open http://www.serebii.net/itemdex/#{item.downcase}.shtml`

	end
end
