require 'elo'

bob = Elo::Player.new
jane = Elo::Player.new

for i in 1..5
    bob.wins_from(jane)
end
for i in 1..5
    jane.wins_from(bob)
end
    
puts bob.rating
puts jane.rating
