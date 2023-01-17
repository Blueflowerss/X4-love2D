global = {}
space = {}
global.font = love.graphics.newFont("LiberationSans-Italic.ttf",30)

global.currentPlanet = "earth"
global.multiverse = {}
global.planetTypes = {}
global.biomes = {}
global.biomeAmount = 0
global.biomesIndexed = {}
global.spriteDistancing = 128
global.spriteScaling = 0.5
global.gameScene = null
deltatime = 0
global.scenes = {
  GAMESCENE = "main",
  SPACEMENU = "spaceMenu"
}
global.camera = gamera.new(0,0,1000,1000)
global.playerData = {
  position=vector(0,0):__tostring(),
  world=global.currentUniverse,
  planet=global.currentPlanet
}
global.chunkFiles = {}
global.keyBindings = {["SPACEMENU"]={
  left="left",right="right",down="down",up="up",["kp+"]="plus",["kp-"]="minus",
  [","]="timeback",["."]="timeforward",space="pause"
}}
interactionList = {door=0,sign=0,warp=0}
space.viewingUniverse = 2200
space.viewingPlanet = 1
space.timeMult = 1
space.offset = vector(0,0)
space.planetFollowOffset = vector(0,0)
space.zoom = 0
space.centralCircle = {}
space.dateString = ""
space.bodies = {}
menus = {}
menus.mineralAmount = 0
menus.organicAmount = 0
menus.radioactiveAmount = 0
menus.selectedPlanet = "earth"
events = {}
ships = {}
menusEnabled = {}
menusEnabled.events = false
menusEnabled.manager = false
menusEnabled.topBar = true
menusEnabled.resources = false

menusFunc = {}
menusFunc.events = eventMenu
menusFunc.manager = manager
menusFunc.topBar = menuBar
menusFunc.resources = resourceManager
function global.initializeGame()
  local playerData = love.filesystem.read("playerData.json")
  timer = 0
  planetGeneration.generatePlanetTypes()
  planetGeneration.generateBiomes()
  eventObject.on("event",function(message) 
    if table.length(events) > 30 then
      table.remove(events,#events)
    end
    table.insert(events,message)
  end)
  eventObject.on("ship",function(start,destination,type,resources) 
      local ship = shipTypes[type](start,destination,type,resources)
      table.insert(ships,ship)
  end)
  space.bodies = functions.generatePlanets(space.viewingUniverse)
end