I = 0
prev_error = 0
dt = 1/60 -- 60hz tick rate

function PID(setpoint, pv, Kp, Ki, Kd)
    e = (setpoint - pv + math.pi) % (2 * math.pi) - math.pi
    P = e * Kp
    I = Ix + e * dt
    D = (e - prev_error) / dt * Kd
    prev_error = e
    return P + (I * Ki) + D
end

function clamp(v, lo, hi)
    return math.max(lo, math.min(hi, v))
end

function onTick()

end
