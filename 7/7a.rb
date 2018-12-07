lines = File.readlines("input")

done = []
todo = Hash.new()

lines.each do |l|
	splitter = l.split(" ")
	step = splitter[7]
	precondition = splitter[1]

	if !todo.has_key?(step)
		todo[step] = []
	end

	if !todo.has_key?(precondition)
		todo[precondition] = []
	end

	todo[step] << precondition
end  

sorted = Hash[todo.sort]

sorted.each do |k, v|
	print "#{k} waits for: "

	v.each do |pre|
		print "#{pre};"
	end

	puts
end

steps = ""

while !sorted.empty?
	step = nil

	sorted.each do |k, v|
		if v.empty?
			step = k
			sorted.delete(k)
			break
		end
	end

	sorted.map{|k,v| v.delete(step)}
	steps += step
end

puts steps