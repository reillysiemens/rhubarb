#!/usr/bin/env ruby

require 'sinatra'
require_relative 'request_handler'

#Enable use of sessions for easy logging/state management
enable :sessions

#Verify login information
def checkLogin()
    #p "userid = " + session['userID'].to_s
    if session['user_id'] > 0
        return true
    end
    return false
end

#Set up port and hostname for Sinatra
set :port => 10081
set :bind => "0.0.0.0"

#Hello, world
get '/' do
    "Rhubarb says hello!"
end

#Authentication
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

#Run checkLogin() to test authentication
get '/testAuth' do
    checkLogin().to_s
end

#Forward new game requests to the request handler
get '/addNewGame' do

    #If we don't have a valid login display error
    if !checkLogin()
        "Invalid login"
    #Otherwise get request data and forward to appropriate handling method
    else
        action = params[:action]
        winner_id = params[:winner_id]
        loser_id = params[:loser_id]
        high_score = params[:high_score]
        low_score = params[:low_score]
        player_id = session['user_id']
        recipient_id = params[:recipient_id]
        pending_game_id = params[:pending_game_id]

        #If action is new request a new addition to the pending table
        if (action == "new")
            gameRequest(action, winner_id, loser_id, high_score, low_score, player_id, recipient_id)
        #If action is accept then accept an existing game, move it to games and remove from pending games
        elsif (action == "accept")
            gameAccept(player_id, pending_game_id)
        #If action is decline then decline an existing game, remove it from pending games
        elsif (action == "decline")
            gameDecline(player_id, pending_game_id)
        #If action is cancel then cancel an existing game, remove it from pending games
        elsif (action == "cancel")
            gameCancel(player_id, pending_game_id)
        else
        end

    end
end

#Forward requests for game info to the request handler
get '/getGameInfo' do
    gid = params[:game_id]
    getGameInfo(gid)
end

#Forward requests for player info to the request handler
get '/getPlayerInfo' do
    pid = params[:player_id]
    getPlayerInfo(pid)
end

#Forward requests for games to the request handler
get '/getGames' do
    getTopGames(-1)
end
