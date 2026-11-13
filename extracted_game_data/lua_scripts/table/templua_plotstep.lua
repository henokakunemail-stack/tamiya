


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/plotstep')), '')
local datalist = {}
local textname = 'plotstep.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("plotstep", "id", param[1])
	 data.during = ConvertToNumber("plotstep", "during", param[2])
	 data.skiptype = ConvertToNumber("plotstep", "skiptype", param[3])
	 data.skipparam = ConvertToNumber("plotstep", "skipparam", param[4])
	 data.actions = stringSplitToNumber(param[5], '|')
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
	 local reqBytes = assert(Dll_PB.encode('plotstep_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
