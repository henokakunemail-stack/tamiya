



---@class dictkillerstage_config




dictkillerstage_config = {}
---@type table<number,dictkillerstage_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictkillerstage')), '')
local bytes = mono.LoadBytes('dictkillerstage')
local cfg = assert(Dll_PB.decode('dictkillerstage_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictkillerstage.txt'
function dictkillerstage_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 btime = columns[2],
		 etime = columns[3],
		 addstage = ConvertToNumber(configName, 'addstage', columns[4]),
		 addstage1 = ConvertToNumber(configName, 'addstage1', columns[5]),
		 stagetype = ConvertToNumber(configName, 'stagetype', columns[6]),
		 matchstr = ConvertToNumber(configName, 'matchstr', columns[7]),
		 selectn = ConvertToNumber(configName, 'selectn', columns[8]),
		 desc = columns[9],
		 serverdesc = columns[10],
		 stageday = ConvertToNumber(configName, 'stageday', columns[11]),
		 matchnum = ConvertToNumber(configName, 'matchnum', columns[12]),
		 guesstype = ConvertToNumber(configName, 'guesstype', columns[13]),
		 guessnum = ConvertToNumber(configName, 'guessnum', columns[14]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictkillerstage_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictkillerstage_config_cell>
function dictkillerstage_config.GetConfigData() return configData end
---@return dictkillerstage_config_cell
function dictkillerstage_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local _RacSuperBattleStage={}
local _RacSuperBattleStage2={}
function dictkillerstage_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if v.matchstr~=0 and v.stagetype~=RaceSuperBattleBattleState.KnockoutBanTrack then
			_RacSuperBattleStage[v.addstage]=v.matchstr
			_RacSuperBattleStage2[v.stageday]=v.matchstr
		end
	end
end
function dictkillerstage_config.Get_RankingStage(day)
	return  _RacSuperBattleStage[day]
end
function dictkillerstage_config.Get_RacSuperBattleStage()
	return  _RacSuperBattleStage2
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictkillerstage_config.AnalyseConfig()
----%%%-------------%%%----








return dictkillerstage_config
