


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/pvelevel')), '')
local datalist = {}
local textname = 'pvelevel.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("pvelevel", "id", param[1])
	 data.chapterId = ConvertToNumber("pvelevel", "chapterId", param[2])
	 data.levelID = ConvertToNumber("pvelevel", "levelID", param[3])
	 data.stageorder = param[4]
	 data.name = param[5]
	 data.leveltips = param[6]
	 data.minimap = param[7]
	 data.leveltype = ConvertToNumber("pvelevel", "leveltype", param[8])
	 data.leveltypePar = param[9]
	 data.levelicon = param[10]
	 data.tili = ConvertToNumber("pvelevel", "tili", param[11])
	 data.gold = param[12]
	 data.rewardshow = param[13]
	 data.reward = param[14]
	 data.firstreward = param[15]
	 data.limitNum = ConvertToNumber("pvelevel", "limitNum", param[16])
	 data.trackType = param[17]
	 data.sceneId = ConvertToNumber("pvelevel", "sceneId", param[18])
	 data.mapId = ConvertToNumber("pvelevel", "mapId", param[19])
	 data.mapnodeId = param[20]
	 data.round = ConvertToNumber("pvelevel", "round", param[21])
	 data.pTrackId = ConvertToNumber("pvelevel", "pTrackId", param[22])
	 data.npcs = param[23]
	 data.track = param[24]
	 data.starspar = param[25]
	 data.raceInfo = stringSplit(param[26], '|')
	 data.storygroup = stringSplitToNumber(param[27], '|')
	 data.trackId = ConvertToNumber("pvelevel", "trackId", param[28])
	 data.cameraId = ConvertToNumber("pvelevel", "cameraId", param[29])
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
	 local reqBytes = assert(Dll_PB.encode('pvelevel_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
