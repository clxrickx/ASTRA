function onTick()
    -- Get/assign composite data to variables.
    xGPS =input.getNumber(1)
    yGPS = input.getNumber(2)
    zGPS = input.getNumber(3) -- check if we have a barometer in SW
    xV_lin = input.getNumber(7)
    v_spd = input.getNumber(8)
    zV_lin = input.getNumber(9)
    xV_ang = input.getNumber(10)
    yV_ang = input.getNumber(11)
    zV_ang = input.getNumber(12)
    absV_lin = input.getNumber(13)
    absV_ang = input.getNumber(14)
    PV_Zr = input.getNumber(15)
    PV_Xr = input.getNumber(16)
    ra = input.getNumber(18)
    fuel = input.getNumber(19)
    FFpS = input.getNumber(20)
    bat = input.getNumber(21)
    servo_x = input.getNumber(22)
    servo_z = input.getNumber(23)
    servo_dx = input.getNumber(24)
    servo_dz = input.getNumber(25)
    tvc_x = input.getNumber(26)
    tvc_z = input.getNumber(27)
    tvc_x_inv = input.getNumber(28)
    tvc_z_inv = input.getNumber(29)
    thr = input.getNumber(30)
    stage = input.getNumber(31)
    launch = input.getBool(1)

    Ex = 0 - PV_Xr
    Ez = 0 - PV_Zr

    status = 0 --warning var for screen, 0 = all good, 1 = caution, 2 = warning
    if fuel < 50 then
        status = 1
    elseif fuel < 15 then
        status = 2
    elseif bat < 0.3 then
        status = 1
    elseif bat < 0.1 then
        status = 2
    end
end

function onDraw() --one monitor block is 32x32
    -- MAIN STATUS
    if status == 0 then
        screen.setColor(255, 255, 255)
    elseif status == 1 then
        screen.setColor(255, 255, 0)
    elseif status == 2 then
        screen.setColor(255, 0, 0)
    end
    screen.drawRectF(0, 0, 160, 11)
    screen.setColor(0, 0, 0)
    screen.drawText(5, 3, "STAGE " .. string.format("%.0f", stage))
    screen.setColor(255, 255, 255)
    -- TVC
    screen.drawText(5, 13, "Ex: " .. string.format("%.1f", Ex * 10))
    screen.drawText(64, 13, "Ez: " .. string.format("%.1f", Ez * 10))

    screen.drawText(5, 21, "TVCx: " .. string.format("%.1f", tvc_x * 10))
    screen.drawText(64, 21, "TVCz: " .. string.format("%.1f", tvc_z * 10))

    screen.drawText(5, 29, "TVCDx: " .. string.format("%.1f", servo_dx * 10))
    screen.drawText(64, 29, "TVCDz: " .. string.format("%.1f", servo_dz * 10))

    screen.drawText(5, 37, "PVx: " .. string.format("%.1f", PV_Xr * 10))
    screen.drawText(64, 37, "PVx: " .. string.format("%.1f", PV_Zr * 10))

    --SPD/ALT
    screen.drawText(5, 45, "VSPD: " .. string.format("%.0f", v_spd) .. "FPM")

    screen.drawText(5, 53, "RA: " .. string.format("%.1f", ra) .. "M")
    screen.drawText(64, 53, "BARO: " .. string.format("%.0f", yGPS-9) .. "M")

    -- ALT GRAPH
    screen.drawRect(138, 15, 20, 70)
    screen.drawRectF(139, 85, 19, -math.abs(yGPS-9/70))
end
