RoundThinker_i =0
RoundThinker_wave = 0
RoundThinker_next = 0
RoundThinker_lumber_i = 0
RoundThinker_OneRound = 100



function RoundThinker()
	--if 	RoundThinker_i == nil then
			--RoundThinker_i =0
	--end
	--local GAME_TIME = GameRules:GetDOTATime(false,false)

		if GameRules:GetDOTATime(false,false) == GAME_TIME then 
	 		--print("pause")
		else
			RoundThinker_i  = 	RoundThinker_i  + 1
			GAME_TIME = GameRules:GetDOTATime(false,false)
			--print("game is moving")
		end
			--print("Game time  ="..GAME_TIME)
			--print("DOTA time  ="..GameRules:GetDOTATime(false,false))



	--GAME_TIME = GameRules:GetDOTATime(false,false)
	--print(	RoundThinker_i )
	if 	RoundThinker_i  < RoundThinker_OneRound then
		--RoundThinker_i  = 	RoundThinker_i  + 1
		--
	 	RoundThinker_next = RoundThinker_OneRound - RoundThinker_i + 1
	 	--
	else
		RoundThinker_i  = 1
		RoundThinker_wave = RoundThinker_wave + 1
		RoundThinker_next = 1
---------------------------回合开始------------------------------------
			
		--for _, player in pairs( AllPlayers ) do
		for _, pid in pairs( AllPlayers ) do
			--local pid = player:GetPlayerID()
			
			--print("Now make a round of player " .. tostring(pid))
			local Gold = PlayerResource:GetGold(pid) 
			local Lumber = PlayerS[pid].Lumber
			local CurFood = PlayerS[pid].CurFood
			local FullFood = PlayerS[pid].FullFood
			local Tech = PlayerS[pid].Tech
			local Farmer = PlayerS[pid].FarmerNum
			local Score = PlayerS[pid].Score
			local Income = PlayerS[pid].Income
			local Portal_point = PlayerS[pid].Portal:GetAbsOrigin() 
-----------------------设置售价为半价----------------------------------
			for __, newb in pairs( PlayerS[pid].NewBuild ) do

				--print(newb.Sale)
				if IsValidEntity(newb) then
					if newb:IsAlive()  then
						newb.Sale = newb.Sale/2
						newb:FindAbilityByName("Sale_Build"):SetLevel(2)
					end
				end
			end
			PlayerS[pid].NewBuild={}
--------------------------收入------------------------------------------
			PlayerResource:SetGold(pid,Gold + 97+3*RoundThinker_wave + Income, false)
			PopupGoldGain(PlayerS[pid].Hero,97+3*RoundThinker_wave) 
			if Income ~= 0 then
				PopupGoldGain(PlayerS[pid].Hero,Income) 
			end
--------------------------佣兵------------------------------------------			
			for __, newh in pairs( PlayerS[pid].NewHire ) do

				FindClearSpaceForUnit(newh, Portal_point, true)  --完成传送
				if pid <= 3 then
	            	local OrderPoint=Vector(Portal_point.x+8000 , Portal_point.y,Portal_point.z)
	        	else
	        		local OrderPoint=Vector(Portal_point.x-8000 , Portal_point.y,Portal_point.z)
	        	end

	            --trigger.activator:MoveToPositionAggressive(point2)
	            local newOrder = {                                        --发送攻击指令
	                    UnitIndex = newh:entindex(), 
	                    OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
	                    TargetIndex = nil, --Optional.  Only used when targeting units
	                    AbilityIndex = 0, --Optional.  Only used when casting abilities
	                    Position = OrderPoint, --Optional.  Only used when targeting the ground
	                    Queue = 0 --Optional.  Used for queueing up abilities
	            				 }
			 		
	            ExecuteOrderFromTable(newOrder)
			end

			PlayerS[pid].NewHire={}
--------------------------冲锋------------------------------------------
				

				local build_point_ent =Entities:FindByName(nil, "player_"..tostring(pid).."_farmer_1")  
				local build_table = Entities:FindAllByClassnameWithin("npc_dota_creature", build_point_ent:GetAbsOrigin() , 3000)
						--ShowCustomHeaderMessage("#Arouse", pid, pid, 5)--冲锋号令  多次提示
				for _,build in pairs(build_table) do
					if IsValidEntity(build) then
						if build:IsAlive() == true then

							--if string.sub( build:GetUnitName(), 1, 9 ) == "npc_build"  then
							if build:HasAbility("build_base") then

								CFunit = UnitManager:CreateUnitByBuilding( build )
							end
						end
					end
				end

--------------------------护卫队------------------------------------------
			if RoundThinker_wave <=100 then
				for left = 1,3 do --左边护卫队
				
						local leftHwd = CreateUnitByName("npc_unit_huweidui_left_BZ",Vector(-4160,20,265),false,nil,nil,DOTA_TEAM_GOODGUYS)
								--随着时间强化
					    leftHwd:SetBaseDamageMin(RoundThinker_wave+5)
						leftHwd:SetBaseDamageMax(RoundThinker_wave+5)
						leftHwd:SetMaxHealth(100+10*RoundThinker_wave)
	    				leftHwd:SetHealth(100+10*RoundThinker_wave)


				       	local Order = 
				       	{                                        --发送攻击指令
				            UnitIndex = leftHwd:entindex(), 
				            OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				            TargetIndex = nil, 
				            AbilityIndex = 0, 
				            Position = Vector(4160,22.8232,265), 
				            Queue = 0 
				   		}
								 
								            
						leftHwd:SetContextThink(DoUniqueString("order_later"), function() ExecuteOrderFromTable(Order) end, 0)

					    leftHwd:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})

				end




				for right = 1,3 do --右边护卫队

					local rightHwd = CreateUnitByName("npc_unit_huweidui_right_BZ",Vector(4160,20,265),false,nil,nil,DOTA_TEAM_BADGUYS)
						
					--随着时间强化
							
				    rightHwd:SetBaseDamageMin(RoundThinker_wave+5)
					rightHwd:SetBaseDamageMax(RoundThinker_wave+5)
					rightHwd:SetMaxHealth(100+10*RoundThinker_wave)
		    		rightHwd:SetHealth(100+10*RoundThinker_wave)



			       	local Order = 
			       	{                                        --发送攻击指令
			            UnitIndex = rightHwd:entindex(), 
			            OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			            TargetIndex = nil, 
			            AbilityIndex = 0, 
			            Position = Vector(-4172.98,22.8232,265), 
			            Queue = 0 
			   		}
							 
							            
					rightHwd:SetContextThink(DoUniqueString("order_later"), function() ExecuteOrderFromTable(Order) end, 0)


				    rightHwd:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})


				end
				
			end
		end
	end




--------------------------采集--周期8秒----------------------------------------		

	if RoundThinker_lumber_i < 79 then 
		RoundThinker_lumber_i = RoundThinker_lumber_i + 1
	else
		RoundThinker_lumber_i = 1
		--for _, player in pairs( AllPlayers ) do
		--	local pid = player:GetPlayerID()
			for _, pid in pairs( AllPlayers ) do
			--local Gold = PlayerResource:GetGold(pid) 
			local Lumber = PlayerS[pid].Lumber
			local Tech = PlayerS[pid].Tech
			local Farmer = PlayerS[pid].FarmerNum
			if Lumber and Tech and Farmer then
				PlayerS[pid].Lumber  =  Lumber + Farmer*(2+Tech)
			
				for __,farmer in pairs (PlayerS[pid].Farmer) do
					PopupHealing(farmer, 2+Tech )
				end
			end
		end

	end


-------------------------------------------------------------------------------


end