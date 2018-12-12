input = File.readlines(ARGV[0])
generations = ARGV[1].to_i
initialState = input[0].split(":")[1].strip.split("")
state = Hash.new(".")
rules = Hash.new(".")

for i in 2..(input.length - 1)
	splitter = input[i].split("=>")
	rules[splitter[0].strip] = splitter[1].strip
end

initialState.each_index{|i| state[i] = initialState[i]}

for i in 1..generations
	nextState = Hash.new(".")

	min = state.keys.min - 5

	state.each do |k,v|
		(1..4).each do |x|
			kx = 5-x

			if k-kx > min && state[k-kx] == "."
				nextVal = rules["#{state[k-kx-2]}#{state[k-kx-1]}#{state[k-kx]}#{state[k-kx+1]}#{state[k-kx+2]}"]

				if nextVal == "#"
					nextState[k-kx] = nextVal
				end
			end
		end

		nextVal = rules["#{state[k-2]}#{state[k-1]}#{state[k]}#{state[k+1]}#{state[k+2]}"]

		if nextVal == "#"
			nextState[k] = nextVal
		end

		min = k

		(1..4).each do |kx|
			if state[k+kx] == "."
				nextVal = rules["#{state[k+kx-2]}#{state[k+kx-1]}#{state[k+kx]}#{state[k+kx+1]}#{state[k+kx+2]}"]

				if nextVal == "#"
					nextState[k+kx] = nextVal
					min = k+kx
				end
			else
				break
			end
		end
	end

	state = nextState

	# Print sum + count every 100k iterations
	# You can see that the value just changes at the 100k-Position, 
	# so it's easy to calculate the value for 50B iterations

	if i % 100000 == 0
		count = 0
		sum = 0

		state.each do |k, v|
			if v == "#"
				count += 1
				sum += k
			end
		end

		print "#{i}:\t|#{sum}|#{count}|\n"
	end
end

puts

sum = 0

state.each do |k, v|
	if v == "#"
		sum += k
	end
end

puts sum