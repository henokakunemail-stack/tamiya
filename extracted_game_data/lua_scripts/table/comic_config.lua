



---@class comic_config




comic_config = {}
---@type table<number,comic_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/comic')), '')
local bytes = mono.LoadBytes('comic')
local cfg = assert(Dll_PB.decode('comic_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'comic.txt'
function comic_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 stepids = columns[2],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
comic_config.Load()
----------以pb方式加载配置表---end




---@return table<number,comic_config_cell>
function comic_config.GetConfigData() return configData end
---@return comic_config_cell
function comic_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function comic_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if not CommonHelper:IsNullOrEmpty(v.stepids) then
			configData[k].stepids=stringSplitToNumber(v.stepids,':')
		end
	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
comic_config.AnalyseConfig()
----%%%-------------%%%----








return comic_config
