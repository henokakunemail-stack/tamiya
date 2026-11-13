


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/pvelevelfield')), '')
local datalist = {}
local textname = 'pvelevelfield.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("pvelevelfield", "id", param[1])
	 data.chapterId = ConvertToNumber("pvelevelfield", "chapterId", param[2])
	 data.levelID = ConvertToNumber("pvelevelfield", "levelID", param[3])
	 data.stageorder = param[4]
	 data.name = param[5]
	 data.leveltips = param[6]
	 data.minimap = param[7]
	 data.leveltype = ConvertToNumber("pvelevelfield", "leveltype", param[8])
	 data.leveltypePar = param[9]
	 data.levelicon = param[10]
	 data.gold = param[11]
	 data.rewardshow = param[12]
	 data.reward = param[13]
	 data.firstreward = param[14]
	 data.trackType = param[15]
	 data.sceneId = ConvertToNumber("pvelevelfield", "sceneId", param[16])
	 data.mapId = ConvertToNumber("pvelevelfield", "mapId", param[17])
	 data.mapnodeId = param[18]
	 data.round = ConvertToNumber("pvelevelfield", "round", param[19])
	 data.pTrackId = ConvertToNumber("pvelevelfield", "pTrackId", param[20])
	 data.npcs = param[21]
	 data.track = param[22]
	 data.starspar = param[23]
	 data.raceInfo = stringSplit(param[24], '|')
	 data.storygroup = stringSplitToNumber(param[25], '|')
	 data.trackId = ConvertToNumber("pvelevelfield", "trackId", param[26])
	 data.cameraId = ConvertToNumber("pvelevelfield", "cameraId", param[27])
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
	 local reqBytes = assert(Dll_PB.encode('pvelevelfield_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
