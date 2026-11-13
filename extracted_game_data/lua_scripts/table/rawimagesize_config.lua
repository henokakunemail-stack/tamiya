



---@class rawimagesize_config




rawimagesize_config = {}
---@type table<number,rawimagesize_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/rawimagesize')), '')
local bytes = mono.LoadBytes('rawimagesize')
local cfg = assert(Dll_PB.decode('rawimagesize_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'rawimagesize.txt'
function rawimagesize_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 name = columns[2],
		 size = columns[3],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
rawimagesize_config.Load()
----------以pb方式加载配置表---end




---@return table<number,rawimagesize_config_cell>
function rawimagesize_config.GetConfigData() return configData end
---@return rawimagesize_config_cell
function rawimagesize_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function rawimagesize_config.AnalyseConfig()
	for k, v in pairs(configData) do
		local temp = stringSplitToNumber(v.size, ',')
		configData[k].NewWidth = temp[1]
		configData[k].NewHeight = temp[2]
	end
end
function rawimagesize_config.GetDataByName(name)
	for k, v in pairs(configData) do
		if v.name == name then return v end
	end
	return
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
rawimagesize_config.AnalyseConfig()
----%%%-------------%%%----








return rawimagesize_config
