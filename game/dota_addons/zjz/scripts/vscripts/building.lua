--function stylized by Tiny Night

building_tech = {}

building_tech.t_tech = {}
building_tech.t_tech["Q1_00"] = {"Q1_10"}
building_tech.t_tech["Q1_10"] = {"Q1_20", "Q1_21"}
building_tech.t_tech["Q1_20"] = {}
building_tech.t_tech["Q1_21"] = {}

building_tech.t_tech["Q2_00"] = {"Q2_10"}
building_tech.t_tech["Q2_10"] = {"Q2_20", "Q2_21"}
building_tech.t_tech["Q2_20"] = {}
building_tech.t_tech["Q2_21"] = {}

building_tech.t_tech["Q3_00"] = {"Q3_10"}
building_tech.t_tech["Q3_10"] = {"Q3_20"}
building_tech.t_tech["Q3_20"] = {}

building_tech.t_tech["Q4_00"] = {"Q4_10"}
building_tech.t_tech["Q4_10"] = {"Q4_20"}
building_tech.t_tech["Q4_20"] = {}

building_tech.t_tech["Q5_00"] = {"Q5_10"}
building_tech.t_tech["Q5_10"] = {"Q5_20","Q5_21"}
building_tech.t_tech["Q5_20"] = {}
building_tech.t_tech["Q5_21"] = {}

building_tech.t_tech["W1_00"] = {"W1_10", "W1_11"}
building_tech.t_tech["W1_10"] = {"W1_20"}
building_tech.t_tech["W1_20"] = {}
building_tech.t_tech["W1_11"] = {"W1_21"}
building_tech.t_tech["W1_21"] = {}

building_tech.t_tech["W2_00"] = {"W2_10",}
building_tech.t_tech["W2_10"] = {"W2_20",}
building_tech.t_tech["W2_20"] = {}

building_tech.t_tech["W3_00"] = {"W3_10",}
building_tech.t_tech["W3_10"] = {"W3_20",}
building_tech.t_tech["W3_20"] = {}

building_tech.t_tech["W4_00"] = {"W4_10",}
building_tech.t_tech["W4_10"] = {"W4_20",}
building_tech.t_tech["W4_20"] = {}

building_tech.t_tech["W5_00"] = {"W5_10",}
building_tech.t_tech["W5_10"] = {"W5_20","W5_21",}
building_tech.t_tech["W5_20"] = {}
building_tech.t_tech["W5_21"] = {}

building_tech.t_tech["E1_00"] = {"E1_10",}
building_tech.t_tech["E1_10"] = {}


building_tech.t_tech["E2_00"] = {"E2_10",}
building_tech.t_tech["E2_10"] = {}

building_tech.t_tech["E3_00"] = {"E3_10",}
building_tech.t_tech["E3_10"] = {}

building_tech.t_tech["E4_00"] = {"E4_10",}
building_tech.t_tech["E4_10"] = {}

building_tech.t_tech["E5_00"] = {"E5_10","E5_11",}
building_tech.t_tech["E5_10"] = {}
building_tech.t_tech["E5_11"] = {}

building_tech.t_tech["E6_00"] = {"E6_10","E6_11",}
building_tech.t_tech["E6_10"] = {}
building_tech.t_tech["E6_11"] = {}


function building_tech:ApplyTechSkills( u_building )

	s_building_name = u_building:GetUnitName()
	s_tech_name = string.sub(s_building_name, -8, -4)
	t_building = self.t_tech[s_tech_name]
	if t_building ~= nil then
		for k,s_ability_name in pairs(t_building) do
			AbilityManager:AddAndSet( u_building, s_ability_name )
		end
	end
	AbilityManager:AddAndSet( u_building, "Sale_Build" )
	AbilityManager:AddAndSet( u_building, "build_base" )
end
--original functions


