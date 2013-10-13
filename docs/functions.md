#newUser(name, username, password)
Creates a new entry in the users table with the specified information.
Must also fill current rating and ratings package fields based on selected rating system
returns boolean - should this be a string so specialized errors can be passed back?

#auth(username, password)
checks for valid login credentials
returns boolean

#addGame(user_id, user_score, other_score, other_user)
Adds a game to the pending game list with the given information
This function should do the logic to tell who is winner and loser and fill table accordingly
returns boolean - should this be a string so specialed errors can be passed back?

#acceptGame(user_id, game_id)
Check to make sure the user is allowed to accept the game first!
Moves a game from pending to real and updates user ranking
returns boolean

#declineGame(user_id, game_id)
Check to make sure user is allowed to decline the game first!
Moves a game from pending to declined (deletes it?)
returns boolean

#getGamesByUser(username)
to do

#getGameById(game_id)
to do

#getUser(username)
to do
