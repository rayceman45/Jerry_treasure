ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local isdead = false
local onclick = false

local blip = nil
local zoneblip = nil
local CheckBlips = true
local coordsZ = nil

local working = false

local obj = nil

RegisterNetEvent("Jerry_treasure:ChekStatus")
AddEventHandler("Jerry_treasure:ChekStatus", function()
    if true then 
        TriggerEvent('Jerry_treasure:RandomCoords')
        TriggerServerEvent("Jerry_hunting:server:removeItems")
    else
        exports["mythic_notify"]:SendAlert("error", Config.Text['CheckStatus'], 5000)
    end
end)


RegisterNetEvent("Jerry_treasure:RandomCoords")
AddEventHandler("Jerry_treasure:RandomCoords", function()
    local result = Config.Treasure[math.random(#Config.Treasure)]

    local a = 15
    local b = 35

    local modX = math.random(-a, b)
    local modY = math.random(-a, b)

    local coordsX = result.x + modX
    local coordsY = result.y + modY

    coordsZ = GetCoordZ(coordsX, coordsY)

    
    Start(result.x, result.y, result.z, coordsX, coordsY, coordsZ)
end)

function Start(x, y, z, coordsX, coordsY, coordsZ)
    local Distance10 = true
    local Distance7 = true
    local Distance5 = true
    local Distance2 = true
    working = true
    isdead = false

    PlaySoundFrontend(-1, "download_start", "DLC_BTL_Break_In_Sounds", true)
    playanim()
    Blips(x, y, z)
    print(coordsX, coordsY, coordsZ)
    print('base' .. x, y, z)

    local sw = 100
    local anim = false
    while true do
        local ped = GetEntityCoords(PlayerPedId())

        if (GetDistanceBetweenCoords(ped, coordsX, coordsY, coordsZ, true) <= 15 and Distance10) then
            PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
            sw = 1000
        else
            Distance10 = true
            Distance7 = true
            Distance5 = true
            Distance2 = true
        end

        if (GetDistanceBetweenCoords(ped, coordsX, coordsY, coordsZ, true) <= 10 and Distance7) then
            Distance10 = false
            PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
            sw = 750
        end

        if (GetDistanceBetweenCoords(ped, coordsX, coordsY, coordsZ, true) <= 5 and Distance5) then 
            Distance7 = false
            onclick = false
            PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
            sw = 500
        end

        if (GetDistanceBetweenCoords(ped, coordsX, coordsY, coordsZ, true) <= 1.5 and Distance2) then
            Distance5 = false
            PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
            onclick = true
            sw = 250
        end

        if isdead then 
            DelObj(obj)
            Delblip(blip, zoneblip)
            
            coordsX = nil
            coordsY = nil
            coordsZ = nil
            return
        end
        Citizen.Wait(sw)
    end
end

Citizen.CreateThread(function()
    while true do 
        local sleep = 500
        if onclick then
            sleep = 7
            ESX.ShowHelpNotification("Press ~INPUT_PICKUP~ to dig for treasure")
            if IsControlJustReleased(0, 38) then
                DelObj(obj)
                TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
                TriggerEvent("mythic_progbar:client:progress", {
                name = "unique_action_name",
                duration = 7000,
                label = "Action Label",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }
                }, function(status)
                    if not status then
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("Jerry_hunting:server:addItems", Config.Items.Item.Itemname, math.random(Config.Items.Item.Itemcount[1], Config.Items.Item.Itemcount[2]) )
                        working = false
                        isdead = true
                    end
                end)    
            end
            if isdead then 
                onclick = false
            end
        end
        Wait(sleep)
    end
end)


function playanim()
    local dict = "amb@world_human_tourist_map@male@base"
    local ped = GetPlayerPed(-1)
    local coords    = GetEntityCoords(ped)
    local boneIndex = GetPedBoneIndex(ped, 28422)

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(100)
        end
        if not anim then
            TaskPlayAnim(GetPlayerPed(-1), dict, "base", 8.0, 8.0, -1, 50, 0, false, false, false)
            anim = true
        else
            anim = false
            ClearPedTasks(GetPlayerPed(-1))
        end

        ESX.Game.SpawnObject('prop_tourist_map_01', {
            x = coords.x,
            y = coords.y,
            z = coords.z + 2
        }, function(object)
            AttachEntityToEntity(object, ped, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
            while true do
                sleep = 1000   
                obj = object
                Wait(sleep)
            end
        end)
    end
end

-- GetCoord Z
function GetCoordZ(x, y)
    while true do 
        local groundCheckHeights = Config.grandZ
        if z == nil then 
            for i, height in ipairs(groundCheckHeights) do
                local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
                --
                if foundGround then
                    return z
                end
            end
        end
        Wait(1000)
    end
end

-- Create Blips
function Blips(x, y, z)
    if Config.ShowBlips then
        blip = AddBlipForCoord(x, y, z)
        SetBlipSprite(blip, Config.Blips.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blips.scale)
        SetBlipColour(blip, Config.Blips.color)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blips.name)
        EndTextCommandSetBlipName(blip)
    end
    if Config.ShowBlipsRadius then 
        zoneblip = AddBlipForRadius(x, y, z, Config.BlipsRadius.radius)
        SetBlipSprite(zoneblip, Config.BlipsRadius.sprite)
        SetBlipColour(zoneblip, Config.BlipsRadius.color)
        SetBlipAlpha(zoneblip, Config.BlipsRadius.intensity)
    end
end

function DelObj(obj) 
    DeleteObject(obj)
    ClearPedSecondaryTask(GetPlayerPed(-1)) 
end

function Delblip(blip, zoneblip)
    RemoveBlip(blip)
    RemoveBlip(zoneblip)
end

AddEventHandler('esx:onPlayerDeath', function(data)
	isdead = true
end)