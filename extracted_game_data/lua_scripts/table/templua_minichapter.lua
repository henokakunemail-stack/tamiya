


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/minichapter')), '')
local datalist = {}
local textname = 'minichapter.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("minichapter", "id", param[1])
	 data.levelID = ConvertToNumber("minichapter", "levelID", param[2])
	 data.charpterId = ConvertToNumber("minichapter", "charpterId", param[3])
	 data.chapterIdx = param[4]
	 data.chaptername = param[5]
	 data.levelicon = param[6]
	 data.stageorder = param[7]
	 data.name = param[8]
	 data.leveltips = param[9]
	 data.minimap = param[10]
	 data.nextIds = param[11]
	 data.raceType = ConvertToNumber("minichapter", "raceType", param[12])
	 data.type = ConvertToNumber("minichapter", "type", param[13])
	 data.subType = ConvertToNumber("minichapter", "subType", param[14])
	 data.isboss = ConvertToNumber("minichapter", "isboss", param[15])
	 data.gold = param[16]
	 data.rewardshow = param[17]
	 data.reward = param[18]
	 data.firstreward = param[19]
	 data.trackType = param[20]
	 data.sceneId = param[21]
	 data.mapId = ConvertToNumber("minichapter", "mapId", param[22])
	 data.resName = param[23]
	 data.startNum = ConvertToNumber("minichapter", "startNum", param[24])
	 data.endNum = ConvertToNumber("minichapter", "endNum", param[25])
	 data.round = ConvertToNumber("minichapter", "round", param[26])
	 data.pTrackId = ConvertToNumber("minichapter", "pTrackId", param[27])
	 data.npcs = param[28]
	 data.track = param[29]
	 data.raceInfo = stringSplit(param[30], '|')
	 data.storygroup = stringSplitToNumber(param[31], '|')
	 data.scene_camera = param[32]
	 data.scene_camera_time = param[33]
	 data.battle_camera_mode = ConvertToNumber("minichapter", "battle_camera_mode", param[34])
	 data.start_camera = param[35]
	 data.end_camera = param[36]
	 data.trackresname = param[37]
	 data.trackid = ConvertToNumber("minichapter", "trackid", param[38])
	 table.insert(datalist, data)
end

local function analyseList()
	 local content = CS.Horizon.EditorTool.TableCfg.PBCfg.ReadTxt(textname)
	 local strs = stringSplit(content, '\n')
	 for i = 4, #strs - 1 do
		 local temp = stringSplit(strs[i], '\t')
		 analyse(temp)
	 end
	 local tab = { configData = datalist }
	 local reqBytes = assert(Dll_PB.encode('minichapter_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
