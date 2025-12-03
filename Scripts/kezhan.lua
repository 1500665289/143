local KeZhan = GameMain:GetMod("KeZhan");
local tbEvent = GameMain:GetMod("_Event");
local NPCING = {0,0,0,0}
local ID = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,2001,2002,2003,2004,2005,2006,2007,2008,3001,10001,10002,10003,10004,
-- 添加170043149到170043173
170043149,170043150,170043151,170043152,170043153,170043154,170043155,170043156,170043157,170043158,170043159,170043160,170043161,170043162,170043163,170043164,170043165,170043166,170043167,170043168,170043169,170043170,170043171,170043172,170043173}
local NewID = {}
local OldID = {}
local LunHui = {}

function KeZhan:OnInit()

end

function KeZhan:OnEnter()
	tbEvent:RegisterEvent(g_emEvent.SecretUpdate, KeZhan.OnSecretUpdate, "KeZhan")
end

function KeZhan:OnLeave()
	tbEvent:UnRegisterEvent(g_emEvent.SecretUpdate, "KeZhan")
end

function KeZhan.OnSecretUpdate(t,obj)
	if PlacesMgr:IsLocked("Place_KeZhan") == true then
		if MapStoryMgr:HasSecret(27961) == true then
			PlacesMgr:UnLockPlace("Place_KeZhan");
			MapStoryMgr:GetSecretDef(27961).Hide = true
		end
	end
end

function KeZhan:GeRandomModNpc()
	NewID = {};
	for k,v in pairs(NpcMgr:GetReincarnateIDs()) do
		if k >= 107 and v ~= 5288 and v ~= 5289 and v ~= 5290 and v ~= 5291 then
			NewID[k] = v;
		end
	end
	return NewID;
end

function KeZhan:GetAllModNpcID()
	NewID = {};
	local i = 1;
	for k,v in pairs(NpcMgr:GetReincarnateIDs()) do
		if k >= 107 and v ~= 5288 and v ~= 5289 and v ~= 5290 and v ~= 5291 then
			NewID[i] = v;
			i = i + 1;
		end
	end
	return NewID;
end

function KeZhan:GetAllModNpcName()
	NewID = {};
	LunHui = {}
	local i = 1;
	for k,v in pairs(NpcMgr:GetReincarnateIDs()) do
		if k >= 107 and v ~= 5288 and v ~= 5289 and v ~= 5290 and v ~= 5291 then
			NewID[i] = v;
			i = i + 1;
		end
	end
	for k,v in pairs(NewID) do
		LunHui[k] = NpcMgr:GetReincarnateDataByID(v).LastName..NpcMgr:GetReincarnateDataByID(v).FristName
	end
	LunHui[#LunHui + 1] = "离开此地"
	return LunHui;
end

function KeZhan:Secrets_KZ_Choice()
	xlua.private_accessible(CS.XiaWorld.NpcRandomMechine)
	local Npc = me;
	local npc = nil;
	local name = Npc.npcObj.Name
	local NameList = KeZhan:GetAllModNpcName()
	local IDList = KeZhan:GetAllModNpcID()
	world:ShowStoryBox(""..name.."环顾了四周天宫降临的奇人，想要邀请他们加入自己的门派。", "天宫奇人",NameList,
	function(Key)
		local key = Key + 1;
		if key == #NameList then
			world:ShowMsgBox(""..name.."想了想，决定还是不冒险，转身离去。","离开客栈");
		else
			local ID = IDList[key]
			local reincarnateDataByID = NpcMgr:GetReincarnateDataByID(ID);
			if reincarnateDataByID.Race == "Human" or reincarnateDataByID.Race == nil then
				npc = CS.XiaWorld.NpcRandomMechine._RandomNpc("Human", reincarnateDataByID.Sex, 0, reincarnateDataByID.LastName, reincarnateDataByID.FristName, true, reincarnateDataByID)
			else
				npc = CS.XiaWorld.NpcRandomMechine._RandomNpc(reincarnateDataByID.Race, reincarnateDataByID.Sex, 0, reincarnateDataByID.LastName, reincarnateDataByID.FristName, true, reincarnateDataByID)
			end
			CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,CS.XiaWorld.World.Instance.map:RandomBronGrid(),Map,CS.XiaWorld.Fight.g_emFightCamp.Player);
			npc:ChangeRank(CS.XiaWorld.g_emNpcRank.Worker);
			world:ShowMsgBox(""..name.."一眼过去就看中了眼前的这个人并热情的邀请他去参观该门派，【"..NpcMgr:GetReincarnateDataByID(ID).LastName..NpcMgr:GetReincarnateDataByID(ID).FristName.."】禁不住"..name.."的热情邀请，最终同意与他前往参观门派（监狱）。","邀请加入")
			KeZhan:AddOldID(ID)
		end
	end);
end

function KeZhan:Secrets_KZ_Random()
	local Npc = me;
	local npc = nil;
	local name = Npc.npcObj.Name;
	local IDList = KeZhan:GetAllModNpcID();
	world:SetRandomSeed();
	local rate = me:RandomInt(1,#IDList);
	local reincarnateDataByID = NpcMgr:GetReincarnateDataByID(IDList[rate]);
	xlua.private_accessible(CS.XiaWorld.NpcRandomMechine);
	if reincarnateDataByID.Race == "Human" or reincarnateDataByID.Race == nil then
		npc = CS.XiaWorld.NpcRandomMechine._RandomNpc("Human", reincarnateDataByID.Sex, 0, reincarnateDataByID.LastName, reincarnateDataByID.FristName, true, reincarnateDataByID)
	else
		npc = CS.XiaWorld.NpcRandomMechine._RandomNpc(reincarnateDataByID.Race, reincarnateDataByID.Sex, 0, reincarnateDataByID.LastName, reincarnateDataByID.FristName, true, reincarnateDataByID);
	end
	CS.XiaWorld.NpcMgr.Instance:AddNpc(npc,Map:RandomBronGrid(),Map,CS.XiaWorld.Fight.g_emFightCamp.Player);
	npc:ChangeRank(CS.XiaWorld.g_emNpcRank.Worker);
	world:ShowMsgBox(""..NpcMgr:GetReincarnateDataByID(IDList[rate]).Desc.."",""..NpcMgr:GetReincarnateDataByID(IDList[rate]).LastName..NpcMgr:GetReincarnateDataByID(IDList[rate]).FristName.."");
	me:AddMsg(""..name.."一眼过去就看中了眼前的这个人并热情的邀请他去参观该门派，【"..NpcMgr:GetReincarnateDataByID(IDList[rate]).LastName..NpcMgr:GetReincarnateDataByID(IDList[rate]).FristName.."】禁不住"..name.."的热情邀请，最终同意与他前往参观门派（监狱）。");
	KeZhan:AddOldID(IDList[rate]);
end

function KeZhan:AddOldID(ID)
	OldID[ID] = (OldID[ID] or 0) + 1;
end

function KeZhan:GetNPC(i)
	if NPCING[i] == 0 then
		return true;
	else
		return false;
	end
end

function KeZhan:AddNPC(i)
	NPCING[i] = 1;
	return
end

function KeZhan:GetID()
	world:SetRandomSeed()
	local id = me:RandomInt(1,#ID)
	return ID[id];
end

function KeZhan:OnSave()
	local tbSave = { index1 = NPCING , index2 = OldID };
	return tbSave;
end

function KeZhan:OnLoad(tbLoad)
	if tbLoad ~= nil then
		NPCING = tbLoad["index1"];
		OldID = tbLoad["index2"];
	end
end
