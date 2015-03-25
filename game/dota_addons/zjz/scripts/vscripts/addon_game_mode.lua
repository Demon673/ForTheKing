--注册游戏的类
if CbtfGameMode == nil then
	CbtfGameMode = class({})
end

--[[BbtfStart=0
--************************************攻防相克表***********************
--********************************************************************
]]


require('require_everything')


-------------------------------------------------------------------------------------------------------------------
local function PrecacheSound(sound, context )
    PrecacheResource( "soundfile", sound, context)
end
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
local function PrecacheParticle(particle, context )
    PrecacheResource( "particle",  particle, context)
end
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
local function PrecacheModel(model, context )
    PrecacheResource( "model", model, context )
end
--------------------------------------------------------------------- ----------------------------------------------
 
-------------------------------------------------------------------------------------------------------------------

--预载入--------
function PrecacheEveryThingFromKV( context )
	local kv_files = {"scripts/npc/npc_units_custom.txt","scripts/npc/npc_abilities_custom.txt","scripts/npc/npc_heroes_custom.txt","scripts/npc/npc_abilities_override.txt","npc_items_custom.txt"}
	for _, kv in pairs(kv_files) do
		local kvs = LoadKeyValues(kv)
		if kvs then
			print("BEGIN TO PRECACHE RESOURCE FROM: ", kv)
			PrecacheEverythingFromTable( context, kvs)
		end
	end

	local zr={
	 --dummy
	{"model", "models/heroes/pedestal/pedestal_1.vmdl"},
	{"model", "models/courier/frull/frull_courier_flying.vmdl"},
	{"model", "models/items/courier/gnomepig/gnomepig_flying.vmdl"},
	
	 --left king
	{"model", "models/heroes/chen/chen.vmdl"},
	{"model", "models/items/chen/squareskystaff_weapon/squareskystaff_weapon.vmdl"},
	{"model", "models/items/chen/weapon_navi/weapon_navi.vmdl"},
	{"model", "models/items/chen/armor_navi/armor_navi.vmdl"},
	{"model", "models/items/chen/arms_navi/arms_navi.vmdl"},
	{"model", "models/items/chen/head_navi/head_navi.vmdl"},
	{"model", "models/items/chen/mount_navi_new/mount_navi_new.vmdl"},
	{"model", "models/items/chen/shoulder_navi/shoulder_navi.vmdl"},
	{"model", "models/items/chen/neck_desert/neck_desert.vmdl"},
	{"model", "models/items/chen/desert_gale_shoulder_plate/desert_gale_shoulder_plate.vmdl"},

	--right king
	{"model", "models/heroes/abaddon/abaddon.vmdl"},
	{"model", "models/items/abaddon/netherax_nightmare_of_the_mist/netherax_nightmare_of_the_mist.vmdl"},
	{"model", "models/items/abaddon/alliance_abba_back/alliance_abba_back.vmdl"},
	{"model", "models/items/abaddon/alliance_abba_head/alliance_abba_head.vmdl"},
	{"model", "models/items/abaddon/mistblade/mistblade.vmdl"},
	{"model", "models/items/abaddon/alliance_abba_shoulder/alliance_abba_shoulder.vmdl"},


	--Q1 00
	{"model", "models/heroes/sven/sven_belt.vmdl"},
	{"model", "models/heroes/sven/sven_gauntlet.vmdl"},
	{"model", "models/heroes/sven/sven_mask.vmdl"},
	{"model", "models/heroes/sven/sven_shoulder.vmdl"},
	{"model", "models/heroes/sven/sven_sword.vmdl"},

	--Q1 10
	{"model", "models/items/sven/mono_militis_head.vmdl"},
	{"model", "models/items/sven/mono_militis_shoulder.vmdl"},
	{"model", "models/items/sven/mono_militis_weapon.vmdl"},
	{"particle", "particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_explode_points.vpcf"},

	--Q1 20
	{"model", "models/items/sven/ceremonialtassetsofthemyrmidon/ceremonialtassetsofthemyrmidon.vmdl"},
	{"model", "models/items/sven/sven_ceremonialarmbladesofthemyrmidon/sven_ceremonialarmbladesofthemyrmidon.vmdl"},
	{"model", "models/items/sven/sven_ceremonialgreathelmofthemyrmidon/sven_ceremonialgreathelmofthemyrmidon.vmdl"},
	{"model", "models/items/sven/sven_ceremonialshieldbladeofthemyrmidon/sven_ceremonialshieldbladeofthemyrmidon.vmdl"},
	{"model", "models/items/sven/sven_ceremonialshoulderbladesofthemyrmidon/sven_ceremonialshoulderbladesofthemyrmidon.vmdl"},
	{"particle", "particles/units/heroes/hero_queenofpain/queen_shadow_strike_smoke.vpcf"},
	{"particle", "particles/econ/courier/courier_tinkbot/courier_tinkbot_flying_ambient_b.vpcf"},


	--Q1 21
	
	{"model", "models/items/sven/belt_of_tielong/belt_of_tielong.vmdl"},
	{"model", "models/items/sven/breath_of_tielong/breath_of_tielong.vmdl"},
	{"model", "models/items/sven/gauntlet_of_tielong/gauntlet_of_tielong.vmdl"},
	{"model", "models/items/sven/helmet_of_tielong/helmet_of_tielong.vmdl"},
	{"model", "models/items/sven/pauldron_of_tielong/pauldron_of_tielong.vmdl"},

	--Q2 00
	--"models/heroes/lycan/lycan.vmdl",
	{"model", "models/heroes/lycan/lycan_blades.vmdl"},--206
	{"model", "models/heroes/lycan/lycan_head.vmdl"},	--207
	{"model", "models/heroes/lycan/lycan_armor.vmdl"}, --208
	{"model", "models/heroes/lycan/lycan_fur.vmdl"},--209
	{"model", "models/heroes/lycan/lycan_belt.vmdl"}, --210

	--Q2 10
	{"model", "models/items/lycan/armor_royal/armor_royal.vmdl"},--4974
	{"model", "models/items/lycan/belt_alpha/belt_alpha.vmdl"},--4975
	{"model", "models/items/lycan/clawsy_greatg/clawsy_greatg.vmdl"},--4976
	{"model", "models/items/lycan/shoulder_alpha/shoulder_alpha.vmdl"},--4977
	{"model", "models/items/lycan/head_alpha/head_alpha.vmdl"},--4978

	--Q2 20
	{"model", "models/items/lycan/sanguinemoon_armor/sanguinemoon_armor.vmdl"}, --4859
	{"model", "models/items/lycan/sanguinemoon_shoulder/sanguinemoon_shoulder.vmdl"},--4860
	{"model", "models/items/lycan/sanguinemoon_weapon/sanguinemoon_weapon.vmdl"}, --4861
	{"model", "models/items/lycan/sanguinemoon_belt/sanguinemoon_belt.vmdl"},--4862
	{"model", "models/items/lycan/sanguinemoon_head/sanguinemoon_head.vmdl"}, --4863

	--Q2 21
	--"models/items/lycan/ultimate/thegreatcalamityti4/thegreatcalamityti4.vmdl",
	--Q2 1a 幼狼
	--"models/items/lycan/wolves/alpha_summon_01/alpha_summon_01.vmdl",
	--Q2 2a 野狼
	--"models/heroes/lycan/summon_wolves.vmdl",

	--Q3 00
	--"models/heroes/life_stealer/life_stealer.vmdl",
	--Q3 10
	{"model", "models/items/lifestealer/ravenous_head/ravenous_head.vmdl"},--6260
	{"model", "models/items/lifestealer/ravenous_arms/ravenous_arms.vmdl"},--6261
	{"model", "models/items/lifestealer/ravenous_belt/ravenous_belt.vmdl"},--6262
	{"model", "models/items/lifestealer/ravenous_back/ravenous_back.vmdl"},--6263
	--Q3 20
	{"model", "models/items/lifestealer/redrage_head/redrage_head.vmdl"},--6318
	{"model", "models/items/lifestealer/redrage_belt/redrage_belt.vmdl"},--6319
	{"model", "models/items/lifestealer/redrage_battlewings/redrage_battlewings.vmdl"},--6320
	{"model", "models/items/lifestealer/redrage_bracers/redrage_bracers.vmdl"},--6321

	--Q4 00
	--"models/heroes/faceless_void/faceless_void.vmdl",
	{"model", "models/heroes/faceless_void/faceless_void_weapon.vmdl"},--15
	{"model", "models/heroes/faceless_void/faceless_void_head.vmdl"},--90
	{"model", "models/heroes/faceless_void/faceless_void_shoulder.vmdl"},--91
	{"model", "models/heroes/faceless_void/faceless_void_bracer.vmdl"},--92
	{"model", "models/heroes/faceless_void/faceless_void_belt.vmdl"},--93

	--Q4 10
	{"model", "models/items/faceless_void/acolyte_belt/acolyte_belt.vmdl"},--5059
	{"model", "models/items/faceless_void/acolyte_cowl/acolyte_cowl.vmdl"},--5060
	{"model", "models/items/faceless_void/acolyte_gauntlet/acolyte_gauntlet.vmdl"},--5061
	{"model", "models/items/faceless_void/acolyte_mace/acolyte_mace.vmdl"},--5062
	{"model", "models/items/faceless_void/acolyte_hood/acolyte_hood.vmdl"},--5063

	--Q4 20
	{"model", "models/items/faceless_void/timelord_bracers/timelord_bracers.vmdl"},--5861
	{"model", "models/items/faceless_void/timelord_head/timelord_head.vmdl"},--5868
	{"model", "models/items/faceless_void/timelord_shoulders/timelord_shoulders.vmdl"},--5896
	{"model", "models/items/faceless_void/timelord_skirt/timelord_skirt.vmdl"},--5897
	{"model", "models/items/faceless_void/timelord_weapon/timelord_weapon.vmdl"},--5898

	--Q5 00
	{"model", "models/items/slark/deep_warden_scimitar/deep_warden_scimitar.vmdl"},--5261
	{"model", "models/items/slark/deep_warden_pauldron/deep_warden_pauldron.vmdl"},--5262
	{"model", "models/items/slark/deep_warden_bracer/deep_warden_bracer.vmdl"},--5263
	{"model", "models/items/slark/deep_warden_cape/deep_warden_cape.vmdl"},--5264
	{"model", "models/items/slark/deep_warden_hood/deep_warden_hood.vmdl"},--5265

	--Q5 10
	{"model", "models/items/slark/deepscoundrel_arms/deepscoundrel_arms.vmdl"},--6417
	{"model", "models/items/slark/deepscoundrel_back/deepscoundrel_back.vmdl"},--6418
	{"model", "models/items/slark/deepscoundrel_weapon/deepscoundrel_weapon.vmdl"},--6419
	{"model", "models/items/slark/deepscoundrel_shoulder/deepscoundrel_shoulder.vmdl"},--6420
	{"model", "models/items/slark/deepscoundrel_head/deepscoundrel_head.vmdl"},--6421

	--Q5 20
	{"model", "models/items/slark/dark_reef_arms/dark_reef_arms.vmdl"},--7710
	{"model", "models/items/slark/dark_reef_back/dark_reef_back.vmdl"},--7711
	{"model", "models/items/slark/dark_reef_head/dark_reef_head.vmdl"},--7712
	{"model", "models/items/slark/dark_reef_shoulders/dark_reef_shoulders.vmdl"},--7713
	{"model", "models/items/slark/dark_reef_weapon/dark_reef_weapon.vmdl"},--7714

	--Q5 21
	{"model", "models/items/slark/oceanconquerer_back/oceanconquerer_back.vmdl"},--6383
	{"model", "models/items/slark/oceanconquerer_shoulder/oceanconquerer_shoulder.vmdl"},--6392
	{"model", "models/items/slark/oceanconquerer_head/oceanconquerer_head.vmdl"},--6405
	{"model", "models/items/slark/oceanconquerer_arms/oceanconquerer_arms.vmdl"},--6406
	{"model", "models/items/slark/oceanconquerer_weapon/oceanconquerer_weapon.vmdl"},--6407

	--W1 00
	--{"model", "models/heroes/sniper/sniper.vmdl"},
	{"model", "models/heroes/sniper/bracer.vmdl"},
	{"model", "models/heroes/sniper/cape.vmdl"},
	{"model", "models/heroes/sniper/headitem.vmdl"},
	{"model", "models/heroes/sniper/shoulder.vmdl"},
	{"model", "models/heroes/sniper/weapon.vmdl"},
	--W1 10	
	{"model", "models/items/sniper/sharpshooter_stache/sharpshooter_stache.vmdl"},
	{"model", "models/items/sniper/killstealer/killstealer.vmdl"},
	{"model", "models/items/sniper/sharpshooter_shoulder/sharpshooter_shoulder.vmdl"},
	{"model", "models/items/sniper/sharpshooter_cloak/sharpshooter_cloak.vmdl"},
	{"model", "models/items/sniper/sharpshooter_arms/sharpshooter_arms.vmdl"},
	--W1 11
	--{"model", "models/heroes/techies/techies.vmdl"},
	{"model", "models/heroes/techies/techies_barrel.vmdl"},
	{"model", "models/heroes/techies/techies_spleen_weapon.vmdl"},
	{"model", "models/heroes/techies/techies_cart.vmdl"},
	{"model", "models/heroes/techies/techies_spleen_costume.vmdl"},
	--W1 20
	{"model", "models/items/sniper/wildwest_weapon/wildwest_weapon.vmdl"},
	{"model", "models/items/sniper/wildwest_head/wildwest_head.vmdl"},
	{"model", "models/items/sniper/wildwest_back/wildwest_back.vmdl"},
	{"model", "models/items/sniper/wildwest_shoulders/wildwest_shoulders.vmdl"},
	{"model", "models/items/sniper/wildwest_arms/wildwest_arms.vmdl"},
	--W1 21
	{"model", "models/items/techies/bigshot/bigshot.vmdl"},
	{"model", "models/items/techies/bigshot/bigshot_spleen_costume.vmdl"},
	{"model", "models/items/techies/bigshot/bigshot_squee_costume.vmdl"},
	{"model", "models/items/techies/bigshot/bigshot_barrel.vmdl"},
	{"model", "models/items/techies/bigshot/bigshot.vmdl"},
	
	--W2 00  models/heroes/huskar/huskar.vmdl
	{"model", "models/heroes/huskar/huskar_spear.vmdl"},--268
	{"model", "models/heroes/huskar/huskar_dagger.vmdl"},--269
	{"model", "models/heroes/huskar/huskar_helmet.vmdl"},--270
	{"model", "models/heroes/huskar/huskar_shoulder.vmdl"},--271
	{"model", "models/heroes/huskar/huskar_bracer.vmdl"},--272

	--W2 10
	{"model", "models/items/huskar/sacred_bones_offhand_weapon/sacred_bones_offhand_weapon.vmdl"}, --4906
	{"model", "models/items/huskar/sacred_bones_shoulder/sacred_bones_shoulder.vmdl"}, --4907
	{"model", "models/items/huskar/sacred_bones_arms/sacred_bones_arms.vmdl"}, --4908
	{"model", "models/items/huskar/sacred_bones_helmet/sacred_bones_helmet.vmdl"},--4909
	{"model", "models/items/huskar/sacred_bones_spear/sacred_bones_spear.vmdl"}, --4910

	--W2 20
	{"model", "models/items/huskar/obsidian_claw_of_the_jaguar_arms/obsidian_claw_of_the_jaguar_arms.vmdl"}, --4299
	{"model", "models/items/huskar/obsidian_claw_of_the_jaguar_helmet/obsidian_claw_of_the_jaguar_helmet.vmdl"},--4300
	{"model", "models/items/huskar/obsidian_claw_of_the_jaguar_shoulder/obsidian_claw_of_the_jaguar_shoulder.vmdl"},--4301
	{"model", "models/items/huskar/obsidian_blade_spear/obsidian_blade_spear.vmdl"},--4748
	{"model", "models/items/huskar/obsidian_claw_of_the_jaguar_dagger/obsidian_claw_of_the_jaguar_dagger.vmdl"},--4749

	--W3 00 models/heroes/clinkz/clinkz.vmdl
	{"model", "models/heroes/clinkz/clinkz_head.vmdl"}, --56 通用
	{"model", "models/heroes/clinkz/clinkz_bow.vmdl"},  --57
	{"model", "models/heroes/clinkz/clinkz_pads.vmdl"},  --58
	{"model", "models/heroes/clinkz/clinkz_back.vmdl"},  --59
	{"model", "models/heroes/clinkz/clinkz_horns.vmdl"}, --60
	{"model", "models/heroes/clinkz/clinkz_gloves.vmdl"}, --61

	--W3 10
	{"model", "models/items/clinkz/clinkz_weapon_goc/clinkz_weapon_goc.vmdl"},--4741
	{"model", "models/items/clinkz/clinkz_shoulders_goc/clinkz_shoulders_goc.vmdl"},--4742
	{"model", "models/items/clinkz/clinkz_helmet01_goc/clinkz_helmet01_goc.vmdl"},--4971
	{"model", "models/items/clinkz/clinkz_hands_goc/clinkz_hands_goc.vmdl"},--4972
	{"model", "models/items/clinkz/clinkz_back_goc/clinkz_back_goc.vmdl"},--4973

	--W3 20
	{"model", "models/items/clinkz/lost_viking_back/lost_viking_back.vmdl"},--5151
	{"model", "models/items/clinkz/lost_viking_bow/lost_viking_bow.vmdl"},--5152
	{"model", "models/items/clinkz/lost_viking_gauntlet/lost_viking_gauntlet.vmdl"},--5153
	{"model", "models/items/clinkz/lost_viking_helmet/lost_viking_helmet.vmdl"},--5154
	{"model", "models/items/clinkz/lost_viking_shoulder/lost_viking_shoulder.vmdl"},--5155

	--W4 00 models/heroes/lanaya/lanaya.vmdl
	{"model", "models/heroes/lanaya/lanaya_hair.vmdl"},--173
	{"model", "models/heroes/lanaya/lanaya_cowl_shoulder.vmdl"},--174
	{"model", "models/heroes/lanaya/lanaya_bracers_skirt.vmdl"},--175

	--W4 10
	{"model", "models/items/lanaya/thiefscholar_girdle/thiefscholar_girdle.vmdl"}, --4695
	{"model", "models/items/lanaya/thiefscholar_coiffure/thiefscholar_coiffure.vmdl"},--4696
	{"model", "models/items/lanaya/thiefscholar_shoulder/thiefscholar_shoulder.vmdl"},--4697

	--W4 20
	{"model", "models/items/lanaya/ta_ns_shoulder/ta_ns_shoulder.vmdl"},--4668
	{"model", "models/items/lanaya/ta_ns_armor/ta_ns_armor.vmdl"},--4669
	{"model", "models/items/lanaya/ta_ns_head/ta_ns_head.vmdl"},--4670

	--W5 00 models/heroes/shadowshaman/shadowshaman.vmdl
	{"model", "models/heroes/shadowshaman/head.vmdl"},--251  通用
	{"model", "models/items/shadowshaman/shades_weapon/shades_weapon.vmdl"},--6197
	{"model", "models/items/shadowshaman/shades_offhand/shades_offhand.vmdl"},--6198
	{"model", "models/items/shadowshaman/shades_belt/shades_belt.vmdl"},--6206
	{"model", "models/items/shadowshaman/shades_arms/shades_arms.vmdl"},--6309
	{"model", "models/items/shadowshaman/shades_head/shades_head.vmdl"}, --6310

	--W5 10
	{"model", "models/items/shadowshaman/vagabond_pack/vagabond_pack.vmdl"}, --4412
	{"model", "models/items/shadowshaman/vagabond_wand/vagabond_wand.vmdl"},--4416
	{"model", "models/items/shadowshaman/vagabond_hat/vagabond_hat.vmdl"},--4417
	{"model", "models/items/shadowshaman/vagabond_drink/vagabond_drink.vmdl"},--4419

	--W5 20
	{"model", "models/items/shadowshaman/tangki_offhand/tangki_offhand.vmdl"},--6814
	{"model", "models/items/shadowshaman/tangki_weapon/tangki_weapon.vmdl"},--6816
	{"model", "models/items/shadowshaman/tangki_arms/tangki_arms.vmdl"},--6817
	{"model", "models/items/shadowshaman/tangki_belt/tangki_belt.vmdl"},--6818
	{"model", "models/items/shadowshaman/tangki_head/tangki_head.vmdl"},--6819

	--W5 21
	{"model", "models/items/shadowshaman/eki_bukaw_bracers/eki_bukaw_bracers.vmdl"},--5501
	{"model", "models/items/shadowshaman/records_of_the_eki_bukaw/records_of_the_eki_bukaw.vmdl"},--5500
	{"model", "models/items/shadowshaman/eki_bukaw_wand__offhand/eki_bukaw_wand__offhand.vmdl"},--5503
	{"model", "models/items/shadowshaman/eki_bukaw_wand/eki_bukaw_wand.vmdl"},--5504
	{"model", "models/items/shadowshaman/visage_of_eki_bukaw/visage_of_eki_bukaw.vmdl"},--5548

	--E1 00 models/heroes/tiny_02/tiny_02.vmdl
	{"model", "models/heroes/tiny_02/tiny_02_body.vmdl"},--494
	{"model", "models/heroes/tiny_02/tiny_02_head.vmdl"},--493
	{"model", "models/heroes/tiny_02/tiny_02_left_arm.vmdl"},--495
	{"model", "models/heroes/tiny_02/tiny_02_right_arm.vmdl"},--496

	--E1 10  
	{"model", "models/items/tiny/scarletquarry_arms/scarletquarry_arms.vmdl"},--6886
	{"model", "models/items/tiny/scarletquarry_offhand/scarletquarry_offhand.vmdl"},--6998
	{"model", "models/items/tiny/scarletquarry_head/scarletquarry_head.vmdl"},--6999
	{"model", "models/items/tiny/scarletquarry_armor/scarletquarry_armor.vmdl"},--7000


	--E2 00 models/heroes/undying/undying.vmdl
	{"model", "models/heroes/undying/undying_helmet.vmdl"}, --392
	{"model", "models/heroes/undying/undying_armor.vmdl"}, --393

	--E2 10 models/heroes/undying/undying_flesh_golem.vmdl

 	--E2 1a models/heroes/undying/undying_minion.vmdl

	--E3 00 models/heroes/wraith_king/wraith_king.vmdl
	{"model", "models/heroes/wraith_king/wraith_king_chest.vmdl"}, --500 通用
	{"model", "models/items/wraith_king/eternal_arms/eternal_arms.vmdl"},--6171
	{"model", "models/items/wraith_king/eternal_back/eternal_back.vmdl"}, --6172
	{"model", "models/items/wraith_king/eternal_blade/eternal_blade.vmdl"}, --6173
	{"model", "models/items/wraith_king/eternal_head/eternal_head.vmdl"},--6174
	{"model", "models/items/wraith_king/eternal_shoulder/eternal_shoulder.vmdl"},--6175

	--E3 10
	{"model", "models/items/wraith_king/regalia_of_the_wraith_lord_back/regalia_of_the_wraith_lord_back.vmdl"},--5052
	{"model", "models/items/wraith_king/regalia_of_the_wraith_lord_sword/regalia_of_the_wraith_lord_sword.vmdl"},--5053
	{"model", "models/items/wraith_king/regalia_of_the_wraith_lord_bracers/regalia_of_the_wraith_lord_bracers.vmdl"},--5054
	{"model", "models/items/wraith_king/regalia_of_the_wraith_lord_helmet/regalia_of_the_wraith_lord_helmet.vmdl"},--5055
	{"model", "models/items/wraith_king/regalia_of_the_wraith_lord_shoulder/regalia_of_the_wraith_lord_shoulder.vmdl"},--5056

	--E4 00 models/heroes/shredder/shredder.vmdl
	{"model", "models/heroes/shredder/shredder_driver_hat.vmdl"},--386
	{"model", "models/heroes/shredder/shredder_chainsaw.vmdl"},--388(注意不连贯)
	{"model", "models/heroes/shredder/shredder_shoulders.vmdl"},--389
	{"model", "models/heroes/shredder/shredder_body.vmdl"},--390
	{"model", "models/heroes/shredder/shredder_blade.vmdl"},--400
	{"model", "models/heroes/shredder/shredder_armor.vmdl"},--401
	{"model", "models/heroes/shredder/shredder_hook.vmdl"},--402

	--E4 10
	{"model", "models/items/shredder/timberthaw_armor/timberthaw_armor.vmdl"},--6519
	{"model", "models/items/shredder/timberthaw_weapon/timberthaw_weapon.vmdl"},--6520
	{"model", "models/items/shredder/timberthaw_head/timberthaw_head.vmdl"},--6521
	{"model", "models/items/shredder/timberthaw_offhand/timberthaw_offhand.vmdl"},--6522
	{"model", "models/items/shredder/timberthaw_shoulder/timberthaw_shoulder.vmdl"},--6523
	{"model", "models/items/shredder/timberthaw_back/timberthaw_back.vmdl"},--6524

	--E5 00 models/heroes/chaos_knight/chaos_knight.vmdl
	{"model", "models/items/chaos_knight/chaos_legion_mount/chaos_legion_mount.vmdl"},--5980
	{"model", "models/items/chaos_knight/chaos_legion_drapes/chaos_legion_drapes.vmdl"},--5981
	{"model", "models/items/chaos_knight/chaos_legion_helm/chaos_legion_helm.vmdl"},--5982
	{"model", "models/items/chaos_knight/chaos_legion_shield/chaos_legion_shield.vmdl"},--5983
	{"model", "models/items/chaos_knight/chaos_legion_weapon/chaos_legion_weapon.vmdl"},--5984

	--E5 10
	{"model", "models/items/chaos_knight/ck_esp_blade/ck_esp_blade.vmdl"},--5518
	{"model", "models/items/chaos_knight/ck_esp_helm/ck_esp_helm.vmdl"},--5519
	{"model", "models/items/chaos_knight/ck_esp_mount/ck_esp_mount.vmdl"},--5520
	{"model", "models/items/chaos_knight/ck_esp_shield/ck_esp_shield.vmdl"},--5521
	{"model", "models/items/chaos_knight/ck_esp_shoulder/ck_esp_shoulder.vmdl"},--5522

	--E5 11
	{"model", "models/items/chaos_knight/rising_chaos_blade/rising_chaos_blade.vmdl"},--5921
	{"model", "models/items/chaos_knight/rising_chaos_helm/rising_chaos_helm.vmdl"},--5922
	{"model", "models/items/chaos_knight/rising_chaos_spaulders/rising_chaos_spaulders.vmdl"},--5923
	{"model", "models/items/chaos_knight/rising_chaos_steed/rising_chaos_steed.vmdl"},--5924
	{"model", "models/items/chaos_knight/rising_chaos_shield/rising_chaos_shield.vmdl"},--5925

	--E6 00 models/heroes/nerubian_assassin/nerubian_assassin.vmdl
	{"model", "models/items/nerubian_assassin/nyx_dusky_back/nyx_dusky_back.vmdl"},--5567
	{"model", "models/items/nerubian_assassin/nyx_dusky_head/nyx_dusky_head.vmdl"},--5568
	{"model", "models/items/nerubian_assassin/nyx_dusky_misc/nyx_dusky_misc.vmdl"},--5569
	{"model", "models/items/nerubian_assassin/nyx_dusky_weapon/nyx_dusky_weapon.vmdl"},--5570

	--E6 10	
	{"model", "models/items/nerubian_assassin/spines_of_the_predator/spines_of_the_predator.vmdl"},--5201
	{"model", "models/items/nerubian_assassin/mind_piercer_of_the_predator/mind_piercer_of_the_predator.vmdl"},--5202
	{"model", "models/items/nerubian_assassin/preyfinders_of_the_predator/preyfinders_of_the_predator.vmdl"},--5203
	{"model", "models/items/nerubian_assassin/blades_of_the_predator/blades_of_the_predator.vmdl"},--5204

	--E6 11 models/heroes/broodmother/broodmother.vmdl (和E6 10模型不一样)
	{"model", "models/items/broodmother/abdomen_of_perception/abdomen_of_perception.vmdl"},--5854
	{"model", "models/items/broodmother/crown_of_perception/crown_of_perception.vmdl"}, --5891
	{"model", "models/items/broodmother/legs_of_perception/legs_of_perception.vmdl"}, --5892
	
	--E6 1a  models/heroes/broodmother/spiderling.vmdl










	}


	     
	print("loading shiping")
	local t=#zr;
	for i=1,t do
	   	PrecacheResource( zr[i][1], zr[i][2], context)
	end

	print("done loading shiping")


