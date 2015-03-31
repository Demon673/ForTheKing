if chushihua == nil then
	chushihua = class({})
end

--创建地基单位\王\传送门等
function chushihua:SpawnBuildBase() 
--创建双王
	local king_left_ent = Entities:FindByName(nil,"king_left")
	local king_right_ent = Entities:FindByName(nil,"king_right")

	local left_p = king_left_ent:GetAbsOrigin() 
	local right_p = king_right_ent:GetAbsOrigin()

	king_left = CreateUnitByName("npc_king_left_LC",left_p, true, nil, nil,2)
	king_right = CreateUnitByName("npc_king_right_LC",right_p, true, nil, nil,3)

	--face_l = (right_p - left_p):Normalized()
	--face_r = (left_p - right_p):Normalized()
	self.king_left = king_left
	self.king_right = king_right

	--king_left:SetForwardVector(face_l)
	--king_right:SetForwardVector(face_r)
	print("Spawn King Done")


end

--function chushihua:SetConKing(unit)
	--给双方玩家 共享单位控制权
--function chushihua:SetConKing()
	
	--for _, player in pairs( AllPlayers ) do
	
		--local pid = player:GetPlayerID()
		
	--for _, pid in pairs( AllPlayers ) do

	--	print("Goint to set player " .. tostring(pid) .. " able to control his King.")

	--	if pid<=3 then
			--if PlayerInstanceFromIndex(pid) ~= nil then
	--			print("He is going to control good guy.")
	--			self.king_left:SetControllableByPlayer(pid, true) 
			--end
	--	else	
			--if PlayerInstanceFromIndex(pid) ~= nil then
	--			print("He is going to control bad guy.")
	--			self.king_right:SetControllableByPlayer(pid, true) 
			--end
	--	end
	--	print("And it is the end of setting.")
	--end
--end