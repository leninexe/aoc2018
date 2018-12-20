# program = File.readlines("test_input")
program = File.readlines(ARGV[0])

pc = 0
boundreg = program[0].split(" ")[1].to_i
program.delete_at(0)

reg = Array.new(6,0)
line = program[0]

while true
	reg[boundreg] = pc

	print "ip=#{pc} #{reg}"

	splitter = line.split(" ")
	cmd = splitter[0]
	a = splitter[1].to_i
	b = splitter[2].to_i
	c = splitter[3].to_i

	print " #{cmd} #{a} #{b} #{c}"

	if cmd == "addr"
		reg[c] = reg[a] + reg[b]
	elsif cmd == "addi"
		reg[c] = reg[a] + b
	elsif cmd == "mulr"
		reg[c] = reg[a] * reg[b]
	elsif cmd == "muli"
		reg[c] = reg[a] * b
	elsif cmd == "banr"
		reg[c] = reg[a] & reg[b]
	elsif cmd == "bani"
		reg[c] = reg[a] & b
	elsif cmd == "borr"
		reg[c] = reg[a] | reg[b]
	elsif cmd == "bori"
		reg[c] = reg[a] | b
	elsif cmd == "setr"
		reg[c] = reg[a]
	elsif cmd == "seti"
		reg[c] = a
	elsif cmd == "gtir"
		reg[c] = a > reg[b] ? 1 : 0
	elsif cmd == "gtri"
		reg[c] = reg[a] > b ? 1 : 0
	elsif cmd == "gtrr"
		reg[c] = reg[a] > reg[b] ? 1 : 0
	elsif cmd == "eqir"
		reg[c] = a == reg[b] ? 1 : 0
	elsif cmd == "eqri"
		reg[c] = reg[a] == b ? 1 : 0
	elsif cmd == "eqrr"
		reg[c] = reg[a] == reg[b] ? 1 : 0
	else
		print "PROGRAMERROR\n"
	end

	print " #{reg}\n"

	pc = reg[boundreg] + 1

	break if pc < 0 || pc > program.length - 1

	line = program[pc]
end

print "Reg0 = #{reg[0]}\n"
