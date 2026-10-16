function onTick()
    x = input.getNumber(1) -- x position(cartesian)
    y = input.getNumber(2) -- y position(cartesian)
    z = input.getNumber(3) -- z position(cartesian)
    PV_Xr = input.getNumber(4) -- x rotation(euler)
    PV_Yr = input.getNumber(5) -- y rotation(euler)
    PV_Zr = input.getNumber(6) -- z rotation(euler)
    v_spd = input.getNumber(9) -- linear velocity Z speed
    ra = input.getNumber(18) -- radio altimeter(parllel to airframe) | 18 because physics sensor comp indices range from 1-17

    SP_Xr = 0 -- x rotation setpoint
    SP_Yr = 0 -- y rotation setpoint
    SP_Zr = 0 -- z rotation setpoint

    stage = 0 -- flight stage(init guard)

    if ra < 1 then
        stage = 0 --ground state
    elseif ra >= 1 and v_spd > 5 then
        stage = 1 --ascend state
    elseif ra > 50 and v_spd < -5 then
        stage = 2 --descend state
    elseif ra >= 1 and ra <= 50 and v_spd >= -5 and v_spd < 0 then
        stage = 3 --approach state
    end

    -- flight target calculations
    error_x = SP_Xr - x
    error_y = SP_Yr - y

    output.setNumber(1, SP_Xr)
    output.setNumber(2, SP_Yr)
    output.setNumber(3, SP_Zr)
    output.setNumber(4, v_spd)
    output.setNumber(5, ra)
    output.setNumber(6, stage)

end
