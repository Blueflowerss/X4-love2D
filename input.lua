input = {}
function interaction(name,object,actor)
  function warp()
    global.switchPlanet(global.currentPlanet,object.warpTo,actor)
  end
  local interactions = {warp=warp}
  if interactions[name] then
    interactions[name]()
  end
end

function input:processInput(key)
  local keys = global.keyBindings[global.gameScene]
  
  -- controls for normal game 
  function GAMESCENE()
    local modes = {
      INTERACT = 2
    }
    inputCurrentMode = inputCurrentMode or modes.MOVE
    inputDirection = inputDirection or vector(0,0,0)
    function processInput()
    end
  function moveleft()
    inputDirection = vector(-1,0,0)
    processInput()
  end
  function moveleftup()
    inputDirection = vector(-1,-1,0)
    processInput()
  end
  function moveleftdown()
    inputDirection = vector(-1,1,0)
    processInput()
  end
  function moveright()
    inputDirection = vector(1,0,0)
    processInput()
  end
  function moverightup()
    inputDirection = vector(1,-1,0)
    processInput()
  end
  function moverightdown()
    inputDirection = vector(1,1,0)
    processInput()
  end
  function moveup()
    inputDirection = vector(0,-1,0)
    processInput()
  end
  function movedown()
    inputDirection = vector(0,1,0)
    processInput()
  end
  function climbup()
    inputDirection = vector(0,0,1)
    processInput()
  end
  function climbdown()
    inputDirection = vector(0,0,-1)
    processInput()
  end
  function stepforward()
    global.switchUniverse(global.currentUniverse,global.currentUniverse+1,global.multiverse[global.currentUniverse].bodies[global.currentPlanet].actors[global.currentActor])
  end
  function stepback()
    global.switchUniverse(global.currentUniverse,global.currentUniverse-1,global.multiverse[global.currentUniverse].bodies[global.currentPlanet].actors[global.currentActor])
  end
  function placeObject()
    inputCurrentMode = modes.BUILD
  end
  function destroyObject()
    inputCurrentMode = modes.DESTROY
  end
  function interact()
    inputCurrentMode = modes.INTERACT
  end
  function debug()
    for i,v in pairs(global.multiverse[global.currentUniverse].bodies[global.currentPlanet].objects) do
      print(i)  
    end
  end
  function buildSlotLeft()
    global.buildSlot = global.buildSlot + 1
    global.buildSlotName = classFactory.finishedObjectsIndexTable[(global.buildSlot%classFactory.databaseLength)+1]
  end
  function buildSlotRight()
    global.buildSlot = global.buildSlot - 1
    global.buildSlotName = classFactory.finishedObjectsIndexTable[(global.buildSlot%classFactory.databaseLength)+1]
  end
  function quit()
    
    love.event.quit()
  end
  function openSpaceMenu()
    global.gameScene = "SPACEMENU"
    Scene.Load(global.scenes["SPACEMENU"])
  end
  local controls = {["moveleft"]=moveleft,["moveright"]=moveright,["moveup"]=moveup,["movedown"]=movedown,
    ["stepforward"]=stepforward,["stepback"]=stepback,climbup=climbup,climbdown=climbdown,debug=debug,
    build=placeObject,moverightup=moverightup,moverightdown=moverightdown,moveleftup=moveleftup,moveleftdown=moveleftdown,buildSlotLeft=buildSlotLeft,buildSlotRight=buildSlotRight,destroy = destroyObject,
    ["escape"]=quit,interact=interact,
    ["spacemenu"]=openSpaceMenu}
  if keys[key] ~= nil then
    controls[keys[key]]()
  end
end
function SPACEMENU()
  function quitMenu()
    global.gameScene = "GAMESCENE"
    Scene.Load(global.scenes["GAMESCENE"])
  end
  function up()
    space.offset = space.offset + vector(0,10) * space.zoom
  end
  function down()
    space.offset = space.offset + vector(0,-10) * space.zoom
  end
  function left()
    
    space.offset = space.offset + vector(10,0)
  end
  function right()
    space.offset = space.offset + vector(-10,0)
  end
  function minus()
    space.zoom = space.zoom - 0.1
  end
  function plus()
    space.zoom = space.zoom + 0.1
  end
  function timeforward()
    print(space.timeMult)
    if space.timeMult * 2 < 8388608 then
      space.timeMult = space.timeMult * 2
    end
  end
  function timeback()
    if space.timeMult / 2 > 0.1 then
      space.timeMult = space.timeMult / 2
    end
  end
  function pause()
    if paused then
      paused = false
    else
      paused = true
    end
  end
  local controls = {left=left,right=right,up=up,down=down,minus=minus,plus=plus,
timeforward=timeforward,timeback=timeback,pause=pause}
if keys[key] ~= nil then
    controls[keys[key]]()
  end
end
local scenes = {
  ["GAMESCENE"] = GAMESCENE,
  ["SPACEMENU"] = SPACEMENU
}
  if scenes[global.gameScene] ~= nil then
    scenes[global.gameScene]()
  end
end