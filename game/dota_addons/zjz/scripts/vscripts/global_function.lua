if BTFGeneral == nil then
    BTFGeneral = class({})
end

-----------------------------
------自定义错误信息---------
-----------------------------
function BTFGeneral:ShowError(msg, playerid)
    FireGameEvent('custom_error_show', {player_ID = playerid, _error = msg})
end


function BTFGeneral:ToTopBarUI(playerid,IncomeNum,Farmer,TechNum,Score,Arms)

         FireGameEvent('UpdateTopBar', {PID = playerid ,income=IncomeNum, FarmerNum= Farmer,Tech=TechNum,troops= Score,arms=Arms})

end

if PlayerCalc == nil then
    PlayerCalc = class({})
end

function PlayerCalc:GetPlayerByIndex(i_player_index)
    return PlayerInstanceFromIndex(i_player_index)
end

function PlayerCalc:GetPlayerByPosition(i_player_position)
    return PlayerResource:GetPlayer(i_player_position)
end

function PlayerCalc:GetPlayerIndex(p_player)
    i_player_pos = self:GetPlayerPosition(p_player)
    if (PlayerS[i_player_pos].Index == nil) then		--检测是否已经记录
        for k, i_player_index in pairs({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}) do
            if (self:GetPlayerByIndex(i_player_index) == p_player) then
                PlayerS[i_player_pos].Index = i_player_index
                print("This is the first time to find counting number for player " .. tostring(i_player_pos))
                print("The counting number for player " .. tostring(i_player_pos) .. " is " .. tostring(i_player_index))
                return i_player_index
            end
        end
    end
    return PlayerS[i_player_pos].Index
end

function PlayerCalc:GetPlayerPosition(p_player)
    return p_player:GetPlayerID()
end

if AbilityManager == nil then
    AbilityManager = {}
end

function AbilityManager:AddAndSet( u_unit, s_ability_name )
    u_unit:AddAbility(s_ability_name)
    a_ability = u_unit:FindAbilityByName(s_ability_name)
    a_ability:SetLevel(1)
    return a_ability
end

function AbilityManager:GetBuffRegister( u_unit )
    local a_ability = u_unit:FindAbilityByName("buff_register")
    if (a_ability == nil) then
        a_ability = AbilityManager:AddAndSet( u_unit, "buff_register" )
    end
    return a_ability
end

if UnitManager == nil then
    UnitManager = {}
end

function UnitManager:GetTypeFromName( s_unit_name )
    return string.sub( s_unit_name , -8, -4)
end

function UnitManager:GetAttackTypeFromName( s_unit_name )
    return string.sub( s_unit_name , -2, -2)
end

function UnitManager:GetDefendTypeFromName( s_unit_name )
    return string.sub( s_unit_name , -1, -1)
end

function UnitManager:CreateUnitByBuilding( u_building )
    --local s_building_name = u_building:GetUnitName() 
    
    --local s_unit_name = "npc_unit_" .. string.sub(s_building_name, 11, -1) 
    local s_unit_name = u_building:GetUnitName() 
    local s_unit_type = string.sub(s_unit_name, -8, -4)
    local v_unit_point = u_building:GetAbsOrigin() 
    local i_teamnumber = u_building:GetTeamNumber() 
    local p_owner = u_building:GetOwner()
    local i_playerID = PlayerCalc:GetPlayerPosition( p_owner )

    local u_unit = CreateUnitByName( s_unit_name, v_unit_point, true, p_owner, p_owner, i_teamnumber)
    local attack_type_name = UnitManager:GetAttackTypeFromName( s_unit_name )
    local defend_type_name = UnitManager:GetDefendTypeFromName( s_unit_name )
    AbilityManager:AddAndSet( u_unit, "A" .. attack_type_name )
    AbilityManager:AddAndSet( u_unit, "D" .. defend_type_name )
    u_unit.Player = p_owner 
    u_unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
    table.insert(u_unit, PlayerS[i_playerID].Unit )
    local v_order = nil

    if i_playerID <= 3 then
        v_order = Vector( 8200, 0, 0 )
    else
        v_order = Vector( -8200, 0, 0 )
    end

    local t_order = 
        {                                        --发送攻击指令
            UnitIndex = u_unit:entindex(), 
            OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
            TargetIndex = nil, 
            AbilityIndex = 0, 
            Position = v_unit_point + v_order, 
            Queue = 0 
        }
    u_unit:SetContextThink(DoUniqueString("order_later"), function() ExecuteOrderFromTable(t_order) end, 0.1)

    AbilityManager:AddAndSet( u_unit, "buff_register" )

    local s_file_name = "UNITS/unit_" .. s_unit_type
    local init_function = nil

    if (AIManager.AItable[s_unit_type] == true) then
        AIManager:AddBrain( u_unit, s_file_name )
    else
        AIManager:AddBrain( u_unit, "UNITS/default" )
    end

    return u_unit
