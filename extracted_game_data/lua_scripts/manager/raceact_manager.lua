---@class LoginRaceActInfo
---@field Id
---@field BeginTime
---@field EndTime
---@field IsOpen
---@field SeasonId


---@class RaceActManager
RaceActManager = class("RaceActManager")

---@return RaceActManager
function RaceActManager:Get()
    if self._instance == nil then
        self._instance = RaceActManager()
    end
    return self._instance
end

function RaceActManager:initialize()
   ---@type  LoginRaceActInfo[]
   self.RaceDic={}
end
---@param msg SC_fightInfo[]
function RaceActManager:Init(msg)
    ---@type  LoginRaceActInfo[]
    self.RaceDic={}
    for i = 1, #msg do
        if msg[i].fightid==RaceActId.RaceSuperBattle and PlayerDataManager:Get():GetPlayerServerID()==171   then
        else
            ---@type LoginRaceActInfo
            local temp={}
            temp.Id=msg[i].fightid
            temp.IsOpen=false
            if msg[i].btime==0 and msg[i].etime==0 then
                temp.IsOpen=true
            end
            temp.BeginTime=CommonHelper:ConvertIntToDataTime(msg[i].btime*1000)
            temp.EndTime=CommonHelper:ConvertIntToDataTime(msg[i].etime*1000)
            temp.SeasonId=msg[i].seasonid
            table.insert(self.RaceDic,temp)
        end

    end
end
---@return boolean,LoginRaceActInfo
function RaceActManager:GetRaceInfo(id,isshowtips,isreturntime,index)
    if isreturntime==nil then isreturntime=false end
    if isshowtips==nil then isshowtips=false end
    if index==nil then index=1 end
    local data=self:GetDataById(id)
    if #data>0 then
        local temp=data[index]
        if temp then
            if (CommonHelper:GetNowTime()>temp.BeginTime and CommonHelper:GetNowTime()<temp.EndTime) or temp.IsOpen then
                return true, temp
            end
            if isreturntime then
                if isshowtips then
                    CommonTipsHelper:Get():ShowCenterTips(self:GetStringById(id))
                end
                return false,temp
            end
        end
    end
    if isshowtips then
        CommonTipsHelper:Get():ShowCenterTips(self:GetStringById(id))
    end
    return false ,nil
end
function RaceActManager:GetDataById(id)
    local result={}
    for k, v in pairs(self.RaceDic) do
        if id==v.Id then
            table.insert(result,v)
        end
    end
    return result
end

function RaceActManager:GetStringById(id)
    local raceName=nil
    if id==RaceActId.RaceJcp then
      raceName=CommonHelper:GetTempStr_Default(TemplateStringID.RaceJcpName)
    end
    if id==RaceActId.RaceClub3V3 then
        raceName=CommonHelper:GetTempStr_Default(TemplateStringID.RaceClub3V3Name)
    end
    if id==RaceActId.RaceTop then
        raceName=CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopName)
    end
    if id==RaceActId.RaceGVG then
        raceName=CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGName)
    end
    if id==RaceActId.RaceTrot then
        raceName=CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotName)
    end
    if id==RaceActId.RaceCarGod then
        raceName=CommonHelper:GetTempStr_Default(TemplateStringID.RaceCarGodName)
    end
   if id==RaceActId.RaceSuperBattle then
        raceName=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleName)
    end
    return  CommonHelper:GetTempStr_Default(TemplateStringID.RaceActNoOpen,raceName)
end

---@return LoginRaceActInfo[]
function RaceActManager:GetRaceAct()
    return self.RaceDic
end

---@return LoginRaceActInfo[]
function RaceActManager:OpenRaceActView(id,func)
   logError( " RaceActManager:OpenRaceActView ", id)
    if id==RaceActId.RaceTrot then
        FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceTrot,func,nil,true)
    end
   if id==RaceActId.RaceTop then
       FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceTop,func)
    end
   if id==RaceActId.RaceSuperBattle then
       FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceSuper,func)
    end
   if id==RaceActId.RaceGVG then
       FunctionSkipManager:Get():SkipToFunction(GameFunction.Club,func)
       RaceGVGManager:Get().ReturnBattleGVG=true
    end
end


