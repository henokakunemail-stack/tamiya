


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/map')), '')
local datalist = {}
local textname = 'map.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("map", "id", param[1])
	 data.type = ConvertToNumber("map", "type", param[2])
	 data.mapidx = param[3]
	 data.mapname = param[4]
	 data.mapicon = param[5]
	 data.allstarsnum = ConvertToNumber("map", "allstarsnum", param[6])
	 data.starsnum = param[7]
	 data.reward = param[8]
	 data.bg = param[9]
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
	 local reqBytes = assert(Dll_PB.encode('map_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
