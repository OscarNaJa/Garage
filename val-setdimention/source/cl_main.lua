----------------------------------------------------------
-- กำหนดตัวแปรและเตรียม ESX (Client)
----------------------------------------------------------
local ESX = exports["es_extended"]:getSharedObject()
local resourceName = GetCurrentResourceName()

Config = Config or {}
Config.Dimensions = Config.Dimensions or {}

-- เก็บมิติปัจจุบันฝั่ง Client (เพื่ออ้างอิงภายใน UI/เงื่อนไข)
local Mydime = 0
local Myzone = nil
local ShowUI = false
local spawnedProps = {}   -- เก็บ entity ของ prop ที่สร้างไว้ ตาม zone.text
local DuiOpen = false
local STREAM_IN  = 30.0  -- ระยะเริ่ม "สร้าง"
local STREAM_OUT = 40.0  -- ระยะเริ่ม "ลบ" (ให้กว้างกว่านิด กันกะพริบ)
local ReturnOnDeath = false  -- ตายแล้วกลับมิติเดิม
local StoryDimen = { 100 , 101}
----------------------------------------------------------
AddEventHandler('esx:onPlayerDeath', function()
    -- print('******************************************************')
    -- print("[Dimension] PlayerDied "..tostring(ReturnOnDeath))
    -- print('******************************************************')

	if ReturnOnDeath then
		if Mydime ~= StoryDimen[Mydime] then
            SetDimension(0)
            ReturnOnDeath = false
        end
	end
end)

function GetWhitelistDimen()
    return StoryDimen
end

exports('GetWhitelistDimen', GetWhitelistDimen)

-- function isWhitelistedDimension(dim)
--     local WhitelistDimen = exports['val-setdimention']:GetWhitelistDimen()
--     for _, allowed in ipairs(WhitelistDimen) do
--         if dim == allowed then
--             return true
--         end
--     end
--     return false
-- end

-- exports('isWhitelistedDimension', isWhitelistedDimension)

-- โหลดโมเดลให้พร้อมใช้งาน
function loadModel(model)
    local hash = (type(model) == "string") and GetHashKey(model) or model
    if not IsModelInCdimage(hash) then
        print(("[PropSpawner] ❌ โมเดลไม่อยู่ในเกม: %s"):format(tostring(model)))
        return nil
    end
    RequestModel(hash)
    local t = GetGameTimer()
    while not HasModelLoaded(hash) do
        Wait(0)
        if GetGameTimer() - t > 5000 then
            print(("[PropSpawner] ⚠️ โหลดโมเดลนานเกิน 5 วิ: %s"):format(tostring(model)))
            break
        end
    end
    if not HasModelLoaded(hash) then return nil end
    return hash
end

-- หา z ของพื้น (ใช้ได้ทั้งพื้น/ถนน) มี fallback เป็น raycast
function findGroundZ(x, y, zHint)
    local startZ = zHint or 1000.0
    local ok, z = GetGroundZFor_3dCoord(x + 0.0, y + 0.0, startZ + 0.0, false)
    if ok then return z end

    -- ลองแบบ GetGroundZAndNormalFor_3dCoord
    local ok2, z2 = GetGroundZAndNormalFor_3dCoord(x + 0.0, y + 0.0, startZ + 0.0)
    if ok2 then return z2 end

    -- สุดท้าย: raycast ลงล่าง
    local test = StartExpensiveSynchronousShapeTestLosProbe(x, y, startZ, x, y, -500.0, 1, 0, 4)
    local _, hit, _, hitCoords = GetShapeTestResult(test)
    if hit then return hitCoords.z end

    -- ถ้าไม่เจอจริง ๆ ให้ใช้ zHint หรือ 0.0
    return zHint or 0.0
end

-- รอให้ collision บริเวณนั้นโหลด (กันจม/ลอย)
function ensureCollision(entity, x, y, z)
    if not HasCollisionLoadedAroundEntity(entity) then
        RequestCollisionAtCoord(x, y, z)
        local t = 0
        while not HasCollisionLoadedAroundEntity(entity) and t < 2000 do
            Wait(0)
            t = t + 1
        end
    end
end

