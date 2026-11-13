



---@class tracksegement_config




tracksegement_config = {}
---@type table<number,tracksegement_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/tracksegement')), '')
local bytes = mono.LoadBytes('tracksegement')
local cfg = assert(Dll_PB.decode('tracksegement_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'tracksegement.txt'
function tracksegement_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 configName = columns[2],
		 resname = columns[3],
		 type = ConvertToNumber(configName, 'type', columns[4]),
		 numbers = ConvertToNumber(configName, 'numbers', columns[5]),
		 toward = ConvertToNumber(configName, 'toward', columns[6]),
		 name = columns[7],
		 desc = columns[8],
		 material = columns[9],
		 icon = columns[10],
		 previewIcon = columns[11],
		 appearance = columns[12],
		 bottomMatID = ConvertToNumber(configName, 'bottomMatID', columns[13]),
		 difficulty = ConvertToNumber(configName, 'difficulty', columns[14]),
		 electricity = ConvertToNumber(configName, 'electricity', columns[15]),
		 freeflag = ConvertToNumber(configName, 'freeflag', columns[16]),
		 editflag = ConvertToNumber(configName, 'editflag', columns[17]),
		 sort = ConvertToNumber(configName, 'sort', columns[18]),
		 direction = ConvertToNumber(configName, 'direction', columns[19]),
		 cv = ConvertToNumber(configName, 'cv', columns[20]),
		 soundeffect = ConvertToNumber(configName, 'soundeffect', columns[21]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
tracksegement_config.Load()
----------以pb方式加载配置表---end




---@return table<number,tracksegement_config_cell>
function tracksegement_config.GetConfigData() return configData end
---@return tracksegement_config_cell
function tracksegement_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return tracksegement_config
