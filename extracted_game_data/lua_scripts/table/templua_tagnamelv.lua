


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/tagnamelv')), '')
local datalist = {}
local textname = 'tagnamelv.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("tagnamelv", "id", param[1])
	 data.tagnameId = ConvertToNumber("tagnamelv", "tagnameId", param[2])
	 data.lvTime = ConvertToNumber("tagnamelv", "lvTime", param[3])
	 data.lv = ConvertToNumber("tagnamelv", "lv", param[4])
	 data.roficiencyName = param[5]
	 data.articleId = param[6]
	 data.strAddExp = ConvertToNumber("tagnamelv", "strAddExp", param[7])
	 data.upstarattrLv = param[8]
	 data.articleIdLv = param[9]
	 data.tagnameLvExp = ConvertToNumber("tagnamelv", "tagnameLvExp", param[10])
	 data.expArticleId = param[11]
	 data.addProbability = ConvertToNumber("tagnamelv", "addProbability", param[12])
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
	 local reqBytes = assert(Dll_PB.encode('tagnamelv_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
