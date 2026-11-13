


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/partsreformfactor')), '')
local datalist = {}
local textname = 'partsreformfactor.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("partsreformfactor", "id", param[1])
	 data.type = ConvertToNumber("partsreformfactor", "type", param[2])
	 data.school = ConvertToNumber("partsreformfactor", "school", param[3])
	 data.articleid = ConvertToNumber("partsreformfactor", "articleid", param[4])
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
	 local reqBytes = assert(Dll_PB.encode('partsreformfactor_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
