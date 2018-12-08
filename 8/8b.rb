$meta = 0

def analyze_node(nodetext)
	countChildren = nodetext[0].to_i
	countMeta = nodetext[1].to_i
	offset = 2

	childSums = Array.new(countChildren, 0)
	meta = Array.new(countMeta, 0)

	if countChildren > 0
		i = 0

		while i < countChildren
			childResult = analyze_node(nodetext[offset..-1])
			offset += childResult[0]
			childSums[i] = childResult[1]
			i += 1
		end
	end

	if countMeta > 0
		i = 0
		
		while i < countMeta
			meta[i] = nodetext[offset + i].to_i
			i += 1
		end
	end

	sum = 0

	if countChildren == 0
		meta.each{|x| sum += x}
	else
		meta.each_index do |i|
			if meta[i] - 1 >= 0 && meta[i] - 1 < countChildren
				sum += childSums[meta[i] - 1]
			end
		end 
	end

	puts countChildren
	puts countMeta
	print "childSums: #{childSums}\n"
	print "meta: #{meta}\n"

	return offset + countMeta, sum
end

input = File.readlines("input")[0].split(" ")

result = analyze_node(input)
puts result[1]