def printArea(area, minx, maxx, miny, maxy)
	for y in miny..maxy
		for x in minx..maxx
			print "#{area[[x,y]]}"
		end

		print "\n"
	end

	print "\n"
end

input = File.readlines(ARGV[0])
# input = File.readlines("test_input")
area = Hash.new(".")
area[[500,0]] = "+"
minx = 500
maxx = 500
miny = 0
maxy = 0
minYCmd = -1

input.each do |line|
	x = nil
	y = nil
	splitter = line.strip.gsub(/\s+/,"").split(",")

	if splitter.first.strip[0] == "x"
		x = splitter.first.split("=").last.to_i
		range = splitter.last.split("=").last.split("..").map{|v| v.to_i}

		if x < minx
			minx = x
		end

		if x > maxx
			maxx = x
		end

		if minYCmd == -1 || range[0] < minYCmd
			minYCmd = range[0]
		end

		if range[1] > maxy
			maxy = range[1]
		end

		for i in range[0]..range[1]
			area[[x,i]] = "#"
		end
	elsif splitter.first.strip[0] == "y"
		y = splitter.first.split("=").last.to_i
		range = splitter.last.split("=").last.split("..").map{|v| v.to_i}

		if y > maxy
			maxy = y
		end

		if minYCmd == -1 || y < minYCmd
			minYCmd = y
		end

		if range[0] < minx
			minx = range[0]
		end

		if range[1] > maxx
			maxx = range[1]
		end

		for i in range[0]..range[1]
			area[[i,y]] = "#"
		end
	end	
end

minx -= 2
maxx += 2

printArea(area, minx, maxx, miny, maxy)
print "\n\n\n"

depth = 0
iteration = 0

while true
	# drop from top to bottom
	delta = Hash.new

	area.select{|k,v| k[1] < maxy && (v == "+" || v == "|")}.each do |k,v|
		if area[[k[0],k[1]+1]] == "."
			delta[[k[0],k[1]+1]] = "|"
			depth = [k[1]+1,depth].max
		end
	end

	delta.each{|k,v| area[k] = v}

	# find standing water
	
	if delta.length == 0
		keys = area.select{|k,v| v == "|"}.keys.sort{|x,y| y[1] == x[1] ? x[0] - y[0] : y[1] - x[1]}

		keys.each do |k|
			x = k[0]
			y = k[1]

			leftBound = x
			rightBound = x

			# find left and right border of area

			for dx in 1..(x-minx).abs
				# <--
				if area[[x-dx,y]] == "." || area[[x-dx,y]] == "|"
					if area[[x-dx,y+1]] == "#" || area[[x-dx,y+1]] == "~"
						next
					else
						break
					end
				elsif area[[x-dx,y]] == "#"
					leftBound = x - dx
					break
				end
			end

			if leftBound != x
				for dx in 1..(x-maxx).abs
					# -->
					if area[[x+dx,y]] == "." || area[[x+dx,y]] == "|"
						if area[[x+dx,y+1]] == "#" || area[[x+dx,y+1]] == "~"
							next
						else
							break
						end
					elsif area[[x+dx,y]] == "#"
						rightBound = x + dx
						break
					end
				end
			end

			if leftBound != x && rightBound != x
				((leftBound + 1)..(rightBound - 1)).each{|newx| delta[[newx,y]] = "~"}
			end
		end

		delta.each{|k,v| area[k] = v}
	end

	# extend moving water

	if delta.length == 0
		keys = area.select{|k,v| v == "|"}.keys.sort{|x,y| y[1] == x[1] ? x[0] - y[0] : y[1] - x[1]}

		keys.each do |k|
			x = k[0]
			y = k[1]

			if area[[x,y+1]] == "~" || area[[x,y+1]] == "#"
				limitLeft = x
				limitRight = x

				# find left and right limit or edge of spill

				for dx in 1..(x-minx).abs
					# <--
					if area[[x-dx,y]] == "." || area[[x-dx,y]] == "|"
						if area[[x-dx,y+1]] == "#" || area [[x-dx,y+1]] == "~"
							next
						elsif area[[x-dx,y+1]] == "." && area[[x-dx+1,y+1]] == "#"
							limitLeft = x-dx
							break
						else
							break
						end
					elsif area[[x-dx,y]] == "#"
						limitLeft = x - dx + 1
						break
					end
				end

				for dx in 1..(x-maxx).abs
					# -->
					if area[[x+dx,y]] == "." || area[[x+dx,y]] == "|"
						if area[[x+dx,y+1]] == "#" || area[[x+dx,y+1]] == "~"
							next
						elsif area[[x+dx,y+1]] == "." && area[[x+dx-1,y+1]] == "#"
							limitRight = x+dx
							break
						else
							break
						end
					elsif area[[x+dx,y]] == "#"
						limitRight = x + dx - 1
						break
					end
				end

				if limitLeft != limitRight
					if area.select{|k,v| k[0] >= limitLeft && k[0] <= limitRight && k[1] == y && v == "|"}.length != (limitRight - limitLeft).abs + 1
						((limitLeft..limitRight)).each{|newx| delta[[newx,y]] = "|"}
					end
				end
			end
		end

		delta.each{|k,v| area[k] = v}
	end

	# if iteration % 1 == 0
	# 	printArea(area, minx, maxx, [0,depth-100].max, depth + 1)
	# end

	break if delta.length == 0

	iteration += 1

	gets
end

printArea(area, minx, maxx, 0, maxy)

water = area.select{|k,v| k[1] >= minYCmd && (v == "|" || v == "~")}

print "Water: #{water.length}\n"