-- ✅ ลบ prop ทั้งหมดที่เราเคยสปาวน์
function deleteAllZoneProps()
    for zonename, ent in pairs(spawnedProps) do
        if DoesEntityExist(ent) then
            SetEntityAsMissionEntity(ent, true, true)
            DeleteObject(ent) -- หรือ DeleteEntity(ent)
        end
        spawnedProps[zonename] = nil
    end
end

-- ลบ prop ของโซนเดียว (ถ้ามี)
function removePropForZone(zone)
    if not zone or not zone.text then return end
    local ent = spawnedProps[zone.text]
    if ent and DoesEntityExist(ent) then
        SetEntityAsMissionEntity(ent, true, true)
        DeleteObject(ent) -- หรือ DeleteEntity(ent)
        -- print(("[PropSpawner] 🗑️ STREAM-OUT zone '%s'"):format(zone.text))
    end
    spawnedProps[zone.text] = nil
end

-- สร้าง prop ให้โซนเดียว (ถ้ายังไม่มี)
function spawnPropForZone(zone)
    if not (zone and zone.text and zone.coord and zone.Prop and zone.Prop.model) then return end
    if spawnedProps[zone.text] and DoesEntityExist(spawnedProps[zone.text]) then return end

    local modelHash = loadModel(zone.Prop.model)
    if not modelHash then
        print(("[PropSpawner] ❌ โหลดโมเดลไม่สำเร็จ: %s @ zone %s"):format(tostring(zone.Prop.model), tostring(zone.text)))
        return
    end

    local x = tonumber(zone.coord.x) or 0.0
    local y = tonumber(zone.coord.y) or 0.0
    local zHint  = tonumber(zone.coord.z) or 1000.0
    local heading = tonumber(zone.Prop.heading or 0.0) or 0.0
    local zGround = findGroundZ(x, y, zHint)

    local ent = CreateObjectNoOffset(modelHash, x, y, zGround, false, false, false)
    if ent and ent ~= 0 then
        SetEntityAsMissionEntity(ent, true, true)
        ensureCollision(ent, x, y, zGround)
        PlaceObjectOnGroundProperly(ent)
        SetEntityHeading(ent, heading)
        SetEntityCollision(ent, true, true)
        FreezeEntityPosition(ent, true)
        SetEntityInvincible(ent, true)
        spawnedProps[zone.text] = ent

        -- print(("[PropSpawner] ✅ STREAM-IN '%s' zone '%s' (%.2f, %.2f, %.2f)")
            -- :format(tostring(zone.Prop.model), tostring(zone.text), x, y, zGround))
    else
        print(("[PropSpawner] ❌ CreateObject ล้มเหลว: %s @ zone %s")
            :format(tostring(zone.Prop.model), tostring(zone.text)))
    end

    SetModelAsNoLongerNeeded(modelHash)
end

-- เมื่อ resource หยุด: ลบ props ทั้งหมด
AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        deleteAllZoneProps()
    end
end)

-- ดึงค่า Dimension ปัจจุบันจากตัวแปร local
function GetDimension()
    return Mydime
end
exports('GetDimension', GetDimension)

function IsDuiOpen()
    return DuiOpen
end
exports('IsDuiOpen', IsDuiOpen)

-- ตั้งค่า Dimension โดยเรียก Server Callback ให้เซ็ต Routing Bucket
-- หมายเหตุ: การตั้ง bucket ที่แท้จริงเกิดฝั่ง Server เสมอ
function SetDimension(dime)
    -- กันชนิดและช่วงค่า (เอาเฉพาะจำนวนเต็ม >= 0)
    local n = tonumber(dime)
    if not n then return end
    n = math.floor(n)
    if n < 0 then n = 0 end

    -- ต้องใช้ ESX.TriggerServerCallback (ไม่ใช่ TriggerServerCallback)
    ESX.TriggerServerCallback(resourceName..':setdimension', function(success, currentBucket)
        if success then
            -- อัปเดตตัวแปรใน Client ให้สอดคล้องกับค่าที่ Server ตั้งจริง
            -- exports['esx_core']:Cutscene()
            -- Wait(2000)
            Mydime = currentBucket or n
            -- print(("[Dimension] Success: %d"):format(Mydime))
            TriggerEvent('pNotify:SendNotification', {
                text = 'You have moved to dimension '..Mydime,
                type = 'success',
                timeout = 3000,
                layout = 'centerRight'
            })
        else
            print(('[Dimension] Error: %s'):format(tostring(n)))
        end
    end, n)
