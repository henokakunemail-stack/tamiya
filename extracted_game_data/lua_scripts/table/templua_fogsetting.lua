


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/fogsetting')), '')
local datalist = {}
local textname = 'fogsetting.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("fogsetting", "id", param[1])
	 data.fog = ConvertToNumber("fogsetting", "fog", param[2])
	 data.color = param[3]
	 data.mode = ConvertToNumber("fogsetting", "mode", param[4])
	 data.startPoint = ConvertToNumber("fogsetting", "startPoint", param[5])
	 data.endPoint = ConvertToNumber("fogsetting", "endPoint", param[6])
	 data.density = ConvertToNumber("fogsetting", "density", param[7])
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
	 local reqBytes = assert(Dll_PB.encode('fogsetting_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
