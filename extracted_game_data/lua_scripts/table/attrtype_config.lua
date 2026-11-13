



---@class attrtype_config




attrtype_config = {}
---@type table<number,attrtype_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/attrtype')), '')
local bytes = mono.LoadBytes('attrtype')
local cfg = assert(Dll_PB.decode('attrtype_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'attrtype.txt'
function attrtype_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 attrname = columns[2],
		 attrtype = ConvertToNumber(configName, 'attrtype', columns[3]),
		 tag = ConvertToNumber(configName, 'tag', columns[4]),
		 tagName = columns[5],
		 desc = columns[6],
		 showradio = ConvertToNumber(configName, 'showradio', columns[7]),
		 format = columns[8],
		 formula = ConvertToNumber(configName, 'formula', columns[9]),
		 formulaparm = columns[10],
		 interval = columns[11],
		 init = ConvertToNumber(configName, 'init', columns[12]),
		 attrtrait = ConvertToNumber(configName, 'attrtrait', columns[13]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
attrtype_config.Load()
----------以pb方式加载配置表---end




---@return table<number,attrtype_config_cell>
function attrtype_config.GetConfigData() return configData end
---@return attrtype_config_cell
function attrtype_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@return table<number,attrtype_config_cell>
function attrtype_config.GetList()
	---@type table<number,attrtype_config_cell>
	local result = {}
	for k, v in pairs(configData) do
		table.insert(result, v)
	end
	table.sort(result, function(a, b)
		return a.C_ID < b.C_ID
	end)
	return result
end
function attrtype_config.AnalyseConfig()
	for k, v in pairs(configData) do

		configData[k].NewInterval = {}
		if v.interval ~= "-1" then
			local value = stringSplitToNumber(v.interval,',')
			if #value < 2 then
				logError("---   attrtype_config格式错误，intervalg个数少于2个，interval = ", v.interval)
			else
				if value[1] == value[2] then
					logError("---   attrtype_config格式错误，interval = ", v.interval)
				elseif value[1] < value[2] then
					local temp = {}
					table.insert(temp, -99999999)
					for i = 1, #value do table.insert(temp, value[i]) end
					table.insert(temp, 99999999)
					configData[k].NewInterval = temp
				elseif value[1] > value[2] then
					local temp = {}
					table.insert(temp, 99999999)
					for i = 1, #value do table.insert(temp, value[i]) end
					table.insert(temp, -99999999)
					configData[k].NewInterval = temp
				end
			end
		end
	end

end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
attrtype_config.AnalyseConfig()
----%%%-------------%%%----








return attrtype_config
