


---@class PlotView:ViewBase
PlotView = class("PlotView", ViewBase)

function PlotView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PlotViewAction")

    self.poolList = {}
    self.usingDict = {}
end

function PlotView:Awake()
    log("---   PlotView awake")
    CommonHelper:HButtonSetCallback("NextBtn1",self.gameObject,function(data)
        PlotManager:Get():SkipStep()
    end)
    CommonHelper:HButtonSetCallback("NextBtn2",self.gameObject,function(data)
        PlotManager:Get():SkipStep()
    end)

    CommonHelper:HButtonSetCallback("SkipBtn",self.gameObject,function(data)
        PlotManager:Get():SkipPlot()
    end)

    self.PosRoot = {}
    for i = 1, 9 do
        local obj = UIUtil.GetChild("rolepos"..i, self.gameObject)
        self.PosRoot[i] = obj
    end

    self:PlayerPoolInit()
end

function PlotView:OnOpen()
    for i = 1, 8 do
        self.usingDict[i] = -1
    end

    for i = 1, #self.poolList do
        CommonHelper:GetComponentSetUITexture("playerIcon", self.poolList[i], "uitex_sucai_default.png", UIModuleID.Plot)
    end

    CommonHelper:TweenGroupPlotSetStateDialog("TweenTemp_PlotDialog", self.gameObject,false)
    CommonHelper:TweenGroupPlotSetStateMiniIcon("TweenTemp_PlotRoleMini", self.gameObject,false)
end

function PlotView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.Plot)
end

--{{{playericon缓存池
function PlotView:PlayerPoolInit()
    self.poolList = {}
    for i = 1, 8 do
        local obj = UIUtil.GetChild("TweenTemp_PlotRole"..i, self.gameObject)
        self.poolList[i] = obj
        CommonHelper:GetComponentSetUITexture("playerIcon", obj, "uitex_sucai_default.png", UIModuleID.Plot)
        if self.usingDict then
            self.usingDict[i] = -1
        end
    end
end
function PlotView:PlayerDictAdd(playerid, iconname,width,height)

    for i = 1, #self.usingDict do
        local id = self.usingDict[i]
        if id == playerid then
            local RawImage= CommonHelper:GetComponentSetUITexture("playerIcon", self.poolList[i], iconname, UIModuleID.Plot)
            UIUtil.SetUIWidth(RawImage,width)
            UIUtil.SetUIHeight(RawImage,height)
            return
        end
    end
    for i = 1, #self.usingDict do
        local id = self.usingDict[i]
        if id == -1 then
            self.usingDict[i] = playerid
            local RawImage=CommonHelper:GetComponentSetUITexture("playerIcon", self.poolList[i], iconname, UIModuleID.Plot)
            UIUtil.SetUIWidth(RawImage,width)
            UIUtil.SetUIHeight(RawImage,height)
            return
        end
    end
end
function PlotView:PlayerDictRemove(playerid, iconname)
    for i = 1, #self.usingDict do
        local id = self.usingDict[i]
        if id == playerid then
            CommonHelper:GetComponentSetUITexture("playerIcon", self.poolList[i], iconname, UIModuleID.Plot)
            return
        end
    end
end
function PlotView:PlayerDictGet(playerid)
    for i = 1, #self.usingDict do
        local id = self.usingDict[i]
        if id == playerid then
            return self.poolList[i]
        end
    end
end
--}}}



---@param data PlotDataAction
function PlotView:PlayAction(data, isquick)
    log("---   ^^^   PlayAction",data:GetID())

    self:SetDialog(data, isquick)

    self:SetPlayer(data, isquick)
end