end

function PrecacheEverythingFromTable( context, kvtable)
	for key, value in pairs(kvtable) do
		if type(value) == "table" then
			PrecacheEverythingFromTable( context, value )
		else
			if string.find(value, "vpcf") then
				PrecacheResource( "particle",  value, context)
				print("PRECACHE PARTICLE RESOURCE", value)
			end
			if string.find(value, "vmdl") then 	
				PrecacheResource( "model",  value, context)
				print("PRECACHE MODEL RESOURCE", value)
			end
			if string.find(value, "vsndevts") then
				PrecacheResource( "soundfile",  value, context)
				print("PRECACHE SOUND RESOURCE", value)
			end
		end
	end	   
end


function Precache( context )


  	print("BEGIN TO PRECACHE RESOURCE")
	local time = GameRules:GetGameTime()
	PrecacheEveryThingFromKV( context )
	time = time - GameRules:GetGameTime()
	print("DONE PRECACHEING IN:"..tostring(time).."Seconds")

	--PrecacheParticle( "particles/econ/events/ti4/teleport_start_ti4.vpcf", context )
	PrecacheParticle( "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", context )
	

end

--游戏载入和事件监听
function Activate()
	GameRules.btf = CbtfGameMode()
	GameRules.btf:InitGameMode()
end


function CbtfGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 0.1 )
    --GameRules:GetGameModeEntity():SetThink( "RoundThinker", self, "GlobalThink", 1 )
    --GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("RoundThinker"), "RoundThinker", 0.1)
    
    --隐藏原有面板
    mode = GameRules:GetGameModeEntity()
    mode:SetHUDVisible(1, false) --顶部英雄栏
    mode:SetHUDVisible(9, false) --信使栏
    mode:SetHUDVisible(12, false) --推荐物品栏
    mode:SetHUDVisible(8, false)  --快速购买

    Convars:SetInt("dota_render_crop_height", 0)
	Convars:SetInt("dota_render_y_inset", 0)


    --设置游戏准备时间
    GameRules:SetPreGameTime( 15)
	--重复选择英雄
	GameRules:SetSameHeroSelectionEnabled(true)    

	--取消自动增加金钱
	GameRules:SetGoldPerTick(0)

	--监听游戏
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(CbtfGameMode,"OnGameRulesStateChange"), self) --规则改变
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(CbtfGameMode, "OnNPCSpawned"), self) --单位重生和创建
	ListenToGameEvent("entity_killed", Dynamic_Wrap(CbtfGameMode, "OnEntityKilled"), self) 	--单位被杀死
	ListenToGameEvent("dota_unit_event", Dynamic_Wrap(CbtfGameMode, "OnEvent"), self) 	--???

