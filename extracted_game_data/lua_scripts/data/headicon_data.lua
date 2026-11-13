---@class HeadIconData HeadIconData
HeadIconData = class("HeadIconData")
function HeadIconData:initialize()
    self.id=-1
    ---@type headicon_config_cell
    self.cfg=nil
    self.LockFlag=false
end

---@param isLock 0未解锁 1解锁
function HeadIconData:SetData(id,isLock)
    self.id=id
    self.cfg=CommonHelper:GetTableDataByID(ConfigNames.headicon_config,id)
    self.isLock=isLock==1
end