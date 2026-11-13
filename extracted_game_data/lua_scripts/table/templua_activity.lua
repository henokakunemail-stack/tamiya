


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/activity')), '')
local datalist = {}
local textname = 'activity.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("activity", "id", param[1])
	 data.activityType = ConvertToNumber("activity", "activityType", param[2])
	 data.sort = ConvertToNumber("activity", "sort", param[3])
	 data.tab = param[4]
	 data.activityItemId = param[5]
	 data.nextId = param[6]
	 data.mainMenuShow = ConvertToNumber("activity", "mainMenuShow", param[7])
	 data.hide = ConvertToNumber("activity", "hide", param[8])
	 data.icon = param[9]
	 data.bgicon = param[10]
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
	 local reqBytes = assert(Dll_PB.encode('activity_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
