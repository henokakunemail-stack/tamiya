



---@class dicthidecopy_config




dicthidecopy_config = {}
---@type table<number,dicthidecopy_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dicthidecopy')), '')
local bytes = mono.LoadBytes('dicthidecopy')
local cfg = assert(Dll_PB.decode('dicthidecopy_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dicthidecopy.txt'
function dicthidecopy_config.Load()
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
		 needstar = ConvertToNumber(configName, 'needstar', columns[9]),
		 paypower = ConvertToNumber(configName, 'paypower', columns[10]),
		 openflag = columns[11],
		 unlockflag = ConvertToNumber(configName, 'unlockflag', columns[12]),
		 sceneId = ConvertToNumber(configName, 'sceneId', columns[13]),
		 trackid = columns[14],
		 npcid = columns[15],
		 playertrackno = columns[16],
		 npctrackno = columns[17],
		 round = columns[18],
		 firstdown = ConvertToNumber(configName, 'firstdown', columns[19]),
		 copydowns = columns[20],
		 maxenter = ConvertToNumber(configName, 'maxenter', columns[21]),
		 storygroup = columns[22],
		 cameraId = ConvertToNumber(configName, 'cameraId', columns[23]),
		 needlevel = ConvertToNumber(configName, 'needlevel', columns[24]),
		 guideId = ConvertToNumber(configName, 'guideId', columns[25]),
		 GuideId = ConvertToNumber(configName, 'GuideId', columns[26]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dicthidecopy_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dicthidecopy_config_cell>
function dicthidecopy_config.GetConfigData() return configData end
---@return dicthidecopy_config_cell
function dicthidecopy_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function dicthidecopy_config.AnalyseConfig()
	for k, v in pairs(configData) do
		---@type PVELevelBattleData

		local trackids=stringSplitToNumber(v.trackid,';')
		local npcids=stringSplit(v.npcid,';')
		local playertracknos=stringSplitToNumber(v.playertrackno,';')
		local npctracknos=stringSplit(v.npctrackno,';')
		local rounds=stringSplitToNumber(v.round,';')
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
dicthidecopy_config.AnalyseConfig()
----%%%-------------%%%----








return dicthidecopy_config
