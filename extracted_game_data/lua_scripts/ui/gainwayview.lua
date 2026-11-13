---@class GainwayView : ViewBase

GainwayView = class("GainwayView", ViewBase)

function GainwayView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "GainwayViewAction")

    print("---   GainwayView 初始化完成")
end

function GainwayView:Awake()
    print("---   GainwayView awake")

    CommonHelper:HButtonSetCallback("BtnSizeSmallYellow",self.gameObject,function()
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function()
        UIManager:Get():ClosePopup()
    end)

    local scroll = UIUtil.GetTypeChildWightByParent("ScrollVerticalOneRow", self.gameObject, typeof(InfinityScrollView))
    self:InitScroll_OneRow(scroll, 4)
end

function GainwayView:OnClose()

end

function GainwayView:InitScroll_OneRow(scroll, totleCount)
    local funcUpdateItem = function (dataIndex, itemObj, scroll)
        ---######################写自己的代码
        print("---   更新item，index：",dataIndex)
        CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
            print("---   点击，index：",hbtn.intData)
        end, dataIndex)
        ---######################
    end
    CommonHelper:InitScroll_OneRow(scroll, totleCount, funcUpdateItem)
end
