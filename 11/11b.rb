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

for y in 1..300
	for x in 1..300
		sum = powerLevels[[x,y]]

		for i in 1..((300-[x,y].max) - 1)
			for x1 in 0..i
				sum += powerLevels[[x+x1,y+i]]
			end

			for y1 in 0..(i-1)
				sum += powerLevels[[x+i,y+y1]]
			end

			if sum > maxLevel
				maxLevel = sum
				maxPos = [x,y,i+1]
			end
		end	
	end
end

puts maxLevel
puts maxPos