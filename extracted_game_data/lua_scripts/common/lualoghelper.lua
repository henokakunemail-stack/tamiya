
local color = {}
color[0] = "<color=#ffffff>"
color[1] = "<color=#ffff00>"
color[2] = "<color=#ff0000>"
color[3] = "<color=#00ffff>"
color[4] = "<color=#ff8800>"
color[5] = "<color=#ff00ff>"
color[6] = "<color=#00ff00>"
color[7] = "<color=#0088ff>"
color[8] = "<color=#8800ff>"

local __idx = 0
local __instance = nil




---@class LuaLogHelper
LuaLogHelper = class("LuaLogHelper")
function LuaLogHelper:initialize()
    self.ClassNode = {}
end
---@return LuaLogHelper
function LuaLogHelper:Get()
    if __instance == nil then
        __instance = LuaLogHelper()
    end
    return __instance
end

function LuaLogHelper.LogTable(title, tab, isloop)
    if isloop == nil then isloop = true end
    if title == nil then title = "" end
    LuaLogHelper:Get():PrintTable(title, tab, isloop)
end

function LuaLogHelper:PrintTable(title, tab, isloop)
    self.ClassNode[__idx] = {}

    local log = "---   LuaTable:"..title
    log = self:BuildLine(log)
    log = self:ReadTable(log, tab, 0, isloop)
    print(log)

    self.ClassNode[__idx] = nil
    __idx = __idx + 1
end

function LuaLogHelper:ReadTable(str, data, loop, isloop)

    if type(data) == "table" then

        str = self:BuildLeft(str, loop)
        str = self:BuildLine(str)

        for k, v in pairs(data) do
            if k ~= "class" then
                if self:IsLoopClass(tostring(data), loop) then
                    if type(v) == "table" then
                        str = self:BuildBlank(str, loop + 1)
                        local temp = k.." = 未解析"
                        str = str..self:SetColor(temp, loop)
                        str = self:BuildLine(str)
                    elseif type(v) ~= "function" then
                        str = self:BuildBlank(str, loop + 1)
                        local temp = k.." = "..tostring(v)
                        str = str..self:SetColor(temp, loop)
                        str = self:BuildLine(str)
                    end

                else
                    self:AddClassNode(tostring(data),loop)
                    if type(v) == "table" then
                        if isloop then
                            str = self:BuildBlank(str, loop + 1)
                            local temp = k.." = "
                            str = str..self:SetColor(temp, loop)
                            str = self:BuildLine(str)
                            str = self:ReadTable(str, v, loop + 1, isloop)
                        else
                            str = self:BuildBlank(str, loop + 1)
                            local temp = k.." = 未解析"
                            str = str..self:SetColor(temp, loop)
                            str = self:BuildLine(str)
                        end

                    elseif type(v) ~= "function" then
                        str = self:BuildBlank(str, loop + 1)
                        local temp = k.." = "..tostring(v)
                        str = str..self:SetColor(temp, loop)
                        str = self:BuildLine(str)
                    end

                end

            end
        end
        str = self:BuildRight(str, loop)
        str = self:BuildLine(str)
    end

    return str
end

function LuaLogHelper:BuildLeft(str, loop)
    local tab = ""
    for i = 1, loop do
        tab = tab.."    "
    end
    str = str..self:SetColor(tab.."{", loop)
    return str
end
function LuaLogHelper:BuildRight(str, loop)
    local tab = ""
    for i = 1, loop do
        tab = tab.."    "
    end

    str = str..self:SetColor(tab.."}", loop)
    return str
end
function LuaLogHelper:BuildBlank(str, loop)
    local tab = ""
    for i = 1, loop do
        tab = tab.."    "
    end
    return str..tab
end
function LuaLogHelper:BuildLine(str)
    return str.."\n"
end

function LuaLogHelper:SetColor(str, idx)
    return color[idx]..str.."</color>"
end

function LuaLogHelper:AddClassNode(name, loop)

    if name == nil then
        return
    end

    local tab = self.ClassNode[__idx]
    if tab[loop] == nil then
        tab[loop] = {}
    end

    table.insert(tab[loop], name)

end
function LuaLogHelper:IsLoopClass(name, loop)
    local tab = self.ClassNode[__idx]
    for k,v in pairs(tab) do
        for i = 1, #v do
            if k < loop and v[i] == name then
                return true
            end
        end
    end
    return false
end