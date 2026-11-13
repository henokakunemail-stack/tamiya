


---@class PushView
PushView = class("PushView",ViewBase)


function PushView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PushViewViewAction")

    print("---   PushView 初始化完成")
end

function PushView:Awake()
    print("---   PushView awake")
    self.text = self:GetChildWight("Text",typeof(Text))
    self.tween = self:GetChildWight("Tween",typeof(Tweener))
end

function PushView:ShowTips(des)

    CommonHelper:SetText("Text",self.gameObject,des)

    self.tween.method = EaseType.easeOutBack
    self.tween:PlayForward()

    local seqHandle = UnrealM.ActionSequenceHandle()
    seqHandle:Looper(1, nil):ActionInt(function(count)
        seqHandle:StopSequence()
        self.tween.method = EaseType.easeOutBack
        self.tween:PlayReverse()
        local seqHandle = UnrealM.ActionSequenceHandle()
        seqHandle:Looper(1, nil):ActionInt(function(count)
            seqHandle:StopSequence()
            PopupPushManager:Get():Next()
        end)
    end)
end