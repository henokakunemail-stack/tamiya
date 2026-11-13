


local tempindex = {}





---@class Template_ScrollPageView : ViewBase
Template_ScrollPageView = class("Template_ScrollPageView", ViewBase)

-- View必加
function Template_ScrollPageView:initialize()
    ViewBase.initialize(self)
end

function Template_ScrollPageView:Awake()
    print("Template_ScrollPageView start")

    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject, function (hbtn)
        UIManager:Get():CloseView()
    end)

    local input = self:GetChildWightByParent("InputField",self.gameObject,typeof(InputField))


    ----------------------------------------------------------------------单列纵向
    local vertical = self:GetChild("Vertical")
    local verticalscroll_onerow = UIUtil.GetTypeChildWightByParent("VerticalScroll", vertical, typeof(InfinityScrollViewPage))
    CommonHelper:HButtonSetCallback("BtnCreate50",vertical, function (hbtn)
        self:InitScroll_OneRow(verticalscroll_onerow,48 )
    end)
    CommonHelper:HButtonSetCallback("BtnCreate200",vertical, function (hbtn)
        self:InitScroll_OneRow(verticalscroll_onerow,52 )
    end)
    CommonHelper:HButtonSetCallback("BtnMove",vertical, function (hbtn)
        verticalscroll_onerow:MoveToPage(tonumber(input.text))
    end)
    CommonHelper:HButtonSetCallback("BtnNext",vertical, function (hbtn)
        verticalscroll_onerow:MoveNextPage()
    end)
    CommonHelper:HButtonSetCallback("BtnLast",vertical, function (hbtn)
        verticalscroll_onerow:MoveLastPage()
    end)
    ----------------------------------------------------------------------


    ------------------------------------------------------------------------单列横向
    local Horizontal = self:GetChild("Horizontal")
    local horizontalscroll_onerow = UIUtil.GetTypeChildWightByParent("HorizontalScroll", Horizontal, typeof(InfinityScrollViewPage))
    CommonHelper:HButtonSetCallback("BtnCreate20",Horizontal, function (hbtn)
        self:InitScroll_OneRow(horizontalscroll_onerow, 21 )
    end)
    CommonHelper:HButtonSetCallback("BtnCreate100",Horizontal, function (hbtn)
        self:InitScroll_OneRow(horizontalscroll_onerow, 51 )
    end)
    CommonHelper:HButtonSetCallback("BtnMove",Horizontal, function (hbtn)
        horizontalscroll_onerow:MoveToPage(tonumber(input.text))
    end)
    ------------------------------------------------------------------------



end
function Template_ScrollPageView:OnOpen()
    tempindex = {}
end




function Template_ScrollPageView:InitScroll_OneRow(scroll, totleCount)
    local funcUpdateItem = function (dataIndex, itemObj, scroll)
        ---######################写自己的代码

        local tween = true
        for i = 1, #tempindex do
            if tempindex[i] == dataIndex then
                tween = false
                break
            end
        end

        if tween then
            local aaa = CS.uTools.TweenScale.Begin(itemObj, Vector3(0,0,0), Vector3.one,  0.5)
            --aaa.method = EaseType.easeOutBack;
            table.insert(tempindex, dataIndex)
        end

        if dataIndex < 50 then
            itemObj:SetActive(true)
        else
            itemObj:SetActive(false)
        end


        print("---   更新item，index：",dataIndex)
        CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
            print("---   点击，index：",hbtn.intData)
        end, dataIndex)

        local text = UIUtil.GetTypeChildWightByParent("Text", itemObj, typeof(Text))
        text.text = "item_"..dataIndex
        ---######################
    end
    CommonHelper:InitScroll_OneRow(scroll, totleCount, funcUpdateItem)
end
