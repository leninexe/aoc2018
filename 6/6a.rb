coordinates = File.readlines("input")
map = Hash.new(-1)
minX = 0
maxX = 0
minY = 0
maxY = 0

# Initialise
coordinates.each_index do |i|
	splitter = coordinates[i].split(",")
	x = splitter[0].strip.to_i
	y = splitter[1].strip.to_i

	if x > maxX
		maxX = x
	end

	if x < minX
		minX = x
	end

	if y > maxY
		maxY = y
	end

	if y < minY
		minY = y
	end

	map[[y,x]] = i
end

changes = false

#modify
loop do
	changes = false
	otherMap = Hash.new(-1)

	(minY..maxY).each do |y|
		(minX..maxX).each do |x|
			if map[[y,x]] != -1
				if otherMap[[y-1,x]] == -1
					otherMap[[y-1,x]] = map[[y,x]]
				elsif otherMap[[y-1,x]] != map[[y,x]]
					otherMap[[y-1,x]] = -2
				end

				if otherMap[[y+1,x]] == -1
					otherMap[[y+1,x]] = map[[y,x]]
				elsif otherMap[[y+1,x]] != map[[y,x]]
					otherMap[[y+1,x]] = -2
				end

				if otherMap[[y,x-1]] == -1
					otherMap[[y,x-1]] = map[[y,x]]
				elsif otherMap[[y,x-1]] != map[[y,x]]
					otherMap[[y,x-1]] = -2
				end

				if otherMap[[y,x+1]] == -1
					otherMap[[y,x+1]] = map[[y,x]]
				elsif otherMap[[y,x+1]] != map[[y,x]]
					otherMap[[y,x+1]] = -2
				end
			end				
		end
	end

	otherMap.each do |k, v|
		if map[k] == -1		
			map[k] = v
			changes = true
		end
	end

	break if !changes
end

maxFields = 0

coordinates.each_index do |i|
	fields = 0
	infinite = false

	map.each do |k, v|
		if v == i
			if k[0] == minY || k[0] == maxY || k[1] == minX || k[1] == maxX
				infinite = true
				break
			end

			fields += 1
		end
	end

	if infinite
		print "#{i}: infinite"
		puts
	elsif fields > 0
		if fields >= maxFields
			maxFields = fields
		end

		print "#{i}: #{fields}"
		puts
	end
end

puts maxFields
