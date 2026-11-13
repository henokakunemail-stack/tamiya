---@class RaceRankNewView : ViewBase
RaceRankNewView = class("RaceRankNewView", ViewBase)
function RaceRankNewView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRankNewViewAction")

end
function RaceRankNewView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView()
    end)
    CommonHelper:HButtonSetCallback("BtnGarage", self.gameObject, function(data)
        SkipModuleHelper:Get():ToGarage(UIModuleID.RaceRank)
    end)
    self.ToggleSelect= CommonHelper:HButtonSetCallback("ToggleSelect",self.gameObject,function (hbtn)
        local value= PlayerPrefsHelper:GetValue_RaceRankSelectPosition()
        PlayerPrefsHelper:SetValue_RaceRankSelectPosition(value==1 and 0 or 1)
        CommonHelper:SetToggleState(self.ToggleSelect, PlayerPrefsHelper:GetValue_RaceRankSelectPosition()==1)
    end)
    CommonHelper:HButtonSetCallback("BtnEnter", self.gameObject, function(hbtn)
        local flag,carId,carids=self:GetBattleCarId()
        if not flag then
            return
        end
        self:OnBtnEnterClick(self.TrackData.RaceType,carId,carids)
    end)
    self.Pre_SelectCar = UIUtil.GetChild("Page_SelectCar", self.gameObject)
    self.ObjCarIdx = UIUtil.GetChild("CaridxGroup", self.gameObject)
    self.CarAttrRecommend = UIUtil.GetChild("carAttrRecommend", self.gameObject)
    self.items = {}
    for i = 1, 4 do
        self.items[i] = UIUtil.GetChild("SelfItem" .. i.."/ItemPart_118", self.gameObject)
    end
    self.PartsItem = { 4, 1, 2, 3 }
end
function RaceRankNewView:OnOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRaceRankSelectCar(port)
    cs_coroutine.start(function()
        coroutine.yield()
        coroutine.yield()
        self:CheckNewBieGuide()
    end)

end
function RaceRankNewView:ReOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRaceRankSelectCar(port)
    if self.RaceStyleType~=RaceStyleType.Relay then
        self:SetCarOne(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex())
    else
        self:SetCarFive(self:GetCurTrackCar(),false)
        self:SelectFiveReOpen()
    end
end

function RaceRankNewView:OnClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
end
function RaceRankNewView:OnAutoClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
end

function RaceRankNewView:OnBtnEnterClick(type,carId,carids)
    local sendcar=carId
    if self.RaceStyleType==RaceStyleType.Relay then
        sendcar=carids
    end
    if RaceRankManager:Get():GetSelectPositionNum()>=RaceRankManager:Get():GetSelectPositionMaxNum() or CommonHelper:CheckPlayerIsNewGuide() or PlayerPrefsHelper:GetValue_RaceRankSelectPosition()==1 then
        RaceRankSubsystem:Get():SendMsg_Match(sendcar,0, type,0,self.TrackData.TrackData:GetId())
    else
        local articleType= stringSplitToNumber(CommonHelper:GetDictCalcData(CommonCfgKey.RaceRankSelectPositionCost,true),':')
        CommonHelper:TrackSelectDepartPosition(self.TrackData:GetRaceNumber(),function(position)
            if position~=0 then
                local boxFunc = function()
                    local tips=CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankSelectPositionTips,CommonHelper:GetPartOrArticleName(articleType[1]),articleType[2],position)
                    local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotEnter_Tittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true,nil,nil,nil,nil,CanvasType.FrontCanvas)
                    if ret == MessageBoxHelp.BtnType.OK then
                        cs_coroutine.start(function()
                            RaceRankSubsystem:Get():SendMsg_Match(sendcar,0, type,position,self.TrackData.TrackData:GetId())
                        end)
                    end
                end
                MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
            else
                RaceRankSubsystem:Get():SendMsg_Match(sendcar,0, type,0,self.TrackData.TrackData:GetId())
            end
        end,TrackPositionViewType.CostAndCount,{{RaceRankManager:Get():GetSelectPositionNum(),RaceRankManager:Get():GetSelectPositionMaxNum()},articleType})
    end
end
function RaceRankNewView:SetData(data)
    ---@type RaceRankMoreTrackTrackData
   self.TrackData=data
    self.RaceStyleType=self.TrackData.RaceStyleType
    self:SetCar(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex(),true)
    CommonHelper:SetToggleState(self.ToggleSelect, PlayerPrefsHelper:GetValue_RaceRankSelectPosition()==1)
    self:SetRankListView()
