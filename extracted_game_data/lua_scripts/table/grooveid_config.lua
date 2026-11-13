



---@class grooveid_config




grooveid_config = {}
---@type table<number,grooveid_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/grooveid')), '')
local bytes = mono.LoadBytes('grooveid')
local cfg = assert(Dll_PB.decode('grooveid_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'grooveid.txt'
function grooveid_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 list = columns[2],
		 partstype = columns[3],
		 bgicon = columns[4],
		 rotate = ConvertToNumber(configName, 'rotate', columns[5]),
		 notice = columns[6],
		 camera = columns[7],
		 noticeerror = columns[8],
		 isbase = ConvertToNumber(configName, 'isbase', columns[9]),
		 replace = columns[10],
		 name = columns[11],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
grooveid_config.Load()
----------以pb方式加载配置表---end




---@return table<number,grooveid_config_cell>
function grooveid_config.GetConfigData() return configData end
---@return grooveid_config_cell
function grooveid_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local _BaseGrooveCfg={}
function grooveid_config.AnalyseConfig()
	for k, v in pairs(configData) do
		configData[k].NewList = stringSplitToNumber(v.list, ',')

		configData[k].NewTypes = {}
		if v.partstype ~= "-1" then
			local strs = stringSplit(v.partstype, ';')
			for i = 1, #strs do
				local types = stringSplitToNumber(strs[i], ',')
				configData[k].NewTypes[i] = types
			end
		end
		if CommonHelper:IsNullOrEmpty(v.bgicon) or v.bgicon=="0" or v.bgicon=="-1" then
			v.bgicon="uitex_sucai_default.png"
		else
			v.bgicon=v.bgicon..".png"
		end
		if configData[k].isbase==1 then
			_BaseGrooveCfg[k]=v
		end
		if v.replace~='0' then
			configData[k].ReplacePartType={}
			local replaces=stringSplit(v.replace, '|')
			for i = 1, #replaces do
			    local temp=	stringSplitToNumber(replaces[i],':')
				table.insert(configData[k].ReplacePartType,{GrooveId=temp[1],PartType=temp[2],PartSubType=temp[3]})
			end
		end

	end
end
function grooveid_config.Get_BaseGrooveCfg()
	return _BaseGrooveCfg
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
grooveid_config.AnalyseConfig()
----%%%-------------%%%----








return grooveid_config
