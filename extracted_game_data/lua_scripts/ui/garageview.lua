
local page_main = 1
local page_assemble = 2
local page_reform = 3
local page_reformselect = 4
local page_reformcost = 5
local page_star = 6
local page_strong = 7
local page_appearance = 8
local page_hole = 9
local page_color = 10
local page_sticker = 11
local page_grid = 12
local page_gridlist = 13
local page_partcolor = 14
local page_partcolorcost = 15
local page_levelup = 16
local page_reformreplace = 17
local page_verifycar = 18
local page_verifycarresult = 19
local page_inherit = 20
local page_inheritcost = 21
local page_inheritlevelup = 22
local page_inheritrecasting = 23
local page_inheritselect = 24
local page_shellchange = 25
local page_motoradjust = 26
local page_motoradjustcost = 27
local page_awake = 28
local page_advanced = 29
local page_advancedselect  = 30
local page_partsticker  = 31
local UI_Moudle=true


---@class GarageView : ViewBase
GarageView = class("GarageView", ViewBase)

function GarageView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "GarageViewAction")


    self.curpage = -1


    ---@type PageGarageCarinfo
    self.PageCarinfo = PageGarageCarinfo()

    ---@type PageGaragePartmap
    self.PagePartmap = PageGaragePartmap()

    ---@type PreGarageCarIdx
    self.PreCarIdx = PreGarageCarIdx()

    ---@type PageGaragePartinfo
    self.PagePartinfo = PageGaragePartinfo()

    ---@type PageGaragePartlist
    self.PagePartlist = PageGaragePartlist()

    ---@type PageGarageReform
    self.PageReform = PageGarageReform()

    ---@type PageGarageStar
    self.PageStar = PageGarageStar()

    ---@type PageGarageReformSelect
    self.PageReformSelect = PageGarageReformSelect()

    ---@type PageGarageReformCost
    self.PageReformCost = PageGarageReformCost()

    ---@type PageGarageReformReplace
    self.PageReformReplace = PageGarageReformReplace()

    ---@type PageGarageStrong
    self.PageStrong = PageGarageStrong()

    ---@type PageGarageLevelup
    self.PageLevelup = PageGarageLevelup()

    ---@type PageGarageAppearance
    self.PageAppearance = PageGarageAppearance()

    ---@type PageGarageHole
    self.PageHole = PageGarageHole()

    ---@type PageGarageColor
    self.PageColor = PageGarageColor()

    ---@type PageGarageSticker
    self.PageSticker = PageGarageSticker()

    ---@type PageGarageGrid
    self.PageGrid = PageGarageGrid()

    ---@type PageGarageGridList
    self.PageGridList = PageGarageGridList()

    ---@type PageGaragePartColor
    self.PagePartColor = PageGaragePartColor()
    ---@type PageGaragePartColorCost
    self.PagePartColorCost = PageGaragePartColorCost()
    ---@type PageGarageVerifyCar
    self.PageCarVerify = PageGarageVerifyCar()
    ---@type PageGarageVerifyCarResult
    self.PageCarVerifyResult = PageGarageVerifyCarResult()
    ---@type PageGarageInherit
    self.PageGarage_Inherit = PageGarageInherit()
    ---@type PageGarageInheritCost
    self.PageGarage_InheritCost = PageGarageInheritCost()
    ---@type PageGarageInheritSelect
    self.PageGarage_InheritSelect = PageGarageInheritSelect()
    ---@type PageGarageInheritLevelUp
    self.PageGarage_InheritLevelUp = PageGarageInheritLevelUp()
    ---@type PageGarageInheritRecasting
    self.PageGarage_InheritRecasting = PageGarageInheritRecasting()
    ---@type PageGarageShellChange
    self.PageGarage_ShellChange = PageGarageShellChange()
    ---@type PageGarageMotorAdjust
    self.PageGarage_MotorAdjust = PageGarageMotorAdjust()
    ---@type PageGarageMotorAdjustCost
    self.PageGarage_MotorAdjustCost = PageGarageMotorAdjustCost()
 ---@type PageGarageAwake
    self.PageGarage_Awake = PageGarageAwake()
 ---@type PageGarageAdvanced
    self.PageGarage_Advanced = PageGarageAdvanced()
 ---@type PageGarageAdvancedSelect
    self.PageGarage_AdvancedSelect = PageGarageAdvancedSelect()
 ---@type PageGaragePartSticker
    self.PageGarage_PartSticker = PageGaragePartSticker()

end

