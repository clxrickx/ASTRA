prev_errorx = 0 --init guard
prev_errory = 0 --init guard
Ix = 0 --init guard
Iy = 0 --init guard
dt = 1/60 -- 60hz tick rate as per stormworks

function clamp(v, lo, hi)
    return math.max(lo, math.min(hi, v))
end

function PIDx(setpoint, pv, Kp, Ki, Kd)
    ex = (setpoint - pv + math.pi) % (2 * math.pi) - math.pi
    Px = ex * Kp
    Ix = Ix + ex * dt
    Dx = (ex - prev_errorx) / dt * Kd
    prev_errorx = ex

    return Px + (Ix * Ki) + Dx
end

function PIDy(setpoint, pv, Kp, Ki, Kd)
    ey = (setpoint - pv + math.pi) % (2 * math.pi) - math.pi
    Py = ey * Kp
    Iy = Iy + ey * dt
    Dy = (ey - prev_errory) / dt * Kd
    prev_errory = ey

    return Py + (Iy * Ki) + Dy
end

function onTick()
    PV_Xr = input.getNumber(1)
    PV_Yr = input.getNumber(2)
    v_spd = input.getNumber(3)
    ra = input.getNumber(4)
    stage = input.getNumber(5)

    tvc_x = 0 --init guard, no z rotation control needed
    tvc_y = 0

    SP_Xr = math.pi -- x rotation setpoint
    SP_Yr = math.pi -- y rotation setpoint

    if stage == 1 then
        tvc_x, tvc_y, ex, ey = 0, 0, 0, 0 --tvcs neutral on ground
        Ix, Iy, prev_errorx, prev_errory = 0, 0, 0, 0 --prevent integral windup and derivative kick
    else
        tvc_x = PIDx(SP_Xr, PV_Xr, 20, 0.2, 0.5)
        tvc_y = -PIDy(SP_Yr, PV_Yr, 20, 0.2, 0.5)
        tvc_x = clamp(tvc_x, -0.2, 0.2)
        tvc_y = clamp(tvc_y, -0.2, 0.2)
    end

    output.setNumber(1, tvc_x)
    output.setNumber(2, tvc_y)
    output.setNumber(3, SP_Xr)
    output.setNumber(4, SP_Yr)
    output.setNumber(5, ex)
    output.setNumber(6, ey)
end
