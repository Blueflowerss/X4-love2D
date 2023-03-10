local sqrt = math.sqrt
shipObject = classObject:extend()
function shipObject:constructor(start,destination,objective,resources)
	self.position = planetPositions[start]
	self.moveSpeed = 1
	self.cargo = {}
	self.destination = destination
	self.action = "idle"
	self.resources = resources
	self.size = 1
	self.destroyed = false
end
function shipObject:process()
	print("noAction")
end
cargoShip = shipObject:extend()
function cargoShip:process()
	local destination = space.bodies[self.destination]
	local distanceToDestination = sqrt(((planetPositions[self.destination].x-self.position.x)^2)+((planetPositions[self.destination].y-self.position.y)^2))
	if distanceToDestination > destination.radius then
		local direction = (planetPositions[self.destination]-self.position):norm()
		self.position = self.position + direction * self.moveSpeed * space.timeMult
	else
		for i,v in pairs(self.resources) do
			destination.resources[i] = destination.resources[i] + v
		end
		self.destroyed = true
	end
end
shipTypes = {cargoShip=cargoShip}
planetObject = classObject:extend()
function planetObject:process()
		timerObject.update(deltatime*space.timeMult,self.cargoTimer)
end