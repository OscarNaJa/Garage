local textcoords = nil
local isShowUI = false
local currentUIKey = nil
local interactions = {}

local function SHOWTEXT(isPress, text)
	local uiKey = (isPress or '') .. '|' .. (text or '')
	if isShowUI and currentUIKey == uiKey then
		return
	end

	isShowUI = true
	currentUIKey = uiKey

	SendNUIMessage({
		action = 'SHOW',
		text = text,
		isPress = isPress,
	})
end

local function HIDETEXT()
	if isShowUI then
		SendNUIMessage({
			action = 'HIDE'
		})
		isShowUI = false
		currentUIKey = nil
	end
end

local function normalizeCoords(coords)
	if not coords then
		return nil
	end

	if coords.x and coords.y and coords.z then
		return vector3(coords.x + 0.0, coords.y + 0.0, coords.z + 0.0)
	end

	if coords[1] and coords[2] and coords[3] then
		return vector3(coords[1] + 0.0, coords[2] + 0.0, coords[3] + 0.0)
	end

	return nil
end

local function showInteractionUI(data)
	if type(data) ~= 'table' then
		return false
	end

	local interactionId = tostring(data.id or ('auto_' .. tostring(GetGameTimer())))
	local coords = normalizeCoords(data.coords)
	if not coords then
		return false
	end

	interactions[interactionId] = {
		id = interactionId,
		coords = coords,
		keyText = tostring(data.keyText or 'E'),
		keyNum = tonumber(data.keyNum) or 38,
		text = tostring(data.text or ''),
		dist = tonumber(data.dist) or 2.0,
		type = tonumber(data.type) or 2,
		createdAt = GetGameTimer(),
		duration = tonumber(data.duration) or 0
	}

	return true
end

local function hideInteractionUI(id)
	if id == nil then
		interactions = {}
		HIDETEXT()
		return true
	end

	interactions[tostring(id)] = nil
	return true
end

exports('showInteractionUI', showInteractionUI)
exports('hideInteractionUI', hideInteractionUI)

exports('DTT_show3d', function(text, isPress, coordsX)
	textcoords = coordsX
	SHOWTEXT(isPress, text)
end)

exports('DTT_hide3d', function()
	HIDETEXT()
end)

exports('DTT_show2d', function(text, isPress)
	SHOWTEXT(isPress, text)
end)

exports('DTT_hide2d', function()
	HIDETEXT()
end)

CreateThread(function()
	while true do
		local sleep = 500
		local playerCoords = GetEntityCoords(PlayerPedId())
		local nearestInteraction = nil
		local nearestDistance = nil

		for id, data in pairs(interactions) do
			if data.duration > 0 and (GetGameTimer() - data.createdAt) >= data.duration then
				interactions[id] = nil
			else
				local distance = #(playerCoords - data.coords)
				if distance <= data.dist then
					if (nearestDistance == nil) or (distance < nearestDistance) then
						nearestDistance = distance
						nearestInteraction = data
					end
				end
			end
		end

		if nearestInteraction then
			sleep = 0
			SHOWTEXT(nearestInteraction.keyText, nearestInteraction.text)
			textcoords = nearestInteraction.coords
		else
			HIDETEXT()
		end

		Wait(sleep)
	end
end)

-- Citizen.CreateThread(function()
--     while true do 
-- 		local sleep = 1000
		
-- 		if isShowUI then 
-- 			local mCoords = textcoords or GetEntityCoords(PlayerPedId())
-- 			sleep = 0
-- 			-- print('ok')
-- 			local x, y, z = table.unpack(mCoords)
-- 			local onScreen, DTT, yyy = GetHudScreenPositionFromWorldPosition(x, y, z +1.225)
--             SendNUIMessage({
--                 action = 'POS',
--                 left = DTT*100,
--                 top = yyy*100
--             })

-- 		end 
-- 		Citizen.Wait(sleep)
-- 	end 
-- end)
