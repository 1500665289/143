local KeZhan = GameMain:GetMod("KeZhan");
local tbEvent = GameMain:GetMod("_Event");

-- 不再需要预定义的ID列表，改为动态获取
local NewID = {}
local LunHui = {}

function KeZhan:OnInit()
    -- 初始化时注册事件
    print("客栈MOD初始化完成")
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

-- 获取所有可用NPC（动态方式）
function KeZhan:GetAllAvailableNPCs()
    NewID = {}
    local allNPCs = NpcMgr:GetReincarnateIDs()
    local count = 0
    
    -- 获取所有可转世的NPC，不限制ID范围
    for npcId, npcData in pairs(allNPCs) do
        -- 只添加有完整数据的NPC
        if npcData and npcData.LastName and npcData.FristName then
            -- 过滤掉一些无效或测试用的NPC
            if not self:IsExcludedNPC(npcId) then
                table.insert(NewID, npcId)
                count = count + 1
            end
        end
    end
    
    print("客栈MOD：发现" .. count .. "个可用NPC")
    return NewID
end

function KeZhan:IsExcludedNPC(npcId)
    -- 排除一些不合适的NPC（如剧情关键NPC等）
    local excludedIDs = {
        0, -- 无效ID
        -1, -- 测试ID
        -- 可以在这里添加其他需要排除的ID
    }
    
    for _, excludedId in ipairs(excludedIDs) do
        if npcId == excludedId then
            return true
        end
    end
    
    return false
end

-- 修改原有函数，使用动态获取的NPC
function KeZhan:GeRandomModNpc()
    return self:GetAllAvailableNPCs()
end

function KeZhan:GetAllModNpcID()
    NewID = {}
    local allNPCs = self:GetAllAvailableNPCs()
    local i = 1
    for _, npcId in ipairs(allNPCs) do
        NewID[i] = npcId
        i = i + 1
    end
    return NewID
end

function KeZhan:GetAllModNpcName()
    NewID = {}
    LunHui = {}
    local allNPCs = self:GetAllAvailableNPCs()
    local i = 1
    
    for _, npcId in ipairs(allNPCs) do
        NewID[i] = npcId
        i = i + 1
    end
    
    for k, v in ipairs(NewID) do
        local npcData = NpcMgr:GetReincarnateDataByID(v)
        if npcData then
            LunHui[k] = npcData.LastName .. npcData.FristName
        else
            LunHui[k] = "未知NPC"
        end
    end
    
    LunHui[#LunHui + 1] = "离开此地"
    return LunHui
end

function KeZhan:Secrets_KZ_Choice()
    xlua.private_accessible(CS.XiaWorld.NpcRandomMechine)
    local Npc = me;
    local npc = nil;
    local name = Npc.npcObj.Name
    local NameList = KeZhan:GetAllModNpcName()
    local IDList = KeZhan:GetAllModNpcID()
    
    world:ShowStoryBox(""..name.."环顾了四周天宫降临的奇人，想要邀请他们加入自己的门派。", "天宫奇人", NameList,
    function(Key)
        local key = Key + 1;
        if key == #NameList then
            world:ShowMsgBox(""..name.."想了想，决定还是不冒险，转身离去。","离开客栈");
        else
            local ID = IDList[key]
            local reincarnateDataByID = NpcMgr:GetReincarnateDataByID(ID);
            if reincarnateDataByID then
                if reincarnateDataByID.Race == "Human" or reincarnateDataByID.Race == nil then
                    npc = CS.XiaWorld.NpcRandomMechine._RandomNpc("Human", reincarnateDataByID.Sex, 0, reincarnateDataByID.LastName, reincarnateDataByID.FristName, true, reincarnateDataByID)
                else
                    npc = CS.XiaWorld.NpcRandomMechine._RandomNpc(reincarnateDataByID.Race, reincarnateDataByID.Sex, 0, reincarnateDataByID.LastName, reincarnateDataByID.FristName, true, reincarnateDataByID)
                end
                CS.XiaWorld.NpcMgr.Instance:AddNpc(npc, CS.XiaWorld.World.Instance.map:RandomBronGrid(), Map, CS.XiaWorld.Fight.g_emFightCamp.Player);
                npc:ChangeRank(CS.XiaWorld.g_emNpcRank.Worker);
                world:ShowMsgBox(""..name.."一眼过去就看中了眼前的这个人并热情的邀请他去参观该门派，【"..reincarnateDataByID.LastName..reincarnateDataByID.FristName.."】禁不住"..name.."的热情邀请，最终同意与他前往参观门派（监狱）。","邀请加入")
            else
                world:ShowMsgBox("招募NPC时出现错误，该NPC数据不存在。","错误")
            end
        end
    end);
end

function KeZhan:Secrets_KZ_Random()
    local Npc = me;
    local npc = nil;
    local name = Npc.npcObj.Name;
    local IDList = KeZhan:GetAllModNpcID();
    
    if #IDList == 0 then
        world:ShowMsgBox("当前没有可用的NPC可以招募。","提示")
        return
    end
    
    world:SetRandomSeed();
    local rate = me:RandomInt(1, #IDList);
    local reincarnateDataByID = NpcMgr:GetReincarnateDataByID(IDList[rate]);
    
    if not reincarnateDataByID then
        world:ShowMsgBox("随机招募NPC时出现错误，NPC数据不存在。","错误")
        return
    end
    
    xlua.private_accessible(CS.XiaWorld.NpcRandomMechine);
    if reincarnateDataByID.Race == "Human" or reincarnateDataByID.Race == nil then
        npc = CS.XiaWorld.NpcRandomMechine._RandomNpc("Human", reincarnateDataByID.Sex, 0, reincarnateDataByID.LastName, reincarnateDataByID.FristName, true, reincarnateDataByID)
    else
        npc = CS.XiaWorld.NpcRandomMechine._RandomNpc(reincarnateDataByID.Race, reincarnateDataByID.Sex, 0, reincarnateDataByID.LastName, reincarnateDataByID.FristName, true, reincarnateDataByID);
    end
    
    CS.XiaWorld.NpcMgr.Instance:AddNpc(npc, Map:RandomBronGrid(), Map, CS.XiaWorld.Fight.g_emFightCamp.Player);
    npc:ChangeRank(CS.XiaWorld.g_emNpcRank.Worker);
    world:ShowMsgBox(""..reincarnateDataByID.Desc.."", ""..reincarnateDataByID.LastName..reincarnateDataByID.FristName.."");
    me:AddMsg(""..name.."一眼过去就看中了眼前的这个人并热情的邀请他去参观该门派，【"..reincarnateDataByID.LastName..reincarnateDataByID.FristName.."】禁不住"..name.."的热情邀请，最终同意与他前往参观门派（监狱）。");
end

-- 移除不再需要的限制函数
function KeZhan:GetNPC(i)
    return true; -- 始终返回true，允许选择任何NPC
end

function KeZhan:AddNPC(i)
    -- 空函数，不再记录选择状态
    return
end

function KeZhan:GetID()
    local allNPCs = self:GetAllModNpcID()
    if #allNPCs == 0 then
        return nil
    end
    world:SetRandomSeed()
    local idIndex = me:RandomInt(1, #allNPCs)
    return allNPCs[idIndex]
end

function KeZhan:OnSave()
    local tbSave = {
        version = 1.1, -- 版本号，用于兼容性检查
        message = "使用动态NPC获取方式"
    };
    return tbSave;
end

function KeZhan:OnLoad(tbLoad)
    if tbLoad ~= nil then
        print("客栈MOD数据加载完成")
        -- 不再需要加载旧的限制数据
    end
end
