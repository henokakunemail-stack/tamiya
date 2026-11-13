
---@class NetSubSystemManager NetSubSystemManager
NetSubSystemManager = class("NetSubSystemManager")

function NetSubSystemManager:initialize( ... )
	-- body
	self.subSystemList = {}
	print(" NetSubSystemManager:initialize........ ")
end

function NetSubSystemManager:OnInit(  )
	-- body
	for k,v in pairs(NetSubSystemNames) do
		local ev = require("net/sub_system/"..v);
        self.subSystemList[v] = ev;
	end
end

function NetSubSystemManager:Get()
    if self._instance == nil then
        self._instance = NetSubSystemManager()
    end

    return self._instance
end