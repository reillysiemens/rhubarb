require('mysql')
require('json')
#require_relative('mysql_connection')
require_relative('db_connection')

#Initiate a connection to the database defined by mysql_connection.rb
$con = Mysql.new($hostname, $username, $password, $database)

# PLAYER REQUEST HANDLERS =====================================================

#Inserts a new row into rhubarb_players
def addPlayer(name, username, password, rating_package, current_rating, status)
    $con.query("insert into rhubarb_players (name, username, password, rating_package, current_rating, status) values ('" + name.to_s + "','" + username.to_s + "','" + password.to_s + "','" + rating_package.to_s + "','" + current_rating.to_s + "','" + status.to_s + "');")
end

#Given a player id, sets the player status to enabled.
def enablePlayer(player_id)
    $con.query("update rhubarb_players set status=1 where id=" + player_id.to_s + ";")
end

#Given a player id, sets the players status to disabled.
def disablePlayer(player_id)
    $con.query("update rhubarb_players set status=0 where id=" + player_id.to_s + ";")
end

#Authenticate a user by checking the supplied password and username against the database
def auth(username, password)
    results = $con.query("select id, username from rhubarb_players where username='" + username +"' AND password='" + password + "';")
    if results.num_rows() == 1
        row = results.fetch_hash
        return row["id"].to_i
    else
        return 0
    end
end

#Get a JSON-formatted player info for a particular player_id
def getPlayerInfo(player_id)
    results = $con.query("select name, username, rating_package, rating from rhubarb_players where id=" + player_id.to_s + ";")
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
        query_str = "select name, username, rating_package, rating from rhubarb_players where rating between " + low.to_s + " and " + high.to_s + ";"
        result = $con.query(query_str)
        rows = Array.new
        result.each_hash do |row|
            rows << row
        end
        return JSON.fast_generate(rows)
    end
end

# GAME REQUEST HANDLERS =======================================================

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
    results = $con.query("select * from rhubarb_games where (winner='" + name1.to_s + "' and loser='" + name2.to_s + "') or (winner='" + name2.to_s + "' and loser='" + name1.to_s + "');")
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

#Given a game_id, swap the values of sender_id and recipient_id for that game
#NEEDS ERROR HANDLING
def roleSwap(game_id)
    results = $con.query("select sender_id, recipient_id from rhubarb_games where id=" + game_id.to_s + ";")
    row = results.fetch_hash
    $con.query("update rhubarb_games set sender_id=" + row["recipient_id"].to_s + ", recipient_id=" + row["sender_id"].to_s + " where id=" + game_id.to_s + ";")
    return 0
end

#Insert a game into the database
#NEEDS ERROR HANDLING
def addGame(user_id, user_score, other_score, recipient_id)
    if(user_score > other_score)
        winner = user_id;
        loser = recipient_id;
        winner_score = user_score;
        loser_score = other_score;
    else
        winner = recipient_id;
        loser = user_id;
        winner_score = user_score;
        loser_score = other_score;
    end
    sender_id = user_id;
    $con.query("insert into rhubarb_games (winner, loser, winner_score, loser_score, sender_id, recipient_id, timestamp, state) values (" + winner.to_s + "," + loser.to_s + "," + winner_score.to_s + "," + loser_score.to_s + "," + sender_id.to_s + "," + recipient_id.to_s + "," + Time.now.to_i.to_s + ",0);")
    #should this return the game id?
    return True
end

#Remove a game from the database
#NEEDS ERROR HANDLING
def removeGame(game_id)
    $con.query("delete from rhubarb_games where id=" + game_id.to_s + ";")
    return True
end

#Set the state of a given game to accepted
#NEEDS ERROR HANDLING
def acceptGame(game_id)
    $con.query("update rhubarb_games set state=1 where id=" + game_id.to_s + ";")
    return 0
end

#Verify a user has permissions to edit a particular game
#UNFINISHED
def checkPermissions(player_id, game_id)
end

#Update an existing game with new information
#UNFINISHED
def editGame(game_id)
end

# RATING REQUEST HANDERS  =====================================================

#Add a rating to the database
#UNFINISHED
def addRating()
end

#Get information about a rating from the database
#UNFINISHED
def getRatings()
end
