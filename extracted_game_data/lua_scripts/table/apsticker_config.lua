



---@class apsticker_config




apsticker_config = {}
---@type table<number,apsticker_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/apsticker')), '')
local bytes = mono.LoadBytes('apsticker')
local cfg = assert(Dll_PB.decode('apsticker_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'apsticker.txt'
function apsticker_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 name = columns[2],
		 des = columns[3],
		 type = ConvertToNumber(configName, 'type', columns[4]),
		 mat = columns[5],
		 mat2 = columns[6],
		 mesh = ConvertToNumber(configName, 'mesh', columns[7]),
		 stickerEffect = columns[8],
		 ifPerson = ConvertToNumber(configName, 'ifPerson', columns[9]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
apsticker_config.Load()
----------以pb方式加载配置表---end




---@return table<number,apsticker_config_cell>
function apsticker_config.GetConfigData() return configData end
---@return apsticker_config_cell
function apsticker_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,apsticker_config_cell>
local __NewConfigData = {}
function apsticker_config.AnalyseConfig()
	__NewConfigData = {}
	for k, v in pairs(configData) do
		configData[k].NewMat = v.mat..".mat"
		if v.mat2~="0" then
			configData[k].NewMatAdditional = v.mat2..".mat"
		else
			configData[k].NewMatAdditional = "0"
		end
		table.insert(__NewConfigData, v)
	end
end
function apsticker_config.GetList()
	return __NewConfigData
end
function apsticker_config.GetListByType(type)
	local result = {}
	for i = 1, #__NewConfigData do
		if __NewConfigData[i].type == type and type > 0 then
			table.insert(result, __NewConfigData[i])
		end
	end
	return result
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
apsticker_config.AnalyseConfig()
----%%%-------------%%%----








return apsticker_config
