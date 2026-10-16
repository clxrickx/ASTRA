function onTick()
    SP_Xr = input.getNumber(1)
    SP_Yr = input.getNumber(2)
    SP_Zr = input.getNumber(3)
    v_spd = input.getNumber(4)
    ra = input.getNumber(5)
    stage = input.getNumber(6)

    tvc_x = 0 --init guards
    tvc_y = 0

    if stage == 0 then --if ground state, then tvcs neutral
        tvc_x = 0
        tvc_y = 0
    
    else -- else, tvcs are actively targetting setpoints
        

    end
end
