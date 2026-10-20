-- GLOBALS/INIT GUARDS
dt = 1/60 -- 60hz tick rate

stage = 1
sp = 0 --fpm setpoint
tvc_x = 0 --init guard, no y rotation control needed
tvc_z = 0
prev_fuel = 0
prev_bat = 0
prev_alt = 0
launch_armed = false
launch_edge = false
FFpS = 0 --fuel flow per second
BUpS = 0 --battery discharge per second
v_spd = 0

-- PID LOCALS
It = 0
Ix = 0
Iz = 0

prev_errort = 0
prev_errorx = 0
prev_errorz = 0

--PID FUNCTIONS
function PIDthr(setpoint, pv, Kp, Ki, Kd)
    Et = setpoint - pv
    Pt = Et * Kp
    It = It + Et * dt
    Dthr = (Et - prev_errort) / dt * Kd
    prev_errort = Et
    return Pt + (It * Ki) + Dthr
end
function PIDx(setpoint, pv, Kp, Ki, Kd)
    ex = (setpoint - pv)
    Px = ex * Kp
    Ix = Ix + ex * dt
    Dx = (ex - prev_errorx) / dt * Kd
    prev_errorx = ex

    return Px + (Ix * Ki) + Dx
end
function PIDz(setpoint, pv, Kp, Ki, Kd)
    ez = (setpoint - pv)
    Pz = ez * Kp
    Iz = Iz + ez * dt
    Dz = (ez - prev_errorz) / dt * Kd
    prev_errorz = ez

    return Pz + (Iz * Ki) + Dz
end

--CLAMP FUNCTION
function clamp(var, lo, hi)
    return math.max(lo, math.min(hi, var))
end



function onTick()
    -- IMU composite
    xGPS = input.getNumber(1)
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
    -- bools
    launch = input.getBool(1)
    -- radio altimeter
    ra = input.getNumber(18)
    -- other external information from various places
    fuel = input.getNumber(19) -- fuel remaining(in litres)
    bat = input.getNumber(20) --battery voltage from 0-1
    servo_x = input.getNumber(21) -- actual x "servo[piston]" position
    servo_z = input.getNumber(22) -- actual z "servo[piston]" position

    v_spd = (yGPS - prev_alt) * 3600
    prev_alt = yGPS

    -- STAGE SUBPROCESS
    launch_edge = launch and not prev_launch
    prev_launch = launch

    if yGPS > 200 then
        stage = 3 --coast/apogee state
        stagename = "APOG"
        lnch_ctrl = false
    elseif yGPS > 12 and v_spd < 10 then
        stage = 2 --descent state
        stagename = "DESC"
    elseif ra < 2 then
        stage = 1 --ground state
        stagename = "GRND"
        if not launch then
            launch_armed = false
        end
    elseif stage == 1 and launch_edge and launch_armed then
        stage = 4
        stagename = "LNCH"
        launch_armed = true
    elseif stage == 4 then
        stage = 4
        stagename = "LNCH"
    else
        stage = 2
    end


    -- THROTTLE SUBPROCESS
    if stage == 0 or stage == 1 then --test stage/ground stage
        sp = 0 
    elseif stage == 4 then --climb/ascent
        sp = 1000 
    elseif stage == 3 or stage == 2 then --descent
        sp = -500
    end

    thr = PIDthr(sp, v_spd, 5, 0, 0.5)
    thr = clamp(thr, 0, 1)
    -- TVC SUBPROCESS
    SP_Xr = 0 -- x rotation setpoint
    SP_Zr = 0 -- z rotation setpoint

    if stage == 1 then
        tvc_x, tvc_z, ex, ez = 0, 0, 0, 0 --tvcs neutral on ground
        Ix, Iz, prev_errorx, prev_errorz = 0, 0, 0, 0 --prevent integral windup and derivative kick
    else
        tvc_x = PIDx(SP_Xr, PV_Xr, 20, 0, 1.5)
        tvc_z = PIDz(SP_Zr, PV_Zr, 20, 0, 1.5)
        tvc_x = clamp(tvc_x, -0.5, 0.5)
        tvc_z = clamp(tvc_z, -0.5, 0.5)
    end

    -- ADDITIONAL TELEMETRY CALCULATIONS
    FFpS = (fuel - prev_fuel) * 60
    prev_fuel = fuel

    BUpS = (bat - prev_bat) * 60
    prev_bat = bat

    servo_dx = servo_x - tvc_x
    servo_dz = servo_z - tvc_z

    -- COMP OUT WRITE (to radio transmitter)
    output.setNumber(1, xGPS)
    output.setNumber(2, yGPS)
    output.setNumber(3, zGPS) -- check if we have a barometer in SW
    output.setNumber(7, xV_lin)
    output.setNumber(8, v_spd)
    output.setNumber(9, zV_lin)
    output.setNumber(10, xV_ang)
    output.setNumber(11, yV_ang)
    output.setNumber(12, zV_ang)
    output.setNumber(13, absV_lin)
    output.setNumber(14, absV_ang)
    output.setNumber(15, PV_Zr)
    output.setNumber(16, PV_Xr)
    output.setNumber(18, ra)
    output.setNumber(19, fuel)
    output.setNumber(20, FFpS)
    output.setNumber(21, bat)
    output.setNumber(22, servo_x)
    output.setNumber(23, servo_z)
    output.setNumber(24, servo_dx)
    output.setNumber(25, servo_dz)
    output.setNumber(31, stage)
    output.setBool(1, launch)
    output.setBool(2, lnch_ctrl)
    -- PROCESSED DATA OUT
    output.setNumber(26, tvc_x)
    output.setNumber(27, tvc_z)
    output.setNumber(28, -tvc_x)
    output.setNumber(29, -tvc_z)
    output.setNumber(30, thr)
end

function onDraw()
    screen.drawText(5, 5,"S"..stage)
    screen.drawText(5, 15, stagename)
end
