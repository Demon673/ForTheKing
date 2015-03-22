--[[
有限状态机：
STATE_NORMAL    --初始状态
STATE_ANGRY		--当受到攻击时变得愤怒
STATE_RAGE		--当血量到达一定值时，变得暴躁
STATE_OFFENSIVE	--具有侵略性，发现敌人就对其进行攻击
STATE_SCARD     --害怕
]]
STATE_NORMAL=0
STATE_ANGRY=1
STATE_RAGE=2
STATE_OFFENSIVE=3
STATE_SCARD=4

FSMManager={}    

function FSMManager:CreateFSM(entity,default,vectory)

	local FSM={}

	FSM._curState=default
	FSM._vectory=vectory
	FSM._entity=entity
	--


	function FSM:FindStateInVec(STATE)
		for k,v in pairs(FSM._vectory) do
			--print("MACHINE FSM=",FSM)
			--print("print k,v")
			--print(STATE)
			--print(k,v.STATE)
			if v.STATE==STATE  then return v end

		end

		return nil
	end

	function FSM:ChangeState(STATE)
	
		local state=FSM:FindStateInVec(STATE)

		if state~=nil then
			if state==FSM._curState then
				 return -1
			end

			FSM._curState=state
		
		end


	end

	function FSM:GoToFort()

		
		local jidi =Entities:FindByName(nil,"dota_goodguys_fort")
		if GetDistance(jidi,FSM._entity)>=500 then
		 FSM._entity:MoveToPositionAggressive(jidi:GetOrigin()) 
	    end
	end

	function FSM:GoToSpawner(name)
		local spawner =Entities:FindByName(nil,name)
		
		local distance=GetDistance(spawner,FSM._entity)

		if distance>=200 then

		FSM._entity:MoveToPosition(spawner:GetOrigin()) 

		end
	end


	function FSM:creature_ai_base()

		local table_spawner_ent=GameRules:GetGameModeEntity().table_spawner_ent
		local spanwer_name
		for k,v in pairs(table_spawner_ent) do
				
				
				if v.entity==FSM._entity then
					
					spanwer_name=k
				end


		end

		

		if spanwer_name~=nil then
			--	print("======enter:judge!========")
			--如果700范围没敌人，自动返回初始点
				if FSMManager:RandomEnemyHeroInRange(FSM._entity,800)==nil then
				--	print("out of range 800")
					 FSM:GoToSpawner(spanwer_name)
				end
			--如果离开初始点1200.自动返回初始点
			   
			    local spawnerEnt=Entities:FindByName(nil,spanwer_name)
			    local  distance =GetDistance(spawnerEnt,FSM._entity)
			    --print(distance)
			    if distance>=1200 then
			    --	print("away from birthplace 1200")
			    	FSM:GoToSpawner(spanwer_name)
			    end

		end

	end
	
	function  FSM:OnThink()

		self._curState:think()
	end
	
	return FSM
end



function FSMManager:RandomEnemyHeroInRange( entity, range )
	--print("ENTER:RandomEnemyHeroInRange")
	--local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, entity:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	local enemies=FindUnitsInRadius( DOTA_TEAM_BADGUYS, entity:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
	if #enemies > 0 then

	
		local index = RandomInt( 1, #enemies )
		return enemies[index]
	else
		return nil
	end
end

function FSMManager:WeakestEnemyHeroInRange( entity, range )
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, entity:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false )

	local minHP = nil
	local target = nil

	for _,enemy in pairs(enemies) do
		local distanceToEnemy = (entity:GetOrigin() - enemy:GetOrigin()):Length()
		local HP = enemy:GetHealth()
		if enemy:IsAlive() and (minHP == nil or HP < minHP) and distanceToEnemy < range then
			minHP = HP
			target = enemy
		end
	end

	return target
end

function GetDistance(ent_1,ent_2)
 -- return	(ent_1:GetOrigin()- ent_2:GetOrigin()):Length()
 local pos_1=ent_1:GetOrigin()
 local pos_2=ent_2:GetOrigin() 
 local x_=(pos_1[1]-pos_2[1])^2
 local y_=(pos_1[2]-pos_2[2])^2
 local dis=(x_+y_)^(0.5)
 return dis
end