function GarageView:Awake()
    log("---   GarageView awake")

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        if self.curpage == page_main or  CommonHelper:CheckPlayerIsNewGuide() then
            UIManager:Get():CloseView()
        else
            local boxFunc = function()
                local str = CommonHelper:GetTempStr_Default(TemplateStringID.GarageBackTips)
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Orange, str)
                if ret == MessageBoxHelp.BtnType.OK then
                    UIManager:Get():CloseView()
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        end
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        local flag= self.curpage ~= page_main
        if SkipModuleHelper:GetOpenGarageType()==UIModuleID.RaceRoomDetail then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceRoomNoBack))
            return
        end
        if SkipModuleHelper:GetOpenGarageType()~=UIModuleID.MainMenu then
            flag=true
        end
       SkipModuleHelper:Get():BackToMainMenuView(flag)
    end)

    self.BtnAppearance=CommonHelper:HButtonSetCallback("BtnAppearance", self.gameObject, function(hbtn)
        self:ChangeGroupAppearance()
    end)
    CommonHelper:HButtonSetCallback("BtnRot", self.gameObject, function(hbtn)
        self:RandomRot(CommonHelper:GetInputFieldText("Input3",self.gameObject))
    end)
    self.BtnManual=CommonHelper:HButtonSetCallback("BtnManual", self.gameObject, function(hbtn)
        CommonHelper:OpenEncyclopedia(EncyclopediaPage.Parts)
    end)

    self.BtnIllustratedHandbook=CommonHelper:HButtonSetCallback("BtnIllustratedHandbook", self.gameObject, function(hbtn)
        --FunctionSkipManager:Get():SkipToFunction(GameFunction.IllustratedHandbook)
        IllustratedHandbookSubsystem:Get():SendMsg_CollectList()
    end)
    CommonHelper:HButtonSetCallback("BtnVerifyCarLocal", self.gameObject, function(hbtn)
      CommonTipsHelper:Get():ShowCenterTips(CommonHelper:VerifyCar_ForCarIdx(self.PreCarIdx:GetCurCarData():GetCarIdx()))
    end)
    self.BtnVerifyCar=CommonHelper:HButtonSetCallback("BtnVerifyCar", self.gameObject, function(hbtn)
        self:ChangeVerifyCar()
    end)
    CommonHelper:HButtonSetCallback("BtnNoUI", self.gameObject, function(hbtn)
        UI_Moudle=not UI_Moudle
        self:CloseAllUI(UI_Moudle)
    end)


    --------AR按钮----------------------------------



        self.BtnAR =  CommonHelper:HButtonSetCallback("BtnAR", self.gameObject, function(hbtn)
            if PlayerPrefsHelper:GetValue_ArUserAgreement() == 0 then
                UIManager:Get():OpenPopup("ARUserAgreementView", CanvasType.MainCanvas, "ARUserAgreementView")
            else
                HomeSceneHelper:SetARScene()
                ARManager:Get():AREnter()
                UIManager:Get():OpenView("ARMainView", CanvasType.MainCanvas, "ARMainView")
            end
        end)




    self.ObjCarinfo = UIUtil.GetChild("Page_Garage_Carinfo", self.gameObject)
    self.ObjPartmap = UIUtil.GetChild("Page_Garage_Partmap", self.gameObject)

    self.ObjPartinfo = UIUtil.GetChild("Page_Garage_Partinfo", self.gameObject)
    self.ObjPartlist = UIUtil.GetChild("Page_Garage_PartList", self.gameObject)
    self.ObjReform = UIUtil.GetChild("Page_Garage_Reform", self.gameObject)
    self.ObjStar = UIUtil.GetChild("Page_Garage_Star", self.gameObject)
    self.ObjReformSelect = UIUtil.GetChild("Page_Garage_ReformSelect", self.gameObject)
    self.ObjReformCost = UIUtil.GetChild("Page_Garage_ReformCost", self.gameObject)
    self.ObjReformReplace = UIUtil.GetChild("Page_Garage_ReformReplace", self.gameObject)
    self.ObjStrong = UIUtil.GetChild("Page_Garage_Strong", self.gameObject)
    self.ObjLevelup = UIUtil.GetChild("Page_Garage_Levelup", self.gameObject)

    self.ObjAppearance = UIUtil.GetChild("Page_Garage_Appearance", self.gameObject)
    self.ObjHole = UIUtil.GetChild("Page_Garage_Hole", self.gameObject)
    self.ObjColor = UIUtil.GetChild("Page_Garage_Color", self.gameObject)
    self.ObjSticker = UIUtil.GetChild("Page_Garage_Sticker", self.gameObject)
    self.ObjGrid = UIUtil.GetChild("Page_Garage_Grid", self.gameObject)
    self.ObjPartColor = UIUtil.GetChild("Page_Garage_PartColor", self.gameObject)
    self.ObjPartColorCost = UIUtil.GetChild("Page_Garage_PartColorCost", self.gameObject)
    self.ObjGridList = UIUtil.GetChild("Page_Garage_GridList", self.gameObject)
    self.ObjVerifyCar = UIUtil.GetChild("Page_Garage_VerifyCar", self.gameObject)
    self.ObjVerifyCarResult = UIUtil.GetChild("Page_Garage_VerifyCarResult", self.gameObject)
    self.ObjPartInherit = UIUtil.GetChild("Page_Garage_Inherit", self.gameObject)
    self.ObjPartInheritCost = UIUtil.GetChild("Page_Garage_InheritCost", self.gameObject)
    self.ObjPartInheritLevelUp = UIUtil.GetChild("Page_Garage_InheritLevelUp", self.gameObject)
    self.ObjPartInheritRecasting = UIUtil.GetChild("Page_Garage_InheritRecasting", self.gameObject)
    self.ObjPartInheritSelect = UIUtil.GetChild("Page_Garage_InheritSelect", self.gameObject)
    self.ObjPartShellChange = UIUtil.GetChild("Page_Garage_ShellChange", self.gameObject)
    self.ObjPartMotorAdjust = UIUtil.GetChild("Page_Garage_MotorAdjust", self.gameObject)
    self.ObjPartMotorAdjustCost = UIUtil.GetChild("Page_Garage_MotorAdjustCost", self.gameObject)
    self.ObjPartAwake = UIUtil.GetChild("Page_Garage_Awake", self.gameObject)
    self.ObjPartAdvanced = UIUtil.GetChild("Page_Garage_Advanced", self.gameObject)
    self.ObjPartSticker = UIUtil.GetChild("Page_Garage_PartSticker", self.gameObject)
    self.ObjPartAdvancedSelect = UIUtil.GetChild("Page_Garage_AdvancedSelect", self.gameObject)

    self.ObjCarIdx = UIUtil.GetChild("CaridxGroup", self.gameObject)
    self.CanvasGroup1= self:GetChildWight("page_carinfo/TweenTemp_Left/tween", typeof(CanvasGroup))
    self.CanvasGroup2= self:GetChildWight("page_partmap/TweenTemp_Right/tween", typeof(CanvasGroup))
    self.CanvasGroup3= self:GetChildWight("page_carinfo/TweenTemp_Left/tween/Page_Garage_Carinfo/groupinfo/tween", typeof(CanvasGroup))
end
function  GarageView:RandomRot(angle)
    HomeSceneHelper:SetMeshCtrl_Rot(tonumber(angle))
end
function GarageView:SetBtn()
    CommonHelper:SetGameObjectActive("BtnVerifyCarLocal", self.gameObject,not GameProperties.AssetBundleMode)
    CommonHelper:SetHButtonClick(self.BtnAR, not GuideManager:Get():CheckGuideIsGuideStartId2(),false)
    CommonHelper:SetHButtonClick(self.BtnAppearance,not GuideManager:Get():CheckGuideIsGuideStartId2(),false)
    CommonHelper:SetHButtonClick(self.BtnManual,not GuideManager:Get():CheckGuideIsGuideStartId2(),false)
    CommonHelper:SetHButtonClick(self.BtnVerifyCar,not GuideManager:Get():CheckGuideIsGuideStartId2(),false)
    CommonHelper:SetHButtonClick(self.BtnIllustratedHandbook,not GuideManager:Get():CheckGuideIsGuideStartId2(),false)
