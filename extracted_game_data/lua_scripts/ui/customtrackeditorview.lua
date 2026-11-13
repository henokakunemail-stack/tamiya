---@class CustomTrackEditorView : ViewBase
CustomTrackEditorView = class("CustomTrackEditorView", ViewBase)

local _Top = nil
local _Center = nil
local _Bottom = nil
local _AngleView = false --false 自由  true 顶视
local _ModeofOperation = false --false 添加 true 替换
local _SelectShowType = TrackSegmentType.Straightaway
local _CustomTrackCameraCtrl = nil
local _IsSave = true
local _miniTrackSystem = true
local _LastViewMode=-1
---@type CustomTrack_Data
local _CustomTrackData=nil
local MiniTrackData=nil
local _Count=nil
local ShowError =false
local IsCheckNum =false
function CustomTrackEditorView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "CustomTrackEditorViewAction")
  end

function CustomTrackEditorView:Awake()
    _Top = self:GetChild("Top")
    _Center = self:GetChild("Center")
    _Bottom = self:GetChild("TogView")
    self.NormalGroup = self:GetChildWightByParent("NormalGroup", _Center, typeof(CanvasGroup))
    self.MoveGroup = self:GetChildWightByParent("MoveGroup", _Center, typeof(CanvasGroup))
    self.treakNameInput = self:GetChildWightByParent("treakNameInput", _Center, typeof(InputField))
    self.TweenGroup = self:GetChildWightByParent("tweengroup", _Center, typeof(FXUITweenMoreGroup))
    CommonHelper:InputFieldSetCharacterValue(self.treakNameInput,9)
    self.PositionHit = self:GetChildByParent("PostionHit", _Center)
    CommonHelper:HButtonSetCallback("BtnHelp", _Top, function(data)

    end)

    self.AngleOfViewBtn = CommonHelper:HButtonSetCallback("AngleOfViewBtn", _Center, function(data)
        _AngleView = not _AngleView
        self:SetTogView()
        CommonHelper:TMG_PlayAllTween(self.TweenGroup)
    end)

    self.Shop=CommonHelper:HButtonSetCallback("Shop", _Center, function(data)
       -- CommonTipsHelper:Get():ShowCenterTips("功能未开启")
        if SegmentDataManager:Get().TrackNumbers == TrackSegmentNumbers.Three then
            FunctionSkipManager:Get():SkipToFunction(GameFunction.Shop,ShopID.ThreeSegment)
        end
        if SegmentDataManager:Get().TrackNumbers == TrackSegmentNumbers.Five then
            FunctionSkipManager:Get():SkipToFunction(GameFunction.Shop,ShopID.FiveSegment)
        end
    end)
    self.Create=CommonHelper:HButtonSetCallback("Create", _Center, function(data)
        CommonHelper:SetUnlockFunc({ GameFunction.LabIron }, function()
            LabSubsystem:Get():SendMsg_TrackScience()

        end)
    end)
    CommonHelper:HButtonSetCallback("MoveAll", _Center, function(data)
        if not _AngleView then
            _CustomTrackCameraCtrl:SwitchTopView()
        end
        self:UpdateModeGroup(2)
        CommonHelper:TMG_PlayAllTween(self.TweenGroup)
    end)
    self.ModeOfOperationBtn = CommonHelper:HButtonSetCallback("ModeOfOperationBtn", _Center, function(data)
        _ModeofOperation = not _ModeofOperation
        self:SetTogMode()
    end)
    CommonHelper:HButtonSetCallback("SaveBtn", _Center, function(data)
        self:SaveBtnOnClick()
    end)
    CommonHelper:HButtonSetCallback("DelBtn", _Center, function(data)
        _IsSave = false
        SelfDefineTrack:DeleteMiniSegment()
        self:UpdateScrollView()
    end)
    CommonHelper:HButtonSetCallback("BackBtn", _Center, function(data)
        _IsSave = false
        SelfDefineTrack:UndoMiniSegment()
        self:UpdateScrollView()
    end)
    self.RotateBtn=CommonHelper:HButtonSetCallback("RotateBtn", _Center, function(data)
        if not _AngleView then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackEditTopNotRotate))
            return
        end
        _IsSave = false
        SelfDefineTrack:RotateTrack()

    end)
    CommonHelper:HButtonSetCallback("DelAllBtn", _Center, function(data)
        _IsSave = false
        SelfDefineTrack:ClearUntilStartSegment()
        self:UpdateScrollView()
    end)
    CommonHelper:HButtonSetCallback("MoveAllBtn2", _Center, function(data)
        _IsSave = false
        self:UpdateModeGroup(1)
        CommonHelper:TMG_PlayAllTween(self.TweenGroup)
        if not _AngleView then
            self:SetTogView()
        end

    end)
    CommonHelper:HButtonSetCallback("BackBtn2", _Center, function(data)
        _IsSave = false
        SelfDefineTrack:UndoMiniSegment()
        self:UpdateScrollView()
        --SelfDefineTrack:RedoMiniSegment()
    end)
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(data)
        print("")

        if not _IsSave then
            local boxfunc = function()
                local text = CommonHelper:GetTempStr_Default(TemplateStringID.CustomTackEditSaveHit)
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, text,  CommonHelper:GetTempStr_Default(TemplateStringID.CustomTackEditSaveHitTittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
                if ret == MessageBoxHelp.BtnType.OK then
                    self:SaveBtnOnClick()
                else
                    ShowError=false
                    CommonHelper:ExitCustomTrack(_miniTrackSystem)
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
        else
            ShowError=false
           CommonHelper:ExitCustomTrack(_miniTrackSystem)
        end
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(data)
        CommonHelper:ShowHelpView(PageDetailType.CustomTrack)
    end)
    self.trackView = self:GetChildWightByParent("ScrollHorizontalOneRow", _Bottom, typeof(MoreRowScrollView))
    self.MoreRowScrollView_Type = self:GetChildWightByParent("MoreRowScrollView_Type", _Bottom, typeof(MoreRowScrollView))
    self.ShopView=self:GetChild("ShopView")
