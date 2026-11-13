


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/headicon')), '')
local datalist = {}
local textname = 'headicon.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("headicon", "id", param[1])
	 data.type = ConvertToNumber("headicon", "type", param[2])
	 data.subtype = ConvertToNumber("headicon", "subtype", param[3])
	 data.icon = param[4]
	 data.name = param[5]
	 data.unlocktype = ConvertToNumber("headicon", "unlocktype", param[6])
	 data.cond = param[7]
	 data.term = param[8]
	 data.endTime = ConvertToNumber("headicon", "endTime", param[9])
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
	 local reqBytes = assert(Dll_PB.encode('headicon_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
