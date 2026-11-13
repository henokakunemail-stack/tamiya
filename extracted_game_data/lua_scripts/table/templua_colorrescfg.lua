


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/colorrescfg')), '')
local datalist = {}
local textname = 'colorrescfg.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("colorrescfg", "id", param[1])
	 data.basecolor = param[2]
	 data.ssscolor = param[3]
	 data.fakecolor = param[4]
	 data.metallic = ConvertToNumber("colorrescfg", "metallic", param[5])
	 data.smoothness = ConvertToNumber("colorrescfg", "smoothness", param[6])
	 data.icon = param[7]
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
	 local reqBytes = assert(Dll_PB.encode('colorrescfg_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
