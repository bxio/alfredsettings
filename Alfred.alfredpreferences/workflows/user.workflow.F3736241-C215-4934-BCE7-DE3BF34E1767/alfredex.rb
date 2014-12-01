require 'yaml'
require File.join(File.dirname(__FILE__), 'alfred_feedback.rb')

class String
    def is_number?
       !!(self =~ /^[-+]?[0-9]+$/)
    end

    def remove_accents
    	self.tr(
	"ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
	"AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz")
    end
end

class Alfredex
	FILE_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'pokemon.yml'))
	POKEMOVES_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'pokemoves.yml'))
	MOVES_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'moves.yml'))
	EVOLUTIONS_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'evolutions.yml'))
	POKELOCATIONS_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'pokelocations.yml'))
	POKESTATS_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'pokestats.yml'))
	MEGASTATS_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'megastats.yml'))
	POKEABILITIES_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'pokeabilities.yml'))
	ABILITIES_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'abilities.yml'))

	def self.createAbilityFeedback(ability, type, feedback)

		a = []

		if ability.include? '('
			a = ability.split(' (')
			ability = a[0]
		end

		ability_match = ABILITIES_DATA.select do |n, d|
			n.downcase == ability.downcase
		end

		if a.length > 0
			ability = a[0] + " (" + a[1]
		end

		description = ''

		ability_match.each do |n, d|
			description = d['description']
		end

		icon = type

		feedback.add_item({
	        :title => ability,
	        :subtitle => description,
	        :autocomplete => ability,
          	:arg => ability.downcase + '@' + description + '@ability',
	        :icon => {:type => "filetype", :name => "abilities_img/#{icon}.png"}
	    })

	end

	def self.createTypeFeedback(form, firstType, secondType, feedback)

		titleString = firstType
		argString = firstType + "@type"
		imgString = firstType + ".png"

		if secondType
			titleString = firstType + " | " + secondType
			argString = firstType + "," + secondType + "@type"
			imgString = "/dual-types/" + firstType + "-" + secondType + ".gif"
		end

		feedback.add_item({
	      :title => titleString,
	      :subtitle => form,
	      :arg => argString,
	      :icon => {:type => "filetype", :name => "types_img/#{imgString}"}
	     })

		return feedback

	end

	def self.createMoveFeedback(name, lvl, data, feedback)
		
		subtitle = ''
		
		if lvl
			subtitle += "Level: #{lvl}"
		end

			titleString = name
			argString = name + '@move'

			if data['tm']
				titleString = "#{name} (#{data['tm']})"
			end 

			feedback.add_item({
				:title => titleString,
				:subtitle => subtitle,
				:autocomplete => name,
				:arg => argString,
				:icon => {:type => "filetype", :name => "types_img/#{data['type']}.png"}
	      	})
				
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
		
		return feedback
	
	end

  def self.search(string)
	
