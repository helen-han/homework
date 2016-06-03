#!/usr/bin/ruby
require 'yaml'
require 'json'
require 'net/http'
require 'io/console'

def func
	restful_api= YAML.load_file('API.yml')
	count = 1
	z = []
	restful_api.each do |k, v|
		v.each do |a, b|
		z << Thread.start("#{count}") do
			puts "new thread success"
				response = Net::HTTP.get(URI.parse(b))
			  File.open("temp#{count}.json","w") do |f|
					f.write(JSON.parse(response).to_json)
				end
				c = JSON.parse(File.read("temp#{count}.json"))
				c.each do |r, t|
					if r == "message"
						puts "#{r}...#{t}"
					end
				end
				count = count + 1
			end
		end
		z.each{|t| t.join}
	end
end
func
