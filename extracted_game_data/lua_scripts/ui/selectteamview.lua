

---@class SelectTeamView : ViewBase
SelectTeamView = class("SelectTeamView", ViewBase)

function SelectTeamView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelectTeamViewAction")

    ---@type LevelData
    self.LevelData = nil

    self.Pre_SelectCar = nil
    ---@type Page_SelectCar
    self.Page_SelectCar = nil
end

function SelectTeamView:Awake()
    log("---   SelectTeamView awake")

    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnFight", self.gameObject, function(hbtn)
        self:OnClickBtn_Fight()
    end)

    CommonHelper:HButtonSetCallback("BtnSwap", self.gameObject, function(hbtn)
        self:OnClickBtn_Swap()
    end)

    CommonHelper:HButtonSetCallback("BtnAssemble", self.gameObject, function(hbtn)
        self:OnClickBtn_Assemble()
    end)
    CommonHelper:HButtonSetCallback("BtnReview", self.gameObject, function(hbtn)
        self:OnClickBtn_Review()
    end)

    self.PageRoot = UIUtil.GetChild("pageroot",self.gameObject)
    self.Pre_SelectCar =UIUtil.GetChild("Page_SelectCar",self.gameObject)
end

function SelectTeamView:OnOpen()

end

function SelectTeamView:OnClose()
    self.Page_SelectCar:Release()
    CommonHelper:ReleasePool(UIModuleID.SelectTeam)
end

function SelectTeamView:OnAutoClose()
    self.Page_SelectCar:Release()
end

function SelectTeamView:ReOpen()
    self:SetCar()
end

---@param leveldata LevelData
function SelectTeamView:SetData(leveldata)
    self.LevelData = leveldata
    self:SetLevelInfo()
    self:SetCost()
    self:SetCar()
end
function SelectTeamView:OnOpenAnimEnd()
    self:CheckNewBieGuide(nil,GuideTriggerType.PveLevelTrigger,nil,self.LevelData.idx)
end

function SelectTeamView:SetLevelInfo()

    CommonHelper:SetText("title/text", self.gameObject, self.LevelData.idxname.."   "..self.LevelData.name)
    CommonHelper:SetText("leveltips", self.gameObject, self.LevelData.leveltips)

    local trackdata = CommonHelper:GetRacetrackData(self.LevelData.trackId)
    if trackdata then
        CommonHelper:GetComponentSetTrackIconByData("trackicon", self.gameObject, trackdata, UIModuleID.SelectTeam)
    end

    ---@type table<number, table<number, RewardData>>
    local datalist = {}
    for i = 1, #self.LevelData.FirstReward do table.insert(datalist, {true, self.LevelData.FirstReward[i]}) end
    for i = 1, #self.LevelData.SomeDown do table.insert(datalist, {false, self.LevelData.SomeDown[i]}) end
    local scrollview = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H", self.gameObject, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(scrollview, #datalist, 1,function(dataIndex, itemObj, scroll)
        local temp = datalist[dataIndex + 1]
        local isfirst = temp[1]
        local reward = temp[2]
        local obj = UIUtil.GetChild("PropCompoent", itemObj)
        local param = Param_PropSquareParam()
        param.moduleId = UIModuleID.SelectTeam
        param.id = reward.id
        param.count = reward.num
        param.BtnFun=true
        CommonHelper:SetPropSquareGroup(obj, param)
       CommonHelper:HButtonSetCallback("BtnItem",itemObj,function(data)
           CommonHelper:ShowPartInfoByCfgId(data.intData,UIModuleID.SelectTeam)
       end,reward.id)
        CommonHelper:SetGameObjectActive("first", itemObj, isfirst)
    end)
end

function SelectTeamView:SetCost()
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.SwapTicket)
    local costnum = KnapsackDataManager:Get():GetArticleCountByCfgid(tonumber(cfg.varval))
    local powervalue = PlayerDataManager:Get():GetPlayerStamina()

    if 1 > costnum then
        CommonHelper:SetText("costvalue", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountFormatRed, costnum, 1))
    else
        CommonHelper:SetText("costvalue", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountFormatGreen, costnum, 1))
    end

    if 5 > powervalue then
        CommonHelper:SetText("powervalue", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountFormatRed, powervalue, 5))
    else
        CommonHelper:SetText("powervalue", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountFormatGreen, powervalue, 5))
    end

end

function SelectTeamView:SetCar()
    if self.Page_SelectCar == nil then
        --PrefabCacheMgr:Get():SwapPrefabAsync("Page_SelectCar.prefab", nil, nil, function(param, obj)
        --    self.Pre_SelectCar = obj
        --    UIUtil.SetParentGameObject(self.PageRoot, obj, true, true)
            self.Page_SelectCar = Page_SelectCar()
            self:SetPageSelectCar()
        --end)
    else
        self:SetPageSelectCar()
    end
    local port = CommonHelper:CameraPortUIFit("CameraUIFit",self.gameObject)
    HomeSceneHelper:SetSelectCar(port)
end

function SelectTeamView:SetPageSelectCar()
    if self.Page_SelectCar then
        self.Page_SelectCar:SetData(self.Pre_SelectCar, UIModuleID.SelectTeam,1,false, SceneChangeID.SelectCar, true)
    end

end


function SelectTeamView:OnClickBtn_Fight()
    local levelid = self.LevelData.newid
    local data = self.Page_SelectCar:GetCurCar()

    if CarDataManager:Get():CheckCarCompleteness(data:GetID()) then
        StoryHelper:TouchStory_SelectTeam(levelid, function()
            BattleSubsystem:Get():SendMsg_BattleBegin(levelid, data:GetID())
        end)
    end

   -- PlayerDataManager:Get():SetPlayerStamina(PlayerDataManager:Get():GetPlayerStamina()-5)

end

function SelectTeamView:OnClickBtn_Assemble()
    --local data = self.Page_SelectCar:GetCurCar()
    --if data then
    --    SkipModuleHelper:Get():ToAssemble(SkipAssembleType.Map, data.carIdx, PartGrooveID.Shell, nil)
    --end
end
function SelectTeamView:OnClickBtn_Review()
    local trackdata = CommonHelper:GetRacetrackData(self.LevelData.trackId)
    if trackdata then
        CommonHelper:LoadReviewTrack(nil, trackdata)
    end
end

function SelectTeamView:OnClickBtn_Swap()
    if self.LevelData.state ~= 1 then
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.SwapLock))
        return
    end
    ---@type dictcalc_config_cell
    local value = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.SwapTicket)
    local costcount = KnapsackDataManager:Get():GetArticleCountByCfgid(tonumber(value.varval))
    if costcount <= 0 then
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.SwapNoMoney))
        return
    end

    if PlayerDataManager:Get():GetPlayerStamina() < 5 then
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.PowerNotEnough))
        return
    end


    local boxfunc = function()
        local ret, tog = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue,ClientDataManager:Get():GetTemplateString(TemplateStringID.SwapSure))
        if ret == MessageBoxHelp.BtnType.OK then
            ChapterSubsystem:Get():SendMsg_Swap(self.LevelData.newid,  1)
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
end


function SelectTeamView:RefreshData()
    self:SetCost()
end