end
function GarageView:OnOpen()
    self:SetBtn()
    self:ViewFixScreen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit",self.gameObject)
    if GarageSceneValue==SceneChangeID.Garage then
        HomeSceneHelper:SetGarage(port)
    end
    if GarageSceneValue==SceneChangeID.Garage_New then
        HomeSceneHelper:SetGarage_New(port)
    end



    --CommonHelper:TweenGroupSetStateClose("page_carinfo/TweenTemp_Left/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_partinfo/TweenTemp_Left/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_caridx/TweenTemp_GarageButtom/tween", self.gameObject)
    --
    --CommonHelper:TweenGroupSetStateClose("page_partmap/TweenTemp_Right/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_partlist/TweenTemp_Right/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_reform/TweenTemp_Right/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_star/TweenTemp_Right/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_reformselect/TweenTemp_Right2/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_reformcost/TweenTemp_Right2/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_reformreplace/TweenTemp_Right2/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_strong/TweenTemp_Right2/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_levelup/TweenTemp_Right2/tween", self.gameObject)
    --
    --CommonHelper:TweenGroupSetStateClose("page_appearance/TweenTemp_Right2/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_hole/TweenTemp_Right2/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_color/TweenTemp_Right2/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_sticker/TweenTemp_Right2/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_grid/TweenTemp_Right2/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("page_gridlist/TweenTemp_Right2/tween", self.gameObject)
    --
    --
    --CommonHelper:TweenGroupSetStateClose("TweenTemp_Appearance/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("TweenTemp_Photo/tween", self.gameObject)
    --CommonHelper:TweenGroupSetStateClose("TweenTemp_Try/tween", self.gameObject)


    cs_coroutine.start(function()
        coroutine.yield()
        self:ChangeGroupMain()
    end)

    self:SetCarIdxGroup()
    self:RefreshGarageRedPoint()
    UI_Moudle=true
    self:CloseAllUI(UI_Moudle)
end


function GarageView:ReOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit",self.gameObject)
    if GarageSceneValue==SceneChangeID.Garage then
        HomeSceneHelper:SetGarage(port)
    end
    if GarageSceneValue==SceneChangeID.Garage_New then
        HomeSceneHelper:SetGarage_New(port)
    end

    cs_coroutine.start(function()
        coroutine.yield()
        log("---   ^^^   333")
        self:ChangeGroupMain()
        log("---   ^^^   444")
    end)
    log("---   ^^^   222")

    self:SetCarIdxGroup()
    self:RefreshGarageRedPoint()
end

function GarageView:OnAutoClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
    CameraStackHelper:GarageCameraClose()
    UI_Moudle=true
    self:CloseAllUI(UI_Moudle)
end

function GarageView:OnClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
    CameraStackHelper:GarageCameraClose()
    CommonHelper:ReleasePool(UIModuleID.Garage)
    UI_Moudle=true
    self:CloseAllUI(UI_Moudle)
end
function GarageView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
    --cs_coroutine.start(function()
    --    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.3))
    --    UIUtil.ShowCanvasGroup(self.CanvasGroup1,true)
    --    UIUtil.ShowCanvasGroup(self.CanvasGroup2,true)
    --    UIUtil.ShowCanvasGroup(self.CanvasGroup3,true)
    --end)
end



