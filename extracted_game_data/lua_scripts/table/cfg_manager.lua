

---@class CfgManager
CfgManager = class("CfgManager")

function CfgManager:initialize()
    self.Configs = {}
    self.CfgInitState = {}
end

---@return CfgManager
function CfgManager:Get()
    if self._instance == nil then
        self._instance = CfgManager()
    end
    return self._instance
end

function CfgManager:GetConfig(name)
    if name == nil or name=="" then
        logError("---   读取配置表失败，name = nil",debug.traceback())
        return nil
    end
    if self.Configs[name] == nil then
        self:LoadLoginCfgByName_PB(name)
        if self.Configs[name] == nil then
            logError("---   配置表不存在，name =  "..name,debug.traceback())
            return nil
        end
    end
    return self.Configs[name]
end


-------------------------------------------------------加载txt文件，读取配置表
-- 登陆之前的时候加载的配置表
function CfgManager:LoadLoginCfg_Txt()

end

-- 登陆之后第一次Loading主城的时候加载的场景
function CfgManager:LoadCfg_Txt()

end
-------------------------------------------------------加载txt文件，读取配置表






-------------------------------------------------------pb文件，读取配置表
function CfgManager:LoadLoginCfg_PB()
    for k, v in pairs(LoginConfigNames) do
        local ev =nil
        if GameProperties.CfgIsLuaTable then
            ev = require("table/load_bypb/lua_cfg/" .. v)
        else
            ev = require("table/load_bypb/lua/" .. v)
        end

        self.Configs[v] = ev
        self.CfgInitState[v] = true
    end
end
function CfgManager:LoadLoginCfgByName_PB(name)
    local ev =nil
    if GameProperties.CfgIsLuaTable then
        ev = require("table/load_bypb/lua_cfg/" .. name)
    else
        ev = require("table/load_bypb/lua/" .. name)
    end
    self.Configs[name] = ev
    self.CfgInitState[name] = true
end

function CfgManager:LoadAppStartCfg_PB()
    for k, v in pairs(AppStartConfigNames) do
        local ev =nil
        if GameProperties.CfgIsLuaTable then
            ev = require("table/load_bypb/lua_cfg/" .. v)
        else
            ev = require("table/load_bypb/lua/" .. v)
        end

        self.Configs[v] = ev
        self.CfgInitState[v] = true
    end
end



function CfgManager:LoadCfg_PB()
    print("登录后加载配置")
        for k, v in pairs(ConfigNames) do
            local isLoaded = self.CfgInitState[v]
            if not isLoaded then
                -- print("LoadCfg_PB   require:" .. v)
                local ev =nil
                if GameProperties.CfgIsLuaTable then
                    ev = require("table/load_bypb/lua_cfg/" .. v)
                else
                    ev = require("table/load_bypb/lua/" .. v)
                end
                self.Configs[v] = ev
            end
        end
end
-------------------------------------------------------pb文件，读取配置表


function CfgManager:PBTest()
    local v = "attrtype_config"
    local ev = require("table/load_bypb/lua/" .. v)
    self.Configs[v] = ev
end