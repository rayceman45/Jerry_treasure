Config = {}

Config.Base = '1.1'

Config.ShowBlips = true
Config.ShowBlipsRadius = true

Config.ItemsUse = "map"
Config.RemoveItem = true
Config.ItemsCountRemove = 1

Config.Items = {
    Item = {
        Itemname = 'water',
        Itemcount = {1, 4},
        bonusOnOff = true,
        bonus = {
            {
                itembonus = "bread", -- ไอเทมโบนัส 
                bonuscount = {1, 4},        -- จำนวนไอเทมโบนัส
                bonusdroprate = 100        -- % การดรอปของไอเทมโบนัส
            }
        }
    }
}

Config.Treasure = {
    {
        x = 3896.13,
        y = -4709.85,
        z = 4.74
    },
    {
        x = 4265.38,
        y = -4356.54,
        z = 20.86
    },
    {
        x = 4776.17,
        y = -4335.71,
        z = 12.09
    },
    {
        x = 4871.98,
        y = -4627.33,
        z = 14.62
    },
    {
        x = 4918.48,
        y = -4906.66,
        z = 3.45
    }
}

Config.grandZ = {30.0, 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 62.0, 70.0,1000}

Config.Blips = {
    name = 'Treasure',
    sprite = 161,
    scale = 1.0,
    color = 27
}

Config.BlipsRadius = {
    sprite = 9,
    radius = 45.0,  -- ขนาดของ วง ในแมพ (แนะนำ 45.0 ต้องมีจุดด้านหลังด้วยถึงจะใช้งานได้)
    color = 27,
    intensity = 300
}

Config.Text = {
    -- ฝั่ง Client
    ['CheckStatus'] = 'คุณเปิดแผนที่ล่าสมบัติไปแล้ว!',

    -- ฝั่ง Server
    -- 1.1
    ['header_text'] = 'แจ้งเตือน !',
    ['item_limit'] = 'ไอเทมของคุณเต็มแล้ว',
    ['item_bonus_limit'] = 'ไอเทมโบนัสของคุณเต็ม',
    -- 1.2
    ['item_weight'] = 'น้ำหนักของคุณเต็ม',
    ['item_bonus_weight'] = 'น้ำหนักของคุณเต็ม'
}