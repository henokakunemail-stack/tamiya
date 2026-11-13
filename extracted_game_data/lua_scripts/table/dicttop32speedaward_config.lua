



---@class dicttop32speedaward_config




dicttop32speedaward_config = {}
---@type table<number,dicttop32speedaward_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dicttop32speedaward')), '')
local bytes = mono.LoadBytes('dicttop32speedaward')
local cfg = assert(Dll_PB.decode('dicttop32speedaward_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dicttop32speedaward.txt'
function dicttop32speedaward_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 seasonid = ConvertToNumber(configName, 'seasonid', columns[2]),
		 speedfrom = ConvertToNumber(configName, 'speedfrom', columns[3]),
		 speedto = ConvertToNumber(configName, 'speedto', columns[4]),
		 awardids = columns[5],
		 awardnums = columns[6],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dicttop32speedaward_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dicttop32speedaward_config_cell>
function dicttop32speedaward_config.GetConfigData() return configData end
---@return dicttop32speedaward_config_cell
function dicttop32speedaward_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,table<number,dicttop32speedaward_config_cell>>
local __NewReward = {}
function dicttop32speedaward_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if __NewReward[v.seasonid]==nil then
			__NewReward[v.seasonid]={}
		end
		table.insert(__NewReward[v.seasonid],v)
	end
end
function dicttop32speedaward_config.GetDataByRank(rank,seasonid)
	for k, v in pairs(__NewReward[seasonid]) do
		if rank <= v.speedto and rank>=v.speedfrom then
			return v
		end
	end
	return nil
end
function dicttop32speedaward_config.GetDataBySeasonid(seasonid)
	return __NewReward[seasonid]
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dicttop32speedaward_config.AnalyseConfig()
----%%%-------------%%%----








return dicttop32speedaward_config
