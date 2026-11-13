


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/comsys')), '')
local datalist = {}
local textname = 'comsys.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("comsys", "id", param[1])
	 data.name = param[2]
	 data.type = param[3]
	 data.session = param[4]
	 data.creatcost = param[5]
	 data.applycost = param[6]
	 data.creatreward = param[7]
	 data.reward = param[8]
	 data.turns = ConvertToNumber("comsys", "turns", param[9])
	 data.showrwd = param[10]
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
	 local reqBytes = assert(Dll_PB.encode('comsys_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
