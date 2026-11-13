



---@class dicttrademission_config




dicttrademission_config = {}
---@type table<number,dicttrademission_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dicttrademission')), '')
local bytes = mono.LoadBytes('dicttrademission')
local cfg = assert(Dll_PB.decode('dicttrademission_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dicttrademission.txt'
function dicttrademission_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 missionids = columns[2],
		 awardids = columns[3],
		 awardnums = columns[4],
		 nexttradeseq = ConvertToNumber(configName, 'nexttradeseq', columns[5]),
		 trademissionname = columns[6],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dicttrademission_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dicttrademission_config_cell>
function dicttrademission_config.GetConfigData() return configData end
---@return dicttrademission_config_cell
function dicttrademission_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function dicttrademission_config.SetTradeMission()
	for i, v in pairs(configData) do
		local missionids = stringSplitToNumber(v.missionids, ':')
		local awardids = stringSplitToNumber(v.awardids, ':')
		local awardnums = stringSplitToNumber(v.awardnums, ':')

		configData[i].missionids = missionids
		configData[i].awardids = awardids
		configData[i].awardnums = awardnums
	end

end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dicttrademission_config.SetTradeMission()
----%%%-------------%%%----








return dicttrademission_config
