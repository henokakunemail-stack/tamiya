


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/showmeshcfg')), '')
local datalist = {}
local textname = 'showmeshcfg.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("showmeshcfg", "id", param[1])
	 data.modelpos = ConvertToNumber("showmeshcfg", "modelpos", param[2])
	 data.assembleList = stringSplitToNumber(param[3], '|')
	 data.showPartList = stringSplitToNumber(param[4], '|')
	 data.showPartPos = param[5]
	 data.showPartRot = param[6]
	 data.ShowCameraID = ConvertToNumber("showmeshcfg", "ShowCameraID", param[7])
	 data.UI3DIconList = stringSplitToNumber(param[8], '|')
	 data.UI3DIconPos = param[9]
	 data.UI3DIconRot = param[10]
	 data.IconCameraID = ConvertToNumber("showmeshcfg", "IconCameraID", param[11])
	 data.iconMeshAngle = ConvertToNumber("showmeshcfg", "iconMeshAngle", param[12])
	 data.showLightGroup = ConvertToNumber("showmeshcfg", "showLightGroup", param[13])
	 data.showresname = param[14]
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
	 local reqBytes = assert(Dll_PB.encode('showmeshcfg_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
