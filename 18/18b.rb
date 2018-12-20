def treecount(map, pos)
	count = 0

	for y in pos[1]-1..pos[1]+1
		for x in pos[0]-1..pos[0]+1
			if [x,y] != pos && map[[x,y]] == "|"
				count += 1
			end
		end
	end

	return count
end

def lumbercount(map, pos)
	count = 0

	for y in pos[1]-1..pos[1]+1
		for x in pos[0]-1..pos[0]+1
			if [x,y] != pos && map[[x,y]] == "#"
				count += 1
			end
		end
	end

	return count
end

def printMap(map, width, height) 
	for y in 0..(height-1)
		for x in 0..(width-1)
			print "#{map[[x,y]]}"
		end

		print "\n"
	end

	print "\n"
end

input = File.readlines(ARGV[0])

width = input[0].strip.length
height = input.length
area = Hash.new(".")
results = Hash.new

input.each_index do |y|
	line = input[y].strip.split("")

	line.each_index do |x|
		area[[x,y]] = line[x]
	end
end

printMap(area, width, height)

for i in 1..1000000000
	delta = Hash.new()

	for y in 0..(height-1)
		for x in 0..(width-1)
			if area[[x,y]] == "."
				if treecount(area, [x,y]) >= 3
					delta[[x,y]] = "|"
				end
			elsif area[[x,y]] == "|"
				if lumbercount(area, [x,y]) >= 3
					delta[[x,y]] = "#"
				end
			elsif area[[x,y]] == "#"
				if lumbercount(area, [x,y]) == 0 || treecount(area, [x,y]) == 0
					delta[[x,y]] = "."
				end
			end
		end
	end

	delta.each{|k,v| area[k] = v}
	# printMap(area, width, height)

	wood = area.select{|k,v| v == "|"}
	lumber = area.select{|k,v| v == "#"}
	result = wood.length * lumber.length

	if results.key?(area)
		print "#{i}\t: #{result} - same map as #{results[area]}\n"
	else
		print "#{i}\t: #{result}\n"
		results[area] = i
	end
end	
