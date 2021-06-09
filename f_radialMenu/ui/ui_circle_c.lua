local screen = {x,y,z=0}
screen.x, screen.y = guiGetScreenSize()


	ui_circle = {}
		function ui_circle:create(x, y, radius, width, r, g, b, image, text)
			local public = {}
				public.pos = {x = x, y = y, z = 0}
				public.radius = radius
				public.width = width
				public.color = {r = r, g = g, b = b}
				public.image = image or "brush"
				public.text = text or "example"
				
			local private = {}
				private.clicked = false
				private.hidden = false
				private.cursored = false
				private.shiftingStart = 0
				private.shiftingEnd = 0
				private.shiftingDuration = 250
				private.shiftingState = false
				private.shiftingStartValue = 0
				private.shiftingEndValue = 1
				private.shiftingValue = 0
				private.alpha = 255
				private.textAlpha = 0
				private.textAlphaStart = 0
				private.textAlphaEnd = 255
				private.textScale = 0
				private.textScaleStart = 0
				private.textScaleEnd = 1
				private.imageSize = public.radius
				private.element = false
			
					function private:setup()
						private.element = createElement("radialButton")
						addEventHandler("onClientRender", root, private.onRender)
					end
					
					function private.onRender()
						for i = 0, 360 do
							local dir = vec3.angleToDir({x = 0, y = 0, z = i})
							local pos = vec3.addVec(public.pos, vec3.scaleVec(dir, public.radius))
							
							dxDrawLine(public.pos.x, public.pos.y, pos.x, pos.y, tocolor(public.color.r, public.color.g, public.color.b, private.alpha), width, false)
						end
						local pos = {x,y}
						local border = {x,y}
						pos.x = public.pos.x - private.imageSize / 2
						pos.y = public.pos.y - private.imageSize / 2
						border.x = public.pos.x + private.imageSize / 2
						border.y = public.pos.y + private.imageSize / 2
						local imgage = ui_textures[public.image] or ui_textures["brush"]
						dxDrawImage(pos.x, pos.y + (public.radius * -0.1) * private.shiftingValue, private.imageSize, private.imageSize, imgage, 0, 0, 0, tocolor(255, 255, 255, private.alpha), false)
						dxDrawText(public.text, pos.x, pos.y + (public.radius * 0.5) * private.shiftingValue, border.x, border.y + (public.radius * 0.5) * private.shiftingValue, tocolor(0,0,0,private.textAlpha), private.textScale, "default-bold", "center", "center")
						
						if isCursorShowing() and not private.hidden then
							local mouse = {x,y,z=0}
							mouse.x, mouse.y = getCursorPosition()
							mouse = vec3.mulVec(screen, mouse)
							local dist = vec3.getDistance(mouse, public.pos)
							if dist <= public.radius and not private.cursored and not private.shiftingState then
								private.cursored = true
								private:shiftIn()
							end
							if dist > public.radius and private.cursored and not private.shiftingState then
								private.cursored = false
								private:shiftOut()
							end
							if dist <= public.radius and getKeyState("mouse1") and not private.clicked then
								private.clicked = true
								triggerEvent("onClientGUIClick", private.element)
							end
							if not getKeyState("mouse1") and private.clicked then
								private.clicked = false
							end
						end
					end
					
					function private.shifting()
						if private.hidden then
							removeEventHandler("onClientRender", root, private.shifting)
							private.shiftingState = false
							private.textAlpha = 0
							return false
						end
						local progress = (private.shiftingDuration  - (private.shiftingEnd - getTickCount())) / private.shiftingDuration
						private.shiftingValue = interpolateBetween(private.shiftingStartValue, 0, 0, private.shiftingEndValue, 0, 0, progress, "InOutQuad")
						private.textAlpha = interpolateBetween(private.textAlphaStart, 0, 0, private.textAlphaEnd, 0, 0, progress, "InOutQuad")
						private.textScale = interpolateBetween(private.textScaleStart, 0, 0, private.textScaleEnd, 0, 0, progress, "InOutQuad")
						if progress >= 1 then
							removeEventHandler("onClientRender", root, private.shifting)
							private.shiftingState = false
						end
					end
					
					function private:shiftIn()
						if private.shiftingState then return false end
						private.shiftingState = true
						private.shiftingStartValue = 0
						private.shiftingEndValue = 1
						private.textAlphaStart = 0
						private.textAlphaEnd = 255
						private.textScaleStart = 0
						private.textScaleEnd = 1
						private.shiftingStart = getTickCount()
						private.shiftingEnd = private.shiftingStart + private.shiftingDuration
						addEventHandler("onClientRender", root, private.shifting)
					end
					
					function private:shiftOut()
						if private.shiftingState then return false end
						private.shiftingState = true
						private.shiftingStartValue = 1
						private.shiftingEndValue = 0
						private.textAlphaStart = 255
						private.textAlphaEnd = 0
						private.textScaleStart = 1
						private.textScaleEnd = 0
						private.shiftingStart = getTickCount()
						private.shiftingEnd = private.shiftingStart + private.shiftingDuration
						addEventHandler("onClientRender", root, private.shifting)
					end
					
					function public:hide()
						private.alpha = 0
						private.textAlpha = 0
						removeEventHandler("onClientRender", root, private.onRender)
					end
					
					function public:unhide()
						private.alpha = 255
						addEventHandler("onClientRender", root, private.onRender)
					end
					
					function public:getElement()
						return private.element
					end
					
					function public:destroy()
						if isElement(private.element) then destroyElement(private.element) end
						removeEventHandler("onClientRender", root, private.onRender)
						for k, v in pairs(private) do private[k] = nil end
						for k, v in pairs(public) do public[k] = nil end
						private = nil
						public = nil
					end
					
			private:setup()
			setmetatable(public, self)
			self.__index = self
			return public
		end