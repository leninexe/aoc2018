input = File.read("input").split("")
changes = false

begin
	changes = false

	input.each_with_index do |c, i|
		if i < input.length - 1
			if c.capitalize == input[i+1].capitalize && c != input[i+1]
				input[i] = ""
				input[i+1] = ""
				changes = true
			end
		end
	end

	input.delete("")
end while changes

puts input.length