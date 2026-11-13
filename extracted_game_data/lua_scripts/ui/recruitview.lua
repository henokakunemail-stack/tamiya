--local _ref = 0
---@class RecruitView : RecruitView
RecruitView = class("RecruitView", ViewBase)

function RecruitView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RecruitViewAction")
end

function RecruitView:Awake()
    self:CacheRecruitViewData()
    self:InitRecruitViewBtn()
    LogoutClearManager:Get():RegisterEvent(self, self.SkipAni)
end
local _CurSubType = -1
function RecruitView:OnOpen()
    self:ViewFixScreen()
    RedPointManager:Get():UpdateValue(RedPointID.S_Recruit_Task, true)
    HomeSceneHelper:SetDefaultScene()

end
function RecruitView:ReOpen()
    HomeSceneHelper:SetDefaultScene()
    local selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
    local recruitData = RecruitDataManager:Get():GetDataById(selectRecruitId)
    if recruitData:GetId() == 501 then
        UINotify:Get():SendNotification(UINotifyEvent.Msg_SetFriendShip, { CurrencyType.FriendShip, recruitData:GetTabIcon() })
    else
        UINotify:Get():SendNotification(UINotifyEvent.Msg_SetFriendShip, { recruitData:GetTicketId(), recruitData:GetTabIcon() })
    end
end
function RecruitView:SetData(isreset)
    self:InitRecruitTypeList(isreset)
    UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitBtn, isreset)
end

function RecruitView:CacheRecruitViewData()

    self.recruitTypeList = self:GetChildWight("RecruitTypeList", typeof(MoreRowScrollView))
    self.AttrType = self:GetChildWight("MoreRowScrollView_AttrType", typeof(MoreRowScrollView))
    self.RecruitTG = self:GetChildWight("Center", typeof(FXUITweenMoreGroup))
    self.RecruitTG2 = self:GetChildWight("Tween2", typeof(FXUITweenMoreGroup))
