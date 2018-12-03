input = File.readlines("input")

input.each.with_index do |line, index|
	parts = line.split(" ")
	offset = parts[2].sub(":","").split(",")
	dimension = parts[3].split("x")

	id = parts[0]
	x = offset[0].to_i
	y = offset[1].to_i

	width = dimension[0].to_i
	height = dimension[1].to_i

	overlapping = false

	input.each do |line2|
		p2 = line2.split(" ")
		o2 = p2[2].sub(":","").split(",")
		d2 = p2[3].split("x")

		cid = p2[0]
		cx = o2[0].to_i
		cy = o2[1].to_i

		cwidth = d2[0].to_i
		cheight = d2[1].to_i

		if cid != id
			if x >= cx && x < cx + cwidth
				if (y >= cy && y < cy + cheight) || (cy >= y && cy < y + height)
					overlapping = true
				end
			elsif cx >= x && cx < x + width
				if (y >= cy && y < cy + cheight) || (cy >= y && cy < y + height)
					overlapping = true
				end 
			end
		end

		if overlapping
			break
		end
	end

	if !overlapping
		puts id
		break
	end
end