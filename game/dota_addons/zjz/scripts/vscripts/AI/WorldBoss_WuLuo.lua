require( "StateMachine_AI" )


local FSM={}

local thinkInterval=1.0

local state_01={STATE=STATE_NORMAL}
local state_02={STATE=STATE_ANGRY}
local StateVectory={state_01,state_02}
function Spawn( entityKeyValues )

	FSM=FSMManager:CreateFSM(thisEntity,state_01,StateVectory)
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )


end

function AIThink()

	FSM:OnThink()

	return thinkInterval
end

WuLuo_move_table = nil
function state_01:think()
	--print("Wl_AI----->state_normal_think")
	
	if FSMManager:RandomEnemyHeroInRange(FSM._entity,1000) ~=nil then 
	--	print("wL_AI----->enter__RandomEnemyHeroInRange")
		local enemy=FSMManager:RandomEnemyHeroInRange(FSM._entity,1000)
		local ab_0=FSM._entity:GetAbilityByIndex(0)
		if ab_0:IsCooldownReady() then
			FSM._entity:SetContextThink(DoUniqueString("cast_ability1"),
			function()
				FSM._entity:CastAbilityNoTarget(FSM._entity:GetAbilityByIndex(0),3)
			end,0)
		
		end
		local ab_1 = FSM._entity:GetAbilityByIndex(1)
		if ab_1:IsCooldownReady() then
			FSM._entity:SetContextThink(DoUniqueString("cast_ability2"),
			function()
				FSM._entity:CastAbilityOnPosition(enemy:GetOrigin(), ab_1, 0)
			end,0)
		end
	else
			FSM:GoToSpawner("fb_spawner_10_01")

	end


	

end

function state_02:think()
	print("AI----->state_angry_think")
end