function Ability_holylight_Created(keys) 

    for i,v in pairs(keys) do
        print(tostring(i).."="..tostring(v))
    end

    keys.caster:SetModifierStackCount('modifier_never_dead',keys.ability,4)

end

function Ability_holylight(keys)
	for i,v in pairs(keys) do
        print(tostring(i).."="..tostring(v))
    end
    local health = keys.caster:GetHealth()
    print(health)
    local life = keys.caster:GetModifierStackCount('modifier_never_dead',keys.ability)
    if health < 5 then
    	life = life - 1 
    	if life < 0 then
    		keys.caster:RemoveModifierByName('modifier_never_dead')
    	else
    		keys.caster:SetHealth(keys.caster:GetMaxHealth())
    		keys.caster:SetModifierStackCount('modifier_never_dead',keys.ability,life)
		end

	end
end
