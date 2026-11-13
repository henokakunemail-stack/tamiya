---@class MainRankingListView : ViewBase
MainRankingListView = class("MainRankingListView", ViewBase)

function MainRankingListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "MainRankingListViewAction")
end

function MainRankingListView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    self.TogRank1= CommonHelper:HButtonSetCallback("TogRank1",self.gameObject,function (hbtn)
        self:TogClick(RankingListType.MainSpeed)
    end)
    self.TogRank2=CommonHelper:HButtonSetCallback("TogRank2",self.gameObject,function (hbtn)
        self:TogClick(RankingListType.RaceClubAll)
    end)
    self.TogRank3=CommonHelper:HButtonSetCallback("TogRank3",self.gameObject,function (hbtn)
        self:TogClick(RankingListType.MainRlSpeed)
    end)
    self.NoSelf=self:GetChildByParent("NoSelf",self.gameObject)
    self.Normal=self:GetChildByParent("Normal",self.gameObject)
    self.Self=self:GetChild("self")
    self.ScrollViewbg=self:GetChild("ScrollViewbg")
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
    self.DropDownScrollView = UIUtil.GetTypeChildWightInputPath("DropDownScrollView", self.gameObject, typeof(UIDropDownScrollList))
end

function MainRankingListView:OnOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetMainRankingList(port)
    self:SetCamera()
end
function MainRankingListView:OnOpenAnimEnd()
    CommonHelper:CloseGuideScreenEffectUIMask()
    CommonHelper:PlayScreenEffectNull(false)
    CarBuilderManager:Get():RemoveBuildMask()
end
function MainRankingListView:SetCamera()
    local obj=HomeSceneHelper:GetCarRoot_MainRankListCameraRoot()
    local fxCom = UIUtil.GetGameobjectComponent(obj, typeof(CS.Horizon.Game.ShowLayer.FXFollowCamera))
    CinemachineCameraHelper:SetCineMachineCameraActive(true)
    if fxCom then
        fxCom:SetCameraRoot(obj)
    end
end


---@type SC_RetRankCar
function MainRankingListView:SetCarData(msg)
    if msg.car then
        local data=CarReviewData()
        data:SetDataByMsg(msg.car,false)
        self:SetCar(data)
    else
        self:SetCar(nil)
    end
end
---@param data CarReviewData
function MainRankingListView:SetCar(data)
    CommonHelper:SetGameObjectActive("CarInfo",self.gameObject,data~=nil)
    if data then
        HomeSceneCarMeshHelper:Get():ClearCache()
        cs_coroutine.start(function()
            coroutine.yield()
            coroutine.yield()
            HomeSceneCarMeshHelper:Get():SetDataByCarReviewData(data, SceneChangeID.MainRankingList, AnimateType.None)
        end)
        local partsList = data:GetPartList()
        self.items = {}
        for i = 1, 4 do
            self.items[i] = UIUtil.GetChild("CarInfo/ItemPart" .. i, self.gameObject)
        end
        self.PartsItem = { 4, 1, 2, 3 }
        for i = 1, 4 do

            ---@type dictparts_config_cell
            local parts = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partsList[self.PartsItem[i]].PartCfgID)
            if CommonHelper:GetPartBaseCfg(partsList[self.PartsItem[i]].PartCfgID).parttype==PartType.Shell then
                parts = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partsList[self.PartsItem[i]].PartOrgCfgID)
            end
            local param= Param_ItemPartParam()
            param.generation=partsList[self.PartsItem[i]].PartGeneration
            if parts then
                CommonHelper:SetItemPartGroup(self.items[i], UIModuleID.MainRankingList, parts.C_ID,ItemPartUIType.Simple,param,function(id)
                    CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.MainRankingList)
                end,parts.C_ID)
            end
        end
    end
end
local ShowGroup=-1
function MainRankingListView:OnClose()
    self.Page_RankListView=nil
    ShowGroup=-1
    CinemachineCameraHelper:SetCineMachineCameraActive(false)
    HomeSceneCarMeshHelper:Get():ClearCache()
    CommonHelper:ReleasePool(UIModuleID.MainRankingList)
end
function MainRankingListView:TogClick(type)
    if type==self.CurRankType then
        return
    end
    if type==RankingListType.RaceClubAll then
        RaceGVGSubsystem:Get():SendMsg_GetClubRankList()
    else
        RankingListSubsystem:Get():SendMsg_RankingListInfo(type)
    end
