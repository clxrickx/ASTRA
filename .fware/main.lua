launched = false
prev_launch = false

function wrap(a)
    return (a + math.pi) % (2 * math.pi) - math.pi
end

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
    elseif ra < 2 and not launched then -- 0.75 = 3 units
        stage = 1 --ground state
        stagename = "GRND"
        launched = false
    else
        stage = 2
        stagename = "LNCH"
    end

    prev_launch = launch

    pvx = SP_Xr + wrap(PV_Xr - SP_Xr)
    pvy = SP_Yr + wrap(PV_Yr - SP_Yr)

    output.setNumber(1, pvx)
    output.setNumber(2, pvy)
    output.setNumber(3, v_spd)
    output.setNumber(4, ra)
    output.setNumber(5, stage)
    output.setNumber(6, y)
end

function onDraw() --debug info
    screen.setColor(0, 255, 255)
    screen.drawText(5, 5, "S" .. stage)
    screen.drawText(5, 15, stagename)
end
