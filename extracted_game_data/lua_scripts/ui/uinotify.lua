
---@class UINotify
UINotify = class("UINotify")

function UINotify:initialize()
    self.m_viewObserversDict = {}
    self.actionMap = {}
end


---@return UINotify
function UINotify:Get()
    if self._instance == nil then
        self._instance = UINotify()
    end
    return self._instance
end

function UINotify:RegisterAction(action)
    -- body
    self.actionMap[action.class.name] = action
end

---@return ViewBaseAction
function UINotify:GetAction(actionName)
    -- body
    return self.actionMap[actionName]
end

function UINotify:RegisterObserver(eventName, observer)
    -- body
    --logError("RegisterObserver ".. eventName)
    local actionList =  self.m_viewObserversDict[eventName]
    if actionList == nil then
        actionList = {}
        self.m_viewObserversDict[eventName] = actionList
    end

    local isExist = false
    for i, v in ipairs(actionList) do
        if v == observer then
            isExist = true
        end
    end

    if not isExist then
        table.insert(actionList, observer)
    end
end

---@param eventName UINotifyEvent
function UINotify:SendNotification(eventName, notifyData)

    local observers = self.m_viewObserversDict[eventName]
    if observers == nil then

        logError("GlobalUIVariable : ' " .. tostring(eventName) .. " is not exist in global_uivariable.lua or ListNotificationString",debug.traceback())
    else
        for i, v in ipairs(observers) do
            v:HandleNotification(eventName, notifyData);
        end
    end
end

function UINotify:ReleaseXLuaRelevance()
    self.m_viewObserversDict = {}
    self.actionMap = {}
end