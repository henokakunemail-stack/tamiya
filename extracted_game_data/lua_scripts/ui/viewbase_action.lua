
---@class ViewBaseAction
ViewBaseAction = class("ViewBaseAction")


function ViewBaseAction:initialize(  )
	-- body
	self.eventMap = {}

	--OnNotificationRegister
	self:OnRegisterEvents()

	for k,v in pairs(self.eventMap) do
		UINotify:Get():RegisterObserver(k, self)
	end

	UINotify:Get():RegisterAction(self)
end

function ViewBaseAction:HandleNotification( eventName, notifyData )
	-- body
	local eventCallback = self.eventMap[eventName]
	eventCallback(self, notifyData)
end

function ViewBaseAction:OnRegisterEvents()
	
end

function ViewBaseAction:SetView(v)
	self.view = v
end


---AddNotificationEvent
---@param eventName UINotifyEvent
---@param callback
function ViewBaseAction:AddNotificationEvent( eventName, callback )
	self.eventMap[eventName] = callback
end



















