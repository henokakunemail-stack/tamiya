---@class HistoryDataManager
HistoryDataManager = class("HistoryDataManager")


function HistoryDataManager:initialize()

end
function HistoryDataManager:Get()
    if self._instance == nil then
        self._instance = HistoryDataManager()
    end
    return self._instance
end
local DirPath=CS.AppPath.PersistentDataPath4Res .. "RaceHistory/"
local RaceModuleName={}
RaceModuleName[RaceModel.RaceTrot]=TemplateStringID.RaceTrotName
RaceModuleName[RaceModel.RaceGVG]=TemplateStringID.RaceGVGName
RaceModuleName[RaceModel.RaceTop]=TemplateStringID.RaceTopName
RaceModuleName[RaceModel.RaceJcp]=TemplateStringID.RaceJcpName
RaceModuleName[RaceModel.RaceXcp]=TemplateStringID.RaceXcpName
RaceModuleName[RaceModel.RaceCarGod]=TemplateStringID.RaceCarGodName
RaceModuleName[RaceModel.RaceClub3v3]=TemplateStringID.RaceClub3V3Name
function HistoryDataManager:Init()
    ---@type GlobalHistoryData[]
    self.HistoryDataList={}
    if CS.System.IO.Directory.Exists(DirPath) then
        local files= CS.System.IO.Directory.GetFiles(DirPath)
        for i = 0, files.Length-1 do
            print(files[i])
            print(HotfixHelper:ReadFileString(files[i]))
        end
    end
end

function HistoryDataManager:Save(json,raceModule)
   local time= CommonHelper:GetNowTime()
   local  data = string.format("%04d_%02d_%02d_%02d_%02d", time.Year, time.Month, time.Day,time.Hour,time.Minute)
   local fileName= string.format("%s_%d.txt",data,raceModule)
   local path= DirPath.."/"..fileName
    HotfixHelper:WriteFileString(path, json)
end
---@class GlobalHistoryData
GlobalHistoryData=class("GlobalHistoryData")
function GlobalHistoryData:initialize()
    self.name=nil
    self.date=nil
    self.type=nil
    self.json=nil
end