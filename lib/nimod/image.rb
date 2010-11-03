module Nimod
  class Image
    def initialize(options={})
      @title = nil
      @description = nil
      @src = nil
      @date = nil
      @content_type = nil
      @size = nil
      @link = nil

      from_hash(options) if options && !options.empty?
    end

    attr_accessor :title, :description, :src, :date, :content_type, :size, :link

    def id
      return nil unless date
      date.strftime('%Y%m%d')
    end

    alias :key :id

    def from_hash(hash)
      hash.each { |k, v| send("#{k.to_s}=", v) if respond_to?(k) }
    end

    def to_hash
      hash = {}

      instance_variables.map{ |v| v.to_s.sub('@', '') }.each do |v|
        hash[v.to_sym] = send(v)
      end

      hash
    end

    def to_json
      self.to_hash.to_json
    end
    
    def ==(other)
      to_hash == other.to_hash
    end

    def self.create_from_rss_item(item)
      return Image.new(:title => item.title, :description => item.description,
        :src => item.enclosure.url, :date => Time.parse(item.date.to_s),
        :content_type => item.enclosure.type, :size => item.enclosure.length,
        :link => item.link)
    end

    def self.from_json(json)
      return Image.new(JSON.parse(json))
    end
  end
end

