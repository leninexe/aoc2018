input = File.readlines(ARGV[0])
state = input[0].split(":")[1].strip.split("")
rules = Hash.new(".")

for i in 2..(input.length - 1)
	splitter = input[i].split("=>")
	rules[splitter[0].strip] = splitter[1].strip
end

offset = -3

(0..2).each{state.unshift("."); state << "."}

state.each{|s| print "#{s}"}
puts
print "#{rules}\n"

for i in 1..20
	nextState = Array.new(state.length, ".")
	
	for i in 2..(state.length - 3)
		nextState[i] = rules["#{state[i-2]}#{state[i-1]}#{state[i]}#{state[i+1]}#{state[i+2]}"]
	end

	state = nextState
	appendFront = 0
	appendEnd = 0

	(0..4).each do |i| 
		if state[i] != "."
			appendFront = 4 - i
			break
		end
	end

	(0..4).each do |i|
		if state[state.length - 1 - i] != "."
			appendEnd = 4 - i
			break
		end
	end

	offset -= appendFront

	(1..appendFront).each{state.unshift(".")}
	(1..appendEnd).each{state << "."}

	state.each{|s| print "#{s}"}
	puts
end	

sum = 0

state.each_index do |i|
	if state[i] == "#"
		sum += i + offset
	end
end

puts sum