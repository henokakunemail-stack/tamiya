


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/novicetask')), '')
local datalist = {}
local textname = 'novicetask.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("novicetask", "id", param[1])
	 data.description = param[2]
	 data.openday = ConvertToNumber("novicetask", "openday", param[3])
	 data.condType = ConvertToNumber("novicetask", "condType", param[4])
	 data.condPara = param[5]
	 data.reward = param[6]
	 data.progress = ConvertToNumber("novicetask", "progress", param[7])
	 data.taskpoint = ConvertToNumber("novicetask", "taskpoint", param[8])
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
	 local reqBytes = assert(Dll_PB.encode('novicetask_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
