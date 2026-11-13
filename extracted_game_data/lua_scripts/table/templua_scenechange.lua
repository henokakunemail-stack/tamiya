


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/scenechange')), '')
local datalist = {}
local textname = 'scenechange.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("scenechange", "id", param[1])
	 data.scenename = param[2]
	 data.sceneroot = param[3]
	 data.cameraroot = param[4]
	 data.fitenable = ConvertToNumber("scenechange", "fitenable", param[5])
	 data.cameraparammax = param[6]
	 data.cameraparammin = param[7]
	 data.cameraparam = param[8]
	 data.fog = ConvertToNumber("scenechange", "fog", param[9])
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
	 local reqBytes = assert(Dll_PB.encode('scenechange_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
