local screen = {x,y}
screen.x, screen.y = guiGetScreenSize()

bindKey("e", "down",
	function()
		radialMenu:open()
	end
);

bindKey("e", "up",
	function()
		radialMenu:close()
	end
);

	radialMenu = {}
		radialMenu.radius = screen.x * 0.075
		radialMenu.dotCircleInRadius = screen.x * 0.04
		radialMenu.dotCircleOutRadius = radialMenu.dotCircleInRadius + radialMenu.dotCircleInRadius * 0.025
		radialMenu.dotCircleWidth = screen.x * 0.005
		radialMenu.circleRadius = radialMenu.dotCircleInRadius * 0.9
		radialMenu.objects = {}
		
			function radialMenu:setup()
				-- for i = 180, 540, 72 do
					-- local dir = vec3.angleToDir({x = 0, y = 0, z = i - 15})
					-- dir = vec3.scaleVec(dir, self.radius)
					-- local pos = vec3.addVec({x = screen.x/2, y = screen.y/2, z = 0}, dir)
					-- radialMenu.objects[#radialMenu.objects + 1] = {
						-- circle = ui_circle:create(pos.x, pos.y, radialMenu.circleRadius, radialMenu.dotCircleWidth, 255, 255, 255),
						-- dotCircle = ui_dottedCircle:create(pos.x, pos.y, radialMenu.dotCircleInRadius, radialMenu.dotCircleOutRadius, radialMenu.dotCircleWidth, 255, 255, 255)
					-- }
				-- end
				-- radialMenu:close()
				
				local i = 165
				local step = 72
				
				local dir = vec3.angleToDir({x = 0, y = 0, z = i}) 
				dir = vec3.scaleVec(dir, self.radius)
				local pos = vec3.addVec({x = screen.x/2, y = screen.y/2, z = 0}, dir)
				
					radialMenu.objects["measure"] = {
						circle = ui_circle:create(pos.x, pos.y, radialMenu.circleRadius, radialMenu.dotCircleWidth, 255, 255, 255, "pen", "Measure"),
						dotCircle = ui_dottedCircle:create(pos.x, pos.y, radialMenu.dotCircleInRadius, radialMenu.dotCircleOutRadius, radialMenu.dotCircleWidth, 255, 255, 255)
					}
					
					addEventHandler("onClientGUIClick", radialMenu.objects.measure.circle:getElement(),
						function()
							outputChatBox("You click " .. radialMenu.objects.measure.circle.text)
						end
					);
					
					i = i - step
					
				dir = vec3.angleToDir({x = 0, y = 0, z = i}) 
				dir = vec3.scaleVec(dir, self.radius)
				pos = vec3.addVec({x = screen.x/2, y = screen.y/2, z = 0}, dir)
				
					radialMenu.objects["tools"] = {
						circle = ui_circle:create(pos.x, pos.y, radialMenu.circleRadius, radialMenu.dotCircleWidth, 255, 255, 255, "tools", "Tools"),
						dotCircle = ui_dottedCircle:create(pos.x, pos.y, radialMenu.dotCircleInRadius, radialMenu.dotCircleOutRadius, radialMenu.dotCircleWidth, 255, 255, 255)
					}
					
					addEventHandler("onClientGUIClick", radialMenu.objects.tools.circle:getElement(),
						function()
							outputChatBox("You click " .. radialMenu.objects.tools.circle.text)
						end
					);
					
					i = i - step
					
				dir = vec3.angleToDir({x = 0, y = 0, z = i}) 
				dir = vec3.scaleVec(dir, self.radius)
				pos = vec3.addVec({x = screen.x/2, y = screen.y/2, z = 0}, dir)
				
					radialMenu.objects["scissors"] = {
						circle = ui_circle:create(pos.x, pos.y, radialMenu.circleRadius, radialMenu.dotCircleWidth, 255, 255, 255, "scissors", "Scissors"),
						dotCircle = ui_dottedCircle:create(pos.x, pos.y, radialMenu.dotCircleInRadius, radialMenu.dotCircleOutRadius, radialMenu.dotCircleWidth, 255, 255, 255)
					}
					
					addEventHandler("onClientGUIClick", radialMenu.objects.scissors.circle:getElement(),
						function()
							outputChatBox("You click " .. radialMenu.objects.scissors.circle.text)
						end
					);
					
					i = i - step
					
				dir = vec3.angleToDir({x = 0, y = 0, z = i}) 
				dir = vec3.scaleVec(dir, self.radius)
				pos = vec3.addVec({x = screen.x/2, y = screen.y/2, z = 0}, dir)
				
					radialMenu.objects["brush"] = {
						circle = ui_circle:create(pos.x, pos.y, radialMenu.circleRadius, radialMenu.dotCircleWidth, 255, 255, 255, "brush", "Brush"),
						dotCircle = ui_dottedCircle:create(pos.x, pos.y, radialMenu.dotCircleInRadius, radialMenu.dotCircleOutRadius, radialMenu.dotCircleWidth, 255, 255, 255)
					}
					
					addEventHandler("onClientGUIClick", radialMenu.objects.brush.circle:getElement(),
						function()
							outputChatBox("You click " .. radialMenu.objects.brush.circle.text)
						end
					);
					
					i = i - step
					
				dir = vec3.angleToDir({x = 0, y = 0, z = i}) 
				dir = vec3.scaleVec(dir, self.radius)
				pos = vec3.addVec({x = screen.x/2, y = screen.y/2, z = 0}, dir)
				
					radialMenu.objects["alonepen"] = {
						circle = ui_circle:create(pos.x, pos.y, radialMenu.circleRadius, radialMenu.dotCircleWidth, 255, 255, 255, "alonepen", "Pen"),
						dotCircle = ui_dottedCircle:create(pos.x, pos.y, radialMenu.dotCircleInRadius, radialMenu.dotCircleOutRadius, radialMenu.dotCircleWidth, 255, 255, 255)
					}
					
					addEventHandler("onClientGUIClick", radialMenu.objects.alonepen.circle:getElement(),
						function()
							outputChatBox("You click " .. radialMenu.objects.alonepen.circle.text)
						end
					);
					
					i = i - step
					
				radialMenu:close()
			end
		
			function radialMenu:open()
				showCursor(true)
				for k, v in pairs(radialMenu.objects) do
					radialMenu.objects[k].circle:unhide()
					radialMenu.objects[k].dotCircle:unhide()
				end
			end
			
			function radialMenu:close()
				showCursor(false)
				for k, v in pairs(radialMenu.objects) do
					radialMenu.objects[k].circle:hide()
					radialMenu.objects[k].dotCircle:hide()
				end
			end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		radialMenu:setup()
	end
);
		