end
function RaceRankNewView:SetRankListView()
    local players = RaceRankManager:Get():GetFastRank(self.TrackData.TrackData:GetId())
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_Rank", self.gameObject, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView,4,1,function(index, itemObj,scroll)
        local data=nil
        if players then
            data=players[index+1]
        end
        if index==3 then
            CommonHelper:SetGameObjectActive("coustom_rank_none",itemObj,false)
            CommonHelper:SetGameObjectActive("playergroup",itemObj,false)
        else
            local coustom_rank_none= CommonHelper:SetGameObjectActive("coustom_rank_none",itemObj,data==nil)
            local playergroup= CommonHelper:SetGameObjectActive("playergroup",itemObj,data~=nil)
            if data==nil then
                CommonHelper:SetPlayerIconById("PlayerIcon",coustom_rank_none,99999,99999,nil,UIModuleID.RaceRank)
            else
                self:SetItem(playergroup,data,index)
            end
        end
    end)
    self:SetItem(self:GetChild("self"),RaceRankManager:Get():GetSelfRank(self.TrackData.TrackData:GetId()),-1)
end

---@param data RaceRankMoreTrackRankData
function RaceRankNewView:SetItem(parent,data,dataIndex)
    if data.Rank then
        CommonHelper:SetGameObjectActive("first",parent,data.Rank==1)
        CommonHelper:SetGameObjectActive("second",parent,data.Rank==2)
        CommonHelper:SetGameObjectActive("third",parent,data.Rank==3)
    end

    if data.Time>0 then
        CommonHelper:GetComponentTransferTime("###bestrecord",parent,data.Time)
    elseif data.Time<0 then
        local result=CommonHelper:TransferTime(math.abs(data.Time), 0.001)
        CommonHelper:SetText("###bestrecord", parent,"-".. CommonHelper:TransferTimeToString(result))
    else
        CommonHelper:SetText("###bestrecord",parent,"--:--:--")
    end

    CommonHelper:SetPlayerIconById("PlayerIcon",parent,data.HeadIcon,data.IconFrame,nil,UIModuleID.RaceRank)
    CommonHelper:SetText("###playerName",parent,data.Name)
    if data.Score then
        ---@type qualifyingrank_config_cell
        local curcfg, minscore, maxscore = CommonHelper:GetRankCfgByScore(data.Score)
        CommonHelper:SetRankIconGroup("rankicon_s_5", parent, curcfg)
    end
end





function RaceRankNewView:GetBattleCarId()
    if self.RaceStyleType==RaceStyleType.Relay then
        local flag=true
        local result=""
        for i = 1,3 do
            if self.Cars[i].CarIdx>0 then
                if CarDataManager:Get():CheckCarCompleteness(self.Cars[i].CarIdx) then
                else
                    flag=false
                    break
                end
            else
                if CarDataManager:Get():GetCarNum()<3 then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarPleaseOpenCar))
                    return
                end
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChapterMoreCarNoCar))
                return
            end
        end
        if flag then
            for i = 1, 3 do
                if i>=3 then
                    result=result..self.Cars[i].CarIdx
                else
                    result=result..self.Cars[i].CarIdx..":"
                end
            end
        end
        return flag,0,result
    else
        return CarDataManager:Get():CheckCarCompleteness(self.Page_SelectCar:GetCurCar():GetID()),self.Page_SelectCar:GetCurCar():GetID(),nil
    end
end


function RaceRankNewView:SetCar(carId,flag)
    CommonHelper:SetGameObjectActive("page_more",self.gameObject,self.RaceStyleType==RaceStyleType.Relay)
    CommonHelper:SetGameObjectActive("Page_SelectCar",self.gameObject,self.RaceStyleType~=RaceStyleType.Relay)
    self.Page_SelectCar_Five=CommonHelper:SetGameObjectActive("Page_SelectCar_Five2",self.gameObject,self.RaceStyleType==RaceStyleType.Relay)
    self:SetCarOne(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex())
    self:SetCarFive(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex(),true)
end
function RaceRankNewView:SetCarOne(caridx)
    if  self.RaceStyleType~=RaceStyleType.Relay then
        if self.PreCarIdx==nil then
            self.PreCarIdx=PreGarageCarIdx()
            self:SetPreGarageCar(caridx)
        else
            self:SetPreGarageCar(caridx)
        end
    end
end
function RaceRankNewView:SetPreGarageCar()
    self.PreCarIdx:SetData(self.ObjCarIdx, UIModuleID.RaceRank, PlayerPrefsHelper:GetValue_MainMenuViewCarIndex(), true, false, function(data, isautoselect)
        self:SetCarMesh(data)
        PlayerPrefsHelper:SetValue_MainMenuViewCarIndex(data:GetCarIdx())
    end)
end
function RaceRankNewView:SetCarFive(idx,isreset)
    if self.RaceStyleType==RaceStyleType.Relay then
        if self.PreCarFive == nil then
            self.PreCarFive = Page_SelectCar_Five2()
        end
        if isreset then
            self:SetMore(self.gameObject)
        end
        self.PreCarFive:SetData(self.Page_SelectCar_Five,UIModuleID.RaceRank, idx, false,function(idx, isautoselect)
            self:SetCarMesh(CarDataManager:Get():GetCarDataByIndex(idx))
            self:SetCurCarState(idx,self.PreCarFive:GetState(idx))
        end)
    end
end
function RaceRankNewView:SetCarMesh(data)
    self:SetPageSelectCar(data)
