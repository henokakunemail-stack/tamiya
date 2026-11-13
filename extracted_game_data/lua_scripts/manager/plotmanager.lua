


---@class PlotManager
PlotManager = class("PlotManager")

function PlotManager:initialize()
    ---@type table<number, PlotData>
    self.PlotDict = {}
    ---@type PlotData
    self.CurPlot = nil


    self.FinishFuc = nil
    self.FinishFucParam = nil

    self.TimerID = -1
end

function PlotManager:Get()
    if self._instance == nil then
        self._instance = PlotManager()
    end
    return self._instance
end

--{{{接口
function PlotManager:OnInit()
    self.PlotDict = {}

    ---@type plot_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.plot_config)
    if tab then
        local dict = tab.GetPlotDict()
        for k, v in pairs(dict) do
            local data = PlotData()
            data:SetData(k, v)
            self.PlotDict[k] = data
        end
    end
end

function PlotManager:StartPlot(id, finish, param)
    local data = self.PlotDict[id]

    if data == nil then
        log("---   error:找不到剧情数据，无法触发剧情  id:",id)
        finish()
        return
    end
    if self.CurPlot and self.CurPlot.PlotID==id then
        return
    end
    log("---   触发剧情，plotid:",id)
    UIManager:Get():ShowPersistentView("PlotView", CanvasType.FrontCanvas, "PlotView")

    self.FinishFuc = finish
    self.FinishFucParam = param
    self.CurPlot = data

    cs_coroutine.start(function()
        coroutine.yield()
        data:Touch()
    end)
end

function PlotManager:SkipStep()
    if self.CurPlot then
        self.CurPlot:QuickEnd()
    end
end

function PlotManager:SkipPlot()
    if self.CurPlot then
        self.CurPlot:Skip()
    end
end
--}}}

function PlotManager:NextStep()
    if self.CurPlot then
        local error = self.CurPlot:NextStep()
        if error then
            self:ErrorTimerStart()
        end
    end
end

function PlotManager:EndPlot()
    if self.FinishFuc then
        self.FinishFuc(self.FinishFucParam)
    end
    self:ClearData()

    UIManager:Get():HidePersistentView("PlotView")
end

function PlotManager:ClearData()
    self:ErrorTimerCancel()
    self.CurPlot = nil
    self.FinishFuc = nil
    self.FinishFucParam = nil
    self.TimerID = -1
end


function PlotManager:ErrorTimerStart()
    log("---   error:剧情数据异常，启动5秒保护机制...")
    TimerManager:Get():StopTimer(self.TimerID)
    self.TimerID = TimerManager:Get():CreateTimer(5, function()
        self:ErrorTimerEnd()
    end)
end
function PlotManager:ErrorTimerEnd()
    self.TimerID = -1
    self:ErrorBreak()
    log("---   error:剧情数据异常，自动退出剧情")
end
function PlotManager:ErrorTimerCancel()
    TimerManager:Get():StopTimer(self.TimerID)
    self.TimerID = -1
end
function PlotManager:ErrorBreak()
    self:EndPlot()
end
