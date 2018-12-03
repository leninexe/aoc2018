require 'set'

f = File.open("input","r")

doubleLetters = 0
tripleLetters = 0

f.each_line do |line|
	doubleFound = false
	tripleFound = false

	line.split("").each do |c|
		if line.count(c) == 2 && !doubleFound
			doubleLetters += 1
			doubleFound = true
		elsif line.count(c) == 3 && !tripleFound
			tripleLetters += 1
			tripleFound = true
		end

		if doubleFound && tripleFound
			break
		end
	end
end

f.close

puts doubleLetters
puts tripleLetters
puts doubleLetters * tripleLetters