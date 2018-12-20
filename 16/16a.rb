input = File.readlines(ARGV[0])

samples = []

for i in 0..input.length - 1
	if input[i].start_with?("Before:")
		before = input[i].strip.gsub(/\s+/,"").scan(/\[[0-9]+,[0-9]+,[0-9]+,[0-9]+\]/).first.gsub(/\[/,"").gsub(/\]/,"").split(",").map{|v| v.to_i}
		after = input[i+2].strip.gsub(/\s+/,"").scan(/\[[0-9]+,[0-9]+,[0-9]+,[0-9]+\]/).first.gsub(/\[/,"").gsub(/\]/,"").split(",").map{|v| v.to_i}
		instruction = input[i+1].strip.split(" ").map{|v| v.to_i }

		samples << [before, after, instruction]

		i += 3
	end
end

# addr A B C -> reg C = reg A + reg B
def checkAddr(before, after, instruction)
	a = instruction[1] #reg
	b = instruction[2] #reg
	c = instruction[3] #reg

	return after[c] == before[a] + before[b]
end

# addi A B C -> reg C = reg A + val B
def checkAddi(before, after, instruction)
	a = instruction[1] #reg
	b = instruction[2] #val
	c = instruction[3] #reg

	return after[c] == before[a] + b
end

# mulr A B C -> reg C = reg A * reg B
def checkMulr(before, after, instruction)
	a = instruction[1] #reg
	b = instruction[2] #reg
	c = instruction[3] #reg

	return after[c] == before[a] * before[b]
end

# muli A B C -> reg C = reg A * val B
def checkMuli(before, after, instruction)
	a = instruction[1] #reg
	b = instruction[2] #val
	c = instruction[3] #reg

	return after[c] == before[a] * b
end

# banr A B C -> reg C = reg A & reg B
def checkBanr(before, after, instruction)
	a = instruction[1] #reg
	b = instruction[2] #reg
	c = instruction[3] #reg

	return after[c] == before[a] & before[b]
end

# bani A B C -> reg C = reg A & val B
def checkBani(before, after, instruction)
	a = instruction[1] #reg
	b = instruction[2] #val
	c = instruction[3] #reg

	return after[c] == before[a] & b
end

# borr A B C -> reg C = reg A | reg B
def checkBorr(before, after, instruction)
	a = instruction[1] #reg
	b = instruction[2] #reg
	c = instruction[3] #reg

	return after[c] == before[a] | before[b]
end

# bori A B C -> reg C = reg A | val B
def checkBori(before, after, instruction)
	a = instruction[1] #reg
	b = instruction[2] #val
	c = instruction[3] #reg

	return after[c] == before[a] | b
end

# setr A B C -> reg C = reg A
def checkSetr(before, after, instruction)
	a = instruction[1] #reg
	c = instruction[3] #reg

	return after[c] == before[a]
end

# seti A B C -> reg C = val A
def checkSeti(before, after, instruction)
	a = instruction[1] #val
	c = instruction[3] #reg

	return after[c] == a
end

# gtir A B C -> val A > reg B ? reg C = 1 : reg C = 0
def checkGtir(before, after, instruction)
	a = instruction[1] #val
	b = instruction[2] #reg
	c = instruction[3] #reg

	return (after[c] == 1 && a > before[b]) || (after[c] == 0 && a <= before[b])
end

# gtri A B C -> reg A > val B ? reg C = 1 : reg C = 0
def checkGtri(before, after, instruction)
	a = instruction[1] #reg
	b = instruction[2] #val
	c = instruction[3] #reg

	return (after[c] == 1 && before[a] > b) || (after[c] == 0 && before[a] <= b)
end

# gtrr A B C -> reg A > reg B ? reg C = 1 : reg C = 0
def checkGtrr(before, after, instruction)
	a = instruction[1] #reg
	b = instruction[2] #reg
	c = instruction[3] #reg

	return (after[c] == 1 && before[a] > before[b]) || (after[c] == 0 && before[a] <= before[b])
end

# eqir A B C -> val A == reg B ? reg C = 1 : reg C = 0
def checkEqir(before, after, instruction)
	a = instruction[1] #val
	b = instruction[2] #reg
	c = instruction[3] #reg

	return (after[c] == 1 && a == before[b]) || (after[c] == 0 && a != before[b])
end

# eqri A B C -> reg A == val B ? reg C = 1 : reg C = 0
def checkEqri(before, after, instruction)
	a = instruction[1] #reg
	b = instruction[2] #val
	c = instruction[3] #reg

	return (after[c] == 1 && before[a] == b) || (after[c] == 0 && before[a] != b)
end

# eqrr A B C -> reg A == reg B ? reg C = 1 : reg C = 0
def checkEqrr(before, after, instruction)
	a = instruction[1] #reg
	b = instruction[2] #reg
	c = instruction[3] #reg

	return (after[c] == 1 && before[a] == before[b]) || (after[c] == 0 && before[a] != before[b])
end

count = 0

samples.each do |s|
	b = s[0]
	a = s[1]
	i = s[2]

	result = [checkAddr(b,a,i), checkAddi(b,a,i), checkMulr(b,a,i), checkMuli(b,a,i), checkBanr(b,a,i), checkBani(b,a,i), checkBorr(b,a,i), checkBori(b,a,i), checkSetr(b,a,i), checkSeti(b,a,i), checkGtir(b,a,i), checkGtri(b,a,i), checkGtrr(b,a,i), checkEqir(b,a,i), checkEqri(b,a,i), checkEqrr(b,a,i)]
	result.delete_if{|v| v == false}

	if result.length >= 3
		count += 1
	end
end

print "Count: #{count}\n"