


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/mail')), '')
local datalist = {}
local textname = 'mail.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("mail", "id", param[1])
	 data.icon = param[2]
	 data.type = ConvertToNumber("mail", "type", param[3])
	 data.title = param[4]
	 data.content = param[5]
	 data.sender = param[6]
	 data.annex = param[7]
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
	 local reqBytes = assert(Dll_PB.encode('mail_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
