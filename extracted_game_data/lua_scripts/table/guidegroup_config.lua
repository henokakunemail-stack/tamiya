



---@class guidegroup_config




guidegroup_config = {}
---@type table<number,guidegroup_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/guidegroup')), '')
local bytes = mono.LoadBytes('guidegroup')
local cfg = assert(Dll_PB.decode('guidegroup_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'guidegroup.txt'
function guidegroup_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 steps = columns[2],
		 NextGroup = ConvertToNumber(configName, 'NextGroup', columns[3]),
		 EndGroup = ConvertToNumber(configName, 'EndGroup', columns[4]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
guidegroup_config.Load()
----------以pb方式加载配置表---end




---@return table<number,guidegroup_config_cell>
function guidegroup_config.GetConfigData() return configData end
---@return guidegroup_config_cell
function guidegroup_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local _GuideGroupEndGroup={}
function guidegroup_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if _GuideGroupEndGroup[v.EndGroup]==nil then
			_GuideGroupEndGroup[v.EndGroup]={}
		end
		table.insert(_GuideGroupEndGroup[v.EndGroup],v.C_ID)
	end
end
function guidegroup_config.CheckEndGroupId(endId)
	return _GuideGroupEndGroup[endId]~=nil
end
function guidegroup_config.CheckPlayerGroupEnd(groupendId,groupId)
	if _GuideGroupEndGroup[groupendId] then
		for i = 1, #_GuideGroupEndGroup[groupendId] do
			if _GuideGroupEndGroup[groupendId][i]==groupId then
				return true
			end
		end
	end
	return false
end
function guidegroup_config.CheckPlayerGroupIsGroup(groupId1,groupId2)
	local flag1=0
	local flag2=0
	for k, v in pairs(_GuideGroupEndGroup) do
		for i = 1, #v do
			if v[i]==groupId1 then
				flag1=k
			end
			if v[i]==groupId2 then
				flag2=k
			end
		end
	end
	return flag1==flag2
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
guidegroup_config.AnalyseConfig()
----%%%-------------%%%----








return guidegroup_config
