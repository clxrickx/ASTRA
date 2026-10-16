prev_errorx = 0 --init guard
prev_errory = 0 --init guard
Ix = 0 --init guard
Iy = 0 --init guard
dt = 1/60 -- 60hz tick rate as per stormworks

function PIDx(setpoint, pv, Kp, Ki, Kd)
    ex = setpoint - pv
    Px = ex * Kp
    Ix = Ix + ex * dt
    Dx = (ex - prev_errorx) / dt * Kd
    prev_errorx = ex

    return Px + (Ix * Ki) + Dx
end

function PIDy(setpoint, pv, Kp, Ki, Kd)
    ey = setpoint - pv
    Py = ey * Kp
    Iy = Iy + ey * dt
    Dy = (ey - prev_errory) / dt * Kd
    prev_errory = ey

    return Py + (Iy * Ki) + Dy
end

function onTick()
    PV_Xr = input.getNumber(1)
    PV_Yr = input.getNumber(2)
    PV_Zr = input.getNumber(3)
    v_spd = input.getNumber(4)
    ra = input.getNumber(5)
    stage = input.getNumber(6)

    tvc_x = 0 --init guard, no z rotation control needed
    tvc_y = 0

    SP_Xr = 0 -- x rotation setpoint
    SP_Yr = 0 -- y rotation setpoint

    if stage == 1 then
        tvc_x, tvc_y = 0, 0 --tvcs neutral on ground
        Ix, Iy, prev_errorx, prev_errory = 0, 0, 0, 0 --prevent integral windup and derivative kick
    else
        tvc_x = PIDx(SP_Xr, PV_Xr, 0.0, 0.0, 0.0)
        tvc_y = PIDy(SP_Yr, PV_Yr, 0.0, 0.0, 0.0)
    end

    output.setNumber(1, tvc_x)
    output.setNumber(2, tvc_y)
end
