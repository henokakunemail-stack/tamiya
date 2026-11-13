


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/qualifyingrank')), '')
local datalist = {}
local textname = 'qualifyingrank.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("qualifyingrank", "id", param[1])
	 data.name = param[2]
	 data.star = ConvertToNumber("qualifyingrank", "star", param[3])
	 data.integral = ConvertToNumber("qualifyingrank", "integral", param[4])
	 data.reward = param[5]
	 data.icon = param[6]
	 data.rankidx = ConvertToNumber("qualifyingrank", "rankidx", param[7])
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
	 local reqBytes = assert(Dll_PB.encode('qualifyingrank_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
