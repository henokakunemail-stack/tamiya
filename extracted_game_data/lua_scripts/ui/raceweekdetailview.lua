


---@class RaceWeekDetailView : ViewBase
RaceWeekDetailView = class("RaceWeekDetailView", ViewBase)

function RaceWeekDetailView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceWeekDetailViewAction")
end

function RaceWeekDetailView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    self.RootJoin = UIUtil.GetChild("page_join",self.gameObject)
    self.RootFightGroup = UIUtil.GetChild("page_fightgroup",self.gameObject)
    self.RootResult = UIUtil.GetChild("page_result",self.gameObject)


    self.ObjJoin = nil
    self.ObjFightGroup = nil
    self.ObjResult = nil

    ---@type Page_RaceWeekJoin
    self.PageJoin = nil
    ---@type Page_RaceWeekFightGroup
    self.PageFightGroup = nil
    ---@type Page_RaceWeekResult
    self.PageResult = nil
end

function RaceWeekDetailView:OnOpen()

end

function RaceWeekDetailView:OnClose()
    if self.PageJoin then
        self.PageJoin:ClearData()
        self.PageJoin = nil
    end
    if self.ObjJoin then
        PrefabCacheMgr:Get():RecyclePrefab(self.ObjJoin)
        self.ObjJoin = nil
    end

    if self.PageFightGroup then
        self.PageFightGroup:ClearData()
        self.PageFightGroup = nil
    end
    if self.ObjFightGroup then
        PrefabCacheMgr:Get():RecyclePrefab(self.ObjFightGroup)
        self.ObjFightGroup = nil
    end

    if self.PageResult then
        self.PageResult:ClearData()
        self.PageResult = nil
    end
    if self.ObjResult then
        PrefabCacheMgr:Get():RecyclePrefab(self.ObjResult)
        self.ObjResult = nil
    end
end

---@param data RaceWeekData
function RaceWeekDetailView:SetData(data)
    if data == nil then
        return
    end

    CommonHelper:SetText("TitleCompoentRed/title1", self.gameObject, data:GetName())

    local state = data:GetMyState()
    if state == RaceWeekState.Join then self:SetPageJoin(data) end
    if state == RaceWeekState.First then self:SetPageFightGroup(data, data:GetMyPlayerData():GetFirstGroup(), false) end
    if state == RaceWeekState.Second then self:SetPageFightGroup(data, data:GetMyPlayerData():GetSecondGroup(), false) end
    if state == RaceWeekState.Third then self:SetPageFightGroup(data, data:GetMyPlayerData():GetThirdGroup(), true) end
    if state == RaceWeekState.Result then self:SetPageResult(data) end
end

---@param data RaceWeekData
function RaceWeekDetailView:SetPageJoin(data)
    PrefabCacheMgr:Get():SwapPrefabAsync("Page_RaceWeekJoin.prefab", nil, nil, function(param, obj)
        UIUtil.SetParentGameObject(self.RootJoin, obj, true, true)
        self.ObjJoin = obj
        self.PageJoin = Page_RaceWeekJoin()
        self.PageJoin:SetData(obj, data)
    end)
end

---@param data RaceWeekData
---@param groupdata RaceDataFightGroup
function RaceWeekDetailView:SetPageFightGroup(data, groupdata, isshowcup)
    PrefabCacheMgr:Get():SwapPrefabAsync("Page_RaceWeekFightGroup.prefab", nil, nil, function(param, obj)
        UIUtil.SetParentGameObject(self.RootFightGroup, obj, true, true)
        self.ObjFightGroup = obj
        self.PageFightGroup = Page_RaceWeekFightGroup()
        self.PageFightGroup:SetData(obj, data, groupdata, isshowcup)
    end)
end

---@param data RaceWeekData
function RaceWeekDetailView:SetPageResult(data)
    PrefabCacheMgr:Get():SwapPrefabAsync("Page_RaceWeekResult.prefab", nil, nil, function(param, obj)
        UIUtil.SetParentGameObject(self.RootResult, obj, true, true)
        self.ObjResult = obj
        self.PageResult = Page_RaceWeekResult()
        self.PageResult:SetData(obj, data)
    end)
end