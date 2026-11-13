



---@class assembledefaultmesh_config




assembledefaultmesh_config = {}
---@type table<number,assembledefaultmesh_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/assembledefaultmesh')), '')
local bytes = mono.LoadBytes('assembledefaultmesh')
local cfg = assert(Dll_PB.decode('assembledefaultmesh_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'assembledefaultmesh.txt'
function assembledefaultmesh_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 point1 = columns[2],
		 offset1 = columns[3],
		 point2 = columns[4],
		 offset2 = columns[5],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
assembledefaultmesh_config.Load()
----------以pb方式加载配置表---end




---@return table<number,assembledefaultmesh_config_cell>
function assembledefaultmesh_config.GetConfigData() return configData end
---@return assembledefaultmesh_config_cell
function assembledefaultmesh_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function assembledefaultmesh_config.AnalyseConfig()
	for k, v in pairs(configData) do
		local temp1 = stringSplitToNumber(v.offset1, ',')
		configData[k].NewOffset1 = LuaVector3(temp1[1], temp1[2], temp1[3])

		if v.offset2 ~= "-1" and v.offset2 ~= "" then
			local temp2 = stringSplitToNumber(v.offset2, ',')
			configData[k].NewOffset2 = LuaVector3(temp2[1], temp2[2], temp2[3])
		end
	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
assembledefaultmesh_config.AnalyseConfig()
----%%%-------------%%%----








return assembledefaultmesh_config
