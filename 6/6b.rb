coordinates = File.readlines("input")
maxDistance = 10000
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

# walk through all points and check, if the sum (manhatten distance) to each point is less than 10000
region = 0

(minY..maxY).each do |y|
	(minX..maxX).each do |x|
		sum = 0

		map.each do |k, v|
			sum += (x-k[1]).abs + (y-k[0]).abs
		end

		if sum < maxDistance
			region += 1
		end
	end
end

puts region