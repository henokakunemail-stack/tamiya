



---@class dictpartage_config




dictpartage_config = {}
---@type table<number,dictpartage_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictpartage')), '')
local bytes = mono.LoadBytes('dictpartage')
local cfg = assert(Dll_PB.decode('dictpartage_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictpartage.txt'
function dictpartage_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 basepartid = ConvertToNumber(configName, 'basepartid', columns[2]),
		 partage = ConvertToNumber(configName, 'partage', columns[3]),
		 neednum = ConvertToNumber(configName, 'neednum', columns[4]),
		 attrids = columns[5],
		 attrvals = columns[6],
		 basevals = columns[7],
		 breakattrids = columns[8],
		 breakattrvals = columns[9],
		 breakvals = columns[10],
		 breakgold = ConvertToNumber(configName, 'breakgold', columns[11]),
		 needids = columns[12],
		 needstone = ConvertToNumber(configName, 'needstone', columns[13]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictpartage_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictpartage_config_cell>
function dictpartage_config.GetConfigData() return configData end
---@return dictpartage_config_cell
function dictpartage_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local _NewCfgData={}
---@type dictpartage_config_cell
function dictpartage_config.GetAgeDataById(baseId, age)
	if _NewCfgData[baseId] and _NewCfgData[baseId][age] then
		return _NewCfgData[baseId][age]
	end
	return nil
end

function dictpartage_config.GetMaxGeneration(baseId)
	if _NewCfgData[baseId]  then
		return #_NewCfgData[baseId]
	end
	return 1
end
function dictpartage_config.GetPartGenerationList(baseId)
	if _NewCfgData[baseId]  then
		return _NewCfgData[baseId]
	end
	return {}
end





---@class PartBreakCfg
PartBreakCfg=class("PartBreakCfg")
function PartBreakCfg:initialize()
	self.attrtypes={}
	self.breakvalues={}
end

---@class PartBreakCostCfg
PartBreakCostCfg=class("PartBreakCostCfg")
function PartBreakCostCfg:initialize()
	self.id=nil
	self.value=nil
end

function dictpartage_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if _NewCfgData[v.basepartid] == nil then
			_NewCfgData[v.basepartid] = {}
		end

		---@type table<number, PartAttrCfg>
		v.NewAttr = {}
		---@type table<number,PartAttrCfg>
		v.NewLevelUpAttr = {}
		local strs = stringSplitToNumber(v.attrids, ':')
		local values = stringSplitToNumber(v.attrvals, ':')
		local basevals = stringSplitToNumber(v.basevals, ':')
		for i = 1, #strs do
			local data = PartAttrCfg()
			data.type = strs[i]
			data.value = values[i]
			v.NewAttr[data.type]=data


			local data = PartAttrCfg()
			data.type = strs[i]
			data.value = basevals[i]
			table.insert(v.NewLevelUpAttr, data)
		end
		v._NewBreakAttr = PartBreakCfg()
		if v.breakattrids ~= "0" and v.breakattrids ~= "" then
			local ids = stringSplitToNumber(v.breakattrids, ':')
			local values = stringSplitToNumber(v.breakattrvals, ':')
			for i, m in ipairs(values) do
				values[i] =  values[i] * v.breakvals
			end
			v._NewBreakAttr.attrtypes = ids
			v._NewBreakAttr.breakvalues = values
		end
		v._NewBreakCost = PartBreakCostCfg()
		if v.needids ~= "0" and v.needids ~= "" then
			local id = tonumber(v.needids)
			local value = tonumber(v.needstone)
			v._NewBreakCost.id = id
			v._NewBreakCost.value = value
		end

		v.attrids=nil
		v.attrvals=nil
		v.basevals=nil
		v.breakattrids=nil
		v.breakattrvals=nil
		_NewCfgData[v.basepartid][v.partage] = v
	end

end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictpartage_config.AnalyseConfig()
----%%%-------------%%%----








return dictpartage_config
