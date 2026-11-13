
---@class SpecialTrainingData
---@field id
---@field lastNum
---@field maxNum
SpecialTrainingData = class("SpecialTrainingData")

function SpecialTrainingData:initialize()
    self.id = 0
    self.lastNum = 0
    self.maxNum=0
    ---@type dictcopy_config_cell[]
    self.CopyData=nil
    ---@type dcitchapter_config_cell
    self.cfg=nil
end
---@param data SC_ChapterInfo
function SpecialTrainingData:SetData(data)
   self.id=data.chapterId
   self.lastNum=data.testCurNum
   self.maxNum=data.testMaxNum
   ---@type dictcopy_config_cell[]
   self.CopyData={}
    for i = 1, #data.copys do
        table.insert(self.CopyData,{cfg=CommonHelper:GetTableDataByID(ConfigNames.pvelevel_config,data.copys[i].copyid),msg=data.copys[i]})
    end
    table.sort(self.CopyData,function(a, b)
        return a.msg.copyid<b.msg.copyid
    end)
    ---@type dcitchapter_config_cell
   self.cfg=CommonHelper:GetTableDataByID(ConfigNames.dictchapter_config,self.id)
end