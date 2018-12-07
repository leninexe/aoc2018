lines = File.readlines("input")

values = Hash.new()
alphas = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")

alphas.each_index do |i|
	values[alphas[i]] = i+1+60
end

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
second = 0
workers = Array.new(5, 0)
pending = Array.new(5, "")

done = false

while !sorted.empty? || !done
	workers.each_index do |i|
		if workers[i] == 0
			steps += pending[i]
			sorted.map{|k,v| v.delete(pending[i])}
		end
	end		

	puts steps

	sorted.each do |k, v|
		if v.empty?
			workers.each_index do |wi| 
				if workers[wi] <= 0
					sorted.delete(k)
					workers[wi] = values[k]
					pending[wi] = k
					break
				end
			end
		end
	end

	done = true

	workers.each_index do |i|
		print "worker#{i}: #{workers[i]} (#{pending[i]}); "
		puts

		if workers[i] > 0
			done = false
		end
	end

	workers.each_index{|i| print "worker#{i}: #{workers[i]} (#{pending[i]}); "}
	puts

	second += 1
	workers.map!{|w| w -= 1}
end

puts steps
puts second - 1