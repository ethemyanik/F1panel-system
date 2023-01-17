local tick,x,y
sx,sy = guiGetScreenSize()
pw,ph = 330,210
py = (sy-ph)/2
px = 5

exports.dxlib:dxDestroyEditBox(1)

panel = false
bindKey("f1", "down", function()
if not panel then 
panel = true
tick = getTickCount()
addEventHandler("onClientRender", root, anaRender, false, "low-10")
showCursor(true)
guiSetInputEnabled(true)
else
panel = false
removeEventHandler("onClientRender", root, anaRender)
showCursor(false)
guiSetInputEnabled(false)
end
if arac then 
arac = false
removeEventHandler("onClientRender", root, aracRender)
showCursor(false)
removeEventHandler("onClientRender", root, anaRender)
panel = false
exports.dxlib:dxDestroyEditBox(1)
guiSetInputEnabled(false)
end
if skin then 
skin = false
removeEventHandler("onClientRender", root, skinRender)
showCursor(false)
removeEventHandler("onClientRender", root, anaRender)
panel = false
exports.dxlib:dxDestroyEditBox(1)
guiSetInputEnabled(false)
end
end)

function anaRender()
local tick2 = (getTickCount() - tick) / 500
x, y = interpolateBetween(px-300, py, 0, px, py, 0, tick2, "Linear")
dxDrawRoundedRectangle( x, y, pw, ph, 5, tocolor(5, 5, 5, 255), false)
dxDrawText("oyuncu arayüzü", x + 10, y + 2, px+pw, py+ph, tocolor(255, 255, 255, 235), 1.8, "default-bold")
dxDrawRoundedRectangle( x + 15, y + 40, 300, 40, 5, tocolor(12, 12, 12, 255), false)
dxDrawText("arac çıkart", x + 120, y + 45, px+pw, py+ph, tocolor(255, 255, 255, 235), 1.6, "default-bold")
dxDrawImage(x + 35, y + 46, 25, 25, "img/car.png")
dxDrawRoundedRectangle( x + 15, y + 95, 300, 40, 5, tocolor(12, 12, 12, 255), false)
dxDrawText("skinler", x + 135, y + 100, px+pw, py+ph, tocolor(255, 255, 255, 235), 1.6, "default-bold")
dxDrawImage(x + 35, y + 100, 25, 25, "img/tshirt.png")
dxDrawRoundedRectangle( x + 15, y + 150, 150, 40, 5, tocolor(12, 12, 12, 255), false)
dxDrawText("tamir", x + 100, y + 157, px+pw, py+ph, tocolor(255, 255, 255, 235), 1.6, "default-bold")
dxDrawImage(x + 35, y + 157, 25, 25, "img/repair.png")
dxDrawRoundedRectangle( x + 167, y + 150, 150, 40, 5, tocolor(12, 12, 12, 255), false)
dxDrawText("kendini öldur", x + 189, y + 157, px+pw, py+ph, tocolor(255, 255, 255, 235), 1.6, "default-bold")
dxDrawImage(x + 168, y + 157, 25, 25, "img/rip.png")
end

araclar = {
{"Sultan"},
{"Savanna"},
{"Turismo"},
{"Infernus"}
}
arac = false
function aracRender()
dxDrawRoundedRectangle( px, py, pw, ph+30, 5, tocolor(5, 5, 5, 255), false)
dxDrawText("araç arayüzü", px + 10, py + 2, px+pw, py+ph, tocolor(255, 255, 255, 235), 1.8, "default-bold")
y = 0
for i, v in ipairs(araclar) do 
y = y + 50
dxDrawRoundedRectangle( px + 15, py - 10 + y, 300, 40, 5, tocolor(12, 12, 12, 255), false)
dxDrawText(v[1], px + 40, py - 5 + y, px+pw, py+ph, tocolor(255, 255, 255, 235), 1.8, "default-bold")
if isMouseInPosition(px + 250, py - 10 + y, 75, 40) then 
r = 38
g = 38
b = 38
else
r = 18
g = 18
b = 18
end
dxDrawRoundedRectangle( px + 250, py - 10 + y, 75, 40, 5, tocolor(r, g, b, 255), false)
dxDrawText("Oluştur", px + 257, py - 1 + y, px+pw, py+ph, tocolor(255, 255, 255, 235), 1.4, "default-bold")
end
end