end

if AIManager == nil then
    AIManager = {}
    AIManager.f_ORDER_RANGE = 800
    AIManager.AItable = {}
    AIManager.AItable["Q1_00"] = true
    AIManager.AItable["Q1_10"] = true
    AIManager.AItable["Q1_20"] = true
end

function AIManager:AddBrain( u_unit, s_file_name )
    if (AIManager:HasBrain( u_unit ) == false) then
        init_function = require(s_file_name)
        init_function(u_unit)
        return true
    else
        return false
    end
end

function AIManager:InitBrain( u_unit )

    if AIManager:HasBrain( u_unit ) then
        brain = u_unit.brain
    else
        u_unit.brain = {}
        brain = u_unit.brain
    end

    brain.unit = u_unit

    if (brain.action_function == nil) then
        brain.action_function = {}
        brain.action_function.brain = brain
    end
    if (brain.order_function == nil) then
        brain.order_function = {}
        brain.order_function.brain = brain
    end
    if (brain.criticle_function == nil) then
        brain.criticle_function = {}
        brain.criticle_function.brain = brain
    end
    if (brain.skills == nil) then
        brain.skills = {}
        brain.skills.brain = brain
    end
    if (brain.buffs == nil) then
        brain.buffs = {}
        brain.buffs.brain = brain
    end
    if (brain.auras == nil) then
        brain.auras = {}
        brain.auras.brain = brain
    end

    return brain
end

function AIManager:HasBrain( u_unit )
    if (u_unit.brain == nil) then
        return false
    else
        return true
    end
end

function AIManager:HasAction( u_unit, s_action )
    if (AIManager:HasBrain( u_unit ) == false) then
        return false
    end

    local brain = u_unit.brain

    if (brain.action_function == nil) then
        return false
    end

    if (brain.action_function[s_action] == nil) then
        return false
    end

    return true
end

function AIManager:SendAction( u_self, u_others, f_number, s_action )
    if (AIManager:HasAction( u_self, s_action )) then
        u_self.brain.action_function[s_action]( u_self, u_others, f_number )
    end
end

function AIManager:HasOrder( u_unit, s_order )
    if (AIManager:HasBrain( u_unit ) == false) then
        return false
    end

    local brain = u_unit.brain

    if (brain.order_function == nil) then
        return false
    end

    if (brain.order_function[s_order] == nil) then
        return false
    end

    return true
end

function AIManager:SendOrder( u_sender, u_target, f_number, s_order )
    local p_player = u_sender:GetOwner()
    local i_playerID = PlayerCalc:GetPlayerPosition( p_player )
    --print("While sending order " .. s_order .. ", the player ID is " .. tostring(i_playerID))
    local t_units = PlayerS[i_playerID].Unit
    local i_index = 1
    local i_length = table.getn( t_units )

    while (f_number > 0) and ( i_index <= i_length ) do
        local u_getter = t_units[i_index]
        if AIManager:HasOrder( u_getter, s_order ) then
            f_number = u_getter.brain.order_function[s_order]( u_getter, u_sender, u_target, f_number )
        end
        i_index = i_index + 1
    end
