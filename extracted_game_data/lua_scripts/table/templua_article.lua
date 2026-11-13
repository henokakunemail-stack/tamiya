


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/article')), '')
local datalist = {}
local textname = 'article.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("article", "id", param[1])
	 data.name = param[2]
	 data.description = param[3]
	 data.icon = param[4]
	 data.quality = ConvertToNumber("article", "quality", param[5])
	 data.type = ConvertToNumber("article", "type", param[6])
	 data.school = ConvertToNumber("article", "school", param[7])
	 data.grade = ConvertToNumber("article", "grade", param[8])
	 data.sequence = ConvertToNumber("article", "sequence", param[9])
	 data.floor = ConvertToNumber("article", "floor", param[10])
	 data.useType = ConvertToNumber("article", "useType", param[11])
	 data.stack = ConvertToNumber("article", "stack", param[12])
	 data.effectType = ConvertToNumber("article", "effectType", param[13])
	 data.effectObj = ConvertToNumber("article", "effectObj", param[14])
	 data.effectPara = param[15]
	 data.existType = ConvertToNumber("article", "existType", param[16])
	 data.existTime = param[17]
	 data.canSell = ConvertToNumber("article", "canSell", param[18])
	 data.sellItem = param[19]
	 data.autoUse = ConvertToNumber("article", "autoUse", param[20])
	 data.articletype = ConvertToNumber("article", "articletype", param[21])
	 data.accessWay = param[22]
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
	 local reqBytes = assert(Dll_PB.encode('article_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
