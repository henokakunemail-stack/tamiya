


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/carshell')), '')
local datalist = {}
local textname = 'carshell.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("carshell", "id", param[1])
	 data.carNameid = param[2]
	 data.showcfg = ConvertToNumber("carshell", "showcfg", param[3])
	 data.apshowcfg = ConvertToNumber("carshell", "apshowcfg", param[4])
	 data.skill = param[5]
	 data.attr = param[6]
	 data.holder = ConvertToNumber("carshell", "holder", param[7])
	 data.defaultSticker = ConvertToNumber("carshell", "defaultSticker", param[8])
	 data.isColour = ConvertToNumber("carshell", "isColour", param[9])
	 data.stickerType = param[10]
	 data.shellhole = stringSplitToNumber(param[11], '|')
	 data.aniEnter = param[12]
	 data.aniEnterTime = ConvertToNumber("carshell", "aniEnterTime", param[13])
	 data.audioGroup = stringSplit(param[14], '|')
	 data.carNameIcon = param[15]
	 data.carNameEn = param[16]
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
	 local reqBytes = assert(Dll_PB.encode('carshell_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
