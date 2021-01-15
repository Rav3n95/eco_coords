ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local zMod = Config.MarkerPosZ
local scaleXYZ = Config.MarkerscaleXYZ
local markerType = Config.MarkerType
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

            DrawMarker(markerType,
                coordX,
                coordY,
                coordZ,
                0.0, 0.0, 0.0, -- dir
                0, 0.0, 0.0, -- root
                scaleXYZ, scaleXYZ, scaleXYZ,
                255, 0, 0, 100, -- RGBA
                false, -- bobUpAndDown
                false, 2, false, false, false, false)

            DrawGenericText(("~g~X~w~: %s ~g~Y~w~: %s ~g~Z~w~: %s ~g~H~w~: %s ~g~R~w~: %s ~g~MARKER~w~: %s"):format(coordX, coordY, coordZ, heading, scaleXYZ, markerType))

            -- SHIFT
            if IsControlPressed(0, 61) then

                -- SHIFT - LEFT CTRL
                if not IsControlPressed(0, 36) then

                    -- SHIFT + SCROLL
                    if IsControlJustReleased(0, 97) then

                        if scaleXYZ > 1 then
                            scaleXYZ = scaleXYZ - 0.2
                        end
                    end

                    -- SHIFT + SCROLL
                    if IsControlJustReleased(0, 96) then

                        scaleXYZ = scaleXYZ + 0.2
                    end
                end

                -- SHIFT + LEFT CTRL
                if IsControlPressed(0, 36) then

                    if IsControlJustReleased(0, 96) then

                        if markerType < 43 then
                            markerType = markerType + 1
                        end
                    end

                    if IsControlJustReleased(0, 97) then

                        if markerType > 0 then
                            markerType = markerType - 1
                        end
                    end
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

                    -- ADD DESCRIPTION
                    local description = 'no description'

                    if Config.AddDescription == 1 then

                        description = KeyboardInput() or 'no description'
                    end

                    -- COPY TO CLPBOARD
                    if Config.CopyToClipboard == 1 then

                        SendNUIMessage({
                            text = ("%s, %s, %s, h: %s"):format(coordX, coordY, coordZ, heading)
                        })

                        ESX.ShowNotification("Vágólapra másolva")
                    end

                    TriggerServerEvent('eco_coords:saveCoord', coordX, coordY, coordZ, scaleXYZ, heading, zoneName .. " - " .. streetName, description)
                    ESX.ShowNotification(("Pozició: %s - %s~n~~g~%s, %s, %s"):format(zoneName, streetName, coordX, coordY, coordZ))
                end
            else

                --SCROLL
                if IsControlJustReleased(0, 97) then

                    if zMod > -1 then
                        zMod = zMod - 0.05
                    end
                end

                --SCROLL
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
    scaleXYZ = Config.MarkerscaleXYZ
    markerType = Config.MarkerType
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
