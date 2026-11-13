


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/challengeteam')), '')
local datalist = {}
local textname = 'challengeteam.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("challengeteam", "id", param[1])
	 data.name = param[2]
	 data.banner = param[3]
	 data.bannertext = param[4]
	 data.desc = param[5]
	 data.showtime = param[6]
	 data.showtime1 = param[7]
	 data.racetype = ConvertToNumber("challengeteam", "racetype", param[8])
	 table.insert(datalist, data)
end

local function analyseList()
	 local content = CS.Horizon.EditorTool.TableCfg.PBCfg.ReadTxt(textname)
	 local strs = stringSplit(content, '\n')
	 for i = 4, #strs - 1 do
		 local temp = stringSplit(strs[i], '\t')
		 analyse(temp)
	 end
	 local tab = { configData = datalist }
	 local reqBytes = assert(Dll_PB.encode('challengeteam_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
