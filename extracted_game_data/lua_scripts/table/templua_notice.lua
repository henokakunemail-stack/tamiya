


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/notice')), '')
local datalist = {}
local textname = 'notice.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("notice", "id", param[1])
	 data.chatType = ConvertToNumber("notice", "chatType", param[2])
	 data.sysType = ConvertToNumber("notice", "sysType", param[3])
	 data.templetId = param[4]
	 data.showNum = ConvertToNumber("notice", "showNum", param[5])
	 data.showTime = ConvertToNumber("notice", "showTime", param[6])
	 data.banner = ConvertToNumber("notice", "banner", param[7])
	 data.parm = param[8]
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
	 local reqBytes = assert(Dll_PB.encode('notice_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
