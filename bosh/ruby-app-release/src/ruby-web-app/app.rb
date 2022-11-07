require 'sinatra'
require "pstore"
require 'yaml'

configure do
	# config = YAML.load_file('/var/vcap/jobs/rubyweb/cfg/config.yml')

	set :bind, '0.0.0.0'
    set :port, 8181

	class Item
		attr_reader :name, :type

		def initialize(name, type)
			@name = name
			@type = type
		end
	end

	it1 = Item.new("Pilot Frixion", "pen")
	it2 = Item.new("GummyBear", "chewing gum")
	Item = PStore.new("items.pstore")
	
	Item.transaction do
		Item[it1.type] = it1.name
		Item[it2.type] = it2.name
	end

	def readAll()
		values = Hash.new
		Item.transaction do
			Item.roots.each do |data_root_name|
				values[data_root_name] = Item[data_root_name]
			end
		end
		return values
	end
end

get '/' do
	erb :index
end

get '/items' do
	@items = readAll()
	erb :data
end
