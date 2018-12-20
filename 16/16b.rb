input = File.readlines(ARGV[0])
# input = File.readlines("input")

lastSample = 0
samples = []

for i in 0..input.length - 1
	if input[i].start_with?("Before:")
		before = input[i].strip.gsub(/\s+/,"").scan(/\[[0-9]+,[0-9]+,[0-9]+,[0-9]+\]/).first.gsub(/\[/,"").gsub(/\]/,"").split(",").map{|v| v.to_i}
		after = input[i+2].strip.gsub(/\s+/,"").scan(/\[[0-9]+,[0-9]+,[0-9]+,[0-9]+\]/).first.gsub(/\[/,"").gsub(/\]/,"").split(",").map{|v| v.to_i}
		instruction = input[i+1].strip.split(" ").map{|v| v.to_i }

		samples << [before, after, instruction]

		i += 3
		lastSample = i
	end
end

program = []

for i in lastSample..input.length - 1
	if input[i].strip != ""
		program << input[i].split(" ").map{|v| v.to_i }
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

instructions = Hash.new
completed = false

while !completed
	completed = true

	samples.each do |s|
		b = s[0]
		a = s[1]
		i = s[2]

		if !instructions.has_key?(i[0])
			completed = false
			result = Hash.new

			result["addr"] = checkAddr(b,a,i)
			result["addi"] = checkAddi(b,a,i)
			result["mulr"] = checkMulr(b,a,i)
			result["muli"] = checkMuli(b,a,i)
			result["banr"] = checkBanr(b,a,i)
			result["bani"] = checkBani(b,a,i)
			result["borr"] = checkBorr(b,a,i)
			result["bori"] = checkBori(b,a,i)
			result["setr"] = checkSetr(b,a,i)
			result["seti"] = checkSeti(b,a,i)
			result["gtir"] = checkGtir(b,a,i)
			result["gtri"] = checkGtri(b,a,i)
			result["gtrr"] = checkGtrr(b,a,i)
			result["eqir"] = checkEqir(b,a,i)
			result["eqri"] = checkEqri(b,a,i)
			result["eqrr"] = checkEqrr(b,a,i)

			result.delete_if{|k,v| v == false || instructions.has_value?(k) }

			if result.length == 1
				instructions[i[0]] = result.keys[0]
			end
		end
	end
end

print "#{instructions}\n"

reg = [0,0,0,0]

program.each do |pc|
	i = instructions[pc[0]]
	a = pc[1]
	b = pc[2]
	c = pc[3]

	if i == "addr"
		reg[c] = reg[a] + reg[b]
	elsif i == "addi"
		reg[c] = reg[a] + b
	elsif i == "mulr"
		reg[c] = reg[a] * reg[b]
	elsif i == "muli"
		reg[c] = reg[a] * b
	elsif i == "banr"
		reg[c] = reg[a] & reg[b]
	elsif i == "bani"
		reg[c] = reg[a] & b
	elsif i == "borr"
		reg[c] = reg[a] | reg[b]
	elsif i == "bori"
		reg[c] = reg[a] | b
	elsif i == "setr"
		reg[c] = reg[a]
	elsif i == "seti"
		reg[c] = a
	elsif i == "gtir"
		reg[c] = a > reg[b] ? 1 : 0
	elsif i == "gtri"
		reg[c] = reg[a] > b ? 1 : 0
	elsif i == "gtrr"
		reg[c] = reg[a] > reg[b] ? 1 : 0
	elsif i == "eqir"
		reg[c] = a == reg[b] ? 1 : 0
	elsif i == "eqri"
		reg[c] = reg[a] == b ? 1 : 0
	elsif i == "eqrr"
		reg[c] = reg[a] == reg[b] ? 1 : 0
	else
		print "PROGRAMERROR\n"
	end
end

print "#{reg[0]}\n"