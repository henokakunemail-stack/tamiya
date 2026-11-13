


---@class ARStateCar:ARStateBase
ARStateCar = class("ARStateCar", ARStateBase)

function ARStateCar:initialize()

    self.CarNewID = 0
    self.BuilderID = -1
end

function ARStateCar:OnStart(carnewid)
    self.CarNewID = carnewid
end

function ARStateCar:Trigger()
    if self.BuilderID  ~= -1 then return end


end

function ARStateCar:OnEnd()

    self.CarNewID = 0
    self.BuilderID = -1
end