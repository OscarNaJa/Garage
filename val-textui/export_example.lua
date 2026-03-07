-- ตัวอย่างการใช้งาน export แบบใหม่
-- ใช้งานจาก resource อื่น: exports['val-textui']:showInteractionUI({...})

CreateThread(function()
    Wait(1000)

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    exports['val-textui']:showInteractionUI({
        id = 'example_interaction_1',
        coords = coords,
        keyNum = 38,
        keyText = 'E',
        text = 'กด [E] เพื่อโต้ตอบ',
        dist = 3.0,
        duration = 6000,
        type = 2
    })

    -- ลบเองก่อนหมดเวลา (ไม่ใส่ก็ได้เพราะมี duration)
    Wait(3000)
    exports['val-textui']:hideInteractionUI('example_interaction_1')
end)
