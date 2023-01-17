addEvent("side_f1 >> kendinioldur", true)
addEventHandler("side_f1 >> kendinioldur", root, function()
killPed(source, source)
end)

addEvent("side_f1 >> tamiret", true)
addEventHandler("side_f1 >> tamiret", root, function()
if isPedInVehicle(source) then 
local vehicle = getPedOccupiedVehicle(source)
if getElementData(source, "side_f1 >> aractamiretti") then 
local remaining, executesRemaining, timeInterval  = getTimerDetails(fixTimer)
if remaining then 
outputChatBox("Araç tamir etmene "..math.floor(remaining/1000) .." saniye kaldı.", source, 255, 0, 0, true)
end
return end
fixVehicle(vehicle)
setElementHealth(vehicle, 1000)
setElementData(source, "side_f1 >> aractamiretti", true)
fixTimer = setTimer(setElementData, 5000, 1, source, "side_f1 >> aractamiretti", false)
else
outputChatBox("Bir araçta olmalısınız.", source, 255, 0, 0, true)
end 
end)

vehs = {}
addEvent("side_f1 >> araccikar", true)
addEventHandler("side_f1 >> araccikar", root, function(vehId)
local x, y, z = getElementPosition(source)
local rx, ry, rz = getElementRotation(source)
if getElementData(source, "korumada") then return end
if getElementData(source, "side_f1 >> araccikardi") then 
local remaining, executesRemaining, timeInterval  = getTimerDetails(aracTimer)
if remaining then 
outputChatBox("Araç çıkarmana "..math.floor(remaining/1000) .." saniye kaldı.", source, 255, 0, 0, true)
end
return end
if vehs[source] then destroyElement(vehs[source]) end
vehs[source] = createVehicle(vehId, x, y + 3, z, rx, ry, rz)
setElementData(source, "side_f1 >> araccikardi", true)
aracTimer = setTimer(setElementData, 1000, 1, source, "side_f1 >> araccikardi", false)
end)

addEvent("side_f1 >> setskin", true)
addEventHandler("side_f1 >> setskin", root, function(skinid)
 local allSkins = getValidPedModels ( ) -- Get valid skin IDs
        local result = false -- Define result, it is currently false
        for key, skin in ipairs( allSkins ) do -- Check all skins
            if skin == tonumber( skinid ) then -- If skin equals specified one, it is valid
                result = skin -- So set it as result
                break --stop looping through a table after we found the skin
            end
        end
if result then 
setElementModel(source, result)
else
outputChatBox("Böyle bir skin idsi mevcut değil.", source, 255, 0, 0, true)
end
end)