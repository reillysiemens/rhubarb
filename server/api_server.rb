require 'sinatra'
require_relative 'request_handler'

enable :sessions
#should enable us to handle logging in easily

def checkLogin()
    #p "userid = " + session['userID'].to_s
    if session['user_id'] > 0
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
    session['user_id'] = r
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
        action = params[:action]
        winner_id = params[:winner_id]
        loser_id = params[:loser_id]
        high_score = params[:high_score]
        low_score = params[:low_score]
        player_id = session['user_id']
        recipient_id = params[:recipient_id]
        pending_game_id = params[:pending_game_id]

        #somecomment
        if (action == "new")
            gameRequest(action, winner_id, loser_id, high_score, low_score, player_id, recipient_id)
        elsif (action == "accept")
            gameAccept(player_id, pending_game_id)
            p player_id
        elsif (action == "decline")
            gameDecline(player_id, pending_game_id)
        elsif (action == "cancel")
            gameCancel(player_id, pending_game_id)
        else
        end

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
