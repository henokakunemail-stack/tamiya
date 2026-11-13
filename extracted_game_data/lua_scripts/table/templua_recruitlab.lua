


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/recruitlab')), '')
local datalist = {}
local textname = 'recruitlab.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("recruitlab", "id", param[1])
	 data.recruitid = ConvertToNumber("recruitlab", "recruitid", param[2])
	 data.prize = ConvertToNumber("recruitlab", "prize", param[3])
	 data.awardid = ConvertToNumber("recruitlab", "awardid", param[4])
	 data.recruitlabDesc = param[5]
	 data.showFabric = ConvertToNumber("recruitlab", "showFabric", param[6])
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
	 local reqBytes = assert(Dll_PB.encode('recruitlab_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
