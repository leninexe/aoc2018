serial = File.readlines("input")[0].strip.to_i
powerLevels = Hash.new()

for y in 1..300
	for x in 1..300
		rackId = x + 10
		power = rackId * y
		power += serial
		power *= rackId
		power = (power / 100) % 10
		power -= 5

		powerLevels[[x,y]] = power
	end
end

maxLevel = 0
maxPos = nil

for y in 1..298
	for x in 1..298
		sum = powerLevels[[x,y]] + powerLevels[[x+1,y]] + powerLevels[[x+2,y]] +
			powerLevels[[x,y+1]] + powerLevels[[x+1,y+1]] + powerLevels[[x+2,y+1]] + 
			powerLevels[[x,y+2]] + powerLevels[[x+1,y+2]] + powerLevels[[x+2,y+2]]

		if sum > maxLevel
			maxLevel = sum
			maxPos = [x,y]
		end
	end
end

puts maxPos