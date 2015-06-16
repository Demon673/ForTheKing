local brain_OnAttackOthers = function( u_self, u_target, f_damage )
	AIManager:SendOrder( u_self, u_target, 1, "LastHit" )

	if (SkillManager:IsAble(brain.skills[1])) then
		SkillManager:SetCast( brain.skills[1] )
		brain.skills[1].fun( u_self )
	end
end

local brain_OnAttacked = function( u_self, u_attacker, f_damage )
end

local brain_OnTakenDamage = function( u_self, u_attacker, f_damage )
	u_self.brain.skills[2].fun( u_self, u_attacker)
end

local brain_OnHealthRegain = function( u_self, u_healer, f_number )
	u_self.brain.skills[2].fun( u_self, u_healer)
end
---------- Order System ----------

local brain_OnGetOrderConcentrate = function( u_self, u_sender, u_target, f_number )

	local v_sender_abs = u_sender:GetAbsOrigin()
	local v_target_abs = u_target:GetAbsOrigin()
	local v_rel = v_target_abs - v_sender_abs
	if (v_rel.Length() < 300) then	
		--send order
	end

	return f_number
end

local brain_OnGetOrderLastHit = function( u_self, u_sender, u_target, f_number )
	return f_number
end

---------- Criticle Strike Table ----------

local criticle = function( u_self, u_target )
	local f_random = RandomFloat( 0, 100 )
	if ( BuffManager:GetCount( u_self, "modifier_Q1_20_criticle" ) > 0 ) then
		f_chance = 105
	else
		f_chance = 20
	end
	if ( f_random < f_chance ) then

		local i_particle = ParticleManager:CreateParticle(
								"particles/base_attacks/ranged_badguy_explosion.vpcf",
							 	PATTACH_CUSTOMORIGIN_FOLLOW,
								u_target
							 )
		ParticleManager:SetParticleControlEnt(i_particle, 3, u_target, 5, "attach_hitloc", u_target:GetOrigin(), true)

		return 2
	else
		return 1
	end
end

---------- Skill Table ----------

local skill_01_cast = function( u_self )

	local particle_function = function( u_unit )
		local i_particle = ParticleManager:CreateParticle(
								"particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf",
							 	PATTACH_ROOTBONE_FOLLOW,
								u_unit
							 )
		ParticleManager:SetParticleControlEnt(i_particle, 3, u_unit, 5, "attach_hitloc", u_unit:GetOrigin(), true) -- CP3

		return i_particle
	end

	BuffManager:Add( u_self, "modifier_Q1_20_criticle", particle_function, true )


	GameRules:GetGameModeEntity():SetContextThink(
			DoUniqueString("modifier_Q1_20_criticle"),
			function( )
				BuffManager:Remove( u_self, "modifier_Q1_20_criticle" )
			end,	--End Think Function
			3.0
		)
end

local skill_02_passive = function( u_self )

	local particle_function = function( u_unit )
		local i_particle = ParticleManager:CreateParticle(
								"particles/zjz_units/q1_20_skill02.vpcf",
							 	PATTACH_CUSTOMORIGIN_FOLLOW,
								u_unit
							 )
		ParticleManager:SetParticleControlEnt(i_particle, 3, u_unit, 5, "attach_hitloc", u_unit:GetOrigin(), true) -- CP3

		return i_particle
	end

	local f_self_health = u_self:GetHealth()
	local f_self_health_max = u_self:GetMaxHealth()
	local f_health_percentage = u_self:GetHealth() / u_self:GetMaxHealth()
	local i_stack_count = math.floor((1 - f_health_percentage) * 20) + 1
	print("Calculated to set stack count to " .. tostring(i_stack_count))
	BuffManager:SetCount( u_self, "modifier_Q1_20_attack_speed", particle_function, i_stack_count )

end

---------- Initialize Function ----------

local brain_inititlize = function( u_unit )
	brain = AIManager:InitBrain( u_unit )

	brain.action_function["AttackOthers"] = brain_OnAttackOthers
	brain.action_function["Attacked"] = brain_OnAttacked
	brain.action_function["TakenDamage"] = brain_OnTakenDamage
	brain.action_function["HealthRegain"] = brain_OnHealthRegain

	brain.order_function["Heal"] = brain_OnGetOrderHeal
	brain.order_function["Concentrate"] = brain_OnGetOrderConcentrate
	brain.order_function["AttackBuff"] = brain_OnGetOrderAttackBuff
	brain.order_function["DefendBuff"] = brain_OnGetOrderDefendBuff
	brain.order_function["Stun"] = brain_OnGetOrderStun
	brain.order_function["Kill"] = brain_OnGetOrderKill
	brain.order_function["KillStart"] = brain_OnGetOrderKillStart
	brain.order_function["LastHit"] = brain_OnGetOrderLastHit

	brain.criticle_function[1] = criticle

	brain.skills[1] = SkillManager:AddSkill( "Criticle when low health", brain.skills, 0.0, 7.0, -1, skill_01_cast )
	brain.skills[2] = SkillManager:AddSkill( "AttackSpeed when low health", brain.skills, 0.0, 0.0, 0, skill_02_passive )

	AbilityManager:AddAndSet( u_unit, "listener_OnHealthRegain" )

end

return brain_inititlize