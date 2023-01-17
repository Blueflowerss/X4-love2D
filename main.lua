require "scene"
lunajson = require 'lunajson'
vector = require("vector")
inspect = require("inspect")
require "functions"
require "input"
stateMachine = require("knife.behavior")
classObject = require("knife.base")
eventObject = require("knife.event")
timerObject = require("knife.timer")
require "objects"
gamera = require("gamera")
tick = require("tick")
slab = require("Slab")
require("menus")
require "planetGeneration"
require("randomlua")

require "global"
io.stdout:setvbuf('no')
function love.load()
  slab.Initialize()
  love.filesystem.setIdentity("X4")  
  love.window.setMode(800, 600, {resizable=true})
  love.window.setTitle("Another X4 game - Love2D")
  tick.framerate = 60
  global.initializeGame()
  Scene.Load(global.scenes["SPACEMENU"])
  global.gameScene = "SPACEMENU"
end

-- rewrote run function to handle love and scene functions in a "clean" way
function love.quit()
  if Scene.quit then
    Scene.quit()
  end
end
function love.run()
	if love.load then
		love.load(love.arg.parseGameArguments(arg), arg)
	end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then
		love.timer.step()
	end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a, b, c, d, e, f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() or not Scene.quit() then
						return a or 0
					end
				end
				love.handlers[name](a, b, c, d, e, f)
				Scene[name](a, b, c, d, e, f) -- handle scene event, if any
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then
			dt = love.timer.step()
		end

		-- Call update and draw
		if love.update then
			love.update(dt)
		end -- will pass 0 if love.timer is disabled
		Scene.update(dt)

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then
				love.draw()
			end
			Scene.draw()
			love.graphics.present()
		end

		if love.timer then
			love.timer.sleep(0.001)
		end
	end
end