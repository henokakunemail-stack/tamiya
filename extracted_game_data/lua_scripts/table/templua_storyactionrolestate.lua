


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/storyactionrolestate')), '')
local datalist = {}
local textname = 'storyactionrolestate.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("storyactionrolestate", "id", param[1])
	 data.rolepos = ConvertToNumber("storyactionrolestate", "rolepos", param[2])
	 data.changpos = ConvertToNumber("storyactionrolestate", "changpos", param[3])
	 data.changposani = ConvertToNumber("storyactionrolestate", "changposani", param[4])
	 data.picidx = ConvertToNumber("storyactionrolestate", "picidx", param[5])
	 data.shake = ConvertToNumber("storyactionrolestate", "shake", param[6])
	 data.shine = ConvertToNumber("storyactionrolestate", "shine", param[7])
	 data.gray = ConvertToNumber("storyactionrolestate", "gray", param[8])
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
	 local reqBytes = assert(Dll_PB.encode('storyactionrolestate_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
