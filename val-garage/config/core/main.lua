Config = Config or {}

-- ==============================
-- General
-- ==============================
Config.Debug = false
Config.SeeMarker = 25

-- ==============================
-- Marker Colors
-- ==============================
Config.activeColor = { r = 255, g = 0, b = 0 }       -- จุดเก็บรถ
Config.activeColor2 = { r = 222, g = 222, b = 222 }  -- จุดเบิกรถ

Config.MarkerType = {
    car = 36,
    boat = 35,
    helicopter = 34,
}

-- ==============================
-- Dimension / Access
-- ==============================
Config.WhitelistDimen = { 100, 101 }  -- มิติที่อนุญาตให้ใช้งานลานจอดรถ
Config.DimensionsAllow = { 0, 100 }   -- มิติที่ต้องการเช็คสำหรับการใช้งาน Garage

-- ==============================
-- Economy / Vehicle State
-- ==============================
Config.poundCost = 3000
Config.pounddeposit = true -- true = พาวรถจากจุดฝากได้
Config.healthPound = 100
Config.fuelPound = 100

-- ==============================
-- Spawn / Ghost
-- ==============================
-- ระยะ Ghost รอบจุดเบิกรถ (ใช้เป็นค่า default ถ้าจุดนั้นไม่ได้กำหนด GhostRadius)
Config.GhostRadius = 7.5

-- ==============================
-- Notification Hook
-- ==============================
Config.notification = function(type, text)
    -- type = 'success','error'
    -- text = 'ALERT TEXT'
    TriggerEvent('pNotify:SendNotification', {
        text = text,
        type = type,
        timeout = 8000,
    })
end
