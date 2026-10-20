-- GLOBALS/INIT GUARDS
dt = 1/60 -- 60hz tick rate

stage = 1
sp = 0 --throttle setpoint
tvc_x = 0 --init guard, no y rotation control needed
tvc_z = 0
prev_fuel = 0
prev_bat = 0
FFpS = 0 --fuel flow per second
BUpS = 0 --battery discharge per second

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
    test = input.getBool(1)
    launch = input.getBool(2)
    -- radio altimeter
    ra = input.getNumber(18)
    -- other external information from various places
    fuel = input.getNumber(19) -- fuel remaining(in litres)
    bat = input.getNumber(20) --battery voltage from 0-1
    servo_x = input.getNumber(21) -- actual x "servo[piston]" position
    servo_z = input.getNumber(22) -- actual z "servo[piston]" position

    -- STAGE SUBPROCESS
    if test then
        stage = 0 --test state
        stagename = "TEST"
    elseif ra > 300 then
        stage = 3 --coast/apogee state
        stagename = "APOG"
    elseif (ra > 50 and yV_lin < 0) or yV_lin < -10 then
        stage = 4 --descent state
        stagename = "DESC"
        launched = false
    elseif ra >= 2 and ra <= 50 and yV_lin < 0 then
        stage = 5 --landing state
        stagename = "LAND"
    elseif launch and not prev_launch then
        stage = 2 --launch/ascent state
        stagename = "LNCH"
        launched = true
    elseif ra < 2 and not launched then -- 2 = 8 units
        stage = 1 --ground state
        stagename = "GRND"
        launched = false
    else
        stage = 2
        stagename = "LNCH"
    end
    prev_launch = launch


    -- THROTTLE SUBPROCESS
    if stage == 0 or stage == 1 then --test stage/ground stage
        sp = 0 
    elseif stage == 2 then --climb/ascent
        sp = 30 
    elseif stage == 3 then --coast/apogee
        sp = -1000 --ensures no power
    elseif stage == 4 then --descent
        sp = -20
    elseif stage == 5 then --landing
        sp = -5
    end

    thr = PIDthr(sp, yV_lin, 20, 0, 2)
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
    FFpS = fuel - prev_fuel * 60
    prev_fuel = fuel

    BUpS = bat - prev_bat * 60
    prev_bat = bat

    servo_dx = servo_x - tvc_x
    servo_dz = servo_z - tvc_z
    -- COMP OUT WRITE (to radio transmitter)
    output.setNumber(1, xGPS)
    output.setNumber(2, yGPS)
    output.setNumber(3, zGPS) -- check if we have a barometer in SW
    output.setNumber(7, xV_lin)
    output.setNumber(8, yV_lin)
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
    output.setBool(1, test)
    output.setBool(2, launch)
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
