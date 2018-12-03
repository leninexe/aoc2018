f = File.open("input","r")

sum = 0

f.each_line do |line|
	sum += line.to_i
end

puts sum

f.close