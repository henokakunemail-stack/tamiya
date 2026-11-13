
---@class CarDetailData
CarDetailData = class("CarDetailData")
function CarDetailData:initialize()
   self.PartId=-1
   self.BagId=-1
   self.GrooveState=-1
   self.GrooveId=-1
   self.PartCfg=nil
   ---@type dictpartbase_config_cell
   self.PartBaseCfg=nil
   ---@type  AssembleManager
   self.assembleMgr=nil
   self.CarID=-1
   self.Grid =nil
   self.Colorid = 0
   self.Stickerid = 0
   self.ShellCfg = nil
   self.IsSelf=false
   self.RedFlag=false
end

---@param mgr AssembleManager
---@param param SC_UserCarDetail
---@param msg KnapsackData
function CarDetailData:SetData(mgr,param,isself,KnapsackData)
   self.assembleMgr=mgr
   self.BagId=param.partInx
   self.IsSelf=isself
   if KnapsackData==nil then
      self.KnapsackDataManager=KnapsackDataManager:Get().PartKnapsack
   else
      self.KnapsackDataManager=KnapsackData
   end

   if param.partseq==PartGrooveID.Shell then
      if param.copyPartId and param.copyPartId~=0 then
         self.copyPartId=param.copyPartId
      end
      if param.copypartid and param.copypartid~=0 then
         self.copyPartId=param.copypartid
      end
   else
      if param.copyPartId and param.copyPartId~=0 then
         param.partId=param.copyPartId
      end
      if param.copypartid and param.copypartid~=0 then
         self.copyPartId=param.copypartid
      end
   end
   self.ArticleCell=self.KnapsackDataManager:GetArticleByCellID(param.partInx)
   if self.ArticleCell and self.IsSelf then
      self.PartId=self.ArticleCell:GetID()
   else
      self.PartId=param.partId
   end
   self.GrooveState=param.unlockflag
   self.GrooveId=param.partseq
   self.PartCfg=CommonHelper:GetTableDataByID(ConfigNames.parts_config,self.PartId)
   self.PartBaseCfg=CommonHelper:GetPartBaseCfg(self.PartId)
   self.CarID=mgr.CarID
   self.Colorid=param.colorid
   self.Stickerid=param.stickerid
   self.Grid={0,0,0,0,0} --纱网数据
   self.Hole={true,true,true,true,true} --打孔数据
   self.Generation=param.partage
   self.CanUsed=param.canUsed==1
   if param.shellhole and self.GrooveId==PartGrooveID.Shell then
      for i = 1, #param.shellhole do
         self.Grid[i]=param.shellhole[i]
         self.Hole[i]=param.shellhole[i]<=1 -->1 的话未打孔 正常显示
      end
   end
   if param.holes and self.GrooveId==PartGrooveID.Shell then
      for i = 1, #param.holes do
         self.Grid[i]=param.holes[i]
         self.Hole[i]=param.holes[i]<=1 -->1 的话未打孔 正常显示
      end
   end

   self.ChangeColorid=param.copycolorid
   self.ChangeStickerid=param.copystickerid
   self.ChangeGrid={0,0,0,0,0} --纱网数据
   self.ChangeHole={true,true,true,true,true} --打孔数据
   if param.copyshellhole and self.GrooveId==PartGrooveID.Shell then
      for i = 1, #param.copyshellhole do
         self.ChangeGrid[i]=param.copyshellhole[i]
         self.ChangeHole[i]=param.copyshellhole[i]<=1 -->1 的话未打孔 正常显示
      end
   end
   if param.copyholes and self.GrooveId==PartGrooveID.Shell then
      for i = 1, #param.copyholes do
         self.ChangeGrid[i]=param.copyholes[i]
         self.ChangeHole[i]=param.copyholes[i]<=1 -->1 的话未打孔 正常显示
      end
   end
end

function CarDetailData:UpdateCfg()
   self.ArticleCell=self.KnapsackDataManager:GetArticleByCellID(self.BagId)
   if self.ArticleCell then
      self.PartId=self.ArticleCell:GetID()
      self.PartCfg=CommonHelper:GetTableDataByID(ConfigNames.parts_config,self.PartId)
      self.PartBaseCfg=CommonHelper:GetPartBaseCfg(self.PartId)
   end
end

