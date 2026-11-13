---@class PlayerLevelRewardView : ViewBase
PlayerLevelRewardView = class("PlayerLevelRewardView", ViewBase)

function PlayerLevelRewardView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PlayerLevelRewardViewAction")
end

function PlayerLevelRewardView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask", self.gameObject, function(data)
        UIManager:Get():HidePersistentView("PlayerLevelRewardView")
    end)
    CommonHelper:HButtonSetCallback("BtnLeft", self.gameObject, function(data)
        if self.Level>1 then
            self.Level=self.Level-1
            self:SetData()
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PlayerLevelMin))
        end
    end)
    CommonHelper:HButtonSetCallback("BtnRight", self.gameObject, function(data)
        if self.Level< self.Max then
            self.Level=self.Level+1
            self:SetData()
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PlayerLevelMax))
        end
    end)
    self.BtnGet=CommonHelper:HButtonSetCallback("BtnGet", self.gameObject, function(data)
        PlayerInfoSubsystem:Get():SendMsg_GetLevelReward(self.Level)
    end)
    self.BtnGeted=CommonHelper:HButtonSetCallback("BtnGeted", self.gameObject, function(data)

    end)
    self.ScrollView1 = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
    self.ScrollView2 = UIUtil.GetTypeChildWightByParent("ScrollVerticalMoreRow", self.gameObject, typeof(MoreRowScrollView))
end

function PlayerLevelRewardView:OnOpen()
    self.Level=PlayerDataManager:Get():GetPlayerLV()
    local  cfg=ClientDataManager:Get():GetDataTable(ConfigNames.levelup_config)
    local table=cfg.GetConfigData()
    self.Max=0
    for k, v in pairs(table) do
        if self.Max<v.C_ID then
            self.Max=v.C_ID
        end
    end
    cs_coroutine.start(function()
        coroutine.yield()
        self:SetData()
    end)
end

function PlayerLevelRewardView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.PlayerLevelReward)
end
function PlayerLevelRewardView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end

function PlayerLevelRewardView:SetData()
    self:SetFunctionList()
   self:SetRewardList()
   self:SetBtnState()
end

function PlayerLevelRewardView:SetFunctionList()
    local unlockTable=UnlockDataManager:Get():GetUnlockByLevelID(self.Level)
    local funcId = {}
    if unlockTable ~= nil then
        for funcIdKey, funcIdKeyValue in pairs(unlockTable) do
            ---@type functionlist_config_cell
            local cfg = nil
            if ClientDataManager:Get().IsConfig2 then
                cfg=CommonHelper:GetTableDataByID(ConfigNames.functionlist2_config, funcIdKeyValue)
            else
                cfg=CommonHelper:GetTableDataByID(ConfigNames.functionlist_config, funcIdKeyValue)
            end
            table.insert(funcId, CommonHelper:GetTempStr_Default(TemplateStringID.FunctionOpen,CommonHelper:GetTempStr_Default(cfg.name)))
        end
    end
    local cfg=CommonHelper:GetTableDataByID(ConfigNames.levelup_config,self.Level)
    if cfg.leveldesc~="0" then
        local leveldesc=stringSplit(cfg.leveldesc,':')
        for i = 1, #leveldesc do
            table.insert(funcId,CommonHelper:GetTempStr_Default(leveldesc[i]))
        end
    end
    CommonHelper:InitMoreRowScrollView(self.ScrollView1,#funcId,1,function(index, itemObj,scroll)
        CommonHelper:SetText("###index",itemObj,tostring(index+1))
        CommonHelper:SetText("###name",itemObj,funcId[index+1])
        local AutoScrollView = UIUtil.GetTypeChildWightInputPath("AutoMoveScrollView1",itemObj,typeof(AutoMoveScrollView))
        CommonHelper:AutoScroll_BreakMove(AutoScrollView,true)
        CommonHelper:AutoScroll_SetValue(AutoScrollView,0)
        cs_coroutine.start(function()
            coroutine.yield()
            CommonHelper:SetGameObjectActive("AutoMoveScrollView1/cotent",itemObj,false)
            CommonHelper:SetGameObjectActive("AutoMoveScrollView1/cotent",itemObj,true)
            CommonHelper:AutoScroll_Init(AutoScrollView,true,0,function()

            end)
        end)
    end)
end
function PlayerLevelRewardView:SetRewardList()
    local cfg=CommonHelper:GetTableDataByID(ConfigNames.levelup_config,self.Level)
    local count =3
    local reward={}
    if cfg.getawardids~="0" then
         reward= CommonHelper:SetDataByStrIdAndNum(cfg.getawardids,cfg.getawardnums)
        if #reward>count then count=#reward end
    end

    CommonHelper:InitMoreRowScrollView(self.ScrollView2,count,1,function(index, itemObj,scroll)
        CommonHelper:SetGameObjectActive("ItemCom_118",itemObj,reward[index+1]~=nil)
        if reward[index+1] then
            local param = Param_ItemArticleParam()
            param.count =reward[index+1].num
            CommonHelper:SetItemComGroup(itemObj,UIModuleID.PlayerLevelReward,reward[index+1].id,param,function(id)
                CommonHelper:ShowPartInfoByCfgId(id,UIModuleID.PlayerLevelReward,false)
            end,reward[index+1].id)
        end
    end)
end
function PlayerLevelRewardView:SetBtnState()
   local levelAward=PlayerDataManager:Get():GetLevelAward()
    local flag=self.Level<=PlayerDataManager:Get():GetPlayerLV()
    if flag then
        for k, v in pairs(levelAward) do
            if v==self.Level then
                flag=false
                break
            end
        end
    end
   CommonHelper:SetHButtonClick(self.BtnGet,flag,true)
   CommonHelper:SetHButtonClick(self.BtnGeted,not flag,true)
   CommonHelper:SetText("###curlevel",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.CurPlayerLevel,self.Level))
    if not flag  then
        if self.Level>PlayerDataManager:Get():GetPlayerLV() then
            CommonHelper:SetText("###text",self.BtnGeted.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelTaskState1))
        else
            CommonHelper:SetText("###text",self.BtnGeted.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.EmailHasGot))
        end
    end
end




