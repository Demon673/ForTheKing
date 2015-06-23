local brain_OnAttackOthers = function( u_self, u_target, f_damage )
	AIManager:SendOrder( u_self, u_target, 1, "LastHit" )
end

local brain_OnAttacked = function( u_self, u_attacker, f_damage )
	if (SkillManager:IsAble(u_self.brain.skills[1]) and (RandomInt(0, 99) < 30) and (u_self:GetHealth() / u_self:GetMaxHealth() < 0.35)) then
		SkillManager:SetCast(u_self.brain.skills[1])
		brain.skills[1].fun( u_self )
	end
end

local brain_OnTakenDamage = function( u_self, u_attacker, f_damage )
	if (SkillManager:IsAble(u_self.brain.skills[2]) and (u_self:GetHealth() / u_self:GetMaxHealth() < 0.35)) then
		SkillManager:SetCast(u_self.brain.skills[2])
		u_self.brain.skills[2].fun( u_self )
	end
	
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

local skill_01_cast = function( u_self )
	local t_group = FindUnitsInRadius(
					u_self:GetTeamNumber(), 
					u_self:GetOrigin(), 
					nil,			--无描述
					225, 
					DOTA_UNIT_TARGET_TEAM_ENEMY, 
					DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
					DOTA_UNIT_TARGET_FLAG_NONE, 
					FIND_ANY_ORDER, 			--无描述 tabel的顺序? 或许可以按距离决定之类的。
					false						--无描述
				)

	for i_key, u_select in pairs(t_group) do
		DamageManager:CustonDamage( u_self, u_select, "M", 100, false )
	end
	--对周围敌人造成100伤害
end

local skill_02_passive = function( u_self )

	local particle_function = function( u_unit )
		local i_particle = ParticleManager:CreateParticle(
								"particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf",
							 	PATTACH_ROOTBONE_FOLLOW,
								u_unit
							 )
		ParticleManager:SetParticleControlEnt(i_particle, 3, u_unit, 5, "attach_hitloc", u_unit:GetOrigin(), true) -- CP3

		return i_particle
	end

	BuffManager:Add( u_self, "modifier_Q1_21_active", particle_function, true )

	GameRules:GetGameModeEntity():SetContextThink(
			DoUniqueString("modifier_Q1_21_active"),
			function( )
				BuffManager:Remove( u_self, "modifier_Q1_21_active" )
			end,	--End Think Function
			3.0
		)

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

	brain.skills[1] = SkillManager:AddSkill( "Howl when low health", brain.skills, 0.0, 2.0, -1, skill_01_cast )
	brain.skills[2] = SkillManager:AddSkill( "Be strong when low health (active)", brain.skills, 0.0, 0.0, 1, skill_02_passive )

end

return brain_inititlize