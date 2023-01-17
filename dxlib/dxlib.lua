local screenX, screenY = guiGetScreenSize()
local sX, sY = 1366, 768
local x, y = (screenX/sX), (screenY/sY)

local fontTable = {}
local editTable = {}

function dxCreateEditBox (name, text, placeholder, posX, posY, w, h, font, color, masked, maxLength)
    local fontSize = h/2.5
    if not font then font = "opensans-light" end
    if not (fontTable[fontSize]) then 
        fontTable[fontSize] = dxCreateFont("fonts/"..font..".ttf", fontSize*y)
    end
    table.insert(editTable, {
    	["name"] = name or "name"..#editTable+1,
    	["text"] = text or "",
    	["placeholder"] = placeholder or "",
    	["x"] = posX,
    	["y"] = posY,
    	["w"] = w,
    	["h"] = h,
    	["masked"] = masked or false,
    	["font"] = fontTable[fontSize],
    	["active"] = false,
    	["backspaceState"] = 100,
    	["backspaceTick"] = getTickCount(),
    	["cursorTick"] = 0,
    	["clickTick"] = 0,
    	["designAlpha"] = 0,
    	["activeColor"] = color or {255, 255, 255},
    	["maxLength"] = maxLength or false,
    })
    return #editTable
end

addEventHandler("onClientRender", root, 
	function()
		for k, v in pairs(editTable) do
			local textWidth = dxGetTextWidth(v["text"], 1, v["font"]) + 1*x
			local cursorSize = dxGetFontHeight(1, v["font"])*2.5
			if (v["masked"]) then
				textWidth = dxGetTextWidth(setTextMasked(v["text"]), 1, v["font"]) + 1*x
			end
            local cursorPosX = 0
            if (textWidth < v["w"]) then 
            	cursorPosX = textWidth+6*x
            else
            	cursorPosX = v["w"]-6*x
            end

			dxDrawRoundedRectangle(v["x"], v["y"], v["w"], v["h"], 5, tocolor(0, 0, 0, 200), true)

			dxDrawRoundedRectangle(v["x"], v["y"], v["w"], v["h"], 5, tocolor(0, 0, 0, v["designAlpha"]), true)

			if (v["active"]) then
				v["designAlpha"] = interpolateBetween(0, 0, 0, 75, 0, 0, (getTickCount() - v["clickTick"]) / 200, "Linear")

				local cursorAlpha = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount() - v["cursorTick"]) / 1000, "SineCurve")

				dxDrawRectangle(v["x"]+cursorPosX, v["y"]+v["h"]/2-(v["h"]-12*y)/2, 1*y, v["h"]-12*y, tocolor(200, 200, 200, cursorAlpha), true)

				if (getKeyState("backspace")) then
               		v["backspaceState"] = v["backspaceState"] - 1
            	else
                	v["backspaceState"] = 125
            	end
            	if getKeyState("backspace") and (getTickCount() - v["backspaceTick"]) > v["backspaceState"] then
               		v["text"] = string.sub(v["text"], 1, #v["text"] - 1)
                	v["backspaceTick"] = getTickCount()
            	end
			else
				v["designAlpha"] = interpolateBetween(v["designAlpha"], 0, 0, 0, 0, 0, (getTickCount() - v["clickTick"]) / 200, "Linear")
			end

			if (string.len(v["text"]) == 0) and not v["active"] then
				dxDrawText(v["placeholder"], v["x"]+5*x, v["y"], v["x"]-10+v["w"], v["y"]+v["h"], tocolor(255, 255, 255, 200), 1, v["font"], "left", "center", false, false, true)
			else
				if (textWidth < v["w"]) then 
					if (v["masked"]) then
						dxDrawText(setTextMasked(v["text"]), v["x"]+5*x, v["y"], v["x"]-10+v["w"], v["y"]+v["h"], tocolor(255, 255, 255, 255), 1, v["font"], "left", "center", false, false, true)
					else
						dxDrawText(v["text"], v["x"]+5*x, v["y"], v["x"]-10+v["w"], v["y"]+v["h"], tocolor(255, 255, 255, 255), 1, v["font"], "left", "center", false, false, true)
					end
				else
					if (v["masked"]) then
						dxDrawText(setTextMasked(v["text"]), v["x"]+5*x, v["y"], v["x"]-10+v["w"], v["y"]+v["h"], tocolor(255, 255, 255, 255), 1, v["font"], "right", "center", true, false, true)
					else
						dxDrawText(v["text"], v["x"]+5*x, v["y"], v["x"]-10+v["w"], v["y"]+v["h"], tocolor(255, 255, 255, 255), 1, v["font"], "right", "center", true, false, true)
					end
				end
			end
		end
	end
)

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

