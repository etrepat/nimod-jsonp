module Nimod
  DEFAULT_FEED_URL = 'http://www.nasa.gov/rss/lg_image_of_the_day.rss'

  class Reader
    def initialize(url=Nimod::DEFAULT_FEED_URL)
      @url = url
      @images = []
    end

    attr_accessor :url
    attr_reader :images

    def read
      @images.clear

      raw = open(@url).read
      rss = RSS::Parser.parse(raw, false)
      rss.items.each do |item|
        @images.push(Nimod::Image.create_from_rss_item(item))
      end

      @images
    end
  end
end

