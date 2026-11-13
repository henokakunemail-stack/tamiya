



---@class dictpartcell_config




dictpartcell_config = {}
---@type table<number,dictpartcell_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictpartcell')), '')
local bytes = mono.LoadBytes('dictpartcell')
local cfg = assert(Dll_PB.decode('dictpartcell_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictpartcell.txt'
function dictpartcell_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 carNameid = columns[2],
		 showcfg = ConvertToNumber(configName, 'showcfg', columns[3]),
		 apshowcfg = ConvertToNumber(configName, 'apshowcfg', columns[4]),
		 attr = columns[5],
		 holder = ConvertToNumber(configName, 'holder', columns[6]),
		 defaultcolor = ConvertToNumber(configName, 'defaultcolor', columns[7]),
		 defaultSticker = ConvertToNumber(configName, 'defaultSticker', columns[8]),
		 isColour = ConvertToNumber(configName, 'isColour', columns[9]),
		 stickerType = columns[10],
		 aniEnter = columns[11],
		 aniEnterTime = ConvertToNumber(configName, 'aniEnterTime', columns[12]),
		 carNameIcon = columns[13],
		 carNameEn = columns[14],
		 bean = ConvertToNumber(configName, 'bean', columns[15]),
		 cellcv = ConvertToNumber(configName, 'cellcv', columns[16]),
		 cellDefaultEffect = columns[17],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictpartcell_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictpartcell_config_cell>
function dictpartcell_config.GetConfigData() return configData end
---@return dictpartcell_config_cell
function dictpartcell_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,carshell_config_cell>
local __NewConfigData = {}
function dictpartcell_config.AnalyseConfig()
	__NewConfigData = {}
	for k, v in pairs(configData) do
		--configData[k].NewID = v.id * 1000 + v.partGroup

		--configData[k].NewSkill = stringSplitToNumber(v.skill,',')
		if v.aniEnter~="-1" then
			configData[k].NewAniEnter = v.aniEnter..".prefab"
		else
			configData[k].NewAniEnter = v.aniEnter
		end
		configData[k].NewFeature = stringSplitToNumber(v.attr, ',')

		if v.stickerType == "" or v.stickerType == "-1" then
			configData[k].NewExtrSticker = {}
		else
			configData[k].NewExtrSticker = stringSplitToNumber(v.stickerType,',')
		end
		__NewConfigData[v.C_ID] = v
	end
end
---@return table<number,carshell_config_cell>
function dictpartcell_config.GetNewConfigData()
	return __NewConfigData
end
---@return carshell_config_cell
function dictpartcell_config.GetCarById(id)
	return __NewConfigData[id]
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictpartcell_config.AnalyseConfig()
----%%%-------------%%%----








return dictpartcell_config
