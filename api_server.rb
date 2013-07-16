require 'sinatra'
require_relative 'request_handler'

enable :sessions
#should enable us to handle logging in easily

def checkLogin()
    #p "userid = " + session['userID'].to_s
    if session['userID'] > 0
        return true
    end
    return false
end

set :port => 10081
set :bind => "0.0.0.0"

get '/' do
    "hello!"
end

get '/auth' do
    u = params[:username]
    p = params[:password]
    r = auth(u, p)
    session['userID'] = r
    if r > 0
        "Logged in"
    else
        "Login failure"
    end
end

get '/testAuth' do
    checkLogin().to_s
end

get '/addNewGame' do
    if !checkLogin()
        "Invalid login"
    else
        params[:winnerID] + " beat " + params[:loserID]
        #Send this information to the handler
    end
end
    
get '/getGameInfo' do
    gid = params[:game_id]
    getGameInfo(gid)
end

get '/getPlayerInfo' do
    pid = params[:player_id]
    getPlayerInfo(pid)
end

get '/getGames' do
    getTopGames(-1)
end
