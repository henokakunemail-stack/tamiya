---@class GuideData
GuideData=class("GuideData")
function GuideData:initialize(data)
   self:SetData(data)
end
---@param cfg newbieguide_config_cell
function GuideData:SetData(cfg)
    ---@type newbieguide_config_cell
    self.guideCfg=cfg
    self.lastTriggerTime=nil
end

function GuideData:Next()
    ---@type GuideData
   local nextstepData=GuideManager:Get():GetCurGuideStep()
   if nextstepData then
      if nextstepData:GetTriggerType()==GuideTriggerType.NetStep then
          cs_coroutine.start(function()
              coroutine.yield()
              coroutine.yield()
              GuideManager:Get():Execute(nextstepData:GetInterfaceID())
          end)
          return true
      else
          log("不是同界面引导需特殊情况触发")
      end
   end
    return false
end

function GuideData:Execute()

end
function GuideData:End()

end

function GuideData:SetLastTriggerTime(lastTriggerTime)
    self.lastTriggerTime=lastTriggerTime
end

function GuideData:GetNextData() return self.nextStep end
function GuideData:GetId() return self.guideCfg.C_ID  end
function GuideData:GetGroup() return self.guideCfg.group  end
function GuideData:GetStep() return self.guideCfg.step  end
function GuideData:GetNextStep() return self.guideCfg.nextStep  end
function GuideData:GetTriggerType() return self.guideCfg.triggerType  end
function GuideData:GetTriggerPara() return self.guideCfg.triggerPara  end
function GuideData:GetType() return self.guideCfg.type  end
function GuideData:GetUiName() return self.guideCfg.UiName  end
function GuideData:GetArrowTowards() return self.guideCfg.ArrowTowards  end
function GuideData:GetScrollViewName() return self.guideCfg.ScrollViewName  end
function GuideData:GetScrollType() return self.guideCfg.Scrolltype  end
function GuideData:GetScrollMove() return self.guideCfg.ScrollMove==1  end
function GuideData:GetScrollIndex() return self.guideCfg.ScrollIndex  end
function GuideData:GetCompleteCon() return self.guideCfg.completCon  end
function GuideData:GetCompleteType() return self.guideCfg.complettype  end
function GuideData:GetCompleteParam() return self.guideCfg.completParam  end
function GuideData:GetOpenPopupName() return self.guideCfg.OpenPopupName  end
function GuideData:GetNPC() return self.guideCfg.NPC  end
function GuideData:GetNPCPosX() return self.guideCfg.NPCPosX  end
function GuideData:GetNPCPosY() return self.guideCfg.NPCPosY  end
function GuideData:GetDesc() return self.guideCfg.Desc  end
function GuideData:GetDescType() return self.guideCfg.DescType  end
function GuideData:GetIsKey() return self.guideCfg.isKey  end
function GuideData:GetInterfaceID() return self.guideCfg.interfaceID  end
function GuideData:GetIsCollider() return self.guideCfg.Iscollider  end
function GuideData:GetDialogMask() return self.guideCfg.dialogMask  end
function GuideData:GetMaskAnim() return self.guideCfg.maskAnim  end
function GuideData:GetVideoName() return self.guideCfg.videoName  end
function GuideData:GetNextStepMask() return self.guideCfg.nextStepMask  end
function GuideData:GetShrinkTime() return self.guideCfg.shrinkTime  end
function GuideData:GetGuideCV() return self.guideCfg.guideCV  end
function GuideData:GetIsContinueBattle() return self.guideCfg.isContinueBattle  end
function GuideData:GetTriggerProtect() return self.guideCfg.BattleType==2 end--触发慢镜头
function GuideData:GetTriggerPause() return self.guideCfg.BattleType==1 end--暂停
function GuideData:GetTriggerNoFail() return self.guideCfg.BattleNoFail==1 end--触发战斗无敌
function GuideData:GetTriggerCloseNoFail() return self.guideCfg.BattleNoFail==2 end--关闭战斗无敌
function GuideData:GetNextLevelId() return self.guideCfg.nextLevelId end
function GuideData:GetCurGetLevel() return self.guideCfg.curLoading==1 end
function GuideData:GetGaragePartList(partid)
    local result={}
    if partid and partid>0 then
        local temp={}
        temp.PartCfg=CommonHelper:GetTableDataByID(ConfigNames.parts_config,partid)
        temp.PartBaseCfg=CommonHelper:GetPartBaseCfg(partid)
        temp.quality = temp.PartBaseCfg.fabric
        temp.star = 1
        temp.lv = 1
        temp.using = -1
        temp.lock = -1
        temp.awaken=false
        table.insert(result,temp)
    end
    if self.guideCfg and  self.guideCfg.triggerPara ~="-1" then
        local partsId= stringSplitToNumber(self.guideCfg.triggerPara,',')
        for i = 1, #partsId do
            local temp={}
            temp.PartCfg=CommonHelper:GetTableDataByID(ConfigNames.parts_config,partsId[i])
            temp.PartBaseCfg=CommonHelper:GetPartBaseCfg(partsId[i])
            temp.quality = temp.PartBaseCfg.fabric
            temp.star = 1
            temp.lv = 1
            temp.using = -1
            temp.lock = -1
            temp.awaken=false
            table.insert(result,temp)
        end
    end

    return result
end



