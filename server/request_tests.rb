#!/usr/bin/env ruby

require_relative('request_handler')

#Does authentication work?
p auth("reilly", "password")

#Can we get player information?
p getPlayerInfo(1)
p getPlayerInfo(2)
p getPlayerInfo(3)
p getPlayerInfo(4)
p getPlayerInfo(5)
p getPlayerInfo(6)

#Can we get a list of players?
p getPlayers("", 0.0, 5)

#Can we get a list of top games?
p getTopGames(-1)

#Can we get a list of pending games for player_id 2?
p getPendingGames(2)

#Make game requests to player_id 2 from player_id 1
p gameRequest(1, 2, 11, 9, 1, 2)
p gameRequest(1, 2, 11, 8, 2, 1)
p gameRequest(1, 2, 15, 13, 1, 2)

#Are pending games for player_id 2 different now?
p getPendingGames(2)

=begin
#THIS SECTION WON'T WORK DUE TO 'pre login attempt errors with nil uid' ERROR
#Player_id 2 accepts all pending requests
p gameAccept(2, 1)
p gameAccept(2, 2)
p gameAccept(2, 3)
=end

#Check pending games again. Should be empty now.
p getPendingGames(2)

#Get a list of games between Reilly and Tucker
p getGamesByPlayers("Tucker Siemens", "Reilly Steele")
