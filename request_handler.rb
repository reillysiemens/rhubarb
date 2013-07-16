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

#REMOVED ABOVE FUNCTIONS

require('mysql')
require('json')
require_relative('mysql_connection')


#each of these functions desperately need to be protected from sqli
#although this may be better to handle in the api_server

def auth(username, password)
    results = $con.query("select id, login from rhubarb_players where login='" + username +"' AND password='" + password + "';")
    if results.num_rows() == 1
        row = results.fetch_hash
        return row["id"].to_i
    else
        return 0
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
def getGamesByPlayers(name1, name2)
    results = $con.query("select * from rhubarb_games where (winner=" + name1.to_s + " and loser=" + name2.to_s + ") or (winner=" + name2.to_s + " and loser=" + name1.to_s + ");")
    rows = Array.new
    results.each_hash do |row|
        rows << row
    end
    return JSON.fast_generate(rows)
end

def getTopGames(top)
    if top == -1
        results = $con.query("select * from rhubarb_games order by id desc limit 50")
    else
        results = $con.query("select * from rhubarb_games where id<top order by id desc limit 50")
    end
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

#this definitely needs some error handling
def gameRequest(action, winner, loser, high_score, low_score, player_id, requestee_id)
    if(action == "new")
        results = $con.query("insert into rhubarb_pending_games (requested_by, requested_to, timestamp, winner, loser, high_score, low_score) values (" + player_id.to_s + "," + requestee_id.to_s + "," + "NOW() ," + winner.to_s + "," + loser.to_s + "," + high_score.to_s + "," + low_score.to_s + ");")
        return 0
    end
end

$con = Mysql.new($hostname, $username, $password, $database)
#p auth("reilly", "password")
#p getPlayerInfo(0)
#p getPlayers("", 0.0, 5, 0)
#p getGames(0, 1)
#p getPendingGames(0)
#p gameRequest("new", 0, 1, 11, 6, 1, 0)
#p getPendingGames(0)
