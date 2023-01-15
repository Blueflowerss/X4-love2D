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
  [","]="timeback",["."]="timeforward"
}}
interactionList = {door=0,sign=0,warp=0}
space.viewingUniverse = 2200
space.viewingPlanet = 1
space.viewingTime = 1
space.offset = vector(0,0)
space.zoom = 0
space.centralCircle = {}
space.dateString = ""
space.bodies = {}
afterPress = vector(0,0)
function global.initializeGame()
  local playerData = love.filesystem.read("playerData.json")
  timer = 0
  planetGeneration.generatePlanetTypes()
  planetGeneration.generateBiomes()
end