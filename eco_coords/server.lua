local ESX, QbCore

if Config.FrameWork == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
else
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterNetEvent('eco_coords:saveCoord')
AddEventHandler('eco_coords:saveCoord', function(coordX, coordY, coordZ, scaleXYZ, heading, location, description)

    local file, path, formattedCoord, prefix, text


    -- FILENAME
    local filename = ('coords__%s.txt'):format(os.date('%y_%m_%d'))


    -- PATH
    if Config.SaveDirectory == 1 then

        path = filename -- ROOT DIRECTORY
    else

        path = ('resources/%s/%s'):format(GetCurrentResourceName(), filename) -- SCRIPT DIRECTORY
    end


    -- FORMATTING
    if Config.Formatting == 1 then

        formattedCoord = ('vector4(%s, %s, %s, %s)'):format(coordX, coordY, coordZ, heading)

    elseif Config.Formatting == 2 then

        formattedCoord = ('vector3(%s, %s, %s)'):format(coordX, coordY, coordZ)
    else

        formattedCoord = ('vector4(%s, %s, %s, %s)'):format(coordX, coordY, coordZ, heading)
    end


    prefix = ''

    if Config.AddZoneName == 1 then

        prefix = ('%s -- %s'):format(prefix, location)
    end

    if Config.AddDescription == 1 then

        prefix = ('%s -- %s'):format(prefix, description)
    end

    text = ('\n%s\n%s\n'):format(prefix, formattedCoord)

    -- WRITE
    file = io.open(path, 'a')
    file:write(text)
    file:close()
end)

RegisterNetEvent('eco_coords:server:toggle')
AddEventHandler('eco_coords:server:toggle', function()
    if IsPlayerAceAllowed(source, "command") then
        TriggerClientEvent('eco_coords:toggle', source)
    end
end)

RegisterNetEvent('eco_coords:server:reset')
AddEventHandler('eco_coords:server:reset', function()
    if IsPlayerAceAllowed(source, "command") then
        TriggerClientEvent('eco_coords:resetCoords', source)
    end
end)