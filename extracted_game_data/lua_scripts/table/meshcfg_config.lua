



---@class meshcfg_config




meshcfg_config = {}
---@type table<number,meshcfg_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/meshcfg')), '')
local bytes = mono.LoadBytes('meshcfg')
local cfg = assert(Dll_PB.decode('meshcfg_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'meshcfg.txt'
function meshcfg_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 mesh = columns[2],
		 mesh1 = columns[3],
		 initialmodel = columns[4],
		 thickness = ConvertToNumber(configName, 'thickness', columns[5]),
		 showmodel = columns[6],
		 flag = ConvertToNumber(configName, 'flag', columns[7]),
		 meshcolor = columns[8],
		 meshmatch = columns[9],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
meshcfg_config.Load()
----------以pb方式加载配置表---end




---@return table<number,meshcfg_config_cell>
function meshcfg_config.GetConfigData() return configData end
---@return meshcfg_config_cell
function meshcfg_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

---@class Meshcfg_Link
Meshcfg_Link = class("Meshcfg_Link")
function Meshcfg_Link:initialize() end
function Meshcfg_Link:SetData(type, id, offset)
	self.type = type
	self.id = id
	self.offset = offset
end

function meshcfg_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if v.showmodel == "" or v.showmodel == "-1" then v.showmodel = v.mesh end

		configData[k].NewMeshmatch = nil
		if v.meshmatch ~= "" then
			local temp = {}
			local str1 = stringSplit(v.meshmatch, ';')
			for i = 1, #str1 do
				local str2 = stringSplit(str1[i], ',')
				temp[i] = str2
			end
			configData[k].NewMeshmatch = temp
		end
		if v.mesh1 ~= "" and v.mesh1 ~= nil and v.mesh1~="0"and v.mesh1~="-1" then
			local str1 = stringSplit(v.mesh1, ':')
			configData[k].NewMeshForm = str1
		end

		configData[k].NewInitModel = {}
		if v.initialmodel ~= "" and v.initialmodel ~= "-1" then
			configData[k].NewInitModel = stringSplitToNumber(v.initialmodel, ',')
		end

	end
end
function meshcfg_config.GetMeshListByFlag(flag)
	local result={}
	for k, v in pairs(configData) do
		if v.flag==flag then
			table.insert(result,v)
		end
	end
	return result
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
meshcfg_config.AnalyseConfig()
----%%%-------------%%%----








return meshcfg_config
