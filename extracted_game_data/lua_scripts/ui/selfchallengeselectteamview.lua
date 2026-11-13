

local __CurCarIdx = -1


---@class SelfChallengeSelectTeamView : ViewBase
SelfChallengeSelectTeamView = class("SelfChallengeSelectTeamView", ViewBase)

function SelfChallengeSelectTeamView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelfChallengeSelectTeamViewAction")

    print("---   SelectTeamView 初始化完成")
    ---@type LevelData
    self.LevelData = nil
    ---@type ChapterData
    self.ChapterData = nil
end

function SelfChallengeSelectTeamView:Awake()
    print("---   SelectTeamView awake")

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnFight",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeSelectTeamView_Fight)
    end)

    CommonHelper:HButtonSetCallback("BtnSwap",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeSelectTeamView_Swap)
    end)

    CommonHelper:HButtonSetCallback("BtnSetting",self.gameObject,function (hbtn)
        local data = CarDataManager:Get():GetCarDataByIndex(__CurCarIdx)
        --UIManager:Get():OpenView("TransformView", CanvasType.MainCanvas, "TransformView")
        --local param = TransformViewParam()
        --param.Type = TransformUIFlag.Car
        --param.CarIdx = data.carIdx
        --param.CarData = data
        --UINotify:Get():SendNotification(UINotifyEvent.TransformView_SetData, { param, true})
        CommonHelper:PlayScreenEffectUIMask(1.5)
    end)

    self.BtnLeft = CommonHelper:HButtonSetCallback("BtnLeft",self.gameObject,function ()
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeSelectTeamView_ClickChange, -1)
    end)
    self.BtnRight = CommonHelper:HButtonSetCallback("BtnRight",self.gameObject,function ()
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeSelectTeamView_ClickChange, 1)
    end)

    self.RewardView = UIUtil.GetTypeChildWightByParent("Rewardgroup", self.gameObject, typeof(InfinityScrollView))

    self.viewRect =  UIUtil.GetTypeChildWightByParent("viewrect", self.gameObject, typeof(RectTransform))
    self.maskRect =  UIUtil.GetTypeChildWightByParent("maskrect", self.gameObject, typeof(RectTransform))
    self.fillBg =  UIUtil.GetTypeChildWightByParent("fillbg", self.gameObject, typeof(RectTransform))
end


function SelfChallengeSelectTeamView:OnOpen()

    --HomeSceneHelper:SetSelectCarYellow()
    self:SetFillBg()

end

function SelfChallengeSelectTeamView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.SelectTeam)
    --UICarMeshHelper:Get():Recycle()
    HomeSceneCarMeshHelper:Get():ClearCache()
end

function SelfChallengeSelectTeamView:OnAutoClose()
    --UICarMeshHelper:Get():Recycle()
    HomeSceneCarMeshHelper:Get():ClearCache()
end

function SelfChallengeSelectTeamView:ReOpen()

    --HomeSceneHelper:SetSelectCarYellow()
    self:SetCarInfo()
end

function SelfChallengeSelectTeamView:SetFillBg()
    local rectvalue = self.viewRect.rect.height
    local fillvalue = (self.fillBg.rect.height - self.maskRect.rect.height )/ self.fillBg.rect.height
    CommonHelper:SetFillBg("fillbg",self.gameObject,fillvalue,rectvalue)
end

---@param data LevelData
---@param chapter ChapterData
function SelfChallengeSelectTeamView:SetInfo(data, chapter)
    self.LevelData = data
    self.ChapterData = chapter
    self.CarList = CarDataManager:Get():GetCarList()

    self:SetData()

    self:SetRewardView()

    self:SetArticle()

    self:AutoSelect()
end

function SelfChallengeSelectTeamView:OnClickBtn_Fight()
    local levelid = self.LevelData.newid
    local chapterData=SelfChallengeDataManager:Get():GetChapterData()
    local data = CarDataManager:Get():GetCarDataByIndex(__CurCarIdx)
    if data==nil then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarInParkingLot))
    else
        if levelid<chapterData.process then
            CommonTipsHelper:Get():ShowCenterTips("已经完成不能二次参加")
        else
            SelfChallengeDataManager:Get():SetCurSelectCarData(data)
            SelfChallengeDataManager:Get().LevelId=levelid
            SelfChallengeSubsystem:Get():SendBeginSelfChallenge(chapterData.id,levelid,data:GetID())

        end
     end
end

