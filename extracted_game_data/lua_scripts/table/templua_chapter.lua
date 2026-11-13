


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/chapter')), '')
local datalist = {}
local textname = 'chapter.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("chapter", "id", param[1])
	 data.charpterId = ConvertToNumber("chapter", "charpterId", param[2])
	 data.chapterIdx = param[3]
	 data.chaptername = param[4]
	 data.charptericon = param[5]
	 data.levelID = ConvertToNumber("chapter", "levelID", param[6])
	 data.levelicon = param[7]
	 data.stageorder = param[8]
	 data.name = param[9]
	 data.leveltips = param[10]
	 data.minimap = param[11]
	 data.nextIds = param[12]
	 data.raceType = ConvertToNumber("chapter", "raceType", param[13])
	 data.type = ConvertToNumber("chapter", "type", param[14])
	 data.subType = ConvertToNumber("chapter", "subType", param[15])
	 data.isboss = ConvertToNumber("chapter", "isboss", param[16])
	 data.gold = param[17]
	 data.rewardshow = param[18]
	 data.reward = param[19]
	 data.trackType = param[20]
	 data.sceneId = param[21]
	 data.mapId = ConvertToNumber("chapter", "mapId", param[22])
	 data.resName = param[23]
	 data.startNum = ConvertToNumber("chapter", "startNum", param[24])
	 data.endNum = ConvertToNumber("chapter", "endNum", param[25])
	 data.round = ConvertToNumber("chapter", "round", param[26])
	 data.pTrackId = ConvertToNumber("chapter", "pTrackId", param[27])
	 data.npcs = param[28]
	 data.track = param[29]
	 data.raceInfo = stringSplit(param[30], '|')
	 data.storygroup = stringSplitToNumber(param[31], '|')
	 data.scene_camera = param[32]
	 data.scene_camera_time = param[33]
	 data.battle_camera_mode = ConvertToNumber("chapter", "battle_camera_mode", param[34])
	 data.start_camera = param[35]
	 data.end_camera = param[36]
	 data.trackresname = param[37]
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
	 local reqBytes = assert(Dll_PB.encode('chapter_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
