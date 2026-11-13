
---@class RedPointManager
RedPointManager = class("RedPointManager")
function RedPointManager:initialize()
    ---@type table<number, RedPointDataBase>
    self.DataList = {}
    ---@type table<number, RedPointDataBase>
    self.DictID = {}

    CacheClearTrigger:Get():RegisterEvent(self, self.ClearData)
end

function RedPointManager:Get()
    if self._instance == nil then
        self._instance = RedPointManager()
    end
    return self._instance
end

---@param msg SC_MenuInfo[]
function RedPointManager:InitMenuList(msg)
    for k, v in pairs(msg) do

    end
    self:SetLoginRedPoint()
end

function RedPointManager:OnInit()
    RedPointFunction.RegistData()
end

---@param data RedPointDataBase
function RedPointManager:RegistRedPoint(data)
    if data then
        data:InitData()
        local temp = self:GetData(data:GetID())
        if temp then
            logError("---   error:RedPointManager:RegistRedPoint   重复注册， id= ",data:GetID())
        else
            table.insert(self.DataList, data)
            self.DictID[data:GetID()] = data
        end
    end
end

function RedPointManager:ClearData()
    self.DataList = {}
    self.DictID = {}
    RedPointFunction.RegistData()
end

---@return RedPointDataBase
function RedPointManager:GetData(id)
    return self.DictID[id]
end

function RedPointManager:UpdateValue(id, param)
    local data = self:GetData(id)
    if data then data:UpdateValue(param) end
    self:UpdateGroupIdById(id,param)
    if data then return data.Value end
end
function RedPointManager:UpdateGroupIdById(id,param)
    local result=id
    local value=param
    for i, v in pairs(RedPointGroupID) do
        for k, z in pairs(v) do
            if id==k then
                result=i
                break
            end
        end
        if result~=id then
            break
        end
    end
    if result~=id and value==false then
        local group= RedPointGroupID[result]
        for k, v in pairs(group) do
           local data=self:GetData(k)
            if data and data:GetValue() then
                value=data:GetValue()
                break
            else
                logError("组数据没有",id,result)
            end
        end
    end
    local data = self:GetData(result)
    if data then data:UpdateValue(value) end
end

---@param info SC_RedInfo
function RedPointManager:UpdateServer(info)
    local data={}
    local ids=info.redid
    for k, v in pairs(RedPointServerID) do
        for i = 1, #ids do
            if v==ids[i] then
                if (v == RedPointID.S_VideoDayGift or v==RedPointID.S_VideoDayGiftSum ) and not HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.VideoGift) then
                elseif v == RedPointID.S_VideoLuck and not HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.VideoLuckTurntable) then
                else
                    data[v]=true
                end
                break
            end
        end
    end
    for k, v in pairs(data) do
        RedPointManager:Get():UpdateValue(k, v)
    end
end
function RedPointManager:SetLoginRedPoint()
    local flag=false
    if PlayerPrefsHelper:GetValue_LoginTime()~=CommonHelper:GetNowTime().Day then
        flag=true
    end
    print(PlayerPrefsHelper:GetValue_LoginTime(),"-------->>",CommonHelper:GetNowTime().Day,flag)
    PlayerPrefsHelper:SetValue_LoginTime()
    for k, v in pairs(RedPointFirstLoginID) do
        print(v,flag)
        RedPointManager:Get():UpdateValue(v, flag)
    end
end

function RedPointManager:GetValue(id)
    local data = self:GetData(id)
    if data then return data:GetValue() end
    return false
end

function RedPointManager:RegistRealtimeFunc(id,objid, func, redjob)
    local data = self:GetData(id)
    if data then data:SetRealTimeFunc(objid, func, redjob) end
end

---@param list table<number,number>
function RedPointManager:SetListData(list)
    for i = 1, #list do
        self:UpdateValue(list[i], true)
    end
end