end
local _RecruitAnimToggle = false
function RecruitView:InitRecruitViewBtn()

    self.BtnOne = CommonHelper:HButtonSetCallback("BtnOne", self.gameObject, function(hbtn)
        RecruitDataManager:Get():SetRecruitType(RecruitType.Main)
        self:OnRecruitBtnClick(LotteryType.One)
    end)
    self.TogglePlayAnim = CommonHelper:HButtonSetCallback("TogglePlayAnim", self.gameObject, function(hbtn)
        _RecruitAnimToggle = not _RecruitAnimToggle
        PlayerPrefsHelper:SetValue_RecruitAnimSkip(_RecruitAnimToggle)
        self:SetToggleSelectAnim()
    end)

    self.BtnTen = CommonHelper:HButtonSetCallback("BtnTen", self.gameObject, function(hbtn)
        RecruitDataManager:Get():SetRecruitType(RecruitType.Main)
        self:OnRecruitBtnClick(LotteryType.Ten)
    end)
    self.Btn_Task = CommonHelper:HButtonSetCallback("Btn_Task", self.gameObject, function(hbtn)
        local selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
        local recruitData = RecruitDataManager:Get():GetDataById(selectRecruitId)
        if recruitData:GetTaskShellTask() then
            FunctionSkipManager:Get():SkipToFunction(GameFunction.Task, { TaskType.Recruit, UIModuleID.Recruit, selectRecruitId })
            return
        end
        if recruitData:GetTaskCountTask() then
            TaskDataManager:Get():SetOpenModuleType(UIModuleID.Recruit)
            TaskDataManager:Get():SetRecruitID(selectRecruitId)
            RecruitSubsystem:Get():SendMsg_GetRecruitCountInfo(selectRecruitId)
            return
        end

    end)

    self.BtnVideo = CommonHelper:HButtonSetCallback("BtnVideo", self.gameObject, function(hbtn)
        local selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
        local recruitData = RecruitDataManager:Get():GetDataById(selectRecruitId)
        CommonHelper:PlayerVideo(recruitData.cfg.videoname, function()
        end, nil, nil, true)
    end)

    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnSureWish", self.gameObject, function(hbtn)
        local selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
        local recruitData = RecruitDataManager:Get():GetDataById(selectRecruitId)
        local result = ""
        for i = 1, recruitData:GetRecruitViewType() do
            if recruitData:GetCurSelect(i) and recruitData:GetCurSelect(i) > 0 then
                result = result .. recruitData:GetCurSelect(i)
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RecruitCellNoSelectPart, i))
                return
            end
            if i ~= recruitData:GetRecruitViewType() then
                result = result .. ":"
            end
        end
        local flag = false
        for i = 1, recruitData:GetRecruitViewType() do
            if recruitData:GetCurSelect(i) and recruitData:GetCurSelect(i) > 0 then
                if recruitData:GetCurSelect(i) ~= recruitData:GetCurOrgSelect(i) then
                    flag = true
                    break
                end
            end
        end
        if flag then
            RecruitSubsystem:Get():SendMsg_MiniChange(selectRecruitId, result)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RecruitSelectPartRepeat))
        end

    end)
    CommonHelper:HButtonSetCallback("BtnHome", self.gameObject, function(hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(false)
    end)
    self.BtnExchange = CommonHelper:HButtonSetCallback("BtnExchange", self.gameObject, function(hbtn)
        UIManager:Get():OpenPopup("RecruitMiniExchangeView", CanvasType.FrontCanvas, "RecruitMiniExchangeView")
        UINotify:Get():SendNotification(UINotifyEvent.RecruitMiniExchangeView_SetData, RecruitDivinationCell.None)
    end)
    self.BtnExchangeed = CommonHelper:HButtonSetCallback("BtnExchangeed", self.gameObject, function(hbtn)
        UIManager:Get():OpenPopup("RecruitMiniExchangeedView", CanvasType.FrontCanvas, "RecruitMiniExchangeedView")
        UINotify:Get():SendNotification(UINotifyEvent.RecruitMiniExchangedView_SetData, RecruitDivinationCell.None)
    end)
    for i = 1, 5 do
        CommonHelper:HButtonSetCallback("BtndivinationPart" .. i, self.gameObject, function(hbtn)
            local selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
            local recruitData = RecruitDataManager:Get():GetDataById(selectRecruitId)
            if recruitData:GetCurSelect(hbtn.intData) == nil or recruitData:GetCurSelect(hbtn.intData) == 0 then
                if hbtn.intData > RecruitDivinationCell.Shell then
                    UIManager:Get():OpenPopup("RecruitMiniExchangeMoreView", CanvasType.MainCanvas, "RecruitMiniExchangeMoreView")
                    UINotify:Get():SendNotification(UINotifyEvent.RecruitMiniExchangeMoreView_SetData, hbtn.intData)
                else
                    UIManager:Get():OpenPopup("RecruitMiniExchangeView", CanvasType.FrontCanvas, "RecruitMiniExchangeView")
                    UINotify:Get():SendNotification(UINotifyEvent.RecruitMiniExchangeView_SetData, hbtn.intData)
                end
            else
                UIManager:Get():OpenPopup("RecruitMiniExchangeedView", CanvasType.FrontCanvas, "RecruitMiniExchangeedView")
                UINotify:Get():SendNotification(UINotifyEvent.RecruitMiniExchangedView_SetData, hbtn.intData)
            end
        end, i)
    end

    CommonHelper:HButtonSetCallback("BtnProbability", self.gameObject, function(hbtn)
        UIManager:Get():OpenPopup("ProbabilityView", CanvasType.FrontCanvas, "ProbabilityView")
    end)
    self.RecruitGroup = {}
    for i = 3, 7 do
        self.RecruitGroup[i] = UIUtil.GetChild("recruit_fx/group" .. i, self.gameObject)
    end
end
function RecruitView:SetToggleSelectAnim()
    CommonHelper:SetToggleState(self.TogglePlayAnim, _RecruitAnimToggle)
end
function RecruitView:InitRecruitTypeList(isreset)
    local count = RecruitDataManager:Get():GetRecruitTypeCount()
    local updateFunc = function(dataIndex, itemObj, scroll)
        local recruitData = RecruitDataManager:Get():GetDataByIndex(dataIndex + 1)

        local normal = CommonHelper:GetComponentSetUITexture("normal", itemObj, recruitData:GetTypeIcon() .. "_dt.png", UIModuleID.Recruit)
        local selectImg = CommonHelper:SetGameObjectActive("selectImg", itemObj, recruitData:GetId() == RecruitDataManager:Get():GetCurSelectRecruitId() or (RecruitDataManager:Get():GetDataById(RecruitDataManager:Get():GetCurSelectRecruitId()) and RecruitDataManager:Get():GetDataById(RecruitDataManager:Get():GetCurSelectRecruitId()):GetGroupId() == recruitData:GetId()))
        --CommonHelper:SetImageColorRGBA(normal, recruitData:GetId() == RecruitDataManager:Get():GetCurSelectRecruitId() and "ffffffff" or "FFFFFFAD")
        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(param)

            RecruitDataManager:Get():SetCurSelectRecruitId(recruitData:GetId())

            CommonHelper:TMG_PlayAllTween(self.RecruitTG)

            UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitViewInfo)
            CommonHelper:MoreRowView_RefreshCurList(self.recruitTypeList, false)
        end)

        CommonHelper:SetGameObjectActive("RedPointModule", itemObj, RecruitDataManager:Get():GetRedById(recruitData:GetId()) ~= nil or RecruitDataManager:Get():GetRedById(recruitData:GetId() + 100000) ~= nil)
    end
    CommonHelper:InitMoreRowScrollView(self.recruitTypeList, count, 1, updateFunc, true)
    UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitViewInfo)
    if isreset then
        CommonHelper:TMG_PlayAllTween(self.RecruitTG)
    end
