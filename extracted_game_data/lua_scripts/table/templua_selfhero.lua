


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/selfhero')), '')
local datalist = {}
local textname = 'selfhero.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("selfhero", "id", param[1])
	 data.tracktype = ConvertToNumber("selfhero", "tracktype", param[2])
	 data.difficulty = ConvertToNumber("selfhero", "difficulty", param[3])
	 data.trackteam = ConvertToNumber("selfhero", "trackteam", param[4])
	 data.track = ConvertToNumber("selfhero", "track", param[5])
	 data.tracknum = ConvertToNumber("selfhero", "tracknum", param[6])
	 data.npcteam = ConvertToNumber("selfhero", "npcteam", param[7])
	 data.npc = ConvertToNumber("selfhero", "npc", param[8])
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
	 local reqBytes = assert(Dll_PB.encode('selfhero_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
