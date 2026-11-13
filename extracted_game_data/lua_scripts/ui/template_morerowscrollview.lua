


---@class Template_MoreRowScrollView : ViewBase
Template_MoreRowScrollView = class("Template_MoreRowScrollView", ViewBase)

-- View必加
function Template_MoreRowScrollView:initialize()
    ViewBase.initialize(self)
end

function Template_MoreRowScrollView:Awake()
    print("Template_MoreRowScrollView start")

    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject, function (hbtn)
        UIManager:Get():CloseView()
    end)
    local input = self:GetChildWightByParent("InputField",self.gameObject,typeof(InputField))



    ------------------------------------------------------------------------水平无限滚动
    local Horizontal = self:GetChild("Horizontal")
    self.HScrollView = UIUtil.GetTypeChildWightInputPath("Horizontal/MoreRowScrollViewClick_H",self.gameObject,typeof(MoreRowScrollView))
    CommonHelper:HButtonSetCallback("BtnCreat50",Horizontal, function (hbtn)
        self:InitScroll_H50()
    end)
    CommonHelper:HButtonSetCallback("BtnScroll",Horizontal, function (hbtn)
        CommonHelper:MoreRowView_ScrollToItem(self.HScrollView, tonumber(input.text))
    end)
    CommonHelper:HButtonSetCallback("BtnSelect",Horizontal, function (hbtn)
        CommonHelper:MoreRowView_AniSelectItem(self.HScrollView, tonumber(input.text))
    end)
    CommonHelper:HButtonSetCallback("BtnRefresh",Horizontal, function (hbtn)
        CommonHelper:MoreRowView_RefreshCurList(self.HScrollView, false)
    end)
    ------------------------------------------------------------------------







    ------------------------------------------------------------------------垂直无限滚动
    local Vertical = self:GetChild("Vertical")
    self.VScrollView = UIUtil.GetTypeChildWightInputPath("Vertical/MoreRowScrollViewClick_V",self.gameObject,typeof(MoreRowScrollView))
    CommonHelper:HButtonSetCallback("BtnCreat50",Vertical, function (hbtn)
        self:InitScroll_V50()
    end)
    CommonHelper:HButtonSetCallback("BtnScroll",Vertical, function (hbtn)
        CommonHelper:MoreRowView_ScrollToItem(self.VScrollView, tonumber(input.text))
    end)
    CommonHelper:HButtonSetCallback("BtnSelect",Vertical, function (hbtn)
        CommonHelper:MoreRowView_AniSelectItem(self.VScrollView, tonumber(input.text))
    end)
    CommonHelper:HButtonSetCallback("BtnRefresh",Vertical, function (hbtn)
        CommonHelper:MoreRowView_RefreshCurList(self.VScrollView, false)
    end)
    CommonHelper:HButtonSetCallback("BtnAni1",Vertical, function (hbtn)
        CommonHelper:MoreRowView_EnterAni1(self.VScrollView,0.3)
    end)
    CommonHelper:HButtonSetCallback("BtnAni2",Vertical, function (hbtn)
        CommonHelper:MoreRowView_OutAni(self.VScrollView,0.3)
    end)
    CommonHelper:HButtonSetCallback("BtnAni3",Vertical, function (hbtn)
        CommonHelper:MoreRowView_EnterAni3(self.VScrollView,0.3)
    end)
    CommonHelper:HButtonSetCallback("BtnAni4",Vertical, function (hbtn)
        CommonHelper:MoreRowView_EnterAni4(self.VScrollView,0.3)
    end)
    ------------------------------------------------------------------------








    ------------------------------------------------------------------------水平翻页滚动
    local PageH = self:GetChild("PageH")
    self.PageH = UIUtil.GetTypeChildWightInputPath("PageH/PageScrollView_H",self.gameObject,typeof(MoreRowScrollViewPage))
    CommonHelper:HButtonSetCallback("BtnCreat50_3",PageH, function (hbtn)
        self:InitPage_H50_3()
    end)
    CommonHelper:HButtonSetCallback("BtnCreat50_1",PageH, function (hbtn)
        self:InitPage_H50_1()
    end)
    CommonHelper:HButtonSetCallback("BtnRefresh",PageH, function (hbtn)
        CommonHelper:InitPageScrollView_RefreshCurList(self.PageH, false)
    end)
    CommonHelper:HButtonSetCallback("BtnScroll",PageH, function (hbtn)
        CommonHelper:InitPageScrollView_MoveToPage(self.PageH, tonumber(input.text))
    end)
    CommonHelper:HButtonSetCallback("BtnNext",PageH, function (hbtn)
        CommonHelper:InitPageScrollView_MoveNextPage(self.PageH)
    end)
    CommonHelper:HButtonSetCallback("BtnLast",PageH, function (hbtn)
        CommonHelper:InitPageScrollView_MoveLastPage(self.PageH)
    end)
    ------------------------------------------------------------------------







    ------------------------------------------------------------------------垂直翻页滚动
    local PageV = self:GetChild("PageV")
    self.PageV = UIUtil.GetTypeChildWightInputPath("PageV/PageScrollView_V",self.gameObject,typeof(MoreRowScrollViewPage))
    CommonHelper:HButtonSetCallback("BtnCreat50_3",PageV, function (hbtn)
        self:InitPage_V50_3()
    end)
    CommonHelper:HButtonSetCallback("BtnCreat50_1",PageV, function (hbtn)
        self:InitPage_V50_1()
    end)
    CommonHelper:HButtonSetCallback("BtnRefresh",PageV, function (hbtn)
        CommonHelper:InitPageScrollView_RefreshCurList(self.PageV, false)
    end)
    CommonHelper:HButtonSetCallback("BtnScroll",PageV, function (hbtn)
        CommonHelper:InitPageScrollView_MoveToPage(self.PageV, tonumber(input.text))
    end)
    CommonHelper:HButtonSetCallback("BtnNext",PageV, function (hbtn)
        CommonHelper:InitPageScrollView_MoveNextPage(self.PageV)
    end)
    CommonHelper:HButtonSetCallback("BtnLast",PageV, function (hbtn)
        CommonHelper:InitPageScrollView_MoveLastPage(self.PageV)
    end)
    ------------------------------------------------------------------------
