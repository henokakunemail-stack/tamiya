


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/racetrack')), '')
local datalist = {}
local textname = 'racetrack.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("racetrack", "id", param[1])
	 data.name = param[2]
	 data.icon = param[3]
	 data.type = param[4]
	 data.tracksource = ConvertToNumber("racetrack", "tracksource", param[5])
	 data.numbers = param[6]
	 data.round = ConvertToNumber("racetrack", "round", param[7])
	 data.configName = param[8]
	 data.resname = param[9]
	 data.scope = ConvertToNumber("racetrack", "scope", param[10])
	 data.start_camera = param[11]
	 data.end_camera = param[12]
	 data.length = ConvertToNumber("racetrack", "length", param[13])
	 data.logo = param[14]
	 data.roomscope = ConvertToNumber("racetrack", "roomscope", param[15])
	 data.isfield = ConvertToNumber("racetrack", "isfield", param[16])
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
	 local reqBytes = assert(Dll_PB.encode('racetrack_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
