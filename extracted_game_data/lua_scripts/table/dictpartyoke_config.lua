



---@class dictpartyoke_config




dictpartyoke_config = {}
---@type table<number,dictpartyoke_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictpartyoke')), '')
local bytes = mono.LoadBytes('dictpartyoke')
local cfg = assert(Dll_PB.decode('dictpartyoke_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictpartyoke.txt'
function dictpartyoke_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 linkpartids = columns[2],
		 attrids = columns[3],
		 attrvals = columns[4],
		 yokedesc = columns[5],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictpartyoke_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictpartyoke_config_cell>
function dictpartyoke_config.GetConfigData() return configData end
---@return dictpartyoke_config_cell
function dictpartyoke_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@class PartYokeCfg
PartYokeCfg=class("PartYokeCfg")
function PartYokeCfg:initialize()
	self.PartIds={}
	---@type PartAttrCfg[]
	self.Attrs={}
	---@type dictpartyoke_config_cell
	self.Cfg=nil
	self.Desc=nil
end
function PartYokeCfg:AddPart(id)
	table.insert(self.PartIds,id)
end

function PartYokeCfg:SetCfgPart(cfg)
	self.Cfg=cfg
end
function PartYokeCfg:SetDesc(desc)
	self.Desc=desc
end

function PartYokeCfg:AddAttr(type,value)
	local attr=PartAttrCfg()
	attr.type=type
	attr.value=value
	table.insert(self.Attrs,attr)
end
---@type PartYokeCfg[]
local _NewLinkPart={}
function dictpartyoke_config.AnalyseConfig()
	for k, v in pairs(configData) do
		local linkpartids= stringSplit(v.linkpartids,',')
		local linkattrids= stringSplit(v.attrids,',')
		local linkattrvals= stringSplit(v.attrvals,',')
		local yokedescs= stringSplit(v.yokedesc,',')
		---@type PartYokeCfg[]
		configData[k].NewLinkPartAttrs={}
		if _NewLinkPart[v.C_ID]==nil then
			_NewLinkPart[v.C_ID]={}
		end
		for i = 1, #linkpartids do
			local  parts=stringSplitToNumber(linkpartids[i],':')
			local  attrids=stringSplitToNumber(linkattrids[i],':')
			local  attrvals=stringSplitToNumber(linkattrvals[i],':')
			local temp=PartYokeCfg()
			temp:AddPart(v.C_ID)
			temp:SetDesc(yokedescs[i])
			temp:SetCfgPart(v)
			for j = 1, #parts do
				if _NewLinkPart[parts[j]]==nil then
					_NewLinkPart[parts[j]]={}
				end
				temp:AddPart(parts[j])
			end
			for j = 1, #attrids do
				temp:AddAttr(attrids[j],attrvals[j])
			end
			table.insert(configData[k].NewLinkPartAttrs,temp)
			table.insert(_NewLinkPart[v.C_ID],temp)
			for j = 1, #parts do
				table.insert(_NewLinkPart[parts[j]],temp)
			end
		end
		v.linkpartids=nil
		v.attrids=nil
		v.attrvals=nil
	end
end
---@return PartYokeCfg[]
function dictpartyoke_config.GetPartLinksCfgDataById(partId)
	local result = { }
	if _NewLinkPart[partId] then
		result=_NewLinkPart[partId]
	end
	return result
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictpartyoke_config.AnalyseConfig()
----%%%-------------%%%----








return dictpartyoke_config
