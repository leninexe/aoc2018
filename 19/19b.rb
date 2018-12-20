a = 0
d = 10551396

for b in 1..d
	for f in 1..d
		if b * f == d
			print "#{b} * #{f} == #{d}\n"
			a += b
		end

		break if b * f >= d
	end
end

print "Result = #{a}\n"