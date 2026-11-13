


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/segementappearance')), '')
local datalist = {}
local textname = 'segementappearance.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("segementappearance", "id", param[1])
	 data.appearanceMat = param[2]
	 data.meshType = ConvertToNumber("segementappearance", "meshType", param[3])
	 data.bottomMatID = ConvertToNumber("segementappearance", "bottomMatID", param[4])
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
	 local reqBytes = assert(Dll_PB.encode('segementappearance_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
