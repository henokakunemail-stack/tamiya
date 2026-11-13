


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/storyactionbackground')), '')
local datalist = {}
local textname = 'storyactionbackground.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("storyactionbackground", "id", param[1])
	 data.type = ConvertToNumber("storyactionbackground", "type", param[2])
	 data.bgFile = param[3]
	 data.bgPos = ConvertToNumber("storyactionbackground", "bgPos", param[4])
	 data.bgColor = param[5]
	 data.bgSize = stringSplitToNumber(param[6], '|')
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
	 local reqBytes = assert(Dll_PB.encode('storyactionbackground_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