#	string = 'help'
	string = string.force_encoding("UTF-8")
	string = string.remove_accents

    matches = nil
    language = ''

    if string == "/help"
			
		feedback = `ruby ./help.rb "dex"`
		puts feedback

    elsif string.include? "," # contains separators, look up multiple
      string = string.delete(' ')
      mons = string.split(/[\/,\,]/).map{|n| n.strip.downcase }
      dashed_mons = mons.select{|m| m =~ /\-/}

      matches = FILE_DATA.select do |name, data|
        if mons.include? name.downcase
          true
        elsif dashed_mons.length > 0 # contains dash and doesn't match, split
          dashed_mons.any?{|m| m.split('-')[0] == name.downcase }
        end
      end

      # maximum 10 lookups, don't flood the user with tabs
      matches = matches.to_a[0..9]

      feedback = Feedback.new
      feedback.add_item({
        :title => "Find Multiple Pokemon",
        :subtitle => matches.map{|m| m[0]}.join(', '),
        :arg => matches.map{|m| m[1]['url_name'] + '@' + m[1]['number'] + '@multiple'}.join(","),
        :uid => matches.map{|m| m[1]['number'] }.join(','),
        :icon => {:type => "filetype", :name => "icon.png"}
      })

      puts feedback.to_xml

     else

     	s = string.split(' ')
	    string = s[0]
	    info = s[1]
	    filter = s[2]
	    misc = s[3]

		if string =~ /^[0-9]+$/ # numeric string, check pokemon number
	        matches = FILE_DATA.select do |name, data|
	          data['number'].to_i == string.to_i
	        end

	      else # check for name

		    matches = FILE_DATA.select do |name, data|
		    	if name.downcase.include? string.downcase
		    		language = 'en'
		    		data['language'] = language
		    		true
		    	elsif data['Romaji'].downcase.include? string.downcase or data['Kana'].include? string
		    		if language == ''
		    			language = 'jp'
		    		end
		    		data['language'] = language
		    		true
		    	elsif data['French'].downcase.remove_accents.include? string.downcase
		    		if language == ''
		    			language = 'fr'
		    		end
		    		data['language'] = language
		    		true
		    	elsif data['German'].downcase.remove_accents.include? string.downcase
		    		if language == ''
		    			language = 'de'
		    		end
		    		data['language'] = language
		    		true
		    	elsif data['Korean'].downcase.include? string.downcase
		    		if language == ''
		    			language = 'kr'
		    		end
		    		data['language'] = language
		    		true
		    	end
		    end

		    matches.each do |name, data|
		    	if name.downcase == string.downcase
		    		string = name
		    	elsif data['Kana'] == string or data['Romaji'].downcase == string.downcase or
		    		data['German'].downcase.remove_accents == string.downcase.remove_accents or 
		    		data['French'].downcase.remove_accents == string.downcase.remove_accents or data['Korean'] == string
		    		string = name
		    	else
		    		string = name
		    	end
		    end
		end

	    if info == 'langs'

	    	if filter == "/help"
			
				feedback = `ruby ./help.rb "langs"`
				puts feedback

			else

		    	feedback = Feedback.new

		    	matches.each do |name, data|

		    		languages = ['English', 'Kana', 'French', 'German', 'Korean']
		    		
		    		languages.each do |lang|

		    			titleString = ''
		    			img = ''

		    			if lang == 'English'
		    				titleString = "##{data['number'].to_i} #{name}"
		    				img = "pokemon_sprites/#{data['number']}.png"
		    			elsif lang == 'Kana'
		    				lang = 'Japanese'
		    				titleString = "#{data['Kana']} (#{data['Romaji']})"
		    				img = 'no_img.png'
		    			else
		    				titleString = data[lang]
		    				img = 'no_img.png'
		    			end

		    			autocomplete = titleString[/[^ (]+/]

		    			if lang == 'English' then autocomplete = name end

				    	feedback.add_item({
				          :title => titleString,
				          :subtitle => lang,
				          :autocomplete => autocomplete,
				          :arg => data['url_name'] + '@' + data['number'] + '@' + data['description'] + '@pkm',
				          :icon => {:type => "filetype", :name => img}
				        })
				    end
				end
		    end

		    puts feedback.to_xml

	    elsif info == 'ability'

	    	if filter == "/help"
			
				feedback = `ruby ./help.rb "pkm-ability"`
				puts feedback

			else

		    	matches = POKEABILITIES_DATA.select do |name, data|
					name.downcase == string.downcase
				end

				feedback = Feedback.new

				matches.each do |name, data|
					
					data.each do |type, ability|

						if type == "Abilities"

							ability.each do |item|

								self.createAbilityFeedback(item, "Normal", feedback)

							end

						else

							if type == "Mega" and data['Mega Y']
								type = "Mega X"
							end

							self.createAbilityFeedback(ability, type, feedback)

						end
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


	    elsif info == 'stats'

	    	if filter == "/help"
			
				feedback = `ruby ./help.rb "stats"`
				puts feedback

			else

		    	if filter == 'mega'

		    		matches = MEGASTATS_DATA.select do |name, data|
						name.downcase == string.downcase
					end

					feedback = Feedback.new

					matches.each do |name, data|

						if misc == 'y'
							
							if data['Mega Y']
								data['Mega Y'].each do |stat, value|

									feedback.add_item({
								        :title => value,
								        :autocomplete => name,
							          	:arg => name.downcase + '@pkm',
								        :icon => {:type => "filetype", :name => "stats_img/#{stat}.png"}
								    })
							    end
							end
						else 

							data['Mega'].each do |stat, value|

								feedback.add_item({
							        :title => value,
							        :autocomplete => name,
						          	:arg => name.downcase + '@pkm',
							        :icon => {:type => "filetype", :name => "stats_img/#{stat}.png"}
							    })
							end

						end
					end

				else

			    	matches = POKESTATS_DATA.select do |name, data|
						name.downcase == string.downcase
					end

					feedback = Feedback.new

					matches.each do |name, data|

						stats = data

						if data['forms']

							stats = data['normal']

							if filter
								if data['forms'].include? filter.downcase
									if data[filter]
										stats = data[filter]
									else
										stats = data['alternate']
									end
								end
							end
						end
						
						stats.each do |stat, value|

							feedback.add_item({
						        :title => value,
						        :autocomplete => name,
					          	:arg => name.downcase + '@pkm',
						        :icon => {:type => "filetype", :name => "stats_img/#{stat}.png"}
						    })

						end
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

	    elsif info == 'location'

	    	if filter == "/help"
			
				feedback = `ruby ./help.rb "pkm-location"`
				puts feedback

			else

		    	matches = POKELOCATIONS_DATA.select do |name, data|
					name.downcase == string.downcase
				end

				feedback = Feedback.new

				if filter

					if misc
						place = filter + ' ' + misc
					else
						place = filter
					end

				    placesMatches = {}

				    matches[string]['Locations'].each do |game, data|
				    	data.each do |location, placeData|
				    		if location.downcase.include? place.downcase
				    			if not placesMatches[location]
				    				placesMatches[location] = placeData
				    			end
				    			if not placesMatches[location]['Games']
				    				placesMatches[location].merge!('Games' => [])
				    			end			    		
				    			placesMatches[location]['Games'] << game
				    		end
				    	end
				    end

				    placesMatches.each do |location, placeData|
				  		
				    	subtitleString = ''
				    	subtitleArray = []

				    	placeData.each do |method, methodData|

				    		if method == 'Games'
				    			next
				    		end

				    		str = method + ": " + methodData['Rarity']

							if not subtitleArray.include? str
								subtitleArray << str
							end
				    	end

				    	if subtitleArray.count > 0
							subtitleString += subtitleArray.join(', ')
						end

						gamesString = placeData['Games'].join('')

						feedback.add_item({
					        :title => location,
					        :subtitle => subtitleString,
					        :autocomplete => name,
				          	:arg => name.downcase + '@' + subtitleString + '@pkm',
					        :icon => {:type => "filetype", :name => "games_img/#{gamesString}.png"}
						})
				    end

		    	else

					matches[string]['Locations'].each do |game, places|

						subtitleString = ''
						array = places.keys
						placesArray = []
						subtitleArray = []

						array.each do |nameplace|

							methods = places[nameplace].keys.join(', ')

							if not subtitleArray.include? methods and not methods == ''
								subtitleArray << methods
							end

							if nameplace.include? ' - '
								arr = nameplace.split(' - ')
								nameplace = arr[0]
							end

							if not placesArray.include? nameplace
								placesArray.push(nameplace)
							end
						end

						placesString = placesArray.join(', ')
						subtitleString = subtitleArray.join(' | ')

						feedback.add_item({
					        :title => placesString,
					        :subtitle => subtitleString,
					        :autocomplete => name,
				          	:arg => name.downcase + '@' + placesString + '@pkm',
					        :icon => {:type => "filetype", :name => "games_img/#{game}.png"}
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

		elsif info == 'evo'

			if filter == "/help"
			
				feedback = `ruby ./help.rb "pkm-evo"`
				puts feedback

			else
					
				evoMatches = EVOLUTIONS_DATA.select do |name, data|
					name.downcase == string.downcase
				end
				
				feedback = Feedback.new
				
				evoMatches.each do |name, data|
					
					if data.count > 0
						data.each_with_index do |item, index|
							
							if index % 2 == 0
							
								pokeMatches = FILE_DATA.select do |name, data|
						          name.downcase == item.downcase
						        end
						
								number = pokeMatches[item]['number']
								url_name = pokeMatches[item]['url_name']

								if language == 'jp'
									item = pokeMatches[item]['Kana']
								elsif language == 'de'
									item = pokeMatches[item]['German']
								elsif language == 'fr'
									item = pokeMatches[item]['French']
								elsif language == 'kr'
									item = pokeMatches[item]['Korean']
								end
							
								feedback.add_item({
						          :title => "##{number.to_i} #{item}",
						          :autocomplete => name,
						          :arg => url_name + '@pkm',
						          :icon => {:type => "filetype", :name => "pokemon_sprites/#{number}.png"}
						        })
							else
							
								feedback.add_item({
							        :title => item,
							        :arg => item + '@not',
							        :icon => {:type => "filetype", :name => "arrow.png"}
							      })
							end
						end
					else
						feedback.add_item({
				        :title => "This Pokémon doesn't evolve.",
				        :icon => {:type => "filetype", :name => "icon.png"}
				      })
					end
				end
			end
			
			puts feedback.to_xml

		elsif info == "lvl"

			if filter == "/help"
			
				feedback = `ruby ./help.rb "lvl"`
				puts feedback

			else
			
				matches = POKEMOVES_DATA.select do |name, data|
					name.downcase == string.downcase
				end
				
				feedback = Feedback.new

				matches.each do |name, data|
					
					data['Level Up'].each do |move, lvl|
					
						if filter
					      movesMatches = MOVES_DATA.select do |name, data|
								name.downcase == move.downcase and data['type'].downcase.include? filter.downcase
							end
						else
							movesMatches = MOVES_DATA.select do |name, data|
								name.downcase == move.downcase
							end
						end

						movesMatches.each do |name, data|
							feedback = self.createMoveFeedback(name, lvl, data, feedback)
						end
						
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
			
		elsif info == "hm"

			if filter == "/help"
			
				feedback = `ruby ./help.rb "hm"`
				puts feedback

			else
				
				matches = POKEMOVES_DATA.select do |name, data|
					name.downcase == string.downcase
				end
				
				feedback = Feedback.new
				lvl = nil
				
				matches.each do |name, data|
				
					if data['HM'].count > 0
						
						data['HM'].each do |move|
						
							if filter
						      movesMatches = MOVES_DATA.select do |name, data|
									name.downcase == move.downcase and data['type'].downcase.include? filter.downcase
								end
							else
								movesMatches = MOVES_DATA.select do |name, data|
									name.downcase == move.downcase
								end
							end
										
							movesMatches.each do |name, data|
								feedback = self.createMoveFeedback(name, lvl, data, feedback)
							end
						end
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
				
		elsif info == "tm"

			if filter == "/help"
			
				feedback = `ruby ./help.rb "tm"`
				puts feedback

			else
				
				matches = POKEMOVES_DATA.select do |name, data|
					name.downcase == string.downcase
				end
				
				feedback = Feedback.new
				lvl = nil

				matches.each do |name, data|
					
					if data['TM'].count > 0
					
						data['TM'].each do |move|
							
							if filter
						      movesMatches = MOVES_DATA.select do |name, data|
									name.downcase == move.downcase and data['type'].downcase.include? filter.downcase
								end
							else
								movesMatches = MOVES_DATA.select do |name, data|
									name.downcase == move.downcase
								end
							end
										
							movesMatches.each do |name, data|
								feedback = self.createMoveFeedback(name, lvl, data, feedback)
							end
						end
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
				
		elsif info == "egg"

			if filter == "/help"
			
				feedback = `ruby ./help.rb "egg"`
				puts feedback

			else
				
				matches = POKEMOVES_DATA.select do |name, data|
					name.downcase == string.downcase
				end
				
				feedback = Feedback.new
				lvl = nil
				
				matches.each do |name, data|
				
					if data['Egg Moves'].count > 0
					
						data['Egg Moves'].each do |move|
						
					      	if filter
						      movesMatches = MOVES_DATA.select do |name, data|
									name.downcase == move.downcase and data['type'].downcase.include? filter.downcase
								end
							else
								movesMatches = MOVES_DATA.select do |name, data|
									name.downcase == move.downcase
								end
							end
										
							movesMatches.each do |name, data|
								feedback = self.createMoveFeedback(name, lvl, data, feedback)
							end
						end
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

		else

	       	matches = matches.sort_by do |k,v|
	          k.downcase[0..string.length-1] == string.downcase ? 0 : 1
	        end

	      feedback = Feedback.new
	      matches.each do |name, data|
	        
	        if data['language'] == 'fr'
		        name = data['French']
		    elsif data['language'] == 'de'
		    	name = data['German']
		    elsif data['language'] == 'kr'
		    	name = data['Korean']
		    elsif data['language'] == 'jp'
		    	name = data['Kana']
		    end

		    img = data['number']
		    shiny = ''

		    if info == 'shiny'
		    	shiny = 'shiny/'
		    	img += '-shiny'
		    end

		    feedback.add_item({
	          :title => "##{data['number'].to_i} #{name}",
	          :subtitle => data['description'],
	          :autocomplete => name,
	          :arg => data['url_name'] + '@' + data['number'] + '@' + data['description'] + '@pkm',
	          :icon => {:type => "filetype", :name => "pokemon_sprites/#{shiny}#{img}.png"}
	        })

	        types = data['type']
	        feedback = self.createTypeFeedback('', types[0], types[1], feedback)

	        mega = 'Mega '

        	if language == 'jp'
        		mega = 'メガ'
        	end

	        if data['megaType']

	        	types = data['megaType']

	        	if data['megaTypeY']
	        		feedback = self.createTypeFeedback(mega + name + ' X', types[0], types[1], feedback)
	        	else
	        		feedback = self.createTypeFeedback(mega + name, types[0], types[1], feedback)
	        	end

	        end

	        if data['megaTypeY']

	        	types = data['megaTypeY']
	        	feedback = self.createTypeFeedback(mega + name + ' Y', types[0], types[1], feedback)

	        end

	        if data['forms']

	        	data['forms'].each do |form, types|
					feedback = self.createTypeFeedback(form, types[0], types[1], feedback)	        		
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
end

Alfredex.search ARGV.join.strip
