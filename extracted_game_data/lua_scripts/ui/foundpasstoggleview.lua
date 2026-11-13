---@class FoundPassToggleView : ViewBase
FoundPassToggleView = class("FoundPassToggleView", ViewBase)
local CurFoundType=-1
local ToggleFoundType={}
ToggleFoundType[1]=UserFoundType.SeasonOrder
ToggleFoundType[2]=UserFoundType.CarGad
ToggleFoundType[3]=UserFoundType.Story
ToggleFoundType[4]=UserFoundType.Level
function FoundPassToggleView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "FoundPassToggleViewAction")
end

function FoundPassToggleView:Awake()
    self.ToggleGroup={}
    for i = 1, 4 do
        self.ToggleGroup[i]=CommonHelper:HButtonSetCallback("Toggle"..i,self.gameObject,function(data)
            if CurFoundType~=ToggleFoundType[data.intData] then
                FoundListManager:Get():GetFoundInfo(ToggleFoundType[data.intData])
            end
        end,i)
    end
end

function FoundPassToggleView:OnOpen()

end

function FoundPassToggleView:OnClose()

end
function FoundPassToggleView:SetToggle(type,data)
    self:CloseOther(type)
    CurFoundType=type
    local curIndex=self:GetIndexByType(type)
    for k, v in pairs(self.ToggleGroup) do
        CommonHelper:SetToggleState(v,curIndex==k)
    end
    if type==UserFoundType.CarGad then
        if not UIManager:Get():IsPersistentViewShow("FoundPassCarGodView") then
            UIManager:Get():ShowPersistentView("FoundPassCarGodView", CanvasType.MainCanvas, "FoundPassCarGodView")
        end
    elseif type==UserFoundType.Story then
        if not UIManager:Get():IsPersistentViewShow("FoundPassStoryView") then
            UIManager:Get():ShowPersistentView("FoundPassStoryView", CanvasType.MainCanvas, "FoundPassStoryView")
        end
    elseif type==UserFoundType.Level then
        if not UIManager:Get():IsPersistentViewShow("FoundPassLevelView") then
            UIManager:Get():ShowPersistentView("FoundPassLevelView", CanvasType.MainCanvas, "FoundPassLevelView")
        end
    elseif type==UserFoundType.SeasonOrder then
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderTaskView_SetData,{nil,false})
        if not UIManager:Get():IsPersistentViewShow("SeasonOrderView") then
            UIManager:Get():ShowPersistentView("SeasonOrderView", CanvasType.MainCanvas, "SeasonOrderView")
        end
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderView_SetData,data)
    end
end
function FoundPassToggleView:CloseOther(type)
    if type~=CurFoundType then
        if  UIManager:Get():IsPersistentViewShow("FoundPassCarGodView") then
            UIManager:Get():HidePersistentView("FoundPassCarGodView")
        end
        if  UIManager:Get():IsPersistentViewShow("FoundPassLevelView") then
            UIManager:Get():HidePersistentView("FoundPassLevelView", CanvasType.MainCanvas, "FoundPassLevelView")
        end
        if  UIManager:Get():IsPersistentViewShow("FoundPassStoryView") then
            UIManager:Get():HidePersistentView("FoundPassStoryView", CanvasType.MainCanvas, "FoundPassStoryView")
        end
        if  UIManager:Get():IsPersistentViewShow("SeasonOrderView") then
            UIManager:Get():HidePersistentView("SeasonOrderView", CanvasType.MainCanvas, "SeasonOrderView")
        end
    end
end

function FoundPassToggleView:GetIndexByType(type)
    for k, v in pairs(ToggleFoundType) do
        if v==type then
            return k
        end
    end
    return -1
end
function FoundPassToggleView:CloseView(type)
    self:CloseOther(-1)
    UIManager:Get():HidePersistentView("FoundPassToggleView")
end

