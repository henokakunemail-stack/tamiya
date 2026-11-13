function ChatDataManager:InitExplainData()
    self.explainMsgList = {}
end

function ChatDataManager:AddExplainData(talkInfo)
    table.insert(self.explainMsgList, talkInfo)
end

function ChatDataManager:GetExplainDataCount()
    return #self.explainMsgList
end

function ChatDataManager:GetExplainByIdx(idx)
    return self.explainMsgList[idx]
end

function ChatDataManager:ClearExplainData()
    self.explainMsgList = {}
end