



---@class escalate_beta_config




escalate_beta_config = {}
---@type table<number,escalate_beta_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/escalate_beta')), '')
local bytes = mono.LoadBytes('escalate_beta')
local cfg = assert(Dll_PB.decode('escalate_beta_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'escalate_beta.txt'
function escalate_beta_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 level = ConvertToNumber(configName, 'level', columns[2]),
		 unlock = columns[3],
		 lock = columns[4],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
escalate_beta_config.Load()
----------以pb方式加载配置表---end




---@return table<number,escalate_beta_config_cell>
function escalate_beta_config.GetConfigData() return configData end
---@return escalate_beta_config_cell
function escalate_beta_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local _NewConfigDta={}
function escalate_beta_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if v.unlock~="-1" then
			_NewConfigDta[v.level]=stringSplitToNumber(v.unlock,',')
		end
	end
end
function escalate_beta_config.GetLevelByUnlockId(id)
	for k, v in pairs(_NewConfigDta) do
		for i, m in ipairs(v) do
			if m==id then
				return k
			end
		end
	end
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
escalate_beta_config.AnalyseConfig()
----%%%-------------%%%----








return escalate_beta_config
