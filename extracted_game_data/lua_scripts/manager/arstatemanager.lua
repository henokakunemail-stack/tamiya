

local __instance

---@class ARStateManager
ARStateManager = class("ARStateManager")

function ARStateManager:initialize()
    ---@type ARStateType
    self.CurState = ARStateType.None

    self.StateMap = {}

    local carstate = ARStateCar()
    local teamstate = ARStateTeam()
    self.StateMap[ARStateType.Car] = carstate
    self.StateMap[ARStateType.Team] = teamstate
end

---@return ARStateManager
function ARStateManager:Get()
    if __instance == nil then
        __instance = ARStateManager()
    end
    return __instance
end



---@param type ARStateType
function ARStateManager:ChangeState(type, ...)
    if self.StateMap[type] == nil then return end

    if  self:CheckCurState(type) then return  end

    if type == ARStateType.Car then
        local id = select(1, ...)
        ---@type ARStateCar
        local carstate = self.StateMap[type]
        if carstate ~= nil then carstate:OnStart(id) end
        self.CurState = type
    elseif type == ARStateType.Team then
        local index = select(1, ...)
        ---@type ARStateTeam
        local carstate = self.StateMap[type]
        if carstate ~= nil then carstate:OnStart(index) end
        self.CurState = type
    elseif type == ARStateType.CarMove then

    elseif type == ARStateType.None then

    else
        print("---   error:AR切换状态错误，输入错误状态类型,type = ",type)
    end


end

function ARStateManager:EndState()
    ---@type ARStateBase
    local temp = self.StateMap[self.CurState]
    if temp == nil then return end
    temp:OnEnd()
end
function ARStateManager:CheckCurState(type)
    if type == self.CurState then
        print("---   error:ar状态操作异常")
        return true
    end
    return false
end


function ARStateManager:AddARCar()

end
function ARStateManager:AddARTeam()

end