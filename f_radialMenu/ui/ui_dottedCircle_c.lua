local screen = {x,y,z=0}
screen.x, screen.y = guiGetScreenSize()


	ui_dottedCircle = {}
		function ui_dottedCircle:create(x, y, inRadius, outRadius, width, r, g, b)
			local public = {}
				public.pos = {x = x, y = y, z = 0}
				public.inRadius = inRadius
				public.outRadius = outRadius
				public.width = width
				public.color = {r = r, g = g, b = b}
				
			local private = {}
				private.hidden = false
				private.cursored = false
				private.fadingState = false
				private.fadingDuration = 250
				private.fadingStart = 0
				private.fadingEnd = 0
				private.fadingStartMul = 0.9
				private.fadingEndMul = 1
				private.radiusMul = 0
				private.alpha = 0
				private.alphaStart = 0
				private.alphaEnd = 255
			
					function private:setup()
						addEventHandler("onClientRender", root, private.onRender)
					end
					
					function private.onRender()
						for i = 0, 360, width do
							local dir = vec3.angleToDir({x = 0, y = 0, z = i})
							local pos = vec3.addVec(public.pos, vec3.scaleVec(dir, public.inRadius * private.radiusMul))
							local outPos = vec3.addVec(public.pos, vec3.scaleVec(dir, public.outRadius * private.radiusMul))
							
							dxDrawLine(pos.x, pos.y, outPos.x, outPos.y, tocolor(public.color.r, public.color.g, public.color.b, private.alpha), width, false)
						end
						if isCursorShowing() then
							local mouse = {x,y,z=0}
							mouse.x, mouse.y = getCursorPosition()
							mouse = vec3.mulVec(screen, mouse)
							local dist = vec3.getDistance(mouse, public.pos)
							if dist <= public.inRadius and not private.cursored and not private.fadingState then
								private.cursored = true
								public:fadeIn()
							end
							if dist > public.inRadius and private.cursored and not private.fadingState then
								private.cursored = false
								public:fadeOut()
							end
						end
					end
					
					function private.fading()
						if private.hidden then
							removeEventHandler("onClientRender", root, private.fading)
							private.fadingState = false
							private.alpha = 0
							return false
						end
						local progress = (private.fadingDuration  - (private.fadingEnd - getTickCount())) / private.fadingDuration
						private.radiusMul = interpolateBetween(private.fadingStartMul, 0, 0, private.fadingEndMul, 0, 0, progress, "InOutQuad")
						private.alpha = interpolateBetween(private.alphaStart, 0, 0, private.alphaEnd, 0, 0, progress, "InOutQuad")
						if progress >= 1 then
							removeEventHandler("onClientRender", root, private.fading)
							private.fadingState = false
						end
					end
					
					function public:fadeIn()
						if private.fadingState then return false end
						private.hidden = false
						private.fadingState = true
						private.fadingStart = getTickCount()
						private.fadingEnd = private.fadingStart + private.fadingDuration
						private.fadingStartMul = 0.8
						private.fadingEndMul = 1
						private.alphaStart = private.alpha
						private.alphaEnd = 255
						addEventHandler("onClientRender", root, private.fading)
					end
					
					function public:fadeOut()
						if private.fadingState then return false end
						private.hidden = false
						private.fadingState = true
						private.fadingStart = getTickCount()
						private.fadingEnd = private.fadingStart + private.fadingDuration
						private.fadingStartMul = 1
						private.fadingEndMul = 0.8
						private.alphaStart = private.alpha
						private.alphaEnd = 0
						addEventHandler("onClientRender", root, private.fading)
					end
					
					function public:hide()
						private.alpha = 0
						private.hidden = true
						removeEventHandler("onClientRender", root, private.onRender)
					end
					
					function public:unhide()
						private.alpha = 255
						private.radiusMul = 0
						private.hidden = false
						addEventHandler("onClientRender", root, private.onRender)
					end
					
					function public:destroy()
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