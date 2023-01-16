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
menusEnabled = {}
menusEnabled.manager = false
menusEnabled.topBar = true
menusEnabled.resources = false
menusFunc = {}
menusFunc.manager = manager
menusFunc.topBar = menuBar
menusFunc.resources = resourceManager
function global.initializeGame()
  local playerData = love.filesystem.read("playerData.json")
  timer = 0
  planetGeneration.generatePlanetTypes()
  planetGeneration.generateBiomes()
  space.bodies = functions.generatePlanets(space.viewingUniverse)
end