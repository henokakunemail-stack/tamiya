



---@class BagMenuView : ViewBase
BagMenuView = class("BagMenuView", ViewBase)

function BagMenuView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BagMenuViewAction")

end

function BagMenuView:Awake()


    CommonHelper:HButtonSetCallback("BtnCost",self.gameObject,function (hbtn)
        UIManager:Get():OpenView("KnapsackView",CanvasType.MainCanvas,"KnapsackView")
        UINotify:Get():SendNotification(UINotifyEvent.KnapsackView_SetData, KnapsackType.Type4)
    end)

    CommonHelper:HButtonSetCallback("BtnPart",self.gameObject,function (hbtn)
        UIManager:Get():OpenView("EquipmentView",CanvasType.MainCanvas,"EquipmentView")
    end)

    CommonHelper:HButtonSetCallback("BtnReform",self.gameObject,function (hbtn)
        UIManager:Get():OpenView("KnapsackView",CanvasType.MainCanvas,"KnapsackView")
        UINotify:Get():SendNotification(UINotifyEvent.KnapsackView_SetData, KnapsackType.Type1)
    end)

    CommonHelper:HButtonSetCallback("BtnStrong",self.gameObject,function (hbtn)
        UIManager:Get():OpenView("KnapsackView",CanvasType.MainCanvas,"KnapsackView")
        UINotify:Get():SendNotification(UINotifyEvent.KnapsackView_SetData, KnapsackType.Type5)
    end)

    CommonHelper:HButtonSetCallback("BtnAppearance",self.gameObject,function (hbtn)
        UIManager:Get():OpenView("KnapsackView",CanvasType.MainCanvas,"KnapsackView")
        UINotify:Get():SendNotification(UINotifyEvent.KnapsackView_SetData, KnapsackType.Appearance)
    end)

    CommonHelper:HButtonSetCallback("BtnStar",self.gameObject,function (hbtn)
        UIManager:Get():OpenView("KnapsackView",CanvasType.MainCanvas,"KnapsackView")
        UINotify:Get():SendNotification(UINotifyEvent.KnapsackView_SetData, KnapsackType.Type2)
    end)

end

function BagMenuView:OnOpen()

end

function BagMenuView:OnClose()

end