end

exports('SetDimension', SetDimension)

RegisterNetEvent(resourceName..":setDimension")
AddEventHandler(resourceName..":setDimension", function(dimension)
    Mydime = dimension
end)

----------------------------------------------------------
-- 🔁 Loop โซน + เปิดเมนู + เด้งกลับ MAIN เมื่อออกนอกโซน
----------------------------------------------------------
local lastBackMainAt = 0      -- กันสแปมเด้งกลับ MAIN
local backMainCooldown = 800  -- ms

-- util: หา zone object จากชื่อ
function getZoneByName(name)
    for _, z in ipairs(Config.Dimensions) do
        if z.text == name then return z end
    end
    return nil
end

CreateThread(function()
    while true do
        local Sleep = 1000
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)

        -- ✅ ถ้าอยู่ในโซน แล้วออกนอก radiusout → เด้งกลับ MAIN + ปิด UI + ปิด DuiOpen
        if Myzone ~= nil then
            local z = getZoneByName(Myzone)
            if z and z.radiusout and z.coord then
                local distOut = #(pCoords - z.coord)
                if distOut > (z.radiusout + 0.0) then
                    local now = GetGameTimer()
                    if now - lastBackMainAt > backMainCooldown then
                        lastBackMainAt = now

                        -- ปิด UI ถ้าเปิดอยู่
                        if ShowUI then
                            ShowUI = false
                            SetNuiFocus(false, false)
                            SendNUIMessage({ action = "hideMenu" })
                        end

                        -- เด้งกลับ MAIN ถ้ายังไม่ใช่ 0
                        if Mydime ~= 0 then
                            -- print(("[Dimension] Out of zone '%s' (%.2fm) → back to MAIN"):format(Myzone, distOut))
                            SetDimension(0)
                        end

                        -- ปิดสถานะทั้งหมด
                        -- print(("[EXIT] โซน: %s (radiusout)"):format(Myzone))
                        Myzone = nil
                        DuiOpen = false            -- ⬅️ เพิ่มบรรทัดนี้
                        ReturnOnDeath = false      -- ⬅️ กัน config พัง
                    end
                end
            else
                ReturnOnDeath = false
                Myzone = nil
                DuiOpen = false                    -- ⬅️ กัน config พัง
            end
        end

        -- 🔍 เช็คว่า tick นี้เราเข้า "ระยะกด" โซนไหนหรือไม่
        local inPressRange = false

        for _, zone in ipairs(Config.Dimensions or {}) do
            local distance = #(pCoords - zone.coord)
            -- ============ สตรีม Prop ตามระยะ ============
            if zone.Prop and zone.Prop.model then
                if distance <= STREAM_IN then
                    -- เข้าเขต -> ให้อยู่ในโลกนี้มี prop
                    if not spawnedProps[zone.text] then
                        spawnPropForZone(zone)
                    end
                elseif distance >= STREAM_OUT then
                    -- ออกห่าง -> ลบทิ้ง
                    if spawnedProps[zone.text] then
                        removePropForZone(zone)
                    end
                end
            else
                -- โซนนี้ไม่ได้กำหนด Prop -> ล้างเผื่อมีค้าง
                if spawnedProps[zone.text] then
                    removePropForZone(zone)
                end
            end
            -- =============================================

            -- Debug markers
            if Config.DebugZone then
                Sleep = 0
                DrawMarker(
                    1, zone.coord.x, zone.coord.y, zone.coord.z - 1.0,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    (zone.radiusPress or 2.0) * 2.0, (zone.radiusPress or 2.0) * 2.0, 1.0,
                    0, 255, 0, 80, false, false, 2, nil, nil, false
                )
                DrawMarker(
                    1, zone.coord.x, zone.coord.y, zone.coord.z - 1.0,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    (zone.radiusout or 7.0) * 2.0, (zone.radiusout or 7.0) * 2.0, 1.0,
                    255, 0, 0, 80, false, false, 2, nil, nil, false
                )
            end

            -- เข้า “ระยะกด”
            if distance < (zone.radiusPress or 2.0) then
                Sleep = 0
                inPressRange = true                 -- ⬅️ ติดธงว่า tick นี้อยู่ในระยะกด

                if Myzone ~= zone.text then
                    Myzone = zone.text
                    ReturnOnDeath = zone.ReturnOnDeath or false
                    -- print(("[ENTER] เข้าสู่โซน: %s"):format(Myzone))
                end

                -- เปิดสถานะ DuiOpen เมื่ออยู่ในระยะกด
                if not DuiOpen then
                    DuiOpen = true                  -- ⬅️ เปิดเมื่อเข้า range
                end

                -- ปุ่มโต้ตอบ
                local success = exports["Assist_Text"]:showInteractionUI({
                    id       = "Diemen_" .. zone.text,
                    coords   = zone.coord - vec(0.0, 0.0, 0.3),
                    keyText  = zone.Key or "E",
                    text     = "CHANGE WORLD",
                    dist     = zone.radiusPress or 2.0,
                    duration = 600,
                    type     = 2
                })

                if success and not ShowUI then
                    ShowUI = true
                    SendNUIMessage({
                        action = "showMenu",
                        zone = {
                            name      = zone.text,
                            text      = zone.text or "มิติ",
                            dimension = zone.dimension or {},
                            vip = zone.dimensionVip or {}

                        },
                        currentDimension = Mydime
                    })
                    SetNuiFocus(true, true)
                end

                break -- เจอโซนที่เข้าแล้ว ไม่ต้องเช็คตัวอื่นในเฟรมนี้
            end
        end

        -- 🧹 ถ้า tick นี้ "ไม่ได้อยู่" ในระยะกดของโซนใดเลย → ปิด DuiOpen
        if not inPressRange and DuiOpen then
            DuiOpen = false                         -- ⬅️ ออกจาก if radiusPress แล้วปิด
        end

        Wait(Sleep)
    end
