



---@class dictcardetail_config




dictcardetail_config = {}
---@type table<number,dictcardetail_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictcardetail')), '')
local bytes = mono.LoadBytes('dictcardetail')
local cfg = assert(Dll_PB.decode('dictcardetail_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictcardetail.txt'
function dictcardetail_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 npcshow = ConvertToNumber(configName, 'npcshow', columns[2]),
		 partseq = columns[3],
		 partid = columns[4],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictcardetail_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictcardetail_config_cell>
function dictcardetail_config.GetConfigData() return configData end
---@return dictcardetail_config_cell
function dictcardetail_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function dictcardetail_config.AnalyseConfig()
	for k, v in pairs(configData) do
		local  groove=stringSplitToNumber(configData[k].partseq,':')
		local  part=stringSplitToNumber(configData[k].partid,':')
		configData[k].car={}
		for i = 1, #groove do
			configData[k].car[groove[i]]=part[i]
		end
		configData[k].partseq=nil
		configData[k].partid=nil
	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictcardetail_config.AnalyseConfig()
----%%%-------------%%%----








return dictcardetail_config
