require 'sinatra'

set :port => 10081
set :bind => "0.0.0.0"

get '/' do
    "hello!"
end

get '/login' do
    params[:name]
end
