---@class CarAttrRecommendData
---@field public C_ID
---@field public track
---@field public motor
---@field public gear
---@field public stabilizeMin
---@field public stabilizeMax
---@field public cushionMin
---@field public cushionMax
---@field public downforceMin
local CarRecommendPath=CS.AppPath.PersistentDataPath4Res .. "PartRecommend/tracksuggest.txt"
local __instance
---@class CarAttrRecommendManager
CarAttrRecommendManager = class("CarAttrRecommendManager")
function CarAttrRecommendManager:initialize()
    ---@type CarAttrRecommendData[][][]
    self.Data={}
end
---@return CarAttrRecommendManager
function CarAttrRecommendManager:Get()
    if __instance == nil then
        __instance = CarAttrRecommendManager()
    end
    return __instance
end
function CarAttrRecommendManager:Init()
   local version=PlayerPrefsHelper:GetValue_CarAttrRecommendVersion()
   LoginSubSystem:Get():SendMsg_CarAttrRecommendVersion(function(serverversion)
       if version~=serverversion then
           self:GetServerConfig(serverversion)
       else
           if HotfixHelper:CheckFileExist(CarRecommendPath) then
               local text=self:Read()
               if CommonHelper:IsNullOrEmpty(text) then
                   self:GetServerConfig(serverversion)
               else
                   try( function()
                       self:Parse(text)
                   end).catch(function(error)
                       logError("解析本地的配置错误")
                       self:GetServerConfig(serverversion)
                   end)
               end
           else
               self:GetServerConfig(serverversion)
           end
       end
   end)
end

function CarAttrRecommendManager:GetServerConfig(serverversion)
    LoginSubSystem:SendMsg_CarAttrRecommend(function(text)
        self:Save(text)
        self:Parse(text)
        PlayerPrefsHelper:SetValue_CarAttrRecommendVersion(serverversion)
    end)
end
function CarAttrRecommendManager:Parse(content)
    local lines = stringSplit(content, '\n')
    local len = #lines
    local index = 4
    while index <= len - 1 do
        local line = lines[index]
        local columns = stringSplit(line, '\t')
        local row = {
            C_ID = ConvertToNumber("tracksuggest", 'C_ID', columns[1]),
            track = ConvertToNumber("tracksuggest", 'track', columns[2]),
            motor = ConvertToNumber("tracksuggest", 'motor', columns[3]),
            gear = ConvertToNumber("tracksuggest", 'gear', columns[4]),
            stabilizeMin = ConvertToNumber("tracksuggest", 'stabilizeMin', columns[5]),
            stabilizeMax = ConvertToNumber("tracksuggest", 'stabilizeMax', columns[6]),
            cushionMin = ConvertToNumber("tracksuggest", 'cushionMin', columns[7]),
            cushionMax = ConvertToNumber("tracksuggest", 'cushionMax', columns[8]),
            downforceMin = ConvertToNumber("tracksuggest", 'downforceMin', columns[9]),
            downforceMax = ConvertToNumber("tracksuggest", 'downforceMax', columns[10]),
        }
        if self.Data[row.track]==nil then
            self.Data[row.track]={}
        end
        if self.Data[row.track][row.motor]==nil then
            self.Data[row.track][row.motor]={}
        end
        table.insert(self.Data[row.track][row.motor],row)
        index = index + 1
        line = nil
        columns = nil
    end
    lines = nil
end

function CarAttrRecommendManager:Save(text)
    HotfixHelper:WriteFileString(CarRecommendPath, text)
end

function CarAttrRecommendManager:Read()
  return HotfixHelper:ReadFileString(CarRecommendPath)
end
---@return CarAttrRecommendData
function CarAttrRecommendManager:GetDataByTrackId_MotorId_GearId(trackid,motorid,gearid)
    if CommonHelper:GetPartBaseCfg(motorid)==nil or CommonHelper:GetPartBaseCfg(gearid)==nil then return nil end
    motorid=CommonHelper:GetPartBaseCfg(motorid).C_ID
    gearid=CommonHelper:GetPartBaseCfg(gearid).C_ID
    if self.Data[trackid] and self.Data[trackid][motorid] then
        for i = 1, #self.Data[trackid][motorid] do
            if self.Data[trackid][motorid][i].gear==gearid then
                return self.Data[trackid][motorid][i]
            end
        end
    end
    return nil
end
