local ESX = exports['es_extended']:getSharedObject()
local resourceName = GetCurrentResourceName()

local function sanitizeDimension(dimension)
    local value = tonumber(dimension)
    if not value then
        return 0
    end

    value = math.floor(value)
    if value < 0 then
        value = 0
    end

    return value
end

local function syncClientDimension(source)
    local bucket = GetPlayerRoutingBucket(source)
    TriggerClientEvent(resourceName .. ':setDimension', source, bucket)
    return bucket
end

ESX.RegisterServerCallback(resourceName .. ':setdimension', function(source, cb, dimension)
    local bucket = sanitizeDimension(dimension)

    SetPlayerRoutingBucket(source, bucket)
    TriggerClientEvent(resourceName .. ':setDimension', source, bucket)

    cb(true, bucket)
end)

RegisterNetEvent('esx:playerLoaded', function(playerId)
    local src = playerId or source
    syncClientDimension(src)
end)

AddEventHandler('playerJoining', function()
    syncClientDimension(source)
end)

AddEventHandler('onResourceStart', function(resName)
    if resName ~= resourceName then
        return
    end

    local players = GetPlayers()
    for i = 1, #players do
        local src = tonumber(players[i])
        if src then
            syncClientDimension(src)
        end
    end
end)
