I = 0
prev_error = 0
dt = 1/60 -- 60hz tick rate

function PID(setpoint, pv, Kp, Ki, Kd)
    e = setpoint - pv
    P = e * Kp
    I = I + e * dt
    D = (e - prev_error) / dt * Kd
    prev_error = e
    return P + (I * Ki) + D
end

function clamp(v, lo, hi)
    return math.max(lo, math.min(hi, v))
end

function onTick()
    spd = input.getNumber(3) -- vertical speed, factored as "spd" for simplicity
    ra = input.getNumber(4) -- radio altimeter
    stage = input.getNumber(5)
    y = input.getNumber(6) -- vertical position(cartesian)

    sp = 0 -- init guard; linear speed setpoint

    if stage == 0 or stage == 1 then --test stage/ground stage
        sp = 0 
    elseif stage == 2 then --climb/ascent
        sp = 20 
    elseif stage == 3 then --coast/apogee
        sp = 0
    elseif stage == 4 then --descent
        sp = -15
    elseif stage == 5 then --landing
        sp = -3
    end

    thr = PID(sp, spd, 1, 0, 0)
    clamp(thr, 0, 1)

    output.setNumber(1, thr) 
    output.setNumber(2, sp) --debug
end
