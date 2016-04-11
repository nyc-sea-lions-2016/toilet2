class ToiletsController < ApplicationController
  def index
    if params.has_key?(:user_input)
      geo_info = Geocoder.search(params[:user_input])
        user_search_lat = geo_info[0].data["geometry"]["location"]["lat"]
        user_search_lon = geo_info[0].data["geometry"]["location"]["lng"]
        @search_location = [user_search_lat,user_search_lon]
        #need to throw error if geo_info could not parse answer correctly.
    else
      @search_location = [40.7831, -73.9712] #center manhattan
    end

    # toilets within one mile (in meters) of central manhattan or user search input:
    @all_toilets = Toilet.all.select do |toilet|
      toilet.distance_to(@search_location[0], @search_location[1]) < 1609
    end

    # toilets sorted by distance
    @toilets_by_distance = @all_toilets.sort{|x,y| x.distance_to(@search_location[0], @search_location[1]) <=> y.distance_to(@search_location[0], @search_location[1])}

    # toilets paginated
    @toilets = @toilets_by_distance.paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @toilet = Toilet.new
  end

  def show
    @toilet = Toilet.find_by(id: params[:id])

    @average_review = Toilet.average_review(@toilet)
  end

  def create
    @toilet = Toilet.new(toilet_params)
    if @toilet.save
      tags_str = params[:toilet][:tags][:tag]
      tags_str.split(',').each do |tag_name|
        tag_name.strip!
        new_tag = Tag.create(tag: tag_name)
        Tagtoilet.create(tag_id: new_tag.id,toilet_id: @toilet.id)
      end
      toilet_location_info(@toilet)
      redirect_to action: 'show', controller: 'toilets', id:@toilet.id
    end

  end

  def toilet_data
    render json: Toilet.all
  end
 #filters not working just yet
  def filter_data
      case params[:filter][:info]
      when 'Public'
        @tag = Tag.find_by(tag: 'Public')
      when 'Basketball Courts'
        @tag = Tag.find_by(tag: 'Basketball Courts')
      when 'Book Store'
        @tag = Tag.find_by(tag: 'Book Store')
      end

      @joins = Tagtoilet.where('tag_id = ?', @tag.id)
      @toilets = @joins.map{|join| Toilet.find(join.toilet_id)}
      @toilets.to_json
  end

  def user_search
    redirect_to action: 'index', controller: 'toilets', user_input: params[:user][:user_input]
  end
private

  def toilet_params
    params[:toilet].require(:t_info).permit(:name, :location)
  end


  def toilet_location_info(toilet)
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
  end


end
