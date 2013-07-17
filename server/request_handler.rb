require('mysql')
require('json')
require_relative('mysql_connection')

#Initiate a connection to the database defined by mysql_connection.rb
$con = Mysql.new($hostname, $username, $password, $database)

#Authenticate a user by checking the supplied password and username against the database
def auth(username, password)
    results = $con.query("select id, login from rhubarb_players where login='" + username +"' AND password='" + password + "';")
    if results.num_rows() == 1
        row = results.fetch_hash
        return row["id"].to_i
    else
        return 0
    end
end

#Get a JSON-formatted player info for a particular player_id
def getPlayerInfo(player_id)
    results = $con.query("select name, login, rating_package, rating from rhubarb_players where id=" + player_id.to_s + ";")
    if results.num_rows() == 0
        return "no player with id " + player_id.to_s
    end
    row = results.fetch_hash
    return JSON.fast_generate(row)
end

#Get a JSON-formatted list of players by name or ranking
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

#Get a JSON-formatted string containing info for a particular game_id
def getGameInfo(game_id)
    results = $con.query("select * from rhubarb_games where id=" + game_id.to_s + ";")
    if results.num_rows() == 0
        return "no game with id " + game_id.to_s
    end
    row = results.fetch_hash
    return JSON.fast_generate(row)
end

#Get JSON-formatted game info for games between name1 and name2
def getGamesByPlayers(name1, name2)
    results = $con.query("select * from rhubarb_games where (winner=" + name1.to_s + " and loser=" + name2.to_s + ") or (winner=" + name2.to_s + " and loser=" + name1.to_s + ");")
    rows = Array.new
    results.each_hash do |row|
        rows << row
    end
    return JSON.fast_generate(rows)
end

#Get top games? Haven't looked this function over yet.
#COMMENT-FIX-REQUIRED
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

#Get a list of pending games for player_id and return corresponding JSON
def getPendingGames(player_id)
    results = $con.query("select * from rhubarb_pending_games where requested_to=" + player_id.to_s + ";")
    rows = Array.new
    results.each_hash do |row|
        rows << row
    end
    return JSON.fast_generate(rows)
end

#Request a game by adding the necessary information to pending games in the database
#ERROR-HANDLING-NEEDED
def gameRequest(winner, loser, high_score, low_score, player_id, recipient_id)
    results = $con.query("insert into rhubarb_pending_games (requested_by, requested_to, timestamp, winner, loser, high_score, low_score) values (" + player_id.to_s + "," + recipient_id.to_s + "," + "NOW() ," + winner.to_s + "," + loser.to_s + "," + high_score.to_s + "," + low_score.to_s + ");")
    return 0
end

#Accept a game by moving info in the database from pending games to games provided the request was sent to player_id
def gameAccept(player_id, pending_game_id)
    results = $con.query("select * from rhubarb_pending_games where requested_to=" + player_id.to_s + " and id=" + pending_game_id.to_s+ ";")
    row = results.fetch_hash
    $con.query("insert into rhubarb_games (winner, loser, high_score, low_score) values (" + row['winner'] + "," + row['loser'] + "," + row['high_score'] + "," + row['low_score'] + ");")
    $con.query("delete from rhubarb_pending_games where id=" + pending_game_id.to_s + " and requested_to=" + player_id.to_s + ";")
end

#Cancel a game by removing from the database the game matching pending_game_id if it was also requested by player_id
def gameCancel(player_id, pending_game_id)
    $con.query("delete from rhubarb_pending_games where id=" + pending_game_id.to_s + " and requested_by=" + player_id.to_s + ";")
end

#Decline a game by removing from the database the game matching pending_game_id if it was also sent to player_id
def gameDecline(player_id, pending_game_id)
    $con.query("delete from rhubarb_pending_games where id=" + pending_game_id.to_s + " and requested_to=" + player_id.to_s + ";")
end