function SelfChallengeSelectTeamView:OnClickBtn_Swap()
    if self.LevelData.state ~= 1 then
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.SwapLock))
        return
    end
    -----@type dictcalc_config_cell
    --local value = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.SwapTicket)
    --local costcount = KnapsackDataManager:Get():GetArticleCountByCfgid(tonumber(value.varval))
    --if costcount <= 0 then
    --    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.SwapNoMoney))
    --    return
    --end

    UIManager:Get():OpenPopup("SwapView",CanvasType.FrontCanvas,"SwapView")
    UINotify:Get():SendNotification(UINotifyEvent.SwapView_SetData, self.LevelData)

end

function SelfChallengeSelectTeamView:SetData()
    CommonHelper:SetText("TitleCompoentRed/title1", self.gameObject, self.LevelData.idxname)
    CommonHelper:SetText("TitleCompoentRed/title2", self.gameObject, self.LevelData.name)

    local iconRaw = UIUtil.GetTypeChildWightByParent("minimap", self.gameObject, typeof(RawImage))
    if iconRaw then
        --CommonHelper:SetUITexture(iconRaw, self.LevelData.icon, UIModuleID.SelectTeam)
    end

    CommonHelper:SetText("leveltips", self.gameObject, ClientDataManager:Get():GetTemplateString(self.LevelData.leveltips))
    local track=CommonHelper:GetRacetrackData(self.LevelData.trackresname)
    CommonHelper:GetComponentSetTrackIconByData("TrackPic",self.gameObject,track,UIModuleID.SelfChallenge)
    CommonHelper:GetComponentTransferTime("personrecord", self.gameObject, self.LevelData.personRecord)
end

function SelfChallengeSelectTeamView:SetArticle()
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.SwapTicket)
    local costnum = KnapsackDataManager:Get():GetArticleCountByCfgid(tonumber(cfg.varval))
    local powervalue = PlayerDataManager:Get():GetPlayerStamina()
    local text = CommonHelper:SetText("costvalue", self.gameObject, string.format("%d/1",costnum) )
    if 1 > costnum then
        CommonHelper:SetTextColor(text, "ff0000")
    else
        CommonHelper:SetTextColor(text, "ffffff")
    end

    text = CommonHelper:SetText("powervalue", self.gameObject,string.format("%d/5",powervalue))
    if 5 > powervalue then
        CommonHelper:SetTextColor(text, "ff0000")
    else
        CommonHelper:SetTextColor(text, "ffffff")
    end
end

function SelfChallengeSelectTeamView:RefreshData()
    self:SetArticle()
end



function SelfChallengeSelectTeamView:SetCarInfo()
    local data = CarDataManager:Get():GetCarDataByIndex(__CurCarIdx)

    if data == nil then
        CommonHelper:SetText("carname", self.gameObject, "")
    else
        CommonHelper:SetText("carname", self.gameObject, ClientDataManager:Get():GetTemplateString(data:GetShellCfg().carNameid))

        --local parent = UIUtil.GetChild("SelectTeam", UIManager:Get():GetMeshCanvasRoot())
        --UICarMeshHelper:Get():ShowCar(data.carId, CarBuilderType.Assemble, parent)
        --HomeSceneCarMeshHelper:Get():SetDataByCarData(data, SceneHome_CarGroup_Garage_Yellow, false)

        CommonHelper:SetText("fightvalue", self.gameObject, tostring(data:GetScore()) )
    end
end



function SelfChallengeSelectTeamView:OnClickChange(value)
    local max = #self.CarList
    __CurCarIdx = __CurCarIdx + value
    if __CurCarIdx < 1 then __CurCarIdx = 1 end
    if __CurCarIdx > max then __CurCarIdx = max end

    self:UpdatePageBtn()

    self:SetCarInfo()
end

function SelfChallengeSelectTeamView:UpdatePageBtn()
    local max = #self.CarList

    CommonHelper:SetHButtonClick(self.BtnLeft,  __CurCarIdx ~= 1, true)
    CommonHelper:SetHButtonClick(self.BtnRight,  __CurCarIdx ~= max, true)
end

function SelfChallengeSelectTeamView:AutoSelect()
    __CurCarIdx = 0
    self:OnClickChange(1)
end

function SelfChallengeSelectTeamView:SetRewardView()
    CommonHelper:InitScroll_OneRow(self.RewardView, #self.LevelData.rewardsid, function (dataIndex, itemObj, scroll)
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeSelectTeamView_UpdateRewardView, {dataIndex, itemObj, scroll})
    end)
end

function SelfChallengeSelectTeamView:UpdateRewardView(dataIndex, itemObj, scroll)

    local param = Param_ArticleGroup()
    param.articleId = self.LevelData.rewardsid[dataIndex + 1]
    param.moduleId = UIModuleID.SelectTeam
    param.count = tostring(self.LevelData.rewardsnum[dataIndex + 1])
    CommonHelper:SetArticleGroup(itemObj, param)
end