



---@class assemblerulewing_config




assemblerulewing_config = {}
---@type table<number,assemblerulewing_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/assemblerulewing')), '')
local bytes = mono.LoadBytes('assemblerulewing')
local cfg = assert(Dll_PB.decode('assemblerulewing_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'assemblerulewing.txt'
function assemblerulewing_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 point = columns[2],
		 offest = columns[3],
		 rotate = columns[4],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
assemblerulewing_config.Load()
----------以pb方式加载配置表---end




---@return table<number,assemblerulewing_config_cell>
function assemblerulewing_config.GetConfigData() return configData end
---@return assemblerulewing_config_cell
function assemblerulewing_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function assemblerulewing_config.AnalyseConfig()
	for k, v in pairs(configData) do
		local temp1 = stringSplitToNumber(v.offest, ',')
		local temp2 = stringSplitToNumber(v.rotate, ',')
		configData[k].NewOffset = LuaVector3(temp1[1], temp1[2], temp1[3])
		configData[k].NewRotate = LuaVector3(temp2[1], temp2[2], temp2[3])
		v.rotate=nil
		v.offset=nil
	end
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
assemblerulewing_config.AnalyseConfig()
----%%%-------------%%%----








return assemblerulewing_config
