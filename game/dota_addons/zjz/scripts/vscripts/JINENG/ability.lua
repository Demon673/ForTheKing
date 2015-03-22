--[[function AbilityCreateEffect( keys )
        local caster = keys.caster
 
        --创建特效
        local particleID = ParticleManager:CreateParticle(keys.effect_name, PATTACH_ABSORIGIN_FOLLOW,caster)
 
        --我们将施法者的所在的三维坐标传给了CP0
        ParticleManager:SetParticleControl(particleID,0,caster:GetOrigin())
    end
    --]]