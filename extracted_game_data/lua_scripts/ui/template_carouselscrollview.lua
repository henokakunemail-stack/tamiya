


---@class Template_CarouselScrollView : ViewBase
Template_CarouselScrollView = class("Template_CarouselScrollView", ViewBase)

-- View必加
function Template_CarouselScrollView:initialize()
    ViewBase.initialize(self)
end

function Template_CarouselScrollView:Awake()
    print("Template_CarouselScrollView start")

    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject, function (hbtn)
        UIManager:Get():CloseView()
    end)
    local input = self:GetChildWightByParent("InputField",self.gameObject,typeof(InputField))




    ------------------------------------------------------------------------水平翻页滚动
    local PageH = self:GetChild("PageH")
    self.ScrollLoop = UIUtil.GetTypeChildWightInputPath("PageH/CarouselScrollView_Loop",self.gameObject,typeof(CarouselScrollView))
    self.AutoScrollView = UIUtil.GetTypeChildWightInputPath("PageH/CarouselScrollView_Loop2",self.gameObject,typeof(AutoMoveScrollView))
    CommonHelper:AutoScroll_Init(self.AutoScrollView,true,1,function()

    end)
    CommonHelper:HButtonSetCallback("BtnCreat50_3",PageH, function (hbtn)
        self:InitPage_7_Notime()
    end)
    CommonHelper:HButtonSetCallback("BtnCreat50_1",PageH, function (hbtn)
        self:InitPage_5_Loop()
    end)
    CommonHelper:HButtonSetCallback("BtnRefresh",PageH, function (hbtn)
        CommonHelper:InitCarouselScrollView_RefreshCurList(self.ScrollLoop, false)
    end)
    CommonHelper:HButtonSetCallback("BtnScroll",PageH, function (hbtn)
        CommonHelper:InitCarouselScrollView_MoveToPage(self.ScrollLoop, tonumber(input.text))
    end)
    CommonHelper:HButtonSetCallback("BtnNext",PageH, function (hbtn)
        CommonHelper:InitCarouselScrollView_MoveNextPage(self.ScrollLoop)
    end)
    CommonHelper:HButtonSetCallback("BtnLast",PageH, function (hbtn)
        CommonHelper:InitCarouselScrollView_MoveLastPage(self.ScrollLoop)
    end)
    ------------------------------------------------------------------------


end





function Template_CarouselScrollView:InitPage_7_Notime()
    CommonHelper:InitCarouselScrollView(self.ScrollLoop, 7, nil,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        CommonHelper:SetText("Text",itemObj,"i_"..dataIndex)
    end)
end
function Template_CarouselScrollView:InitPage_5_Loop()
    CommonHelper:InitCarouselScrollView(self.ScrollLoop, 5, 2,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        CommonHelper:SetText("Text",itemObj,"i_"..dataIndex)
    end)

    CommonHelper:InitCarouselScrollView_SetPageMoveFinishCB(self.ScrollLoop, function(idx)
        print("---      自动翻到页 :",idx,type(idx))
    end)
end


