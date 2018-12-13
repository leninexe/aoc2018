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
	deletions = []
	positions = Hash.new()
	carts.sort!{|x,y| x.position[1] == y.position[1] ? x.position[0] - y.position[0] : x.position[1] - y.position[1]}
	carts.each{|c| positions[c.position] = c}

	carts.each do |c|
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

		positions.delete(previous)

		if positions.has_key?(c.position)
			deletions << c
			deletions << positions[c.position]
			positions.delete(c.position)
		else
			positions[c.position] = c
		end
	end

	carts.delete_if{|c| deletions.include?(c)}

	if carts.length == 1
		print "#{carts[0].position}\n"
		break
	end
end