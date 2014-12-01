require File.join(File.dirname(__FILE__), 'alfred_feedback.rb')

hash_of_sites = {'Serebii.net' => 'serebii', 'PokémonDB' => 'pokemondb', 'Bulbapedia' => 'bulbapedia'}

feedback = Feedback.new

hash_of_sites.each do |name, url|

	feedback.add_item({
		:title => name,
		:autocomplete => name,
		:arg => url,
		:icon => {:type => "filetype", :name => "icon.png"}
	})

end

puts feedback.to_xml