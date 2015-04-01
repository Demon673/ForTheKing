function OnStartLeft(trigger)

    local nt=trigger.activator:GetTeamNumber() 
    if not(nt==2) then
                                --不对天辉兵生效
    local x=RandomInt(1,7)
    local ent = Entities:FindByName(nil,	"r_portal"..tostring(x)) --随机一个right王身后传送点
    local OwnerPlayer = trigger.activator:GetOwner()
    local point=ent:GetAbsOrigin()                                  
    local pid = trigger.activator:GetPlayerOwnerID()  or 5

    local portal_ent = Entities:FindByName(nil,    "portal"..tostring(pid+1))
    local money = trigger.activator:GetGoldBounty() or 0

    local caller_name = trigger.caller:GetName()
    local Left_pid = string.sub(caller_name, -1, -1)
        print(pid)
    local Left_playerid = Left_pid - 1

    local player = PlayerResource:GetPlayer(Left_playerid) --按ID索引玩家
    local portal_dummy =  PlayerS[Left_playerid].Portal
        print(portal_dummy:GetName())

        --给突破者钱
        if PlayerS[pid].Abhere == false then  

        local Gold = PlayerResource:GetGold(pid)
        PlayerResource:SetGold(pid,Gold + money, false)

        PopupGoldGain(portal_dummy,money) --金钱特效

        end


            FindClearSpaceForUnit(trigger.activator, point, true)  --完成传送
            local OrderPoint=Vector(point.x-8000 , point.y,point.z)
            --trigger.activator:MoveToPositionAggressive(point2)
            local newOrder = {                                        --发送攻击指令
                    UnitIndex = trigger.activator:entindex(), 
                    OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                    TargetIndex = nil, --Optional.  Only used when targeting units
                    AbilityIndex = 0, --Optional.  Only used when casting abilities
                    Position = OrderPoint, --Optional.  Only used when targeting the ground
                    Queue = 0 --Optional.  Used for queueing up abilities
             }
 
            ExecuteOrderFromTable(newOrder)


    end

end

--



function OnStartRight(trigger)

    local nt=trigger.activator:GetTeamNumber() 
    if not(nt==3) then
                                --不对天辉兵生效
    local x  =RandomInt(1,7)
    local ent = Entities:FindByName(nil,    "l_portal"..tostring(x)) --随机一个right王身后传送点

    local point=ent:GetAbsOrigin()                                  
    local OwnerPlayer = trigger.activator:GetOwner()
    local pid = trigger.activator:GetPlayerOwnerID()
        print("pid is "..pid)
    local money = trigger.activator:GetGoldBounty() or 0
        print("money is "..money)
    local caller_name = trigger.caller:GetName()
    local right_pid = string.sub(caller_name, -1, -1)
    local right_playerid = right_pid-1

        local portal_dummy =  PlayerS[right_playerid].Portal

            --给突破者钱
        if PlayerS[pid].Abhere == false  then
            
            local OwnerPlayerId =OwnerPlayer:GetPlayerID()  

            local Gold = PlayerResource:GetGold(OwnerPlayerId)
            PlayerResource:SetGold(OwnerPlayerId,Gold+money, false)
            PopupGoldGain(portal_dummy,money) --金钱特效
        end   
            FindClearSpaceForUnit(trigger.activator, point, true)  --完成传送

            local OrderPoint=Vector(point.x+8000 , point.y,point.z)

            local newOrder = {                                        --发送攻击指令
                    UnitIndex = trigger.activator:entindex(), 
                    OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                    TargetIndex = nil, --Optional.  Only used when targeting units
                    AbilityIndex = 0, --Optional.  Only used when casting abilities
                    Position = OrderPoint, --Optional.  Only used when targeting the ground
                    Queue = 0 --Optional.  Used for queueing up abilities
             }
 
            ExecuteOrderFromTable(newOrder)


    end
end

function StopHero(trigger)
    if trigger.activator:IsHero() then
        print("hero coming~~")
        local playerid = trigger.activator:GetPlayerID()
        local hero = trigger.activator
        local player=hero:GetOwner() 
        local startpoint = PlayerS[playerid].StartPoint
        FindClearSpaceForUnit(hero, startpoint, true)--回到开始点
        BTFGeneral:ShowError("#StopHeroWarning", playerid) --警告信息
        hero:Stop()
    end
end
--]]



function order_portal_player (trigger)


    local nt=trigger.activator:GetTeamNumber() 

        if nt ==2 then
            local unit = trigger.activator
            local player = unit:GetPlayerOwner()
            --if player ~= nil then
                local pid = unit:GetPlayerOwnerID()  

            --end
            --print(player)
            local n = pid + 6
            print("n =  "..n)
            local ent = Entities:FindByName(nil,    "portal"..tostring(n))
            local OrderPoint = ent:GetAbsOrigin() 

                local newOrder = {                                        --发送攻击指令
                        UnitIndex = trigger.activator:entindex(), 
                        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                        TargetIndex = nil, --Optional.  Only used when targeting units
                        AbilityIndex = 0, --Optional.  Only used when casting abilities
                        Position = OrderPoint, --Optional.  Only used when targeting the ground
                        Queue = 0 --Optional.  Used for queueing up abilities
                 }
                             ExecuteOrderFromTable(newOrder)




        end





end




function order_portal_player2 (trigger)

    local nt=trigger.activator:GetTeamNumber() 

        if nt ==3 then
            local unit = trigger.activator
            --local player = unit.Player
            --if player == nil then return false end
            local pid = unit:GetPlayerOwnerID() 
            print("com2")
            local n = pid - 4
            print("n =  "..n)
            local ent = Entities:FindByName(nil,    "portal"..tostring(n))
            local OrderPoint = ent:GetAbsOrigin() 

                local newOrder = {                                        --发送攻击指令
                        UnitIndex = trigger.activator:entindex(), 
                        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                        TargetIndex = nil, --Optional.  Only used when targeting units
                        AbilityIndex = 0, --Optional.  Only used when casting abilities
                        Position = OrderPoint, --Optional.  Only used when targeting the ground
                        Queue = 0 --Optional.  Used for queueing up abilities
                 }
                             ExecuteOrderFromTable(newOrder)
        end


end