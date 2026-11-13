



---@class scenechange_config




scenechange_config = {}
---@type table<number,scenechange_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/scenechange')), '')
local bytes = mono.LoadBytes('scenechange')
local cfg = assert(Dll_PB.decode('scenechange_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'scenechange.txt'
function scenechange_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 scenename = columns[2],
		 sceneroot = columns[3],
		 cameraroot = columns[4],
		 fitenable = ConvertToNumber(configName, 'fitenable', columns[5]),
		 cameraparammax = columns[6],
		 cameraparammin = columns[7],
		 cameraparam = columns[8],
		 fog = ConvertToNumber(configName, 'fog', columns[9]),
		 skybox = columns[10],
		 environmentgradient = columns[11],
		 environmenthdrcolor = columns[12],
		 cubemap = columns[13],
		 loginLoad = ConvertToNumber(configName, 'loginLoad', columns[14]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
scenechange_config.Load()
----------以pb方式加载配置表---end




---@return table<number,scenechange_config_cell>
function scenechange_config.GetConfigData() return configData end
---@return scenechange_config_cell
function scenechange_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function scenechange_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if v.cameraparammax ~= "-1" and v.cameraparammin ~= "-1" then
			local param = stringSplit(v.cameraparammax, ';')
			local parampos = stringSplitToNumber(param[2], ',')
			local paramrot = stringSplitToNumber(param[3], ',')
			configData[k].NewMaxFov = tonumber(param[1])
			configData[k].NewMaxPosX = parampos[1]
			configData[k].NewMaxPosY = parampos[2]
			configData[k].NewMaxPosZ = parampos[3]
			configData[k].NewMaxRotX = paramrot[1]
			configData[k].NewMaxRotY = paramrot[2]
			configData[k].NewMaxRotZ = paramrot[3]

			param = stringSplit(v.cameraparammin, ';')
			parampos = stringSplitToNumber(param[2], ',')
			paramrot = stringSplitToNumber(param[3], ',')
			configData[k].NewMinFov = tonumber(param[1])
			configData[k].NewMinPosX = parampos[1]
			configData[k].NewMinPosY = parampos[2]
			configData[k].NewMinPosZ = parampos[3]
			configData[k].NewMinRotX = paramrot[1]
			configData[k].NewMinRotY = paramrot[2]
			configData[k].NewMinRotZ = paramrot[3]
		end
		if v.cameraparam ~= "-1" then
			configData[k].NewFitFov = tonumber(v.cameraparam)
		end
	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
scenechange_config.AnalyseConfig()
----%%%-------------%%%----








return scenechange_config