--{{{ 组切换
function GarageView:PlayPageAni(page,change)
    if change==false then
        self:OnChangeTweenEnd()
        return
    end
    self.curpage = page
    CommonHelper:TweenGroupUILeft("page_carinfo/TweenTemp_Left/tween", self.gameObject, page == page_main or page==page_verifycar or page == page_verifycarresult,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_partinfo/TweenTemp_Left/tween", self.gameObject, page ~= page_main and page~=page_verifycar and page~=page_verifycarresult,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_caridx/TweenTemp_GarageButtom/tween", self.gameObject, page == page_main,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_partmap/TweenTemp_Right/tween", self.gameObject, page == page_main,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_partlist/TweenTemp_Right/tween", self.gameObject, page == page_assemble,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_reform/TweenTemp_Right/tween", self.gameObject, page == page_reform,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_star/TweenTemp_Right/tween", self.gameObject, page == page_star,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_reformselect/TweenTemp_Right2/tween", self.gameObject, page == page_reformselect,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_reformcost/TweenTemp_Right2/tween", self.gameObject, page == page_reformcost,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_reformreplace/TweenTemp_Right2/tween", self.gameObject, page == page_reformreplace,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_strong/TweenTemp_Right2/tween", self.gameObject, page == page_strong,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_levelup/TweenTemp_Right2/tween", self.gameObject, page == page_levelup,function()
        self:OnChangeTweenEnd()
    end)

    CommonHelper:TweenGroupUILeft("page_appearance/TweenTemp_Right2/tween", self.gameObject, page == page_appearance,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_hole/TweenTemp_Right2/tween", self.gameObject, page == page_hole,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_color/TweenTemp_Right2/tween", self.gameObject, page == page_color,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_sticker/TweenTemp_Right2/tween", self.gameObject, page == page_sticker,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_grid/TweenTemp_Right2/tween", self.gameObject, page == page_grid,function()
        self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_gridlist/TweenTemp_Right2/tween", self.gameObject, page == page_gridlist,function()
       self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_partcolor/TweenTemp_Right2/tween", self.gameObject, page == page_partcolor,function()
       self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_partcolorcost/TweenTemp_Right2/tween", self.gameObject, page == page_partcolorcost,function()
       self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_verifycar/TweenTemp_Right2/tween", self.gameObject, page == page_verifycar,function()
       self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_verifycarresult/TweenTemp_Right2/tween", self.gameObject, page == page_verifycarresult,function()
       self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_inherit/TweenTemp_Right2/tween", self.gameObject, page == page_inherit,function()
       self:OnChangeTweenEnd()
    end)
     CommonHelper:TweenGroupUILeft("page_inheritcost/TweenTemp_Right2/tween", self.gameObject, page == page_inheritcost,function()
       self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_inheritlevelup/TweenTemp_Right2/tween", self.gameObject, page == page_inheritlevelup,function()
       self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_inheritrecasting/TweenTemp_Right2/tween", self.gameObject, page == page_inheritrecasting,function()
       self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_inheritselect/TweenTemp_Right2/tween", self.gameObject, page == page_inheritselect,function()
       self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_shellchange/TweenTemp_Right2/tween", self.gameObject, page == page_shellchange,function()
       self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_motoradjust/TweenTemp_Right2/tween", self.gameObject, page == page_motoradjust,function()
       self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_motoradjustcost/TweenTemp_Right2/tween", self.gameObject, page == page_motoradjustcost,function()
       self:OnChangeTweenEnd()
    end)
  CommonHelper:TweenGroupUILeft("page_awake/TweenTemp_Right2/tween", self.gameObject, page == page_awake,function()
       self:OnChangeTweenEnd()
    end)
  CommonHelper:TweenGroupUILeft("page_advanced/TweenTemp_Right2/tween", self.gameObject, page == page_advanced,function()
       self:OnChangeTweenEnd()
    end)
CommonHelper:TweenGroupUILeft("page_advancedselect/TweenTemp_Right2/tween", self.gameObject, page == page_advancedselect,function()
       self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("page_partsticker/TweenTemp_Right2/tween", self.gameObject, page == page_partsticker,function()
       self:OnChangeTweenEnd()
    end)
    CommonHelper:TweenGroupUILeft("TweenTemp_Appearance/tween", self.gameObject, page == page_main)
end

function GarageView:CloseAllUI(flag)
    CommonHelper:TweenGroupUILeft("Center", self.gameObject, flag)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_CloseUI,flag)
end
function GarageView:OnChangeTweenEnd()
    if true then return end
    local page=self.curpage
    cs_coroutine.start(function()
        CommonHelper:SetGameObjectActive("page_carinfo/TweenTemp_Left/tween", self.gameObject, page == page_main or page==page_verifycar or page == page_verifycarresult)
        CommonHelper:SetGameObjectActive("page_partinfo/TweenTemp_Left/tween", self.gameObject, page ~= page_main and page~=page_verifycar and page~=page_verifycarresult)
        CommonHelper:SetGameObjectActive("page_caridx/TweenTemp_GarageButtom/tween", self.gameObject, page == page_main)
        CommonHelper:SetGameObjectActive("page_partmap/TweenTemp_Right/tween", self.gameObject, page == page_main)
        CommonHelper:SetGameObjectActive("page_partlist/TweenTemp_Right/tween", self.gameObject, page == page_assemble)
        CommonHelper:SetGameObjectActive("page_reform/TweenTemp_Right/tween", self.gameObject, page == page_reform)
        CommonHelper:SetGameObjectActive("page_star/TweenTemp_Right/tween", self.gameObject, page == page_star)
        CommonHelper:SetGameObjectActive("page_reformselect/TweenTemp_Right2/tween", self.gameObject, page == page_reformselect)
        CommonHelper:SetGameObjectActive("page_reformcost/TweenTemp_Right2/tween", self.gameObject, page == page_reformcost)
        CommonHelper:SetGameObjectActive("page_reformreplace/TweenTemp_Right2/tween", self.gameObject, page == page_reformreplace)
        CommonHelper:SetGameObjectActive("page_strong/TweenTemp_Right2/tween", self.gameObject, page == page_strong)
        CommonHelper:SetGameObjectActive("page_levelup/TweenTemp_Right2/tween", self.gameObject, page == page_levelup)
        CommonHelper:SetGameObjectActive("page_appearance/TweenTemp_Right2/tween", self.gameObject, page == page_appearance)
        CommonHelper:SetGameObjectActive("page_hole/TweenTemp_Right2/tween", self.gameObject, page == page_hole)
        CommonHelper:SetGameObjectActive("page_color/TweenTemp_Right2/tween", self.gameObject, page == page_color)
        CommonHelper:SetGameObjectActive("page_sticker/TweenTemp_Right2/tween", self.gameObject, page == page_sticker)
        CommonHelper:SetGameObjectActive("page_grid/TweenTemp_Right2/tween", self.gameObject, page == page_grid)
        CommonHelper:SetGameObjectActive("page_gridlist/TweenTemp_Right2/tween", self.gameObject, page == page_gridlist)
        CommonHelper:SetGameObjectActive("page_partcolor/TweenTemp_Right2/tween", self.gameObject, page == page_partcolor)
        CommonHelper:SetGameObjectActive("page_partcolorcost/TweenTemp_Right2/tween", self.gameObject, page == page_partcolorcost)
        CommonHelper:SetGameObjectActive("page_verifycar/TweenTemp_Right2/tween", self.gameObject, page == page_verifycar)
        CommonHelper:SetGameObjectActive("page_verifycarresult/TweenTemp_Right2/tween", self.gameObject, page == page_verifycarresult)
        CommonHelper:SetGameObjectActive("page_inherit/TweenTemp_Right2/tween", self.gameObject, page == page_inherit)
        CommonHelper:SetGameObjectActive("page_inheritcost/TweenTemp_Right2/tween", self.gameObject, page == page_inheritcost)
        CommonHelper:SetGameObjectActive("page_inheritlevelup/TweenTemp_Right2/tween", self.gameObject, page == page_inheritlevelup)
        CommonHelper:SetGameObjectActive("page_inheritrecasting/TweenTemp_Right2/tween", self.gameObject, page == page_inheritrecasting)
        CommonHelper:SetGameObjectActive("page_inheritselect/TweenTemp_Right2/tween", self.gameObject, page == page_inheritselect)
        CommonHelper:SetGameObjectActive("page_shellchange/TweenTemp_Right2/tween", self.gameObject, page == page_shellchange)
        CommonHelper:SetGameObjectActive("page_motoradjust/TweenTemp_Right2/tween", self.gameObject, page == page_motoradjust)
        CommonHelper:SetGameObjectActive("page_motoradjustcost/TweenTemp_Right2/tween", self.gameObject, page == page_motoradjustcost)
        CommonHelper:SetGameObjectActive("page_awake/TweenTemp_Right2/tween", self.gameObject, page == page_awake)
        CommonHelper:SetGameObjectActive("page_advanced/TweenTemp_Right2/tween", self.gameObject, page == page_advanced)
        CommonHelper:SetGameObjectActive("page_advancedselect/TweenTemp_Right2/tween", self.gameObject, page == page_advancedselect)
        CommonHelper:SetGameObjectActive("page_partsticker/TweenTemp_Right2/tween", self.gameObject, page == page_partsticker)
        CommonHelper:SetGameObjectActive("TweenTemp_Appearance/tween", self.gameObject, page == page_main)
    end)

end
function GarageView:ChangeGroupMain(isresetPos)
    self:PlayPageAni(page_main)
    CameraStackHelper:GarageCameraSwitch(GarageCameraId.Default)
end
function GarageView:ChangeGroupAssemble(node, templist)
    self:PlayPageAni(page_assemble)
    self:SetPartlist(node, templist)
end
function GarageView:ChangeGroupReform(article)
    self:PlayPageAni(page_reform)
    self:SetReform(article)
end
function GarageView:ChangeGroupStar(article)
    self:PlayPageAni(page_star)
    self:SetStar(article)
end
function GarageView:ChangeGroupReformSelect(article,pos)
    self:PlayPageAni(page_reformselect)
    self:SetReformSelect(article,pos)
end
function GarageView:ChangeGroupReformCost(article,pos,reformid)
    self:PlayPageAni(page_reformcost)
    self:SetReformCost(article,pos,reformid)
end
function GarageView:ChangeGroupReformReplace(article,pos,reformid)
    self:PlayPageAni(page_reformreplace)
    self:SetReformReplace(article,pos,reformid)
end
function GarageView:ChangeGroupStrong(data, idx)
    self:PlayPageAni(page_strong)
    self:SetStrong(data, idx)
end
function GarageView:ChangeGroupLevelup(data)
    self:PlayPageAni(page_levelup)
    self:SetLevelup(data)
end
function GarageView:ChangePartColor(data,node)
    self:PlayPageAni(page_partcolor)
    self:SetPartColor(data,node)
end
function GarageView:ChangePartColorCost(article,cfgid)
    self:PlayPageAni(page_partcolorcost)
    self:SetPartColor(article,cfgid)
end

function GarageView:ChangeGroupAppearance()
    self:PlayPageAni(page_appearance)
    self:SetAppearance()
end
function GarageView:ChangeGroupHole()
    self:PlayPageAni(page_hole)
    self:SetHole()
end
function GarageView:ChangeGroupColor()
    self:PlayPageAni(page_color)
    self:SetColor()
end
function GarageView:ChangeGroupSticker()
    self:PlayPageAni(page_sticker)
    self:SetSticker()
end
function GarageView:ChangeGroupGrid()
    self:PlayPageAni(page_grid)
    self:SetGrid()
end
function GarageView:ChangeGroupGridList(holeidx)
    self:PlayPageAni(page_gridlist)
    self:SetGridList(holeidx)
end
function GarageView:ChangeVerifyCar()
    self:PlayPageAni(page_verifycar)
    self:SetCarVerify(self.PreCarIdx:GetCurCarData():GetCarIdx())
end
function GarageView:ChangeInherit(article)
    self:PlayPageAni(page_inherit)
    self:SetPartInherit(article)
end
function GarageView:ChangeShellChange(article,node)
    self:PlayPageAni(page_shellchange)
    self:SetPartShellChange(article,node)
end
function GarageView:ChangeMotorAdjust(article)
    self:PlayPageAni(page_motoradjust)
    self:SetMotorAdjust(article)
end
function GarageView:ChangeMotorAdjustCost(article)
    self:PlayPageAni(page_motoradjustcost)
    self:SetMotorAdjustCost(article)
end
function GarageView:ChangeAwake(article)
    self:PlayPageAni(page_awake)
    self:SetPartAwake(article)
end
function GarageView:ChangeAdvanced(article,cost)
    self:PlayPageAni(page_advanced)
    self:SetPartAdvanced(article,cost)
end
function GarageView:ChangePartSticker(article,node)
    self:PlayPageAni(page_partsticker)
    self:SetPartPartSticker(article,node)
end

function GarageView:ChangeAdvancedSelect(article,cost)
    self:PlayPageAni(page_advancedselect)
    self:SetPartAdvancedSelect(article,cost)
end


function GarageView:ChangeInheritCost(article,index,inheritId,optionType)
    self:PlayPageAni(page_inheritcost)
    self:SetPartInheritCost(article,index,inheritId,optionType)
end
function GarageView:ChangeInheritSelect(article,index,defaultID,optionType)
    self:PlayPageAni(page_inheritselect)
    self:SetPartInheritSelect(article,index,defaultID,optionType)
end
function GarageView:ChangeInheritLevelUp(article)
    self:PlayPageAni(page_inheritlevelup)
    self:SetPartInheritLevelUp(article)
end
function GarageView:ChangeInheritRecasting(article,index)
    self:PlayPageAni(page_inheritrecasting)
    self:SetPartInheritRecasting(article,index)
end

function GarageView:ChangeVerifyCarResult(attr,type)
    self:PlayPageAni(page_verifycarresult)
    self:SetVerifyCarResult(attr,type)
end
function GarageView:OpenVerifyCarResult(type,attr)
    if type==CarVerifyHistoryOpenType.Save then
        self:ChangeVerifyCarResult(self.PreCarIdx:GetCurCarData():GetCurVerifyAttr(),type)
    elseif type==CarVerifyHistoryOpenType.Look then
        self:ChangeVerifyCarResult(attr,type)
    end
end


--}}}


