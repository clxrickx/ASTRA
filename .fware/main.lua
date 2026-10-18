function onTick()
    x = input.getNumber(1) -- x position(cartesian)
    y = input.getNumber(2) -- y position(cartesian)
    z = input.getNumber(3) -- z position(cartesian)
    PV_Xr = input.getNumber(4) -- x rotation(euler)
    PV_Yr = input.getNumber(6) -- y rotation(euler)
    v_spd = input.getNumber(9) -- linear velocity Z speed
    ra = input.getNumber(18) -- radio altimeter(parllel to airframe) | 18 because physics sensor comp indices range from 1-17
    launch = input.getBool(1) -- wired to launch button
    test = input.getBool(2) -- wired to test button

    stage = 1 -- flight stage(init guard)

    if test then
        stage = 0 --test state
    elseif launch then
        stage = 1 --launch/ascent state
    elseif ra < 0.75 then -- 0.75 = 3 units
        stage = 3 --ground state
    elseif ra > 50 and v_spd < -5 then
        stage = 3 --descend state
    elseif ra >= 1 and ra <= 50 and v_spd >= -5 and v_spd < 0 then
        stage = 4 --approach state
    end

    output.setNumber(1, PV_Xr)
    output.setNumber(2, PV_Yr)
    output.setNumber(3, v_spd)
    output.setNumber(4, ra)
    output.setNumber(5, stage)
end

function onDraw() --debug info
    screen.setColor(0, 255, 255)
    screen.drawText(5, 5, "S" .. stage)
end