skin = false
function skinRender()
dxDrawRoundedRectangle( px, py, pw, ph, 5, tocolor(5, 5, 5, 255), false)
dxDrawText("skin arayüzü", px + 15, py + 10, px+pw, py+ph, tocolor(255, 255, 255, 235), 1.8, "default-bold")
dxDrawRoundedRectangle( px + 15, py + 100, 300, 40, 5, tocolor(12, 12, 12, 255), false)
dxDrawText("Set Skin", px + 125, py + 105, px+pw, py+ph, tocolor(255, 255, 255, 235), 1.8, "default-bold")
end

function onClick ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
         if panel then
			if button == "left" and state == "down" then
				--ana
				if isMouseInPosition(px + 167, py + 150, 150, 40) then 
					triggerServerEvent("side_f1 >> kendinioldur", localPlayer)
				elseif isMouseInPosition(px + 15, py + 150, 150, 40) then 
					triggerServerEvent("side_f1 >> tamiret", localPlayer)
				elseif isMouseInPosition(px + 15, py + 40, 300, 40) then 
				addEventHandler("onClientRender", root, aracRender, false, "low-10")
				arac = true
				panel = false
				elseif isMouseInPosition(px + 15, py + 95, 300, 40) then 
				addEventHandler("onClientRender", root, skinRender, false, "low-10")
				skin = true
				panel = false
				editbox = exports.dxlib:dxCreateEditBox("number", "", "Skin Id", px + 15, py + 50, 300, 35, _, _, false)
				end
				--ana
			end
		 end
		 
		 if arac then
		 if button == "left" and state == "down" then
				if isMouseInPosition(px + 250, py - 10 + 50, 75, 40) then 
				triggerServerEvent("side_f1 >> araccikar", localPlayer, 560)
				elseif isMouseInPosition(px + 250, py - 10 + 100, 50, 40) then 
				triggerServerEvent("side_f1 >> araccikar", localPlayer, 567)
				elseif isMouseInPosition(px + 250, py - 10 + 150, 50, 40) then 
				triggerServerEvent("side_f1 >> araccikar", localPlayer, 451)
				elseif isMouseInPosition(px + 250, py - 10 + 200, 50, 40) then 
				triggerServerEvent("side_f1 >> araccikar", localPlayer, 411)
				end
	     end
		 end
		 
		 if skin then 
		 if button == "left" and state == "down" then
			if isMouseInPosition(px + 15, py + 100, 300, 40) then 
			local skinId = exports.dxlib:dxGetText(1)
			if tonumber(skinId) and skinId ~= "" then
				triggerServerEvent("side_f1 >> setskin", localPlayer, skinId)
			end
			end
		 end
		 end
end
addEventHandler ( "onClientClick", root, onClick )

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

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

bindKey("m", "down", function()
showCursor(not isCursorShowing())
end)

local game_time	= ""	-- Game Date and Time
local date_ = ""		-- Client Date and Time
local uptime = getRealTime().timestamp

function getMonthName(month, digits)
	if month < 10 then month = "0"..month end 
	return month
end


local FPScount = 0
local ping2 = 0
local fps2 = 0
function updatePingAndFPS()
	ping2 = getPlayerPing(localPlayer).."ms"
	fps2 = FPScount.."FPS"
	FPScount = 0
end
setTimer(updatePingAndFPS, 1000, 0)

local sX,sY = guiGetScreenSize()
local SERVER_NAME = "%s | %s | %s | %s | Aktif Oyuncu: %s"
--SERVER_NAME = SERVER_NAME:format(fps,ping,date_,#getElementsByType("player"),getElementData(root, "max_players"))
-- GTI Version
--------------->>

function renderGTIVersion()
	FPScount = FPScount + 1
	local dX,dY,dW,dH = 0,sY,sX-85,sY
	local SERVER_NAME = SERVER_NAME:format(
		getPlayerName(localPlayer):gsub("#%x%x%x%x%x%x",""),
		fps2,
		ping2,
		date_,
		#getElementsByType("player")
	)
	dxDrawText(SERVER_NAME, dX,dY,dW,dH, tocolor(255,255,255,100), 1, "default-bold", "right", "bottom")
end
addEventHandler("onClientRender", root, renderGTIVersion)
if badgeNumber then
	if string.len(badgeNumber) > 25 then
		outputChatBox("HATA : Bu kadar uzun olamaz.", thePlayer, 255, 255, 255)
		return
	end
end