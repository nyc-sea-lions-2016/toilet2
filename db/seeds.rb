# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Tag.create(tag:'Public')
response = HTTParty.get('https://data.cityofnewyork.us/resource/h87e-shkn.json')
response.each do |item|
	toilet = Toilet.new(
		name: item['name'],
		location: item['location'],
	)
	if toilet.save
		if Tag.all.any?{|tag| tag.tag == item['type']}
			tag = Tag.find_by(tag: item['type'])
			Tagtoilet.create(tag_id: tag.id, toilet_id: toilet.id)
			pub_tag = Tag.find_by(tag: 'Public')
			Tagtoilet.create(tag_id: pub_tag.id, toilet_id: toilet.id)
		else
			tag = Tag.create(tag: item['type'])
			Tagtoilet.create(tag_id: tag.id, toilet_id: toilet.id)
			pub_tag = Tag.find_by(tag: 'Public')
			Tagtoilet.create(tag_id: pub_tag.id, toilet_id: toilet.id)
		end
	end

	puts toilet.id
end




Toilet.all.each do |toilet|
    address = toilet.location.gsub(" ", "+") + ",+New+York+City,+NY"
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&key=" + ENV["GOOGLE_MAP_KEY"]
  response = HTTParty.get(url)

  begin
    if response["status"] == "OK"
      toilet.zip_code = nil
      toilet.neighborhood = response["results"][0]["address_components"][1]["long_name"]
      toilet.sublocality = response["results"][0]["address_components"][2]["long_name"]
      toilet.latitude = response["results"][0]["geometry"]["location"]["lat"].to_f
      toilet.longitude = response["results"][0]["geometry"]["location"]["lng"].to_f
      toilet.save
    end
  rescue
  end
  puts toilet.id.to_s + ' Toilet\'s Latitude: ' + toilet.latitude.to_s
end

User.create!(username:  "fj",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             first_name: Faker::Name.first_name,
             last_name: Faker::Name.last_name,
             zip_code: Faker::Address.zip,
             gender: Faker::StarWars.specie,
             admin: true)

20.times do
	User.create({
		username: Faker::Hipster.word,
    password: 'passwword',
    password_confirmation: 'passwword',
		email: "example@railstutorial.org",
		first_name: Faker::Name.first_name,
		last_name: Faker::Name.last_name,
		zip_code: Faker::Address.zip,
		gender: Faker::StarWars.specie
		})

end

Toilet.all.each do |toilet|
	5.times do
		Review.create({
			toilet_id: toilet.id,
			review_text: Faker::Hipster.paragraphs(3)[0] + Faker::Hipster.paragraphs(3)[1] + Faker::Hipster.paragraphs(3)[2],
			reviewer_id: User.all.sample.id,
			rating: rand(1..5)
			})
	end

end

500.times do
	Favorite.create({
		favoriter_id:  User.all.sample.id,
		toilet_id:  Toilet.all.sample.id
		})

end


