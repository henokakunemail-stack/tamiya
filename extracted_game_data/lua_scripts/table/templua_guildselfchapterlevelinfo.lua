


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/guildselfchapterlevelinfo')), '')
local datalist = {}
local textname = 'guildselfchapterlevelinfo.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("guildselfchapterlevelinfo", "id", param[1])
	 data.sceneId = ConvertToNumber("guildselfchapterlevelinfo", "sceneId", param[2])
	 data.trackId = ConvertToNumber("guildselfchapterlevelinfo", "trackId", param[3])
	 data.npcs = param[4]
	 data.dropReward = param[5]
	 data.joinCount = ConvertToNumber("guildselfchapterlevelinfo", "joinCount", param[6])
	 data.name = param[7]
	 data.desc = param[8]
	 data.leveltype = ConvertToNumber("guildselfchapterlevelinfo", "leveltype", param[9])
	 data.bossIcon = param[10]
	 data.pos = param[11]
	 data.input = param[12]
	 data.output = param[13]
	 data.temppos = param[14]
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
	 local reqBytes = assert(Dll_PB.encode('guildselfchapterlevelinfo_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
