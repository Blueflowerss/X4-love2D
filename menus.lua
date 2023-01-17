
function manager(x,y,w,h)
	slab.BeginWindow('bodyInfo', {Title = "Planet info",X=x,Y=y,W=w,H=h,DisableDocks={"Left","Right","Bottom"},NoSavedSettings=true})
	if space.viewingPlanet then
		local planet = space.bodies[space.viewingPlanet]
		slab.Text("Planet name: "..planet.type)

		slab.Text("Planet Radius: "..planet.radius)
		slab.Text("Cargo Destination: "..planet.cargoDestination)
		--print(inspect(space.bodies[space.viewingPlanet]))
		slab.Text("Minerals: "..planet.resources.minerals)
		slab.Text("Organics: "..planet.resources.organics)
		slab.Text("Radioactive: "..planet.resources.radioactive)
		if slab.BeginMenu("cargo options") then
			if slab.CheckBox(planet.autoSend, "Toggle auto cargo") then
				if planet.cargoDestination ~= "" then
					planet.autoSend = not planet.autoSend
					if planet.autoSend then
						--moveResourcesToCargoShip(planet.type,planet.cargoDestination,planet.resources,{minerals=planet.autoMineralAmount,organics=planet.autoOrganicAmount,radioactive=planet.autoRadioactiveAmount})
						timerObject.every(5,function() 
							moveResourcesToCargoShip(planet.type,planet.cargoDestination,planet.resources,{minerals=planet.autoMineralAmount,organics=planet.autoOrganicAmount,radioactive=planet.autoRadioactiveAmount})
						end
					):group(planet.cargoTimer)
					else
						timerObject.clear(planet.cargoTimer)
					end
				else
					eventObject.dispatch("event","must select a destination planet first.")
				end
			end
			slab.Text("Minerals")
			slab.SameLine()
			if slab.Input('mineralsToSend', {W=30,NumbersOnly=true,Min=1,Max=math.huge,Step=50,Text=tostring(planet.autoMineralAmount) }) then
				planet.autoMineralAmount = slab.GetInputNumber()
			end
			slab.Text("Organics")
			slab.SameLine()
			if slab.Input('organicsToSend', {W=30,NumbersOnly=true,Min=1,Max=math.huge,Step=50,Text=tostring(planet.autoOrganicAmount) }) then
				planet.autoOrganicAmount = slab.GetInputNumber()
			end
			slab.Text("Radioactive")
			slab.SameLine()
			if slab.Input('radioactiveToSend', {W=30,NumbersOnly=true,Min=1,Max=math.huge,Step=50,Text=tostring(planet.autoRadioactiveAmount) }) then
				planet.autoRadioactiveAmount = slab.GetInputNumber()
			end
			slab.BeginListBox('planetCargoDestination')
			for i,v in pairs(space.bodies) do
				if v.type ~= planet.type then
					slab.BeginListBoxItem('cargoPlanet_' .. v.type)
					if slab.IsListBoxItemClicked() then
						planet.cargoDestination = v.type
					end
					slab.Text(v.type)
					slab.EndListBoxItem()
				end
			end
			slab.EndListBox()
			slab.EndMenu()
		end
		if slab.Button("close") then
			menusEnabled.manager = false
		end
	else
		slab.Text("No planet selected")
	end
	slab.EndWindow()
end
function eventMenu(x,y,w,h)
	slab.BeginWindow('eventMenu', {Title = "Events",X=x,Y=y,W=w,H=h,DisableDocks={"Left","Right","Bottom"},NoSavedSettings=true})
	slab.BeginListBox('planets',{H=50})
	for i,v in pairs(events) do
		slab.BeginListBoxItem('event_' .. i)
		slab.Text(v)
		slab.EndListBoxItem()
	end
	slab.EndListBox()
	if slab.Button("close") then
		menusEnabled.events = not menusEnabled.events
	end
	slab.EndWindow()
end
function menuBar()
	if slab.BeginMainMenuBar() then
		if slab.BeginMenu("menus") then
			if slab.MenuItem("Manager") then
				menusEnabled.manager = not menusEnabled.manager
			end
			if slab.MenuItem("Resource Manager") then
				menusEnabled.resources = not menusEnabled.resources
			end
			if slab.MenuItem("Events") then
				menusEnabled.events = not menusEnabled.events
			end
			slab.Separator()
			if slab.MenuItem("Quit") then
				love.event.quit()
			end
			slab.EndMenu()
		end
		slab.EndMainMenuBar()
	end
end 
function resourceManager(x,y,w,h)
slab.BeginWindow('resManager', {Title = "Manage "..space.viewingPlanet.." resources",X=x,Y=y,W=w,H=h,NoSavedSettings=true})
slab.BeginListBox('planets')
	for i,v in pairs(space.bodies) do
		slab.BeginListBoxItem('planets_' .. i, {selectedPlanet = menus.selectedPlanet == i})
		slab.Text(i)
		if slab.IsListBoxItemClicked() then
			menus.selectedPlanet = i
		end
		slab.EndListBoxItem()
	end
slab.EndListBox()
if slab.Button("close") then
	menusEnabled.resources = false
end
slab.Text("Minerals")
slab.SameLine()
if slab.Input('transferMinerals',{Min=0,Max=99999,Text=menus.mineralAmount}) then
	menus.mineralAmount = slab.GetInputNumber()
end
slab.Text("Organics")
slab.SameLine()
if slab.Input('transferOrganics',{Min=0,Max=99999,Text=menus.organicAmount}) then
	menus.organicAmount = slab.GetInputNumber()
end
slab.Text("Radioactive")
slab.SameLine()
if slab.Input('transferRadioactive',{Min=0,Max=99999,Text=menus.radioactiveAmount}) then
	menus.radioactiveAmount = slab.GetInputNumber()
end
slab.SameLine()
if slab.Button('send resources') then
	local sourcePlanet = space.bodies[space.viewingPlanet]

		if space.viewingPlanet ~= menus.selectedPlanet then
			moveResourcesToCargoShip(space.viewingPlanet,menus.selectedPlanet,sourcePlanet.resources,{minerals=menus.mineralAmount,organics=menus.organicAmount,radioactive=menus.radioactiveAmount})
		else
			eventObject.dispatch("event","Starting point can't be the destination.")
		end

end


slab.Text(space.viewingPlanet.." -> "..menus.selectedPlanet)
slab.EndWindow()
end