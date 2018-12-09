input = File.readlines("input")[0].split(" ")

players = input[0].to_i
marbles = input[6].to_i * 100

puts players
puts marbles

currentGame = Array.new(1, 0)
playerScore = Hash.new(0)
currentMarble = 0
playedMarble = 0

while playedMarble < marbles
	player = (playedMarble % players) + 1
	playedMarble += 1

	if playedMarble % 23 == 0
		removePosition = (currentMarble - 7) % currentGame.size
		playerScore[player] += playedMarble + currentGame[removePosition]

		currentGame.delete_at(removePosition)
		currentMarble = removePosition
	else
		if currentGame.size == 1
			currentMarble = 1
			currentGame << playedMarble
		else 
			nextPosition = ((currentMarble + 1) % currentGame.size + 1)
			currentMarble = nextPosition
			currentGame.insert(currentMarble, playedMarble)
		end
	end

	if playedMarble % 100 == 0
		puts playedMarble
	end
end

puts 

maxValue = 0
maxPlayer = 0

playerScore.each do |k,v|
	if v > maxValue
		maxValue = v
		maxPlayer = k
	end
end

print "#{maxPlayer}: #{maxValue}\n"