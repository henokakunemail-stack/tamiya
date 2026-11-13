


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/tagname')), '')
local datalist = {}
local textname = 'tagname.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("tagname", "id", param[1])
	 data.laboratory = ConvertToNumber("tagname", "laboratory", param[2])
	 data.articleId = ConvertToNumber("tagname", "articleId", param[3])
	 data.type = ConvertToNumber("tagname", "type", param[4])
	 data.icon = param[5]
	 data.tag = ConvertToNumber("tagname", "tag", param[6])
	 data.tagname = param[7]
	 data.project = ConvertToNumber("tagname", "project", param[8])
	 data.projectname = param[9]
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
	 local reqBytes = assert(Dll_PB.encode('tagname_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
