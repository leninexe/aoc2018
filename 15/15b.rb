$mapHistory = Hash.new

class MapPoint
	def initialize(pos, type, distances)
	end
end

class Unit
	def initialize(pos, ap, hp)
		@pos = pos
		@ap = ap
		@hp = hp
	end

	attr_accessor :pos, :ap, :hp
end

class Elve < Unit
end

class Goblin < Unit
end

def neighbors(pos1, pos2)
	return (pos1[0]-pos2[0]).abs + (pos1[1]-pos2[1]).abs == 1
end

def findNeighbors(map, pos) 
	[[pos[0],pos[1]-1],[pos[0],pos[1]+1],[pos[0]-1,pos[1]],[pos[0]+1, pos[1]]].delete_if{|pt| map[pt] != "."}
end

def findDistance(map, pos1, pos2, max)
	#dijkstra

	if $mapHistory.has_key?([map, pos1, pos2])
		return $mapHistory[[map, pos1, pos2]]
	end

	dist = Hash.new(50000)
	prev = Hash.new
	q = Array.new

	map.each do |k,v|
		q << k
	end

	dist[pos1] = 0

	while !q.empty? 
		q.sort!{|v1,v2| dist[v1] == dist[v2] ? (v1[1] == v2[1] ? v1[0] - v2[0] : v1[1] - v2[1]): dist[v1] - dist[v2]}
		u = q.delete_at(0)
		n = findNeighbors(map, u)

		break if u == pos2

		n.each do |v|
			alt = dist[u] + 1

			if alt < dist[v]
				dist[v] = alt
				prev[v] = u
			end
		end
	end

	s = []
	u = pos2

	if prev.has_key?(u) || u == pos1
		while u != nil
			s.unshift(u)
			u = prev[u]
		end

		$mapHistory[[map, pos1, pos2]] = [s.length - 1, s[1]]

		return [s.length - 1, s[1]]
	end

	$mapHistory[[map, pos1, pos2]] = [-1, []]

	return [-1,[]]
end

def findNextSteps(map, pos, opponents)
	result = Array.new
	minDistance = -1
	myCandidates = findNeighbors(map, pos)

	nearestOpponents = opponents.values.sort{|o1,o2| ((o1.pos[0] - pos[0]).abs + (o1.pos[1] - pos[1]).abs) - ((o2.pos[0] - pos[0]).abs + (o2.pos[1] - pos[1]).abs)}

	nearestOpponents.each do |o|
		break if minDistance != -1 && (((o.pos[0] - pos[0]).abs + (o.pos[1] - pos[1]).abs) - 2) > minDistance

		candidates = findNeighbors(map, o.pos)

		candidates.each do |cdt|
			dist = findDistance(map, pos, cdt, minDistance)
			dist << cdt

			if dist[0] != -1
				if dist[0] <= minDistance || minDistance == -1
					result << dist
					minDistance = dist[0]
				end
			end
		end		
	end

	if minDistance > -1
		result.delete_if{|o| o[0] > minDistance}
		result.sort!{|s1,s2| s1[2] == s2[2] ? (s1[1][1] == s2[1][1] ? s1[1][0] - s2[1][0] : s1[1][1] - s2[1][1]) : (s1[2][1] == s2[2][1] ? s1[2][0] - s2[2][0] : s1[2][1] - s2[2][1])}
		return result
	end

	return []
end

def findOpponentsToAttack(map, pos, opponents)
	result = Array.new

	opponents.values.each do |o|
		if neighbors(pos, o.pos)
			result << o	
		end
	end

	result.sort!{|o1,o2| o1.hp == o2.hp ? (o1.pos[1] == o2.pos[1] ? o1.pos[0] - o2.pos[0] : o1.pos[1] - o2.pos[1]) : o1.hp - o2.hp}
end

def printMap(map, width, height)
	for y in 0..height
		for x in 0..width
			print "#{map[[x,y]]}"
		end

		print "\n"
	end
end

file = File.readlines(ARGV[0])
ap = 3
hp = 200
elvesap = ARGV[1].to_i

