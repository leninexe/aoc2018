class Recipe
	def initialize (score)
		@score = score
	end

	attr_reader :score
	attr_accessor :left, :right
end

input = File.readlines(ARGV[0])[0].strip.to_i
first = Recipe.new(3)
last = Recipe.new(7)
first.left = last
first.right = last
last.left = first
last.right = first

insert = -> a, c, b {a.right = c; c.left = a; b.left = c; c.right = b; c }

e1 = first
e2 = last
count = 2
result = []

while count < input + 10
	sum = e1.score + e2.score

	if sum < 10
		count += 1
		last = insert[last, Recipe.new(sum), first]
	else
		count += 2
		last = insert[last, Recipe.new(sum/10), first]
		last = insert[last, Recipe.new(sum%10), first]
	end

	steps1 = 1 + e1.score
	steps2 = 1 + e2.score

	for i in 1..steps1
		e1 = e1.right
	end

	for i in 1..steps2
		e2 = e2.right
	end
end

if count == input + 10 + 1
	last = last.left
end

for i in 1..10
	result.unshift(last.score)
	last = last.left
end

result.each{|i| print "#{i}"}

puts