


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/challenge')), '')
local datalist = {}
local textname = 'challenge.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("challenge", "id", param[1])
	 data.team = ConvertToNumber("challenge", "team", param[2])
	 data.unlocklevel = ConvertToNumber("challenge", "unlocklevel", param[3])
	 data.reward1 = param[4]
	 data.reward2 = param[5]
	 data.reward3 = param[6]
	 data.reward4 = param[7]
	 data.pTrackId = ConvertToNumber("challenge", "pTrackId", param[8])
	 data.npcs = param[9]
	 data.track = param[10]
	 data.racetrack = ConvertToNumber("challenge", "racetrack", param[11])
	 data.sceneId = param[12]
	 data.scene_camera = param[13]
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
	 local reqBytes = assert(Dll_PB.encode('challenge_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
