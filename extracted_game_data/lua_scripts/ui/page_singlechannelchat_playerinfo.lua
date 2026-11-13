function PageSingleChannelChat:CachePlayerInfoData()
    self.pagePlayerInfoCG = UIUtil.GetTypeChildWightByParent("Page_ChatPlayerInfo", self.parentRoot, typeof(CanvasGroup))

    self.pageChatPlayerInfo = PageChatPlayerInfo()
    self.pageChatPlayerInfo:InitData(self.pagePlayerInfoCG.gameObject, self.uiModuleID)

    UIUtil.ShowCanvasGroup(self.pagePlayerInfoCG, false)
end

---@param chatData ChatData
function PageSingleChannelChat:InitPageViewInfo(chatData)
    self.pageChatPlayerInfo:InitViewInfo(chatData)
end

function PageSingleChannelChat:SetBtnInfo()
    self.pageChatPlayerInfo:SetBtnInfo()
end

function PageSingleChannelChat:ClearPlayInfoData()
    self.pageChatPlayerInfo:ClearData()
end

---@param child @child 就是玩家信息，originalParent 就是聊天的itemObj
function PageSingleChannelChat:ChangeChildToSelf(originalParent, child)
    self.pageChatPlayerInfo:ChangeChildToSelf(originalParent, child)
end

function PageSingleChannelChat:ChangeChildToOri()
    self.pageChatPlayerInfo:ChangeChildToOri()
end