end
---@param data CarData
function RaceRankNewView:SetPageSelectCar(data)
    if self.Page_SelectCar == nil then
        self.Page_SelectCar = Page_SelectCar()
    end
    if self.Page_SelectCar then
        self.Page_SelectCar:SetData(self.Pre_SelectCar, UIModuleID.RaceRank, data:GetCarIdx(), false, SceneChangeID.RaceRankSelectCar, false)
        self:SetCarGroup(data)
        self:SetCarAttrRecommend(data:GetCarIdx())
    end
end
function RaceRankNewView:SetCarAttrRecommend(idx)
    local partIdx={PartGrooveID.Motor,PartGrooveID.Gears}
    ---@type CarData
    local carData = CarDataManager:Get():GetCarDataByIndex(idx)
    for i = 1, 2 do
        local item=UIUtil.GetChild("Item"..i,self.CarAttrRecommend)
        if carData.assembleMgr:GetNodeByGrooveID(partIdx[i]) and carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).PartId~=0 then
            ---@type parts_config_cell
            local parts=CommonHelper:GetTableDataByID(ConfigNames.parts_config,carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).PartId)
            if parts then
                local articleCell=carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).ArticleCell
                local param = Param_ItemPartParam()
                param.quality = articleCell:GetPartQuality()
                param.star = articleCell:GetStar()
                param.lv = articleCell:GetPartLV()
                param.using = articleCell:GetCarId()
                param.lock = articleCell:GetPartLock()
                param.awaken=articleCell:GetAwaken()
                param.generation=articleCell:GetGeneration()
                param.downType=articleCell:GetPartDownType()
                param.source = articleCell:GetPartSource()
                param.expireTime = articleCell:GetPartExpTime()
                CommonHelper:SetItemPartGroup(item,UIModuleID.SelectTeam,parts.C_ID,ItemPartUIType.Simple,param,function(id)
                    CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.SelectTeam)
                end,parts.C_ID)
            end
        end
        CommonHelper:SetGameObjectActive("ItemPart_118", item,carData.assembleMgr:GetNodeByGrooveID(partIdx[i])~=nil and carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).PartId~=0)
    end

    local data= CarAttrRecommendManager:Get():GetDataByTrackId_MotorId_GearId(self.TrackId,carData.assembleMgr:GetNodeByGrooveID(partIdx[1]).PartId,carData.assembleMgr:GetNodeByGrooveID(partIdx[2]).PartId)
    for i = 1, 3 do
        CommonHelper:SetGameObjectActive("attr"..i,self.CarAttrRecommend,data~=nil)
    end
    CommonHelper:HButtonSetCallback("BtnCarAttrRecommend",self.CarAttrRecommend,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.CarAttrRecommend)
    end)
    if data~=nil then
        local selfStabilize=CommonHelper:FloatRound( carData:GetAttrValueById(CarAttrType.Stabilize).value/1000,100)
        local selfCushion= CommonHelper:FloatRound(carData:GetAttrValueById(CarAttrType.Cushion).value/1000,100)
        local selfDownforce=  CommonHelper:FloatRound(carData:GetAttrValueById(CarAttrType.Downforce).value/1000,100)
        CommonHelper:SetText("attr1/value",self.CarAttrRecommend,selfStabilize>=data.stabilizeMin and data.stabilizeMin or CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,data.stabilizeMin))
        --CommonHelper:SetText("attr1/comparevalue",self.CarAttrRecommend,CommonHelper:GetAttrCompareString(data.stabilizeMin,selfStabilize))
        CommonHelper:SetText("attr2/value",self.CarAttrRecommend,selfCushion>=data.cushionMin and data.cushionMin or CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,data.cushionMin))
        -- CommonHelper:SetText("attr2/comparevalue",self.CarAttrRecommend,CommonHelper:GetAttrCompareString(data.cushionMin,selfCushion))
        CommonHelper:SetText("attr3/value",self.CarAttrRecommend,selfDownforce>=data.downforceMin and data.downforceMin or CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,data.downforceMin))
        --CommonHelper:SetText("attr3/comparevalue",self.CarAttrRecommend,CommonHelper:GetAttrCompareString(data.downforceMin,selfDownforce))
    end
    CommonHelper:SetGameObjectActive("nocarinfo",self.CarAttrRecommend,data==nil)
end

---@param cardata CarData
function RaceRankNewView:SetCarGroup(cardata)
    local partsList = cardata:GetPartDataList()
    --for i = 1, 4 do
    --    ---@type dictparts_config_cell
    --    local parts = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partsList[self.PartsItem[i]].PartCfgID)
    --    if parts then
    --        CommonHelper:SetItemPartGroup(self.items[i], UIModuleID.RaceRank, parts.C_ID)
    --    end
    --end
    ---@type dictparts_config_cell
    CommonHelper:SetText("###shellname",self.gameObject,string.format(CommonHelper:GetColorShellStringByQuality(CommonHelper:GetPartBaseCfg(cardata:GetShellPartCfg().C_ID).fabric),CommonHelper:GetTempStr_Default(cardata:GetShellPartCfg().partname)))
end
--}}}
