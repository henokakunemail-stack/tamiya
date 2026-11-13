



---@class dictcopy_config




dictcopy_config = {}
---@type table<number,dictcopy_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictcopy')), '')
local bytes = mono.LoadBytes('dictcopy')
local cfg = assert(Dll_PB.decode('dictcopy_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictcopy.txt'
function dictcopy_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 copytype = ConvertToNumber(configName, 'copytype', columns[2]),
		 chapterid = ConvertToNumber(configName, 'chapterid', columns[3]),
		 nextcopys = columns[4],
		 precopys = columns[5],
		 name = columns[6],
		 minimap = columns[7],
		 levelicon = columns[8],
		 openflag = columns[9],
		 needstar = ConvertToNumber(configName, 'needstar', columns[10]),
		 paypower = ConvertToNumber(configName, 'paypower', columns[11]),
		 unlockflag = ConvertToNumber(configName, 'unlockflag', columns[12]),
		 sceneId = ConvertToNumber(configName, 'sceneId', columns[13]),
		 trackid = columns[14],
		 npcid = columns[15],
		 playertrackno = columns[16],
		 npctrackno = columns[17],
		 round = columns[18],
		 superparts = columns[19],
		 firstdown = ConvertToNumber(configName, 'firstdown', columns[20]),
		 firstdownshow = columns[21],
		 copydowns = columns[22],
		 copydownsshow = columns[23],
		 maxenter = ConvertToNumber(configName, 'maxenter', columns[24]),
		 storygroup = columns[25],
		 cameraId = ConvertToNumber(configName, 'cameraId', columns[26]),
		 needlevel = ConvertToNumber(configName, 'needlevel', columns[27]),
		 timescale = ConvertToNumber(configName, 'timescale', columns[28]),
		 racetype = columns[29],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictcopy_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictcopy_config_cell>
function dictcopy_config.GetConfigData() return configData end
---@return dictcopy_config_cell
function dictcopy_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@class PVELevelBattleData
---@field SceneId
---@field TrackId
---@field NpcIds
---@field PlayerTrack
---@field NpcTracks
---@field Round

function dictcopy_config.AnalyseConfig()
	for k, v in pairs(configData) do


		local trackids=stringSplitToNumber(v.trackid,';')
		local npcids=stringSplit(v.npcid,';')
		local playertracknos=stringSplitToNumber(v.playertrackno,';')
		local npctracknos=stringSplit(v.npctrackno,';')
		local rounds=stringSplitToNumber(v.round,';')
		local partNum=stringSplitToNumber(v.superparts,':')
        v.GiftPartId=partNum[1]
        v.GiftPartNum=partNum[2]
		if v.racetype~="0" then
			local raceType=stringSplitToNumber(v.racetype,':')
			v.BattleType=raceType[1]
			v.BattleCars=raceType[2]
			v.BattleTime=raceType[3]
		end
		---@type PVELevelBattleData
		v.BattleInfoList={}
		for i = 1, #trackids do
			local temp={}
			temp.SceneId=v.sceneId
			temp.TrackId=trackids[i]
			temp.NpcIds=stringSplitToNumber(npcids[i],':')
			temp.NpcTracks=stringSplitToNumber(npctracknos[i],':')
			temp.Round=rounds[i]
			temp.PlayerTrack=playertracknos[i]
			table.insert(v.BattleInfoList,temp)
		end
	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictcopy_config.AnalyseConfig()
----%%%-------------%%%----








return dictcopy_config
