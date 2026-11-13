---@class PartAttrCfg
PartAttrCfg = class("PartAttrCfg")
function PartAttrCfg:initialize()
    self.type = -1
    self.value = -1
end


--{{{  重构前
---@class PartFeatureData
PartFeatureData = class("PartFeatureData")
function PartFeatureData:initialize()
    ---@type ArticleCell
    self.Article = nil
    self.id = -1
    self.value = -1
    ---@type attrfeature_config_cell
    self.feature = nil
end
---@param cfg attrfeature_config_cell
---@param article ArticleCell
function PartFeatureData:SetData(article, cfg, value)
    self.Article = article
    self.id = cfg.C_ID
    self.value = value
    self.feature = cfg
end
function PartFeatureData:SetDataByCfg(partcfg,partbasecfg, cfg, value)
    self.PartCfg = partcfg
    ---@type dictpartbase_config_cell
    self.PartBaseCfg = partbasecfg
    self.id = cfg.C_ID
    self.value = value
    self.feature = cfg
end
function PartFeatureData:GetID() return self.id end
function PartFeatureData:GetArticle() return self.Article end
function PartFeatureData:GetFeatureType()
    if self.feature then return self.feature.type end
    return 0
end
function PartFeatureData:GetFeatureName()
    if self.feature then
        return CommonHelper:GetTempStr_Default(self.feature.char)
    else
        return ""
    end
end
function PartFeatureData:GetFeatureValue()
    if self.feature then
        return CommonHelper:GetAttrValue(self.feature.attr, self.value)
    else
        return ""
    end
end
function PartFeatureData:GetFeatureDes()
    if self.feature then
        return CommonHelper:GetTempStr_Default(self.feature.desc)
    else
        return ""
    end
end
function PartFeatureData:GetFeatureLV()
    if self.feature then
        local lv = CommonHelper:GetAttrFeatureLV(self.feature, self.value)
        return CommonHelper:GetTempStr_Default(TemplateStringID.PartFeatureLvFormat, lv)
    else
        return ""
    end
end
function PartFeatureData:GetFeatureIcon()
    if self.feature then
        return self.feature.icon
    else
        return ""
    end
end

---@class PartAttrData
PartAttrData = class("PartAttrData")
function PartAttrData:initialize()
    self.type = -1
    self.value = -1
    ---@type attrfeature_config_cell
    self.feature = nil
    ---@type attrtype_config_cell
    self.attrCfg = nil



    self.attrBaseValue = 0
    ---@type PartAttrCfg
    self.levelupCfg = nil
end
---@param msg SC_Tuple2
function PartAttrData:SetData(type, value, lvupcfg, attrbasevalue, featurecfg)
    self.type = type
    self.value = value
    self.attrCfg = CommonHelper:GetTableDataByID(ConfigNames.attrtype_config, type)

    self.feature = featurecfg

    self.levelupCfg = lvupcfg
    self.attrBaseValue = attrbasevalue
end
function PartAttrData:GetFeatureType()
    if self.feature then return self.feature.type end
    return 0
end
---@class PartInheritData
PartInheritData = class("PartInheritData")
function PartInheritData:initialize()
    self.PartIdx=0
    self.SkillId=0
    self.InheritId=0
    self.Level=0
    self.CurExp=0
    self.AttrVal=0
    self.ReformVal=0
    self.NextExp=0
end
---@param msg SC_UserInherit
function PartInheritData:SetData(msg)
    self.PartIdx=msg.partinx
    self.SkillId=msg.skillid
    self.InheritId=msg.inheritid
    self.Level=msg.powerlev
    self.CurExp=msg.curexp
    self.AttrVal={}
    for i = 1, #msg.attrVal do
        table.insert(self.AttrVal,msg.attrVal[i]/1000)
    end
    self.ReformVal={}
    for i = 1, #msg.reformval do
        table.insert(self.ReformVal,msg.reformval[i])
    end
    self.NextExp=msg.maxexp
    ---@type dictinherit_config_cell
    self.Cfg=CommonHelper:GetTableDataByID(ConfigNames.dictinherit_config,msg.inheritid)
    self.MaxExp=self.NextExp
    self.MaxLevel=#self.Cfg.LevelAttrs
    for i = self.Level+1, #self.Cfg.LevelAttrs-1 do
        self.MaxExp=self.MaxExp+self.Cfg.LevelAttrs[i].NeedExp
    end
end


---@class PartReformData
PartReformData = class("PartReformData")
function PartReformData:initialize()
    self.limit = -1
    self.id = -1
    self.quality = -1
    self.lv = -1
    self.Groove=-1
end
---@param msg Part_Entry
function PartReformData:SetData(limit, msg,i)
    self.limit = limit
    if msg then
        self.id = msg:GetId()
        self.quality = msg:GetQuality()
        self.lv = msg:GetLv()
        self.Groove=msg:GetGroove()
    else
        self.Groove=i-1
    end
end

function PartReformData:GetGroove() return self.Groove end
function PartReformData:GetLv() return self.lv end
function PartReformData:GetQuality() return self.quality end

function PartReformData:UpdateData(reformId, quality)
    self.id = reformId
    self.quality = quality
    self.lv = 1
end
function PartReformData:UpdateQuality( quality)
    self.quality = quality
end
function PartReformData:IsOpen(star)
    return self.limit <= star
end
function PartReformData:IsQualityMax()
    return self.quality >= 3
end
function PartReformData:IsReform()
    return self.id ~= -1
end
function PartReformData:IsBlank(star)
    return self:IsOpen(star) and self.id <= 0
end
function PartReformData:IsNotBlank(star)
    return self:IsOpen(star) and self.id > 0
end



---@class ShellBuffData
ShellBuffData = class("ShellBuffData")
function ShellBuffData:initialize()
    self.id = -1

    ---@type miniskill_config_cell
    self.BuffCfg = nil
end
function ShellBuffData:SetData(id)
    self.id = tonumber(id)
    self.BuffCfg = CommonHelper:GetTableDataByID(ConfigNames.miniskill_config, tonumber(id))
end

---@class ArticleCell_Goods
ArticleCell_Goods = class("ArticleCell_Goods")
function ArticleCell_Goods:initialize()
    ---@type article_config_cell
    self.articleConfig = nil
end
---@param msg SC_PartArticle4Client
function ArticleCell_Goods:SetData(articleid)
    self.articleConfig = CommonHelper:GetTableDataByID(ConfigNames.article_config, articleid)
end




--{{{ 重构
---@class Part_Attr
Part_Attr = class("Part_Attr")
function Part_Attr:initialize()
    self.id=-1
    self.value=-1
end
---@param arg SC_Attr
function Part_Attr:SetData(arg)
    self.id=arg.attrId
    self.value=arg.attrVal/1000
end
function Part_Attr:GetId() return self.id end
function Part_Attr:GetValue() return self.value end

---@class Part_Entry
Part_Entry = class("Part_Entry")
function Part_Attr:initialize()
    self.Id=-1
    self.CellId=-1
    self.Quality=-1
    self.Lv=-1
    self.Groove=-1--改造槽位号
end
---@param arg SC_UserPartEntry
function Part_Entry:SetData(arg)
    self.Id=arg.entryid
    self.CellId=arg.partinx
    self.Quality=arg.quality
    self.Lv=arg.powerlev
    self.Groove=arg.seq
end
function Part_Entry:GetId() return self.Id end
function Part_Entry:GetCellId() return self.CellId end
function Part_Entry:GetQuality() return self.Quality end
function Part_Entry:GetLv() return self.Lv end
function Part_Entry:GetGroove() return self.Groove end

---@class ArticleCell
ArticleCell = class("ArticleCell")

function ArticleCell:initialize()
    self.CellId=-1
    self.ChangeCellId=-1
    self.CfgId=-1
    self.Star=-1
    self.Level=-1
    self.IsUse=-1
    self.Sticker=-1
    self.Color=-1
    self.Hole=-1
    self.Generation=1
    self.CarId=-1--0未用>0车位号
    ---@type Part_Attr[]
    self.PartAttrs= {}
    ---@type Part_Entry[]
    self.Entry={}
    ---@type PartFeatureData[]
    self.FeatureList = {}
    self.Type=-1
    self.Num=0
    self.Rid=-1
    self.flagNew = false
    self.PartLock= 0
    ---@type ShellBuffData[]
    self.ShellBuffs={}
    self.Score=0
    ---@type dictparts_config_cell
    self.partConfig=nil
    ---@type dictpartbase_config_cell
    self.partBaseConfig=nil
    self.FiveAttrs={}
    self.Reform = {}
    self.Awaken=false
    ---@type dictpartage_config_cell
    self.GenCfgCell=nil
    ---@type dictpartage_config_cell[]
    self.GenerationListData=nil
    self.Source=-1
    self.DownType=0
    self.ExpTime=0
    self.IfUse=0
    self.HireNum=0
end

---@param msg SC_UserPart
function ArticleCell:OnInitPart(msg,new)
    self.Rid=msg.rid
    self.CellId=msg.partinx
    local partType=CommonHelper:GetPartBaseCfg(msg.partid).parttype
    if partType==PartType.Shell then
        self.CfgId=msg.partid
        self.ChangeCellId=msg.copypartid
    else
        self.CfgId=msg.copypartid==0 and msg.partid or msg.copypartid
    end
    self.Star=msg.curstar
    self.Level=msg.curlevel
    self.Sticker=msg.stickerid
    self.Color=msg.colorid
    self.PartLock=msg.lockstatus
    self.Grid={0,0,0,0,0} --纱网数据
    self.Hole={true,true,true,true,true} --打孔数据
    for i = 1, #msg.shellhole do
        self.Grid[i]=msg.shellhole[i]
        self.Hole[i]=msg.shellhole[i]<=1 -->1 的话未打孔 正常显示
    end
    self.ChangeColorid=msg.copycolorid
    self.ChangeStickerid=msg.copystickerid
    self.ChangeGrid={0,0,0,0,0} --纱网数据
    self.ChangeHole={true,true,true,true,true} --打孔数据
    if msg.copyshellhole  then
        for i = 1, #msg.copyshellhole do
            self.ChangeGrid[i]=msg.copyshellhole[i]
            self.ChangeHole[i]=msg.copyshellhole[i]<=1 -->1 的话未打孔 正常显示
        end
    end
    self.CarId=msg.planseq
    self.partConfig=CommonHelper:GetTableDataByID(ConfigNames.parts_config,self.CfgId)
    self.PartAttrs={}
    self.Awaken=msg.breakflag == 1
    self.Generation=msg.partage
    self.partBaseConfig=CommonHelper:GetPartBaseCfg(self.CfgId)
    ---@type dictpartage_config
    local GenCfgData=ClientDataManager:Get():GetDataTable(ConfigNames.dictpartage_config)
    if self.partBaseConfig==nil then
        logError("------------>配件没有",self.CellId,self.CfgId)
    end
    self.GenCfgCell=GenCfgData.GetAgeDataById(self.partBaseConfig.C_ID,self.Generation)
    self.GenerationListData=GenCfgData.GetPartGenerationList(self.partBaseConfig.C_ID)
    self.MaxGeneration=GenCfgData.GetMaxGeneration(self.partBaseConfig.C_ID)
    for i = 1, #msg.partAttrs do
        local temp=Part_Attr()
        temp:SetData(msg.partAttrs[i])
        self.PartAttrs[temp.id]=temp
    end
    self.Entry={}
    for i = 1, #msg.curEntry do
        local temp=Part_Entry()
        temp:SetData(msg.curEntry[i])
        self.Entry[temp:GetGroove()+1]=temp
    end
    self.Source=msg.source
    self.DownType=msg.downtype
    if msg.exptime > 0 then
        self.ExpTime = CommonHelper:ConvertIntToDataTime(msg.exptime * 1000)
    end
    self.IfUse=msg.ifuse
    self.HireNum=msg.hirenum
    self:UpdateReform()
    self:SetPartInherit(msg.curInherit)
    self.Type=PropType.Part
    self.Num=1
    self.flagNew=new
    self:UpdateFiveAttrs()
    self:UpdateSecondAttrs()
    --self:UpdateReferenceAttrs()
    self:UpdateScore()
    self:UpdateFeature()
    self:UpdateBuff()
    self:UpdateNew()
end

---@param msg SC_BorrowPart
function ArticleCell:OnInitBorrowPart(msg)
    self.CfgId = msg.copypartid==0 and msg.partid or msg.copypartid
    self.CellId = msg.partinx
    self.Star = msg.curstar
    self.Level = msg.curlevel
    self.Sticker = msg.stickerid
    self.Color = msg.colorid
    self.PartLock = msg.lockstatus
    self.Grid = { 0, 0, 0, 0, 0 } --纱网数据
    self.Hole = { true, true, true, true, true } --打孔数据
    for i = 1, #msg.shellhole do
        self.Grid[i] = msg.shellhole[i]
        self.Hole[i] = msg.shellhole[i] <= 1 -->1 的话未打孔 正常显示
    end
    self.ChangeColorid=msg.copycolorid
    self.ChangeStickerid=msg.copystickerid
    self.ChangeGrid={0,0,0,0,0} --纱网数据
    self.ChangeHole={true,true,true,true,true} --打孔数据
    if msg.copyshellhole  then
        for i = 1, #msg.copyshellhole do
            self.ChangeGrid[i]=msg.copyshellhole[i]
            self.ChangeHole[i]=msg.copyshellhole[i]<=1 -->1 的话未打孔 正常显示
        end
    end
    self.partConfig = CommonHelper:GetTableDataByID(ConfigNames.parts_config, self.CfgId)
    self.PartAttrs = {}
    self.Awaken = msg.breakflag == 1
    self.Generation = msg.partage
    self.partBaseConfig = CommonHelper:GetPartBaseCfg(self.CfgId)
    ---@type dictpartage_config
    local GenCfgData = ClientDataManager:Get():GetDataTable(ConfigNames.dictpartage_config)
    self.GenCfgCell = GenCfgData.GetAgeDataById(self.partBaseConfig.C_ID, self.Generation)
    self.GenerationListData = GenCfgData.GetPartGenerationList(self.partBaseConfig.C_ID)
    self.MaxGeneration = GenCfgData.GetMaxGeneration(self.partBaseConfig.C_ID)
    self.Source = msg.source
    self.DownType = msg.downtype
    --if msg.exptime > 0 then
    --    self.ExpTime = CommonHelper:ConvertIntToDataTime(msg.exptime * 1000)
    --end
    --if msg.hexptime > 0 then
    --    self.HExpTime = CommonHelper:ConvertIntToDataTime(msg.hexptime * 1000)
    --end
    self.ExpTime = msg.exptime
    self.HExpTime = msg.hexptime
    self.OldInx = msg.oldinx
    self.HireRid = msg.hirerid
    self.HireNum = msg.hirenum
    if #msg.partAttrs > 0 then
        for i = 1, #msg.partAttrs do
            local temp = Part_Attr()
            temp:SetData(msg.partAttrs[i])
            self.PartAttrs[temp.id] = temp
        end
    else
        for i, v in pairs(self.GenCfgCell.NewAttr) do
            local temp = Part_Attr()
            v = { attrId = v.type, attrVal = v.value * 1000 }
            temp:SetData(v)
            self.PartAttrs[temp.id] = temp
        end
    end
    self.Entry = {}
    for i = 1, #msg.curEntry do
        local temp = Part_Entry()
        temp:SetData(msg.curEntry[i])
        self.Entry[temp:GetGroove() + 1] = temp
    end
    self:UpdateReform()
    self.Type = PropType.Part
    self.Num = 1
    self:UpdateFiveAttrs()
    self:UpdateSecondAttrs()
    --self:UpdateReferenceAttrs()
    self:UpdateScore()
    -- self:UpdateFeature()
    self:UpdateBuff()
end

function ArticleCell:UpdateReform()
    --{{{改造数据
    self.Reform = {}
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.ReformLimit)
    local reformOpen = stringSplitToNumber(cfg.varval, ',')
    for i = 1, #reformOpen do
        local temp = PartReformData()
        local limit = reformOpen[i]
        if self.partConfig and self.partBaseConfig and limit <= self.partBaseConfig.maxstar then
            local tempmsg = self.Entry[i]
            temp:SetData(limit, tempmsg,i)
            table.insert(self.Reform, temp)
        end
    end
    --}}}
end
---@param curInherit[]
function ArticleCell:SetPartInherit(curInherit)
    --{{{传承数据
    ---@type PartInheritData[]
    self.PartInheritList = {}
    ---@type PartInheritData[]
    self.PartInheritDic = {}
    if curInherit then
        for i = 1, #curInherit do
            local temp = PartInheritData()
            temp:SetData(curInherit[i])
            self.PartInheritDic[temp.InheritId] =temp
            table.insert(self.PartInheritList, temp)
        end
    end
    --}}}
end
function ArticleCell:UpdateBuff()
    self.ShellBuffs = {}
    if self.partBaseConfig and self.partBaseConfig.NewSkillIds then
        local ids = self.partBaseConfig.NewSkillIds
        for i = 1, #ids do
            if ids[i] > 0 then
                local data = ShellBuffData()
                data:SetData(ids[i])
                table.insert(self.ShellBuffs, data)
            end
        end
    end
end

function ArticleCell:UpdateFiveAttrs()
    --解析五维属性
    self.FiveAttrs = {}
    ---@type dictcalc_config_cell
    local calc=CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config,CommonCfgKey.CarFiveAttr)
    local fiveAttrId=stringSplitToNumber(calc.varval,':')
    for k, v in pairs(fiveAttrId) do
        local data = PartAttrData()
        table.insert(self.FiveAttrs, data)
        local startValue=0
        if self.GenCfgCell and self.GenCfgCell.NewAttr[v] then
            startValue=self.GenCfgCell.NewAttr[v].value
        end
        data:SetData(v, CommonHelper:AttrFormulaCalculate(v, startValue, self.PartAttrs, self.partBaseConfig))
    end
end

function ArticleCell:UpdateSecondAttrs()
    --解析二级属性
    self.SecondAttrs = {}
    for k, v in pairs(self.GenCfgCell.NewAttr) do
        local type = k
        local basevalue = v
        local lvupcfg = nil
        for m = 1, #self.GenCfgCell.NewLevelUpAttr do
            if self.GenCfgCell.NewLevelUpAttr[m].type == type then
                lvupcfg = self.GenCfgCell.NewLevelUpAttr[m]
                break
            end
        end
        local value=0
        if self.PartAttrs[type] then
            value=self.PartAttrs[type].value
        end
        local data = PartAttrData()
        data:SetData(type, value, lvupcfg, basevalue)
        table.insert(self.SecondAttrs, data)
    end
    if self:GetAwaken() then
       ---@type PartBreakCfg
       local data= self.GenCfgCell._NewBreakAttr
        for i = 1, #data.attrtypes do
            local type=data.attrtypes[i]
            local flag=true
            for j = 1, #self.SecondAttrs do
                if self.SecondAttrs[j].type==type then
                    flag=false
                    break
                end
            end
            if flag then
                local value=0
                if self.PartAttrs[type] then
                    value=self.PartAttrs[type].value
                end
                local temp = PartAttrData()
                temp:SetData(type, value, nil, 0)
                table.insert(self.SecondAttrs, temp)
            end
        end
    end
    local extendAttr= stringSplitToNumber(CommonHelper:GetDictCalcData(CommonCfgKey.ExtendSecondAttr,true),',')
    for k, v in pairs(extendAttr) do
        local type = v
        local basevalue = 0
        local lvupcfg = nil
        local value=0
        if self.PartAttrs[type] then
            value=self.PartAttrs[type].value
        end
        local flag=true
        for i = 1, #self.SecondAttrs do
            if type==self.SecondAttrs[i].type then
                flag=false
                break
            end
        end
        if value>0 and flag then
            local data = PartAttrData()
            data:SetData(type, value, lvupcfg, basevalue)
            table.insert(self.SecondAttrs, data)
        end
    end
end
function ArticleCell:UpdateReferenceAttrs()
    --解析参考属性
    self.ReferenceAttrs = {}
    for i = 1, #self.partConfig.NewSpecialAttr do
        local temp = self.partConfig.NewSpecialAttr[i]
        local data = PartAttrData()
        data:SetData(temp.type, CommonHelper:AttrFormulaCalculate(temp.type, temp.value, self.PartAttrs, self.partConfig))
        table.insert(self.ReferenceAttrs, data)
    end
end
---@param msg SC_UserProp
function ArticleCell:OnInitProp(msg,new)
    self.Rid=msg.rid
    self.CfgId=msg.propid
    self.Num=msg.propnum
    self.Type=PropType.Article
    ---@type dictarticle_config_cell
    self.articleConfig=CommonHelper:GetTableDataByID(ConfigNames.article_config,self.CfgId)
    self.flagNew=new
    self:UpdateNew()
end
function ArticleCell:UpdateFeature()
    --解析配件特性
    self.FeatureList = {}
    for i = 1, #self.partBaseConfig.NewAttrFeature do
        local temp = self.partBaseConfig.NewAttrFeature[i]
        if temp~=-1 then
            ---@type attrfeature_config_cell
            local feature = CommonHelper:GetTableDataByID(ConfigNames.attrfeature_config, temp)
            local value=0
            if self.PartAttrs[feature.attr] then
                value=self.PartAttrs[feature.attr].value
            end
            local data = PartFeatureData()
            data:SetData(self, feature, value)
            table.insert(self.FeatureList, data)
        end
    end
    table.sort(self.FeatureList, function(a,b) return a:GetFeatureType() < b:GetFeatureType() end)
end
function ArticleCell:UpdateScore()
    --解析评分
    self.ScoreAttrs = {}
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.PartScore)
    local list = stringSplitToNumber(cfg.varval, ':')
    for i = 1, #list do
        local type = list[i]
        self.ScoreAttrs[type] = 0
    end
    for i = 1, #self.FiveAttrs do
        local type = self.FiveAttrs[i].type
        if self.ScoreAttrs[type] ~= nil then
            self.ScoreAttrs[type] = self.FiveAttrs[i].value
        end
    end

    self.Score = self.partConfig.score
    for i, v in pairs(self.ScoreAttrs) do
        self.Score = self.Score + v
    end
end


function ArticleCell:SetCellId(id) self.CellId=id end
function ArticleCell:SetUserCarId(carid)          self.CarId = carid end
function ArticleCell:SetCount(number)          self.Num = number self:UpdateNew() end
function ArticleCell:SetAwaken(value) self.Awaken=value end
function ArticleCell:UpdatePartLightweight(value)
    self.Grid={0,0,0,0,0} --纱网数据
    self.Hole={true,true,true,true,true} --打孔数据
    for i = 1, #value do
        self.Grid[i]=value[i]
        self.Hole[i]=value[i]<=1 -->1 的话未打孔 正常显示
    end
end
function ArticleCell:UpdatePartShellColor(value)    self.Color=value  end
function ArticleCell:UpdatePartShellSticker(value)  self.Sticker=value  end




function ArticleCell:GetCellID()        return self.CellId end
function ArticleCell:GetID()            return self.CfgId end
function ArticleCell:GetChangeIdx()            return self.ChangeCellId end
function ArticleCell:GetRID()           return self.Rid end
function ArticleCell:GetCount()           return self.Num end
function ArticleCell:GetType()          return self.Type end
function ArticleCell:GetIsNew()      return self.flagNew end
function ArticleCell:GetStar()         return self.Star end
function ArticleCell:GetSticker()         return self.Sticker end
function ArticleCell:GetAwaken()         return self.Awaken end
function ArticleCell:GetCanAwaken()         return #self:GetPartBreakCfg().breakvalues > 0 end
function ArticleCell:GetColor()         return self.Color end
function ArticleCell:GetHole()         return self.Hole end
function ArticleCell:GetPartAttrs()         return self.PartAttrs end
function ArticleCell:GetEntry()         return self.Entry end
---@return dictarticle_config_cell
function ArticleCell:GetArticleConfig() return self.articleConfig end
---@return dictparts_config_cell
function ArticleCell:GetPartConfig()    return self.partConfig end
---@return dictpartbase_config_cell
function ArticleCell:GetPartBaseCfg()    return self.partBaseConfig end
function ArticleCell:GetPartType()    return self.partBaseConfig.parttype end
function ArticleCell:GetPartSubType()    return self.partBaseConfig.subtype end
function ArticleCell:GetPartQuality()   return self.partBaseConfig.fabric end
---@return dictpartage_config_cell
function ArticleCell:GetGeneration()   return self.Generation end
function ArticleCell:GetPartChassisLimit()   return self.partBaseConfig.NewChassisLimit end
function ArticleCell:GetPartComposeIds() return {} end
function ArticleCell:GetPartLightweight()   return self.Hole  end
function ArticleCell:GetPartShellGridList() return self.Grid  end
function ArticleCell:GetPartShellColor()    return self.Color  end
function ArticleCell:GetPartShellSticker()  return self.Sticker  end
function ArticleCell:GetPartChangeLightweight()   return self.ChangeHole  end
function ArticleCell:GetPartChangeShellGridList() return self.ChangeGrid  end
function ArticleCell:GetPartChangeShellColor()    return self.ChangeColorid  end
function ArticleCell:GetPartChangeShellSticker()  return self.ChangeStickerid  end
function ArticleCell:GetPartLV()          return self.Level end
function ArticleCell:GetCarId()         return self.CarId end
function ArticleCell:GetPartLock()          return self.PartLock end
function ArticleCell:GetPartFeatureList()    return self.FeatureList end
function ArticleCell:GetPartShellBuffs()    return self.ShellBuffs end
function ArticleCell:GetPartScore()          return self.Score end
function ArticleCell:GetCanUpGeneration()          return self.Generation<self.MaxGeneration end
function ArticleCell:GetPartSource()          return self.Source end
function ArticleCell:GetPartDownType()          return self.DownType end
function ArticleCell:GetPartHireNum()          return self.HireNum end
function ArticleCell:GetPartExpTime()          return self.ExpTime end
function ArticleCell:GetPartIfUse()          return self.IfUse end
function ArticleCell:GetCanUpGeneration()          return self.Generation<self.MaxGeneration end
function ArticleCell:GetCanUpGeneration()          return self.Generation<self.MaxGeneration end
function ArticleCell:GetCanUpGeneration()          return self.Generation<self.MaxGeneration end

function ArticleCell:GetPartBreakCfg()        return self.GenCfgCell._NewBreakAttr end
function ArticleCell:GetPartBreakCostCfg()        return self.GenCfgCell._NewBreakCost end
function ArticleCell:GetPartBreakCostGold()        return self.GenCfgCell.breakgold end
---@return dictpartage_config_cell[]
function ArticleCell:GetGenerationAttrList()        return self.GenerationListData end
---@return dictpartage_config_cell
function ArticleCell:GetCurGenerationData()        return self.GenCfgCell end
function ArticleCell:GetPartInheritCount()        return self.partBaseConfig.inheritnum end
function ArticleCell:GetCurPartInheritList()        return self.PartInheritList end
function ArticleCell:GetInheritById(id)        return self.PartInheritDic[id] end
function ArticleCell:GetInheritExp()
    if self.Type==PropType.Part then
       return self.partBaseConfig.inheritexp
    end
    if self.Type==PropType.Article then
       return self.articleConfig.propsadd
    end
end


---@return PartReformData
function ArticleCell:GetPartReform(idx)    return self.Reform[idx] end
function ArticleCell:GetPartReformByEntryId(id)
    local result=nil
    for i = 1, #self.Reform do
        if self.Reform[i].id==id then
            result=self.Reform[i]
            break
        end
    end
    return result
end
function ArticleCell:IsExp()
    if self.DownType>PartDownType.Self and self.ExpTime~=0 then
        return CommonHelper:GetNowTime()>self.ExpTime
    end
    return false
end
function ArticleCell:GetPartFiveAttrs()      return self.FiveAttrs end
function ArticleCell:GetPartSecondAttrs()    return self.SecondAttrs end
function ArticleCell:GetPartReferenceAttrs() return self.ReferenceAttrs end
function ArticleCell:IsPart()           return self.Type == PropType.Part end
---@return table<number, PartReformData>
function ArticleCell:GetPartReformList()   return self.Reform end
--}}}