end
----设置抽奖数据
function RecruitView:InitViewInfo()

    local selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
    local recruitData = RecruitDataManager:Get():GetDataById(selectRecruitId)
    _RecruitAnimToggle=PlayerPrefsHelper:GetValue_RecruitAnimSkip()
    self:SetToggleSelectAnim()
    if recruitData and recruitData:GetGroupId() then
        recruitData = RecruitDataManager:Get():GetDataById(recruitData:GetGroupId())
    end
    self:SetAttrTypeScrollView(recruitData)
    return recruitData
end
---@param recruitData RecruitData
function RecruitView:SetRecruitView(recruitData)
    self.RecruitData = recruitData
    local LeftTimeCount = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), recruitData:GetRecruitSum(), recruitData:GetRecruitTimeLimit())
    CommonHelper:SetText("###LeftTimeText", self.gameObject, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), CommonHelper:GetTempStr_Default(TemplateStringID.RecruitLimit), LeftTimeCount))
    CommonHelper:SetGameObjectActive("FreeText", self.gameObject, recruitData:GetCurFreeTime() == 0 and recruitData:GetFreeNum() == 1)
    CommonHelper:SetGameObjectActive("FreeText", self.gameObject, recruitData:GetCurFreeTime() == 0 and recruitData:GetFreeNum() == 1)
    CommonHelper:SetHButtonClick(self.BtnVideo, recruitData.cfg.videoname ~= "0", true)
    CommonHelper:SetGameObjectActive("Btn_Task", self.gameObject, recruitData:GetTaskType())
    CommonHelper:SetGameObjectActive("Btn_Task/RedPointModule", self.gameObject, RecruitDataManager:Get():GetRedByIdIsTask(recruitData:GetId()) or RecruitDataManager:Get():GetRedByIdIsCount(recruitData:GetId()))
    CommonHelper:SetGameObjectActive("Exchange", self.gameObject, recruitData:GetRecruitViewType() == RecruitViewType.Exchange and recruitData:GetSelectTime() and #recruitData:GetAwardIds() > 0)
    self.DivinationObj = CommonHelper:SetGameObjectActive("group_divination", self.gameObject, recruitData:GetRecruitViewType() == RecruitViewType.Divination)
    if recruitData:GetRecruitViewType() == RecruitViewType.Exchange then
        if recruitData:GetCurSelect(RecruitDivinationCell.None) > 0 then
            ---@type dictparts_config_cell
            local type, cfg = CommonHelper:GetPropTypeById(recruitData:GetCurSelect(RecruitDivinationCell.None))
            CommonHelper:SetGameObjectActive("BtnExchange", self.gameObject, true)
            local partObj = CommonHelper:SetGameObjectActive("ItemPart_138", self.gameObject, true)
            CommonHelper:SetItemPartGroup(partObj, UIModuleID.Recruit, recruitData:GetCurSelect(RecruitDivinationCell.None), ItemPartUIType.Simple, nil, function(intData)
            end)
            CommonHelper:SetText("Exchange/###selectpart", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RecruitSelectPart, CommonHelper:GetTempStr_Default(cfg.partname)))
        else
            CommonHelper:SetGameObjectActive("BtnExchange", self.gameObject, true)
            CommonHelper:SetGameObjectActive("ItemPart_138", self.gameObject, false)
            CommonHelper:SetText("Exchange/###selectpart", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RecruitSelectPart, CommonHelper:GetTempStr_Default(TemplateStringID.RecruitSelectNoSelect)))
        end
    end

    CommonHelper:SetGameObjectActive("ConsumeOne/TicketIcon", self.gameObject, recruitData:GetCurFreeTime() ~= 0 or recruitData:GetFreeNum() == 0)
    local oneImage, tenImage
    local oneCount = recruitData.info.oneExpend
    local tenCount = recruitData.info.tenExpend

    oneImage = CommonHelper:GetComponentSetImage("TicketIcon", self.BtnOne.gameObject, recruitData:GetTicketIcon(), UIModuleID.Recruit)
    tenImage = CommonHelper:GetComponentSetImage("TicketIcon", self.BtnTen.gameObject, recruitData:GetTicketIcon(), UIModuleID.Recruit)
    if recruitData:GetCurFreeTime() == 0 and recruitData:GetFreeNum() == 1 then
        CommonHelper:SetText("###ConsumeCountText", self.BtnOne.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RecruitFreeText))
    else
        CommonHelper:SetText("###ConsumeCountText", self.BtnOne.gameObject, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrNum), CommonHelper:GetTempStr_Default(TemplateStringID.RecruitShowX), oneCount))
    end
    CommonHelper:SetText("###ConsumeCountText", self.BtnTen.gameObject, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrNum), CommonHelper:GetTempStr_Default(TemplateStringID.RecruitShowX), tenCount))

    CommonHelper:ImageSetNativeSize(oneImage)
    CommonHelper:ImageSetNativeSize(tenImage)

    local count = 0
    if recruitData:GetId() == 501 then
        count = recruitData:GetSelfTicket()
        UINotify:Get():SendNotification(UINotifyEvent.Msg_SetFriendShip, { CurrencyType.FriendShip, recruitData:GetTabIcon() })
    else
        count = KnapsackDataManager:Get():GetArticleCountByCfgid(recruitData:GetTicketId())
        UINotify:Get():SendNotification(UINotifyEvent.Msg_SetFriendShip, { recruitData:GetTicketId(), recruitData:GetTabIcon() })
    end
    CommonHelper:SetText("###CurTicketCountText", self.gameObject, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrNum), CommonHelper:GetTempStr_Default(TemplateStringID.RecruitCurNum), count))
    if recruitData:GetTabIcon() ~= "-1" then
        local image = CommonHelper:GetComponentSetImage("ConsumeImage", self.gameObject, recruitData:GetTabIcon(), UIModuleID.Recruit)
        CommonHelper:ImageSetNativeSize(image)
    end

    CommonHelper:GetComponentSetUITexture("recruitrole", self.gameObject, recruitData:GetBgRole(), UIModuleID.Recruit)
    CommonHelper:GetComponentSetUITexture("recruitbanner", self.gameObject, recruitData:GetBgBanner(), UIModuleID.Recruit)
    CommonHelper:SetText("###minimumguaranteecount", self.gameObject, CommonHelper:GetTempStr_Default(recruitData:GetMaxName(), recruitData:GetPrizeCount()))

    local startEndTime = CommonHelper:SetGameObjectActive("startEndTime", self.gameObject, recruitData:GetStartTime() > 0 and recruitData:GetEndTime() > 0)
    if recruitData:GetStartTime() > 0 and recruitData:GetEndTime() > 0 then
        self:SetEndTimeText(recruitData:GetEndTime() / 1000)

    end
    CommonHelper:SetHButtonClick(self.BtnOne, oneCount > 0, true)
    self:InitNewRecruitInfo(recruitData)
    self:SetRecruitShowIcon(recruitData)
