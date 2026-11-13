



---@class dictparts_config




dictparts_config = {}
---@type table<number,dictparts_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictparts')), '')
local bytes = mono.LoadBytes('dictparts')
local cfg = assert(Dll_PB.decode('dictparts_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictparts.txt'
function dictparts_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 partname = columns[2],
		 partdesc = columns[3],
		 recource = ConvertToNumber(configName, 'recource', columns[4]),
		 icon = columns[5],
		 baseid = ConvertToNumber(configName, 'baseid', columns[6]),
		 defaultsticker = ConvertToNumber(configName, 'defaultsticker', columns[7]),
		 lockstick = ConvertToNumber(configName, 'lockstick', columns[8]),
		 defaultcolor = ConvertToNumber(configName, 'defaultcolor', columns[9]),
		 lockcolor = ConvertToNumber(configName, 'lockcolor', columns[10]),
		 score = ConvertToNumber(configName, 'score', columns[11]),
		 sign = ConvertToNumber(configName, 'sign', columns[12]),
		 shellhole = columns[13],
		 recource2 = ConvertToNumber(configName, 'recource2', columns[14]),
		 recource3 = ConvertToNumber(configName, 'recource3', columns[15]),
		 recource4 = ConvertToNumber(configName, 'recource4', columns[16]),
		 icon2 = columns[17],
		 icon3 = columns[18],
		 icon4 = columns[19],
		 descspecial = columns[20],
		 descopen = columns[21],
		 descclose = columns[22],
		 ifcopy = ConvertToNumber(configName, 'ifcopy', columns[23]),
		 consumeids = columns[24],
		 consumenums = columns[25],
		 cellifcopy = ConvertToNumber(configName, 'cellifcopy', columns[26]),
		 stickerType = columns[27],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictparts_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictparts_config_cell>
function dictparts_config.GetConfigData() return configData end
---@return dictparts_config_cell
function dictparts_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----



---@type table<number,parts_config_cell>
local __NewConfigData = {}
local __NewBaseConfigData = {}
function dictparts_config.AnalyseConfig()
	__NewConfigData = {}
	__NewBaseConfigData = {}
	for k, v in pairs(configData) do
		configData[k].NewShellHole = {}
		v.shellhole=stringSplitToNumber(v.shellhole,':')
		for i = 1, #v.shellhole do
			if v.shellhole[i] ~= 0 then
				table.insert(configData[k].NewShellHole, v.shellhole[i])
			end
		end
		if v.stickerType == "" or v.stickerType == "-1" or v.stickerType == "0" then
			configData[k].NewExtrSticker = {}
		else
			configData[k].NewExtrSticker = stringSplitToNumber(v.stickerType,',')
		end
		table.insert(__NewConfigData, v)
		if __NewBaseConfigData[v.baseid] ==nil then
			__NewBaseConfigData[v.baseid]={}
		end
		table.insert(__NewBaseConfigData[v.baseid],v)
	end
end

---@param data parts_config_cell
function dictparts_config.AnalyseMeshCfgParam()

end
function dictparts_config.GetPartListByBaseId(id)
    return __NewBaseConfigData[id]
end
function dictparts_config.GetPartListByBaseIdCanCopy(id)
	local result={}
	if __NewBaseConfigData[id] then
		for i = 1, #__NewBaseConfigData[id] do
			if __NewBaseConfigData[id][i].ifcopy==0 then
				table.insert(result,__NewBaseConfigData[id][i])
			end
		end
	end
	return result

end


----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictparts_config.AnalyseConfig()
----%%%-------------%%%----








return dictparts_config
