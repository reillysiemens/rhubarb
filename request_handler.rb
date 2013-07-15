=begin
my vision for request handler sits between the sinatra api server and
the wrappers for any given ranking system

as of now the ranking system could be changed by replacing the wrapper
file with an appropriate resource for a different ranking system
I would like to improve this so the files could be automatically chosen
perhaps this will be done by using a require 'variable' which can be
changed during runtime but I'm not sure enough about ruby to even say
if that is a possibility
=end

=begin
def reportGameResults(user, winner, loser, scores_and_stuff?)
    #if user != winner and user != loser reject!
    #set up db to ask other player to respond to results
end

def getGameResults(gameID)
    #return all info from game in json?
end

def login(user, password)
    #this maybe should error on fail
    #else return a login package that includes getUpdates?
end

def getUpdates(user)
    #send a package with any information the user should know about
    #right now I'm just thinking, games that need approval from them
end

def acceptGame(user, gameID)
    #move the game from accepted to game history table, make sure it belongs to the user
end
=end

#COMMENTED OUT ABOVE FUNCTIONS UNTIL THEY ARE NOT NEEDED

require('mysql')
require('json')
require_relative('mysql_connection')


#each of these functions desperately need to be protected from sqli
#although this may be better to handle in the api_server

def auth(username, password)
    results = $con.query("select login from rhubarb_players where login='" + username +"' AND password='" + password + "';")
    if results.num_rows() == 1
        return "success!"
    else
        return "failure!"
    end
end

def getPlayerInfo(player_id)
    results = $con.query("select name, login, rating_package, rating from rhubarb_players where id=" + player_id.to_s + ";")
    if results.num_rows() == 0
        return "no player with id " + player_id.to_s
    end
    row = results.fetch_hash
    return JSON.fast_generate(row)
end

#What is default top?
def getPlayers(name, low, high, default_top)
    if name == ""
        #then do high low
        query_str = "select name, login, rating_package, rating from rhubarb_players where rating between " + low.to_s + " and " + high.to_s + ";"
        result = $con.query(query_str)
        rows = Array.new
        result.each_hash do |row|
            rows << row
        end
        return JSON.fast_generate(rows)
    end
end

def getGameInfo(game_id)
    results = $con.query("select * from rhubarb_games where id=" + game_id.to_s + ";")
    if results.num_rows() == 0
        return "no game with id " + game_id.to_s
    end
    row = results.fetch_hash
    return JSON.fast_generate(row)
end

#this is just.. the worst sql statement ever
def getGames(name1, name2)
    results = $con.query("select * from rhubarb_games where (winner=" + name1.to_s + " and loser=" + name2.to_s + ") or (winner=" + name2.to_s + " and loser=" + name1.to_s + ");")
    rows = Array.new
    results.each_hash do |row|
        rows << row
    end
    return JSON.fast_generate(rows)
end

=begin
Action is one of either NEW, CANCEL, DECLINE, or ACCEPT.
If action is not NEW then only game_id is second argument.
=end
def getPendingGames(player_id)
    results = $con.query("select * from rhubarb_pending_games where requested_to=" + player_id.to_s + ";")
    rows = Array.new
    results.each_hash do |row|
        rows << row
    end
    return JSON.fast_generate(rows)
end

def gameRequest(action, winner, loser, winner_score, loser_score)
end

$con = Mysql.new($hostname, $username, $password, $database)
p auth("reilly", "password")
p getPlayerInfo(0)
p getPlayers("", 0.0, 5, 0)
p getGames(0, 1)
p getPendingGames(0)