end
---@param recruitData RecruitData
function RecruitView:SetRecruitShowIcon(recruitData)
    if recruitData:GetRecruitViewType() == RecruitViewType.Divination then
        for k, v in pairs(self.RecruitGroup) do
            CommonHelper:CSGameObjectSetActive(self.RecruitGroup[k], false)
        end
        CommonHelper:SetGameObjectActive("recruitbanner", self.gameObject, false)
        CommonHelper:SetGameObjectActive("recruitrole", self.gameObject, false)
        for i = 1, recruitData:GetRecruitViewType() do
            local itemObj = CommonHelper:SetGameObjectActive("ItemPart_" .. i, self.DivinationObj, (recruitData:GetCurSelect(i) and recruitData:GetCurSelect(i) > 0))
            if (recruitData:GetCurSelect(i) and recruitData:GetCurSelect(i) > 0) then
                local partId = recruitData:GetCurSelect(i)
                local param = Param_ItemPartParam()
                param.generation = 1
                CommonHelper:SetItemPartGroup(itemObj, UIModuleID.Recruit, partId, ItemPartUIType.Simple, param, function(id)
                    CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.Recruit)
                end, partId)
            end
        end
        CommonHelper:GetComponentSetUIMaterialTexture("recruitRawImage", self.gameObject, "uitex_sucai_recruit_bg.png", UIModuleID.Recruit)
    else
        CommonHelper:GetComponentSetUIMaterialTexture("recruitRawImage", self.gameObject, recruitData:GetBgIcon(), UIModuleID.Recruit)
        CommonHelper:SetGameObjectActive("recruitbanner", self.gameObject, true)
        CommonHelper:SetGameObjectActive("recruitrole", self.gameObject, true)
        local partIds = {}
        if recruitData:GetShowPart() == "0" then
            ---@type dictaward_config
            local awardTab = ClientDataManager:Get():GetDataTable(ConfigNames.dictaward_config)
            ---@type dictaward_config_cell[]
            local prop = awardTab.GetPropTableByIdIdx(recruitData.probability[1].awardid)
            for i = 1, #prop do
                table.insert(partIds, prop[i].propsid)
            end
        else
            partIds = stringSplitToNumber(recruitData:GetShowPart(), ':')
        end
        local parent = nil
        local count = 0
        for k, v in pairs(self.RecruitGroup) do
            CommonHelper:CSGameObjectSetActive(self.RecruitGroup[k], k == #partIds)
            if k == #partIds then
                parent = self.RecruitGroup[k]
                count = k
            end
        end
        if parent == nil then
            if #partIds >= 7 then
                CommonHelper:CSGameObjectSetActive(self.RecruitGroup[7], true)
                count = 7
                parent = self.RecruitGroup[7]
            end
            if #partIds <= 3 then
                CommonHelper:CSGameObjectSetActive(self.RecruitGroup[3], true)
                count = 3
                parent = self.RecruitGroup[3]
            end
        end
        for i = 1, count do
            local type, partcfg = CommonHelper:GetPropTypeById(partIds[i])
            local obj = CommonHelper:SetGameObjectActive("BtnPart" .. i, parent, partcfg ~= nil)
            if partcfg then
                if type == PropType.Part then
                    local baseCfg = CommonHelper:GetPartBaseCfg(partIds[i])
                    CommonHelper:GetComponentSetUITexture("RawImage", obj, partcfg.icon, UIModuleID.Recruit)
                    CommonHelper:SetGameObjectActive("Image", obj, baseCfg.parttype == PartType.Shell)
                    CommonHelper:SetGameObjectActive("PartStar", obj, false)
                    CommonHelper:SetGameObjectActive("articleType", obj, false)
                    CommonHelper:SetPartStar("PartStar", obj, 1, baseCfg.maxstar)
                end
                if type == PropType.Article then
                    ---@type dictarticle_config_cell
                    CommonHelper:GetComponentSetUITexture("RawImage", obj, partcfg.NewIcon, UIModuleID.Recruit)
                    CommonHelper:SetGameObjectActive("Image", obj, false)
                    local image = CommonHelper:GetArticleTypeImage(partcfg.propstype, partcfg.subtype)
                    if image then
                        CommonHelper:GetComponentSetImage("articleType", obj, image, UIModuleID.Recruit)
                    end
                    CommonHelper:SetGameObjectActive("articleType", obj, image ~= nil)
                    CommonHelper:SetGameObjectActive("PartStar", obj, false)
                end
                CommonHelper:HButtonSetCallback("BtnPart" .. i, parent, function(hbtn)
                    CommonHelper:ShowPartInfoByCfgId(hbtn.intData, UIModuleID.Recruit)
                end, partIds[i])

            end
        end
    end
end
---@param data RecruitData
function RecruitView:SetAttrTypeScrollView(data)
    local datas = data:GetRecruits()
    CommonHelper:SetGameObjectActive("attrtype", self.gameObject, datas and #datas ~= 0)
    if datas == nil then
        self:SetRecruitView(data)
        return
    end
    _CurSubType = PlayerPrefsHelper:GetValue_RecruitSubType()
    if datas[_CurSubType] == nil then
        _CurSubType = 1
    end
    RecruitDataManager:Get():SetCurSelectRecruitId(datas[_CurSubType]:GetId())
    self:SetRecruitView(datas[_CurSubType])
    CommonHelper:InitMoreRowScrollView(self.AttrType, #datas, 1, function(dataIndex, itemObj, scroll)
        CommonHelper:SetText("normal/###text", itemObj, CommonHelper:GetTempStr_Default(datas[dataIndex + 1]:GetAttType()))
        CommonHelper:SetText("hover/###text", itemObj, CommonHelper:GetTempStr_Default(datas[dataIndex + 1]:GetAttType()))
        local Tog = CommonHelper:HButtonSetCallback("Toggle2", itemObj, function(hbtn)
            if _CurSubType == hbtn.intData + 1 then
                return
            end
            _CurSubType = hbtn.intData + 1
            PlayerPrefsHelper:SetValue_RecruitSubType(_CurSubType)
            RecruitDataManager:Get():SetCurSelectRecruitId(datas[_CurSubType]:GetId())
            self:SetRecruitView(datas[_CurSubType])
            CommonHelper:TMG_PlayAllTween(self.RecruitTG2)
            CommonHelper:MoreRowView_RefreshCurList(self.AttrType, false)
        end, dataIndex)
        CommonHelper:SetToggleState(Tog, _CurSubType == dataIndex + 1)
    end)
end

---初始化新手信息
---@param recruitData RecruitData
function RecruitView:InitNewRecruitInfo(recruitData)
    if recruitData:GetId() == 601 then
        CommonHelper:SetHButtonClick(self.BtnOne, recruitData:GetSumVal() > 0, true)
        if recruitData:GetSumVal() <= 0 then
            CommonHelper:SetText("###ConsumeCountText", self.BtnTen.gameObject, "")
            CommonHelper:SetText("###ConsumeFree", self.BtnTen.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RecruitNewFree))
        else
            CommonHelper:SetText("###ConsumeFree", self.BtnTen.gameObject, "")
        end
    else
        CommonHelper:SetText("###ConsumeFree", self.BtnTen.gameObject, "")
    end
end

function RecruitView:InitBtn(isEnable)
    CommonHelper:SetHButtonClick(self.BtnOne, isEnable, false)
    CommonHelper:SetHButtonClick(self.BtnTen, isEnable, false)
end

function RecruitView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.Recruit)
end

