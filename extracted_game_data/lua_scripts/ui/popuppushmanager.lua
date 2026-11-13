---@class PopupPushManager
PopupPushManager = class("PopupPushManager")
function PopupPushManager:initialize()
    ---@type Queue
    self.PopupQueue = Queue()
    self.PushState=PushState.End
end

---@return PopupPushManager
function PopupPushManager:Get()
    if self._instance == nil then
        self._instance = PopupPushManager()
    end
    return self._instance
end


function PopupPushManager:PopupPushManager()
    self.PopupQueue:Clear()
end


function PopupPushManager:Add(string)
    self.PopupQueue:EnQueueFront(string)
    self:Pop()
end

function PopupPushManager:Pop()
    if self.PopupQueue:GetSize()>0 and self.PushState==PushState.End then
        local string= self.PopupQueue:DeQueueFront()
        if string then
            self.PushState=PushState.Rally
            CommonTipsHelper:Get():ShowPushTips(string)
        end
    else

    end
end

function PopupPushManager:Next()
    self.PushState=PushState.End
    self:Pop()
end

