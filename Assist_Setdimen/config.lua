Config = {}

Config.DebugZone = false  -- true = แสดงวงกลมโซน, false = ไม่แสดง
Config.Dimensions = {
    {
        text = 'MINER',  --ห้ามซ้ำกัน
        coord = vector3(2944.50, 2795.37, 40.60),
        radiusPress = 2.0, -- ระยะกดปุ่ม
        radiusout = 30.0, -- ระยะออกนอกโซน
        dimension = {1,2,3},
        dimensionVip = {    --ถ้าไม่ใช้ให้ลบออก
           dimension = {4,5},
           checkItem = 'card_vip' -- ไอเท็มที่ใช้ตรวจสอบ
        },
        ReturnOnDeath = true, -- ตายแล้วกลับมิติเดิม
        Key = 'E', -- ปุ่มเปลี่ยนมิติ
        Prop = {    --ถ้าไม่ใช้ให้ลบออก
            model   = "assist_world_prop",
            heading = 138.4
        }
    },
    {
        text = 'RED CUBE',  --ห้ามซ้ำกัน
        coord = vector3(1423.5318, 1480.441, 112.84559),
        radiusPress = 2.0, -- ระยะกดปุ่ม
        radiusout = 25.0, -- ระยะออกนอกโซน
        dimension = {1,2,3},
        dimensionVip = {
           dimension = {4,5},
           checkItem = 'card_vip' -- ไอเท็มที่ใช้ตรวจสอบ
        },
        ReturnOnDeath = true, -- ตายแล้วกลับมิติเดิม
        Key = 'E', -- ปุ่มเปลี่ยนมิติ
        Prop = {
            model   = "assist_world_prop",
            heading = 23.03
        }
    },
    {
        text = 'PURPLE CUBE',  --ห้ามซ้ำกัน
        coord = vector3(1126.3216, 2004.7655, 58.884616),
        radiusPress = 2.0, -- ระยะกดปุ่ม
        radiusout = 25.0, -- ระยะออกนอกโซน
        dimension = {1,2,3},
        dimensionVip = {
           dimension = {4,5},
           checkItem = 'card_vip' -- ไอเท็มที่ใช้ตรวจสอบ
        },
        ReturnOnDeath = true, -- ตายแล้วกลับมิติเดิม
        Key = 'E', -- ปุ่มเปลี่ยนมิติ
        Prop = {
            model   = "assist_world_prop",
            heading = 42.63
        }
    },
    {
        text = 'CYAN CUBE',  --ห้ามซ้ำกัน
        coord = vector3(-13.2218, 2919.7065, 56.793888),
        radiusPress = 2.0, -- ระยะกดปุ่ม
        radiusout = 25.0, -- ระยะออกนอกโซน
        dimension = {1,2,3},
        dimensionVip = {
           dimension = {4,5},
           checkItem = 'card_vip' -- ไอเท็มที่ใช้ตรวจสอบ
        },
        ReturnOnDeath = true, -- ตายแล้วกลับมิติเดิม
        Key = 'E', -- ปุ่มเปลี่ยนมิติ
        Prop = {
            model   = "assist_world_prop",
            heading = 92.157
        }
    },
    {
        text = 'ORANGE CUBE',  --ห้ามซ้ำกัน
        coord = vector3(-1815.849, 2514.8134, 2.0566325),
        radiusPress = 2.0, -- ระยะกดปุ่ม
        radiusout = 25.0, -- ระยะออกนอกโซน
        dimension = {1,2,3},
        dimensionVip = {
           dimension = {4,5},
           checkItem = 'card_vip' -- ไอเท็มที่ใช้ตรวจสอบ
        },
        ReturnOnDeath = true, -- ตายแล้วกลับมิติเดิม
        Key = 'E', -- ปุ่มเปลี่ยนมิติ
        Prop = {
            model   = "assist_world_prop",
            heading = 67.176651
        }
    },
    {
        text = 'BLUE CUBE',  --ห้ามซ้ำกัน
        coord = vector3(-2589.613, 2429.8862, 1.3018348),
        radiusPress = 2.0, -- ระยะกดปุ่ม
        radiusout = 25.0, -- ระยะออกนอกโซน
        dimension = {1,2,3},
        dimensionVip = {
           dimension = {4,5},
           checkItem = 'card_vip' -- ไอเท็มที่ใช้ตรวจสอบ
        },
        ReturnOnDeath = true, -- ตายแล้วกลับมิติเดิม
        Key = 'E', -- ปุ่มเปลี่ยนมิติ
        Prop = {
            model   = "assist_world_prop",
            heading = 274.26
        }
    },

    {
        text = 'Process 1', --ห้ามซ้ำกัน
        coord = vector3(1212.0756, -2197.003, 41.423267),
        radiusPress = 2.0, -- ระยะกดปุ่ม
        radiusout = 30.0, -- ระยะออกนอกโซน
        dimension = {1,2,3},
        dimensionVip = {
           dimension = {4,5},
           checkItem = 'card_vip' -- ไอเท็มที่ใช้ตรวจสอบ
        },
        ReturnOnDeath = true, -- ตายแล้วกลับมิติเดิม
        Key = 'E', -- ปุ่มเปลี่ยนมิติ
        Prop = {
            model   = "assist_world_prop",
            heading = 125.92
        }
    },
    {
        text = 'Process 2', --ห้ามซ้ำกัน
        coord = vector3(1221.6331, -2445.232, 44.48159),
        radiusPress = 2.0, -- ระยะกดปุ่ม
        radiusout = 30.0, -- ระยะออกนอกโซน
        ReturnOnDeath = true, -- ตายแล้วกลับมิติเดิม
        Key = 'E', -- ปุ่มเปลี่ยนมิติ
        dimension = {1,2,3},
        Prop = {
            model   = "assist_world_prop",
            heading = 123.06
        }
    },
    {
        text = 'FISHING', --ห้ามซ้ำกัน
        coord = vector3(-273.5118, 6633.5166, 7.4094076),
        radiusPress = 2.0, -- ระยะกดปุ่ม
        radiusout = 18.0, -- ระยะออกนอกโซน
        ReturnOnDeath = true, -- ตายแล้วกลับมิติเดิม
        Key = 'E', -- ปุ่มเปลี่ยนมิติ
        dimension = {1,2,3},
        Prop = {
            model   = "assist_world_prop",
            heading = 43.96
        }
    },
    -- {
    --     text = 'Process ALL', --ห้ามซ้ำกัน
    --     coord = vector3(-3024.908, 86.8441, 11.643776),
    --     radiusPress = 2.0, -- ระยะกดปุ่ม
    --     radiusout = 13.0, -- ระยะออกนอกโซน
    --     ReturnOnDeath = true, -- ตายแล้วกลับมิติเดิม
    --     Key = 'E', -- ปุ่มเปลี่ยนมิติ
    --     dimension = {1,2,3},
    --     Prop = {
    --         model   = "assist_world_prop",
    --         heading =  143.15786
    --     }
    -- },
    {
        text = 'AFK', --ห้ามซ้ำกัน
        -- coord = vector3(6185.3579, 2664.0795, 5.8495845), -- จุดกลาง AFK
        coord = vector3(6180.0717, 2675.1083, 5.8496594),
        radiusPress = 2.0, -- ระยะกดปุ่ม
        radiusout = 200, -- ระยะออกนอกโซน
        ReturnOnDeath = true, -- ตายแล้วกลับมิติเดิม
        Key = 'E', -- ปุ่มเปลี่ยนมิติ
        dimension = {1,2,3,4,5},
        Prop = {
            model   = "assist_world_prop",
            heading = 42.08
        }
    },
    {
        text = 'COUNCIL', --ห้ามซ้ำกัน
        -- coord = vector3(6185.3579, 2664.0795, 5.8495845), -- จุดกลาง AFK
        coord = vector3(-439.3719, 1067.0048, 328.59072),
        radiusPress = 2.0, -- ระยะกดปุ่ม
        radiusout = 28.2, -- ระยะออกนอกโซน
        ReturnOnDeath = true, -- ตายแล้วกลับมิติเดิม
        Key = 'E', -- ปุ่มเปลี่ยนมิติ
        dimension = {1,2,3,4,5},
        Prop = {
            model   = "assist_world_prop",
            heading = 163.25
        }
    },
}