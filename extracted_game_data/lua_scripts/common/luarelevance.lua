




---@class LuaRelevance
LuaRelevance = class("LuaRelevance")

function LuaRelevance:initialize()
    self.BtnList = {}
    self.MoreRowList = {}
    self.TitleList = {}
    self.CustomList = {}
    self.FilmList = {}
    self.SliderList = {}
    self.LevelMapList = {}
    self.BoxSliderList = {}
    self.CarouselList = {}
    self.InputList = {}
    self.SuperList = {}
    self.DropDownList = {}
    self.DropDownScrollList = {}
    self.HttpRequestList = {}
end

---@return LuaRelevance
function LuaRelevance:Get()
    if self._instance == nil then
        self._instance = LuaRelevance()
    end
    return self._instance
end

--{{{注册
function LuaRelevance:AddBtn(btn)
    table.insert(self.BtnList, btn)
end
function LuaRelevance:AddTitleScrollView(btn)
    table.insert(self.TitleList, btn)
end
function LuaRelevance:AddMoreRowScrollView(btn)
    table.insert(self.MoreRowList, btn)
end
function LuaRelevance:AddFilmScrollView(btn)
    table.insert(self.FilmList, btn)
end
function LuaRelevance:AddCustomScrollView(btn)
    table.insert(self.CustomList, btn)
end
function LuaRelevance:AddSlider(btn)
    table.insert(self.SliderList, btn)
end
function LuaRelevance:AddLevelMapScrollView(btn)
    table.insert(self.LevelMapList, btn)
end
function LuaRelevance:AddBoxSlider(btn)
    table.insert(self.BoxSliderList, btn)
end
function LuaRelevance:AddCarouselScrollView(btn)
    table.insert(self.CarouselList, btn)
end
function LuaRelevance:AddInput(btn)
    table.insert(self.InputList, btn)
end
function LuaRelevance:AddSuperScrollView(btn)
    table.insert(self.SuperList, btn)
end
function LuaRelevance:AddDropDown(btn)
    table.insert(self.DropDownList, btn)
end
function LuaRelevance:AddDropDownScroll(btn)
    table.insert(self.DropDownScrollList, btn)
end
function LuaRelevance:AddHttpRequest(http)
    table.insert(self.HttpRequestList, http)
end
--}}}











function LuaRelevance:Release()
    for i = 1, #self.BtnList do
        self.BtnList[i].onClickAction = nil
        self.BtnList[i].onPointUp = nil
        self.BtnList[i].onPointDown = nil
    end

    for i = 1, #self.TitleList do
        self.TitleList[i]:SetChangeFunc(nil)
    end

    for i = 1, #self.MoreRowList do
        self.MoreRowList[i]:SetChangeFunc(nil)
        self.MoreRowList[i]:SetChangeLineFunc(nil)
    end

    for i = 1, #self.CustomList do
        self.CustomList[i]:SetChangeFunc(nil)
    end

    for i = 1, #self.FilmList do
        self.FilmList[i]:SetChangeFunc(nil)
    end

    for i = 1, #self.SliderList do
        self.SliderList[i].onValueChanged:RemoveAllListeners()
        self.SliderList[i].onValueChanged:Invoke()
    end

    for i = 1, #self.LevelMapList do
        self.LevelMapList[i]:SetChangeFunc(nil)
    end

    for i = 1, #self.BoxSliderList do
        self.BoxSliderList[i]:SetDate({}, nil)
    end

    for i = 1, #self.CarouselList do
        self.CarouselList[i]:SetPageMoveFinishCB(nil)
    end

    for i = 1, #self.InputList do
        self.InputList[i].onEndEdit = nil
    end

    for i = 1, #self.SuperList do
        self.SuperList[i].onValueChanged:RemoveAllListeners()
        self.SuperList[i].onValueChanged:Invoke()
    end

    for i = 1, #self.DropDownList do
        self.DropDownList[i]:SetChangeFun(nil)
        self.DropDownList[i]:SetClickItemAction(nil)
        self.DropDownList[i]:SetClickDropFun(nil)
    end

    for i = 1, #self.DropDownScrollList do
        self.DropDownScrollList[i]:SetClickItemAction(nil)
    end
    for i = 1, #self.HttpRequestList do
        self.HttpRequestList[i].successCallback=nil
        self.HttpRequestList[i].errorCallback=nil
    end
end