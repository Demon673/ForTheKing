--停止播放音效

function StopSound( keys )
	StopSoundEvent(keys.EffectName,keys.caster)
end

--显示暴击数字
function CriticalStrikeMsg( npc, num, color )

	local colorNum = #color
	if colorNum ~= 3 then
		color = {255,255,255}
	end

	local particleName = "particles/msg_fx/msg_crit.vpcf"
	local p = ParticleManager:CreateParticle(particleName,PATTACH_CUSTOMORIGIN_FOLLOW,npc)
	ParticleManager:SetParticleControl(p,0,npc:GetOrigin())
	ParticleManager:SetParticleControl(p,1,Vector(10,num,4))
	ParticleManager:SetParticleControl(p,2,Vector(1,(#tostring(num))+1,0))
	ParticleManager:SetParticleControl(p,3,Vector(color[1],color[2],color[3]))
end

--设置是否产生暴击
function SetCriticalStrike( keys )
	local caster = keys.caster

	local isCriticalStrike = keys.IsCriticalStrike or false

	if isCriticalStrike == "true" then
		caster.IsCriticalStrike=true
		caster.CriticalStrikeNum = keys.CriticalStrikeNum or 1
	else
		caster.IsCriticalStrike  = false
		caster.CriticalStrikeNum = 1
	end
end

--获取技能绿字攻击力
	function GetModifierAttackByHero(hero)
	    local Ability
	    local attack = 0
	    local bonusAttack = 0
	    local x = hero:GetAverageTrueAttackDamage()
	    for i=0,10 do
	        Ability = hero:GetAbilityByIndex(i)

	        --print("x is " ..x)
	        hero:SetModifierStackCount()
	        --Modifier =  hero:GetModifierStackCount(Modifier_Name)
	        if(Ability ~= nil) then
	            bonusAttack = Ability:GetModifierValue() or 0
	            
	            --attack_pct = bonusAttack_pct * x / 100
	            if(bonusAttack~=nil)then
	                print("bonusAttack:"..tostring(bonusAttack))
	                --attack = bonusAttack + attack + attack_pct
	                print("attack:"..tostring(attack))
	            end
	        end
	    end
	    return attack
	end



--自定义攻防
function AandDsystem( keys )
	
		local caster = keys.caster --攻击者
		local target = keys.target --目标

		if target:HasAbility("AandD") then
								
			local a_name = caster:GetUnitName()  --攻击者名字
			local a_type = string.sub(a_name, -2, -2) --攻击类型
			local base_damage = keys.DamageTaken
			local TargetHealth = target:GetHealth() 
			if TargetHealth > 3 then
				target:SetHealth(target:GetHealth() + base_damage)
			end
					
			CustonDamage( caster, target, a_type, base_damage, true )

			--防止王发呆 H：
			if target:HasAbility("spilt_right") or target:HasAbility("spilt_left")  then

				if target:IsAttacking()==false then
					--target:SetForceAttackTarget(caster)

					local newOrder = {
					 		UnitIndex = target:entindex(), 
					 		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
					 		TargetIndex = caster:entindex(), --Optional.  Only used when targeting units
					 		AbilityIndex = 0, --Optional.  Only used when casting abilities
					 		Position = nil, --Optional.  Only used when targeting the ground
					 		Queue = 0 --Optional.  Used for queueing up abilities
	 								}
	 
					ExecuteOrderFromTable(newOrder)
				end
			end

		else
			print( "mubiao meiyou AandD")
		end
end

--[[
function ApplyArmor( base_damage, target )

	local armor = math.floor(target:GetPhysicalArmorValue()) --获取护甲值
	local reduce_damage = armor * 0.06 / ( 1 + 0.06 * armor ) --护甲减损比
	return ( base_damage ) * ( 1 - reduce_damage )  --基础伤害值

end
]]--

function CustonDamage( caster, target, a_type, base_damage, isattack )

	local d_name = target:GetUnitName()
	local d_type = string.sub(d_name, -1, -1)

	local ADnumber = AandD_table[a_type..d_type] --or 100 --获取伤害比例数字
	
	local pure_damage =	base_damage * ADnumber / 100

	--暴击系统
	if (isattack == true) then
		if (AIManager:HasBrain(caster)) then
			--print("Start to apply critical function.")
			--DeepPrintTable(caster.brain.criticle_function)
			local f_number = 1

			for k,fun in pairs(caster.brain.criticle_function) do
				if (fun ~= caster.brain.criticle_function.brain) then
					f_number = f_number * fun( caster, target )
				end
			end
			
			if ( f_number > 1) then
				--print("Critical Strike: x" .. tostring(f_number))
				pure_damage = pure_damage * f_number
				PopupCriticalDamage( target, math.floor(pure_damage))
			end
			if ( f_number < 1) then
				pure_damage = pure_damage * f_number
			end
		end

		AIManager:SendAction( caster, target, pure_damage, "AttackOthers" )
		AIManager:SendAction( target, caster, pure_damage, "Attacked" )

	end

	AIManager:SendAction( target, caster, pure_damage, "TakenDamage" )

	local damageTable = 
						{
							victim = target,
							attacker = caster,
							damage = pure_damage,
							damage_type = DAMAGE_TYPE_PURE,
						}
	ApplyDamage(damageTable)
	--print(tostring(base_damage) .. " has change to " .. tostring(pure_damage))

	

end

--多重箭
function DuoChongGongJiDamage( keys )

	local caster = keys.caster --攻击者
	local target = keys.target --目标

	if target:HasAbility("AandD") then
							
		local a_name = caster:GetUnitName()  --攻击者名字
		local d_name = target:GetUnitName()  --被攻击者名字

		local a_type = string.sub(a_name, -2, -2) --攻击类型
		local d_type = string.sub(d_name, -1, -1)  --防御类型
				
		--local AandD_table = rawget(_G, 'AandD_table')
		local ADnumber = AandD_table[a_type..d_type] --or 100 --获取伤害比例数字

		local Max = caster:GetBaseDamageMax() 
		local Min = caster:GetBaseDamageMin()
		local chazhi = (Max - Min)/2
		local bodong = RandomInt(-chazhi, chazhi)
			--print("bodong is "..bodong) 
		local attack = caster:GetAverageTrueAttackDamage() + bodong
			--print("attack is "..attack)
		local armor = math.floor(target:GetPhysicalArmorValue()) --获取护甲值
		local reduce_damage = armor * 0.06 / ( 1 + 0.06 * armor ) --护甲减损比
		local base_damage = (attack  ) * (1 - reduce_damage)  --基础伤害值							
		local pure_damage = base_damage * ADnumber / 100 --计算攻防相克后的最终伤害值
					local damageTable = 
										{
											victim = target,
											attacker = caster,
											damage = pure_damage,
											damage_type = DAMAGE_TYPE_PURE,
										}
									 
					ApplyDamage(damageTable)
					print(pure_damage)

	else
		print( "mubiao meiyou AandD")
	end

end






--多重攻击
function DuoChongGongJi( keys )

	local caster = keys.caster
	local target = keys.target
--只对远程有效
	if caster:IsRangedAttacker() then
		--获取攻击范围
		local radius = caster:GetAttackRange() +100
		local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
		local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_MECHANICAL+DOTA_UNIT_TARGET_BUILDING
		local flags = DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
		--获取周围的单位
		local group = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetOrigin(),nil,radius,teams,types,flags,FIND_CLOSEST,true)
		--获取箭的数量
		local attack_count = keys.attack_count or 0
		--获取箭的特效
		local attack_effect = keys.attack_effect or "particles/econ/items/keeper_of_the_light/kotl_weapon_arcane_staff/keeper_base_attack_arcane_staff.vpcf"
		local attack_unit = {}

	--筛选离英雄最近的敌人
		for i,unit in pairs(group) do
			if (#attack_unit)==attack_count then
				break
			end

			if unit~=target then
				if unit:IsAlive() then
					table.insert(attack_unit,unit)
				end
			end
		end

		for i,unit in pairs(attack_unit) do
			local info =
						{
							Target = unit,
							Source = caster,
							Ability = keys.ability,
							EffectName = attack_effect,
							bDodgeable = false,
							iMoveSpeed = 1800,
							bProvidesVision = false,
							iVisionRadius = 0,
							iVisionTeamNumber = caster:GetTeamNumber(),
							iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
						}
			projectile = ProjectileManager:CreateTrackingProjectile(info)

		end
	end
end


--[[ 给多重攻击伤害
	function DuoChongGongJiDamage( keys )
	local caster = keys.caster
	local target = keys.target
	--获取攻击伤害
	local attack_damage_lose = keys.attack_damage_lose or 0
	local attack_damage = caster:GetAttackDamage() * ((100-attack_damage_lose)/100)
	local damageTable = {victim=target,
	attacker=caster,
	damage_type=DAMAGE_TYPE_PHYSICAL,
	damage=attack_damage}
	ApplyDamage(damageTable)
end]]

	--[[
function baoji() 

	local isCriticalStrike = caster.IsCriticalStrike or false

	if isCriticalStrike then

		--产生暴击
		local critical_strike_num = caster.CriticalStrikeNum or 1
		local attack_damage = caster:GetAttackDamage() * critical_strike_num
		target:SetHealth(target:GetHealth() + attack_damage)
		CriticalStrikeMsg(caster, attack_damage, {0,255,0} )

	else

		--不产生暴击
		local attack_damage = caster:GetAttackDamage()
		target:SetHealth(target:GetHealth() + attack_damage)

	end]]




	
		--local attack = caster:GetAttackDamage() --获取随机攻击力
		--local modifier_attack = GetModifierAttackByHero(caster) 	--绿字
		--local item_attack = GetItemAttackByHero(caster)				--绿字
		--local attack = caster:GetAverageTrueAttackDamage() + modifier_attack + item_attack



--[[获取物品绿字攻击力
	function GetItemAttackByHero(hero)
	    local item
	    local attack = 0
	    local bonusAttack = 0
	    for i=0,5 do
	        item = hero:GetItemInSlot(i)
	        if(item~=nil)then
	            bonusAttack = item:GetSpecialValueFor("bonus_damage")  + item:GetSpecialValueFor("%bonus_damage_pct")*hero:GetAverageTrueAttackDamage()/100
	            if(bonusAttack~=nil)then
	                print("bonusAttack:"..tostring(bonusAttack))
	                attack = bonusAttack + attack
	                print("attack:"..tostring(attack))
	            end
	        end
	    end
	    return attack
	end]]

