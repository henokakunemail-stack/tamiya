
function ChatViewData:CachePlayerInfoData()
    self.pagePlayerInfoCG = UIUtil.GetTypeChildWightByParent("Page_ChatPlayerInfo", self.parentPrefab,typeof(CanvasGroup))

    self.pageChatPlayerInfo = PageChatPlayerInfo()
    self.pageChatPlayerInfo:InitData(self.pagePlayerInfoCG.gameObject, self.uiModuleID)
end

---@param chatData ChatData
function ChatViewData:InitPageViewInfo(chatData)
    self.pageChatPlayerInfo:InitViewInfo(chatData)
end

function ChatViewData:SetBtnInfo()
    self.pageChatPlayerInfo:SetBtnInfo()
end

function ChatViewData:ClearPlayInfoData()
    self.pageChatPlayerInfo:ClearData()
end

---@param child @child 就是玩家信息，originalParent 就是聊天的itemObj
function ChatViewData:ChangeChildToSelf(originalParent,child)
    self.pageChatPlayerInfo:ChangeChildToSelf(originalParent,child)
end

function ChatViewData:ChangeChildToOri()
    self.pageChatPlayerInfo:ChangeChildToOri()
end


