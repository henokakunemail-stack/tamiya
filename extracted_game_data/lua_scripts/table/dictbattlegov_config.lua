



---@class dictbattlegov_config




dictbattlegov_config = {}
---@type table<number,dictbattlegov_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictbattlegov')), '')
local bytes = mono.LoadBytes('dictbattlegov')
local cfg = assert(Dll_PB.decode('dictbattlegov_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictbattlegov.txt'
function dictbattlegov_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 battlename = columns[2],
		 createtime = ConvertToNumber(configName, 'createtime', columns[3]),
		 resulttime = ConvertToNumber(configName, 'resulttime', columns[4]),
		 overtime = ConvertToNumber(configName, 'overtime', columns[5]),
		 awardid = ConvertToNumber(configName, 'awardid', columns[6]),
		 trackid = columns[7],
		 scienceid = ConvertToNumber(configName, 'scienceid', columns[8]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictbattlegov_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictbattlegov_config_cell>
function dictbattlegov_config.GetConfigData() return configData end
---@return dictbattlegov_config_cell
function dictbattlegov_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictbattlegov_config
