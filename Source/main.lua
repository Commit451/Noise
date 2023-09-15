import "saveddata"

local savedData <const> = SavedData:new()

local snd = playdate.sound
local gfx = playdate.graphics

playdate.setAutoLockDisabled(true)

local maxFrequency <const> = 5000
local minFrequency <const> = 0
local isBButtonDown = false

local synth = snd.synth.new(playdate.sound.kWaveNoise)
local filter = snd.twopolefilter.new(playdate.sound.kFilterLowPass)
filter:setMix(1)
filter:setFrequency(savedData:getFilterFrequency())
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

function playdate.BButtonDown()
	isBButtonDown = true
end

function playdate.BButtonUp()
	isBButtonDown = false
end

function playdate.cranked(change, accelerationChange)
	if isBButtonDown then
		print("change: " .. change .. " accelerationChange: " .. accelerationChange)
		newFrequency = savedData:getFilterFrequency() - change
		if newFrequency < minFrequency then
			newFrequency = minFrequency
		end
		if newFrequency > maxFrequency then
			newFrequency = maxFrequency
		end
		print("newFrequency " .. newFrequency)
		savedData:updateFilterFrequency(newFrequency)
		filter:setFrequency(newFrequency)
		draw()
	end
end

function playdate.update()
	-- don't need to do anything really
end

function draw()
	gfx.clear(gfx.kColorWhite)
	gfx.drawText("Press A to start/stop", 100, 100)

	gfx.drawText("Hold B and crank to change filter", 100, 200)
	local roundedFrequency = math.floor(savedData:getFilterFrequency() + 0.5)
	gfx.drawText("" .. roundedFrequency .. " Hz", 100, 220)
end

startNoise()
draw()