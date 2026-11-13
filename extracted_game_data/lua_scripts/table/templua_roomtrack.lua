


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/roomtrack')), '')
local datalist = {}
local textname = 'roomtrack.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("roomtrack", "id", param[1])
	 data.type = ConvertToNumber("roomtrack", "type", param[2])
	 data.trackId = ConvertToNumber("roomtrack", "trackId", param[3])
	 data.weight = ConvertToNumber("roomtrack", "weight", param[4])
	 data.logo = param[5]
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
	 local reqBytes = assert(Dll_PB.encode('roomtrack_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
