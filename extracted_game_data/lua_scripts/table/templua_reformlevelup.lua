


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/reformlevelup')), '')
local datalist = {}
local textname = 'reformlevelup.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("reformlevelup", "id", param[1])
	 data.group = ConvertToNumber("reformlevelup", "group", param[2])
	 data.level = ConvertToNumber("reformlevelup", "level", param[3])
	 data.costNum1 = ConvertToNumber("reformlevelup", "costNum1", param[4])
	 data.costNum2 = ConvertToNumber("reformlevelup", "costNum2", param[5])
	 data.costNum3 = ConvertToNumber("reformlevelup", "costNum3", param[6])
	 data.goldNum = ConvertToNumber("reformlevelup", "goldNum", param[7])
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
	 local reqBytes = assert(Dll_PB.encode('reformlevelup_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
