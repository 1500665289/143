local KeZhan = GameMain:GetMod("KeZhan");
local tbEvent = GameMain:GetMod("_Event");
local NPCING = {0,0,0,0}
local ID = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,2001,2002,2003,2004,2005,2006,2007,2008,3001,10001,10002,10003,10004}
local NewID = {}
local OldID = {}
local LunHui = {}

function KeZhan:OnInit()
    -- 初始化代码可以放在这里
end

function KeZhan:OnEnter()
    tbEvent:RegisterEvent(g_emEvent.SecretUpdate, self.OnSecretUpdate, "KeZhan")
end

function KeZhan:OnLeave()
    tbEvent:UnRegisterEvent(g_emEvent.SecretUpdate, "KeZhan")
end

function KeZhan.OnSecretUpdate(t, obj)
    if PlacesMgr:IsLocked("Place_KeZhan") == true then
        if MapStoryMgr:HasSecret(27961) == true then
            PlacesMgr:UnLockPlace("Place_KeZhan");
            MapStoryMgr:GetSecretDef(27961).Hide = true
        end
    end
end

function KeZhan:GeRandomModNpc()
    NewID = {};
    for k, v in pairs(NpcMgr:GetReincarnateIDs()) do
        if k >= 107 and v ~= 5288 and v ~= 5289 and v ~= 5290 and v ~= 5291 and OldID[v] == nil then
            NewID[k] = v;
        end
    end
    return NewID;
end

function KeZhan:GetAllModNpcID()
    NewID = {};
    local i = 1;
    for k, v in pairs(NpcMgr:GetReincarnateIDs()) do
        if k >= 107 and v ~= 5288 and v ~= 5289 and v ~= 5290 and v ~= 5291 and OldID[v] == nil then
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
    for k, v in pairs(NpcMgr:GetReincarnateIDs()) do
        if k >= 107 and v ~= 5288 and v ~= 5289 and v ~= 5290 and v ~= 5291 and OldID[v] == nil then
            NewID[i] = v;
            i = i + 1;
        end
    end
    
    for k, v in ipairs(NewID) do
        local npcData = NpcMgr:GetReincarnateDataByID(v)
        if npcData then
            LunHui[k] = (npcData.LastName or "") .. (npcData.FristName or "")
        else
            LunHui[k] = "未知NPC"
        end
    end
    LunHui[#LunHui + 1] = "离开此地"
    return LunHui;
end

function KeZhan:AddOldID(ID)
    if ID then
        OldID[ID] = 1;
    end
end

function KeZhan:GetNPC(i)
    if i and i >= 1 and i <= #NPCING then
        return NPCING[i] == 0;
    end
    return false;
end

function KeZhan:AddNPC(i)
    if i and i >= 1 and i <= #NPCING then
        NPCING[i] = 1;
    end
end

function KeZhan:GetID()
    if not me then
        return ID[1] or 1; -- 默认返回第一个ID
    end
    
    world:SetRandomSeed()
    local idIndex = me:RandomInt(1, #ID)
    return ID[idIndex] or ID[1] or 1;
end

function KeZhan:OnSave()
    local tbSave = { 
        index1 = NPCING, 
        index2 = OldID 
    };
    return tbSave;
end

function KeZhan:OnLoad(tbLoad)
    if tbLoad then
        if tbLoad.index1 and type(tbLoad.index1) == "table" then
            NPCING = tbLoad.index1;
        end
        if tbLoad.index2 and type(tbLoad.index2) == "table" then
            OldID = tbLoad.index2;
        end
    end
end