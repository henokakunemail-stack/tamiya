local __instance
---@class RaceFifaDataManager
RaceFifaDataManager = class("RaceFifaDataManager")
function RaceFifaDataManager:initialize()
    ---@type RaceFifaData
    self.RoomData = nil
end
---@return RaceFifaDataManager
function RaceFifaDataManager:Get()
    if __instance == nil then
        __instance = RaceFifaDataManager()
    end
    return __instance
end
---@param msg SC_RetFifaInfo
function RaceFifaDataManager:Init(msg,flag)
    self._RaceFifaData = RaceFifaData(msg)
    KnapsackDataManager:Get():UpdatePropByConsume(msg.consume)
    if UIManager:Get():IsViewShow("RaceFifaKnockoutView") then
        UINotify:Get():SendNotification(UINotifyEvent.RaceFifaGroupView_GuessSuccess,flag)
    else
        if UIManager:Get():IsViewShow("RaceFifaGuessView")==false then
            UIManager:Get():OpenView("RaceFifaGuessView",CanvasType.MainCanvas,"RaceFifaGuessView")
            UINotify:Get():SendNotification(UINotifyEvent.RaceFifaGuessView_SetData,RaceFifaDataManager:Get():GetRaceData())
        else
            UINotify:Get():SendNotification(UINotifyEvent.RaceFifaGuessView_GuessSuccess,{RaceFifaDataManager:Get():GetRaceData(),flag})
        end
    end
    if UIManager:Get():IsPopViewShow("RaceFifaTeamListView") then
        UIManager:Get():ClosePopup()
    end
end

function RaceFifaDataManager:GetRaceData(type)
    if type== RaceFifaRaceState.RaceKnockout then
        return self._RaceFifaData.KnockoutData
    end
    if type== RaceFifaRaceState.RaceGroup then
        return self._RaceFifaData.GroupData
    end
    return self._RaceFifaData.AllRaceData
end
---@return RaceFifaData
function RaceFifaDataManager:Get_RaceFifaData()
    return self._RaceFifaData
end
function RaceFifaDataManager:Get_RaceFifaSeasonId()
    return self._RaceFifaData.SeasonId
end

function RaceFifaDataManager:Get_RaceFifaChampionCountry()
    local _Data=RaceFifaDataManager:Get():GetRaceData()
    local serverTime= CommonHelper:GetNowTime()
    local index=1
    local serverday=serverTime.Month*100+serverTime.Day
    local DataIndex={}
    for i = 1, #_Data do
        local raceTime=CommonHelper:ConvertIntToDataTime(_Data[i].BettingEndTime*1000)
        local raceDay=raceTime.Month*100+raceTime.Day
        if DataIndex[raceDay]==nil then
            DataIndex[raceDay]=i
        end
    end
    for k, v in pairs(DataIndex) do
        if serverday==k then
            index=v
            break
        end
        if serverday>k then
            index=v
        end
    end
    local result={}
    if _Data[index].type==RaceFifaRaceState.RaceKnockout then
        local data=RaceFifaDataManager:Get():GetRaceData(RaceFifaRaceState.RaceKnockout)
        --1-8
        --9--12
        --13--14
        --15
        local curRaceIndex=1
        for i = 1, #data do
            if _Data[index].Id==data[i].Id then
                curRaceIndex=i
                break
            end
        end
        if curRaceIndex<=8 then
            for i = 1, 8 do
                local cfg1=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,data[i].TeamA)
                local cfg2=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,data[i].TeamB)
                if data[i].Result==RaceFifaBattleResult.None then
                    table.insert(result,cfg1)
                    table.insert(result,cfg2)
                else
                    if data[i].Result==RaceFifaBattleResult.Win then
                        table.insert(result,cfg1)
                    end
                    if data[i].Result==RaceFifaBattleResult.Lose then
                        table.insert(result,cfg2)
                    end
                end
            end
        elseif curRaceIndex>=9 and curRaceIndex<=12 then
            for i = 9, 12 do
                local cfg1=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,data[i].TeamA)
                local cfg2=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,data[i].TeamB)
                if data[i].Result==RaceFifaBattleResult.None then
                    table.insert(result,cfg1)
                    table.insert(result,cfg2)
                else
                    if data[i].Result==RaceFifaBattleResult.Win then
                        table.insert(result,cfg1)
                    end
                    if data[i].Result==RaceFifaBattleResult.Lose then
                        table.insert(result,cfg2)
                    end
                end
            end
        elseif curRaceIndex>=13 and curRaceIndex<=14 then
            for i = 13, 14 do
                local cfg1=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,data[i].TeamA)
                local cfg2=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,data[i].TeamB)
                if data[i].Result==RaceFifaBattleResult.None then
                    table.insert(result,cfg1)
                    table.insert(result,cfg2)
                else
                    if data[i].Result==RaceFifaBattleResult.Win then
                        table.insert(result,cfg1)
                    end
                    if data[i].Result==RaceFifaBattleResult.Lose then
                        table.insert(result,cfg2)
                    end
                end
            end
        else
            local cfg1=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,data[15].TeamA)
            local cfg2=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,data[15].TeamB)
            if data[i].Result==RaceFifaBattleResult.None then
                table.insert(result,cfg1)
                table.insert(result,cfg2)
            else
                if data[i].Result==RaceFifaBattleResult.Win then
                    table.insert(result,cfg1)
                end
                if data[i].Result==RaceFifaBattleResult.Lose then
                    table.insert(result,cfg2)
                end
            end
        end
    else
        local ConfigData=ClientDataManager:Get():GetDataTable(ConfigNames.dictuefacountry_config).GetCountryBySeason(self._RaceFifaData.SeasonId)
        for k, v in pairs(ConfigData) do
            table.insert(result,v)
        end
    end
    return result
end


