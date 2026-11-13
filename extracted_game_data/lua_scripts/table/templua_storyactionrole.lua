


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/storyactionrole')), '')
local datalist = {}
local textname = 'storyactionrole.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("storyactionrole", "id", param[1])
	 data.joinType = ConvertToNumber("storyactionrole", "joinType", param[2])
	 data.pos = ConvertToNumber("storyactionrole", "pos", param[3])
	 data.roldid = ConvertToNumber("storyactionrole", "roldid", param[4])
	 data.picidx = ConvertToNumber("storyactionrole", "picidx", param[5])
	 data.anitype = ConvertToNumber("storyactionrole", "anitype", param[6])
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
	 local reqBytes = assert(Dll_PB.encode('storyactionrole_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
