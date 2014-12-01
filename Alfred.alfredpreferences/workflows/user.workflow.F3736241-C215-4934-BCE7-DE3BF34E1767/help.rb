require File.join(File.dirname(__FILE__), 'alfred_feedback.rb')

keyword = ARGV[0]

feedback = Feedback.new

if keyword == 'dex'

	subtitleString = 'Pokémon Info: Type and Forms'

	feedback.add_item({
		:title => 'dex [Pokémon name or National number]',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

	subtitleString = 'Keywords: lvl, tm, hm, egg, evo, location, stats, ability, langs, shiny'

	feedback.add_item({
		:title => 'dex [Pokémon name] [keyword]',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

	subtitleString = 'Keywords Help'

	feedback.add_item({
		:title => 'dex [Pokémon name] [keyword] /help',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

elsif keyword == 'move'

	subtitleString = 'Type, Category, Description, Power, Accuracy, PP, Probability'

	feedback.add_item({
		:title => 'move [Move name or TM/HM number]',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

	subtitleString = 'Keywords: lvl, tm, egg, tutor'

	feedback.add_item({
		:title => 'move [Move name] [keyword]',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

elsif keyword == 'ability'

	subtitleString = 'Description'

	feedback.add_item({
		:title => 'ability [Ability name]',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

	subtitleString = 'Abilities by Pokémon'

	feedback.add_item({
		:title => 'ability [Ability name] pkm',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

elsif keyword == 'item'

	subtitleString = 'Description'

	feedback.add_item({
		:title => 'item [Item name]',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})


elsif keyword == 'location'

	subtitleString = 'Lists all Pokémon found in this location'

	feedback.add_item({
		:title => 'location [Location name]',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

elsif keyword == 'evo'

	subtitleString = 'Lists all Pokémon with desired evolution condition'

	feedback.add_item({
		:title => 'evo [Condition]',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

	subtitleString = '"evo leaf stone" | "evo trade"'

	feedback.add_item({
		:title => 'Examples:',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

elsif keyword == 'lvl'

	subtitleString = 'Moves learnt by Level up'

	feedback.add_item({
		:title => 'Moves learnt by Level up',
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

	subtitleString = '"dex bulbasaur lvl grass"'

	feedback.add_item({
		:title => 'Move Types as filters',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

elsif keyword == 'hm'

	subtitleString = 'Moves learnt by HM'

	feedback.add_item({
		:title => 'Moves learnt by HM',
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

	subtitleString = '"dex bulbasaur hm grass"'

	feedback.add_item({
		:title => 'Move Types as filters',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

elsif keyword == 'tm'

	subtitleString = 'Moves learnt by TM'

	feedback.add_item({
		:title => 'Moves learnt by TM',
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

	subtitleString = '"dex bulbasaur tm grass"'

	feedback.add_item({
		:title => 'Move Types as filters',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

elsif keyword == 'egg'

	subtitleString = 'Moves learnt by Breeding'

	feedback.add_item({
		:title => 'Moves learnt by Breeding',
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

	subtitleString = '"dex bulbasaur egg grass"'

	feedback.add_item({
		:title => 'Move Types as filters',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

elsif keyword == 'langs'

	subtitleString = 'Pokémon name in other languages'

	feedback.add_item({
		:title => 'Pokémon name in other languages',
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

elsif keyword == 'pkm-ability'

	subtitleString = 'Pokémon Abilities'

	feedback.add_item({
		:title => 'Pokémon Abilities',
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

elsif keyword == 'stats'

	subtitleString = 'Use keywords for Pokémons with multiple forms'

	feedback.add_item({
		:title => '"dex mewtwo mega y"',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

	subtitleString = 'mega, mega y, blade, attack, etc'

	feedback.add_item({
		:title => 'Keywords Examples',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})
	
elsif keyword == 'pkm-location'

	subtitleString = 'To view Rarity in an specific area, use location name'

	feedback.add_item({
		:title => '"dex pidgey location [filters]"',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

	subtitleString = '"dex pidgey location route 2"'

	feedback.add_item({
		:title => 'Filter Example',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})
	
elsif keyword == 'pkm-evo'

	subtitleString = 'Evolution chains and required conditions for evolution'

	feedback.add_item({
		:title => 'Evolution Chain',
		:subtitle => subtitleString,
		:arg => subtitleString + "@info",
		:icon => {:type => "filetype", :name => "help-pokeball.png"}
	})

end

puts feedback.to_xml

