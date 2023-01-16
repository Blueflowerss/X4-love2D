
function manager(x,y,w,h)
	slab.BeginWindow('planetInfo', {Title = "Planet info",X=x,Y=y,W=w,H=h,DisableDocks={"Left","Right","Bottom"}})
	if space.viewingPlanet then
		local planet = space.bodies[space.viewingPlanet]
		slab.Text("Planet name: "..planet.type)
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
function menuBar()
	if slab.BeginMainMenuBar() then
		if slab.BeginMenu("menus") then
			
			if slab.MenuItem("Manager") then
				menusEnabled.manager = true
			end
			if slab.MenuItem("Resource Manager") then
				menusEnabled.resources = true
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
	slab.BeginWindow('resManager', {Title = "Manage "..space.viewingPlanet.." resources",X=x,Y=y,W=w,H=h,DisableDocks={"Left","Right","Bottom"}})
	slab.Text("Test")
	slab.EndWindow()
end