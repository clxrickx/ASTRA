function onTick()
    x = input.getNumber(1) -- x position(cartesian)
    y = input.getNumber(2) -- y position(cartesian)
    z = input.getNumber(3) -- z position(cartesian)
    PV_Xr = input.getNumber(4) -- x rotation(euler)
    PV_Yr = input.getNumber(5) -- y rotation(euler)
    PV_Zr = input.getNumber(6) -- z rotation(euler)
    v_spd = input.getNumber(9) -- linear velocity Z speed
    ra = input.getNumber(18) -- radio altimeter(parllel to airframe) | 18 because physics sensor comp indices range from 1-17
    launch = input.getBool(1) -- wired to launch button
    test = input.getBool(2) -- wired to test button

    stage = 1 -- flight stage(init guard)

    if test then
        stage = 0 --test state
    elseif ra < 1 then
        stage = 1 --ground state
    elseif launch then
        stage = 2 --launch/ascent state
    elseif ra > 50 and v_spd < -5 then
        stage = 3 --descend state
    elseif ra >= 1 and ra <= 50 and v_spd >= -5 and v_spd < 0 then
        stage = 4 --approach state
    end

    output.setNumber(1, PV_Xr)
    output.setNumber(2, PV_Yr)
    output.setNumber(3, PV_Zr)
    output.setNumber(4, v_spd)
    output.setNumber(5, ra)
    output.setNumber(6, stage)
end

function onDraw() --debug info
    screen.setColor(0, 0, 0, 255)
    screen.drawText(5, 5, "Stage: " .. stage)
    screen.drawText(5, 15, "Xr: " .. PV_Xr)
    screen.drawText(5, 25, "Yr: " .. PV_Yr)
    screen.drawText(5, 35, "v_spd: " .. v_spd)
    screen.drawText(5, 45, "ra: " .. ra)
end
