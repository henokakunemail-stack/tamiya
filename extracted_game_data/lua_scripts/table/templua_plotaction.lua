


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/plotaction')), '')
local datalist = {}
local textname = 'plotaction.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("plotaction", "id", param[1])
	 data.delay = ConvertToNumber("plotaction", "delay", param[2])
	 data.actiontype = ConvertToNumber("plotaction", "actiontype", param[3])
	 data.playerid = ConvertToNumber("plotaction", "playerid", param[4])
	 data.join = ConvertToNumber("plotaction", "join", param[5])
	 data.picani = ConvertToNumber("plotaction", "picani", param[6])
	 data.iconani = ConvertToNumber("plotaction", "iconani", param[7])
	 data.heropicidx = ConvertToNumber("plotaction", "heropicidx", param[8])
	 data.miniicon = ConvertToNumber("plotaction", "miniicon", param[9])
	 data.pos = ConvertToNumber("plotaction", "pos", param[10])
	 data.moveidx = ConvertToNumber("plotaction", "moveidx", param[11])
	 data.moveani = ConvertToNumber("plotaction", "moveani", param[12])
	 data.gary = ConvertToNumber("plotaction", "gary", param[13])
	 data.front = ConvertToNumber("plotaction", "front", param[14])
	 data.dialogtype = ConvertToNumber("plotaction", "dialogtype", param[15])
	 data.dialogani = ConvertToNumber("plotaction", "dialogani", param[16])
	 data.contenttype = ConvertToNumber("plotaction", "contenttype", param[17])
	 data.content = param[18]
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
	 local reqBytes = assert(Dll_PB.encode('plotaction_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
