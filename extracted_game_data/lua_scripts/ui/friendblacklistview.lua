---@class  FriendBlackListView : ViewBase
FriendBlackListView = class("FriendBlackListView", ViewBase)

function FriendBlackListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "FriendBlackListViewAction")
end

function FriendBlackListView:Awake()
    self:CacheBaseData()
    self:InitBtnFunc()
end

function FriendBlackListView:OnOpen()
    UINotify:Get():SendNotification(UINotifyEvent.FriendBlackListView_InitFriendList)
end

function FriendBlackListView:CacheBaseData()
    self. FriendListScrollView = self:GetChildWight("FriendList", typeof(MoreRowScrollView))
end

----初始话界面信息
function FriendBlackListView:InitBtnFunc()
    self.BtnClose = CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
        UINotify:Get():SendNotification(UINotifyEvent.FriendListView_ClearLuaViewInfo)
    end)
    self.BtnClose = CommonHelper:HButtonSetCallback("BtnCloseMask2", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
        UINotify:Get():SendNotification(UINotifyEvent.FriendListView_ClearLuaViewInfo)
    end)
end

----------------------------------------------初始化俱乐部列表信息
function FriendBlackListView:InitFriendList()

    local itemCount = FriendDataManager:Get():GetFriendCountByType(FriendManagerType.BlackList)

    CommonHelper:SetGameObjectActive("NoBlackText", self.gameObject, itemCount <= 0)

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        local ViewDetailBtn = self:GetChildWightByParent("ViewDetailBtn", itemObj, typeof(HButton))
        CommonHelper:SetHButtonClick(ViewDetailBtn, true, true)
        ---@type BackListData
        local backListData = FriendDataManager:Get():GetFriendListByIndexType(FriendManagerType.BlackList, dataIndex + 1)

        CommonHelper:SetPlayerIcon("PlayerIcon100", itemObj, CommonHelper:GetPlayerIconById(backListData:GetPlayerIcon()), CommonHelper:GetPlayerIconById(backListData:GetPlayerIconFrame(),nil,HeadIconAttrType.Frame), nil, UIModuleID.Friend)

        --CommonHelper:SetText("###PlayerLevelText", itemObj, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), "Lv ", tostring(backListData:GetPlayerLV())))
        CommonHelper:SetText("###PlayerNameText", itemObj, tostring(backListData:GetPlayerName()))
        --CommonHelper:SetText("###PlayerServerText", itemObj, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ServerTip), tostring(backListData:GetServerName())))

        --local score = backListData:GetRankScore() == nil and 0 or backListData:GetRankScore()
        ---@type qualifyingrank_config_cell
        --local cfg = CommonHelper:GetRankCfgByScore(score)
        --CommonHelper:SetRankIconGroup("rankicon_s_1", itemObj, cfg)

        CommonHelper:HButtonSetCallback("BtnRemove", itemObj, function()
            FriendSubsystem:Get():SendMsg_DelBlacklist(backListData:GetPlayerId())
        end)

        CommonHelper:HButtonSetCallback("ViewDetailBtn", itemObj, function(param)
            --PersonalHomeSubsystem:Get():SendLookHomeInfo(backListData:GetPlayerId())
            --FriendSubsystem:Get():SendMsg_GetPlayerInfo(backListData:GetPlayerId())
        end)
    end
    CommonHelper:InitMoreRowScrollView(self.FriendListScrollView, itemCount, 1, UpdateFunc, true)
end


