


---@class PlotData
PlotData = class("PlotData")

function PlotData:initialize()
    self.PlotID = -1
    ---@type table<number, PlotDataStep>
    self.Steps = {}

    self.CurStepIdx = -1
    ---@type PlotDataStep
    self.CurStep = nil
end
---@param list plot_config_cell[]
function PlotData:SetData(plotid, list)
    self.PlotID = plotid

    for i = 1, #list do
        local data = PlotDataStep()
        data:SetData(list[i].stepid)
        table.insert(self.Steps, data)
    end
end

function PlotData:ClearData()
    self.CurStepIdx = -1
    self.CurStep = nil
end

function PlotData:Touch()
    self.CurStepIdx = 0
    return self:NextStep()
end

function PlotData:NextStep()
    if self.CurStepIdx == -1 then
        log("---   error:数据异常，PlotData:NextStep()异常触发，先调用PlotData:Touch() plotid:",self.PlotID)
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
        PlotManager:Get():EndPlot()
    end
    return false
end

function PlotData:QuickEnd()
    if self.CurStep then
        self.CurStep:QuickEnd()
    end
end

function PlotData:Skip()
    if self.CurStep then
        self.CurStep:Skip()
    end
    self:ClearData()
    PlotManager:Get():EndPlot()
end