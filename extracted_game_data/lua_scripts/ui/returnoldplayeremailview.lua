---@class ReturnOldPlayerEmailView : ViewBase
ReturnOldPlayerEmailView = class("ReturnOldPlayerEmailView", ViewBase)

function ReturnOldPlayerEmailView:initialize()
    ViewBase.initialize(self)
end

function ReturnOldPlayerEmailView:Awake()

    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():HidePersistentView("ReturnOldPlayerEmailView")
    end)

end

function ReturnOldPlayerEmailView:OnOpen()
    local playerName = PlayerDataManager:Get():GetPlayerName()
    local leaveNum = ReturnOldPlayerDataManager:Get():GetReturnEmailDayNum()
    local startYear, startMonth, startDay = self:GetDataTime(ReturnOldPlayerDataManager:Get():GetReturnEmailFirstLogin())
    local levelData = PVEChapterDataManager:Get():GetLevelDataByLevelId(PlayerDataManager:Get():GetLevelId())
    local level = PlayerDataManager:Get():GetPlayerLV()
    local bodyShell = ReturnOldPlayerDataManager:Get():GetReturnEmailCarShellNum()

    local showStr = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ReturnOldPlayerEmail),
            tostring(playerName),
            tostring(leaveNum),
            tostring(startYear),
            tostring(startMonth),
            tostring(startDay),
            tostring(string.gsub(levelData.name, " ", "")),
            tostring(level),
            tostring(bodyShell))

    CommonHelper:SetNewLineText("###Tittle", self.gameObject, showStr)

    local awardStr = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.ReturnOldPlayerEmailData)

    local list = stringSplit(awardStr.varval, ':')
    local awardList = {}
    for i = 1, #list do
        local strs = stringSplit(list[i], '#')
        table.insert(awardList, { strs[1], strs[2] })
    end

    for i = 1, #awardList do
        local objName = ("ItemAward_" .. i)
        local obj = UIUtil.GetChild(objName, self.gameObject)
        local param = Param_ItemArticleParam()
        param.count = tonumber(awardList[i][2])
        CommonHelper:SetItemComGroup(obj, UIModuleID.ReturnOldPlayer, tonumber(awardList[i][1]), param)
    end

end

function ReturnOldPlayerEmailView:GetDataTime(_time)
    local year = tonumber(os.date("%y", _time))
    local month = tonumber(os.date("%m", _time))
    local day = tonumber(os.date("%d", _time))

    return year, month, day
end

function ReturnOldPlayerEmailView:OnClose()

    PopupManager:Get():FirstPopupOnClose()

end