--[[Demon制作]]
--生命达到临界值事件动作表
HealthChangeEventAction={
	jn_Q1_20		=function(keys)
						local caster = keys.caster
						local ab = keys.ability
						if ab:IsCooldownReady() then
							caster:CastAbilityImmediately(ab, caster:GetOwner():GetPlayerID())
						end
					end
	,
	jn_Q1_20_passive=function(keys)
						local caster = keys.caster
						local ab = keys.ability
						local count = math.floor((100-caster:GetHealthPercent())/10)
						if count > 0 then
							if not caster:HasModifier("modifier_jn_Q1_20_passive") then
								ab:ApplyDataDrivenModifier(caster, caster, "modifier_jn_Q1_20_passive",nil)
							end
							caster:SetModifierStackCount("modifier_jn_Q1_20_passive",ab,count)
						else
							caster:RemoveModifierByName("modifier_jn_Q1_20_passive")
						end
					end
	,
	jn_Q1_21b		=function(keys)
						local caster = keys.caster
						local ab = keys.ability
						if ab:IsCooldownReady() then
							caster:CastAbilityImmediately(ab, caster:GetOwner():GetPlayerID())
							ab:StartCooldown(99999)
						end
					end
	,
}
--一些函数
	--召唤单位动作
	function Spawn(keys)
		local caster = keys.caster
		local angle = caster:GetAnglesAsVector().y
		for i=1,keys.Count do
			local spawnunit = UnitManager:SummonUnit(caster:GetOwner(),keys.Name,caster:GetOrigin()+Vector(math.cos(math.rad(angle))*50,math.sin(math.rad(angle))*50,0))
		end
	end
	--生命到达临界值事件
	function HealthChangeEvent( keys )
		local caster = keys.caster
		local health
		if keys.IsPercent == 1 then
			health = caster:GetHealthPercent()
		end
		if keys.IsPercent == 2 then
			health = caster:GetHealth()
		end
		if health > keys.Value then
			if keys.Action1 ~= "" then
				HealthChangeEventAction[keys.Action1](keys)
			end
		else
			if keys.Action2 ~= "" then
				HealthChangeEventAction[keys.Action2](keys)
			end
		end
	end
--技能
function jn_Q1_21a(keys)
	local caster = keys.caster
	local ab = keys.ability
	local radius = ab:GetSpecialValueFor("radius")
	local chance = ab:GetSpecialValueFor("chance")
	local damage = ab:GetSpecialValueFor("damage")
	if ab:IsCooldownReady() then
		if RandomInt(0, 100) <= chance and caster:GetHealthPercent() <= 35 then
			local particleId = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_aftershock_egset.vpcf", PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(particleId, 0, caster:GetOrigin())
			ParticleManager:SetParticleControl(particleId, 1, Vector(radius,radius,radius))
			ParticleManager:ReleaseParticleIndex(particleId)
			local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, 0, true)
			for i,target in pairs(targets) do
				DamageManager:SpellDamage(caster,target,damage)
			end
			ab:StartCooldown(ab:GetCooldown(ab:GetLevel()))
		end
	end
end
function jn_Q2_10(keys)
	local caster = keys.caster
	local ab = keys.ability
	if ab:IsCooldownReady() then
		caster:CastAbilityImmediately(ab, caster:GetOwner():GetPlayerID())
		ab:StartCooldown(99999)
	end
end
function jn_Q2_20a(keys)
	local caster = keys.caster
	local ab = keys.ability
	if ab:IsCooldownReady() then
		caster:CastAbilityImmediately(ab, caster:GetOwner():GetPlayerID())
		ab:StartCooldown(99999)
	end
end
function jn_Q2_20b(keys)
	local caster = keys.caster
	local target = keys.target
	local ab = caster:FindAbilityByName("jn_Q2_20b")
	if target:GetUnitName() == keys.Name1 then
		ab:ApplyDataDrivenModifier(caster, target, "modifier_jn_Q2_20b_buff1", {})
	end
	if target:GetUnitName() == keys.Name2 then
		ab:ApplyDataDrivenModifier(caster, target, "modifier_jn_Q2_20b_buff2", {})
	end
	if target:GetUnitName() == keys.Name3 then
		ab:ApplyDataDrivenModifier(caster, target, "modifier_jn_Q2_20b_buff3", {})
	end
	if target:GetUnitName() == keys.Name4 then
		ab:ApplyDataDrivenModifier(caster, target, "modifier_jn_Q2_20b_buff4", {})
	end
	if target:GetUnitName() == keys.Name5 then
		ab:ApplyDataDrivenModifier(caster, target, "modifier_jn_Q2_20b_buff5", {})
	end