end)


RegisterNUICallback('closeUI', function(_, cb)
    ShowUI = false
    SetNuiFocus(false, false)
    cb('ok')
end)

function isVipDimension(zone, worldid)
    if not zone or not zone.dimensionVip or not zone.dimensionVip.dimension then
        return false
    end
    for _, d in ipairs(zone.dimensionVip.dimension) do
        if tonumber(d) == tonumber(worldid) then
            return true
        end
    end
    return false
end

RegisterNUICallback('joinWorld', function(data, cb)
    local worldid = tonumber(data.worldid) or 0
    local currentZone = getZoneByName(Myzone)  -- ใช้ Myzone (ปัจจุบันคุณตั้งเป็น zone.text)
    local allow = true
    local denyMsg = nil

    -- ถ้า worldid นี้เป็น VIP ของโซนปัจจุบัน -> ต้องมี item
    if isVipDimension(currentZone, worldid) then
        local checkItem = currentZone.dimensionVip and currentZone.dimensionVip.checkItem or nil
        local count = 0

        if checkItem and checkItem ~= "" then
            -- ป้องกัน error จาก export
            local ok, res = pcall(function()
                return exports["esx_core"]:CheckItem(checkItem)
            end)
            if ok then
                count = tonumber(res) or 0
            else
                -- ถ้า export ล้มเหลว ให้ปฏิเสธไว้ก่อน (หรือจะ allow ก็ได้แล้วแต่ต้องการ)
                count = 0
            end
        end

        if count <= 0 then
            allow = false
        end
    end
    if allow then
        -- ✅ เรียกทุกครั้ง ให้เซิร์ฟเวอร์ตั้ง bucket และ sync ค่า Mydime กลับมาเอง
        -- exports['esx_core']:Cutscene()
        SetDimension(worldid)
        
    else
		TriggerEvent("pNotify:SendNotification", {
			text = "YOU ARE NOT VIP",
			type = errType,
			timeout = 3000,
		})
    end

    -- ปิด UI เสมอ
    ShowUI = false
    SetNuiFocus(false, false)
    cb('ok')
end)
