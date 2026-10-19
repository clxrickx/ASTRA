launched = false
prev_launch = false


function onTick()
    x = input.getNumber(1) -- x position(cartesian)
    z = input.getNumber(2) -- z position(cartesian)
    y = input.getNumber(3) -- y position(cartesian)
    PV_Xr = input.getNumber(4) -- x rotation(euler)
    PV_Zr = input.getNumber(6) -- z rotation(euler)
    PV_Yr = input.getNumber(5) -- Y rotation(euler)
    v_spd = input.getNumber(9) -- linear velocity y speed
    ra = input.getNumber(18) -- radio altimeter(parllel to airframe) | 18 because physics sensor comp indices range from 1-17
    launch = input.getBool(1) -- wired to launch button
    test = input.getBool(2) -- wired to test button

    stage = 1 -- flight stage(init guard)


    if test then
        stage = 0 --test state
        stagename = "TEST"
    elseif ra > 300 then
        stage = 3 --coast/apogee state
        stagename = "APOG"
    elseif (ra > 50 and v_spd < 0) or v_spd < -10 then
        stage = 4 --descent state
        stagename = "DESC"
        launched = false
    elseif ra >= 2 and ra <= 50 and v_spd < 0 then
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

    output.setNumber(1, PV_Xr)
    output.setNumber(2, PV_Zr)
    output.setNumber(7, PV_Yr)
    output.setNumber(3, v_spd)
    output.setNumber(4, ra)
    output.setNumber(5, stage)
    output.setNumber(6, z)
end

function onDraw() --debug info
    screen.setColor(0, 255, 255)
    screen.drawText(5, 5, "S" .. stage)
    screen.drawText(5, 15, stagename)
end