function ArticleCell:GetArticleID()     return self.msgData.articleId end
function ArticleCell:UpdatePartStar(star)           self.Star = star end

function ArticleCell:GetPartStar()      return self.PartData.Star end
function ArticleCell:IsNew()           return   self.flagNew end
function ArticleCell:SetNew(flag)
    local isUpdata=self.flagNew~=flag
    self.flagNew=flag
    if isUpdata then
        KnapsackDataManager:Get():SetRedPointData()
    end
end
function ArticleCell:UpdatePartLV(lv)               self.Level = lv end
function ArticleCell:UpdatePartLock(value)          self.PartLock = value end
---@return ShellBuffData
function ArticleCell:GetPartShellBuffByID(id)
    for i = 1, #self.ShellBuffs do
        local temp = self.ShellBuffs[i]
        if temp.id == id then
            return temp
        end
    end
    return nil
end
---@return table<number, PartAttrData>
function ArticleCell:GetPartAttrList()
    ---@type table<number, PartAttrData>
    local result = {}
    for k,v in pairs(self.PartAttrs) do
        table.insert(result, v)
    end
    table.sort(result, function(a, b)
        return a.type < b.type
    end)
    return result
end

function ArticleCell:GetPartAttr(type)
    local data = self.PartAttrs[type]
    if data then
        return data.value
    end
    return 0
