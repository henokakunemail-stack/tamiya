



---@class plotaction_config




plotaction_config = {}
---@type table<number,plotaction_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/plotaction')), '')
local bytes = mono.LoadBytes('plotaction')
local cfg = assert(Dll_PB.decode('plotaction_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'plotaction.txt'
function plotaction_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 delay = ConvertToNumber(configName, 'delay', columns[2]),
		 actiontype = ConvertToNumber(configName, 'actiontype', columns[3]),
		 playerid = ConvertToNumber(configName, 'playerid', columns[4]),
		 joinmode = ConvertToNumber(configName, 'joinmode', columns[5]),
		 picani = ConvertToNumber(configName, 'picani', columns[6]),
		 iconani = ConvertToNumber(configName, 'iconani', columns[7]),
		 heropicidx = ConvertToNumber(configName, 'heropicidx', columns[8]),
		 hreopicid = ConvertToNumber(configName, 'hreopicid', columns[9]),
		 miniicon = ConvertToNumber(configName, 'miniicon', columns[10]),
		 pos = ConvertToNumber(configName, 'pos', columns[11]),
		 moveidx = ConvertToNumber(configName, 'moveidx', columns[12]),
		 moveani = ConvertToNumber(configName, 'moveani', columns[13]),
		 gary = ConvertToNumber(configName, 'gary', columns[14]),
		 front = ConvertToNumber(configName, 'front', columns[15]),
		 dialogtype = ConvertToNumber(configName, 'dialogtype', columns[16]),
		 dialogani = ConvertToNumber(configName, 'dialogani', columns[17]),
		 contenttype = ConvertToNumber(configName, 'contenttype', columns[18]),
		 content = columns[19],
		 content_t = columns[20],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
plotaction_config.Load()
----------以pb方式加载配置表---end




---@return table<number,plotaction_config_cell>
function plotaction_config.GetConfigData() return configData end
---@return plotaction_config_cell
function plotaction_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function plotaction_config.AnalyseConfig()
	for k, v in pairs(configData) do
		configData[k].NewDelay = v.delay * 0.001
	end

end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
plotaction_config.AnalyseConfig()
----%%%-------------%%%----








return plotaction_config
