


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/partreformentry')), '')
local datalist = {}
local textname = 'partreformentry.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("partreformentry", "id", param[1])
	 data.name = param[2]
	 data.desc = param[3]
	 data.minStar = ConvertToNumber("partreformentry", "minStar", param[4])
	 data.attr = param[5]
	 data.increase = param[6]
	 data.frequency = ConvertToNumber("partreformentry", "frequency", param[7])
	 data.rate = param[8]
	 data.good = param[9]
	 data.excellent = param[10]
	 data.perfect = param[11]
	 data.cost = param[12]
	 data.goldcost = ConvertToNumber("partreformentry", "goldcost", param[13])
	 data.lvupcost = param[14]
	 data.increaseIcon = param[15]
	 data.technology = ConvertToNumber("partreformentry", "technology", param[16])
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
	 local reqBytes = assert(Dll_PB.encode('partreformentry_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
