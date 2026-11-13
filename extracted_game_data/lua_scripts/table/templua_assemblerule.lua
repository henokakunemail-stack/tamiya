


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/assemblerule')), '')
local datalist = {}
local textname = 'assemblerule.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("assemblerule", "id", param[1])
	 data.groove = ConvertToNumber("assemblerule", "groove", param[2])
	 data.partsflag = ConvertToNumber("assemblerule", "partsflag", param[3])
	 data.fflaglist = param[4]
	 data.hpoint = param[5]
	 data.offset = param[6]
	 data.symhpoint = param[7]
	 data.symmetry = param[8]
	 data.linkid = ConvertToNumber("assemblerule", "linkid", param[9])
	 data.dyclinkid = ConvertToNumber("assemblerule", "dyclinkid", param[10])
	 data.linkpoint = param[11]
	 data.linkptoffset = param[12]
	 data.symlinkpoint = param[13]
	 data.symptoffset = param[14]
	 data.center = param[15]
	 data.symcenter = param[16]
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
	 local reqBytes = assert(Dll_PB.encode('assemblerule_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
