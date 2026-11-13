


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/recruitaward')), '')
local datalist = {}
local textname = 'recruitaward.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("recruitaward", "id", param[1])
	 data.recruitid = ConvertToNumber("recruitaward", "recruitid", param[2])
	 data.awardid = ConvertToNumber("recruitaward", "awardid", param[3])
	 data.proptype = ConvertToNumber("recruitaward", "proptype", param[4])
	 data.propid = ConvertToNumber("recruitaward", "propid", param[5])
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
	 local reqBytes = assert(Dll_PB.encode('recruitaward_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