end


--触发事件 游戏规则改变
function CbtfGameMode:OnGameRulesStateChange( keys )
    print("OnGameRulesStateChange")
 	DeepPrintTable(keys)    --详细打印传递进来的表
    --获取游戏进度
    local newState = GameRules:State_Get()
 	--初始化
 	if newState==DOTA_GAMERULES_STATE_INIT then

    --开始选择英雄
    elseif newState==DOTA_GAMERULES_STATE_HERO_SELECTION then
   	    runTable()
    --游戏开始
    elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
        print("Player ready game begin")  --玩家处于游戏准备状态
		playerstarts:playertable()
       	chushihua:SpawnBuildBase() --刷王和地基等物体


    elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        print("Player game begin")  --玩家开始游戏
		chushihua:SetConKing()
	        
    end
end

--触发事件 单位重生和创建
function CbtfGameMode:OnNPCSpawned( keys )
	local trigger_unit = EntIndexToHScript(keys.entindex)
	--是英雄的话 传送到开始点
	if trigger_unit:IsRealHero() ==true then
		print("One hero has entered the game.")
		local player = trigger_unit:GetOwner() 
		trigger_unit.Player=player
		local pid = player:GetPlayerID()
		print("The player ID of that hero is " .. tostring(pid))
		print(tostring(player))
		if player.Init == nil then
			playerstarts:init(pid,trigger_unit) 
		end
		--chushihua:SetConKing(pid) --设置王的控制权
		--chushihua:SetConKing(trigger_unit) --设置王的控制权
		local start_ent = Entities:FindByName(nil,  "portal"..tostring(pid+1)) or  Entities:FindByName(nil,  "startpoint"..tostring(pid))
        local start_point = start_ent:GetAbsOrigin() 
        player:SetContextThink(DoUniqueString("telepor_later"), function() FindClearSpaceForUnit(trigger_unit, start_point, true) end, 0.1)--传送到开始点
        PlayerS[pid].Hero = trigger_unit				--传递参数给玩家表
        PlayerResource:SetCameraTarget(pid, trigger_unit) --锁定并移动镜头 	
		PlayerResource:SetGold(pid,PlayerS[pid].Gold, false) --设置初始金钱
        --[[
        print(PlayerS[pid].StartPoint)
        print(trigger_unit:GetOrigin())
        print("its ok")
        print(PlayerS[pid].Hero:GetName())
        --]]
        player:SetContextThink(DoUniqueString("camera_later"), function() PlayerResource:SetCameraTarget(pid, nil)  end, 3)--3秒后解锁
   		trigger_unit:SetAbilityPoints(0)                --取消技能点
		    
		local j=0
      
		for j = 0,5,1 do
		    local temp=trigger_unit:GetAbilityByIndex(j) --获取技能实体

		    if temp then
		        temp:SetLevel(1)                     --设置技能等级
		    end

		end
	end

