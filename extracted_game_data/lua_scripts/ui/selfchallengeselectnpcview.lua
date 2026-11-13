
---@class SelfChallengeSelectNpcView : ViewBase
SelfChallengeSelectNpcView = class("SelfChallengeSelectNpcView", ViewBase)
function SelfChallengeSelectNpcView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelfChallengeSelectNpcViewAction")
end
local _UseIndex=0
function SelfChallengeSelectNpcView:Awake()
    CommonHelper:HButtonSetCallback("BgBtn",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtCancel",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
    end)
  CommonHelper:HButtonSetCallback("BtnEnter",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
      UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSelectNpcBack,_UseIndex+1)
    end)
    self.ScrollView=self:GetChildWight("MoreRowScrollView_V",typeof(MoreRowScrollView))

end

function SelfChallengeSelectNpcView:OnOpen()

end
local _NpcList=nil
local _Track=nil
local _CurLv=nil
function SelfChallengeSelectNpcView:SetData(track,CurLv)
    print("track",track)
    _UseIndex=-1
    _Track=track
    _CurLv=CurLv
   local _Data = SelfChallengeDataManager:Get():GetSelfChallengeData(SelfChallengeDataManager:Get().SelectId)
    _NpcList = _Data.trackNpcInfo[track]

    CommonHelper:InitMoreRowScrollView(self.ScrollView, #_NpcList, 4,function(dataIndex, itemObj, scroll)
        self:UpdateItem(dataIndex, itemObj, scroll)
    end)

end

function SelfChallengeSelectNpcView:UpdateItem(dataIndex, itemObj, scroll)
    local npcId= _NpcList[dataIndex+1]
    ---@type npc_config_cell
    local  cfg=CommonHelper:GetTableDataByID(ConfigNames.npc_config,npcId)
    ---@type hero_config_cell
    if cfg~=nil then
        local hero= CommonHelper:GetTableDataByID(ConfigNames.hero_config,cfg.hero)
        local param=Param_NPCGroup()
        param.npcId=cfg.id
        param.name=cfg.name
        param.npcIcon=hero.picture..".png"
        param.moduleId=UIModuleID.SelfChallenge
        CommonHelper:SetNpcGroup(itemObj,param)
    end
    CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (data)
        if SelfChallengeDataManager:Get():CheckNpcIsSelected(_CurLv,data.intData) then
            CommonTipsHelper:Get():ShowCenterTips("你已选择过该Npc不可重复选择")
        else
            _UseIndex=dataIndex
            CommonHelper:MoreRowView_RefreshCurList(scroll,false)
        end
       -- CommonHelpe
    end,cfg.id)

    CommonHelper:HButtonSetCallback("NpcBtnItem",itemObj,function(data)
        CommonHelper:ShowCarInfoByNPC(npcId,true)
    end)
    local use=self:GetChildByParent("use",itemObj)

    use:SetActive(_UseIndex==dataIndex)
    CommonHelper:SetGameObjectActive("Dot (1)",itemObj,dataIndex %4==0)
end

function SelfChallengeSelectNpcView:OnClose()

end


