


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/storyactiondialog')), '')
local datalist = {}
local textname = 'storyactiondialog.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("storyactiondialog", "id", param[1])
	 data.roleName = param[2]
	 data.roleType = ConvertToNumber("storyactiondialog", "roleType", param[3])
	 data.content = param[4]
	 data.contentType = ConvertToNumber("storyactiondialog", "contentType", param[5])
	 data.contentAni = ConvertToNumber("storyactiondialog", "contentAni", param[6])
	 data.dialogBoxType = ConvertToNumber("storyactiondialog", "dialogBoxType", param[7])
	 data.dialogBoxAni = ConvertToNumber("storyactiondialog", "dialogBoxAni", param[8])
	 data.heroId = ConvertToNumber("storyactiondialog", "heroId", param[9])
	 data.preposition = ConvertToNumber("storyactiondialog", "preposition", param[10])
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
	 local reqBytes = assert(Dll_PB.encode('storyactiondialog_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