end


--单位被杀死
function CbtfGameMode:OnEntityKilled(keys)
	local killed_unit = EntIndexToHScript( keys.entindex_killed )
	if killed_unit == king_left then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end
	if killed_unit == king_right then
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end

	---------- AI Functions by Tiny Night ----------
	local u_killer = EntIndexToHScript( keys.entindex_attacker )
	local u_victim = EntIndexToHScript( keys.entindex_killed )

	AIManager:SendAction( u_killer, u_victim, 0, "Kill" )
	AIManager:SendAction( u_victim, u_killer, 0, "Killed" )
end

function CbtfGameMode:OnEvent(keys)
	print("---------- UnKnow Dota Event ----------")
	DeepPrintTable(keys)
end

--循环计时器 循环检查当前游戏规则
function CbtfGameMode:OnThink()  


	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			self.UpdateScoreboard()
			RoundThinker()
		--print("is runing")
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end


	return 0.1
end

--记分牌
function CbtfGameMode:UpdateScoreboard()
	local NextTime = RoundThinker_next /10
	UTIL_ResetMessageTextAll()
	UTIL_MessageTextAll( "", 255, 255, 255, 255 )
	UTIL_MessageTextAll( "", 255, 255, 255, 255 )
	UTIL_MessageTextAll( "", 255, 255, 255, 255 )
	UTIL_MessageTextAll( "#ScoreboardTitle", 255, 255, 255, 255 )
	UTIL_MessageTextAll( "#ScoreboardSeparator", 255, 255, 255, 255 )
	UTIL_MessageTextAll_WithContext( "#ScoreboardNextWave", 255, 255, 255, 255, {value = RoundThinker_wave+1} ) 
	UTIL_MessageTextAll_WithContext( "#ScoreboardNextTime", 255, 255, 255, 255, {value = NextTime+1 } )
	UTIL_MessageTextAll( "#ScoreboardSeparator", 255, 255, 255, 255 )
	for _, player in pairs( AllPlayers ) do
		local pid = player:GetPlayerID() 
		--print("The gotten pid in AllPlayers is " .. tostring(pid))
		PlayerS[pid].Gold = PlayerResource:GetGold(pid)  --金币绑定
		local GoldNum = PlayerS[pid].Gold
		local LumberNum = PlayerS[pid].Lumber
		local CurFoodNum = PlayerS[pid].CurFood
		local FullFoodNum = PlayerS[pid].FullFood
		local TechNum = PlayerS[pid].Tech
		local FarmerNum = PlayerS[pid].FarmerNum
		local ScoreNum = PlayerS[pid].Score
		local IncomeNum = PlayerS[pid].Income
		--print("player  "..pid.."lum is " .. LumberNum)
		pid = PlayerCalc:GetPlayerIndex(player) --把玩家的position的ID转化成counting的ID
		--print("The pid used to print is " .. tostring(pid))

		--UTIL_MessageText_WithContext( pid,"#ScoreboardPlayerID", 255, 204, 51, 255, { value = pid } ) --test
		UTIL_MessageText_WithContext( pid,"#ScoreboardGold", 255, 204, 51, 255, { value = GoldNum } )
		UTIL_MessageText_WithContext( pid,"#ScoreboardLumber", 0, 255, 255, 255, { value = LumberNum } )
		UTIL_MessageText( pid,"#ScoreboardSeparator", 255, 255, 255, 255 )
		UTIL_MessageText_WithContext( pid,"#ScoreboardCurFood", 255, 177, 102, 255, { value = CurFoodNum})
		--print(tostring(FullFoodNum))
		UTIL_MessageText_WithContext( pid,"#ScoreboardFullFood", 255, 128, 0, 255, { value = FullFoodNum})
		UTIL_MessageText( pid,"#ScoreboardSeparator", 255, 255, 255, 255 )
		UTIL_MessageText_WithContext( pid,"#ScoreboardFarmerNum", 51, 255, 153, 255, { value = FarmerNum } )			
		UTIL_MessageText_WithContext( pid,"#ScoreboardTech", 0, 255, 92, 255, { value = TechNum } )
		UTIL_MessageText_WithContext( pid,"#ScoreboardIncome", 255, 204, 51, 255, { value = IncomeNum } )
		UTIL_MessageText( pid,"#ScoreboardSeparator", 255, 255, 255, 255 )
		UTIL_MessageText_WithContext( pid,"#ScoreboardScore", 255, 61, 61, 255, { value = ScoreNum } )
		UTIL_MessageText( pid,"#ScoreboardSeparator", 255, 255, 255, 255 )

	end
	if king_left ~= nil and king_right~= nil then
		local leftHP = king_left:GetHealthPercent()
		local rightHP = king_right:GetHealthPercent()

		UTIL_MessageTextAll_WithContext( "#ScoreboardleftHP", 255, 255, 255, 255, { value = leftHP } )
		UTIL_MessageTextAll_WithContext( "#ScoreboardrightHP", 255, 255, 255, 255, { value = rightHP } )
		UTIL_MessageTextAll( "#ScoreboardSeparator", 255, 255, 255, 255 )
	end