function RecruitView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end

function RecruitView:SetEndTimeText(endTime)

    if self.raceTimerID ~= 0 then
        TimerManager:Get():StopTimer(self.raceTimerID)
    end
    self.raceTimerID = TimerManager:Get():CreateTimerLoop(1, function()
        if UIManager:Get():IsViewShow("RecruitView") then
            local subTime = math.abs(endTime - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()))
            if subTime <= 0 then
                RecruitSubsystem:Get():SendMsg_RecruitInfo(1)
            end
            local day = math.modf(subTime / TimeSecond_Day)
            local hour = math.modf((subTime - (day * TimeSecond_Day)) / TimeSecond_Hour)
            local minute = math.modf((subTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour)) / TimeSecond_Minute)
            local second = subTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour) - (minute * TimeSecond_Minute)

            if day >= 1 then
                CommonHelper:SetText("###startEndText", self.gameObject,
                        CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTime, day, hour, minute))
            else
                CommonHelper:SetText("###startEndText", self.gameObject,
                        CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTimeSecond, hour, minute, second))
            end
        end
    end, nil, true)
end

----根据次数抽奖
function RecruitView:OnRecruitBtnClick(count)

    local selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
    local recruitData = RecruitDataManager:Get():GetDataById(selectRecruitId)

    local nowTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) * 1000

    local isCanRecruit = true
    if recruitData:GetRecruitViewType() == RecruitViewType.Divination and not recruitData:GetIsOrgSelect() then
        if not recruitData:GetIsSelectIsSure() then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RecruitCellNoSurePart))
            return
        end
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RecruitCellNoHasPart))
        return
    end
    if recruitData:GetStartTime() ~= 0 then
        if nowTime < recruitData:GetStartTime() then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RecruitNoOpen))
            isCanRecruit = false
        elseif nowTime >= recruitData:GetEndTime() then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RecruitEnd))
            isCanRecruit = false
        end
    end

    if isCanRecruit then
        if count == 1 and recruitData:GetCurFreeTime() == 0 and recruitData:GetFreeNum() == 1 then
            --单抽如果是免费的，就是免费抽
            count = 0
        end

        RecruitDataManager:Get():SetRecruitCount(count)
        local payCount = recruitData:GetOneConsume()
        if count == 10 then
            payCount = recruitData:GetTenConsume()
        end
        if count <= 0 or recruitData:GetSelfTicket() >= payCount or (recruitData:GetId() == 601 and recruitData:GetSumVal() <= 0) then
            UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitBtn, false)
            RecruitSubsystem:Get():SendMsg_Recruit(selectRecruitId, count, RecruitPayType.Ticket)
        else
            self:RecruitEnsure(recruitData, count)
        end
    end
