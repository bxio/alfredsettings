require 'yaml'
require File.join(File.dirname(__FILE__), 'alfred_feedback.rb')

class SearchEvoltuions
  EVOLUTIONS_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'evolutions.yml'))
  POKEMON_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'pokemon.yml'))

  def self.search(string)

    # string = "leaf"

    if string == "/help"

      feedback = `ruby ./help.rb "evo"`
      puts feedback

    else

    	conditions = {}

      EVOLUTIONS_DATA.each do |name, data|
        data.each_with_index do |i, index|
          
          if not index % 2 == 0
            
            if not i == ''

              if i.downcase.include? string.downcase
                conditions[data[index - 1]] = i
              end
            end
          end
        end
      end

      feedback = Feedback.new

      conditions.each do |pokename, condition|

        pokenumber = ''

        pokemons = POKEMON_DATA.select do |name, data|
          name.downcase == pokename.downcase
        end

        pokemons.each do |name, data|
          pokenumber = data['number']
        end

       	feedback.add_item({
    			:title => pokename,
    			:subtitle => condition,
    			:autocomplete => pokename,
    			:arg => pokename + '@' + pokenumber + '@' + condition + '@pkm',
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
end

SearchEvoltuions.search ARGV.join.strip