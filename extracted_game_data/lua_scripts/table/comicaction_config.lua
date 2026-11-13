



---@class comicaction_config




comicaction_config = {}
---@type table<number,comicaction_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/comicaction')), '')
local bytes = mono.LoadBytes('comicaction')
local cfg = assert(Dll_PB.decode('comicaction_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'comicaction.txt'
function comicaction_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 image = columns[2],
		 tweentype = ConvertToNumber(configName, 'tweentype', columns[3]),
		 size = columns[4],
		 pos = columns[5],
		 duration = ConvertToNumber(configName, 'duration', columns[6]),
		 delay = ConvertToNumber(configName, 'delay', columns[7]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
comicaction_config.Load()
----------以pb方式加载配置表---end




---@return table<number,comicaction_config_cell>
function comicaction_config.GetConfigData() return configData end
---@return comicaction_config_cell
function comicaction_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function comicaction_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if configData[k].image~="-1" then
			configData[k].image=configData[k].image..".png"
		end
		if configData.size~="-1" then
			if not CommonHelper:IsNullOrEmpty(v.size) then
				local size=stringSplitToNumber(configData[k].size,',')
				local temp=LuaVector3(size[1],size[2])
				configData[k].size=temp
			end
		end
		if configData.pos~="-1" then
			if not CommonHelper:IsNullOrEmpty(v.pos) then
				local pos=stringSplitToNumber(configData[k].pos,',')
				local temp=LuaVector3(pos[1],pos[2])
				configData[k].pos=temp
			end
		end
	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
comicaction_config.AnalyseConfig()
----%%%-------------%%%----








return comicaction_config
