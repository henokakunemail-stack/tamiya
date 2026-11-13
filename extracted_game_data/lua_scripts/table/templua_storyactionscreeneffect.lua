


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/storyactionscreeneffect')), '')
local datalist = {}
local textname = 'storyactionscreeneffect.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("storyactionscreeneffect", "id", param[1])
	 data.Type = ConvertToNumber("storyactionscreeneffect", "Type", param[2])
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
	 local reqBytes = assert(Dll_PB.encode('storyactionscreeneffect_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
