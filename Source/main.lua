local snd = playdate.sound
local gfx = playdate.graphics

playdate.setAutoLockDisabled(true)

local maxFrequency <const> = 5000
local minFrequency <const> = 0
local currentFrequency = 300

local synth = snd.synth.new(playdate.sound.kWaveNoise)
local filter = snd.twopolefilter.new(playdate.sound.kFilterLowPass)
filter:setMix(1)
filter:setFrequency(currentFrequency)
filter:setResonance(0)

snd.addEffect(filter)

function startNoise()
	synth:playNote("C4", 1.0)
end

function playdate.AButtonUp()
	if synth:isPlaying() then
		synth:stop()
	else
		startNoise()
	end
end

function playdate.cranked(change, accelerationChange)
	print("change: " .. change .. " accelerationChange: " .. accelerationChange)
	currentFrequency = currentFrequency - change
	if currentFrequency < minFrequency then
		currentFrequency = minFrequency
	end
	if currentFrequency > maxFrequency then
		currentFrequency = maxFrequency
	end
	print("currentFrequency " .. currentFrequency)
	filter:setFrequency(currentFrequency)
	draw()
end

function playdate.update()
	-- don't need to do anything really
end

function draw()
	gfx.clear(gfx.kColorWhite)
	gfx.drawText("Press A to start/stop", 100, 100)

	gfx.drawText("Crank to change filter", 100, 200)
	local roundedFrequency = math.floor(currentFrequency + 0.5)
	gfx.drawText("" .. roundedFrequency, 100, 220)
end

startNoise()
draw()