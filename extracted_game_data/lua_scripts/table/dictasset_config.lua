



---@class dictasset_config




dictasset_config = {}
---@type table<number,dictasset_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictasset')), '')
local bytes = mono.LoadBytes('dictasset')
local cfg = assert(Dll_PB.decode('dictasset_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictasset.txt'
function dictasset_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 star = columns[2],
		 cond = columns[3],
		 succval = columns[4],
		 star1 = ConvertToNumber(configName, 'star1', columns[5]),
		 cond1 = columns[6],
		 succval1 = columns[7],
		 star2 = ConvertToNumber(configName, 'star2', columns[8]),
		 cond2 = columns[9],
		 succval2 = columns[10],
		 star3 = ConvertToNumber(configName, 'star3', columns[11]),
		 cond3 = columns[12],
		 succval3 = columns[13],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictasset_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictasset_config_cell>
function dictasset_config.GetConfigData() return configData end
---@return dictasset_config_cell
function dictasset_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictasset_config
