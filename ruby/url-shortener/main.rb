require 'sinatra'
require './util/alphaNum'

get '/' do
  'Hello world!'
end

get '/hello/:name' do
    # matches "GET /hello/foo" and "GET /hello/bar"
    # params['name'] is 'foo' or 'bar'
    "Hello #{params['name']}!"
end

post "/newURL" do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    original = data['url']
    p original
    p Digest::SHA1.hexdigest(original)
    shortenURL = AlphaNum.encode(Digest::SHA1.hexdigest(original))

    "URL: #{original}!, newURL: #{shortenURL}"
  end