end
----抽奖确认
-----@param recruitData RecruitData
function RecruitView:RecruitEnsure(recruitData, count)

    local currencyType = recruitData:GetTicketId()
    local currencyName = CommonHelper:GetCurrencyTypeName(currencyType)
    local currencyCount = count == 1 and recruitData:GetOneConsume() or recruitData:GetTenConsume()

    if PlayerDataManager:Get():GetCurrency(currencyType) >= currencyCount then
        if CommonHelper:CheckPlayerIsNewGuide() then
            self:Recruit(recruitData, count)
        else
            self:Recruit(recruitData, count)
        end
    else
        if currencyType == 0 then
            currencyType = recruitData:GetMoneyType()
        end
        self:NewRecruitGoView(currencyType, currencyCount)
    end
end
function RecruitView:NewRecruitGoView(currencyType, count)
    local _result = PlayerDataManager:Get():CheckCurrencyEnough(currencyType, count, false)
    if not _result then
        if currencyType == RecruitCard.Gold then
            local MoneyIfEnough = ChargeTipsDataManager:Get():GetMoneyIfEnough(currencyType, CurrencyType.Gold, count)
            if MoneyIfEnough > 0 then
                CommonHelper:ShowCurrencyNoEnough(CurrencyType.Gold)
            else
                CommonHelper:NewRecruitGoView(currencyType, CurrencyType.Gold, count)
            end
            return
        end
        if currencyType == RecruitCard.Diamond then
            CommonHelper:NewRecruitGoView(currencyType, CurrencyType.Diamond, count)
            return
        end
        PlayerDataManager:Get():CheckCurrencyEnough(currencyType, count)
    end
