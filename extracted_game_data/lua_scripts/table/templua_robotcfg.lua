


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/robotcfg')), '')
local datalist = {}
local textname = 'robotcfg.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("robotcfg", "id", param[1])
	 data.partsid = ConvertToNumber("robotcfg", "partsid", param[2])
	 data.partslevel = ConvertToNumber("robotcfg", "partslevel", param[3])
	 data.changeOne = ConvertToNumber("robotcfg", "changeOne", param[4])
	 data.changeOneLevel = ConvertToNumber("robotcfg", "changeOneLevel", param[5])
	 data.changeTwo = ConvertToNumber("robotcfg", "changeTwo", param[6])
	 data.changeTwoLevel = ConvertToNumber("robotcfg", "changeTwoLevel", param[7])
	 data.changeThree = ConvertToNumber("robotcfg", "changeThree", param[8])
	 data.changeThreeLevel = ConvertToNumber("robotcfg", "changeThreeLevel", param[9])
	 data.changeFour = ConvertToNumber("robotcfg", "changeFour", param[10])
	 data.changeFourLevel = ConvertToNumber("robotcfg", "changeFourLevel", param[11])
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
	 local reqBytes = assert(Dll_PB.encode('robotcfg_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