end
function CustomTrackEditorView:SetData(trackData,miniTrackSystem)
    _miniTrackSystem = miniTrackSystem
    _CustomTrackData=trackData
    MiniTrackData=_CustomTrackData:InitCSharp()
    _Count=_CustomTrackData.trackSgList ==nil and 1 or #_CustomTrackData.trackSgList
    CSLuaHelper:Get():CustomTrackRegister(self,self.OnError)
    ShowError=true
    if _CustomTrackCameraCtrl == nil then
        _CustomTrackCameraCtrl = CSCameraManager:Get().gameObject:GetComponent(typeof(CS.Horizon.Game.ShowLayer.SelfDefineTrackCameraCtrl))
    end
    CSLuaHelper:Get():CustomTrackRegister(self,self.OnError)
    self:SetDefault()
    CommonHelper:SetInputFieldText("treakNameInput",_Center,_CustomTrackData.name)
    _IsSave = true
end
function CustomTrackEditorView:SaveBtnOnClick()
    _IsSave = true
    SelfDefineTrack:Save()
    local isBlockTime = SelfDefineTrack:IsBlockTime()
    if not isBlockTime then
        if CommonHelper:ReviewNicknameV2(self.treakNameInput.text) then
            _CustomTrackData:SetName(self.treakNameInput.text)
            local data = _CustomTrackData:ConvertTrackInfo()

            if _miniTrackSystem == MiniTrackSystem.Self then
                CustomtrackSubsystem:Get():SendMsg_UpdateTrackData(data, 2)
                CommonHelper:SaveTrackPic(PlayerDataManager:Get():GetPlayerRID() .._CustomTrackData.id)
            elseif _miniTrackSystem == MiniTrackSystem.Club then
                ClubTrainSubsystem:Get():SendMsg_UpdateSelfTrackData(data)
                CommonHelper:SaveTrackPic(PlayerDataManager:Get():GetPlayerRID() .. UIModuleID.ClubTraining.._CustomTrackData.id)
            end
        end
    else
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CustomTrackSaveError))
    end
end
function CustomTrackEditorView:SaveTrackSuccess()
    if _miniTrackSystem == MiniTrackSystem.Self then
        _CustomTrackData:ConvertToCustomTrack_Data()
        _CustomTrackData.isEdit=true
        self:UpdateScrollView(true)
    elseif _miniTrackSystem == MiniTrackSystem.Club then

    end
end
function CustomTrackEditorView:ShopBack()
   self:ShowShopView(false)
end
function CustomTrackEditorView:SetShopData()
    if self.Page_Shop then
        self.Page_Shop:SetData()
    else
        self.Page_Shop=Page_TrackSegmentShop()
        self.Page_Shop:SetRoot(self.ShopView)
        self.Page_Shop:SetData()
    end
    self:ShowShopView(true)
end
function CustomTrackEditorView:ClickShopItem(data)
    self.Page_Shop:ClickItem(data)
