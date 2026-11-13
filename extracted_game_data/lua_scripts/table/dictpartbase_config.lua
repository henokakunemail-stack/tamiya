



---@class dictpartbase_config




dictpartbase_config = {}
---@type table<number,dictpartbase_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictpartbase')), '')
local bytes = mono.LoadBytes('dictpartbase')
local cfg = assert(Dll_PB.decode('dictpartbase_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictpartbase.txt'
function dictpartbase_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 parttype = ConvertToNumber(configName, 'parttype', columns[2]),
		 subtype = ConvertToNumber(configName, 'subtype', columns[3]),
		 maxstar = ConvertToNumber(configName, 'maxstar', columns[4]),
		 fabric = ConvertToNumber(configName, 'fabric', columns[5]),
		 para = columns[6],
		 installid = columns[7],
		 supplyid = columns[8],
		 unlockids = columns[9],
		 expireids = columns[10],
		 debris = columns[11],
		 score = ConvertToNumber(configName, 'score', columns[12]),
		 skillids = columns[13],
		 parm1 = ConvertToNumber(configName, 'parm1', columns[14]),
		 parm2 = ConvertToNumber(configName, 'parm2', columns[15]),
		 parm3 = ConvertToNumber(configName, 'parm3', columns[16]),
		 parm4 = ConvertToNumber(configName, 'parm4', columns[17]),
		 parm5 = ConvertToNumber(configName, 'parm5', columns[18]),
		 attrFeature = columns[19],
		 chassisLimit = columns[20],
		 centerIcon = columns[21],
		 inheritexp = ConvertToNumber(configName, 'inheritexp', columns[22]),
		 inheritnum = ConvertToNumber(configName, 'inheritnum', columns[23]),
		 chassisSwitchFx = columns[24],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictpartbase_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictpartbase_config_cell>
function dictpartbase_config.GetConfigData() return configData end
---@return dictpartbase_config_cell
function dictpartbase_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

local _NewConfigData={}

---@class PartStarCostCfg
PartStarCostCfg = class("PartStarCostCfg")
function PartStarCostCfg:initialize()
	self.counts = {}
	self.articles = {}
end


---@class PartReformCfg
PartReformCfg = class("PartReformCfg")
function PartReformCfg:initialize()
	self.reformid = -1
	self.attrtype = {}
	self.attrmax = {}
end


function dictpartbase_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if v.parttype == PartType.Shell then configData[k].NewShellId = tonumber(v.para) end -- carshell  ID
        v.chassisSwitchFx=string.format("%s.prefab",v.chassisSwitchFx)
		configData[k].PortData = nil
		v = CommonHelper:PartCalculate_AnalysePort(v)

		---@type table<number,PartAttrCfg>
		configData[k].NewAttrFeature = {}
		if v.attrFeature ~= "0" and v.attrFeature ~= "" then
			if CommonHelper:IsNullOrEmpty(v.attrFeature) then
				print(v.C_ID)
			else
				configData[k].NewAttrFeature = stringSplitToNumber(v.attrFeature, ',')
			end

		end
		configData[k].NewSkillIds = nil
		if v.skillids ~= "0" and not CommonHelper:IsNullOrEmpty(v.skillids) then
			configData[k].NewSkillIds = stringSplitToNumber(v.skillids, ':')
		end
		---@type table<number,PartAttrCfg>
		configData[k].NewChassisLimit = {}
		if v.chassisLimit ~= "0" and v.chassisLimit ~= "" then
			configData[k].NewChassisLimit = stringSplitToNumber(v.chassisLimit, ':')
		end

		if _NewConfigData[v.parttype]==nil then
			_NewConfigData[v.parttype]={}
		end
		if _NewConfigData[v.parttype][v.subtype]==nil then
			_NewConfigData[v.parttype][v.subtype]={}
		end
		table.insert(_NewConfigData[v.parttype][v.subtype],v)
	end
end

---@return table<dictpartbase_config_cell>
function dictpartbase_config.GetDataByType(parttype,subtype)
	return _NewConfigData[parttype][subtype]
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictpartbase_config.AnalyseConfig()
----%%%-------------%%%----








return dictpartbase_config
