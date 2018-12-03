require 'set'

foundDuplicate = false
sum = 0
set = Set.new()

while !foundDuplicate do
	f = File.open("input","r")

	f.each_line do |line|
		sum += line.to_i

		if set.include?(sum)
			# duplicate found
			puts sum
			f.close
			exit
		else
			set.add(sum)
		end
	end 

	f.close
end