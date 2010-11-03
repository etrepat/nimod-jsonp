require File.dirname(__FILE__) + '/env.rb'

describe Nimod::Image do
  before(:each) do
    @hash = {
      :title => "Decade",
      :description => "From 220 miles above Earth, ...",
      :src => "http://www.nasa.gov/images/content/494799main_iss025e010008_full.jpg",
      :date => Time.now,
      :content_type => "image/jpeg",
      :size => 1234567,
      :link=>"http://www.nasa.gov/multimedia/imagegallery/image_feature_1795.html"
    }

    @image = Nimod::Image.new(@hash)
  end

  it 'should initialize empty if no arguments provided' do
    im = Nimod::Image.new
    im.instance_variables.each do |v|
      method = v.to_s.sub('@', '')
      im.send(method).should be(nil)
    end
  end

  it 'should initialize properly from a hash object' do
    h = { :title => 'a title', :description => 'some description', :src => 'be a nice uri',
      :date => Time.now, :content_type => 'image/jpeg', :size => 100,
      :link => 'yet a nice link', :should_not_go_into_image => 'i\'m not an image property' }

    im = Nimod::Image.new(h)

    h.keys.each do |k|
      method = k.to_s

      im.send(method).should_not be(nil) if im.respond_to?(method)
    end
  end
end

