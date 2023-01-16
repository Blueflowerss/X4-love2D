--[[
Scene usage example
]]
require "scene"
local reverseTable = functions.reverseTable
local createAndInsertTable = functions.createAndInsertTable
--Init
local sqrt = math.sqrt
local s = {}
function s.load ()
  love.keyboard.setKeyRepeat(true)
  space.viewingPlanet = global.currentPlanet
  space.viewingTime = timer
  space.offset = vector()
  space.zoom = 1
  
  updateSpaceMenu()
end
function updateSpaceMenu()
  space.dateString = get_date_from_unix(space.viewingTime)
end
function s.unload()

end
function s.draw()
  local renderStack = {}
  drawToCanvas(renderStack,9)
  slab.Draw()
  local height,width = love.graphics.getDimensions()
  resolution = vector(height,width)
  local planet = space.viewingPlanet
  space.centralCircle = {
    middleHeight = height/2,
    middleWidth = width/2,
    radius =  (height*width)/5000
  }
  planetPositions = {}
  local bodyCount = 0
  for i,v in pairs(space.bodies) do
    bodyCount = bodyCount + 1
  end
  local parentalBodies = {}
  for i,v in pairs(space.bodies) do
    local planetVariant = global.planetTypes[v.type].variants[v.variant]
    local planetType = global.planetTypes[v.type]
    if i == planet then
      love.graphics.setColor(0.2,1,0.2)
    else
      love.graphics.setColor(0.2,0.2,0.2)
    end
    --cycle 1 - draw all planets without parents
    if v.parentBody == nil then
      -- draw orbit line
      drawToCanvas(renderStack,5)
      love.graphics.circle("line",(space.centralCircle.middleHeight+space.offset.x)*space.zoom,(space.centralCircle.middleWidth+space.offset.y)*space.zoom,(v.orbitRadius*space.centralCircle.radius/100)*space.zoom)
      -- find position on the orbit line
      local point = pointOnACircle(v.orbitRadius*space.centralCircle.radius/100,space.centralCircle.middleHeight,space.centralCircle.middleWidth,0.0001*space.viewingTime*v.orbitSpeed+planetType.orbitAhead)
      
      planetPositions[v.type] = point
      love.graphics.setColor(planetVariant.color)
      --draw planet
      drawToCanvas(renderStack,3)
      love.graphics.circle("fill",(point.x+space.offset.x)*space.zoom,(point.y+space.offset.y)*space.zoom,v.radius*space.zoom)
      --decrement parentless bodies
      bodyCount = bodyCount - 1
    else
      table.insert(parentalBodies,v.type)
    end
    
    love.graphics.setColor(1,1,1)
    end
    --cycle 2 - draw all parental bodies
    local count = 0
    while count <= bodyCount do
      for i,planet in pairs(parentalBodies) do
        local planetType = space.bodies[planet]
        local parentPlanet = space.bodies[planetType.parentBody]
        if planetPositions[planet] then
          count = count + 1
        elseif planetPositions[parentPlanet.type] then
          local parentPosition = planetPositions[parentPlanet.type]
          local point = pointOnACircle(planetType.orbitRadius,parentPosition.x,parentPosition.y,0.0001*space.viewingTime*planetType.orbitSpeed+planetType.orbitAhead)
          planetPositions[planet] = point
        end
      end
    end
    for planetName,planetPosition in pairs(planetPositions) do
      local planetType = space.bodies[planetName]
      local planetVariant = global.planetTypes[planetType.type].variants[planetType.variant]
      local parentPosition = planetPositions[planetType.parentBody]
      if planetType.parentBody then
        drawToCanvas(renderStack,5)
        love.graphics.circle("line",(parentPosition.x+space.offset.x)*space.zoom,(parentPosition.y+space.offset.y)*space.zoom,planetType.orbitRadius*space.zoom)
        drawToCanvas(renderStack,3)
        love.graphics.setColor(planetVariant.color)
        love.graphics.circle("fill",(planetPosition.x+space.offset.x)*space.zoom,(planetPosition.y+space.offset.y)*space.zoom,planetType.radius*space.zoom)
        love.graphics.setColor({1,1,1})
      end
    end
    love.graphics.print(tostring(space.viewingUniverse),width/2,20) 
    love.graphics.print(space.dateString,width/2,40)
    love.graphics.setCanvas()
    reverseTable(renderStack)
    for _,renderLayer in pairs(renderStack) do
        love.graphics.draw(renderLayer)
        --without this new canvases will be created and clog up the memory
        renderLayer:release()
      end
    end
function s.keypressed(key)
    input:processInput(key)
end

function s.mousepressed(x,y,button,istouch,presses)
  if love.mouse.isDown(1) then
    local mx,my = love.mouse.getPosition()
    mx,my = (mx-space.offset.x*space.zoom)/space.zoom,(my-space.offset.y*space.zoom)/space.zoom 
    for i,v in pairs(space.bodies) do
      if sqrt(((planetPositions[v.type].x-mx)^2)+((planetPositions[v.type].y-my)^2)) < v.radius then
        space.viewingPlanet = v.type
        break
      end
    end
  end
end
function s.mousereleased(x,y,button,istouch,presses)
end
function s.mousemoved(x,y,dx,dy,istouch)
  if love.mouse.isDown(2) then
    space.offset = space.offset + vector(dx,dy) / space.zoom
  end
end
function s.wheelmoved(x,y) 
  if space.zoom + y * 0.1 >= 0.1 then
    space.oldZoom = space.zoom
    local mx,my = love.mouse.getPosition()
    space.zoom = space.zoom + y * 0.1
    local width,height = love.graphics.getDimensions()
    local xRatio,yRatio = (((mx - (width / 2)) / width) + 0.5) * -1,(((my - (height / 2)) / height) + 0.5) * -1
    local xdifference,ydifference = (width / space.oldZoom) - (width / space.zoom),(height / space.oldZoom) - (height / space.zoom)
    space.offset.x,space.offset.y = space.offset.x + xdifference * xRatio,space.offset.y + ydifference * yRatio
    
  end
end
function s.keyreleased(key)

end
function s.update(dt)
  slab.Update(dt)
  local w,h = love.graphics.getDimensions()
  for menuName,enabled in pairs(menusEnabled) do
    if enabled then
      menusFunc[menuName]()
    end
  end
  if not paused then
    space.viewingTime = space.viewingTime + 1 * space.timeMult
    updateSpaceMenu()
  end
end
--[[function s.quit()
    print "exiting..."
end]]

return s 
