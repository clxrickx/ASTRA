function onTick()
    input.getNumber(1) -- radio altimeter(parllel to airframe)
    input.getNumber(2) -- x position(cartesian)
    input.getNumber(3) -- y position(cartesian)
    input.getNumber(4) -- azimuth
    input.getNumber(5) -- linear speed

    tvc_x = 0
    tvc_y = 0
    if stage == 0 then --if ground state, then tvcs neutral
        tvc_x = 0
        tvc_y = 0
    elseif stage == 1 then
        
    end
end