end
function ArticleCell:GetPartReformTypeCount(id) --配件改造词条的个数
    local result = 0
    for i = 1, #self.Reform do
        if self.Reform[i].id == id then
            result = result + 1
        end
    end
    return result
end
function ArticleCell:GetPartStrongLv() --配件强化等级
    local result = 0
    for i = 1, #self.Reform do
        if self.Reform[i].lv > -1 and self.Reform[i].id > 0 then
            result = result + self.Reform[i].lv
        end
    end
    return result
end

function ArticleCell:GetPartReformPosCount(star) --配件开启的改造槽位个数
    local result = 0
    for i = 1, #self.Reform do
        local data = self.Reform[i]
        if data:IsOpen(star) then
            result = result + 1
        end
    end
    return result
end

function ArticleCell:GetPartIsReform() --配件是否改造过
    local result = false
    for i = 1, #self.Reform do
        local data = self.Reform[i]
        if data:IsReform() then
            result = true
            break
        end
    end
    return result
end

--function ArticleCell:GetPartReformSucceedCount() --配件改造成功的槽位个数
--    local result = 0
--    for i = 1, #self.PartData.Reform do
--        if self.PartData.Reform[i].id > 0 then
--            result = result + 1
--        end
--    end
--    return result
--end
function ArticleCell:IsPartUsing()
    if self:IsPart() then
        return self.CarId >  0
    end
    return false
