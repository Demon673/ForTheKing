if playerstarts == nil then
    playerstarts = class({})
end

if AllPlayers == nil then
    AllPlayers={}
end

if PlayerS == nil then
    PlayerS={}
end


AllTypes = {}
AllTypes["Q"] = { "Q1_00" }
AllTypes["W"] = { "W1_00" }
AllTypes["E"] = { "Q2_00" }
AllTypes["R"] = { "Q3_00" }
AllTypes["T"] = { "Q4_00" }
AllTypes["Y"] = { "Q5_00" }


function playerstarts:playertable()

    for i = 0,8,1 do

        local n = i + 1

        if PlayerS[i] == nil then
            PlayerS[i] = {}
        end      
                         --设置传送门马甲
        if i <= 3 then
            local left_p = Entities:FindByName(nil,"portal"..tostring(n))
            local por_left = CreateUnitByName("npc_dummy_portal",left_p:GetAbsOrigin(),true, nil, nil,2)
            PlayerS[i].Portal = por_left
        end

        if i >=5 then
            local right_p = Entities:FindByName(nil,"portal"..tostring(n))
            local por_right = CreateUnitByName("npc_dummy_portal",right_p:GetAbsOrigin(),true, nil, nil,3)
            PlayerS[i].Portal=por_right
        end

    end

end


function playerstarts:init(i,hero) --英雄登场之后准备开始运行的函数

    if ((i~=4) and (i~=8)) then
        if PlayerS[i] == nil then
            PlayerS[i] = {}
        end
        --print("fst playerID is "..i)
                  --local player = PlayerResource:GetPlayer(i)  
        local player = hero:GetOwner() 
        player.Init = false

        local n = i+1
        local start_ent = Entities:FindByName(nil,  "startpoint"..tostring(i)) or Entities:FindByName(nil,  "portal"..tostring(n)) 
        local start_point = start_ent:GetAbsOrigin() 
                                      
        PlayerS[i].StartPoint = start_point  
        PlayerS[i].Gold = 60000                    --定义初始金钱 600
        PlayerS[i].Lumber = 0                   --定义初始木材  0
        PlayerS[i].CurFood = 1                      --初始当前人口
        PlayerS[i].FullFood = 16                     --初始最大人口            每次提升8
        PlayerS[i].FarmerNum = 1                    --初始采集者数量          最多为8
        PlayerS[i].Tech = 0                         --初始采集科技等级        最多为8
        PlayerS[i].Score = 0                        --初始兵力
        PlayerS[i].Income = 0                       --初始收入
                          --print(PlayerS[i].Gold)
                          --print("player"..tostring(i).." gold is  "..PlayerS[i].Gold)

        PlayerS[i].Unit = {}                                                                          --玩家单位 
        PlayerS[i].Farmer = {}                                                                        --玩家采集者单位
        PlayerS[i].Build = {}                                                                         --玩家的建筑
        PlayerS[i].NewBuild = {}                                                                      --未出兵的建筑
        PlayerS[i].Hire = {}                                                                          --玩家的佣兵
        PlayerS[i].NewHire = {}                                 
        PlayerS[i].Light = 1                                                                          --圣光数量
        PlayerS[i].Abhere = false                                                                     --固守状态
        if i >= 5 then
            PlayerS[i].Team = right
        else
            PlayerS[i].Team = left
        end                            --设置阵营
        table.insert( AllPlayers, player)                                                         --加入全部玩家队伍
                      
        local lib_ent = Entities:FindByName(nil, "player_"..tostring(i).."_farmer_4")   --player_i_lib
        PlayerS[i].Lib =  CreateUnitByName("npc_dummy_lib", lib_ent:GetAbsOrigin() , false, hero,hero ,player:GetTeam()) 
        PlayerS[i].Lib:SetControllableByPlayer(i, true)


        local pig_ent = Entities:FindByName(nil, "player_"..tostring(i).."_farmer_3")   --player_i_lib
        PlayerS[i].Pig =  CreateUnitByName("npc_dummy_pig", pig_ent:GetAbsOrigin() , false, hero,hero ,player:GetTeam()) 
        PlayerS[i].Pig:SetControllableByPlayer(i, true)
                      


        if player ~= nil then
            local ent =  Entities:FindAllByName("player"..tostring(i+1)) --这里返回一个表
            --print("Spawn BuildBase Done")
            PlayerS[i].BuildBase = {}                                                              --设置初始的地基
            --print("playerID is  "..player:GetPlayerID() )
            PlayerS[i].buildtype = {}
            for k,supertype in pairs({"Q", "W", "E", "R", "T", "Y"}) do
                PlayerS[i].buildtype[supertype] = RandomInt(1, #AllTypes[supertype])
            end

            for x,v in pairs (ent) do
                local p = v:GetAbsOrigin()

                local buildbase = CreateUnitByName("npc_dummy_build_base", p, false, hero,hero,player:GetTeam()) --地基单位
                table.insert(PlayerS[i].BuildBase, buildbase)
                --buildbase:SetOwner(hero) 
                buildbase:SetControllableByPlayer(i, true)
                --print(buildbase:GetPlayerOwnerID() )

                buildbase.Player = player --设置地基的player
                buildbase.Score = 0 -- 兵力提升值
                buildbase.Sale = 0 -- 贩卖后退还金额
                buildbase.Food = 0
                local fake = CreateUnitByName("npc_dummy_build_fake", p, false, nil, nil,player:GetTeam()) --假地基 装饰用
                --local min = GetGroundPosition(p,buildbase)
                buildbase:SetOrigin(Vector(p.x,p.y,p.z+ 13))
                fake:SetOrigin(Vector(p.x,p.y,p.z+ 13))
                --buildbase:SetContextNum("player",i,0)


                playerstarts:RollBuilds(buildbase) -- （地基单位；重选哪种兵种,nil为全选；是否reroll）
                


            end
            local farmer_ent = Entities:FindByName(nil, "player_"..tostring(i).."_farmer_1") 
            local farmer = CreateUnitByName("npc_dummy_farmer", farmer_ent:GetAbsOrigin() , false, hero,hero ,player:GetTeam()) 
            table.insert(PlayerS[i].Farmer, farmer)


        end 

    end

end

function playerstarts:PrintAll()
    print("Now start to test PlayerInstanceFromIndex: ")
    for k,v in pairs({0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}) do
        p_player = PlayerInstanceFromIndex(v)
        print("The player gotten from ID " .. tostring(v) .. " is " .. tostring(p_player))
    end

    print("Now start to test PlayerResource:GetPlayer: ")
    for k,v in pairs({0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}) do
        p_player = PlayerResource:GetPlayer(v)
        print("The player gotten from ID " .. tostring(v) .. " is " .. tostring(p_player))
    end
end


function playerstarts:RollBuilds(unit) --(单位，字符串，True/False)
    local player = unit:GetPlayerOwner()
    local pid  = player:GetPlayerID()

    for k,supertype in pairs({"Q", "W", "E", "R", "T", "Y"}) do
        local type_string = AllTypes[supertype][PlayerS[pid].buildtype[supertype]]
        AbilityManager:AddAndSet( unit, type_string )
    end

end



function SwapAbility(unit,new,old) --替换技能
    unit:AddAbility(new)
    unit:SwapAbilities(new,old, true, false)
    unit:RemoveAbility(old) 
end