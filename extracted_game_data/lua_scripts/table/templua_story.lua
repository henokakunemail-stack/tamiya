


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/story')), '')
local datalist = {}
local textname = 'story.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("story", "id", param[1])
	 data.storyid = ConvertToNumber("story", "storyid", param[2])
	 data.sort = ConvertToNumber("story", "sort", param[3])
	 data.stepid = ConvertToNumber("story", "stepid", param[4])
	 data.skipType = ConvertToNumber("story", "skipType", param[5])
	 data.skipParam = param[6]
	 data.skipStoryBtnDelay = ConvertToNumber("story", "skipStoryBtnDelay", param[7])
	 data.skipStepBtnDelay = ConvertToNumber("story", "skipStepBtnDelay", param[8])
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
	 local reqBytes = assert(Dll_PB.encode('story_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
