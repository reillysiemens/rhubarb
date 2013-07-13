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

def auth(username, password)
end

def getPlayerInfo(player_id)
end

#What is default top?
def getPlayers(name, high, low, default top)
end

def getGameInfo(game_id)
end

def getGames(names)
end

=begin
Action is one of either NEW, CANCEL, DECLINE, or ACCEPT.
If action is not NEW then only game_id is second argument.
=end
def gameRequest(action, winner, loser, winner_score, loser_score)
end
