function onTick()
    -- Get/assign composite data to variables.
    xGPS =input.getNumber(1)
    yGPS = input.getNumber(2)
    zGPS = input.getNumber(3) -- check if we have a barometer in SW
    xV_lin = input.getNumber(7)
    yV_lin = input.getNumber(8)
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
    test = input.getBool(1)
    launch = input.getBool(2)
end

function onDraw()
    screen.setColor(255, 255, 255)

    --
end
