class Cart
	def initialize(position, direction)
			@position = position
			@direction = direction
			@turn = 0
	end

	attr_reader :position, :direction, :turn
	attr_writer :position, :direction, :turn
end

# directions: 0 right, 1 down, 2 left, 3 up

input = File.readlines(ARGV[0])
rails = Hash.new(" ")
carts = Array.new()

maxX = 0
maxY = input.length

input.each_index do |y|
	line = input[y].split("")

	line.each_index do |x|
		if line[x] == "<" || line[x] == ">"
			carts << Cart.new([x,y], line[x])
			rails[[x,y]] = "-"
		elsif line[x] == "^" || line[x] == "v"
			carts << Cart.new([x,y], line[x])
			rails[[x,y]] = "|"
		elsif line[x] == "/" || line[x] == "\\" || line[x] == "-" || line[x] == "|" || line[x] == "+"
			rails[[x,y]] = line[x]
		end

		if x > maxX
			maxX = x
		end
	end
end

crashed = 0

while true
	positions = Hash.new(0)
	carts.sort!{|x,y| x.position[1] == y.position[1] ? x.position[0] - y.position[0] : x.position[1] - y.position[1]}
	carts.each{|c| positions[c.position] = 1}

	carts.each_index do |i|
		c = carts[i]
		# print "#{c.position} - #{c.direction}\n"
		previous = []
		previous.replace(c.position)

		if c.direction == ">"
			c.position[0] += 1

			if rails[c.position] == "/"
				c.direction = "^"
			elsif rails[c.position] == "\\"
				c.direction = "v"
			elsif rails[c.position] == "+"
				if c.turn == 0
					c.direction = "^"
				elsif c.turn == 2
					c.direction = "v"
				end

				c.turn = (c.turn + 1) % 3
			end
		elsif c.direction == "v"
			c.position[1] += 1
			
			if rails[c.position] == "/"
				c.direction = "<"
			elsif rails[c.position] == "\\"
				c.direction = ">"
			elsif rails[c.position] == "+"
				if c.turn == 0
					c.direction = ">"
				elsif c.turn == 2
					c.direction = "<"
				end

				c.turn = (c.turn + 1) % 3
			end
		elsif c.direction == "<"
			c.position[0] -= 1

			if rails[c.position] == "/"
				c.direction = "v"
			elsif rails[c.position] == "\\"
				c.direction = "^"
			elsif rails[c.position] == "+"
				if c.turn == 0
					c.direction = "v"
				elsif c.turn == 2
					c.direction = "^"
				end

				c.turn = (c.turn + 1) % 3
			end
		elsif c.direction == "^"
			c.position[1] -= 1
			
			if rails[c.position] == "/"
				c.direction = ">"
			elsif rails[c.position] == "\\"
				c.direction = "<"			
			elsif rails[c.position] == "+"
				if c.turn == 0
					c.direction = "<"
				elsif c.turn == 2
					c.direction = ">"
				end

				c.turn = (c.turn + 1) % 3
			end
		end

		if positions[c.position] > 0
			print "Crash at #{c.position}\n"
			crashed += 1
			break
		end

		positions[previous] -= 1
		positions[c.position] += 1
	end

	break if crashed > 0
end