


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/task')), '')
local datalist = {}
local textname = 'task.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("task", "id", param[1])
	 data.description = param[2]
	 data.questType = ConvertToNumber("task", "questType", param[3])
	 data.subType = ConvertToNumber("task", "subType", param[4])
	 data.taskChainID = ConvertToNumber("task", "taskChainID", param[5])
	 data.nextIds = ConvertToNumber("task", "nextIds", param[6])
	 data.progressMeth = ConvertToNumber("task", "progressMeth", param[7])
	 data.condType = ConvertToNumber("task", "condType", param[8])
	 data.condPara = param[9]
	 data.reward = param[10]
	 data.activeType = ConvertToNumber("task", "activeType", param[11])
	 data.activeNum = ConvertToNumber("task", "activeNum", param[12])
	 data.progress = ConvertToNumber("task", "progress", param[13])
	 data.jump = param[14]
	 data.cond = param[15]
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
	 local reqBytes = assert(Dll_PB.encode('task_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