end




function Template_MoreRowScrollView:InitScroll_H50()
    CommonHelper:InitMoreRowScrollView(self.HScrollView, 50, 3,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        CommonHelper:SetText("Text",itemObj,"i_"..dataIndex)
        CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function(btnData)
            CommonHelper:MoreRowView_ShowClickItem(self.HScrollView,btnData.intData)
        end,dataIndex)
    end)
end



function Template_MoreRowScrollView:InitScroll_V50()
    CommonHelper:InitMoreRowScrollView(self.VScrollView, 50, 3,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        CommonHelper:SetText("Text",itemObj,"i_"..dataIndex)
        CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function(btnData)
           CommonHelper:MoreRowView_SelectItem(self.VScrollView,btnData.intData,function(scroll,item,index)
               CommonHelper:SetText("Text",item,"i_"..index)
           end)
            CommonHelper:MoreRowView_ShowClickItem(self.VScrollView,btnData.intData)
        end,dataIndex)
    end)
end



function Template_MoreRowScrollView:InitPage_H50_3()
    CommonHelper:InitPageScrollView(self.PageH, 50, 3,12,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        CommonHelper:SetText("Text",itemObj,"i_"..dataIndex)
    end)

    CommonHelper:InitPageScrollView_SetPageMoveFinishCB(self.PageH, function(idx)
        print("---      翻到页 :",idx,type(idx))
    end)
end
function Template_MoreRowScrollView:InitPage_H50_1()
    CommonHelper:InitPageScrollView(self.PageH, 50, 1,4,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        CommonHelper:SetText("Text",itemObj,"i_"..dataIndex)
    end)
end






function Template_MoreRowScrollView:InitPage_V50_3()
    CommonHelper:InitPageScrollView(self.PageV, 50, 3,15,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        CommonHelper:SetText("Text",itemObj,"i_"..dataIndex)
    end)
end
function Template_MoreRowScrollView:InitPage_V50_1()
    CommonHelper:InitPageScrollView(self.PageV, 50, 1,5,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        CommonHelper:SetText("Text",itemObj,"i_"..dataIndex)
    end)
end