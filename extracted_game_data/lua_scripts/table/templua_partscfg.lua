


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/partscfg')), '')
local datalist = {}
local textname = 'partscfg.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("partscfg", "id", param[1])
	 data.partsid = ConvertToNumber("partscfg", "partsid", param[2])
	 data.partslevel = ConvertToNumber("partscfg", "partslevel", param[3])
	 data.changeOne = ConvertToNumber("partscfg", "changeOne", param[4])
	 data.changeOneLevel = ConvertToNumber("partscfg", "changeOneLevel", param[5])
	 data.changeTwo = ConvertToNumber("partscfg", "changeTwo", param[6])
	 data.changeTwoLevel = ConvertToNumber("partscfg", "changeTwoLevel", param[7])
	 data.changeThree = ConvertToNumber("partscfg", "changeThree", param[8])
	 data.changeThreeLevel = ConvertToNumber("partscfg", "changeThreeLevel", param[9])
	 data.changeFour = ConvertToNumber("partscfg", "changeFour", param[10])
	 data.changeFourLevel = ConvertToNumber("partscfg", "changeFourLevel", param[11])
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
	 local reqBytes = assert(Dll_PB.encode('partscfg_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
