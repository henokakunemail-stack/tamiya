---@class MenuListManager
MenuListManager = class("MenuListManager")

---@return MenuListManager
function MenuListManager:Get()
    if self._instance == nil then
        self._instance = MenuListManager()
    end
    return self._instance
end

function MenuListManager:initialize()

end

function MenuListManager:Init(msg)
    self.MenuDic={}
    self:ParseJson(msg)
end

function MenuListManager:ParseJson(str)
    if CommonHelper:IsNullOrEmpty(str) then
        return
    end
    local data=Dll_JSON.decode(str)
    for k, v in pairs(data.menulist) do
        self.MenuDic[v.key]=v
    end
end

function MenuListManager:GetMenuState(key)
    local result= true
    local curTime=CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    if self.MenuDic then
        local data=self.MenuDic[key]
        if data then
            if data.state and data.openTime<curTime and data.endTime>curTime then
                result=true
            else
                result=false
            end
        end
    end
    return result
end