while true	
	input = file
	map = Hash.new("#")
	goblins = Hash.new
	elves = Hash.new
	elvesap += 1

	width = 0
	height = input.length - 1

	input.each_index do |y|
		l = input[y]
		chars = l.strip.split("")

		chars.each_index do |x|
			c = chars[x]

			if c == "G"
				goblins[[x,y]] = Goblin.new([x,y], ap, hp)
				map[[x,y]] = "#"
			elsif c == "E"
				elves[[x,y]] = Elve.new([x,y], elvesap, hp)
				map[[x,y]] = "#"
			else
				map[[x,y]] = c
			end

			if x > width
				width = x
			end
		end
	end

	iterations = 0
	elvedied = false

	while !elvedied
		print "ITERATION: #{iterations}\n"
		print "------------------------------\n"

		iterations += 1

		units = []
		goblins.each{|k,v| units << v}
		elves.each{|k,v| units << v}
		units.sort!{|u1,u2| u1.pos[1] == u2.pos[1] ? u1.pos[0] - u2.pos[0] : u1.pos[1] - u2.pos[1]}

		units.each do |u|
			next if u.hp <= 0

			print "#{u.instance_of?(Elve) ? 'E' : 'G'}: #{u.pos} - #{u.hp} -> "
			opponents = findOpponentsToAttack(map, u.pos, u.instance_of?(Elve) ? goblins : elves)

			if !opponents.empty?
				# attack
				victim = u.instance_of?(Elve) ? goblins[opponents[0].pos] : elves[opponents[0].pos]
				victim.hp -= u.ap

				print "ATTACK! #{victim.pos}"

				if victim.hp <= 0
					if victim.instance_of?(Elve)
						elvedied = true
					end

					map[victim.pos] = "."
					goblins.delete_if{|k,v| v.hp <= 0}
					elves.delete_if{|k,v| v.hp <= 0}
				end
			else
				# move
				steps = findNextSteps(map, u.pos, u.instance_of?(Elve) ? goblins : elves)

				if !steps.empty?
					oldpos = u.pos
					newpos = steps[0][1]

					print "MOVE! #{newpos}"

					map[oldpos] = "."
					map[newpos] = "#"
					u.pos = newpos

					if u.instance_of?(Elve)
						elves[newpos] = u
						elves.delete(oldpos)
					elsif u.instance_of?(Goblin)
						goblins[newpos] = u
						goblins.delete(oldpos)
					end

					# and attack!
					opponents = findOpponentsToAttack(map, u.pos, u.instance_of?(Elve) ? goblins : elves)

					if !opponents.empty?
						# attack
						victim = u.instance_of?(Elve) ? goblins[opponents[0].pos] : elves[opponents[0].pos]
						victim.hp -= u.ap

						print " -> ATTACK! #{victim.pos}"

						if victim.hp <= 0
							map[victim.pos] = "."
							goblins.delete_if{|k,v| v.hp <= 0}
							elves.delete_if{|k,v| v.hp <= 0}
						end
					end
				end
			end

			print "\n"	
		end

		print "\n\n----------\n\n"

		# print field

		for y in 0..height
			appendix = ""
			for x in 0..width
				if elves.has_key?([x,y])
					appendix += "E(#{elves[[x,y]].hp})"
					print "E"
				elsif goblins.has_key?([x,y])
					appendix += "G(#{goblins[[x,y]].hp})"
					print "G"
				else
					print "#{map[[x,y]]}"
				end
			end

			print " #{appendix}\n"
		end

		print "\n----------\n\n"

		break if goblins.empty? || elves.empty?
	end

	rounds = iterations - 1
	sumhp = 0

	if goblins.empty?
		elves.values.each{|e| sumhp += e.hp}
	elsif elves.empty?
		goblins.values.each{|g| sumhp += g.hp}
	end

	print "Iterations: #{rounds}\n"
	print "Elve ap: #{elvesap}\n"
	print "Remaining hp: #{sumhp}\n"
	print "Result: #{rounds * sumhp}\n"

	if !elvedied
		print "Elves won without losses!\n"
		break
	end
end