--{{{设置页面数据
function GarageView:SetCarinfo(isresetPos)
    local data = self.PreCarIdx:GetCurCarData()
    self.PageCarinfo:SetData(self.ObjCarinfo, data, isresetPos)
end

function GarageView:SetPartmap(isresetPos)

    local data = self.PreCarIdx:GetCurCarData()
    self.PagePartmap:SetData(self.ObjPartmap, data,isresetPos, function(grooveid)
        local node = data.assembleMgr:GetNodeByGrooveID(grooveid)
        local templist = AssembleHelper:GetPartsByGroove(node)
        CommonHelper:PlaySfxByGrooveId(grooveid)

        self:RotToGroove(grooveid)
        if #templist > 0 then
            self:ChangeGroupAssemble(node, templist)
        else
            CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.AssembleSiftlistNil))
        end
    end)
end
function  GarageView:RotToGroove(grooveid)
    ---@type grooveid_config_cell
    self.grooveCfg=CommonHelper:GetTableDataByID(ConfigNames.grooveid_config,grooveid)
    if self.grooveCfg then
        HomeSceneHelper:SetMeshCtrl_Rot(self.grooveCfg.rotate)
        CameraStackHelper:GarageCameraSwitch(self.grooveCfg.camera)
    end
end
---@param data ArticleCell
---@param node AssembleNode
function GarageView:SetPartinfo(data, node)
    self.PagePartinfo:SetData(self.ObjPartinfo, data, node)
end

---@param id
---@param node AssembleNode
function GarageView:SetPartinfoByCfg(data, node,cfg)
    self.PagePartinfo:SetData(self.ObjPartinfo, data, node,cfg)
end

function GarageView:SetPartlist(node, templist)
    self.PagePartlist:SetData(self.ObjPartlist, node, templist, function()
        self:ChangeGroupMain()
        self:PageUpdateMain(false)
    end, function(article)
        self:ChangeGroupReform(article)
    end, function(article)
        self:ChangeGroupStar(article)
    end, function(article)
        self:ChangeGroupLevelup(article)
    end,function(data,node)
        self:ChangePartColor(data,node)
    end,function(article)
        self:ChangeInherit(article)
    end,function(article,node)
        self:ChangeShellChange(article,node)
    end,function(article)
        self:ChangeMotorAdjust(article)
    end,function(article)
        self:ChangeAwake(article)
    end,function(article)
        self:ChangeAdvanced(article)
    end,function(data,node)
        self:ChangePartSticker(data,node)
    end)


end

function GarageView:SetReform(article)
    self.PageReform:SetData(self.ObjReform, article,function()
        self:PlayPageAni(page_assemble)
    end,function(data,pos)
        self:ChangeGroupReformSelect(data,pos)
    end,function(data, idx)
        self:ChangeGroupStrong(data, idx)
    end,function(data,pos)
        self:ChangeGroupReformReplace(data, pos)
    end,function(data)
        self:ChangeGroupStar(data)
    end)
end

function GarageView:SetStar(article)
    self.PageStar:SetData(self.ObjStar,article, function()
        self:PlayPageAni(page_assemble)
    end)
end

function GarageView:SetReformSelect(article,pos)
    self.PageReformSelect:SetData(self.ObjReformSelect,article,pos, function()
        self:PlayPageAni(page_reform)
    end, function(data,pos,reformid)
        self:ChangeGroupReformCost(data,pos,reformid)
    end)
end

function GarageView:SetReformCost(article,pos,reformid)
    self.PageReformCost:SetData(self.ObjReformCost,article,pos,reformid, function()
        self:PlayPageAni(page_reformselect)
    end)
end

function GarageView:SetReformReplace(article,pos)
    self.PageReformReplace:SetData(self.ObjReformReplace,article,pos, function()
        self:PlayPageAni(page_reform)
    end)
end

function GarageView:SetStrong(data, idx)
    self.PageStrong:SetData(self.ObjStrong,data, idx, function()
        self:PlayPageAni(page_reform)
    end)
end

function GarageView:SetLevelup(data)
    self.PageLevelup:SetData(self.ObjLevelup,data, function()
        self:PlayPageAni(page_assemble)
    end)
end
function GarageView:SetPartColor(data,node)
    self.PagePartColor:SetData(self.ObjPartColor,data, node,function()
        self:PlayPageAni(page_assemble)
        HomeSceneCarMeshHelper:Get():QucikReBuild()
    end,function(article,cfg)
        self:PlayPageAni(page_partcolorcost)
        self:SetPartColorCost(article,cfg)
    end)
end
function GarageView:SetPartColorCost(article,cfg)
    self.PagePartColorCost:SetData(self.ObjPartColorCost,article, cfg,function()
        self:PlayPageAni(page_partcolor)
    end)
end
function GarageView:SetCarVerify(caridx)
    self.PageCarVerify:SetData(self.ObjVerifyCar,caridx,function()
        self:PlayPageAni(page_main)
        self:PageUpdateMain(false)
    end,function()
        self:ChangeVerifyCarResult()
    end)
end
function GarageView:SetVerifyCarResult(attr,type)
    self.PageCarVerifyResult:SetData(self.ObjVerifyCarResult,self.PreCarIdx:GetCurCarData():GetCarIdx(),attr,type,function()
        self:PlayPageAni(page_verifycar)
        self:ChangeVerifyCar()
    end)
end
function GarageView:SetPartInherit(article)
    self.PageGarage_Inherit:SetData(self.ObjPartInherit,article,function()
        self:PlayPageAni(page_assemble)
    end,function(article,index,optionType)
        self:ChangeInheritSelect(article,index,-1,optionType)
    end,function(article,index)
        self:ChangeInheritLevelUp(article,index)
    end,function(article,index)
        self:ChangeInheritRecasting(article,index)
    end)
end
function GarageView:SetPartShellChange(article,node)
    self.PageGarage_ShellChange:SetData(self.ObjPartShellChange,node,article,function()
        self:PlayPageAni(page_assemble)
    end)
end
function GarageView:SetMotorAdjust(article)
    self.PageGarage_MotorAdjust:SetData(self.ObjPartMotorAdjust,article,function()
        self:PlayPageAni(page_assemble)
    end,function()
        self:ChangeMotorAdjustCost(article)
    end)
end
function GarageView:SetMotorAdjustCost(article)
    self.PageGarage_MotorAdjustCost:SetData(self.ObjPartMotorAdjustCost,article,function()
        self:PlayPageAni(page_motoradjust)
    end)
end
function GarageView:SetPartAwake(article)
    self.PageGarage_Awake:SetData(self.ObjPartAwake,article,function()
        self:PlayPageAni(page_assemble)
    end)
end
function GarageView:SetPartAdvanced(article,cost)
    self.PageGarage_Advanced:SetData(self.ObjPartAdvanced,article,cost,function()
        self:PlayPageAni(page_assemble)
    end,function(article,cost)
        self:ChangeAdvancedSelect(article,cost)
    end)
end
function GarageView:SetPartPartSticker(data,node)
    self.PageGarage_PartSticker:SetData(self.ObjPartSticker,data, node,function()
        self:PlayPageAni(page_assemble)
        self.PagePartlist:ReOpen()
    end)
end

function GarageView:SetPartAdvancedSelect(article,cost)
    self.PageGarage_AdvancedSelect:SetData(self.ObjPartAdvancedSelect,article,cost,function(article,cost)
        self:ChangeAdvanced(article,cost)
    end,function(article,cost)
        self:ChangeAdvanced(article,cost)
    end)
end


function GarageView:SetPartInheritCost(article,index,inheritId,optionType)
    self.PageGarage_InheritCost:SetData(self.ObjPartInheritCost,article,index,inheritId,optionType,function(article,index,inheritId,optionType)
        self:ChangeInheritSelect(article,index,inheritId,optionType)
    end)
end
function GarageView:SetPartInheritLevelUp(article,index)
    self.PageGarage_InheritLevelUp:SetData(self.ObjPartInheritLevelUp,article,index,function()
        self:PlayPageAni(page_inherit)
    end)
end
function GarageView:SetPartInheritSelect(article,index,defaultID,optionType)
    self.PageGarage_InheritSelect:SetData(self.ObjPartInheritSelect,article,index,defaultID,optionType,function()
        self:PlayPageAni(page_inherit)
    end,function(article,index,inheritId,optionType)
        self:ChangeInheritCost(article,index,inheritId,optionType)
    end)
end
function GarageView:SetPartInheritRecasting(article,index)
    self.PageGarage_InheritRecasting:SetData(self.ObjPartInheritRecasting,article,index,function()
        self:PlayPageAni(page_inherit)
    end)
end

function GarageView:SetAppearance()
    self.PageAppearance:SetData(self.ObjAppearance, function()
        self:PlayPageAni(page_main)
        self:PageUpdateMain(false)
        self:ResetCarMesh()
    end, function()
        self:ChangeGroupHole(page_hole)
    end, function()
        self:ChangeGroupColor(page_color)
    end, function()
        self:ChangeGroupSticker(page_sticker)
    end, function()
        self:ChangeGroupGrid(page_grid)
    end)
    self:SetAppearanceShellInfo()
end
function GarageView:SetAppearanceShellInfo()
    local data = self.PreCarIdx:GetCurCarData()
    local node = data.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell)
    local data = KnapsackDataManager:Get():GetArticleByID(node:GetBagId())
    UINotify:Get():SendNotification(UINotifyEvent.GarageView_SetPartinfo, {data, node})
    UINotify:Get():SendNotification(UINotifyEvent.GarageView_PartReview, {data, PartGrooveID.Shell,true})
