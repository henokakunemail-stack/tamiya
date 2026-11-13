
---@class SelfChallengeSelectSceneView : ViewBase
SelfChallengeSelectSceneView = class("SelfChallengeSelectSceneView", ViewBase)
function SelfChallengeSelectSceneView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelfChallengeSelectSceneViewAction")
end
local _UseIndex=0
function SelfChallengeSelectSceneView:Awake()
    CommonHelper:HButtonSetCallback("BgBtn",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtCancel",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
    end)
   CommonHelper:HButtonSetCallback("BtnEnter",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSelectSceneBack,_UseIndex+1)
    end)

    self.ScrollView=self:GetChildWight("MoreRowScrollView_V",typeof(MoreRowScrollView))
end

function SelfChallengeSelectSceneView:OnOpen()

end
---@type SelfChallengeData
local Data=nil
function SelfChallengeSelectSceneView:SetData(data)
   Data=SelfChallengeDataManager:Get():GetSelfChallengeData(SelfChallengeDataManager:Get().SelectId)
    if Data then
        CommonHelper:InitMoreRowScrollView(self.ScrollView, #Data.scenes, 2,function(dataIndex, itemObj, scroll)
            self:UpdateItem(dataIndex, itemObj, scroll)
        end)
    end
end


function SelfChallengeSelectSceneView:UpdateItem(dataIndex, itemObj, scroll)
    CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function ()
        _UseIndex=dataIndex
        CommonHelper:MoreRowView_RefreshCurList(scroll,false)
    end)
    local use=self:GetChildByParent("use",itemObj)
    use:SetActive(_UseIndex==dataIndex)
    local  cfg=CommonHelper:GetTableDataByID(ConfigNames.scene_config,Data.scenes[dataIndex+1])
    CommonHelper:GetComponentSetUITexture("icon",itemObj,cfg.icon,UIModuleID.SelfChallenge)
    local name=ClientDataManager:Get():GetTemplateString(cfg.name)
    CommonHelper:SetText("name",itemObj,name)
    CommonHelper:SetGameObjectActive("Dot (1)",itemObj,dataIndex %2==0)

end

function SelfChallengeSelectSceneView:OnClose()

end