---@param data PlotDataAction
function PlotView:SetDialog(data, isquick)
    if data:GetActionType() ~= 1 then return end


    local dialogtype = data:GetDialogType()
    local tempDialogType1 = (dialogtype == 1 or dialogtype == 2 or dialogtype == 3)
    local tempDialogType2 = (dialogtype == 11 or dialogtype == 12 or dialogtype == 13)

    local title = data:GetPlayer():GetName()
    local playername = PlayerDataManager:Get():GetPlayerName()
    local carname = "无名车"
    local cardata =  CarDataManager:Get():GetCarDataByCarID(1)
    if cardata then carname = cardata:GetName() end

    local contenttype = data:GetContentType()
    local des = data:GetContent()
    if contenttype == 0 then des = CommonHelper:GetTempStr_Default(des) end
    if contenttype == 1 then des = CommonHelper:GetTempStr_Default(des, playername) end
    if contenttype == 2 then des = CommonHelper:GetTempStr_Default(des, carname) end
    if contenttype == 3 then des = CommonHelper:GetTempStr_Default(des, playername, carname) end
    if contenttype == 4 then des = CommonHelper:GetTempStr_Default(des, carname, playername) end

    local dialogani = data:GetDialogAni()

    if dialogtype ~= -1 then
        --{{{next箭头
        CommonHelper:SetGameObjectActive("BtnGroupSmall", self.gameObject, tempDialogType1)
        CommonHelper:SetGameObjectActive("BtnGroupBig", self.gameObject, tempDialogType2)
        --}}}

        --{{{对话框组
        CommonHelper:SetGameObjectActive("dialoggroup1", self.gameObject, tempDialogType1)
        CommonHelper:SetGameObjectActive("dialoggroup2", self.gameObject, tempDialogType2)
        --}}}

        --{{{对话框样式
        CommonHelper:SetGameObjectActive("dialogbg1", self.gameObject, dialogtype == 1)
        CommonHelper:SetGameObjectActive("dialogbg2", self.gameObject, dialogtype == 2)
        CommonHelper:SetGameObjectActive("dialogbg3", self.gameObject, dialogtype == 3)
        CommonHelper:SetGameObjectActive("dialogbg11", self.gameObject, dialogtype == 11)
        CommonHelper:SetGameObjectActive("dialogbg12", self.gameObject, dialogtype == 12)
        CommonHelper:SetGameObjectActive("dialogbg13", self.gameObject, dialogtype == 13)
        --}}}

        --{{{对话框标题
        CommonHelper:SetText("dialoggroup1/dialogtitle",self.gameObject, title)
        CommonHelper:SetText("dialoggroup2/dialogtitle",self.gameObject, title)
        --}}}

        --{{{对话框文本内容
        CommonHelper:SetText("dialoggroup1/dialogdes",self.gameObject, des)
        CommonHelper:SetText("dialoggroup2/dialogdes",self.gameObject, des)
        --}}}

    end

    if dialogani ~= -1 then
        --{{{对话框动画
        if dialogani == 1 and (not isquick) then
            CommonHelper:TweenGroupPlotPlayDialog("TweenTemp_PlotDialog", self.gameObject)
        else
            CommonHelper:TweenGroupPlotSetStateDialog("TweenTemp_PlotDialog", self.gameObject, true)
        end
        --}}}
    end
end