end
function GarageView:SetPartListSelect()
    self.PagePartlist:AutoSelect()
end

function GarageView:SetHole()
    local data = self.PreCarIdx:GetCurCarData()
    self.PageHole:SetData(self.ObjHole, data,function()
        self:PlayPageAni(page_appearance)
        self:SetAppearanceShellInfo()
    end)
end

function GarageView:SetColor()
    local data = self.PreCarIdx:GetCurCarData()
    self.PageColor:SetData(self.ObjColor,data, function()
        self:PlayPageAni(page_appearance)
        self:SetAppearanceShellInfo()
    end)
end

function GarageView:SetSticker()
    local data = self.PreCarIdx:GetCurCarData()
    self.PageSticker:SetData(self.ObjSticker,data, function()
        self:PlayPageAni(page_appearance)
        self:SetAppearanceShellInfo()
    end)
end

function GarageView:SetGrid()
    local data = self.PreCarIdx:GetCurCarData()
    self.PageGrid:SetData(self.ObjGrid, data, function()
        self:PlayPageAni(page_appearance)
        self:SetAppearanceShellInfo()
    end, function(holeidx)
        self:ChangeGroupGridList(holeidx)
    end)
end

function GarageView:SetGridList(holeidx)
    local data = self.PreCarIdx:GetCurCarData()
    self.PageGridList:SetData(self.ObjGridList, data,holeidx, function()
        self:ChangeGroupGrid()
        self:SetAppearanceShellInfo()
    end)
