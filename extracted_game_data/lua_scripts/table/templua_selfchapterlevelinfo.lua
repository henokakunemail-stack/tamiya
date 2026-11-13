


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/selfchapterlevelinfo')), '')
local datalist = {}
local textname = 'selfchapterlevelinfo.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("selfchapterlevelinfo", "id", param[1])
	 data.sceneId = ConvertToNumber("selfchapterlevelinfo", "sceneId", param[2])
	 data.trackId = ConvertToNumber("selfchapterlevelinfo", "trackId", param[3])
	 data.npcs = param[4]
	 data.rewardshow = param[5]
	 data.dropReward = param[6]
	 data.joinCount = ConvertToNumber("selfchapterlevelinfo", "joinCount", param[7])
	 data.name = param[8]
	 data.desc = param[9]
	 data.leveltype = ConvertToNumber("selfchapterlevelinfo", "leveltype", param[10])
	 data.bossIcon = param[11]
	 data.pos = param[12]
	 data.input = param[13]
	 data.output = param[14]
	 data.temppos = param[15]
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
	 local reqBytes = assert(Dll_PB.encode('selfchapterlevelinfo_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
