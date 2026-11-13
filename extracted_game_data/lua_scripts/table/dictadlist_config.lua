



---@class dictadlist_config




dictadlist_config = {}
---@type table<number,dictadlist_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictadlist')), '')
local bytes = mono.LoadBytes('dictadlist')
local cfg = assert(Dll_PB.decode('dictadlist_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictadlist.txt'
function dictadlist_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 viewnum = ConvertToNumber(configName, 'viewnum', columns[2]),
		 awardids = columns[3],
		 awardnum = columns[4],
		 limittime = ConvertToNumber(configName, 'limittime', columns[5]),
		 missionname = columns[6],
		 missionmemo = columns[7],
		 adcard = columns[8],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictadlist_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictadlist_config_cell>
function dictadlist_config.GetConfigData() return configData end
---@return dictadlist_config_cell
function dictadlist_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictadlist_config
