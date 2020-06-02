local lg = love.graphics --Localize love.graphics
local newCave = require("cave") --Aqquire the cave constructor
local cave

--Values that affects the cellular automata
local birthLimit = 4
local deathLimit = 3
local chanceToStartAlive = 0.45

function love.load()
	enableFullscreenOnMobile()
	cave = newCave(lg.getWidth()/8, lg.getHeight()/8, birthLimit, deathLimit, chanceToStartAlive, "assets/wall.png", "assets/empty.png")
end

function love.draw()
	lg.draw(cave:getRenderedCanvas(), 0, 0)
end

function love.mousepressed(x)
	if x > lg.getWidth()/2 then
		cave:step()
	else
		cave = newCave(lg.getWidth()/8, lg.getHeight()/8, birthLimit, deathLimit, chanceToStartAlive, "assets/wall.png", "assets/empty.png")
	end
end

function love.keypressed(key)
	if key == "n" then
		cave = newCave(lg.getWidth()/8, lg.getHeight()/8, birthLimit, deathLimit, chanceToStartAlive, "assets/wall.png", "assets/empty.png")
	elseif key == "s" then
		cave:step()
	end
end