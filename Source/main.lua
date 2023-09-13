local snd = playdate.sound
local gfx = playdate.graphics

playdate.setAutoLockDisabled(true)

local currentFrequency = 400

local synth = snd.synth.new(playdate.sound.kWaveNoise)
local filter = snd.twopolefilter.new(playdate.sound.kFilterLowPass)
filter:setMix(1)
filter:setFrequency(currentFrequency)

snd.addEffect(filter)

function startNoise()
	synth:playNote("C4", 0.1)
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
	gfx.drawText("" .. currentFrequency, 100, 220)
end

startNoise()
draw()