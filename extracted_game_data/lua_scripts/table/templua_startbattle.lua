


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/startbattle')), '')
local datalist = {}
local textname = 'startbattle.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("startbattle", "id", param[1])
	 data.sceneId = ConvertToNumber("startbattle", "sceneId", param[2])
	 data.trackId = ConvertToNumber("startbattle", "trackId", param[3])
	 data.round = ConvertToNumber("startbattle", "round", param[4])
	 data.npcs = param[5]
	 data.track = param[6]
	 data.storygroup = stringSplitToNumber(param[7], '|')
	 data.view = param[8]
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
	 local reqBytes = assert(Dll_PB.encode('startbattle_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
