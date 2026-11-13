



---@class carshell_config




carshell_config = {}
---@type table<number,carshell_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/carshell')), '')
local bytes = mono.LoadBytes('carshell')
local cfg = assert(Dll_PB.decode('carshell_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'carshell.txt'
function carshell_config.Load()
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
		 skill = columns[5],
		 attr = columns[6],
		 holder = ConvertToNumber(configName, 'holder', columns[7]),
		 defaultSticker = ConvertToNumber(configName, 'defaultSticker', columns[8]),
		 isColour = ConvertToNumber(configName, 'isColour', columns[9]),
		 stickerType = columns[10],
		 shellhole = stringSplitToNumber(columns[11], '|'),
		 aniEnter = columns[12],
		 aniEnterTime = ConvertToNumber(configName, 'aniEnterTime', columns[13]),
		 audioGroup = stringSplit(columns[14], '|'),
		 carNameIcon = columns[15],
		 carNameEn = columns[16],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
carshell_config.Load()
----------以pb方式加载配置表---end




---@return table<number,carshell_config_cell>
function carshell_config.GetConfigData() return configData end
---@return carshell_config_cell
function carshell_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,carshell_config_cell>
local __NewConfigData = {}
function carshell_config.AnalyseConfig()
	__NewConfigData = {}
	for k, v in pairs(configData) do
		--configData[k].NewID = v.id * 1000 + v.partGroup
		configData[k].NewShellHole = {}
		configData[k].NewSkill = stringSplitToNumber(v.skill,',')
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

		v.shellhole=stringSplitToNumber(v.shellhole,'|')
		for i = 1, #v.shellhole do
			if v.shellhole[i] ~= 0 then
				table.insert(configData[k].NewShellHole, v.shellhole[i])
			end
		end
		__NewConfigData[v.C_ID] = v
	end
end
---@return table<number,carshell_config_cell>
function carshell_config.GetNewConfigData()
	return __NewConfigData
end
---@return carshell_config_cell
function carshell_config.GetCarById(id)
	return __NewConfigData[id]
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
carshell_config.AnalyseConfig()
----%%%-------------%%%----








return carshell_config
