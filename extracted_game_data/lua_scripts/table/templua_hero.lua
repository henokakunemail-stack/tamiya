


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/hero')), '')
local datalist = {}
local textname = 'hero.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("hero", "id", param[1])
	 data.name = param[2]
	 data.normalpicture = ConvertToNumber("hero", "normalpicture", param[3])
	 data.smallpicture = ConvertToNumber("hero", "smallpicture", param[4])
	 data.confusepicture = ConvertToNumber("hero", "confusepicture", param[5])
	 data.angrypicture = ConvertToNumber("hero", "angrypicture", param[6])
	 data.shockpicture = ConvertToNumber("hero", "shockpicture", param[7])
	 data.icon = param[8]
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
	 local reqBytes = assert(Dll_PB.encode('hero_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
