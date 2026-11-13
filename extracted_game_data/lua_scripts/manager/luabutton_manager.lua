

local __ButtonID = 0


---@class LuaButtonManager
LuaButtonManager = class("LuaButtonManager")

function LuaButtonManager:initialize()
    ---@type table<number,LuaButtonParam>
    self.buttonList = {}
end

---@return LuaButtonManager
function LuaButtonManager:Get()
    if self._instance == nil then
        self._instance = LuaButtonManager()
    end
    return self._instance
end

function LuaButtonManager:AddButton(objectName, parent,poolid, func,param, class)
    __ButtonID = __ButtonID + 1
    local data = LuaButtonParam()
    data:Init(__ButtonID, func, class, param, poolid)
    table.insert(self.buttonList, data)
    local btn = CommonHelper:HButtonSetCallback(objectName,parent,function(hbtn)
        LuaButtonManager:Get():OnClickBtn(hbtn.intData)
    end ,__ButtonID)

    --print("---   LuaButtonManager    AddButton    datacount = ",#self.buttonList)

    return btn
end

function LuaButtonManager:OnClickBtn(id)
    --print("---   LuaButtonManager    OnClickBtn    datacount = ",#self.buttonList)
    for i = 1, #self.buttonList do
        if self.buttonList[i].id == id then
            self.buttonList[i]:Click()
            break
        end
    end
end

function LuaButtonManager:ReleasePool(poolID)
    --print("---   LuaButtonManager    ReleasePool    datacount = ",#self.buttonList)
    local index = 1
    while(index <= #self.buttonList)
    do
        if self.buttonList[index].poolid == poolID then
            table.remove(self.buttonList, index)
        else
            index = index + 1
        end
    end
    --print("---   LuaButtonManager    ReleasePool    datacount = ",#self.buttonList)
end






---@class LuaButtonParam
LuaButtonParam = class("LuaButtonParam")
function LuaButtonParam:Init(id, func,class , param, poolid)
    self.id = id
    self.func = func
    self.class = class
    self.param = param
    self.poolid = poolid
    if poolid == UIModuleID.None then
        logError("---   Error:Dirty data, buttonid = ",id)
    end
end
function LuaButtonParam:Click()
    if self.class then
        self.func(self.class, self.param)
    else
        self.func(self.param)
    end
end