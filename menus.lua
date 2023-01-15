
function manager(x,y,w,h)
	slab.BeginWindow('MyFirstWindow', {Title = "My First Window",X=x,Y=y,W=w,H=h})
	slab.Text("Hello World")
	slab.EndWindow()
end