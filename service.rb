require 'sinatra'
require 'erb'
require File.dirname(__FILE__) + '/lib/nimod.rb'
require 'chronic'

disable :run, :reload
enable :inline_templates

helpers do
  def today
    Time.now.utc
  end

  def render_response_for date, options={}
    @data = Nimod.get_image_for date, options
    halt 404, 'Not found' unless @data
    erb :index, :layout => false
  end
end

before do
  @callback = params.delete('callback') || 'callback'
  content_type :js
end

error do
  @data = {:error => 'A nasty error ocurred.'}
  erb :index, :layout => false
end

not_found do
  @data = {:error => 'Requested resource does not exist.'}
  erb :index, :layout => false
end

get '/' do
  render_response_for today, :fallback => true
end

get '/:description' do
  time = Chronic.parse(params[:description])
  halt 400, 'Bad time description' unless time
  render_response_for time
end

get '/:year/:month/:day' do
  key = "#{params[:year].rjust(4,'0')}#{params[:month].rjust(2,'0')}#{params[:day].rjust(2,'0')}"
  render_response_for key
end

__END__

@@ index
<%= "#{@callback}(#{@data.to_json})" %>

