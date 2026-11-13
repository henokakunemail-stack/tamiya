


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/championships')), '')
local datalist = {}
local textname = 'championships.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("championships", "id", param[1])
	 data.type = ConvertToNumber("championships", "type", param[2])
	 data.week = ConvertToNumber("championships", "week", param[3])
	 data.cost = param[4]
	 data.condition = param[5]
	 data.rules = param[6]
	 data.time = ConvertToNumber("championships", "time", param[7])
	 data.duration = ConvertToNumber("championships", "duration", param[8])
	 data.times = ConvertToNumber("championships", "times", param[9])
	 data.timeLimit = ConvertToNumber("championships", "timeLimit", param[10])
	 data.price = ConvertToNumber("championships", "price", param[11])
	 data.reward = param[12]
	 data.sceneId = ConvertToNumber("championships", "sceneId", param[13])
	 data.trackId = ConvertToNumber("championships", "trackId", param[14])
	 data.name = param[15]
	 data.rulename = param[16]
	 data.icon = param[17]
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
	 local reqBytes = assert(Dll_PB.encode('championships_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
