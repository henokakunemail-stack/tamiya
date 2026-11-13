


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/partstest')), '')
local datalist = {}
local textname = 'partstest.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("partstest", "id", param[1])
	 data.racetrack = ConvertToNumber("partstest", "racetrack", param[2])
	 data.racetracknum = ConvertToNumber("partstest", "racetracknum", param[3])
	 data.circle = ConvertToNumber("partstest", "circle", param[4])
	 data.time = ConvertToNumber("partstest", "time", param[5])
	 data.attrid = ConvertToNumber("partstest", "attrid", param[6])
	 data.shellId = ConvertToNumber("partstest", "shellId", param[7])
	 data.chassisId = ConvertToNumber("partstest", "chassisId", param[8])
	 data.gearsId = ConvertToNumber("partstest", "gearsId", param[9])
	 data.motorId = ConvertToNumber("partstest", "motorId", param[10])
	 data.fHubId = ConvertToNumber("partstest", "fHubId", param[11])
	 data.bHubId = ConvertToNumber("partstest", "bHubId", param[12])
	 data.fTyreId = ConvertToNumber("partstest", "fTyreId", param[13])
	 data.bTyreId = ConvertToNumber("partstest", "bTyreId", param[14])
	 data.headId = ConvertToNumber("partstest", "headId", param[15])
	 data.midId = ConvertToNumber("partstest", "midId", param[16])
	 data.tailId = ConvertToNumber("partstest", "tailId", param[17])
	 data.fExtendId = ConvertToNumber("partstest", "fExtendId", param[18])
	 data.fExtend2Id = ConvertToNumber("partstest", "fExtend2Id", param[19])
	 data.fExtend3Id = ConvertToNumber("partstest", "fExtend3Id", param[20])
	 data.fddId = ConvertToNumber("partstest", "fddId", param[21])
	 data.mExtendId = ConvertToNumber("partstest", "mExtendId", param[22])
	 data.bExtendId = ConvertToNumber("partstest", "bExtendId", param[23])
	 data.bExtend2Id = ConvertToNumber("partstest", "bExtend2Id", param[24])
	 data.bExtend3Id = ConvertToNumber("partstest", "bExtend3Id", param[25])
	 data.bddId = ConvertToNumber("partstest", "bddId", param[26])
	 data.gw11Id = ConvertToNumber("partstest", "gw11Id", param[27])
	 data.gw12Id = ConvertToNumber("partstest", "gw12Id", param[28])
	 data.gw21Id = ConvertToNumber("partstest", "gw21Id", param[29])
	 data.gw22Id = ConvertToNumber("partstest", "gw22Id", param[30])
	 data.gw31Id = ConvertToNumber("partstest", "gw31Id", param[31])
	 data.gw32Id = ConvertToNumber("partstest", "gw32Id", param[32])
	 data.enhance1 = ConvertToNumber("partstest", "enhance1", param[33])
	 data.enhance2 = ConvertToNumber("partstest", "enhance2", param[34])
	 data.enhance3 = ConvertToNumber("partstest", "enhance3", param[35])
	 data.enhance4 = ConvertToNumber("partstest", "enhance4", param[36])
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
	 local reqBytes = assert(Dll_PB.encode('partstest_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
