--[[
攻防相克表
攻击类型   混乱 L 普通攻击 B 魔法攻击 M 穿刺攻击 P  攻城攻击 S 英雄 H
护甲类型   重甲 Z  中甲 S   轻甲 W  坚甲城甲 C   无甲 B   英雄 H
]]




--[[AandD_table = {
		B = {
				  Z = 90,
				  S = 130,
				  W = 80,
				  C = 90,
				  B = 100,
				  H = 85
				},
		P = {
				  Z = 80,
				  S = 100,
				  W = 130,
				  C = 80,										
				  B = 100,
				  H = 85
				},
		M = {
				  Z = 130,
				  S = 80,
				  W = 110,
				  C = 70,
				  B = 100,
				  H = 85
				},
		S = {
				  Z = 90,
				  S = 90,
				  W = 80,
				  C = 130,
				  B = 100,
				  H = 85
				},
		H = {
				  Z = 100,
				  S = 100,
				  W = 100,
				  C = 100,
				  B = 100,
				  H = 100
				},
		L = {
				  Z = 110,
				  S = 110,
				  W = 110,
				  C = 110,
				  B = 110,
				  H = 110
				}
		}

--]]





		--Unit_Table = {unit_name = {"BASICA","BASICD"}, }做一个总表，子表为单位名称，子表的字表为单位攻防类型。
		--在Spawn事件里，根据单位名称索引出单位的攻防类型

		--Unit_Table.unit_name[1] --> "BASICA"

