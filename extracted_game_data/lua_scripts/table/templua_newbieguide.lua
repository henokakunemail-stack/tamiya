


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/newbieguide')), '')
local datalist = {}
local textname = 'newbieguide.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("newbieguide", "id", param[1])
	 data.group = ConvertToNumber("newbieguide", "group", param[2])
	 data.step = ConvertToNumber("newbieguide", "step", param[3])
	 data.nextStep = ConvertToNumber("newbieguide", "nextStep", param[4])
	 data.triggerType = ConvertToNumber("newbieguide", "triggerType", param[5])
	 data.triggerPara = param[6]
	 data.isContinueBattle = ConvertToNumber("newbieguide", "isContinueBattle", param[7])
	 data.type = ConvertToNumber("newbieguide", "type", param[8])
	 data.interfaceID = param[9]
	 data.isKey = ConvertToNumber("newbieguide", "isKey", param[10])
	 data.complettype = ConvertToNumber("newbieguide", "complettype", param[11])
	 data.UiName = param[12]
	 data.completCon = param[13]
	 data.ScrollViewName = param[14]
	 data.Scrolltype = ConvertToNumber("newbieguide", "Scrolltype", param[15])
	 data.ScrollIndex = ConvertToNumber("newbieguide", "ScrollIndex", param[16])
	 data.OpenPopupName = param[17]
	 data.ArrowTowards = ConvertToNumber("newbieguide", "ArrowTowards", param[18])
	 data.videoName = param[19]
	 data.NPC = ConvertToNumber("newbieguide", "NPC", param[20])
	 data.NPCPosX = ConvertToNumber("newbieguide", "NPCPosX", param[21])
	 data.NPCPosY = ConvertToNumber("newbieguide", "NPCPosY", param[22])
	 data.Desc = param[23]
	 data.guideCV = param[24]
	 data.shrinkTime = ConvertToNumber("newbieguide", "shrinkTime", param[25])
	 data.Iscollider = ConvertToNumber("newbieguide", "Iscollider", param[26])
	 data.dialogMask = ConvertToNumber("newbieguide", "dialogMask", param[27])
	 data.nextStepMask = ConvertToNumber("newbieguide", "nextStepMask", param[28])
	 data.maskAnim = ConvertToNumber("newbieguide", "maskAnim", param[29])
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
	 local reqBytes = assert(Dll_PB.encode('newbieguide_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
