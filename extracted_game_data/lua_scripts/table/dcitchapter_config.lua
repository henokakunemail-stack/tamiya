



---@class dcitchapter_config




dcitchapter_config = {}
---@type table<number,dcitchapter_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dcitchapter')), '')
local bytes = mono.LoadBytes('dcitchapter')
local cfg = assert(Dll_PB.decode('dcitchapter_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dcitchapter.txt'
function dcitchapter_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 chaptertype = ConvertToNumber(configName, 'chaptertype', columns[2]),
		 initunlock = ConvertToNumber(configName, 'initunlock', columns[3]),
		 sumstar = ConvertToNumber(configName, 'sumstar', columns[4]),
		 mapidx = columns[5],
		 mapname = columns[6],
		 mapicon = columns[7],
		 bg = columns[8],
		 time = columns[9],
		 desc = columns[10],
		 prop = ConvertToNumber(configName, 'prop', columns[11]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dcitchapter_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dcitchapter_config_cell>
function dcitchapter_config.GetConfigData() return configData end
---@return dcitchapter_config_cell
function dcitchapter_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dcitchapter_config
