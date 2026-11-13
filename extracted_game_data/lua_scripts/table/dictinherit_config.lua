



---@class dictinherit_config




dictinherit_config = {}
---@type table<number,dictinherit_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictinherit')), '')
local bytes = mono.LoadBytes('dictinherit')
local cfg = assert(Dll_PB.decode('dictinherit_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictinherit.txt'
function dictinherit_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 inheritname = columns[2],
		 attrids = columns[3],
		 powlevs = columns[4],
		 needexps = columns[5],
		 attrvals = columns[6],
		 reformvals = columns[7],
		 consumepartid = ConvertToNumber(configName, 'consumepartid', columns[8]),
		 partnum = ConvertToNumber(configName, 'partnum', columns[9]),
		 skillbookid = ConvertToNumber(configName, 'skillbookid', columns[10]),
		 skillbooknum = ConvertToNumber(configName, 'skillbooknum', columns[11]),
		 reformagainid = ConvertToNumber(configName, 'reformagainid', columns[12]),
		 reformagainsum = ConvertToNumber(configName, 'reformagainsum', columns[13]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictinherit_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictinherit_config_cell>
function dictinherit_config.GetConfigData() return configData end
---@return dictinherit_config_cell
function dictinherit_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type InheritAttrData[]
local _NewCfgData={}
---@class InheritAttrData
---@field LevelAttrs InheritAttrLevelData[]
---@field RecastingAttrs PartAttrCfg[]
---@field OpenCostPart RewardData
---@field OpenCostArticle RewardData
---@field RecastingCost RewardData



---@class InheritAttrLevelData
---@field Level
---@field NeedExp
---@field Attrs PartAttrCfg[]

function dictinherit_config.AnalyzeCfg()
	for k, v in pairs(configData) do
		local levels=stringSplitToNumber(v.powlevs,":")
		local needexps=stringSplitToNumber(v.needexps,":")
		local attrids=stringSplitToNumber(v.attrids,":")
		local attrvals=stringSplit(v.attrvals,":")
		local reformvals=stringSplitToNumber(v.reformvals,":")

		configData[k].LevelAttrs={}
		configData[k].RecastingAttrs={}
		for i = 1, #attrids do
			local temp=PartAttrCfg()
			temp.type=attrids[i]
			temp.value=reformvals[i]
			table.insert(configData[k].RecastingAttrs,temp)
		end
		configData[k].OpenCostPart=RewardData()
		configData[k].AttrIds=attrids
		configData[k].OpenCostPart:SetDataIdNum(v.consumepartid,v.partnum)
		configData[k].OpenCostArticle=RewardData()
		configData[k].OpenCostArticle:SetDataIdNum(v.skillbookid,v.skillbooknum)
		configData[k].RecastingCost=RewardData()
		configData[k].RecastingCost:SetDataIdNum(v.reformagainid,v.reformagainsum)
		for i = 1, #levels do
			---@type InheritAttrData
			local temp={}
			temp.Level=levels[i]
			temp.NeedExp=needexps[i]
			temp.Attrs= {}
			for j = 1, #attrids do
				local attrvalues=stringSplitToNumber(attrvals[j],",")
				local attr=PartAttrCfg()
				attr.type=attrids[j]
				attr.value=attrvalues[i]
				table.insert(temp.Attrs,attr)
			end
			table.insert(configData[k].LevelAttrs,temp)
		end
		v.powlevs=nil
		v.needexps=nil
		v.attrids=nil
		v.attrvals=nil
		v.reformvals=nil
		v.consumepartid=nil
		v.partnum=nil
		v.skillbookid=nil
		v.skillbooknum=nil
		v.reformagainid=nil
		v.reformagainsum=nil
	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictinherit_config.AnalyzeCfg()
----%%%-------------%%%----








return dictinherit_config
