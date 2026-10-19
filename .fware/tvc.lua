prev_errorx = 0 --init guard
prev_errorz = 0 --init guard
Ix = 0 --init guard
Iz = 0 --init guard
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

function PIDz(setpoint, pv, Kp, Ki, Kd)
    ez = (setpoint - pv + math.pi) % (2 * math.pi) - math.pi
    Pz = ez * Kp
    Iz = Iz + ez * dt
    Dz = (ez - prev_errory) / dt * Kd
    prev_errorz = ez

    return Pz + (Iz * Ki) + Dz
end

function onTick()
    PV_Xr = input.getNumber(1)
    PV_Zr = input.getNumber(2)
    v_spd = input.getNumber(3)
    ra = input.getNumber(4)
    stage = input.getNumber(5)

    tvc_x = 0 --init guard, no z rotation control needed
    tvc_z = 0

    SP_Xr = math.pi -- x rotation setpoint
    SP_Zr = math.pi -- y rotation setpoint

    if stage == 1 then
        tvc_x, tvc_z, ex, ey = 0, 0, 0, 0 --tvcs neutral on ground
        Ix, Iy, prev_errorx, prev_errory = 0, 0, 0, 0 --prevent integral windup and derivative kick
    else
        tvc_x = PIDx(SP_Xr, PV_Xr, 4, 0, 0)
        tvc_z = PIDz(SP_Zr, PV_Yr, 4, 0, 0)
        tvc_x = clamp(tvc_x, -0.5, 0.5)
        tvc_z = clamp(tvc_z, -0.5, 0.5)
    end

    output.setNumber(1, tvc_x)
    output.setNumber(2, tvc_z)
    output.setNumber(3, -tvc_x)
    output.setNumber(4, -tvc_z)
    output.setNumber(5, SP_Xr)
    output.setNumber(6, SP_Zr)
    output.setNumber(7, ex)
    output.setNumber(8, ey)

end
