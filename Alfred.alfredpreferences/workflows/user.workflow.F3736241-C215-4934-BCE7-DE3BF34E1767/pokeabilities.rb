require 'yaml'
require File.join(File.dirname(__FILE__), 'alfred_feedback.rb')

class Pokeabilities
  ABILITIES_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'abilities.yml'))
  POKEABILITIES_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'pokeabilities.yml'))
  POKEMON_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'pokemon.yml'))

  def self.search(string)

	# string = 'pressure pkm'

  	s = string.split(' ')
  	string = s[0]
  	info = s[1]
  	filter = s[2]

    if string == "/help"

      feedback = `ruby ./help.rb "ability"`
      puts feedback

    else

    	if info == "pkm"

    		matches = {}

    		POKEABILITIES_DATA.each do |name, data|

    			data.each do |type, ability|

    				if type == 'Abilities'

    					ability.each_with_index do |abilityName, index|

    						if abilityName.downcase == string.downcase
    							if index == 0
    								matches[name] = "First Ability"
    							elsif index == 1
    								matches[name] = "Second Ability"
    							end
    						end
    					end
    				else
    					if ability.downcase == string.downcase
    						matches[name] = "Hidden Ability"
    					end
    				end
    			end
    		end

    		feedback = Feedback.new

    		matches.each do |name, data|

    			if filter
    				if not name.downcase.include? filter.downcase
    					next
    				end
    			end

    			pokeMatches = POKEMON_DATA.select do |pokename, data|
    				pokename.downcase == name.downcase
    			end

    			pokenumber = pokeMatches[name]['number']

    			feedback.add_item({
  				:title => name,
  				:subtitle => data,
  				:autocomplete => name,
  				:arg => name + "@" + pokenumber + "@" + data + "@pkm",
  				:icon => {:type => "filetype", :name => "pokemon_sprites/#{pokenumber}.png"}
  	      })
    		end

    		puts feedback.to_xml
    	else

  		matches = ABILITIES_DATA.select do |name, data|
  		      name.downcase.include? string.downcase
  		    end

  	    feedback = Feedback.new

  	    matches.each do |name, data|

  	      feedback.add_item({
  				:title => name,
  				:subtitle => data['description'],
  				:autocomplete => name,
  				:arg => name + "@" + data['description'] + "@ability",
  				:icon => {:type => "filetype", :name => "icon.png"}
  	      })
  			  	
  		end
    end
	end

    puts feedback.to_xml

  end
end

Pokeabilities.search ARGV.join.strip