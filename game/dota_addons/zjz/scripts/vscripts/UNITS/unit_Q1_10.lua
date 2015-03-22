local brain_OnAttackOthers = function( u_self, u_target, f_damage )
	AIManager:SendOrder( u_self, u_target, 1, "LastHit" )
end

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

local criticle = function( u_self, u_target )
	local f_random = RandomFloat( 0, 100 )
	if ( f_random < 20 ) then

		--[[
		print("Critical Strike !!")
		local ptc_effect = ParticleManager:CreateParticle(
				"particles/units/heroes/hero_rubick/rubick_base_attack_launch.vpcf",
				PATTACH_ABSORIGIN,
				u_target
			)
		ParticleManager:SetParticleControlEnt(ptc_effect, 0, u_target, 5, "attach_hitloc", u_target:GetOrigin(), true)
		]]--

		return 2
	else
		return 1
	end
end

local brain_inititlize = function( u_unit )
	local brain = {}
	brain.unit = u_unit
	u_unit.brain = brain

	brain.action_function = {}
	brain.action_function["AttackOthers"] = brain_OnAttackOthers
	brain.action_function.brain = brain

	brain.order_function = {}
	brain.order_function["Concentrate"] = brain_OnGetOrderConcentrate
	brain.order_function.brain = brain

	brain.criticle_function = {}
	brain.criticle_function[1] = criticle
	brain.criticle_function.brain = brain

	brain.skill = {}
	brain.skill.brain = brain

end

return brain_inititlize