end
---@param recruitData RecruitData
function RecruitView:Recruit(recruitData, count)
    RecruitSubsystem:Get():SendMsg_Recruit(recruitData:GetId(_CurSubType), count, RecruitPayType.GoldDiamond)
    if self.btnClickTimerId ~= 0 then
        TimerManager:Get():StopTimer(self.btnClickTimerId)
    end
    UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitBtn, false)
    self.btnClickTimerId = TimerManager:Get():CreateTimer(6, function()
        if self.btnClickTimerId ~= 0 then
            TimerManager:Get():StopTimer(self.btnClickTimerId)
        end
        UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitBtn, true)
    end)
end

----根据次数抽奖
---@param msg SC_UserRecruit
function RecruitView:PlayAni(msg)
    if PlayerPrefsHelper:GetValue_RecruitAnimSkip() then
        UIManager:Get():OpenPopup("RecruitShowView", CanvasType.MainCanvas, "RecruitShowView")
        UINotify:Get():SendNotification(UINotifyEvent.RecruitShowView_InitViewInfo, { msg, RecruitDataManager:Get():GetRecruitCount(),false })
        return
    end
    local lotteryCarType = LotteryCarType.Normal
    local lotteryType = LotteryType.Ten
    local isAdvance = false
    if #msg.mySomeDown > 0 then
        for i = 1, #msg.mySomeDown[1].partViewId do
            local quality = -1

            local cfg = CommonHelper:GetPartBaseCfg(msg.mySomeDown[1].partViewId[i])

            quality = cfg.fabric

            isAdvance = quality >= QualityType.Gold

            if isAdvance then
                break
            end
        end
        if not isAdvance then
            for i = 1, #msg.mySomeDown[1].downProps do
                local quality = -1
                ---@type dictarticle_config_cell
                local cfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, msg.mySomeDown[1].downProps[i].propid)

                quality = cfg.propsgrade

                isAdvance = quality >= QualityType.Gold

                if isAdvance then
                    break
                end
            end
        end
    end
    if #msg.mySomeDown[1].partViewId == 10 then

    else
        lotteryType = LotteryType.One
        if msg.myRecruits[1].recruitId == 601 or msg.myRecruits[1].recruitId == 501 then

        else
            lotteryCarType = LotteryCarType.Diamond
        end

    end
    ---@type RecruitViewAni
    --if isAdvance then
    --    self.ani=RecruitViewAni1()
    --else
    self.ani = RecruitViewAni2()
    --end
    self.ani:Begin(lotteryCarType, lotteryType, isAdvance, function()
        UIManager:Get():CloseView()--关闭skip view
        UIManager:Get():OpenPopup("RecruitShowView", CanvasType.MainCanvas, "RecruitShowView")
        UINotify:Get():SendNotification(UINotifyEvent.RecruitShowView_InitViewInfo, { msg, RecruitDataManager:Get():GetRecruitCount(),true })
    end)
end

function RecruitView:SkipAni()
    if self.ani then
        self.ani:SkipAni()
    end
end