end
--}}}


--{{{车位
function GarageView:SetCarIdxGroup()
    local idx = PlayerPrefsHelper:GetValue_MainMenuViewCarIndex()
    ---@param data CarData
    self.PreCarIdx:SetData(self.ObjCarIdx, UIModuleID.Garage, idx,true, true,function(data, isautoselect)
        self:SetCarMesh(data,isautoselect==false)
        if isautoselect then
            self:PageUpdateMain(true)
        else
            self:PageUpdateMain(false)
            PlayerPrefsHelper:SetValue_MainMenuViewCarIndex(data:GetCarIdx())
        end
    end)
end
--}}}


--{{{车模型
function GarageView:SetCarMesh(cardata,isQucik)
    if isQucik then
        HomeSceneCarMeshHelper:Get():QuickBreak()
    else
        HomeSceneCarMeshHelper:Get():Break()
    end
    HomeSceneCarMeshHelper:Get():SetDataByCarData(cardata, GarageSceneValue, AnimateType.Garage)
end
function GarageView:ResetCarMesh()
    HomeSceneCarMeshHelper:Get():ResetCar()
    HomeSceneCarMeshHelper:Get():QucikReBuild()
end
function GarageView:ReviewPart(article, grooveid,isOrg)
    HomeSceneCarMeshHelper:Get():ReviewPart(article, grooveid,isOrg or false)
end

function GarageView:ReviewPartByCfgId(id,article ,grooveid)
    HomeSceneCarMeshHelper:Get():ReviewPartByCfgId(id, article,grooveid)
end


function GarageView:ReviewHole(idx)
    HomeSceneCarMeshHelper:Get():ReviewHole(idx)
end
function GarageView:ReviewGrid(idx, gridid)
    HomeSceneCarMeshHelper:Get():RebuildGrid(idx, gridid)
end
function GarageView:ReviewColor(id)
    HomeSceneCarMeshHelper:Get():RebuildColor(id)
end
function GarageView:ReviewSticker(partId,generation,id)
    HomeSceneCarMeshHelper:Get():RebuildSticker(partId,generation,id)
end
function GarageView:ReviewPartSticker(grooveid,partId,generation,id)
    HomeSceneCarMeshHelper:Get():RebuildPartSticker(grooveid,partId,generation,id)
end

--}}}


