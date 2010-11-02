require 'sinatra'
require 'json'
require 'redis'

configure :development, :test do
  $redis = Redis.connect
end

configure :production do
  uri = URI.parse(ENV['REDISTOGO_URL'])
  $redis = Redis.connect(:host => uri.host, :port => uri.port, :password => uri.password)
end

helpers do
  def today
    @today ||= Time.now
  end
  
  def time_to_key(t = today)
    t.strftime('%Y%m%d')
  end
  
  def get_latest_image_url
    latest = $redis.get time_to_key
    unless latest
      latest = $redis.get($redis.sort("nasa-images-of-the-day", :limit => [0, 1], :order => 'desc alpha'))
      unless latest
        raw = open('http://www.nasa.gov/rss/lg_image_of_the_day.rss').read
        rss = RSS::Parser.parse(raw, false)      
        rss.items.each do |item|
          k = time_to_key(Time.parse(item.date.to_s))
          unless $redis.exists(k)
            $redis.set k, item.enclosure.url
            $redis.sadd "nasa-images-of-the-day", k
          end
        end
        latest = $redis.get $redis.srandmember("nasa-images-of-the-day")
      end     
    end
    
    latest
  end
end

before do
  @data = {}
  @callback = params.delete('callback') || 'callback'
  content_type :js
end

get '/' do
  @data[:url] = get_latest_image_url
  "#{@callback}(#{@data.to_json})"
end

error do
  @data[:error] = 'A nasty error ocurred.'
  "#{@callback}(#{@data.to_json})"
end

not_found do
  @data[:error] = 'Requested resource does not exist.'
  "#{@callback}(#{@data.to_json})"  
end
