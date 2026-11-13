
---@type JsonData_Race
local __instance

---@class JsonData_Race
JsonData_Race = class("JsonData_Race")

function JsonData_Race:initialize()
    self.name = ""
    self.qualifierTimes = -1
    self.promoTimes = -1
    self.semifinalsTimes = -1
    self.finalsTimes = -1
    self.price = -1
    self.buylimit = -1
    ---@type table<number, table<number, number>>
    self.pamgroup = {}
end

function JsonData_Race:SetData()
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.RaceRule)
    if cfg == nil then
        print("---   error:JsonData_Race:SetData()   cfg = nil")
        return
    end

    local tab = Dll_JSON.decode(cfg.varval)
    if tab == nil then
        print("---   error:JsonData_Race:SetData()   tab = nil   body = ",cfg.body)
        return
    end


    self.name = tab.name
    self.qualifierTimes = tab.qualifierTimes
    self.promoTimes = tab.promoTimes
    self.semifinalsTimes = tab.semifinalsTimes
    self.finalsTimes = tab.finalsTimes
    self.price = tab.price
    self.buylimit = tab.buylimit
    self.pamgroup = tab.pamgroup
end

---@return JsonData_Race
function JsonData_Race:Get()
    if __instance == nil then
        __instance = JsonData_Race()
        __instance:SetData()
    end
    return __instance
end