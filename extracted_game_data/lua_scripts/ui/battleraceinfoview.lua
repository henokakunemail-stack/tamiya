---@class BattleRaceInfoView : ViewBase
BattleRaceInfoView = class("BattleRaceInfoView", ViewBase)

function BattleRaceInfoView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BattleRaceInfoViewAction")
end

function BattleRaceInfoView:Awake()
    self:CacheRaceInfoViewData()
    self:InitBattleTrackData()
end

function BattleRaceInfoView:OnOpen()
    self:SetAllBattleTrackData()
end



function BattleRaceInfoView:CacheRaceInfoViewData()
    self.PlayerInfos = self:GetChild("PlayerInfos")
    self.tweenGos = {}
    self.carCount = BattleDyDataManager:Get():GetCarCount()
end


function BattleRaceInfoView:InitBattleTrackData()
    for i = 1, 5 do
        local tweenGo = self:GetChildByParent(string.format("%s%d", "tween", i), self.PlayerInfos)
        if i <= self.carCount then
            tweenGo.gameObject:SetActive(true)
        else
            tweenGo.gameObject:SetActive(false)
        end
        table.insert(self.tweenGos, tweenGo)
    end
end

function BattleRaceInfoView:SetAllBattleTrackData()
    for i = 1, self.carCount do
        local carDyData = BattleDyDataManager:Get():GetCarDataByIndex(i)
        self:SetOneBattleTrackData(carDyData, self.tweenGos[i].gameObject)
    end
end

---@param carDyData CarDyData
function BattleRaceInfoView:SetOneBattleTrackData(carDyData, tweenGo)
    ---@type carshell_config_cell
    local carData = CommonHelper:GetTableDataByID(ConfigNames.dictpartcell_config, carDyData:GetShellId())
    local carName = ClientDataManager:Get():GetTemplateString(carData.carNameid)
    CommonHelper:SetText("CarName", tweenGo,carName)
    CommonHelper:SetText("PlayerName",tweenGo, carDyData.playerName)
end