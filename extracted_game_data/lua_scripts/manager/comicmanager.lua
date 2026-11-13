---@class ComicManager
ComicManager = class("ComicManager")

function ComicManager:initialize()
    ---@type table<number, ComicData>
    self.ComicDict = {}
    ---@type ComicData
    self.CurPlot = nil


    self.FinishFuc = nil
    self.FinishFucParam = nil

    self.TimerID = -1
end

function ComicManager:Get()
    if self._instance == nil then
        self._instance = ComicManager()
    end
    return self._instance
end

--{{{接口
function ComicManager:OnInit()
    self.ComicDict = {}

    ---@type comic_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.comic_config)
    if tab then
        ---@type comic_config_cell
        local dict = tab.GetConfigData()
        for k, v in pairs(dict) do
            if v.stepids then
                local data = ComicData()
                data:SetData(v.C_ID, v.stepids)
                self.ComicDict[v.C_ID] = data
            end
        end
    end
end

function ComicManager:StartPlot(id, finish, param)
    local data = self.ComicDict[id]

    if data == nil then
        log("---   error:找不到漫画数据，无法触发漫画  id:",id)
        return
    end

    log("---   触发漫画，plotid:",id)
    UIManager:Get():ShowPersistentView("ComicView", CanvasType.FrontCanvas, "ComicView")
    self:SetFinishFuc(finish,param)
    self.CurPlot = data

    cs_coroutine.start(function()
        coroutine.yield()
        data:Touch()
    end)
end
function ComicManager:StartPlotImg(img,finish,param)
    UIManager:Get():ShowPersistentView("ComicView", CanvasType.FrontCanvas, "ComicView")
    UINotify:Get():SendNotification(UINotifyEvent.ComicView_PlayActionImage,{img})
    self.FinishFuc = finish
    self.FinishFucParam = param
end



function ComicManager:SkipStep()
    if self.CurPlot then
        self.CurPlot:QuickEnd()
    end
end

function ComicManager:SkipPlot()
    if self.CurPlot then
        self.CurPlot:Skip()
    end
end
--}}}

function ComicManager:NextStep()
    if self.CurPlot then
        local error = self.CurPlot:NextStep()
        if error then
            self:ErrorTimerStart()
        end
    end
end

function ComicManager:EndPlot()
    if self.FinishFuc then
        self.FinishFuc(self.FinishFucParam)
    end
    self:ClearData()

    UIManager:Get():HidePersistentView("ComicView")
end

function ComicManager:ClearData()
    self:ErrorTimerCancel()
    self.CurPlot = nil
    self.FinishFuc = nil
    self.FinishFucParam = nil
    self.TimerID = -1
end


function ComicManager:ErrorTimerStart()
    log("---   error:剧情数据异常，启动5秒保护机制...")
    TimerManager:Get():StopTimer(self.TimerID)
    self.TimerID = TimerManager:Get():CreateTimer(5, function()
        self:ErrorTimerEnd()
    end)
end
function ComicManager:ErrorTimerEnd()
    self.TimerID = -1
    self:ErrorBreak()
    log("---   error:剧情数据异常，自动退出剧情")
end
function ComicManager:ErrorTimerCancel()
    TimerManager:Get():StopTimer(self.TimerID)
    self.TimerID = -1
end
function ComicManager:ErrorBreak()
    self:EndPlot()
end