end
function jn_Q2_21b_1(keys)
	local caster = keys.caster
	local ab = keys.ability
	local perattackdamage = ab:GetSpecialValueFor("perattackdamage")
	local maxattackdamage = ab:GetSpecialValueFor("maxattackdamage")
	local count = math.min(caster:GetModifierStackCount("modifier_jn_Q2_21b",ab)+perattackdamage,maxattackdamage)
	caster:SetModifierStackCount("modifier_jn_Q2_21b",ab,count)
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, ab:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, 0, true)
	for i,target in pairs(targets) do
		if target:HasModifier("modifier_jn_Q2_21b_aura") then
			if not target:HasModifier("modifier_jn_Q2_21b_buff") then
				ab:ApplyDataDrivenModifier(caster,target, "modifier_jn_Q2_21b_buff",{})
			end
			target:SetModifierStackCount("modifier_jn_Q2_21b_buff",ab,count)
		end
	end
end
function jn_Q2_21b_2(keys)
	local caster = keys.caster
	local target = keys.target
	local ab = caster:FindAbilityByName("jn_Q2_21b")
	local count = caster:GetModifierStackCount("modifier_jn_Q2_21b",ab)
	if count > 0 then
		if not target:HasModifier("modifier_jn_Q2_21b_buff") then
			ab:ApplyDataDrivenModifier(caster,target, "modifier_jn_Q2_21b_buff",{})
		end
		target:SetModifierStackCount("modifier_jn_Q2_21b_buff",ab,count)
	end
end
---------------
function jn_D2_00( keys )
	local caster = keys.caster
	local group = keys.target_entities

	for i=1,keys.Count do
		local damageTable = {
			victim = table.remove(group,1),
			attacker = caster,
			damage = keys.Damage,
			damage_type = DAMAGE_TYPE_PURE,
		}
		ApplyDamage(damageTable)
	end
end


function jn_D2_10b( keys )
	local caster = keys.caster

	if caster:GetHealthPercent()<keys.HealPercent then
		keys.ability:ApplyDataDrivenModifier(caster,caster,"modifier_jn_D2_10b_effect",nil)
		caster:RemoveModifierByName("modifier_jn_D2_10b")
	end
end

--闪电链
function ShanDian( caster,old,new,ability,radius,count,count_const,_group )

	if count>count_const then
		return nil
	end
	
	if IsValidEntity(old) and IsValidEntity(new) then
		if old:IsAlive() and new:IsAlive() then
			local p = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf",PATTACH_CUSTOMORIGIN,old)
			ParticleManager:SetParticleControlEnt(p,0,old,5,"attach_hitloc",old:GetOrigin(),true)
			ParticleManager:SetParticleControlEnt(p,1,new,5,"attach_hitloc",new:GetOrigin(),true)

			ability:ApplyDataDrivenModifier(caster,new,"modifier_HuXingShanDian_effect",nil)

			table.insert(_group,new)

			GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("ShanDian"),function()
				local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
			    local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
			    local flags = DOTA_UNIT_TARGET_FLAG_NONE
				local group = FindUnitsInRadius(caster:GetTeamNumber(),new:GetOrigin(),nil,radius,teams,types,flags,FIND_CLOSEST,true)

				local unit  = nil
				local alive = true
				repeat
					if #group<=0 then break end

					unit = table.remove(group,1)

					if IsValidEntity(unit) then
						if unit:IsAlive() then
							alive = true
						else
							alive = false
						end
					else
						alive = false
					end

					for k,v in pairs(_group) do
						if unit == v then
							alive = false
							break
						end
					end

				until(alive)

				ShanDian( caster,new,unit,ability,radius,count+1,count_const,_group )

				return nil
			end,0.2)
		end
	end

end

function jn_D3_00( keys )
	local caster = keys.caster
	local target = keys.target

	keys.ability.AttackCount = (keys.ability.AttackCount or 0) + 1

	if keys.ability.AttackCount>=keys.AttackCount then
		keys.ability.AttackCount = 0
		ShanDian( caster,caster,target,keys.ability,keys.Radius,1,keys.Count,{} )
	end
end
