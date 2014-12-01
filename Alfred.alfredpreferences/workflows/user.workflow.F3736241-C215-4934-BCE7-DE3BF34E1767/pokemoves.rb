require 'yaml'
require File.join(File.dirname(__FILE__), 'alfred_feedback.rb')

class String
    def is_number?
       !!(self =~ /^[-+]?[0-9]+$/)
    end
end

class Pokemoves
  FILE_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'moves.yml'))
  POKEMON_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'pokemon.yml'))
  MOVESPOKE_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'movespoke.yml'))

  def self.search(string)

	# string = "tm10"

  	matches = nil

	s = string.split(' ')
    string = s[0]
    tempString = s[1]

    if string == '/help'

    	feedback = `ruby ./help.rb "move"`
    	puts feedback

    else

	    if tempString == "tm" or tempString == "egg" or tempString == "lvl" or tempString == "tutor"
	    	filter = tempString
			pokefilter = s[2]
	    elsif tempString
	    	string = s[0] + ' ' + s[1]
	    	filter = s[2]
		   	pokefilter = s[3]
	    end


		if filter == "lvl"

			matches = MOVESPOKE_DATA.select do |name, data|
			      name.downcase.include? string.downcase
			end

			feedback = Feedback.new

	    	matches.each do |name, data|

	    		if pokefilter
		    		pokematches = data['Level Up'].select do |pokename|
		    			pokename.downcase.include? pokefilter.downcase
		    		end
		    	else
		    		pokematches = data['Level Up']
		    	end

	    		pokematches.each do |pokename, level|	    			

	    			pokemons = POKEMON_DATA.select do |name, data|
	    				name.downcase == pokename.downcase
	    			end

	    			pokenumber = pokemons[pokename]['number']

	    			feedback.add_item({
						:title => pokename,
						:subtitle => level,
						:autocomplete => pokename,
						:arg => pokename + "@" + pokenumber + "@pkm",
						:icon => {:type => "filetype", :name => "pokemon_sprites/#{pokenumber}.png"}
		      		})

	    		end
	    	end

		elsif filter == "tm"

			matches = MOVESPOKE_DATA.select do |name, data|
			      name.downcase.include? string.downcase
			end

			feedback = Feedback.new

	    	matches.each do |name, data|

	    		if pokefilter
		    		pokematches = data['TM'].select do |pokename|
		    			pokename.downcase.include? pokefilter.downcase
		    		end
		    	else
		    		pokematches = data['TM']
		    	end

	    		pokematches.each do |pokename|

	    			pokemons = POKEMON_DATA.select do |name, data|
	    				name.downcase == pokename.downcase
	    			end

	    			pokenumber = pokemons[pokename]['number']

	    			feedback.add_item({
						:title => pokename,
						:autocomplete => pokename,
						:arg => pokename + "@" + pokenumber + "@pkm",
						:icon => {:type => "filetype", :name => "pokemon_sprites/#{pokenumber}.png"}
		      		})

	    		end
	    	end

	    elsif filter == "egg"

			matches = MOVESPOKE_DATA.select do |name, data|
			      name.downcase.include? string.downcase
			end

			feedback = Feedback.new

	    	matches.each do |name, data|

	    		if pokefilter
		    		pokematches = data['Egg Moves'].select do |pokename|
		    			pokename.downcase.include? pokefilter.downcase
		    		end
		    	else
		    		pokematches = data['Egg Moves']
		    	end

	    		pokematches.each do |pokename|

	    			pokemons = POKEMON_DATA.select do |name, data|
	    				name.downcase == pokename.downcase
	    			end

	    			pokenumber = pokemons[pokename]['number']

	    			feedback.add_item({
						:title => pokename,
						:autocomplete => pokename,
						:arg => pokename + "@" + pokenumber + "@pkm",
						:icon => {:type => "filetype", :name => "pokemon_sprites/#{pokenumber}.png"}
		      		})

	    		end
	    	end

		elsif filter == "tutor"

			matches = MOVESPOKE_DATA.select do |name, data|
			      name.downcase.include? string.downcase
			end

			feedback = Feedback.new

	    	matches.each do |name, data|

	    		if pokefilter
		    		pokematches = data['Tutor'].select do |pokename|
		    			pokename.downcase.include? pokefilter.downcase
		    		end
		    	else
		    		pokematches = data['Tutor']
		    	end

				pokematches.each do |pokename|

	    			pokemons = POKEMON_DATA.select do |name, data|
	    				name.downcase == pokename.downcase
	    			end

	    			pokenumber = pokemons[pokename]['number']

	    			feedback.add_item({
						:title => pokename,
						:autocomplete => pokename,
						:arg => pokename + "@" + pokenumber + "@pkm",
						:icon => {:type => "filetype", :name => "pokemon_sprites/#{pokenumber}.png"}
		      		})

	    		end
	    	end

		else

			if string =~ /\d/
				s = string.scan(/\d+|\D+/)
				
				if s[1].length == 1
					s[1] = "0" + s[1]
				end
				
				string = s[0].upcase + s[1]

				if string.include? "TM" or string.include? "HM"
			        matches = FILE_DATA.select do |name, data|
			          data['tm'] == string
			        end
		    	end
			else
				matches = FILE_DATA.select do |name, data|
		    	  name.downcase.include? string.downcase
		    	end
		    end

			feedback = Feedback.new

		    matches.each do |name, data|

		      if data['tm']
					feedback.add_item({
						:title => "#{name} (#{data['tm']})",
						:autocomplete => "#{name}",
						:arg => name + "@move",
						:icon => {:type => "filetype", :name => "types_img/#{data['type']}.png"}
			      	})
				else
					feedback.add_item({
						:title => "#{name}",
						:autocomplete => "#{name}",
						:arg => name + "@move",
						:icon => {:type => "filetype", :name => "types_img/#{data['type']}.png"}
			      	})
				end
				
				moveStats = ''
				
				if data['power'].is_number?
					moveStats += "Power: #{data['power']}"
				end
				
				if data['accuracy'].is_number?
				
					if data['power'].is_number?
						moveStats += ", "
					end
					moveStats += "Acc.: #{data['accuracy']}"
				end
				
				if data['pp'].is_number?
				
					if data['accuracy'].is_number?
						moveStats += ", "
					end
					moveStats += "PP: #{data['pp']}"
				end
				
				if data['probability'].is_number?
				
					if data['pp'].is_number?
						moveStats += ", "
					end
					moveStats += "Prob.: #{data['probability']}%"
				end

				if data['description'] != ''

			      feedback.add_item({
						:title => data['description'],
						:subtitle => moveStats,
						:arg => data['description'] + '@not',
						:icon => {:type => "filetype", :name => "categories_img/#{data['category']}.png"}
			      })
			  else

			  	feedback.add_item({
						:title => moveStats,
						:arg => moveStats + '@not',
						:icon => {:type => "filetype", :name => "categories_img/#{data['category']}.png"}
			      })

			  end
			  	
			end
		
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

Pokemoves.search ARGV.join.strip