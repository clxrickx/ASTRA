function onTick()
    ra = input.getNumber(1) -- radio altimeter(parllel to airframe)
    x = input.getNumber(2) -- x position(cartesian)
    y = input.getNumber(3) -- y position(cartesian)
    azi = input.getNumber(4) -- azimuth
    lin_spd = input.getNumber(5) -- linear speed

    stage = 0 -- flight stage(init guard)

    if ra < 1 then
        stage = 0 --ground state
    elseif ra >= 1 and lin_spd > 5 then
        stage = 1 --ascend state
    elseif ra > 50 and lin_spd < -5 then
        stage = 2 --descend state
    elseif ra >= 1 and ra <= 50 and lin_spd >= -5 and lin_spd < 0 then
        stage = 3 --approach state
    end

    output.setNumber(1, ra)
    output.setNumber(2, x)
    output.setNumber(3, y)
    output.setNumber(4, azi)
    output.setNumber(5, lin_spd)
    output.setNumber(6, stage)
end