function buildbuilding( keys )--建筑完成
	local old_build = keys.caster
	local player = old_build:GetPlayerOwner()--old_build.Player
	local pid = player:GetPlayerID()
	print("now the building pid is  "..pid)

	local BuildPoint = keys.caster:GetAbsOrigin() 
	local TeamNumber = player:GetTeamNumber() 
	local new_build = keys.new_build
	local cost = keys.ability:GetGoldCost(keys.ability:GetLevel() - 1)--keys.GoldCost
	local food = keys.ability:GetManaCost(keys.ability:GetLevel() - 1)--keys.Food
	print("ManaCost is  "..keys.ability:GetManaCost(1))
	local money = PlayerResource:GetGold(pid) 
	local old_sale = old_build.Sale
	local old_food = old_build.Food
	local old_score = old_build.Score
	local FullFood = PlayerS[pid].FullFood
	local CurFood =  PlayerS[pid].CurFood + food

	--创建新的建筑
		local build = CreateUnitByName(new_build, BuildPoint, false, old_build:GetOwner(), old_build:GetOwner(), TeamNumber) 
		print(old_build:GetOwner())

	--设置控制权和加入表	
		build:SetControllableByPlayer(pid, true) 
		table.insert(PlayerS[pid].NewBuild,build)
		table.insert(PlayerS[pid].Build,build)
	--设置高度
	    local min = GetGroundPosition(BuildPoint,build)

	    build:SetOrigin(Vector(BuildPoint.x,BuildPoint.y,min.z+30))
	--设置朝向(在单位出生事件统一设置了)
		--if TeamNumber == 2 then
		--	build:SetForwardVector((Vector(2000,0,0) - Vector(-2000,0,0)):Normalized())--朝右
		--else
		--	build:SetForwardVector((Vector(-2000,0,0) - Vector(2000,0,0)):Normalized())--朝左
		--end

	--设置归属玩家和设置贩售金钱
		build.Player = player
		build.Sale = old_sale + cost
		build.Food = old_food + food
		build.Score = old_score + cost
	--设置石化效果

		build:SetContextThink(DoUniqueString("build_stonehold"), function() 
			if IsValidEntity(build) then 
				if build:IsAlive()  then 
					build:FindAbilityByName("build_base"):ApplyDataDrivenModifier(build,build,"modifier_buildbase_partic",nil) 
					end
				end
			end
			, 2.6)

		--删除旧的
		old_build:SetOrigin(Vector(7000,-7000,-400))
		old_build:ForceKill(true)

	--兵力增加
		PlayerS[pid].Score = PlayerS[pid].Score + cost

	--单位建筑化
		
		build:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
		build:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK) 
		local f_scale = build.BuildScale

			--build:SetModelScale(1.2) --待修改

	--增加升级
		building_tech:ApplyTechSkills( build )
end


function conditions(keys) --开始建筑
	--DeepPrintTable(keys)
	local old_build = keys.caster
	local player = old_build:GetPlayerOwner()  --old_build.Player
	local pid = player:GetPlayerID()
	local money = PlayerResource:GetGold(pid) 
	local cost = keys.ability:GetGoldCost(keys.ability:GetLevel() - 1)--keys.GoldCost
	local food = keys.ability:GetManaCost(keys.ability:GetLevel() - 1)--keys.Food
	local FullFood = PlayerS[pid].FullFood

	PlayerS[pid].CurFood = PlayerS[pid].CurFood + food  --增加人口

	local CurFood =  PlayerS[pid].CurFood


	if (CurFood > FullFood)  then
		BTFGeneral:ShowError("#NoEnoughFood", pid) --人口不足的警告信息
		old_build:Stop()

	end

	
end

function CancelBuild(keys )
	local old_build = keys.caster
	local player = old_build:GetPlayerOwner()  --old_build.Player
	local pid = player:GetPlayerID()
	local food = keys.ability:GetManaCost(keys.ability:GetLevel() - 1)--keys.Food
--退还金钱
	local money = PlayerResource:GetGold(pid) 
	local cost = keys.ability:GetGoldCost(keys.ability:GetLevel() - 1)--keys.GoldCost
	PlayerResource:SetGold(pid,money+cost, false)
	print("now backup the money playerid is "..pid)
--退还人口
	PlayerS[pid].CurFood = PlayerS[pid].CurFood - food	

end