addEventHandler ("onClientClick", root,
	function(button, state, absoluteX, absoluteY)
		if (button == "left" and state == "down") then
			for k, v in pairs(editTable) do
				if (isMouseInPosition (v["x"], v["y"], v["w"], v["h"])) then
					if not (v["active"]) then
						dxSetText(1, "")
						v["active"] = true
						v["clickTick"] = getTickCount()
					end
				else
					v["active"] = false
					v["clickTick"] = getTickCount()
				end
			end
		end
	end
)

addEventHandler("onClientKey", root, 
	function(button, state) 
		if (isCursorShowing()) then
			if (state) then
				if (button == "tab") then
					local activeEditBoxID = dxGetActiveEditBox ()

					if (activeEditBoxID) then
						if (activeEditBoxID < #editTable) then
							dxSetActiveEditBox (activeEditBoxID+1)
						else
							dxSetActiveEditBox (1)
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientCharacter", root, 
	function(character)
		if (isCursorShowing()) then
			for k, v in pairs(editTable) do
				if (v["active"]) then
				guiSetInputEnabled(true)
					if (getValidKey(character)) then
						if (v["maxLength"]) then
							if (v["maxLength"] == string.len(v["text"])) then
								return
							end
						end
						v["text"] = v["text"] .. character
						v["cursorTick"] = getTickCount()
					end
				end
			end
		end
	end
)

function setTextMasked (password)
    local length = utfLen(password)
    return string.rep("*", length)
end

function getValidKey (key)
	local validKeys = {["0"] = true, ["1"] = true, ["2"] = true, ["3"] = true, ["4"] = true, ["5"] = true, ["6"] = true, ["7"] = true, ["8"] = true, ["9"] = true, ["q"] = true, ["w"] = true, ["e"] = true, ["r"] = true, ["t"] = true, ["z"] = true, ["u"] = true, ["i"] = true, ["o"] = true, ["p"] = true, ["ő"] = true, ["ú"] = true, ["ö"] = true, ["ü"] = true, ["ó"] = true, ["a"] = true, ["s"] = true, ["d"] = true, ["f"] = true, ["g"] = true, ["h"] = true, ["j"] = true, ["k"] = true, ["l"] = true, ["é"] = true, ["á"] = true, ["ű"] = true, ["í"] = true, ["y"] = true, ["x"] = true, ["c"] = true, ["v"] = true, ["b"] = true, ["n"] = true, ["m"] = true, [","] = true, ["."] = true, ["-"] = true, 
	["!"] = true, ["?"] = true, ["#"] = true, ["&"] = true, ["@"] = true, ["$"] = true, ["'"] = true, ["\""] = true, ["%"] = true, ["+"] = true, ["="] = true, ["("] = true, [")"] = true, [" "] = true}

	if (validKeys[string.lower(key)]) then
		return true
	else
		return false
	end
end

-- Usefully functions
function isMouseInPosition (x, y, width, height)
	if (not isCursorShowing()) then
		return false
	end
	local cx, cy = getCursorPosition ()
	local cx, cy = (cx * screenX), (cy * screenY)
	
	return ((cx >= x and cx <= x + width) and (cy >= y and cy <= y + height))
end

function dxDrawLinedRectangle(x, y, width, height, color, _width, postGUI)
	_width = _width or 1
	dxDrawLine ( x, y, x+width, y, color, _width, postGUI ) -- Top
	dxDrawLine ( x, y, x, y+height, color, _width, postGUI ) -- Left
	dxDrawLine ( x, y+height, x+width, y+height, color, _width, postGUI ) -- Bottom
	dxDrawLine ( x+width, y, x+width, y+height, color, _width, postGUI ) -- Right
end

-- Exported functions
function isValidEditBox(id)
	if (editTable[id]) then
		return id
	else
		return false
	end
end

function dxGetActiveEditBox ()
	local id
	for k, v in pairs(editTable) do
		if (v["active"]) then
			id = k
			break
		end
	end
	return id or false
end

function dxGetIDByName (name)
	local id
	for k, v in pairs(editTable) do
		if (v["name"] == name) then
			id = k
			break
		end
	end
	return id or false
end

function dxGetText (id)
	if not isValidEditBox(id) then return end
	return editTable[id]["text"]
end

function dxSetText (id, text)
	if not isValidEditBox(id) then return end
	editTable[id]["text"] = text
	return true
end

function dxSetActiveEditBox (id)
	if not isValidEditBox(id) then return end
	if not (editTable[id]["active"]) then
		local activeEditBoxID = dxGetActiveEditBox ()
		if activeEditBoxID then
			editTable[activeEditBoxID]["active"] = false
			editTable[activeEditBoxID]["clickTick"] = getTickCount()
		end

		editTable[id]["active"] = true
		editTable[id]["clickTick"] = getTickCount()
	end
	return true
end

function dxDestroyEditBox (id)
	if not isValidEditBox(id) then return end
	table.remove(editTable,id)
	return true
end

function dxSetEditBoxPosition (id, x, y)
	if not isValidEditBox(id) then return end
	editTable[id]["x"] = x
	editTable[id]["y"] = y
	return true
end