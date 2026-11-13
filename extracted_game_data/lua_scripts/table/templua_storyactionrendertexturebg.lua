


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/storyactionrendertexturebg')), '')
local datalist = {}
local textname = 'storyactionrendertexturebg.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("storyactionrendertexturebg", "id", param[1])
	 data.Type = ConvertToNumber("storyactionrendertexturebg", "Type", param[2])
	 data.position1 = param[3]
	 data.rotation1 = param[4]
	 data.position2 = param[5]
	 data.rotation2 = param[6]
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
	 local reqBytes = assert(Dll_PB.encode('storyactionrendertexturebg_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
