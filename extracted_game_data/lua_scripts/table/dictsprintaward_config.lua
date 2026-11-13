



---@class dictsprintaward_config




dictsprintaward_config = {}
---@type table<number,dictsprintaward_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictsprintaward')), '')
local bytes = mono.LoadBytes('dictsprintaward')
local cfg = assert(Dll_PB.decode('dictsprintaward_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictsprintaward.txt'
function dictsprintaward_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 awardid = ConvertToNumber(configName, 'awardid', columns[2]),
		 val = columns[3],
		 award = columns[4],
		 num = columns[5],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictsprintaward_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictsprintaward_config_cell>
function dictsprintaward_config.GetConfigData() return configData end
---@return dictsprintaward_config_cell
function dictsprintaward_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@return table<number,table<number,dictsprintaward_config_cell>>
local NewCfgData={}
function dictsprintaward_config.AnalyseConfig()
	for k, v in pairs(configData) do
		v.score=tonumber(v.val)
		if NewCfgData[v.awardid]==nil then
			NewCfgData[v.awardid]={}
		end
		table.insert(NewCfgData[v.awardid],v)
	end
end
function dictsprintaward_config.GetAwardListByActId(actId)
	if NewCfgData[actId] then
		return NewCfgData[actId]
	end
	return {}
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictsprintaward_config.AnalyseConfig()
----%%%-------------%%%----








return dictsprintaward_config
