



---@class apcolor_config




apcolor_config = {}
---@type table<number,apcolor_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/apcolor')), '')
local bytes = mono.LoadBytes('apcolor')
local cfg = assert(Dll_PB.decode('apcolor_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'apcolor.txt'
function apcolor_config.Load()
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
		 quality = ConvertToNumber(configName, 'quality', columns[4]),
		 basecolor = columns[5],
		 ssscolor = columns[6],
		 fakecolor = columns[7],
		 metallic = ConvertToNumber(configName, 'metallic', columns[8]),
		 smoothness = ConvertToNumber(configName, 'smoothness', columns[9]),
		 icon = columns[10],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
apcolor_config.Load()
----------以pb方式加载配置表---end




---@return table<number,apcolor_config_cell>
function apcolor_config.GetConfigData() return configData end
---@return apcolor_config_cell
function apcolor_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,apcolor_config_cell>
local __NewConfigData = {}
function apcolor_config.AnalyseConfig()
	__NewConfigData = {}
	for k, v in pairs(configData) do
		table.insert(__NewConfigData, v)

		if v.basecolor ~= "" and string.len(v.basecolor) == 6 then
			local r=string.sub(v.basecolor,1,2)
			local g=string.sub(v.basecolor,3,4)
			local b=string.sub(v.basecolor,5,6)
			configData[k].NewBaseColor = LuaColor(r,g,b)
		else
			logError("---   数据格式错误:basecolor", v.basecolor)
		end
		if v.ssscolor ~= "" and string.len(v.ssscolor) == 6 then
			local r=string.sub(v.ssscolor,1,2)
			local g=string.sub(v.ssscolor,3,4)
			local b=string.sub(v.ssscolor,5,6)
			configData[k].NewSSSColor = LuaColor(r,g,b)
		else
			logError("---   数据格式错误:ssscolor", v.ssscolor)
		end
		if v.fakecolor ~= "" and string.len(v.fakecolor) == 6 then
			local r=string.sub(v.fakecolor,1,2)
			local g=string.sub(v.fakecolor,3,4)
			local b=string.sub(v.fakecolor,5,6)
			configData[k].NewFakeColor = LuaColor(r,g,b)
		else
			logError("---   数据格式错误:fakecolor", v.fakecolor)
		end
	end
end
function apcolor_config.GetList()
	return __NewConfigData
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
apcolor_config.AnalyseConfig()
----%%%-------------%%%----








return apcolor_config
