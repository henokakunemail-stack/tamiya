


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/npc')), '')
local datalist = {}
local textname = 'npc.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("npc", "id", param[1])
	 data.scorce = ConvertToNumber("npc", "scorce", param[2])
	 data.level = ConvertToNumber("npc", "level", param[3])
	 data.name = param[4]
	 data.suits = ConvertToNumber("npc", "suits", param[5])
	 data.hero = ConvertToNumber("npc", "hero", param[6])
	 data.skill = param[7]
	 data.attr1 = ConvertToNumber("npc", "attr1", param[8])
	 data.attr2 = ConvertToNumber("npc", "attr2", param[9])
	 data.attr3 = ConvertToNumber("npc", "attr3", param[10])
	 data.attr4 = ConvertToNumber("npc", "attr4", param[11])
	 data.attr5 = ConvertToNumber("npc", "attr5", param[12])
	 data.attr6 = ConvertToNumber("npc", "attr6", param[13])
	 data.attr7 = ConvertToNumber("npc", "attr7", param[14])
	 data.attr8 = ConvertToNumber("npc", "attr8", param[15])
	 data.attr9 = ConvertToNumber("npc", "attr9", param[16])
	 data.attr10 = ConvertToNumber("npc", "attr10", param[17])
	 data.attr11 = ConvertToNumber("npc", "attr11", param[18])
	 data.attr12 = ConvertToNumber("npc", "attr12", param[19])
	 data.attr13 = ConvertToNumber("npc", "attr13", param[20])
	 data.attr14 = ConvertToNumber("npc", "attr14", param[21])
	 data.attr15 = ConvertToNumber("npc", "attr15", param[22])
	 data.attr16 = ConvertToNumber("npc", "attr16", param[23])
	 data.attr17 = ConvertToNumber("npc", "attr17", param[24])
	 data.attr18 = ConvertToNumber("npc", "attr18", param[25])
	 data.attr19 = ConvertToNumber("npc", "attr19", param[26])
	 data.attr20 = ConvertToNumber("npc", "attr20", param[27])
	 data.attr21 = ConvertToNumber("npc", "attr21", param[28])
	 data.attr22 = ConvertToNumber("npc", "attr22", param[29])
	 data.attr23 = ConvertToNumber("npc", "attr23", param[30])
	 data.attr26 = ConvertToNumber("npc", "attr26", param[31])
	 data.attr27 = ConvertToNumber("npc", "attr27", param[32])
	 data.attr28 = ConvertToNumber("npc", "attr28", param[33])
	 data.attr29 = ConvertToNumber("npc", "attr29", param[34])
	 data.attr30 = ConvertToNumber("npc", "attr30", param[35])
	 data.attr31 = ConvertToNumber("npc", "attr31", param[36])
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
	 local reqBytes = assert(Dll_PB.encode('npc_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
