require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

require 'rubygems'
require 'redis'
require 'json'

require File.dirname(__FILE__) + '/nimod/store.rb'
require File.dirname(__FILE__) + '/nimod/image.rb'
require File.dirname(__FILE__) + '/nimod/reader.rb'

# NASA Image of the Day
module Nimod
  def self.get_image_for(t, options={})
    key = t.dup
    key = Nimod::Image.key_from_time(key) if (key.is_a?(Time) || key.is_a?(Date))

    json = store.get(key)
    if !json && options[:fallback]
      json = store.last
      unless json
        self.fetch_from_feed
        json = store.random
      end
    end

    return Nimod::Image.from_json(json) if json
    nil
  end

  def self.fetch_from_feed
    reader = Nimod::Reader.new
    images = reader.read
    images.each do |image|
      key = image.key
      store.put key, image.to_json if !store.exists?(key)
    end
  end
end

