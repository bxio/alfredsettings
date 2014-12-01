require 'yaml'
require File.join(File.dirname(__FILE__), 'alfred_feedback.rb')

class SearchLocations
  POKEMON_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'pokemon.yml'))
  POKELOCATIONS_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'pokelocations.yml'))

  def self.search(string)

	# string = "route 2"
    
    matches = {}
    placesArray = []
    results = false

    POKELOCATIONS_DATA.each do |pokename, data|
      data['Locations'].each do |game, places|

       data['Locations'][game].keys.each do |place|

        if place.downcase.include? string.downcase
          if not placesArray.include? place
            placesArray << place
          end
        end
      
        if place.downcase == string.downcase

          results = true

          if not matches[pokename]
            matches[pokename] = {}
          end
    
          string = place
          matches[pokename].merge!(game => places)  
        end
      end
      end
    end

    feedback = Feedback.new

    if results == false
      placesArray.each do |name|

        feedback.add_item({
          :title => name,
          :autocomplete => name,
          :arg => name + '@' + name + '@not',
          :icon => {:type => "filetype", :name => "icon.png"}
        })

      end
    end

    matches.each do |pokename, data|

      pokenumber = ''

      pokemons = POKEMON_DATA.select do |name, data|
        name.downcase == pokename.downcase
      end

      pokenumber = pokemons[pokename]['number']

      subtitleArray = []
      gamesArray = []

      if data['X']

        gamesArray << 'X'

        data['X'][string].each do |method, methodData|
        
          str = method + ": " + methodData['Rarity']

          if not subtitleArray.include? str
            subtitleArray << str
          end
        end
      end

      if data['Y']

        gamesArray << 'Y'

        data['Y'][string].each do |method, methodData|
        
          str = method + ": " + methodData['Rarity']

          if not subtitleArray.include? str
            subtitleArray << str
          end
        end
      end

      subtitleString = gamesArray.join(', ')
      if subtitleArray.count > 0
        subtitleString += ' ● ' + subtitleArray.join(', ')
      end

     	feedback.add_item({
  			:title => pokename,
  			:subtitle => subtitleString,
  			:autocomplete => string,
  			:arg => pokename + '@' + pokenumber + '@' + subtitleString + '@pkm',
  			:icon => {:type => "filetype", :name => "pokemon_sprites/#{pokenumber}.png"}
      })

	end

    if feedback.to_xml == '<items/>'

      feedback.add_item({
        :title => "No results found.",
        :icon => {:type => "filetype", :name => "icon.png"}
      })

    end		

    puts feedback.to_xml

  end
end

SearchLocations.search ARGV.join.strip