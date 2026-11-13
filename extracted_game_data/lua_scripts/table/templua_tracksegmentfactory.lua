


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/tracksegmentfactory')), '')
local datalist = {}
local textname = 'tracksegmentfactory.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("tracksegmentfactory", "id", param[1])
	 data.type = ConvertToNumber("tracksegmentfactory", "type", param[2])
	 data.typeDesc = param[3]
	 data.blue = ConvertToNumber("tracksegmentfactory", "blue", param[4])
	 data.red = ConvertToNumber("tracksegmentfactory", "red", param[5])
	 data.white = ConvertToNumber("tracksegmentfactory", "white", param[6])
	 data.time = ConvertToNumber("tracksegmentfactory", "time", param[7])
	 data.cost = param[8]
	 data.technology = ConvertToNumber("tracksegmentfactory", "technology", param[9])
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
	 local reqBytes = assert(Dll_PB.encode('tracksegmentfactory_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
