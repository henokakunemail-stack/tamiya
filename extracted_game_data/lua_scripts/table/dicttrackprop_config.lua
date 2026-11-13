



---@class dicttrackprop_config




dicttrackprop_config = {}
---@type table<number,dicttrackprop_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dicttrackprop')), '')
local bytes = mono.LoadBytes('dicttrackprop')
local cfg = assert(Dll_PB.decode('dicttrackprop_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dicttrackprop.txt'
function dicttrackprop_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 proptype = ConvertToNumber(configName, 'proptype', columns[2]),
		 proctrackgold = ConvertToNumber(configName, 'proctrackgold', columns[3]),
		 proctime = ConvertToNumber(configName, 'proctime', columns[4]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dicttrackprop_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dicttrackprop_config_cell>
function dicttrackprop_config.GetConfigData() return configData end
---@return dicttrackprop_config_cell
function dicttrackprop_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function dicttrackprop_config.GetConfigDataLen()
    local len = 0
    for _, v in pairs(configData) do
        if v then
            len = len + 1
        end
    end
    return len
end

function dicttrackprop_config.GetConfigDataByNum(getNum)
    local trackPropData={}
    for i, v in pairs(configData) do
        table.insert(trackPropData,v)
    end
    for i, v in pairs(trackPropData) do
        if i == getNum then
            return v
        end
    end
    return nil
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dicttrackprop_config
