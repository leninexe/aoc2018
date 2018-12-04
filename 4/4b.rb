list = File.readlines "input"
guards = Hash.new

sortedList = list.sort { |x,y| x[1..16] <=> y[1..16]}
guardId = ""
sequence = ""
lastChange = 0
minutes = 0

sortedList.each do |line|
	minutes = line[15..16].to_i
	action = line[19..-1]

	if action.start_with?("Guard")
		if guardId != ""
			if !guards.has_key?(guardId)
				guards[guardId] = Array.new
			end

			guards[guardId] << sequence
		end

		guardId = action.split(" ")[1]
		sequence = "." * 60
		lastChange = 0
	elsif action.start_with?("falls asleep")
		sequence[minutes..60] = "#" * (60 - minutes)
	elsif action.start_with?("wakes up")
		sequence[minutes..60] = "." * (60 - minutes)
	end
end

maxSleep = 0
sleepyGuard = ""
maxSleepyHours = Array.new()

guards.each_key do |guard|
	sleepyHours = Array.new(60, 0)

	guards[guard].each do |schedule|
		schedule.split("").each_with_index do |c, i|
			if c == "#"
				sleepyHours[i] += 1
			end
		end
	end

	if sleepyHours.max >= maxSleep
		maxSleep = sleepyHours.max
		maxSleepyHours = sleepyHours
		sleepyGuard = guard
	end
end	

puts sleepyGuard[1..-1].to_i * maxSleepyHours.each_with_index.max[1] 