--{{{刷新页面数据
function GarageView:PageUpdateMain(isresetPos)
    self:SetCarinfo(isresetPos)
    self:SetPartmap(isresetPos)
end
--}}}











function GarageView:UpdateMsg(change)
    local lastPage=self.curpage
    if self.curpage == page_assemble then
        if change then
            self:ChangeGroupMain()
        end
        self:PageUpdateMain(false)
        self.PreCarIdx:UpdateMsg()
        self.PagePartlist:UpdateMsg()
        HomeSceneCarMeshHelper:Get():ResetCar()
    end
    if self.curpage == page_hole then
        self.PageHole:UpdateMsg()
    end
    if self.curpage == page_color then
        self.PageColor:UpdateMsg()
    end
    if self.curpage == page_sticker then
        self.PageSticker:UpdateMsg()
    end
    if self.curpage == page_partsticker then
        self.PageGarage_PartSticker:UpdateMsg()
    end
    if self.curpage == page_gridlist then
        self.PageGridList:UpdateMsg()
    end
    if self.curpage == page_star then
        self:PlayPageAni(page_reform,change)
        self.PagePartlist:UpdateMsg()
        self.PagePartinfo:UpdateMsg()
        self.PageReform:UpdateMsg()
        if not change then
            self.PageStar:UpdateMsg()
        end
    end
    if self.curpage == page_reformcost then
        self:PlayPageAni(page_reform,change)
        self.PageReform:UpdateMsg()
        self.PagePartinfo:UpdateMsg(true)
        if not change then
            self.PageReformCost:UpdateMsg()
        end
    end
    if self.curpage == page_reform then
        self:PlayPageAni(page_reform,change)
        self.PageReform:UpdateMsg()
        self.PagePartinfo:UpdateMsg(true)
    end

    if self.curpage == page_reformreplace then
        self:PlayPageAni(page_reform,change)
        self.PageReform:UpdateMsg()
        self.PagePartinfo:UpdateMsg()
    end
    if self.curpage == page_strong then
        self:PlayPageAni(page_reform,change)
        self.PageReform:UpdateMsg()
        self.PagePartinfo:UpdateMsg()
        if not change then
            self.PageStrong:UpdateMsg()
        end
    end
    if self.curpage == page_levelup then
        self:PlayPageAni(page_assemble,change)
        self.PagePartlist:UpdateMsg()
        self.PagePartinfo:UpdateMsg()
        if not change then
            self.PageLevelup:UpdateMsg()
        end
    end
    if self.curpage == page_awake then
        self:PlayPageAni(page_assemble,change)
        self.PagePartlist:UpdateMsg()
        self.PagePartinfo:UpdateMsg()
        if not change then
            self.PageGarage_Awake:UpdateMsg()
        end
    end
    if self.curpage == page_advanced then
        self:PlayPageAni(page_assemble,change)
        self.PagePartlist:UpdateMsg(true)
        self.PagePartinfo:UpdateMsg()
        if not change then
            self.PageGarage_Advanced:UpdateMsg()
        end
    end
    if self.curpage == page_partcolor then
        self:PlayPageAni(page_assemble,change)
        self.PagePartlist:UpdateMsg()
        self.PagePartinfo:UpdateMsg()
    end
    if self.curpage == page_shellchange then
        self:PlayPageAni(page_assemble,change)
        self.PagePartlist:UpdateMsg()
        self.PagePartinfo:UpdateMsg()
    end
    if self.curpage == page_partcolorcost then
        self:PlayPageAni(page_assemble,change)
        self.PagePartlist:UpdateMsg()
        self.PagePartinfo:UpdateMsg()
    end
    if self.curpage == page_inheritcost then
        self:PlayPageAni(page_inherit,change)
        self.PageGarage_Inherit:UpdateMsg()
        self.PagePartinfo:UpdateMsg(true)
        self.PagePartlist:UpdateMsg(true)
    end
    if self.curpage == page_inheritrecasting then
        self.PageGarage_InheritRecasting:UpdateMsg()
        self.PageGarage_Inherit:UpdateMsg()
        self.PagePartinfo:UpdateMsg(true)
        self.PagePartlist:UpdateMsg(true)
    end
    if self.curpage == page_inherit then
        self.PageGarage_Inherit:UpdateMsg()
        self.PagePartinfo:UpdateMsg(true)
        self.PagePartlist:UpdateMsg(true)
    end
    if lastPage == page_hole or lastPage == page_color or lastPage == page_sticker or lastPage==page_grid then
        self:SetAppearanceShellInfo()
    else
        HomeSceneCarMeshHelper:Get():QucikReBuild()
    end
end

function GarageView:PartInheritRecastingBack()
    self:PlayPageAni(page_inherit,true)
    self.PageGarage_Inherit:UpdateMsg()
    self.PagePartinfo:UpdateMsg(true)
end
function GarageView:UpdateMsgPartLock()
    self.PagePartinfo:UpdateMsg()
    if self.curpage == page_assemble then
        self.PagePartlist:UpdateMsg()
    end
    if self.curpage == page_levelup then
        self.PageLevelup:UpdateMsg()
    end
end


function GarageView:UpdateMsgCarAttrUpdate()
    if self.curpage == page_main then
        self.PageCarinfo:UpdateMsg()
    end
end

function GarageView:UpdateMsgCarIdxOpen()
    if self.curpage == page_main then
        self.PreCarIdx:UpdateMsg()
    end
end

function GarageView:RefreshGarageRedPoint()
    --RedPointHelper.RefreshCarPosRedPoint()
    --RedPointHelper.RefreshGrooveMapRedPoint(0)
end






