local brain_OnAttackOthers = function( u_self, u_target, f_damage )
	AIManager:SendOrder( u_self, u_target, 1, "LastHit" )

	if (SkillManager:IsAble(brain.skills[1])) then
		SkillManager:SetCast( brain.skills[1] )
		brain.skills[1].fun( u_self )
	end
end

local brain_OnAttacked = function( u_self, u_attacker, f_damage )
	if ((u_self:GetHealth() / u_self:GetMaxHealth() < 0.5) and (RandomInt(0, 99) < 35)) then
		u_self:SetHealth(u_self:GetHealth() + f_damage)
	end
end

local brain_OnTakenDamage = function( u_self, u_attacker, f_damage )
	u_self.brain.skills[1].fun( u_self )
end

local brain_OnHealthRegain = function( u_self, u_healer, f_number )
	u_self.brain.skills[1].fun( u_self )
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

---------- Skill Table ----------

local skill_01_passive = function( u_self )

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

	if ((f_health_percentage >= 0.5) and (BuffManager:GetCount( u_self, "modifier_Q4_20_attack_speed" ) == 0)) then
		BuffManager:Add( u_self, "modifier_Q4_20_attack_speed", particle_function, false )
	end

	if ((f_health_percentage < 0.5) and (BuffManager:GetCount( u_self, "modifier_Q4_20_attack_speed" ) == 1)) then
		BuffManager:Remove( u_self, "modifier_Q4_20_attack_speed" )
	end

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

	brain.skills[1] = SkillManager:AddSkill( "AttackSpeed when high health", brain.skills, 0.0, 0.0, 0, skill_01_passive )
	skill_01_passive( u_unit )

	AbilityManager:AddAndSet( u_unit, "listener_OnHealthRegain" )

end

return brain_inititlize