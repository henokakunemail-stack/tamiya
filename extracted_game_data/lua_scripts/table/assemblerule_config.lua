



---@class assemblerule_config




assemblerule_config = {}
---@type table<number,assemblerule_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/assemblerule')), '')
local bytes = mono.LoadBytes('assemblerule')
local cfg = assert(Dll_PB.decode('assemblerule_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'assemblerule.txt'
function assemblerule_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 groove = ConvertToNumber(configName, 'groove', columns[2]),
		 partsflag = ConvertToNumber(configName, 'partsflag', columns[3]),
		 fflaglist = columns[4],
		 hpoint = columns[5],
		 offset = columns[6],
		 offset1 = columns[7],
		 symhpoint = columns[8],
		 symmetry = columns[9],
		 linkid = ConvertToNumber(configName, 'linkid', columns[10]),
		 dyclinkid = ConvertToNumber(configName, 'dyclinkid', columns[11]),
		 linkpoint = columns[12],
		 linkptoffset = columns[13],
		 symlinkpoint = columns[14],
		 symptoffset = columns[15],
		 scale = columns[16],
		 symscale = columns[17],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
assemblerule_config.Load()
----------以pb方式加载配置表---end




---@return table<number,assemblerule_config_cell>
function assemblerule_config.GetConfigData() return configData end
---@return assemblerule_config_cell
function assemblerule_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function assemblerule_config.AnalyseConfig()
	for k, v in pairs(configData) do
		local temp1 = stringSplitToNumber(v.offset, ',')
		configData[k].NewOffset = LuaVector3(temp1[1], temp1[2], temp1[3])
		if v.symmetry ~= "-1" and v.symmetry ~= "0" then
			local temp2 = stringSplitToNumber(v.symmetry, ',')
			configData[k].NewOffset2 = LuaVector3(temp2[1], temp2[2], temp2[3])
		end
		configData[k].NewParent = stringSplitToNumber(v.fflaglist, ',')



		if v.linkptoffset ~= "-1" and v.linkptoffset ~= "0" then
			local temp3 = stringSplitToNumber(v.linkptoffset, ',')
			configData[k].NewLinkOffset = LuaVector3(temp3[1], temp3[2], temp3[3])
		end

		if v.symptoffset ~= "-1" and v.symptoffset ~= "0"  then
			local temp4 = stringSplitToNumber(v.symptoffset, ',')
			configData[k].NewLinkSymOffset = LuaVector3(temp4[1], temp4[2], temp4[3])
		end
		if v.scale ~= "-1" and v.scale ~= "0"  then
			local temp4 = stringSplitToNumber(v.scale, ',')
			configData[k].NewScale = LuaVector3(temp4[1], temp4[2], temp4[3])
		end
		if v.symscale ~= "-1" and v.symscale ~= "0"  then
			local temp4 = stringSplitToNumber(v.symscale, ',')
			configData[k].NewSymScale = LuaVector3(temp4[1], temp4[2], temp4[3])
		end
		v.linkptoffset=nil
		v.symptoffset=nil
		v.symmetry=nil
		v.fflaglist=nil
		v.offset=nil
		v.scale=nil
		v.symscale=nil
	end
end

---@type table<number, table<number, assemblerule_config_cell>>
local __GrooveDict = {}
function assemblerule_config.CreateGrooveDict()
	for k, v in pairs(configData) do
		if __GrooveDict[v.groove] == nil then
			__GrooveDict[v.groove] = {}
		end
		if __GrooveDict[v.groove][v.partsflag]==nil then
			__GrooveDict[v.groove][v.partsflag]={}
		end
		local tab = __GrooveDict[v.groove][v.partsflag]
		table.insert(tab, v)
	end
	for k, v in pairs(__GrooveDict) do
		for m, n in pairs(v) do
			table.sort(n,function(a, b)
				local countA = 0
				local countB = 0

				for _, v in ipairs(a.NewParent) do
					if v == -1 then countA = countA + 1 end
				end
				for _, v in ipairs(b.NewParent) do
					if v == -1 then countB = countB + 1 end
				end
				return countA < countB
			end)
		end
	end
end

function assemblerule_config.GetAssembleCfg(grooveid, flag, parents)
	local tab = __GrooveDict[grooveid]
	if tab == nil then return nil end
	tab =tab[flag]
	if tab == nil then return nil end
	for i = 1, #tab do
		local v = tab[i]
		--log("---   <<<<<<<   配置表遍历：",grooveid,flag,v.NewParent[1],v.NewParent[2],v.NewParent[3] )
		local istrue = true
		for j = 1, #v.NewParent do
			local flag = v.NewParent[j]
			local parentflag = parents[j]
			if flag ~= -1 and parentflag ~= flag then
				istrue = false
			end
		end
		if istrue then return v end
	end
end
function assemblerule_config.GetAssembleByGroveAndFlag(grooveid, flag)
	local tab = __GrooveDict[grooveid]
	if tab == nil then return nil end
     local result={}
	for i = 1, #tab do
		local v = tab[i]
		if v.partsflag == flag then
			table.insert(result,v)
		end
	end
	return result
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
assemblerule_config.AnalyseConfig()
assemblerule_config.CreateGrooveDict()
----%%%-------------%%%----








return assemblerule_config
