require 'saulabs/trueskill'

include Saulabs::TrueSkill

def createNewPlayer()
    #player = [Rating.new(25.0, 25.0/3.0)]
    player = Rating.new(25.0, 25.0/3.0)
    return player
end

def recoverPlayer(u, o)
    #player = [Rating.new(u, o)]
    player = Rating.new(u, o)
    return player
end

def playGame(winner, loser)
    #we enclose the winner and loser in a one element array because
    #we are making them into single player 'teams' for the algorithm
    FactorGraph.new([[winner], [loser]], [1,2]).update_skills
end

def getRank(player)
    rank = player.mean - (3 * player.deviation)
    return rank
end

p1 = createNewPlayer()
p2 = createNewPlayer()

puts "Initial values"
puts "p1 " + p1.to_s + " rating: " + getRank(p1).to_s
puts "p2 " + p2.to_s + " rating: " + getRank(p2).to_s

puts "Playing 500 games of p2 wins"
for i in 1..500
    playGame(p2, p1)
end 

puts "p1 " + p1.to_s + " rating: " + getRank(p1).to_s
puts "p2 " + p2.to_s + " rating: " + getRank(p2).to_s

puts "Giving p1 one win"
playGame(p1, p2)
puts "p1 " + p1.to_s + " rating: " + getRank(p1).to_s
puts "p2 " + p2.to_s + " rating: " + getRank(p2).to_s

#puts p1[0].tau    #I think the 0 is because it is designed to work with theams? aka arrays of players
#puts p2[0]
