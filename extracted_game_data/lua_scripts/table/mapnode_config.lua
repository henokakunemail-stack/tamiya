



---@class mapnode_config




mapnode_config = {}
---@type table<number,mapnode_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/mapnode')), '')
local bytes = mono.LoadBytes('mapnode')
local cfg = assert(Dll_PB.decode('mapnode_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'mapnode.txt'
function mapnode_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 chapterid = ConvertToNumber(configName, 'chapterid', columns[2]),
		 pos = columns[3],
		 input = columns[4],
		 output = columns[5],
		 openstar = ConvertToNumber(configName, 'openstar', columns[6]),
		 openpass = ConvertToNumber(configName, 'openpass', columns[7]),
		 openother = columns[8],
		 temppos = columns[9],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
mapnode_config.Load()
----------以pb方式加载配置表---end




---@return table<number,mapnode_config_cell>
function mapnode_config.GetConfigData() return configData end
---@return mapnode_config_cell
function mapnode_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local _chapterDic={}
function mapnode_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if _chapterDic[v.chapterid]==nil then
			_chapterDic[v.chapterid]={}
		end
		table.insert(_chapterDic[v.chapterid],v)
	end
end
function mapnode_config.GetChapterDic()
	return _chapterDic
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
mapnode_config.AnalyseConfig()
----%%%-------------%%%----








return mapnode_config
