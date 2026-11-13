


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/tracksegement')), '')
local datalist = {}
local textname = 'tracksegement.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("tracksegement", "id", param[1])
	 data.configName = param[2]
	 data.resname = param[3]
	 data.type = ConvertToNumber("tracksegement", "type", param[4])
	 data.numbers = ConvertToNumber("tracksegement", "numbers", param[5])
	 data.toward = ConvertToNumber("tracksegement", "toward", param[6])
	 data.name = param[7]
	 data.desc = param[8]
	 data.material = param[9]
	 data.icon = param[10]
	 data.previewIcon = param[11]
	 data.appearance = param[12]
	 data.bottomMatID = ConvertToNumber("tracksegement", "bottomMatID", param[13])
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
	 local reqBytes = assert(Dll_PB.encode('tracksegement_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
