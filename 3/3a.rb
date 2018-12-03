# First part
f = File.open("input","r")
input = f.read

fabric = Array.new(1000) { Array.new(1000, ".") }

input.each_line do |line|
	parts = line.split(" ")
	offset = parts[2].sub(":","").split(",")
	dimension = parts[3].split("x")

	id = offset[0]
	x = offset[0].to_i
	y = offset[1].to_i

	width = dimension[0].to_i
	height = dimension[1].to_i

	for yy in (0...height)
		for xx in (0...width)
			if fabric[y+yy][x+xx] == "."
				fabric[y+yy][x+xx] = "#"
			else
				fabric[y+yy][x+xx] = "D"
			end
		end
	end
end

doubleInches = 0

fabric.each do |line|
	line.each do |f| 
		if f == "D"
			doubleInches += 1
		end
	end
end 

puts doubleInches

f.close
