local lg = love.graphics --Localize love.graphics
local dirs = { --8 directions
	{0, -1},
	{1, -1},
	{1, 0},
	{1, 1},
	{0, 1},
	{-1, 1},
	{-1, 0},
	{-1, -1}
}

local cave = {}
cave.__index = cave

function cave:getRenderedCanvas() --Renders itself to it's canvas and returns it
	self.canvas:renderTo(function()
		for y = 0, self.h - 1 do
			for x = 0, self.w - 1 do
				lg.draw(self.imgs[self.data[y][x]], x*self.tw, y*self.th)
			end
		end
	end)
	
	return self.canvas
end

function cave:step() --Performs a step(applies the cellular automata rules)
	local new = {}
	for y = 0, self.h-1 do
		new[y] = {}
		for x = 0, self.w-1 do
			local count = self:_countNeighbours(x, y)
			if self.data[y][x] == "alive" then
				new[y][x] = count < self.dl and "dead" or "alive"
			elseif self.data[y][x] == "dead" then
				new[y][x] = count > self.bl and "alive" or "dead"
			end
		end
	end
	self.data = new
end

function cave:_countNeighbours(x, y) --Function to count the number of alive neighbours of a cell, meant to be used internally
	local count = 0
	for _, d in ipairs(dirs) do
		local cx, cy = x + d[1], y + d[2]
		if not(self.data[cy] and self.data[cy][cx]) or self.data[cy][cx] == "alive" then
			count = count + 1
		end
	end
	return count
end

return function(w, h, bl, dl, chToAlive, wimg, eimg) --Construct and return a cave object
	local cv = {w = w, h = h, data = {}}
	cv.bl, cv.dl = bl, dl
	
	for y = 0, h - 1 do
		cv.data[y] = {}
		for x = 0, w - 1 do
			cv.data[y][x] = love.math.random() < chToAlive and "alive" or "dead"
		end
	end
	
	cv.imgs = {
		alive = lg.newImage(wimg),
		dead = lg.newImage(eimg)
	}
	
	cv.tw, cv.th = cv.imgs.alive:getWidth(), cv.imgs.alive:getHeight()
	
	cv.canvas = lg.newCanvas(w*cv.tw, h*cv.th)
	return setmetatable(cv, cave)
end