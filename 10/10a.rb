input = File.readlines("input")
vectors = Hash.new()
positions = Hash.new()

minx = 0
maxx = 0
miny = 0
maxy = 0

input.each_index do |i|
	pairs = input[i].gsub(/\s+/, "").scan(/<[-]*[0-9]+,[-]*[0-9]+>/)
	coordinates = pairs[0].gsub(/</, "").gsub(/>/, "").split(",").map{|c| c.to_i}
	vector = pairs[1].gsub(/</, "").gsub(/>/, "").split(",").map{|c| c.to_i}

	positions[i] = coordinates
	vectors[i] = vector

	if coordinates[0] < minx
		minx = coordinates[0]
	end

	if coordinates[0] > maxx
		maxx = coordinates[0]
	end

	if coordinates[1] < miny
		miny = coordinates[1]
	end

	if coordinates[1] > maxy
		maxy = coordinates[1]
	end
end

minManhattenSum = nil
bestStep = nil
manhattenPos = Marshal.load(Marshal.dump(positions))

for i in 0..100000
	manhattenSum = 0

	manhattenPos.each do |k, v|
		newX = manhattenPos[k][0] + vectors[k][0]
		newY = manhattenPos[k][1] + vectors[k][1]
		manhattenPos[k] = [newX, newY]
		manhattenSum += newX.abs + newY.abs
	end

	if minManhattenSum == nil || manhattenSum < minManhattenSum
		minManhattenSum = manhattenSum
		bestStep = i
	end
end

print "#{bestStep}: #{minManhattenSum}"

for i in 0..100000
	field = Hash.new(" ")
	currentMinX = 0
	currentMinY = 0
	currentMaxX = 0
	currentMaxY = 0

	positions.each do |k, v|
		newX = positions[k][0] + vectors[k][0]
		newY = positions[k][1] + vectors[k][1]

		if newX < currentMinX && vectors[k][0] > 0
			currentMinX = positions[k][0]
		end

		if positions[k][0] > currentMaxX && vectors[k][0] < 0
			currentMaxX = positions[k][0]
		end

		if positions[k][1] < currentMinY && vectors[k][1] > 0
			currentMinY = positions[k][1]
		end

		if positions[k][1] > currentMaxY && vectors[k][1] < 0
			currentMaxY = positions[k][1]
		end

		positions[k] = [newX, newY]
		field[v] = "#"
	end
	
	if i > bestStep - 100 && i < bestStep + 100
		for y in currentMinY..currentMaxY do
			for x in currentMinX..currentMaxX do
				print field[[x,y]]
			end

			puts
		end
	end
end