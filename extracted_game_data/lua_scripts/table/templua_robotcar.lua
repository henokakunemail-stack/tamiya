


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/robotcar')), '')
local datalist = {}
local textname = 'robotcar.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("robotcar", "id", param[1])
	 data.shellId = ConvertToNumber("robotcar", "shellId", param[2])
	 data.robotShell = ConvertToNumber("robotcar", "robotShell", param[3])
	 data.chassisId = ConvertToNumber("robotcar", "chassisId", param[4])
	 data.gearsId = ConvertToNumber("robotcar", "gearsId", param[5])
	 data.motorId = ConvertToNumber("robotcar", "motorId", param[6])
	 data.fHubId = ConvertToNumber("robotcar", "fHubId", param[7])
	 data.bHubId = ConvertToNumber("robotcar", "bHubId", param[8])
	 data.fTyreId = ConvertToNumber("robotcar", "fTyreId", param[9])
	 data.bTyreId = ConvertToNumber("robotcar", "bTyreId", param[10])
	 data.headId = ConvertToNumber("robotcar", "headId", param[11])
	 data.midId = ConvertToNumber("robotcar", "midId", param[12])
	 data.tailId = ConvertToNumber("robotcar", "tailId", param[13])
	 data.fExtendId = ConvertToNumber("robotcar", "fExtendId", param[14])
	 data.fExtend2Id = ConvertToNumber("robotcar", "fExtend2Id", param[15])
	 data.fExtend3Id = ConvertToNumber("robotcar", "fExtend3Id", param[16])
	 data.fddId = ConvertToNumber("robotcar", "fddId", param[17])
	 data.mExtendId = ConvertToNumber("robotcar", "mExtendId", param[18])
	 data.bExtendId = ConvertToNumber("robotcar", "bExtendId", param[19])
	 data.bExtend2Id = ConvertToNumber("robotcar", "bExtend2Id", param[20])
	 data.bExtend3Id = ConvertToNumber("robotcar", "bExtend3Id", param[21])
	 data.bddId = ConvertToNumber("robotcar", "bddId", param[22])
	 data.gw11Id = ConvertToNumber("robotcar", "gw11Id", param[23])
	 data.gw12Id = ConvertToNumber("robotcar", "gw12Id", param[24])
	 data.gw21Id = ConvertToNumber("robotcar", "gw21Id", param[25])
	 data.gw22Id = ConvertToNumber("robotcar", "gw22Id", param[26])
	 data.gw31Id = ConvertToNumber("robotcar", "gw31Id", param[27])
	 data.gw32Id = ConvertToNumber("robotcar", "gw32Id", param[28])
	 data.enhance1 = ConvertToNumber("robotcar", "enhance1", param[29])
	 data.enhance2 = ConvertToNumber("robotcar", "enhance2", param[30])
	 data.enhance3 = ConvertToNumber("robotcar", "enhance3", param[31])
	 data.enhance4 = ConvertToNumber("robotcar", "enhance4", param[32])
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
	 local reqBytes = assert(Dll_PB.encode('robotcar_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
