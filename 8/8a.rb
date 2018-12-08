$meta = 0

def analyze_node(nodetext)
	countChildren = nodetext[0].to_i
	countMeta = nodetext[1].to_i
	offset = 2

	print "#{countChildren} - #{countMeta}\n"

	if countChildren > 0
		i = 0

		while i < countChildren
			offset += analyze_node(nodetext[offset..-1])
			puts offset
			i += 1
		end
	end

	if countMeta > 0
		i = 0
		
		while i < countMeta
			$meta += nodetext[offset + i].to_i
			i += 1
		end
	end

	return offset + countMeta
end

input = File.readlines("input")[0].split(" ")

analyze_node(input)
puts $meta