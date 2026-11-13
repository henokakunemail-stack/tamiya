


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/cartestdata')), '')
local datalist = {}
local textname = 'cartestdata.txt'


local function analyse(param)
	 local data = {}
	 data.ID = ConvertToNumber("cartestdata", "ID", param[1])
	 data.maxRPM = ConvertToNumber("cartestdata", "maxRPM", param[2])
	 data.maxTorque = ConvertToNumber("cartestdata", "maxTorque", param[3])
	 data.stability = ConvertToNumber("cartestdata", "stability", param[4])
	 data.durability = ConvertToNumber("cartestdata", "durability", param[5])
	 data.mass = ConvertToNumber("cartestdata", "mass", param[6])
	 data.airDownPressure = ConvertToNumber("cartestdata", "airDownPressure", param[7])
	 data.airDragFactor = ConvertToNumber("cartestdata", "airDragFactor", param[8])
	 data.energySaving = ConvertToNumber("cartestdata", "energySaving", param[9])
	 data.transmissionEfficiency = ConvertToNumber("cartestdata", "transmissionEfficiency", param[10])
	 data.tireElasticity = ConvertToNumber("cartestdata", "tireElasticity", param[11])
	 data.damping = ConvertToNumber("cartestdata", "damping", param[12])
	 data.staticWheelFrictionAttr = ConvertToNumber("cartestdata", "staticWheelFrictionAttr", param[13])
	 data.rollingWheelFrictionAttr = ConvertToNumber("cartestdata", "rollingWheelFrictionAttr", param[14])
	 data.lossRPM = ConvertToNumber("cartestdata", "lossRPM", param[15])
	 data.lossTorque = ConvertToNumber("cartestdata", "lossTorque", param[16])
	 data.guideFrictionAttr = ConvertToNumber("cartestdata", "guideFrictionAttr", param[17])
	 data.guideRestitution = ConvertToNumber("cartestdata", "guideRestitution", param[18])
	 data.brakingForceAttr = ConvertToNumber("cartestdata", "brakingForceAttr", param[19])
	 data.gearRadio = ConvertToNumber("cartestdata", "gearRadio", param[20])
	 data.wheelRadius = ConvertToNumber("cartestdata", "wheelRadius", param[21])
	 data.tireRestitution = ConvertToNumber("cartestdata", "tireRestitution", param[22])
	 data.gravity = ConvertToNumber("cartestdata", "gravity", param[23])
	 data.carLength = ConvertToNumber("cartestdata", "carLength", param[24])
	 data.carWidth = ConvertToNumber("cartestdata", "carWidth", param[25])
	 data.carHeight = ConvertToNumber("cartestdata", "carHeight", param[26])
	 data.maxU = ConvertToNumber("cartestdata", "maxU", param[27])
	 data.totalBattery = ConvertToNumber("cartestdata", "totalBattery", param[28])
	 data.guideDiameter = ConvertToNumber("cartestdata", "guideDiameter", param[29])
	 data.segFrictionAttr = ConvertToNumber("cartestdata", "segFrictionAttr", param[30])
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
	 local reqBytes = assert(Dll_PB.encode('cartestdata_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
