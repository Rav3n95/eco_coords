RegisterNetEvent('eco_coords:saveCoord')
AddEventHandler('eco_coords:saveCoord', function(coordX, coordY, coordZ, scaleXY, heading, location, description)

    local file, path, formattedCoord, prefix, suffix, text


    -- FILENAME
    local filename = ("coords__%s.txt"):format(os.date("%y_%m_%d"))


    -- PATH
    if Config.SaveDirectory == 1 then

        path = filename -- ROOT DIRECTORY
    else

        path = ("resources/%s/%s"):format(GetCurrentResourceName(), filename) -- SCRIPT DIRECTORY
    end


    -- FORMATTING
    if Config.Formatting == 1 then

        formattedCoord = ("vector3(%s, %s, %s)"):format(coordX, coordY, coordZ)

    elseif Config.Formatting == 2 then

        formattedCoord = ("['x'] = %s, ['y'] = %s, ['z'] = %s"):format(coordX, coordY, coordZ)

    elseif Config.Formatting == 3 then

        formattedCoord = ("['x'] = %s, ['y'] = %s, ['z'] = %s, ['h'] = %s"):format(coordX, coordY, coordZ, heading)

    else

        formattedCoord = ("vector3(%s, %s, %s)"):format(coordX, coordY, coordZ)
    end


    prefix = ""

    if Config.AddZoneName == 1 then

        prefix = ("%s -- %s"):format(prefix, location)
    end

    if Config.AddDescription == 1 then

        prefix = ("%s -- %s"):format(prefix, description)
    end


    suffix = ""

    if Config.AddHeading == 1 then

        suffix = ("%s\nheading = %s"):format(suffix, heading)
    end

    if Config.AddMarkerScaleXY == 1 then

        suffix = ("%s\nscale = %s"):format(suffix, scaleXY)
    end


    text = ("\n%s\n%s\n%s\n"):format(prefix, formattedCoord, suffix)


    -- WRITE
    file = io.open(path, "a")
    file:write(text)
    file:close()
end)


TriggerEvent('es:addGroupCommand', 'coords', 'admin', function(source, args, user)

    TriggerClientEvent('eco_coords:toggle', source)

end, function(source, args, user)

    TriggerClientEvent('chat:addMessage', source, { args = { "^1SYSTEM", "Ehhez nincs jogosultságod!" } })
end, { help = "Koordináta rögzítése txt file-ba" })


TriggerEvent('es:addGroupCommand', 'resetcoords', 'admin', function(source, args, user)

    TriggerClientEvent('eco_coords:resetCoords', source)

end, function(source, args, user)

    TriggerClientEvent('chat:addMessage', source, { args = { "^1SYSTEM", "Ehhez nincs jogosultságod!" } })
end, { help = "Koordináta beállítások alapállapotba helyezése" })



