



---@class dictdown_config




dictdown_config = {}
---@type table<number,dictdown_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictdown')), '')
local bytes = mono.LoadBytes('dictdown')
local cfg = assert(Dll_PB.decode('dictdown_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictdown.txt'
function dictdown_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 id = ConvertToNumber(configName, 'id', columns[2]),
		 dropid = ConvertToNumber(configName, 'dropid', columns[3]),
		 propsid = ConvertToNumber(configName, 'propsid', columns[4]),
		 propsnum = ConvertToNumber(configName, 'propsnum', columns[5]),
		 weight = ConvertToNumber(configName, 'weight', columns[6]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictdown_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictdown_config_cell>
function dictdown_config.GetConfigData() return configData end
---@return dictdown_config_cell
function dictdown_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local configRewardData = {}
function dictdown_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if configRewardData[v.dropid]==nil then
			configRewardData[v.dropid]={}
		end
		local reward=RewardData()
		reward:SetDataIdNum(v.propsid,v.propsnum)
		table.insert(configRewardData[v.dropid],reward)
	end
end
function dictdown_config.GetRewardsGroupByDropId(id)
	if id == nil or configRewardData[id] == nil then
		return {}
	end
	return configRewardData[id]
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictdown_config.AnalyseConfig()
----%%%-------------%%%----








return dictdown_config
