ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local zMod = Config.MarkerPosZ
local scaleXY = Config.MarkerScaleXY
local activate, _PlayerPedId


Citizen.CreateThread(function()

    local coord, coordX, coordY, coordZ, heading

    _PlayerPedId = PlayerPedId()


    while true do

        Citizen.Wait(0)

        if activate then

            coord = GetEntityCoords(_PlayerPedId)
            coordX = FormatCoord(coord.x)
            coordY = FormatCoord(coord.y)
            coordZ = FormatCoord(coord.z + zMod)
            heading = FormatCoord(GetEntityHeading(_PlayerPedId))

            DrawMarker(
                Config.MarkerType, 
                coordX,
                coordY,
                coordZ, 
                0.0, 0.0, 0.0, -- dir
                0, 0.0, 0.0, -- root
                scaleXY, scaleXY, Config.MarkerScaleZ,
                255, 0, 0, 100, -- RGBA
                false, -- bobUpAndDown
                false, 2, false, false, false, false)

            DrawGenericText(("~g~X~w~: %s ~g~Y~w~: %s ~g~Z~w~: %s ~g~H~w~: %s ~g~R~w~: %s ~g~SAVE~w~: SHIFT+X"):format(coordX, coordY, coordZ, heading, scaleXY))

            -- SHIFT
            if IsControlPressed(0, 61) then

                -- SHIFT + SCROLL 16 or 97
                if IsControlJustReleased(0, 97) then

                    if scaleXY > 1 then
                        scaleXY = scaleXY - 0.2
                    end
                end

                -- SHIFT + SCROLL 17 or 96
                if IsControlJustReleased(0, 96) then

                    scaleXY = scaleXY + 0.2
                end

                -- SHIFT+X
                if IsControlJustReleased(0, 105) then

                    local streetNameHash, crossingRoad = GetStreetNameAtCoord(coordX, coordY, coordZ, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
                    local zoneHash = GetNameOfZone(coordX, coordY, coordZ)
                    local streetName = GetStreetNameFromHashKey(streetNameHash)

                    local zoneName = zoneHash

                    if Config.ZoneNames[zoneHash] then

                        zoneName = Config.ZoneNames[zoneHash]
                    end

                    local description = KeyboardInput() or 'no description'

                    TriggerServerEvent('eco_coords:saveCoord', coordX, coordY, coordZ, scaleXY, heading, zoneName .. " - " .. streetName, description)
                    ESX.ShowNotification("Pozició: " .. zoneName .. " - " .. streetName .. "~n~~g~" .. coordX.. ", " ..coordY .. ", " .. coordZ)
                end
            else

                --SCROLL 16 or 97
                if IsControlJustReleased(0, 97) then

                    if zMod > -1 then
                        zMod = zMod - 0.05
                    end
                end

                --SCROLL 17 or 96
                if IsControlJustReleased(0, 96) then

                    zMod = zMod + 0.05
                end
            end

        else

            _PlayerPedId = PlayerPedId()
            Citizen.Wait(1000)
        end
    end
end)


RegisterNetEvent('eco_coords:toggle')
AddEventHandler('eco_coords:toggle', function()

    activate = not activate

    if activate then

        ESX.ShowNotification("Használd az egér görgöt! Kombinálhatod a SHIFT nyovatartásával. Mentés: SHIFT+X")
    else

        ESX.ShowNotification("coord kikapcsolva!")
    end
end)

RegisterNetEvent('eco_coords:resetCoords')
AddEventHandler('eco_coords:resetCoords', function()

    zMod = Config.MarkerPosZ
    scaleXY = Config.MarkerScaleXY
end)

FormatCoord = function(coord)
    if coord == nil then
        return "unknown"
    end

    return tonumber(string.format("%.2f", coord))
end


function KeyboardInput()

    AddTextEntry('FMMC_KEY_TIP1', "Megjegyzés:")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 100)

    local blockinput

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result --Returns the result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end


function DrawGenericText(text)
    SetTextColour(186, 186, 186, 255)
    SetTextFont(7)
    SetTextScale(0.384, 0.384)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.40, 0.00)
end