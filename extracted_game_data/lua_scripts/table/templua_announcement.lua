


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/announcement')), '')
local datalist = {}
local textname = 'announcement.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("announcement", "id", param[1])
	 data.title = param[2]
	 data.content = param[3]
	 data.cmd = param[4]
	 data.sort = param[5]
	 data.tpye = ConvertToNumber("announcement", "tpye", param[6])
	 data.weights = ConvertToNumber("announcement", "weights", param[7])
	 data.picture = param[8]
	 data.reward = param[9]
	 data.startTime = ConvertToNumber("announcement", "startTime", param[10])
	 data.endTime = ConvertToNumber("announcement", "endTime", param[11])
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
	 local reqBytes = assert(Dll_PB.encode('announcement_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
