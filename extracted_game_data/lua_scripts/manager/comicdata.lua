---@class ComicData
ComicData = class("ComicData")

function ComicData:initialize()
    self.PlotID = -1
    ---@type table<number, ComicStep>
    self.Steps = {}

    self.CurStepIdx = -1
    ---@type ComicStep
    self.CurStep = nil
end
---@param list comic_config_cell[]
function ComicData:SetData(plotid, list)
    self.PlotID = plotid

    for i = 1, #list do
        local data = ComicStep()
        data:SetData(list[i])
        table.insert(self.Steps, data)
    end
end

function ComicData:ClearData()
    self.CurStepIdx = -1
    self.CurStep = nil
end

function ComicData:Touch()
    self.CurStepIdx = 0
    return self:NextStep()
end

function ComicData:NextStep()
    if self.CurStepIdx == -1 then
        log("---   error:数据异常，ComicData:NextStep()异常触发，ComicData:Touch() plotid:",self.PlotID)
        return true
    end
    if self.CurStep and self.CurStep:GetIsPlaying() then
        log("---   error:数据异常，当前step未完成，不能触发下一个step! plotid:",self.PlotID,"stepidx:",self.CurStepIdx,"stepid:", self.CurStep:GetStepID())
        return true
    end

    self.CurStepIdx = self.CurStepIdx + 1
    if self.CurStepIdx <= #self.Steps then
        self.CurStep = self.Steps[self.CurStepIdx]
        self.CurStep:Touch()
    else
        self:ClearData()
        ComicManager:Get():EndPlot()
    end
    return false
end

function ComicData:QuickEnd()
    if self.CurStep then
        self.CurStep:QuickEnd()
    end
end

function ComicData:Skip()
    if self.CurStep then
        self.CurStep:Skip()
    end
    self:ClearData()
    ComicManager:Get():EndPlot()
end