end

function AIManager:AddSkill( s_name, t_skill_table, f_mana_cost, f_cool_down, fun )
    local t_skill = {}
    t_skill.name = s_name
    t_skill.cooldown = f_cool_down
    t_skill.manacost = f_mana_cost
    t_skill.lasttime = 0.0
    t_skill.fun = fun
    t_skill.table = t_skill_table

    return t_skill
end

function AIManager:IsSkillAble( t_skill )

    if (t_skill.cooldown < 0.0) and (t_skill.lasttime > 0.0) then -- 检查技能是否只能用一次
        print("AIManager:IsSkillAble -- [once]!")
        return false
    end

    local f_time = GameRules:GetDOTATime(false, false)
    if (t_skill.cooldown > f_time - t_skill.lasttime) then -- 检查冷却时间
        print("AIManager:IsSkillAble -- [cooldown]")
        return false
    end

    local u_unit = t_skill.table.brain.unit
    local f_mana = u_unit:GetMana()

    if (t_skill.manacost > f_mana) then -- 检查魔法消耗
        print("AIManager:IsSkillAble -- [manacost]")
        return false
    end

    print("AIManager:IsSkillAble -- [YEEEEES]")
    return true

end

if ModifierManager == nil then
    ModifierManager = {}
end

function BuffManager:AddBuff( u_unit, s_modifier, particle_function, b_stick ) -- particle_function 要return粒子特效的ID

    if (AIManager:HasBrain( u_unit ) == false) then
        return false
    end

    brain = u_unit.brain

    if (brain.buffs == nil) then
        return false
    end

    if (brain.buffs[s_modifier] == nil) then
        t_buff_type = {}
        t_buff_type.buffs = brain.buffs
        brain.buffs[s_modifier] = t_buff_type
    else
        t_buff_type == brain.buffs[s_modifier]
    end

    if (#t_buff_type == 0) then
        AbilityManager:GetBuffRegister( u_self ):ApplyDataDrivenModifier( u_self, u_self, s_modifier, nil )
        t_buff = {}
        table.insert(t_buff_type, t_buff)
        t_buff.particle = particle_function(u_unit)

        return t_buff
    else
        if (b_stick) then
            t_buff = {}
            table.insert(t_buff_type, t_buff)
            t_buff.particle = particle_function(u_unit)
            i_stack_count = #t_buff_type
            u_self:SetModifierStackCount(s_modifier, u_self, i_stack_count)

            return t_buff
        else
            return false
        end
    end

end

function BuffManager:RemoveBuff( u_unit, s_modifier )

    if (AIManager:HasBrain( u_unit ) == false) then
        return false
    end

    brain = u_unit.brain

    if (brain.buffs == nil) then
        return false
    end

    if (brain.buffs[s_modifier] == nil) then
        return false
    end

    i_length = #brain.buffs[s_modifier]

    if (i_length == 0) then
        return false
    end

    t_buff = brain.buffs[s_modifier][i_length]
    ParticleManager:DestroyParticle(t_buff.particle , true)
    table.remove(brain.buffs[s_modifier], i_length)

    return true

end

function BuffManager:SetBuffCount( u_unit, s_modifier, particle_function, i_stack_count )

    if (AIManager:HasBrain( u_unit ) == false) then
        return false
    end

    brain = u_unit.brain

    if (brain.buffs == nil) then
        return false
    end

    if (brain.buffs[s_modifier] == nil) then
        return false
    end

    while (#brain.buffs[s_modifier] > i_stack_count) do
        BuffManager:RemoveBuff( u_unit, s_modifier )
    end

    while (#brain.buffs[s_modifier] < i_stack_count) do
        BuffManager:AddBuff( u_unit, s_modifier, particle_function, true )
    end

    return true

end

function listener_OnHealthRegain(keys)
    AIManager:SendAction( keys.caster, keys.caster, 0, "HealthRegain" )
end