---@param data PlotDataAction
function PlotView:SetPlayer(data, isquick)
    if data:GetActionType() ~= 1 then return end


    local player = data:GetPlayer()
    local playerid = player:GetID()
    local join = data:GetJoin()
    local picidx = data:GetPicIdx()
    local rawingidx = data:GetRawImgIdx()
    local picani = data:GetPicAni()
    local miniicon = data:GetMiniIcon()
    local miniiconani = data:GetMiniIconAni()
    local pos = data:GetPos()
    local gary = data:GetGary()
    local moveidx = data:GetMoveIdx()
    local moveani = data:GetMoveAni()



    --{{{进出场
    if join ~= -1 then
        if join == 1 then
            local picname = "uitex_sucai_default.png"
            local width = 0
            local height= 0
            if rawingidx and rawingidx> 0 then
                ---@type rawimagesize_config_cell
                local cfg = player:GetHalfPic(rawingidx)
                if cfg then picname = cfg.name end
                if cfg then width = cfg.NewWidth end
                if cfg then height = cfg.NewHeight end
            end
            if rawingidx > 0 then self:PlayerDictAdd(playerid, picname,width,height) end
            if miniicon > 0 then CommonHelper:GetComponentSetUITexture("playerminiicon", self.gameObject, player:GetMiniIcon(), UIModuleID.Plot) end
        end
        if join == 2 then
           -- if rawingidx > 0 then self:PlayerDictRemove(playerid, "uitex_sucai_default.png") end
            self:PlayerDictRemove(playerid, "uitex_sucai_default.png")
            if miniicon > 0 then CommonHelper:GetComponentSetUITexture("playerminiicon", self.gameObject, "uitex_sucai_default.png", UIModuleID.Plot) end
        end
    end
    --}}}


    local obj = self:PlayerDictGet(playerid)

    --{{{半身像设置挂点
    if join == 1 and picidx > 0 and pos ~= -1 and pos ~= 101 then
        if obj then
            local posobj = nil
            if pos == 1 then posobj = self.PosRoot[1] end
            if pos == 2 then posobj = self.PosRoot[2] end
            if pos == 3 then posobj = self.PosRoot[3] end
            if pos == 4 then posobj = self.PosRoot[4] end
            if pos == 5 then posobj = self.PosRoot[1] end
            if pos == 6 then posobj = self.PosRoot[5] end
            if pos == 7 then posobj = self.PosRoot[6] end
            if pos == 8 then posobj = self.PosRoot[7] end
            if pos == 9 then posobj = self.PosRoot[8] end
            if pos == 10 then posobj = self.PosRoot[9] end
            CommonHelper:TweenGroupPlotRole(obj, posobj)
        else
            log("---   error:PlayAction()   角色没有进场，不能设置挂点位置!playerid:",playerid)
        end
    end
    --}}}


    --{{{半身像移动
    if moveidx > 0 then
        if obj then
            local posobj = nil
            if moveidx == 1 then posobj = self.PosRoot[1] end
            if moveidx == 2 then posobj = self.PosRoot[2] end
            if moveidx == 3 then posobj = self.PosRoot[3] end
            if moveidx == 4 then posobj = self.PosRoot[4] end
            if moveidx == 5 then posobj = self.PosRoot[1] end
            if moveidx == 6 then posobj = self.PosRoot[5] end
            if moveidx == 7 then posobj = self.PosRoot[6] end
            if moveidx == 8 then posobj = self.PosRoot[7] end
            if moveidx == 9 then posobj = self.PosRoot[8] end
            if moveidx == 10 then posobj = self.PosRoot[9] end
            if moveani == 1 then
                CommonHelper:TweenGroupPlotRole(obj, nil,nil,nil,nil,nil,posobj)
                --CommonHelper:TweenGroupPlotRole(obj, posobj)
            else
                CommonHelper:TweenGroupPlotRole(obj, posobj)
            end
        else
            log("---   error:PlayAction()   角色没有进场，不能半身像移动!playerid:",playerid)
        end
    end
    --}}}



    --{{{是否置灰
    if gary ~= -1 then
        if obj then
            if gary == 1 then
                CommonHelper:TweenGroupPlotRole(obj, nil, nil, nil, true)
            end
            if gary == 2 then
                CommonHelper:TweenGroupPlotRole(obj, nil, nil, nil, nil,true)
            end
        else
            log("---   error:PlayAction()   角色没有进场，不能设置置灰效果!playerid:",playerid)
        end
    end
    --}}}



    --{{{miniicon动画
    if miniiconani > 0 then
        if join == 1 then
            if miniiconani == 1 and (not isquick) then
                CommonHelper:TweenGroupPlotPlayMiniIconEnter("TweenTemp_PlotRoleMini", self.gameObject)
            else
                CommonHelper:TweenGroupPlotSetStateMiniIcon("TweenTemp_PlotRoleMini", self.gameObject, true)
            end
        elseif join == 2 then
            CommonHelper:TweenGroupPlotSetStateMiniIcon("TweenTemp_PlotRoleMini", self.gameObject,false)
        end
    end
    --}}}

    --{{{半身像动画
    if picani > 0 then
        if obj then
            if join == 1 then
                if picani == 1 and (not isquick) then
                    CommonHelper:TweenGroupPlotRole(obj, nil, true)
                end
            elseif join == 2 then

            end
        else
            log("---   error:PlayAction()   角色没有进场，不能设置半身像动画!playerid:",playerid)
        end
    end
    --}}}









end

function PlotView:OnBackKey()

end























--function PlotView:InitBackground()
--
--    local center = UIUtil.GetTypeChildWightInputPath("centerBg",self.gameObject,typeof(RawImage))
--    local top    = UIUtil.GetTypeChildWightInputPath("topBg",self.gameObject,typeof(RawImage))
--    local buttom = UIUtil.GetTypeChildWightInputPath("buttomBg",self.gameObject,typeof(RawImage))
--    table.insert(self.bgList, center)
--    table.insert(self.bgList, top)
--    table.insert(self.bgList, buttom)
--    for i = 1, #self.bgList do
--        self.bgList[i]:ColorAlpha(0)
--    end
--end


--function PlotView:InitTalkGroup()
--    local group1 = UIUtil.GetChildInputPath("TextGroup1",self.gameObject)
--    local group2 = UIUtil.GetChildInputPath("TextGroup2",self.gameObject)
--
--    table.insert(self.talkList, group1)
--    table.insert(self.talkList, group2)
--
--    for i = 1, #self.talkList do
--        self.talkList[i]:SetActive(false)
--    end
--end