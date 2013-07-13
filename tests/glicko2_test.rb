require 'glicko2'

# Objects to store Glicko ratings
Rating = Struct.new(:rating, :rating_deviation, :volatility)
rating1 = Rating.new(1400, 30, 0.06)
rating2 = Rating.new(1550, 100, 0.06)

# Rating period with all participating ratings
period = Glicko2::RatingPeriod.from_objs [rating1, rating2]

# Register a game where rating1 wins against rating2
period.game([rating1, rating2], [1,2])

# Generate the next rating period with updated players
next_period = period.generate_next

# Update all Glicko ratings
next_period.players.each { |p| p.update_obj }

# Output updated Glicko ratings
puts rating1
puts rating2
