


---@class ARStateTeam:ARStateBase
ARStateTeam = class("ARStateCar", ARStateBase)

function ARStateTeam:initialize()

    self.TeamIdx = 0
end

function ARStateTeam:OnStart(teamindex)
    self.TeamIdx = teamindex
end

function ARStateTeam:OnEnd()
    self.TeamIdx = 0
end