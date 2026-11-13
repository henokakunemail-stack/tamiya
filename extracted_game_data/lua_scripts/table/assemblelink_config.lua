



---@class assemblelink_config




assemblelink_config = {}
---@type table<number,assemblelink_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/assemblelink')), '')
local bytes = mono.LoadBytes('assemblelink')
local cfg = assert(Dll_PB.decode('assemblelink_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'assemblelink.txt'
function assemblelink_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 linkgroopid = columns[2],
		 linkoffset = columns[3],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
assemblelink_config.Load()
----------以pb方式加载配置表---end




---@return table<number,assemblelink_config_cell>
function assemblelink_config.GetConfigData() return configData end
---@return assemblelink_config_cell
function assemblelink_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function assemblelink_config.AnalyseConfig()
	for k, v in pairs(configData) do
		configData[k].NewLinkIds = stringSplitToNumber(v.linkgroopid, ';')

		configData[k].NewLinkOffsets = {}
		local strs = stringSplit(v.linkoffset, ';')
		for i = 1, #strs do
			local temp = stringSplitToNumber(strs[i], ',')
			local offset = LuaVector3(temp[1], temp[2], temp[3])
			table.insert(configData[k].NewLinkOffsets, offset)
		end

	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
assemblelink_config.AnalyseConfig()
----%%%-------------%%%----








return assemblelink_config
