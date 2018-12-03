f = File.open("input","r")
contents = f.read
duplicate = contents
foundCode = false

contents.each_line do |line|
	duplicate.each_line do |other_line|
		differences = 0

		line.each_char.with_index do |c, idx|
			if c != other_line[idx]
				differences += 1
			end
		end

		if differences == 1
			puts line
			puts other_line
			foundCode = true
			break
		end
	end

	if foundCode
		break
	end
end

f.close