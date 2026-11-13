



---@class dicthidechapter_config




dicthidechapter_config = {}
---@type table<number,dicthidechapter_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dicthidechapter')), '')
local bytes = mono.LoadBytes('dicthidechapter')
local cfg = assert(Dll_PB.decode('dicthidechapter_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dicthidechapter.txt'
function dicthidechapter_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 tebtype = ConvertToNumber(configName, 'tebtype', columns[2]),
		 tebname = columns[3],
		 chaptertype = ConvertToNumber(configName, 'chaptertype', columns[4]),
		 initunlock = ConvertToNumber(configName, 'initunlock', columns[5]),
		 sumstar = ConvertToNumber(configName, 'sumstar', columns[6]),
		 begintime = columns[7],
		 endtime = columns[8],
		 finishsum = columns[9],
		 joinsum = columns[10],
		 needlev = columns[11],
		 mapidx = columns[12],
		 mapname = columns[13],
		 mapicon = columns[14],
		 bg = columns[15],
		 recommendicon = columns[16],
		 hide = columns[17],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dicthidechapter_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dicthidechapter_config_cell>
function dicthidechapter_config.GetConfigData() return configData end
---@return dicthidechapter_config_cell
function dicthidechapter_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dicthidechapter_config
