---@class RecruitShowView : ViewBase
RecruitShowView = class("RecruitShowView", ViewBase)

function RecruitShowView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RecruitShowViewAction")
end

function RecruitShowView:Awake()
    self.count = nil--是十连抽还是单抽



    self:InitBtnFunc()

    self.ScrollView = UIUtil.GetTypeChildWightByParent("ScrollHorizontalOneRow", self.gameObject, typeof(MoreRowScrollView))

    LogoutClearManager:Get():RegisterEvent(self, self.SkipAni)
end

function RecruitShowView:OnOpen()
    UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitBtn, true)
    self:CheckNewBieGuide()
    CommonHelper:SetHButtonClick(self.BtnAgain,not CommonHelper:CheckPlayerIsNewGuide())
    CommonHelper:SetHButtonClick(self.BtnOk,not CommonHelper:CheckPlayerIsNewGuide())
   -- CommonHelper:ShowNoticeMsg()
end

---@param finishMsg SC_UserRecruit
function RecruitShowView:InitViewInfo(finishMsg, count,showviewAnim)
    self.count = count > 1 and 10 or 1

    local selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
    local recruitData = RecruitDataManager:Get():GetDataById(selectRecruitId)

    local ticketCount = count > 1 and recruitData.info.tenExpend or recruitData.info.oneExpend

    local  TenTicketIcon = CommonHelper:GetComponentSetImage("TenTicketIcon", self.gameObject, recruitData:GetTicketIcon(), UIModuleID.Recruit)
    CommonHelper:SetText("TenTicketIcon/ConsumeCountText", self.gameObject, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrNum), CommonHelper:GetTempStr_Default(TemplateStringID.RecruitShowX), ticketCount))
    CommonHelper:ImageSetNativeSize(TenTicketIcon)

    CommonHelper:CSGameObjectSetActive(self.BtnOk.gameObject, recruitData ~= nil)
    CommonHelper:CSGameObjectSetActive(self.BtnAgain.gameObject, recruitData ~= nil)
    CommonHelper:SetGameObjectActive("ConsumeTen", self.gameObject, recruitData ~= nil)

    self:InitShowList(CommonHelper:GetRewardDataBySomeDown(finishMsg.mySomeDown[1]),showviewAnim)
end
local AgainFlag=false
function RecruitShowView:InitBtnFunc()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function()
        AgainFlag=false
        UIManager:Get():ClosePopup()
    end)
    self.BtnOk = CommonHelper:HButtonSetCallback("BtnOk", self.gameObject, function()
        AgainFlag=false
        UIManager:Get():ClosePopup()
    end)
    self.BtnShare = CommonHelper:HButtonSetCallback("BtnShare", self.gameObject, function()
        QuickTaHelper:Get():ShareEvent('ShareOnClickStart')
        UnifySDKManager:Get():IShare():CaptureScreenshotSharePhoto()
        local recruitData = RecruitDataManager:Get():GetDataById(701)--指定查找的活动id
        QuickTaHelper:Get():ShareEvent('ShareOnClickEnd')
    end)

    local recruitData = RecruitDataManager:Get():GetDataById(701)--指定查找的活动id
    local  firstShare =false
    if recruitData then
        firstShare =recruitData.info.curShare == 0
    end
    local  btnShareActive =HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Share) and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk) == false
    CommonHelper:SetGameObjectActive("BtnShare",self.gameObject,  btnShareActive)

    CommonHelper:SetGameObjectActive("sharesign",self.BtnShare.gameObject,firstShare)
    self. BtnAgain = CommonHelper:HButtonSetCallback("BtnAgain", self.gameObject, function(hbtn)
        AgainFlag=true
        UIManager:Get():ClosePopup()
    end)
end


---关闭首次分享奖励标志
function RecruitShowView:FirstShareClose()
    CommonHelper:SetGameObjectActive("sharesign",self.BtnShare.gameObject,false)
end
function RecruitShowView:OnCloseAnimEnd()
    if AgainFlag then
        RecruitDataManager:Get():SetRecruitType(RecruitType.Again)
        UINotify:Get():SendNotification(UINotifyEvent.RecruitView_OnRecruitClick,self.count)
    end
end

---@param items table<number,RewardData>
function RecruitShowView:InitShowList(items,showviewAnim)
    if items == nil then
        return
    end
    local funcUpdateItem = function(dataIndex, itemObj, scroll)
        local data = items[dataIndex + 1]
        if data == nil then
            return
        end
        local param= Param_ItemArticleParam()
        param.count=data.num
        CommonHelper:SetItemComGroup(itemObj,UIModuleID.Recruit,data.id,param,function(intData)
            CommonHelper:ShowPartInfoByCfgId(intData, UIModuleID.Recruit)
        end,data.id,ItemPartUIType.Simple)
    end

    CommonHelper:InitMoreRowScrollView(self.ScrollView, #items, 5, funcUpdateItem, true)
    CommonHelper:MoreRowView_EnterAni2(self.ScrollView, 0.3)
end

function RecruitShowView:OnClose()
    self:CheckExitNewBieGuide()
    PopUpGiftDataManager:Get():DelayPopUpShow()
    UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitBtn, true)
end




