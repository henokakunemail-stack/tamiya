



---@class dictpartsdevelop_config




dictpartsdevelop_config = {}
---@type table<number,dictpartsdevelop_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictpartsdevelop')), '')
local bytes = mono.LoadBytes('dictpartsdevelop')
local cfg = assert(Dll_PB.decode('dictpartsdevelop_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictpartsdevelop.txt'
function dictpartsdevelop_config.Load()
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
		 entryid = ConvertToNumber(configName, 'entryid', columns[3]),
		 name = columns[4],
		 desc = columns[5],
		 rate = columns[6],
		 attrids = columns[7],
		 developattr = columns[8],
		 attrvals = columns[9],
		 excellent = columns[10],
		 perfect = columns[11],
		 costids = ConvertToNumber(configName, 'costids', columns[12]),
		 perfectcost = ConvertToNumber(configName, 'perfectcost', columns[13]),
		 reformagain = ConvertToNumber(configName, 'reformagain', columns[14]),
		 reformlevs = columns[15],
		 upconsumes = columns[16],
		 increase = columns[17],
		 increaseIcon = columns[18],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictpartsdevelop_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictpartsdevelop_config_cell>
function dictpartsdevelop_config.GetConfigData() return configData end
---@return dictpartsdevelop_config_cell
function dictpartsdevelop_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@class PartReformAttrCfg
PartReformAttrCfg = class("PartReformAttrCfg")
function PartReformAttrCfg:initialize()
	self.type = -1 -- 属性类型
	self.increase = -1 --有利不利  1有利，-1不利
	self.feature = -1 --属性特性   1有利，-1不利
	self.featurelv = -1  -- 属性特性等级(箭头个数)

	self.tag = {}  -- 公式类型
	self.formulaParam2 = {}--系数
end
---@class PartStrongCfg
PartStrongCfg = class("PartStrongCfg")
function PartStrongCfg:initialize()
	self.Lv = -1
	self.PartGroup = -1
end

local __NewConfigData = {}
local __NewConfigEntityData = {}
function dictpartsdevelop_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if __NewConfigData[v.basepartid]==nil then  __NewConfigData[v.basepartid]={} end
		__NewConfigData[v.basepartid][v.entryid]=v

		-----@type table<number, PartReformAttrCfg>
		configData[k].NewAttr = {}
		configData[k].NewStrong = {}
		local strattr = stringSplitToNumber(v.attrids, ':')
		local strincrease = stringSplitToNumber(v.increase, ',')
		local strincreaseIcon = stringSplit(v.increaseIcon, ';')
		for i = 1, #strattr do
			local data = PartReformAttrCfg()
			data.type = strattr[i]
			data.increase = strincrease[i]
			if strincreaseIcon[i] then
				local temp = stringSplitToNumber(strincreaseIcon[i], ':')
				data.feature = temp[1]
				data.featurelv = temp[2]
			else
				data.feature = 0
				data.featurelv = 0
			end
			table.insert(configData[k].NewAttr, data)
			local templv=stringSplitToNumber(v.reformlevs,':')
			local tempPart=stringSplitToNumber(v.upconsumes,':')
			for i = 1, #templv do
				local data =PartStrongCfg()
				data.Lv=templv[i]
				data.PartGroup=tempPart[i]
				configData[k].NewStrong[data.Lv]=data
			end
		end
		v.reformlevs=nil
		v.upconsumes=nil
		v.increaseIcon=nil
		v.increase=nil
		v.attrids=nil
		__NewConfigEntityData[v.entryid]=v

	end

end
function dictpartsdevelop_config.AnalyseQuality(good, excellent, perfect)

	local tag = {}
	local param = {}

	good = stringSplit(good, ';')
	for i = 1, #good do
		local temp = stringSplit(good[i], ':')
		local tempstr = stringSplitToNumber(temp[1], ',')
		table.insert(tag, tempstr[1])
		table.insert(param, tonumber(temp[2]))
	end

	excellent = stringSplit(excellent, ';')
	for i = 1, #excellent do
		local temp = stringSplit(excellent[i], ':')
		local tempstr = stringSplitToNumber(temp[1], ',')
		table.insert(tag, tempstr[1])
		table.insert(param, tonumber(temp[2]))
	end

	perfect = stringSplit(perfect, ';')
	for i = 1, #perfect do
		local temp = stringSplit(perfect[i], ':')
		local tempstr = stringSplitToNumber(temp[1], ',')
		table.insert(tag, tempstr[1])
		table.insert(param, tonumber(temp[2]))
	end

	return tag, param
end

function dictpartsdevelop_config.GetDevelopListByPartId(partId)
	local result =nil
	if __NewConfigData[partId] then
		result=__NewConfigData[partId]
	end
	return result
end
function dictpartsdevelop_config.GetDevelopByEntryId(partId)
	local result =nil
	if __NewConfigEntityData[partId] then
		result=__NewConfigEntityData[partId]
	end
	return result
end
---@return PartStrongCfg
function dictpartsdevelop_config.GetDevelopLvPartByEntryId(entryid,lv)
	local result =nil
	if __NewConfigEntityData[entryid] then
		result=__NewConfigEntityData[entryid].NewStrong[lv]
	end
	return result
end
---@return PartStrongCfg
function dictpartsdevelop_config.GetDevelopPartByEntryId(entryid)
	return __NewConfigEntityData[entryid]
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictpartsdevelop_config.AnalyseConfig()
----%%%-------------%%%----








return dictpartsdevelop_config
