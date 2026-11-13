


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/storystep')), '')
local datalist = {}
local textname = 'storystep.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("storystep", "id", param[1])
	 data.stepid = ConvertToNumber("storystep", "stepid", param[2])
	 data.actionType = ConvertToNumber("storystep", "actionType", param[3])
	 data.actionid = ConvertToNumber("storystep", "actionid", param[4])
	 data.delay = ConvertToNumber("storystep", "delay", param[5])
	 data.during = ConvertToNumber("storystep", "during", param[6])
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
	 local reqBytes = assert(Dll_PB.encode('storystep_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
