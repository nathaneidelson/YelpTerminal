require 'rubygems'
require 'nokogiri'

link = "http://www.yelp.com/search?find_desc="
#Use the first arguement as the search keyword. NOTE: This version only supports one search keyword.
description = ARGV[0]
link = link + description
link = link + "&find_loc="

#For all other arguments, assume they make up the location and append to link
ARGV[2..ARGV.size].each_with_index do|input, index|
	link = link + input
	if(index < ARGV.size - 3) 
		link = link + "+"
	end
end

#Finialize the yelp link
link = link + "%2C+CA&ns=1"
#Call wget, and download the html to a local file, page.html
command = "wget " "--output-document=page.html " + '"' + link + '"'
system(command)

#Open the html file using Nokogiri, a Ruby html parser.
page = Nokogiri::HTML(open("page.html"))


#Here's some work trying to get the above working in clever ways (but Nokogiri wasn't being cooperative)
prefix = "a[id = '"

for i in 0..9 do
	resturantID = "bizTitleLink" + i.to_s()
	resturantID = prefix + resturantID + "']"
	#puts resturantID
	puts page.css(resturantID).text
end

=begin

#Aquire the string of resurants as delimited by commas
resurantString = page.at('meta[@name="description"]')[:content]
#Remove the first portion of the string, which has nothing to do with our strings of interest
junkPrefix, resurantList = resurantString.split('   ', 2)
#Split the string on commas. NOTE: This doesn't work properly when a resturant name has a comma 
#in it. There is really no way around this if we go about parsing the html "description" element.
resturants = resurantList.split(/, */, 10)

#For each resturant, print an index and the resturan name to the console.
resturants.each_with_index do|resturant, index|
	stringToPrint = (index + 1).to_s() + ". " + resturant
	puts stringToPrint
end
=end


