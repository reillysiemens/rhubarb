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

get '/newUser' do                   
    name = params[:name]
    username = params[:username]
    password = params[:password]
    newUser(name, username, password)
    #addPlayer(name, username, password, "0", "0", "1")
end

#Authentication
get '/auth' do
    u = params[:username]
    p = params[:password]
    r = auth(u, p)
    session['user_id'] = r
    if r > 0
        "{result:success}"
    else
        "{result:failure}"
    end
end

#Run checkLogin() to test authentication
get '/testAuth' do
    checkLogin().to_s
end


get '/addGame' do
    if !checkLogin()
        badLoginResponse()
        return
    end
    user_score = params[:user_score]
    other_score = params[:other_score]
    recipient_id = params[:recipient_id]
    # Clean input
    # Check userid
    newGame(session['user_id'], user_score, other_score, recipient_id)
end

get '/acceptGame' do
    game_id = params[:game_id]
    acceptGame(session['user_id'], game_id)
end

get '/getPendingGames' do
    getPendingGames(session['user_id'])
end

get '/getAllgames' do
    getAllGames()
end

get '/getUser' do
    username = params[:username]
    getUser(username)
end
=begin
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
        winner_score = params[:high_score]
        loser_score = params[:low_score]
        player_id = session['user_id']
        recipient_id = params[:recipient_id]
        pending_game_id = params[:pending_game_id]

        #If action is new request a new addition to the pending table
        if (action == "new")
            gameRequest(action, winner_id, loser_id, winner_score, loser_score, player_id, recipient_id)
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
        #NEED TO FINISH OFF THIS OPTION 
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
=end
