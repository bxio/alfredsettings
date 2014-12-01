require 'yaml'

class OpenAlfred
  ITEMS_DATA = YAML.load_file(File.join(File.dirname(__FILE__), 'items.yml'))

  def self.search(string)
	
	# string = 'gloom@Use Leaf Stone@pkm'
		
    s = string.split('@')

    pokename = s[0]
    condition = s[1]
    info = s.last

    if info == 'pkm'

      `osascript ./alfred.scpt "#{pokename.downcase}" "dex"`

    else

      condition = s[2]

      item = false

      ITEMS_DATA.each do |name, data|
        if condition.downcase.include? name.downcase
          `osascript ./alfred.scpt "#{name.downcase}" "#{info}"`
          item = true
          break
        end
      end

      if not item
        `osascript ./alfred.scpt "#{pokename.downcase}" "dex"`
      end
    end
  end
end

OpenAlfred.search ARGV.join.strip