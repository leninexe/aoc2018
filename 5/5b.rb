input = File.read("input").split("")
letters = [].replace(input).map{|c| c.downcase}.uniq

minResult = input.length
minLetter = ""

letters.each do |letter|
	tempInput = [].replace(input)
	tempInput.delete(letter)
	tempInput.delete(letter.capitalize)

	changes = false

	begin
		changes = false

		tempInput.each_with_index do |c, i|
			if i < tempInput.length - 1
				if c.capitalize == tempInput[i+1].capitalize && c != tempInput[i+1]
					tempInput[i] = ""
					tempInput[i+1] = ""
					changes = true
				end
			end
		end

		tempInput.delete("")
	end while changes

	if tempInput.length <= minResult
		minResult = tempInput.length
		minLetter = letter
	end
end	

print "#{minLetter}: #{minResult}"
puts