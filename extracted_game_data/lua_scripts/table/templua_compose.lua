


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/compose')), '')
local datalist = {}
local textname = 'compose.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("compose", "id", param[1])
	 data.name = param[2]
	 data.desc = param[3]
	 data.icon = param[4]
	 data.laboratory = ConvertToNumber("compose", "laboratory", param[5])
	 data.type = ConvertToNumber("compose", "type", param[6])
	 data.tag = ConvertToNumber("compose", "tag", param[7])
	 data.project = ConvertToNumber("compose", "project", param[8])
	 data.interface = ConvertToNumber("compose", "interface", param[9])
	 data.preview = param[10]
	 data.prop1 = param[11]
	 data.prop2 = param[12]
	 data.prop3 = param[13]
	 data.prop4 = param[14]
	 data.prop5 = param[15]
	 data.prop6 = param[16]
	 data.prop7 = param[17]
	 data.prop8 = param[18]
	 data.prop9 = param[19]
	 data.prop10 = param[20]
	 data.gold = ConvertToNumber("compose", "gold", param[21])
	 data.create = param[22]
	 data.addExp = ConvertToNumber("compose", "addExp", param[23])
	 data.probability = ConvertToNumber("compose", "probability", param[24])
	 data.time = ConvertToNumber("compose", "time", param[25])
	 data.tagnameId = ConvertToNumber("compose", "tagnameId", param[26])
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
	 local reqBytes = assert(Dll_PB.encode('compose_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
