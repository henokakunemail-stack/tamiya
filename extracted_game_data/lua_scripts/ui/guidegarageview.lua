
local page_main = 1
local page_assemble = 2



---@class GuideGarageView : ViewBase
GuideGarageView = class("GuideGarageView", ViewBase)

function GuideGarageView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "GuideGarageViewAction")


    self.curpage = -1


    ---@type PageGuideGarageCarinfo
    self.PageCarinfo = PageGuideGarageCarinfo()

    ---@type PageGuideGaragePartmap
    self.PagePartmap = PageGuideGaragePartmap()

    ---@type PreGarageCarIdx
   -- self.PreCarIdx = PreGarageCarIdx()

    ---@type PageGuideGaragePartinfo
    self.PagePartinfo = PageGuideGaragePartinfo()

    ---@type PageGuideGaragePartlist
    self.PagePartlist = PageGuideGaragePartlist()

end

function GuideGarageView:Awake()
    log("---   GarageView awake")

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
            UIManager:Get():CloseView()
    end)
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


  --  self.ObjCarIdx = UIUtil.GetChild("CaridxGroup", self.gameObject)
end

function GuideGarageView:OnOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit",self.gameObject)
    HomeSceneHelper:SetGarage_New(port)

    cs_coroutine.start(function()
        coroutine.yield()

        self:ChangeGroupMain()

    end)

end

function GuideGarageView:ReOpen()
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

function GuideGarageView:OnAutoClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
    CameraStackHelper:GarageCameraClose()
end

function GuideGarageView:OnClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
    CommonHelper:ReleasePool(UIModuleID.GuideGarage)
    CameraStackHelper:GarageCameraClose()
end
function GuideGarageView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end



--{{{ 组切换
function GuideGarageView:PlayPageAni(page)
    self.curpage = page
    CommonHelper:TweenGroupUILeft("page_carinfo/TweenTemp_Left/tween", self.gameObject, page == page_main)
    CommonHelper:TweenGroupUILeft("page_partinfo/TweenTemp_Left/tween", self.gameObject, page ~= page_main)
    CommonHelper:TweenGroupUILeft("page_caridx/TweenTemp_GarageButtom/tween", self.gameObject, page == page_main)


    CommonHelper:TweenGroupUILeft("page_partmap/TweenTemp_Right/tween", self.gameObject, page == page_main)
    CommonHelper:TweenGroupUILeft("page_partlist/TweenTemp_Right/tween", self.gameObject, page == page_assemble)


    CommonHelper:TweenGroupUILeft("TweenTemp_Appearance/tween", self.gameObject, page == page_main)
end
function GuideGarageView:ChangeGroupMain(isresetPos)
    self:PlayPageAni(page_main,isresetPos)
end
function GuideGarageView:ChangeGroupAssemble(node, templist)
    self:PlayPageAni(page_assemble)
    self:SetPartlist(node, templist)
end

function GuideGarageView:BackMain()
    self:ChangeGroupMain()
    self:PageUpdateMain(self.CarData,false)
end
--}}}


--{{{设置页面数据
function GuideGarageView:SetCarinfo(data,isresetPos)
    local data = data
    self.PageCarinfo:SetData(self.ObjCarinfo, data, isresetPos)
end

function GuideGarageView:SetPartmap(data,isresetPos)

    local data = data
    self.PagePartmap:SetData(self.ObjPartmap, data,isresetPos, function(grooveid)
        local node = data.assembleMgr:GetNodeByGrooveID(grooveid)
        local templist ={}
        if self.OpenType==GuideGarageViewOpenType.RaceSeniorTrain and GuideManager:Get():GetLastGuideStep() then
             templist =GuideManager:Get():GetLastGuideStep():GetGaragePartList(node.PartId)
        end
        if self.OpenType==GuideGarageViewOpenType.FairMatch then
             templist =AssembleHelper:GetFairmatchPartListByGrooveId(node,self.CarData)
        end
        if #templist > 0 then
            self:ChangeGroupAssemble(node, templist)
        else
            CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.AssembleSiftlistNil))
        end
    end)
end

---@param data ArticleCell
---@param node AssembleNode
function GuideGarageView:SetPartinfo(data, node)
    self.PagePartinfo:SetData(self.ObjPartinfo, data, node)
end

function GuideGarageView:SetPartlist(node, templist)
    self.PagePartlist:SetData(self.ObjPartlist, node, templist, function()
        self:ChangeGroupMain()
        self:PageUpdateMain(self.CarData,false)
    end, function(article)

    end, function(article)

    end, function(article)

    end)
end



--}}}


--{{{车位
function GuideGarageView:SetCarIdxGroup()
    local idx = PlayerPrefsHelper:GetValue_MainMenuViewCarIndex()
    ---@param data CarData
    self.PreCarIdx:SetData(self.ObjCarIdx, UIModuleID.GuideGarage, idx,true, true,function(data, isautoselect)
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

function GuideGarageView:SetData(data,list,type)
    ---@type CarReviewData
    self.CarData=data
    self.PartList=list
    self.OpenType=type
    self:PageUpdateMain(data,true)
    self:SetCarMesh(data,true)
end


--{{{车模型
function GuideGarageView:SetCarMesh(cardata,isQucik)
    if isQucik then
        HomeSceneCarMeshHelper:Get():QuickBreak()
    else
        HomeSceneCarMeshHelper:Get():Break()
    end
    HomeSceneCarMeshHelper:Get():SetDataByCarReviewData(cardata, SceneChangeID.Garage_New, AnimateType.Garage)
end
function GuideGarageView:ResetCarMesh()
    HomeSceneCarMeshHelper:Get():QucikReBuildCarReviewData(self.CarData)
end
function GuideGarageView:ReviewPart(article, grooveid)
    HomeSceneCarMeshHelper:Get():ReviewPartCfg(article, grooveid)
end
function GuideGarageView:PartRemove(article, grooveid)
    self.CarData:SetDataByGrooveId(grooveid,-1)
    HomeSceneCarMeshHelper:Get():QucikReBuildCarReviewData(self.CarData)
    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.DisassembleSucceed))
end
function GuideGarageView:PartChange(article, grooveid)
    self.CarData:SetDataByGrooveId(grooveid,article.PartCfg.C_ID)
    HomeSceneCarMeshHelper:Get():QucikReBuildCarReviewData(self.CarData)
    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.AssembleSucceed))
end
--}}}


--{{{刷新页面数据
function GuideGarageView:PageUpdateMain(data,isresetPos)
    self:SetCarinfo(data,isresetPos)
    self:SetPartmap(data,isresetPos)
end
--}}}

function GuideGarageView:UpdateMsg()
    if self.curpage == page_assemble then
        self:ChangeGroupMain()
        self:PageUpdateMain(false)
        self.PreCarIdx:UpdateMsg()
        HomeSceneCarMeshHelper:Get():ResetCar()
    end
    HomeSceneCarMeshHelper:Get():QucikReBuild()
end

function GuideGarageView:UpdateMsgCarAttrUpdate()
    if self.curpage == page_main then
        self.PageCarinfo:UpdateMsg()
    end
end







