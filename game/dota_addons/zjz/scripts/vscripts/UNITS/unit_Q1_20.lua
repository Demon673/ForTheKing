local brain_OnAttackOthers = function( u_self, u_target, f_damage )
	AIManager:SendOrder( u_self, u_target, 1, "LastHit" )
end

local brain_OnAttacked = function( u_self, u_attacker, f_damage )
end

local brain_OnTakenDamage = function( u_self, u_attacker, f_damage )
	u_self.brain.skill[2].fun( u_self, u_attacker)
end

local brain_OnHealthRegain = function( u_self, u_healer, f_number )
	u_self.brain.skill[2].fun( u_self, u_healer)
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
	if ( f_random < 20 ) then
		return 2
	else
		return 1
	end
end

---------- Skill Table ----------

local skill_01_cast = function( u_self, u_target )
	
end

local skill_02_passive = function( u_self, u_target )
	if (not (u_self:HasModifier("modifier_Q1_20_attack_speed"))) then
		AbilityManager:GetBuffRegister( u_self ):ApplyDataDrivenModifier( u_self, u_self, "modifier_Q1_20_attack_speed", nil )
	end

	local f_self_health = u_self:GetHealth()
	local f_self_health_max = u_self:GetMaxHealth()
	local f_health_percentage = u_self:GetHealth() / u_self:GetMaxHealth()
	local i_stack_count = math.floor((1 - f_health_percentage) * 20)
	u_self:SetModifierStackCount("modifier_Q1_20_attack_speed", u_self, i_stack_count)

end

---------- Initialize Function ----------

local brain_inititlize = function( u_unit )
	local brain = {}
	brain.unit = u_unit
	u_unit.brain = brain

	brain.action_function = {}
	brain.action_function["AttackOthers"] = brain_OnAttackOthers
	brain.action_function["Attacked"] = brain_OnAttacked
	brain.action_function["TakenDamage"] = brain_OnTakenDamage
	brain.action_function["HealthRegain"] = brain_OnHealthRegain
	brain.action_function.brain = brain

	brain.order_function = {}
	brain.order_function["Heal"] = brain_OnGetOrderHeal
	brain.order_function["Concentrate"] = brain_OnGetOrderConcentrate
	brain.order_function["AttackBuff"] = brain_OnGetOrderAttackBuff
	brain.order_function["DefendBuff"] = brain_OnGetOrderDefendBuff
	brain.order_function["Stun"] = brain_OnGetOrderStun
	brain.order_function["Kill"] = brain_OnGetOrderKill
	brain.order_function["KillStart"] = brain_OnGetOrderKillStart
	brain.order_function["LastHit"] = brain_OnGetOrderLastHit
	brain.order_function.brain = brain

	brain.criticle_function = {}
	brain.criticle_function[1] = criticle
	brain.criticle_function.brain = brain

	brain.skill = {}
	brain.skill[1] = AIManager:AddSkill( "Criticle when low health", brain.skill, 0.0, 7.0, skill_01_cast )
	brain.skill[2] = AIManager:AddSkill( "AttackSpeed when low health", brain.skill, 0.0, 0.0, skill_02_passive )
	brain.skill.brain = brain

	AbilityManager:AddAndSet( u_unit, "listener_OnHealthRegain" )

end

return brain_inititlize