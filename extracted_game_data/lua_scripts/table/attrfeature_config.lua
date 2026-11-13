



---@class attrfeature_config




attrfeature_config = {}
---@type table<number,attrfeature_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/attrfeature')), '')
local bytes = mono.LoadBytes('attrfeature')
local cfg = assert(Dll_PB.decode('attrfeature_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'attrfeature.txt'
function attrfeature_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 attr = ConvertToNumber(configName, 'attr', columns[2]),
		 type = ConvertToNumber(configName, 'type', columns[3]),
		 icon = columns[4],
		 bg = columns[5],
		 char = columns[6],
		 desc = columns[7],
		 isShow = ConvertToNumber(configName, 'isShow', columns[8]),
		 interval = columns[9],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
attrfeature_config.Load()
----------以pb方式加载配置表---end




---@return table<number,attrfeature_config_cell>
function attrfeature_config.GetConfigData() return configData end
---@return attrfeature_config_cell
function attrfeature_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function attrfeature_config.AnalyseConfig()
	for k, v in pairs(configData) do
		configData[k].NewInterval = {}

		if v.interval ~= "-1" then
			local value = stringSplitToNumber(v.interval,',')
			if #value < 2 then
				logError("---   attrfeature_config格式错误，intervalg个数少于2个，interval = ", v.interval)
			else
				if value[1] == value[2] then
					logError("---   attrfeature_config格式错误，interval = ", v.interval)
				elseif value[1] < value[2] then
					local temp = {}
					table.insert(temp, -99999999)
					for i = 1, #value do table.insert(temp, value[i]) end
					table.insert(temp, 99999999)
					configData[k].NewInterval = temp
				elseif value[1] > value[2] then
					local temp = {}
					table.insert(temp, 99999999)
					for i = 1, #value do table.insert(temp, value[i]) end
					table.insert(temp, -99999999)
					configData[k].NewInterval = temp
				end
			end
		end

	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
attrfeature_config.AnalyseConfig()
----%%%-------------%%%----








return attrfeature_config
