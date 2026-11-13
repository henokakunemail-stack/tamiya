


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/npcshow')), '')
local datalist = {}
local textname = 'npcshow.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("npcshow", "id", param[1])
	 data.sticker = ConvertToNumber("npcshow", "sticker", param[2])
	 data.shellhole = ConvertToNumber("npcshow", "shellhole", param[3])
	 data.gauce = param[4]
	 data.paint = ConvertToNumber("npcshow", "paint", param[5])
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
	 local reqBytes = assert(Dll_PB.encode('npcshow_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