end
function ArticleCell:IsPartLock()
    if self:IsPart() then
        return self.PartLock > 0
    end
    return false
end
function ArticleCell:IsChange()
    return self:GetAwaken() or self:GetStar()>1 or self:GetPartLV()>1 or self:GetGeneration()>1 or #self:GetCurPartInheritList()>0 or  self:IsPartLock() or  self:IsPartUsing()
end

function ArticleCell:IsChangeNoUsing()
    return (self:GetAwaken() or self:GetStar()>1 or self:GetPartLV()>1 or self:GetGeneration()>1 or #self:GetCurPartInheritList()>0 or  self:IsPartLock()) and  not self:IsPartUsing()
end





function ArticleCell:UpdateNew()
   local localData= PlayerPrefsHelper:GetValue_Bag(self:GetCellID())
    local temp=false
    if self.Type==PropType.Part then
        if localData==0 then
            temp=true
        end
        if localData==self:GetID() then
            temp=false
        else
            temp=true
        end
        if temp or self.flagNew then
            self.flagNew=true
        else
            self.flagNew=false
        end
        if self.flagNew then
            self.flagNew=not self:IsPartUsing()
        end
        if self.flagNew then
            PlayerPrefsHelper:SetValue_Bag(self:GetCellID(),self:GetID())
        end
    else
        self.flagNew=false
    end

end