function UpFoodStart(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local pid = caster:GetPlayerOwnerID() 
	--local pid = player:GetPlayerID()
	--local pid = PlayerCalc:GetPlayerIndex(player) --把玩家的position的ID转化成counting的ID 
		--print("now UpFood OwnerPlayerid is "..pid)
	local FullFood = PlayerS[pid].FullFood
	local money = PlayerResource:GetGold(pid) 
	local lumber = PlayerS[pid].Lumber
	local cost = 20+5*(FullFood/8)

	if FullFood < 184 then
		if money < cost then
			BTFGeneral:ShowError("#NoEnoughMoney", pid) --警告信息  
			caster:Stop()
		else
			if lumber < cost*2 then
				BTFGeneral:ShowError("#NoEnoughLumber", pid) --警告信息
				caster:Stop()
			end
		end
	else
		BTFGeneral:ShowError("#MaxFullFood", pid) --警告信息  
		caster:Stop()	
	end
	PlayerS[pid].Lumber = PlayerS[pid].Lumber - cost * 2
	PlayerResource:SetGold(pid,money-cost, false)
end

function UpFoodSuccess(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
		--local pid = caster:GetPlayerOwnerID() 
	local pid = player:GetPlayerID()
	--local pid = PlayerCalc:GetPlayerIndex(player) --把玩家的position的ID转化成counting的ID 
	local FullFood = PlayerS[pid].FullFood
	local money = PlayerResource:GetGold(pid) 
	local lumber = PlayerS[pid].Lumber
	local cost = 20+5*(FullFood/8)
	local name = keys.ability:GetAbilityName()
	local lv = keys.ability:GetLevel()
	local lvnum = string.sub(name,-1,-1)
	print(lv)
	print(name)
	if lv == 7 then
		if lvnum == "1" then
			caster:RemoveAbility(name)
			caster:AddAbility("Up_Food2")
			local ab = caster:FindAbilityByName("Up_Food2")
			ab:SetLevel(1)
		end
		if lvnum == "2" then
			caster:RemoveAbility(name)
			caster:AddAbility("Up_Food3")
			local ab2 = caster:FindAbilityByName("Up_Food3")
			ab2:SetLevel(1)			
		end		
		if lvnum == "3" then

		end
	else
		keys.ability:SetLevel(lv+1)
	end

	PlayerS[pid].FullFood = PlayerS[pid].FullFood+8
			
end


function UpFoodCancel(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local pid = caster:GetPlayerOwnerID() 
	local FullFood = PlayerS[pid].FullFood
	local money = PlayerResource:GetGold(pid) 
	local lumber = PlayerS[pid].Lumber
	local cost = 20+5*(FullFood/8)
	PlayerS[pid].Lumber = PlayerS[pid].Lumber + cost * 2
	PlayerResource:SetGold(pid,money+cost, false)

end


function UpTechStart(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local pid = caster:GetPlayerOwnerID() 
	local Tech = PlayerS[pid].Tech
	local money = PlayerResource:GetGold(pid) 
	local Score = PlayerS[pid].Score
	local lumber = PlayerS[pid].Lumber
	local cost = keys.ability:GetGoldCost(keys.ability:GetLevel() - 1)
	print("pid is  "..pid)
	print("cost is  "..cost)
	print("money is "..money)
	if Tech >= 8 then
		BTFGeneral:ShowError("#MaxTechLevel", pid) --警告信息
		caster:Stop()
	else
		if Score <= 2000 then
			BTFGeneral:ShowError("#NoEnoughScore2000", pid) --警告信息	
			caster:Stop()
		else
			if lumber < cost then
				BTFGeneral:ShowError("#NoEnoughLumber", pid) --警告信息
				caster:Stop()
			else

			end
		end
	end
	PlayerS[pid].Lumber = PlayerS[pid].Lumber - 125


end



function UpTechCancel(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local pid = caster:GetPlayerOwnerID() 

	local money = PlayerResource:GetGold(pid) 

	local cost = keys.ability:GetGoldCost(keys.ability:GetLevel() - 1)
	print("pid is  "..pid)
	print("cost is  "..cost)
	print("money is "..money)

	PlayerS[pid].Lumber = PlayerS[pid].Lumber + 125
---------------------退还金钱--------------------------------
	PlayerResource:SetGold(pid,money+125, false)


end

function UpTechSuccess(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local pid = caster:GetPlayerOwnerID() 
	local FullFood = PlayerS[pid].FullFood
	local money = PlayerResource:GetGold(pid) 
	local lumber = PlayerS[pid].Lumber
	local cost = 125

			PlayerS[pid].Tech = PlayerS[pid].Tech+1

end






function SaleBuild(keys)
	local sale_build  = keys.caster
	local player = sale_build.Player
	local pid = player:GetPlayerID() 
	local sale_money = sale_build.Sale
	local player_money = PlayerResource:GetGold(pid)
	local p = keys.caster:GetAbsOrigin() 	
	local food = sale_build.Food
	local score = sale_build.Score
	local owner = sale_build:GetOwner() 

---------------------删除旧的---------------------
	sale_build:ForceKill(true)
	sale_build:SetOrigin(Vector(7000,-7000,-400))
---------------------创建新的建筑---------------------
    local buildbase = CreateUnitByName("npc_dummy_build_base", p, false, owner, owner,player:GetTeam()) --地基单位
    buildbase.Player = player
    table.insert(PlayerS[pid].BuildBase, buildbase)
    buildbase:SetControllableByPlayer(pid, true) 
    local min = GetGroundPosition(p,buildbase)
    buildbase:SetOrigin(Vector(p.x,p.y,min.z+ 13))
    buildbase.Score = 0 -- 兵力提升值
    buildbase.Sale = 0 -- 贩卖后退还金额
    buildbase.Food = 0
    playerstarts:RollBuilds(buildbase) --重设技能
---------------------退还金钱--------------------------------
	PlayerResource:SetGold(pid,player_money+sale_money, false)
---------------------金钱特效--------------------------------
    PopupGoldGain(buildbase,math.floor(sale_money))
---------------------退还人口--------------------------------
	PlayerS[pid].CurFood = PlayerS[pid].CurFood - food
---------------------退还兵力--------------------------------
	PlayerS[pid].Score = PlayerS[pid].Score - score
end



function UpFarmerStart(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local pid = caster:GetPlayerOwnerID() 
	local FarmerNum = PlayerS[pid].FarmerNum
	local money = PlayerResource:GetGold(pid) 
	local Score = PlayerS[pid].Score
	local CurFood = PlayerS[pid].CurFood
	local FullFood = PlayerS[pid].FullFood


PlayerS[pid].CurFood = PlayerS[pid].CurFood + 1 --增加人口

	if	FarmerNum >= 8 then
		BTFGeneral:ShowError("#MaxFarmerNum", pid) --最大采集者数量警告信息
		caster:Stop() --升级中断
		PlayerS[pid].FarmerNum = 8
	else
		if  CurFood + 1 > FullFood  then

			BTFGeneral:ShowError("#NoEnoughFood", pid) --人口不足警告信息
			caster:Stop() --升级中断
		else
			if FarmerNum < 4 then
				if Score <600 then
					BTFGeneral:ShowError("#NoEnoughScore600", pid) --兵力不足警告信息
					caster:Stop() --升级中断
				end
			else
				if Score <1000 then
					BTFGeneral:ShowError("#NoEnoughScore1000", pid) --兵力不足警告信息
					caster:Stop() --升级中断				
				end
			end
		end

	end

end


function UpFarmerCancel(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local pid = caster:GetPlayerOwnerID() 
	local FarmerNum = PlayerS[pid].FarmerNum
	local money = PlayerResource:GetGold(pid) 
	local Score = PlayerS[pid].Score
	local CurFood = PlayerS[pid].CurFood
	local FullFood = PlayerS[pid].FullFood
	local cost = 60
	if FarmerNum > 4 then	--设置售价
		cost = 80
	end
---------------------退还金钱--------------------------------
	PlayerResource:SetGold(pid,money+cost, false)
---------------------退还人口--------------------------------
	PlayerS[pid].CurFood = PlayerS[pid].CurFood - 1

end


function UpFarmerSuccess(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local pid = caster:GetPlayerOwnerID() 
	local FarmerNum = PlayerS[pid].FarmerNum
	local money = PlayerResource:GetGold(pid) 
	local Score = PlayerS[pid].Score
	local CurFood = PlayerS[pid].CurFood
	local FullFood = PlayerS[pid].FullFood
	local Ability = keys.ability

	Ability:SetLevel(FarmerNum)

	PlayerS[pid].FarmerNum = PlayerS[pid].FarmerNum + 1

    local farmer_ent = Entities:FindByName(nil, "player_"..tostring(pid).."_farmer_"..tostring(FarmerNum+1)) 
    local farmer = CreateUnitByName("npc_dummy_farmer", farmer_ent:GetAbsOrigin() , false, hero,hero ,player:GetTeam()) 
	table.insert(PlayerS[pid].Farmer, farmer)

end


--防卡兵
function fangkabing(keys)
	--local target = keys.target
	local caster = keys.caster 
	local point = keys.target_points[1]
	local teams = DOTA_UNIT_TARGET_TEAM_BOTH
	local types = DOTA_UNIT_TARGET_BASIC
	local flags = DOTA_UNIT_TARGET_FLAG_NONE

	--获取范围内的单位
	local group = FindUnitsInRadius(caster:GetTeamNumber(),point,nil,200,teams,types,flags,FIND_UNITS_EVERYWHERE,true)
		print("the kabing unit is  ")
		print("group:"..#group)	
	for i,target in pairs(group) do
		local team_number = target:GetTeamNumber() 
		local unit_point = target:GetAbsOrigin()

		if team_number == DOTA_TEAM_GOODGUYS  then

					local attack_to_right = Vector(4200 , unit_point.y,unit_point.z)
					local Order = 
				{                                        --发送攻击指令
					UnitIndex = target:entindex(), 
					OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
					TargetIndex = nil, 
					AbilityIndex = 0, 
					Position = attack_to_right, 
					Queue = 0 
				}
			ExecuteOrderFromTable(Order)
			print("attack to right x is"..attack_to_right.x)
			print("order1")
		end

		if team_number ==  DOTA_TEAM_BADGUYS  then
			local attack_to_left = Vector(-4200 , unit_point.y,unit_point.z)
			local Order2 = 
				{                                        --发送攻击指令
					UnitIndex = target:entindex(), 
					OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
					TargetIndex = nil, 
					AbilityIndex = 0, 
					Position = attack_to_left, 
					Queue = 0 
				}
			ExecuteOrderFromTable(Order2)
			print("attack to left x is"..attack_to_left.x)
			print("order2")
		end
	end

end


function ReRollBuilds(keys) --(施法单位，指定兵种[nil为所有兵种])
	local caster = keys.caster 
    local player = caster:GetPlayerOwner()
    local pid  = player:GetPlayerID()


        if keys.build_type == nil then
            --重选全部技能 
            local BUILD_Q = PlayerS[pid]["Q"] --获取Q旧编号
            local BUILD_W = PlayerS[pid]["W"] --获取W旧编号
            local BUILD_E = PlayerS[pid]["E"] --获取E旧编号
            local BUILD_D = PlayerS[pid]["D"] --获取D旧编号
            local BUILD_F = PlayerS[pid]["F"] --获取F旧编号
            local BUILD_R = PlayerS[pid]["R"] --获取R旧编号

            PlayerS[pid]["Q"] = RandomInt(1, #AllTypes["Q"]) --设置新编号
            PlayerS[pid]["W"] = RandomInt(1, #AllTypes["W"]) --从W列表里随机 (1,x)
            PlayerS[pid]["E"] = RandomInt(1, #AllTypes["E"]) --从E列表里随机 (1,x)
            PlayerS[pid]["D"] = RandomInt(1, #AllTypes["D"]) --从D列表里随机 (1,x)
            PlayerS[pid]["F"] = RandomInt(1, #AllTypes["F"]) --从F列表里随机 (1,x)
            PlayerS[pid]["R"] = RandomInt(1, #AllTypes["R"]) --从R列表里随机 (1,x)

            local old_Q = "Q"..tostring(BUILD_Q).."_0"
            local new_Q = "Q"..tostring(PlayerS[pid]["Q"]).."_00"

            local old_W = "W"..tostring(BUILD_W).."_0"
            local new_W = "W"..tostring(PlayerS[pid]["W"]).."_00"

            local old_E = "E"..tostring(BUILD_E).."_0"
            local new_E = "E"..tostring(PlayerS[pid]["E"]).."_00"

            local old_D = "D"..tostring(BUILD_D).."_0"
            local new_D = "D"..tostring(PlayerS[pid]["D"]).."_00"

            local old_F = "F"..tostring(BUILD_F).."_0"
            local new_F = "F"..tostring(PlayerS[pid]["F"]).."_00"

            local old_R = "R"..tostring(BUILD_R).."_0"
            local new_R = "R"..tostring(PlayerS[pid]["R"]).."_00"

            for k,v in pairs(PlayerS[pid].BuildBase) do 
            	if IsValidEntity(v) then 
					if v:IsAlive()  then  
			            SwapAbility(v,new_Q,old_Q)           --替换W
			            SwapAbility(v,new_W,old_W)           --替换E
			            SwapAbility(v,new_E,old_E)           --替换D
			            SwapAbility(v,new_D,old_D)           --替换F
			            SwapAbility(v,new_F,old_F)           --替换R
			            SwapAbility(v,new_R,old_R)
			        end  
			    end
	        end

        else
            --重选指定技能
            local x = PlayerS[pid][build_type] --获取旧编号
            local table = buildings_..build_type
            PlayerS[pid][build_type] = RandomInt(1, #table) --设置新编号
            local old_ability = build_type..tostring(x).."_0"
            local new_ability = build_type..tostring(PlayerS[pid][build_type]).."_0"
            --替换函数
            for k,v in pairs(PlayerS[pid].BuildBase) do 
            	if IsValidEntity(v) then 
					if v:IsAlive()  then  
			            SwapAbility(v,new_ability,old_ability)           --替换
			        end  
			    end
	        end
        end



end

