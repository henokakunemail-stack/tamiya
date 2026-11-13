



---@class Template_CustomScrollView : ViewBase
Template_CustomScrollView = class("Template_CustomScrollView", ViewBase)

-- View必加
function Template_CustomScrollView:initialize()
    ViewBase.initialize(self)
end

function Template_CustomScrollView:Awake()
    print("Template_ScrollPageView start")

    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject, function (hbtn)
        UIManager:Get():CloseView()
    end)

    local input = self:GetChildWightByParent("InputField",self.gameObject,typeof(InputField))




    ------------------------------------------------------------------------单列,从上向下
    local Vertical = self:GetChild("Vertical")
    self.customScrollView = UIUtil.GetTypeChildWightByParent("CustomScrollView",Vertical,typeof(CustomScrollView))

    CommonHelper:HButtonSetCallback("BtnCreat",Vertical, function (hbtn)
        self:InitScroll_OneRow(self.customScrollView)
    end)
    CommonHelper:HButtonSetCallback("BtnScroll",Vertical, function (hbtn)
        self.customScrollView:ScrollToItem(tonumber(input.text))
    end)
    CommonHelper:HButtonSetCallback("BtnHide",Vertical, function (hbtn)
        CommonHelper:CustomScroll_HideItems(self.customScrollView, {2,4,6})
    end)
    CommonHelper:HButtonSetCallback("BtnShow",Vertical, function (hbtn)
        CommonHelper:CustomScroll_ShowItems(self.customScrollView, {2,4,6})
    end)
    CommonHelper:HButtonSetCallback("BtnChangeItems",Vertical, function (hbtn)
        --CommonHelper:RefreshCurList_Custom(self.customScrollView, {1,2,3,2,3})
    end)
    ------------------------------------------------------------------------


    ------------------------------------------------------------------------单列,从下向上
    local Vertical = self:GetChild("Vertical")
    self.customScrollView2 = UIUtil.GetTypeChildWightByParent("CustomScrollView2",Vertical,typeof(CustomScrollView))

    CommonHelper:HButtonSetCallback("BtnCreat2",Vertical, function (hbtn)
        self:InitScroll_OneRow(self.customScrollView2)
    end)
    CommonHelper:HButtonSetCallback("BtnScroll2",Vertical, function (hbtn)
        self.customScrollView2:ScrollToItem(tonumber(input.text))
    end)
    ------------------------------------------------------------------------


    ------------------------------------------------------------------------
    self.titleScrollView = UIUtil.GetTypeChildWightByParent("TitleScrollView",self.gameObject,typeof(TitleScrollView))
    CommonHelper:HButtonSetCallback("BtnCreatTitleView",self.gameObject, function (hbtn)
        self:InitTitleScrollView(self.titleScrollView)
    end)
    CommonHelper:HButtonSetCallback("BtnRefrashTitleView",self.gameObject, function (hbtn)
        CommonHelper:TitleScrollView_RefreshCurList(self.titleScrollView,false)
    end)
    ------------------------------------------------------------------------


    ------------------------------------------------------------------------
    self.MoreRowScrollView = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_V",self.gameObject,typeof(MoreRowScrollView))
    CommonHelper:HButtonSetCallback("BtnCreat50",self.gameObject, function (hbtn)
        self:InitMoreRowScrollView(self.MoreRowScrollView)
    end)
    CommonHelper:HButtonSetCallback("BtnMove20",self.gameObject, function (hbtn)
        CommonHelper:MoreRowView_ScrollToItem(self.MoreRowScrollView, tonumber(input.text))
    end)
    CommonHelper:HButtonSetCallback("BtnSelectItem",self.gameObject, function (hbtn)
        CommonHelper:MoreRowView_AniSelectItem(self.MoreRowScrollView, tonumber(input.text))
    end)
    CommonHelper:HButtonSetCallback("BtnSelectItem2",self.gameObject, function (hbtn)
        CommonHelper:MoreRowView_RefreshCurList(self.MoreRowScrollView, false)
    end)
    ------------------------------------------------------------------------



    ------------------------------------------------------------------------
    self.levelListScrollView = UIUtil.GetTypeChildWightByParent("LevelMapScrollView",self.gameObject,typeof(LevelListScrollView))
    CommonHelper:HButtonSetCallback("BtnLevel20",self.gameObject, function (hbtn)
        self:InitScroll_LevelList(self.levelListScrollView, 20)
    end)
    CommonHelper:HButtonSetCallback("BtnLevel3",self.gameObject, function (hbtn)
        self:InitScroll_LevelList(self.levelListScrollView, 3)
    end)
    ------------------------------------------------------------------------
end




function Template_CustomScrollView:InitScroll_OneRow(scroll)
    local data = {0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3}
    CommonHelper:CustomView_Init(scroll, data, function(index, itemObj, scroll)
        print("---      更新index = " ,index)
        CommonHelper:SetText("Text",itemObj,index)
    end)
end


function Template_CustomScrollView:InitTitleScrollView(scroll)
    print("---      InitTitleScrollView = " ,scroll)
    local data = {"111",4,"222",1,"333",7,"444",10,"555",5}
    CommonHelper:InitTitleScrollView(scroll, data, 3,function(title, itemObj, dataIndex, scroll)
        if dataIndex == -1 then
            print("---      刷新标题 = " ,title)
            CommonHelper:SetText("Text",itemObj,title)
        else
            print("---      更新item :    title = " ,title,"   itemidx = ", dataIndex)
            CommonHelper:SetText("Text",itemObj,"item"..dataIndex)
        end

        --CommonHelper:SetText("Text",itemObj,dataIndex)
    end)
end




function Template_CustomScrollView:InitMoreRowScrollView(scroll)
    print("---      InitMoreRowScrollView = " ,scroll)
    CommonHelper:InitMoreRowScrollView(scroll, 50, 3,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        CommonHelper:SetText("Text",itemObj,"i_"..dataIndex)
    end)
end


function Template_CustomScrollView:InitScroll_LevelList(scroll, num)
    local data = {}
    if num == 3 then
        table.insert(data, Vector2(0,0))
        table.insert(data, Vector2(100,100))
        table.insert(data, Vector2(-100,200))
    end
    if num == 20 then
        table.insert(data, Vector2(-100,0))
        table.insert(data, Vector2( 40, 100))
        table.insert(data, Vector2(100, 300))
        table.insert(data, Vector2( 80, 550))
        table.insert(data, Vector2( 20, 700))
        table.insert(data, Vector2(-30, 900))
        table.insert(data, Vector2(-80,1100))
        table.insert(data, Vector2( 70,1320))
        table.insert(data, Vector2( 50,1580))
        table.insert(data, Vector2( 40,1740))
        table.insert(data, Vector2(-90,1960))
        table.insert(data, Vector2(-10,2100))
        table.insert(data, Vector2(-40,2350))
        table.insert(data, Vector2( 70,2590))
        table.insert(data, Vector2(-50,2700))
        table.insert(data, Vector2(-40,2910))
        table.insert(data, Vector2( 80,3120))
        table.insert(data, Vector2(-90,3390))
        table.insert(data, Vector2(100,3500))
        table.insert(data, Vector2(100,3700))
    end

    CommonHelper:LevelListView_Init(scroll, data,9, function(index, itemObj, scroll)
        print("---      更新index = " ,index)
        CommonHelper:SetText("LabName",itemObj,index)
    end)
end