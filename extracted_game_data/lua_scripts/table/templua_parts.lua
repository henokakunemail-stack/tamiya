


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/parts')), '')
local datalist = {}
local textname = 'parts.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("parts", "id", param[1])
	 data.name = param[2]
	 data.desc = param[3]
	 data.type = ConvertToNumber("parts", "type", param[4])
	 data.type1 = ConvertToNumber("parts", "type1", param[5])
	 data.quality = ConvertToNumber("parts", "quality", param[6])
	 data.fabric = ConvertToNumber("parts", "fabric", param[7])
	 data.cweight = ConvertToNumber("parts", "cweight", param[8])
	 data.para = param[9]
	 data.attr = param[10]
	 data.recource = ConvertToNumber("parts", "recource", param[11])
	 data.icon = param[12]
	 data.posrelation = param[13]
	 data.banPos = param[14]
	 data.entries = param[15]
	 data.debris = ConvertToNumber("parts", "debris", param[16])
	 data.upstarcost = param[17]
	 data.color = param[18]
	 data.composeids = param[19]
	 data.upstarattr = param[20]
	 data.fiveAttr = param[21]
	 data.specialAttr = param[22]
	 data.score = ConvertToNumber("parts", "score", param[23])
	 data.sign = ConvertToNumber("parts", "sign", param[24])
	 data.levelUpAttr = param[25]
	 data.star = ConvertToNumber("parts", "star", param[26])
	 data.attrFeature = param[27]
	 data.skillIds = ConvertToNumber("parts", "skillIds", param[28])
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
	 local reqBytes = assert(Dll_PB.encode('parts_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
