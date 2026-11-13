



---@class dicttempletstringattrfeature_config




dicttempletstringattrfeature_config = {}
---@type table<number,dicttempletstringattrfeature_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dicttempletstringattrfeature')), '')
local bytes = mono.LoadBytes('dicttempletstringattrfeature')
local cfg = assert(Dll_PB.decode('dicttempletstringattrfeature_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dicttempletstringattrfeature_key.txt'
local configName_chs = 'dicttempletstringattrfeature_chs.txt'
local configName_cht = 'dicttempletstringattrfeature_cht.txt'
local configName_en = 'dicttempletstringattrfeature_en.txt'
local configName_tai = 'dicttempletstringattrfeature_tai.txt'
local configName_ind = 'dicttempletstringattrfeature_ind.txt'
local configName_pt_BR = 'dicttempletstringattrfeature_pt_BR.txt'
local configName_kr = 'dicttempletstringattrfeature_kr.txt'
function dicttempletstringattrfeature_config.Load()
	 local content = loadConfig(configName)
	 local linesString = nil
	 local lines = stringSplit(content, '\n')
	 content=nil
	 local len = #lines
	 local languageType =  CS.Horizon.Game.Language.LanguageSwitchManager.Get():GetCurLanguage()
	 if languageType== LanguageType.CHS then local content = loadConfig(configName_chs) linesString = stringSplit(content, '\n') end
	 if languageType== LanguageType.CHT then local content = loadConfig(configName_cht) linesString = stringSplit(content, '\n') end
	 if languageType== LanguageType.EN then local content = loadConfig(configName_en) linesString = stringSplit(content, '\n') end
	 if languageType== LanguageType.THAI then local content = loadConfig(configName_tai) linesString = stringSplit(content, '\n') end
	 if languageType== LanguageType.IDA then local content = loadConfig(configName_ind) linesString = stringSplit(content, '\n') end
	 if languageType== LanguageType.PT_BR then local content = loadConfig(configName_pt_BR) linesString = stringSplit(content, '\n') end
	 if languageType== LanguageType.KR then local content = loadConfig(configName_kr) linesString = stringSplit(content, '\n') end
	 if linesString==nil then return end
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local lineString = linesString[index]
		 local columns = stringSplit(line, '\t')
		 local contentString = stringSplit(lineString, '\t')
		 local row = {
		 C_ID = columns[1],
		 text=contentString[1]
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
		 lineString = nil
		 contentString = nil
	 end
	 lines = nil
	 linesString = nil
end
dicttempletstringattrfeature_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dicttempletstringattrfeature_config_cell>
function dicttempletstringattrfeature_config.GetConfigData() return configData end
---@return dicttempletstringattrfeature_config_cell
function dicttempletstringattrfeature_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function dicttempletstringattrfeature_config.AnalyseConfig(id)
----@@@SkipInLuaCfg@@@----
--	for k, v in pairs(configData) do
--		configData[k]=StringConfigField(v)
--	end
----@@@EndSkipInLuaCfg@@@----
end
function dicttempletstringattrfeature_config.ReLoad()
	configData = nil
	configIdx = nil
	configData = {}
	configIdx = {}
	dicttempletstringattrfeature_config.Load()
end


----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dicttempletstringattrfeature_config.AnalyseConfig()
----%%%-------------%%%----








return dicttempletstringattrfeature_config
