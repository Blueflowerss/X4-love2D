
function manager(x,y,w,h)
	slab.BeginWindow('bodyInfo', {Title = "Planet info",X=x,Y=y,W=w,H=h,DisableDocks={"Left","Right","Bottom"},NoSavedSettings=true})
	if space.viewingPlanet then
		local planet = space.bodies[space.viewingPlanet]
		slab.Text("Planet name: "..planet.type)
		slab.SameLine()
		if slab.Button("close") then
			menusEnabled.manager = false
		end
		slab.Text("Planet Radius: "..planet.radius)
		--print(inspect(space.bodies[space.viewingPlanet]))
		slab.Text("Minerals: "..planet.resources.minerals)
		slab.Text("Organics: "..planet.resources.organics)
		slab.Text("Radioactive: "..planet.resources.radioactive)
		if slab.Button("manage resources") then
			menusEnabled.resources = true
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
		menusEnabled.events = false
	end
	slab.EndWindow()
end
function menuBar()
	if slab.BeginMainMenuBar() then
		if slab.BeginMenu("menus") then
			if slab.MenuItem("Manager") then
				menusEnabled.manager = true
			end
			if slab.MenuItem("Resource Manager") then
				menusEnabled.resources = true
			end
			if slab.MenuItem("Events") then
				menusEnabled.events = true
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
	if (sourcePlanet.resources.minerals-menus.mineralAmount>0) and
	(sourcePlanet.resources.organics-menus.organicAmount>0) and
	(sourcePlanet.resources.radioactive-menus.radioactiveAmount>0) then
		sourcePlanet.resources.minerals= sourcePlanet.resources.minerals - menus.mineralAmount
		sourcePlanet.resources.organics= sourcePlanet.resources.organics - menus.organicAmount
		sourcePlanet.resources.radioactive= sourcePlanet.resources.radioactive - menus.radioactiveAmount
		eventObject.dispatch("ship",space.viewingPlanet,menus.selectedPlanet,"cargoShip",{menus.mineralAmount,menus.organicAmount,menus.radioactiveAmount})
	end
end


slab.Text(space.viewingPlanet.." -> "..menus.selectedPlanet)
slab.EndWindow()
end