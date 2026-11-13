
local page_main = 1
local page_assemble = 2
local page_reform = 3
local page_reformselect = 4



---@class RaceAssembleGarageView : ViewBase
RaceAssembleGarageView = class("RaceAssembleGarageView", ViewBase)

function RaceAssembleGarageView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceAssembleGarageViewAction")


    self.curpage = -1


    ---@type PageRaceAssembleGarageCarinfo
    self.PageCarinfo = PageRaceAssembleGarageCarinfo()

    ---@type PageRaceAssembleGaragePartmap
    self.PagePartmap = PageRaceAssembleGaragePartmap()

    ---@type PreGarageCarIdx
   -- self.PreCarIdx = PreGarageCarIdx()

    ---@type PageRaceAssembleGaragePartinfo
    self.PagePartinfo = PageRaceAssembleGaragePartinfo()

    ---@type PageRaceAssembleGaragePartlist
    self.PagePartlist = PageRaceAssembleGaragePartlist()

    ---@type PageRaceAssembleGarageReform
    self.PagePartReform = PageRaceAssembleGarageReform()

    ---@type PageRaceAssembleGarageReformSelect
    self.PagePartReformSelect = PageRaceAssembleGarageReformSelect()

end

function RaceAssembleGarageView:Awake()
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

    self.ObjCarinfo = UIUtil.GetChild("Page_Garage_Carinfo", self.gameObject)
    self.ObjPartmap = UIUtil.GetChild("Page_Garage_Partmap", self.gameObject)

    self.ObjPartinfo = UIUtil.GetChild("Page_Garage_Partinfo", self.gameObject)
    self.ObjPartlist = UIUtil.GetChild("Page_Garage_PartList", self.gameObject)

    self.ObjReform = UIUtil.GetChild("Page_Garage_Reform", self.gameObject)
    self.ObjReformSelect = UIUtil.GetChild("Page_Garage_ReformSelect", self.gameObject)
  --  self.ObjCarIdx = UIUtil.GetChild("CaridxGroup", self.gameObject)
end

function RaceAssembleGarageView:OnOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit",self.gameObject)
    HomeSceneHelper:SetGarage_New(port)

    cs_coroutine.start(function()
        coroutine.yield()

        self:ChangeGroupMain()

    end)

end

function RaceAssembleGarageView:ReOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit",self.gameObject)
    HomeSceneHelper:SetGarage_New(port)
    cs_coroutine.start(function()
        coroutine.yield()
        log("---   ^^^   333")
        self:ChangeGroupMain()
        log("---   ^^^   444")
    end)
    log("---   ^^^   222")

    --self:SetCarIdxGroup()
end

function RaceAssembleGarageView:OnAutoClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
    CameraStackHelper:GarageCameraClose()
end

function RaceAssembleGarageView:OnClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
    CommonHelper:ReleasePool(UIModuleID.AssembleGarage)
    CameraStackHelper:GarageCameraClose()
end
function RaceAssembleGarageView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end



--{{{ 组切换
function RaceAssembleGarageView:PlayPageAni(page)
    self.curpage = page
    CommonHelper:TweenGroupUILeft("page_carinfo/TweenTemp_Left/tween", self.gameObject, page == page_main)
    CommonHelper:TweenGroupUILeft("page_partinfo/TweenTemp_Left/tween", self.gameObject, page ~= page_main)
    CommonHelper:TweenGroupUILeft("page_caridx/TweenTemp_GarageButtom/tween", self.gameObject, page == page_main)


    CommonHelper:TweenGroupUILeft("page_partmap/TweenTemp_Right/tween", self.gameObject, page == page_main)
    CommonHelper:TweenGroupUILeft("page_partlist/TweenTemp_Right/tween", self.gameObject, page == page_assemble)
    CommonHelper:TweenGroupUILeft("page_reform/TweenTemp_Right/tween", self.gameObject, page == page_reform)
    CommonHelper:TweenGroupUILeft("page_reformselect/TweenTemp_Right/tween", self.gameObject, page == page_reformselect)


    CommonHelper:TweenGroupUILeft("TweenTemp_Appearance/tween", self.gameObject, page == page_main)
end
function RaceAssembleGarageView:ChangeGroupMain(isresetPos)
    self:PlayPageAni(page_main,isresetPos)
    CameraStackHelper:GarageCameraSwitch(GarageCameraId.Default)
end
function RaceAssembleGarageView:ChangeGroupAssemble(node, templist)
    self:PlayPageAni(page_assemble)
    self:SetPartlist(node, templist)
end
function RaceAssembleGarageView:ChangeGroupReform(article)
    self:PlayPageAni(page_reform)
    self:SetReform(article)
end
function RaceAssembleGarageView:ChangeGroupReformSelect(article,pos,OpenType)
    self:PlayPageAni(page_reformselect)
    self:SetReformSelect(article,pos,OpenType)
end
function RaceAssembleGarageView:BackMain()
    self:ChangeGroupMain()
    self:PageUpdateMain(self.CarData,false)
end
--}}}


