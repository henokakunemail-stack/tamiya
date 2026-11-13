



---@class dictactivitycopy_config




dictactivitycopy_config = {}
---@type table<number,dictactivitycopy_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictactivitycopy')), '')
local bytes = mono.LoadBytes('dictactivitycopy')
local cfg = assert(Dll_PB.decode('dictactivitycopy_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictactivitycopy.txt'
function dictactivitycopy_config.Load()
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
		 name = columns[5],
		 desc = columns[6],
		 levelicon = columns[7],
		 openflag = ConvertToNumber(configName, 'openflag', columns[8]),
		 unlockflag = ConvertToNumber(configName, 'unlockflag', columns[9]),
		 paypower = ConvertToNumber(configName, 'paypower', columns[10]),
		 sceneId = ConvertToNumber(configName, 'sceneId', columns[11]),
		 trackid = columns[12],
		 npcid = columns[13],
		 playertrackno = columns[14],
		 npctrackno = columns[15],
		 round = columns[16],
		 firstdown = ConvertToNumber(configName, 'firstdown', columns[17]),
		 firstdownshow = columns[18],
		 copydowns = columns[19],
		 cameraId = ConvertToNumber(configName, 'cameraId', columns[20]),
		 comicname = columns[21],
		 racetype = columns[22],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictactivitycopy_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictactivitycopy_config_cell>
function dictactivitycopy_config.GetConfigData() return configData end
---@return dictactivitycopy_config_cell
function dictactivitycopy_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function dictactivitycopy_config.AnalyseConfig()
	for k, v in pairs(configData) do
		---@type PVELevelBattleData
		local trackids=stringSplitToNumber(v.trackid,';')
		local npcids=stringSplit(v.npcid,';')
		local playertracknos=stringSplitToNumber(v.playertrackno,';')
		local npctracknos=stringSplit(v.npctrackno,';')
		local rounds=stringSplitToNumber(v.round,';')
		v.BattleInfoList={}
		if not CommonHelper:IsNullOrEmpty(v.comicname) and v.comicname~="-1" then
			v.comicname=string.format("%s.png",v.comicname)
		end
		if v.racetype~="0" and v.racetype then
			local raceType=stringSplitToNumber(v.racetype,':')
			v.BattleType=raceType[1]
			v.BattleCars=raceType[2]
			v.BattleTime=raceType[3]
		end

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
dictactivitycopy_config.AnalyseConfig()
----%%%-------------%%%----








return dictactivitycopy_config