end
function CustomTrackEditorView:SetPlayerMoney()
    self.Page_Shop:SetPlayerMoney()
end
function CustomTrackEditorView:SetTrackEditTypeView()
    local typeList=SegmentDataManager:Get():GetTrackTypeList()
    CommonHelper:InitMoreRowScrollView(self.MoreRowScrollView_Type, #typeList, 1, function(dataIndex, itemObj, scroll)
        local table= CommonHelper:GetTableDataByID(ConfigNames.dicttrackdifficulty_config,typeList[dataIndex+1])
        CommonHelper:SetText("normal/###text",itemObj,CommonHelper:GetTempStr_Default(table.name))
        CommonHelper:SetText("hover/###text",itemObj,CommonHelper:GetTempStr_Default(table.name))
        local  Tog=CommonHelper:HButtonSetCallback("Toggle1",itemObj,function(hbtn)
            _SelectShowType=hbtn.intData
            CommonHelper:MoreRowView_RefreshCurList(self.MoreRowScrollView_Type,false)
            self:UpdateToggleGroup()
        end,typeList[dataIndex+1])
        CommonHelper:SetToggleState(Tog,typeList[dataIndex+1]==_SelectShowType)
    end)
end

local curShowList = nil
function CustomTrackEditorView:UpdateToggleGroup(isInit)
    SegmentDataManager:Get():SetShowDataByType(_SelectShowType)
    curShowList ={}
    for k, v in pairs(SegmentDataManager:Get().curShowList) do
        table.insert(curShowList,v)
    end
    table.sort(curShowList,function(a, b)
        return a.cfg.sort < b.cfg.sort
    end)
    SegmentDataManager:Get():UpdateTrackSegmentItemData(MiniTrackData,isInit)
    CommonHelper:InitMoreRowScrollView(self.trackView, #curShowList, 3, function(dataIndex, itemObj, scroll)
        CommonHelper:HLongButtonSetCallback("BtnItem", itemObj, function(data)
            local configId = curShowList[data.intData + 1].cfgId
            local curNum = SegmentDataManager:Get():GetNumById(configId)+SegmentDataManager:Get():GetCostInitNumById(configId)
            local changer=self:CheckChangerRepeat(configId)
            _IsSave = false
            if _Count and _Count<=100 and (curNum>curShowList[data.intData + 1].needNum or curShowList[data.intData + 1].isFree)  and changer then
                if _ModeofOperation then
                    SelfDefineTrack:UpdateMiniSegment(configId)
                else
                    SelfDefineTrack:InsertOneMiniSegment(configId)
                end
            else
                if not changer then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackChangerIsOne))
                else
                    if curNum<=curShowList[data.intData + 1].needNum then
                        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackCountNoEnough))
                    else
                        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackCountNo))
                    end
                end

            end
            self:UpdateScrollView()
        end, function(data)
            local configId = curShowList[data.intData + 1].cfgId
            local curNum =SegmentDataManager:Get():GetNumById(configId)+SegmentDataManager:Get():GetCostInitNumById(configId)
            local data = CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config, configId)
            CommonHelper:ShowPartInfoByCfgId(configId, UIModuleID.CustomTrackEditor, false)
        end,dataIndex)

        if curShowList[dataIndex + 1]~=nil then
            local temp=TrackSegment_Data()
            temp.cfgId=curShowList[dataIndex + 1].cfgId
            temp.needNum=curShowList[dataIndex + 1].needNum
            temp.isFree=curShowList[dataIndex + 1].isFree
            temp.curNum=SegmentDataManager:Get():GetNumById(temp.cfgId)+SegmentDataManager:Get():GetCostInitNumById(temp.cfgId)

            self:SetItem(itemObj, temp)
        end
    end)

end




function CustomTrackEditorView:CheckChangerRepeat(cfgid)
    local count=0
    local  temp=CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config,cfgid)
    if temp.type==TrackSegmentType.ChangeTrack then
        for i = 0, MiniTrackData.configIds.Count-1 do
            local  id= MiniTrackData.configIds[i].configId
            local  temp=CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config,id)
            if temp.type==TrackSegmentType.ChangeTrack  then
                count=count+1
            end
        end
        return count<1
    end
    return true