--{{{设置页面数据
function RaceAssembleGarageView:SetCarinfo(data,isresetPos)
    local data = data
    self.PageCarinfo:SetData(self.ObjCarinfo, data, isresetPos)
end

function RaceAssembleGarageView:SetPartmap(data,isresetPos)

    local data = data
    self.PagePartmap:SetData(self.ObjPartmap, data,isresetPos, function(grooveid)
        local node = data.assembleMgr:GetNodeByGrooveID(grooveid)
        local templist = AssembleHelper:GetPartsByGrooveAndCarData(node,self.CarData,self.Bag)
        CommonHelper:PlaySfxByGrooveId(grooveid)

        self:RotToGroove(grooveid)
        if #templist > 0 then
            self:ChangeGroupAssemble(node, templist)
        else
            CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.AssembleSiftlistNil))
        end
    end,self.Bag)
end

function RaceAssembleGarageView:SetReform(article)
    self.PagePartReform:SetData(self.ObjReform, article,self.OpenType,function()
        self:PlayPageAni(page_assemble)
    end,function(data,pos)
        self:ChangeGroupReformSelect(data,pos,self.OpenType)
    end,function(data, idx)
        self:ChangeGroupStrong(data, idx)
    end,function(data,pos)
        self:ChangeGroupReformReplace(data, pos)
    end,function(data)
        self:ChangeGroupStar(data)
    end)
end
function RaceAssembleGarageView:SetReformSelect(article,pos,OpenType)
    self.PagePartReformSelect:SetData(self.ObjReformSelect,article,pos, OpenType,function()
        self:PlayPageAni(page_reform)
    end)
end

function  RaceAssembleGarageView:RotToGroove(grooveid)
    ---@type grooveid_config_cell
    self.grooveCfg=CommonHelper:GetTableDataByID(ConfigNames.grooveid_config,grooveid)
    if self.grooveCfg then
        HomeSceneHelper:SetMeshCtrl_Rot(self.grooveCfg.rotate)
        CameraStackHelper:GarageCameraSwitch(self.grooveCfg.camera)
    end
end
---@param data ArticleCell
---@param node AssembleNode
function RaceAssembleGarageView:SetPartinfo(data, node)
    self.PagePartinfo:SetData(self.ObjPartinfo, data, node,self.Bag)
end

function RaceAssembleGarageView:SetPartlist(node, templist)
    self.PagePartlist:SetData(self.ObjPartlist,self.CarData ,self.Bag,node, templist, function()
        self:ChangeGroupMain()
        self:PageUpdateMain(self.CarData,false)
    end, function(article)
        self:ChangeGroupReform(article)
    end, function(article)

    end, function(article)

    end)
end



--}}}


--{{{车位
function RaceAssembleGarageView:SetCarIdxGroup()
    local idx = PlayerPrefsHelper:GetValue_MainMenuViewCarIndex()
    ---@param data CarData
    self.PreCarIdx:SetData(self.ObjCarIdx, UIModuleID.AssembleGarage, idx,true, true,function(data, isautoselect)
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

function RaceAssembleGarageView:SetData(data,list,type)
    ---@type CarData
    self.CarData=data
    self.Bag=list
    self.OpenType=type
    self:PageUpdateMain(data,true)
    self:SetCarMesh(data,true)
end


--{{{车模型
function RaceAssembleGarageView:SetCarMesh(cardata,isQucik)
    if isQucik then
        HomeSceneCarMeshHelper:Get():QuickBreak()
    else
        HomeSceneCarMeshHelper:Get():Break()
    end
    HomeSceneCarMeshHelper:Get():SetDataByCarData(cardata, SceneChangeID.Garage_New, AnimateType.Garage)
end
function RaceAssembleGarageView:ResetCarMesh()
    HomeSceneCarMeshHelper:Get():QucikReBuildCarData(self.CarData)
end
function RaceAssembleGarageView:ReviewPart(article, grooveid)
    HomeSceneCarMeshHelper:Get():ReviewPart(article, grooveid,false,self.CarData)
end
--}}}


--{{{刷新页面数据
function RaceAssembleGarageView:PageUpdateMain(data,isresetPos)
    self:SetCarinfo(data,isresetPos)
    self:SetPartmap(data,isresetPos)
end
--}}}

function RaceAssembleGarageView:UpdateMsg(change)
    if self.curpage == page_assemble then
        self:ChangeGroupMain()
        self:PageUpdateMain(self.CarData,false)
        self.PagePartlist:UpdateMsg()
    end
    if self.curpage == page_reform then
        self:PlayPageAni(page_reform,change)
        self.PagePartReform:UpdateMsg()
        self.PagePartinfo:UpdateMsg(true)
    end
    if self.curpage == page_reformselect then
        self:PlayPageAni(page_reform,change)
        self.PagePartReform:UpdateMsg()
        self.PagePartinfo:UpdateMsg(true)
    end
    self:ResetCarMesh()
end








