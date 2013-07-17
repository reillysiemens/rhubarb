require('mysql')
require('json')
require_relative('mysql_connection')

#Initiate a connection to the database defined by mysql_connection.rb
$con = Mysql.new($hostname, $username, $password, $database)

#COMMENT-REQUIRED
def auth(username, password)
    results = $con.query("select id, login from rhubarb_players where login='" + username +"' AND password='" + password + "';")
    if results.num_rows() == 1
        row = results.fetch_hash
        return row["id"].to_i
    else
        return 0
    end
end

#COMMENT-REQUIRED
def getPlayerInfo(player_id)
    results = $con.query("select name, login, rating_package, rating from rhubarb_players where id=" + player_id.to_s + ";")
    if results.num_rows() == 0
        return "no player with id " + player_id.to_s
    end
    row = results.fetch_hash
    return JSON.fast_generate(row)
end

#COMMENT-REQUIRED
def getPlayers(name, low, high)
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

#COMMENT-REQUIRED
def getGameInfo(game_id)
    results = $con.query("select * from rhubarb_games where id=" + game_id.to_s + ";")
    if results.num_rows() == 0
        return "no game with id " + game_id.to_s
    end
    row = results.fetch_hash
    return JSON.fast_generate(row)
end

#COMMENT-REQUIRED
def getGamesByPlayers(name1, name2)
    results = $con.query("select * from rhubarb_games where (winner=" + name1.to_s + " and loser=" + name2.to_s + ") or (winner=" + name2.to_s + " and loser=" + name1.to_s + ");")
    rows = Array.new
    results.each_hash do |row|
        rows << row
    end
    return JSON.fast_generate(rows)
end

#COMMENT-REQUIRED
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

#COMMENT-REQUIRED
def getPendingGames(player_id)
    results = $con.query("select * from rhubarb_pending_games where requested_to=" + player_id.to_s + ";")
    rows = Array.new
    results.each_hash do |row|
        rows << row
    end
    return JSON.fast_generate(rows)
end

#COMMENT-REQUIRED
#ERROR-HANDLING-REQUIRED
def gameRequest(winner, loser, high_score, low_score, player_id, recipient_id)
    results = $con.query("insert into rhubarb_pending_games (requested_by, requested_to, timestamp, winner, loser, high_score, low_score) values (" + player_id.to_s + "," + recipient_id.to_s + "," + "NOW() ," + winner.to_s + "," + loser.to_s + "," + high_score.to_s + "," + low_score.to_s + ");")
    return 0
end

#COMMENT-REQUIRED
def gameAccept(player_id, pending_game_id)
    results = $con.query("select * from rhubarb_pending_games where requested_to=" + player_id.to_s + " and id=" + pending_game_id.to_s+ ";")
    row = results.fetch_hash
    $con.query("insert into rhubarb_games (winner, loser, high_score, low_score) values (" + row['winner'] + "," + row['loser'] + "," + row['high_score'] + "," + row['low_score'] + ");")
    $con.query("delete from rhubarb_pending_games where id=" + pending_game_id.to_s + " and requested_to=" + player_id.to_s + ";")
end

#COMMENT-REQUIRED
def gameCancel(player_id, pending_game_id)
end

#COMMENT-REQUIRED
def gameDecline(player_id, pending_game_id)
    $con.query("delete from rhubarb_pending_games where id=" + pending_game_id.to_s + " and requested_to=" + player_id.to_s + ";")
end

#TESTING FUNCTIONS

#p auth("reilly", "password")
#p getPlayerInfo(0)
#p getPlayers("", 0.0, 5, 0)
#p getGames(0, 1)
#p getPendingGames(0)
#p gameRequest("new", 0, 1, 11, 6, 1, 0)
#p getPendingGames(0)
