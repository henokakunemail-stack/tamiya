


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/car')), '')
local datalist = {}
local textname = 'car.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("car", "id", param[1])
	 data.name = param[2]
	 data.type = param[3]
	 data.chassisId = ConvertToNumber("car", "chassisId", param[4])
	 data.gearsId = ConvertToNumber("car", "gearsId", param[5])
	 data.motorId = ConvertToNumber("car", "motorId", param[6])
	 data.shellId = ConvertToNumber("car", "shellId", param[7])
	 data.npcshow = ConvertToNumber("car", "npcshow", param[8])
	 data.gpId = ConvertToNumber("car", "gpId", param[9])
	 data.fHubId = ConvertToNumber("car", "fHubId", param[10])
	 data.bHubId = ConvertToNumber("car", "bHubId", param[11])
	 data.fTyreId = ConvertToNumber("car", "fTyreId", param[12])
	 data.bTyreId = ConvertToNumber("car", "bTyreId", param[13])
	 data.headId = ConvertToNumber("car", "headId", param[14])
	 data.midId = ConvertToNumber("car", "midId", param[15])
	 data.tailId = ConvertToNumber("car", "tailId", param[16])
	 data.fExtendId = ConvertToNumber("car", "fExtendId", param[17])
	 data.fExtend2Id = ConvertToNumber("car", "fExtend2Id", param[18])
	 data.fExtend3Id = ConvertToNumber("car", "fExtend3Id", param[19])
	 data.fddId = ConvertToNumber("car", "fddId", param[20])
	 data.fWeightId = ConvertToNumber("car", "fWeightId", param[21])
	 data.mExtendId = ConvertToNumber("car", "mExtendId", param[22])
	 data.bExtendId = ConvertToNumber("car", "bExtendId", param[23])
	 data.bExtend2Id = ConvertToNumber("car", "bExtend2Id", param[24])
	 data.bExtend3Id = ConvertToNumber("car", "bExtend3Id", param[25])
	 data.bddId = ConvertToNumber("car", "bddId", param[26])
	 data.bWeightId = ConvertToNumber("car", "bWeightId", param[27])
	 data.gw11Id = ConvertToNumber("car", "gw11Id", param[28])
	 data.gw12Id = ConvertToNumber("car", "gw12Id", param[29])
	 data.gw13Id = ConvertToNumber("car", "gw13Id", param[30])
	 data.gw21Id = ConvertToNumber("car", "gw21Id", param[31])
	 data.gw22Id = ConvertToNumber("car", "gw22Id", param[32])
	 data.gw23Id = ConvertToNumber("car", "gw23Id", param[33])
	 data.gw31Id = ConvertToNumber("car", "gw31Id", param[34])
	 data.gw32Id = ConvertToNumber("car", "gw32Id", param[35])
	 data.gw33Id = ConvertToNumber("car", "gw33Id", param[36])
	 data.shellGwId = ConvertToNumber("car", "shellGwId", param[37])
	 data.fBrakeId = ConvertToNumber("car", "fBrakeId", param[38])
	 data.bBrakeId = ConvertToNumber("car", "bBrakeId", param[39])
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
	 local reqBytes = assert(Dll_PB.encode('car_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