end
function MainRankingListView:SetData(type)
    self.CurRankType= type
    self:SetTog()
    self.RankingData=RankingListDataManager:Get():GetRankingListData()
    if RankingListDataManager:Get():GetRankCurGroup()==0 and RankingListDataManager:Get():GetRankCurShowGroup()==0  then
        RankingListSubsystem:Get():SendMsg_RankingListInfo(RankingListType.MainSpeed)
    else
        ShowGroup=RankingListDataManager:Get():GetRankCurShowGroup()
    end
    CommonHelper:SetGameObjectActive("DropDownScrollView",self.gameObject,false)
    if self.Page_RankListView==nil and (self.CurRankType==RankingListType.MainSpeed or self.CurRankType==RankingListType.MainRlSpeed) then
        self.Page_RankListView=Page_RankListScrollView()
        if  RankingListDataManager:Get():GetRankCurGroup()>100 then
            CommonHelper:InitDropDownScrollList(self.DropDownScrollView,2,function(uidrop,item,index)
                if index==0  then
                    CommonHelper:SetText("###Text",item,CommonHelper:GetTempStr_Default(string.format("rankinglistgroup_%d",index)))
                else
                    local key=string.format("rankinglistgroup_%d",RankingListDataManager:Get():GetRankCurGroup())
                    local group= CommonHelper:GetTempStr_Default(key)
                    if key==group then
                        group=CommonHelper:GetTempStr_Default("rankinglistgroup_150")
                    end
                    CommonHelper:SetText("###Text",item,group)
                end

            end,function(index)
                if index==0 and self.CurRankType~=RankingListType.MainSpeed then
                    RankingListSubsystem:Get():SendMsg_RankingListInfo(RankingListType.MainSpeed)
                end
            end,ShowGroup)
        else
            CommonHelper:InitDropDownScrollList(self.DropDownScrollView,RankingListDataManager:Get():GetAllGroup()+1,function(uidrop,item,index)
                CommonHelper:SetText("###Text",item,CommonHelper:GetTempStr_Default(string.format("rankinglistgroup_%d",index)))
            end,function(index)
                if index==0 and self.CurRankType~=RankingListType.MainSpeed then
                    RankingListSubsystem:Get():SendMsg_RankingListInfo(RankingListType.MainSpeed)
                else
                    if index~=0 and index~=ShowGroup then
                        -- RankingListSubsystem:Get():SendMsg_RankingListInfo(RankingListType.MainGroup,index)
                    end
                end
            end,ShowGroup)
        end
    else
        self.Page_RankListView=Page_RankListScrollView()
    end
    if self.CurRankType==RankingListType.RaceClubAll then
        CommonHelper:SetGameObjectActive("self",self.gameObject,false)
        CommonHelper:SetGameObjectActive("showClubInfo",self.gameObject,true)
        CommonHelper:SetGameObjectActive("showPlayer",self.gameObject,false)
        UIUtil.SetParentTransform(self.NoSelf, self.ScrollViewbg, true, true)
        HomeSceneCarMeshHelper:Get():ClearCache()
    else
        CommonHelper:SetGameObjectActive("showClubInfo",self.gameObject,false)
        CommonHelper:SetGameObjectActive("showPlayer",self.gameObject,true)
        CommonHelper:SetGameObjectActive("self",self.gameObject,true)
        UIUtil.SetParentTransform(self.Normal, self.ScrollViewbg, true, true)
    end

    self.Page_RankListView:SetData(self.ScrollView,self.Self,self.RankingData,UIModuleID.MainRankingList,function(index)
        if  self.CurRankType==RankingListType.MainSpeed  then
            if  self.ShowPlayer~=index then
                self.ShowPlayer=index
                RankingListSubsystem:Get():SendMsg_GetUserCar(self.RankingData.RankInfoList[self.ShowPlayer].Id,RaceProtectType.Normal)
                self:SetPlayerInfo()
            end
        end
        if  self.CurRankType==RankingListType.MainRlSpeed  then
            if  self.ShowPlayer~=index then
                self.ShowPlayer=index
                RankingListSubsystem:Get():SendMsg_GetUserCar(self.RankingData.RankInfoList[self.ShowPlayer].Id,RaceProtectType.Protect)
                self:SetPlayerInfo()
            end
        end
        if  self.CurRankType==RankingListType.RaceClubAll  then
            if  self.ShowPlayer~=index then
                self.ShowPlayer=index
                self:SetGuideInfo()
            end
        end
    end,nil,nil,RankingListModuleType.MainRankingListView)
    if self.CurRankType==RankingListType.MainSpeed or self.CurRankType==RankingListType.MainRlSpeed then
        CommonHelper:SetGameObjectActive("SelectPlayer",self.gameObject,#self.RankingData.RankInfoList>0)
        if #self.RankingData.RankInfoList>=1 then
            self.ShowPlayer=1
            if self.CurRankType==RankingListType.MainSpeed then
                RankingListSubsystem:Get():SendMsg_GetUserCar(self.RankingData.RankInfoList[self.ShowPlayer].Id,RaceProtectType.Normal)
            end
            if self.CurRankType==RankingListType.MainRlSpeed then
                RankingListSubsystem:Get():SendMsg_GetUserCar(self.RankingData.RankInfoList[self.ShowPlayer].Id,RaceProtectType.Protect)
            end
            self:SetPlayerInfo()
        else
            local Car = CarDataManager:Get():GetCarDataByIndex(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex())
            local data=CarReviewData()
            data:SetDataByCarData(Car)
            self:SetCar(data)
        end
    end
    if self.CurRankType==RankingListType.RaceClubAll then
        CommonHelper:SetGameObjectActive("SelectPlayer",self.gameObject,#self.RankingData.RankInfoList>0)
        if #self.RankingData.RankInfoList>=1 then
            self.ShowPlayer=1
            self:SetGuideInfo()
        end
    end
    --if self.CurRankType==RankingListType.MainGroup then
    --    CommonHelper:SetText("###curGroupName",self.gameObject,CommonHelper:GetTempStr_Default(string.format("rankinglistgroup_%d",ShowGroup)))
    --    CommonHelper:SetText("normal/###TogGroupName",self.gameObject,CommonHelper:GetTempStr_Default(string.format("rankinglistgroup_%d",ShowGroup)))
    --    CommonHelper:SetText("hover/###TogGroupName",self.gameObject,CommonHelper:GetTempStr_Default(string.format("rankinglistgroup_%d",ShowGroup)))
    --else
    -- CommonHelper:SetText("###curGroupName",self.gameObject,CommonHelper:GetTempStr_Default(string.format("rankinglistgroup_0")))
    --  CommonHelper:SetText("normal/###TogGroupName",self.gameObject,CommonHelper:GetTempStr_Default(string.format("rankinglistgroup_0")))
    --   CommonHelper:SetText("hover/###TogGroupName",self.gameObject,CommonHelper:GetTempStr_Default(string.format("rankinglistgroup_0")))
    --end
end

function MainRankingListView:SetPlayerInfo()
    local data=self.RankingData.RankInfoList[self.ShowPlayer]
    CommonHelper:SetText("showPlayer/###playerName",self.gameObject,data.Name)
    CommonHelper:SetGameObjectActive("showPlayer/first",self.gameObject,data.Rank==1)
    CommonHelper:SetGameObjectActive("showPlayer/rank0",self.gameObject,data.Rank<=0)
    CommonHelper:SetGameObjectActive("showPlayer/second",self.gameObject,data.Rank==2)
    CommonHelper:SetGameObjectActive("showPlayer/third",self.gameObject,data.Rank==3)
    local rank4_9 =CommonHelper:SetGameObjectActive("showPlayer/rank4-9",self.gameObject,data.Rank>=4 and data.Rank<=9)
    local rank10_99 = CommonHelper:SetGameObjectActive("showPlayer/rank5-99",self.gameObject,data.Rank>=10 and  data.Rank<=99)
    local rank_100=CommonHelper:SetGameObjectActive("showPlayer/rank100",self.gameObject,data.Rank>=100 and  data.Rank<=999)
    local rank_1000=CommonHelper:SetGameObjectActive("showPlayer/rank1000",self.gameObject,data.Rank>=1000 and  data.Rank<=9999)
    local rank_10000=CommonHelper:SetGameObjectActive("showPlayer/showPlayer/rank10000",self.gameObject,data.Rank>=10000 and  data.Rank<=99999)
    if data.Rank>3 then
        CommonHelper:SetText("showPlayer/rank4-9",self.gameObject,tostring(data.Rank))
        CommonHelper:SetText("showPlayer/rank5-99",self.gameObject,tostring(data.Rank))
        CommonHelper:SetText("showPlayer/rank100",self.gameObject,tostring(data.Rank))
        CommonHelper:SetText("showPlayer/rank1000",self.gameObject,tostring(data.Rank))
        CommonHelper:SetText("showPlayer/rank10000",self.gameObject,tostring(data.Rank))
    end

end
function MainRankingListView:SetGuideInfo()
    local data=self.RankingData.RankInfoList[self.ShowPlayer]
    CommonHelper:SetText("showClubInfo/###clubName",self.gameObject,data.Name)
    if CommonHelper:IsNullOrEmpty(data.Desc) then
        CommonHelper:SetText("showClubInfo/###desc",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.ClubDefaultSign))
    else
        CommonHelper:SetText("showClubInfo/###desc",self.gameObject,tostring(data.Desc))
    end

    CommonHelper:GetComponentSetUITexture("clubicon", self.gameObject, CommonHelper:GetPlayerIconById(tonumber(data.Icon), HeadIconType.ClubIcon) .. ".png", UIModuleID.MainRankingList)
end

function MainRankingListView:SetTog()
    CommonHelper:SetHButtonClick(self.TogRank2,false,true)
    CommonHelper:SetToggleState(self.TogRank1,self.CurRankType==RankingListType.MainSpeed)
    CommonHelper:SetToggleState(self.TogRank3,self.CurRankType==RankingListType.MainRlSpeed)
    CommonHelper:SetToggleState(self.TogRank2,self.CurRankType==RankingListType.RaceClubAll)
    CommonHelper:SetGameObjectActive("rank4_tittle",self.gameObject,self.CurRankType==RankingListType.MainSpeed or self.CurRankType==RankingListType.MainRlSpeed)
    CommonHelper:SetGameObjectActive("rank31_tittle",self.gameObject,self.CurRankType==RankingListType.RaceClubAll)
    CommonHelper:SetGameObjectActive("rank6_tittle",self.gameObject,false)
    CommonHelper:SetHButtonClick(self.BtnReward,self.CurRankType==RankingListType.MainSpeed,true)
end