end
---@param data TrackSegment_Data
function CustomTrackEditorView:SetItem(itemObj, data)
    local needNum = data.needNum
    local curNum = data.curNum
    local param = Param_TrackSegmentGroup()
    param.moduleId = UIModuleID.CustomTrackEditor
    param.trackSegmentId = data.cfgId
    if data.isFree then
        param.count = CommonHelper:GetTempStr_Default(TemplateStringID.CustomTackEditNum3, needNum)
    else
        if needNum>=curNum then
            param.count = CommonHelper:GetTempStr_Default(TemplateStringID.CustomTackEditNum2, needNum, curNum)
        else
            param.count = CommonHelper:GetTempStr_Default(TemplateStringID.CustomTackEditNum1, needNum, curNum)
        end
    end
    param.showcount = true
    param.showname = false
    param.isdirection = false
    CommonHelper:SetTrackSegmentGroup(itemObj, param)
end

function CustomTrackEditorView:SetDefault()
    _AngleView=false
    _ModeofOperation=false
    IsCheckNum=false
    self:SetTogView()
    self:SetTogMode()
    self:ShowShopView(false)
    _SelectShowType = 1
    self:SetTrackEditTypeView()
    self:UpdateToggleGroup(true)
    _LastViewMode=-1
    self:UpdateModeGroup(1)
end


function CustomTrackEditorView:UpdateModeGroup(mode)
    _LastViewMode=mode
    UIUtil.ShowCanvasGroup(self.NormalGroup, mode==1)
    UIUtil.ShowCanvasGroup(self.MoveGroup, mode==2)
end
function CustomTrackEditorView:SetTogView()
    CommonHelper:SetToggleState(self.AngleOfViewBtn, _AngleView)
    CommonHelper:SetText("###typename", self.AngleOfViewBtn.gameObject, _AngleView and CommonHelper:GetTempStr_Default(TemplateStringID.CustomTackEditAngleView2) or CommonHelper:GetTempStr_Default(TemplateStringID.CustomTackEditAngleView1))
    if _AngleView then
        _CustomTrackCameraCtrl:SwitchTopView()
    else
        _CustomTrackCameraCtrl:SwitchNormalView()
    end
end
function CustomTrackEditorView:SetTogMode()
    --_ModeofOperation=false
    CommonHelper:SetToggleState(self.ModeOfOperationBtn, _ModeofOperation)
    CommonHelper:SetText("###typename", self.ModeOfOperationBtn.gameObject, _ModeofOperation and CommonHelper:GetTempStr_Default(TemplateStringID.CustomTackEditMode2) or CommonHelper:GetTempStr_Default(TemplateStringID.CustomTackEditMode1))
end

function CustomTrackEditorView:UpdateScrollView(isInit)
    IsCheckNum=true
    self:UpdateItemNum(isInit)
    CommonHelper:MoreRowView_RefreshCurList(self.trackView, false)
end
function CustomTrackEditorView:UpdateItemNum(isInit)

    _Count=SegmentDataManager:Get():UpdateTrackSegmentItemData(MiniTrackData,isInit)
    for i = 1, #curShowList do
        ---@type tracksegement_config_cell
        local  temp=CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config,curShowList[i].cfgId)
        if SegmentDataManager:Get().AllTrackSgDic then
            if  SegmentDataManager:Get().AllTrackSgDic[temp.difficulty][temp.C_ID] ~=nil then
                curShowList[i].needNum=   SegmentDataManager:Get().AllTrackSgDic[temp.difficulty][temp.C_ID] .needNum
            end
        end
    end

end

function CustomTrackEditorView:OnOpen()
    HomeSceneHelper:SetTrackEdit()
    MonoHelper:TurnOnPhysics()
end

function CustomTrackEditorView:ReOpen()
    self:UpdateScrollView()
    HomeSceneHelper:SetTrackEdit()
    MonoHelper:TurnOnPhysics()
end
function CustomTrackEditorView:ShowShopView(enable)
    CommonHelper:SetHButtonClick(self.Shop,not  enable,true)
    CommonHelper:SetGameObjectActive("ShopView",self.gameObject,enable)
    CommonHelper:SetGameObjectActive("TogView",self.gameObject,not enable)
end
function CustomTrackEditorView:OnClose()
    _CustomTrackCameraCtrl = nil
    TrackBuilder:Get():RestoreCamera()
    CommonHelper:ReleasePool(UIModuleID.CustomTrackEditor)
end
function CustomTrackEditorView:OnAutoClose()
    --_CustomTrackCameraCtrl = nil
    --TrackBuilder:Get():RestoreCamera()
end

function CustomTrackEditorView:OnError(errorType)
    if ShowError then
        CommonHelper:OnTrackError(errorType)
       -- TimerManager:Get():CreateTimer(3,function()
            self:UpdateItemNum()
       -- end)
    end
end