---@param mgr AssembleManager
---@param param Lua_PartData
function CarDetailData:SetDataByLuaPartData(mgr,param,idx,isself)
   self.assembleMgr=mgr
   if param then
      self.PartId=param.PartCfgID
      self.BagId=0
      self.IsSelf=isself
      self.GrooveState=GrooveState.UnLock
      self.GrooveId=AssembleHelper:MsgIdxToGrooveID(idx)
      self.PartCfg=CommonHelper:GetTableDataByID(ConfigNames.parts_config,self.PartId)
      self.PartBaseCfg=CommonHelper:GetPartBaseCfg(self.PartId)
      self.CarID=mgr.CarID
      self.Colorid=param.colorid
      self.Stickerid=param.stickerid
      self.Grid={0,0,0,0,0} --纱网数据
      self.Hole={true,true,true,true,true} --打孔数据
      self.ChangeColorid=param.colorid
      self.ChangeStickerid=param.stickerid
      self.ChangeGrid={0,0,0,0,0} --纱网数据
      self.ChangeHole={true,true,true,true,true} --打孔数据
      if param.shellhole and self.GrooveId==PartGrooveID.Shell then
         for i = 1, #param.shellhole do
            self.Grid[i]=param.shellhole[i]
            self.Hole[i]=param.shellhole[i]<=1 -->1 的话未打孔 正常显示
         end
      end
   else

      self.GrooveState=GrooveState.UnLock
      self.GrooveId=AssembleHelper:MsgIdxToGrooveID(idx)
   end

end
function CarDetailData:SetRedFlag(value) self.RedFlag=value end
function CarDetailData:GetRedFlag() return self.RedFlag end
function CarDetailData:GetGrooveState() return self.GrooveState end
function CarDetailData:SetGrooveState(value)  self.GrooveState=value end
function CarDetailData:GetBagId() return self.BagId end
function CarDetailData:GetPartId(ischange)
   local result= self.PartId
   local orgId=self.PartId
   if self.GrooveId==PartGrooveID.Shell  and ischange then
         if self.copyPartId and self.copyPartId>0 then
            return self.copyPartId,orgId
         end
   end
   return result,orgId
end
function CarDetailData:GetColor(isorg)
   local result=self.Colorid
   if self.copyPartId and self.copyPartId>0 and not isorg then
     result=self.ChangeColorid
   end
   return result
end
function CarDetailData:GetSticker(isorg)
   local result=self.Stickerid
   if  self.copyPartId and self.copyPartId>0 and not isorg then
      result=self.ChangeStickerid
   end
   return result
end
function CarDetailData:GetLightWeight(isorg)
   local result=self.Hole
   if self.copyPartId and  self.copyPartId>0 and not isorg then
      result=self.ChangeHole
   end
   return result
end
function CarDetailData:GetGrid(isorg)
   local result=self.Grid
   if self.copyPartId and  self.copyPartId>0 and not isorg then
      result=self.ChangeGrid
   end
   return result
end

function CarDetailData:GetPartCfg() return self.PartCfg end
function CarDetailData:GetPartBaseCfg() return self.PartBaseCfg end
function CarDetailData:GetGrooveId() return self.GrooveId end
function CarDetailData:GetCarIdx() return self.CarID end
function CarDetailData:GetGeneration() return self.Generation end
function CarDetailData:UpdateLightweight(value)
   self.Grid={0,0,0,0,0} --纱网数据
   self.Hole={true,true,true,true,true} --打孔数据
   for i = 1, #value do
      self.Grid[i]=value[i]
      self.Hole[i]=value[i]<=1 -->1 的话未打孔 正常显示
   end
end
function CarDetailData:UpdateColor(value)    self.Colorid=value  end
function CarDetailData:UpdateSticker(value)  self.Stickerid=value  end

function CarDetailData:UpdateCopyShellId(value)  self.copyPartId=value  end

function CarDetailData:UpdateCopyLightweight(grid,hole)
   self.ChangeGrid=grid--纱网数据
   self.ChangeHole=hole
   --self.Grid={0,0,0,0,0} --纱网数据
   --self.Hole={true,true,true,true,true} --打孔数据
   --for i = 1, #value do
   --   self.Grid[i]=value[i]
   --   self.Hole[i]=value[i]<=1 -->1 的话未打孔 正常显示
   --end
end
function CarDetailData:UpdateCopyColor(value)    self.ChangeColorid=value  end
function CarDetailData:UpdateCopySticker(value)  self.ChangeStickerid=value  end

