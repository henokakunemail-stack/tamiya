


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/formulaparameter')), '')
local datalist = {}
local textname = 'formulaparameter.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("formulaparameter", "id", param[1])
	 data.typeBig = ConvertToNumber("formulaparameter", "typeBig", param[2])
	 data.typeSmall = ConvertToNumber("formulaparameter", "typeSmall", param[3])
	 data.formula = param[4]
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
	 local reqBytes = assert(Dll_PB.encode('formulaparameter_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