end	



--建立带有默认值的表
function table_new(n)
	local mt = {}
	function mt.__index()
		return n
	end
	function mt.__call(t, nt)
		mt.__call = nil
		--print(nt)
		return setmetatable(nt, mt)

	end
	return setmetatable({}, mt)
end






--[[
攻防相克表
攻击类型   混乱 L 普通攻击 B 魔法攻击 M 穿刺攻击 P  攻城攻击 S 英雄 H
护甲类型   重甲 Z  中甲 S   轻甲 W  坚甲城甲 C   无甲 B   英雄 H

技能名字AL 混乱  AB普通  AM魔法 AP穿刺 AS攻城 AH英雄
		DZ 重甲  DS中甲  DW轻甲 DC城甲 DB无甲 DH英雄

]]
	function runTable() 

	AandD_table = 	table_new(100) 
				{ 
						BZ = 90,
						BS = 130,
						BW = 80,
						BC = 90,
						BB = 100,
						BH = 85,
						PZ = 80,
						PS = 100,
						PW = 130,
						PC = 80,										
					 	PB = 100,
					 	PH = 85,
						MZ = 130,
						MS = 80,
						MW = 110,
						MC = 70,
						MB = 100,
						MH = 85,
						SZ = 90,
						SS = 90,
						SW = 80,
						SC = 130,
						SB = 100,
						SH = 85,
						LZ = 110,
						LS = 110,
						LW = 110,
						LC = 110,
						LB = 110,
						LH = 110,
						HZ = 100,
						HS = 100,
						HW = 100,
						HC = 100,
						HB = 100,
						HH = 100,
				}
				  
				rawset(_G, 'AandD_table', AandD_table) --声明全局变量
				
		print(AandD_table)


		--if AllTypes == nil then
			--AllTypes = { Q={},W={},E={},"D"={},"F"={},"R"={} }
		--	AllTypes = {}
		--end
		--	AllTypes = {
		--				Q={},
		--				W={},
		--				}		
			--AllTypes["Q"] = {}
			--AllTypes["W"] = {}


	--AllTypes["Q"][1] = "Q1_00"

		--AllTypes["W"][1] = "W1_00"
		--rawset(_G, 'AllTypes', AllTypes) --声明全局变量
		--print(getmetatable(_G).__index)
		--print(getmetatable(_ENV).__newindex)
		end


