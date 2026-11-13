



---@class dictpassaward_config




dictpassaward_config = {}
---@type table<number,dictpassaward_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictpassaward')), '')
local bytes = mono.LoadBytes('dictpassaward')
local cfg = assert(Dll_PB.decode('dictpassaward_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictpassaward.txt'
function dictpassaward_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 foundid = ConvertToNumber(configName, 'foundid', columns[2]),
		 foundtype = ConvertToNumber(configName, 'foundtype', columns[3]),
		 subid = columns[4],
		 level = ConvertToNumber(configName, 'level', columns[5]),
		 lvexp = ConvertToNumber(configName, 'lvexp', columns[6]),
		 freeawards = columns[7],
		 highawards = columns[8],
		 linksub = columns[9],
		 levelshow = columns[10],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictpassaward_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictpassaward_config_cell>
function dictpassaward_config.GetConfigData() return configData end
---@return dictpassaward_config_cell
function dictpassaward_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@return table<number,table<number,table<number,dictpassaward_config_cell>>>
local NewCfgData={}
function dictpassaward_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if NewCfgData[v.foundid]==nil then
			NewCfgData[v.foundid]={}
		end
		if NewCfgData[v.foundid][tonumber(v.subid)]==nil then
			NewCfgData[v.foundid][tonumber(v.subid)]={}
		end
		if v.level>0 and v.freeawards~="0" then
			table.insert(NewCfgData[v.foundid][tonumber(v.subid)],v)
		end
	end
	for k, v in pairs(NewCfgData) do
		for m, n in pairs(v) do
			table.sort(n,function(a, b)
				return  a.level<b.level
			end)
		end

	end
	for k, v in pairs(configData) do
		for m, n in pairs(configData) do
			if n.foundid==v.foundid and n.subid==v.subid and n.level==v.level-1 then
				v.LastCfg=n
				break
			end
		end
	end
end
function dictpassaward_config.GetAwardListByFoundId(foundid,subId)
	if NewCfgData[foundid] then
		if NewCfgData[foundid][subId] then
			return NewCfgData[foundid][subId]
		end
	end
	return {}
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictpassaward_config.AnalyseConfig()
----%%%-------------%%%----








return dictpassaward_config
