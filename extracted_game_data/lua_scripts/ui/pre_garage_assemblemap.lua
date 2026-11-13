
---prefab,车库-组装图


local _IdxBase = 0--基础
local _IdxPullay1 = 1--一层导轮
local _IdxExtr = 2--扩展位
local _IdxPullay2 = 3--二层导轮
local _IdxTopRail = 4--二层导轮
local _IdxPullay0 = 5--负一层导轮
local _IdxExtr2 = 6--扩展位
--local _IdxPullay3 = 5
local _IdxOther = 7--增强位

local _GrooveGroup = {}
_GrooveGroup[_IdxBase] = {}
_GrooveGroup[_IdxBase][ 1] = PartGrooveID.Chassis
_GrooveGroup[_IdxBase][ 2] = PartGrooveID.Shell
_GrooveGroup[_IdxBase][ 3] = PartGrooveID.FHub
_GrooveGroup[_IdxBase][ 4] = PartGrooveID.BHub
_GrooveGroup[_IdxBase][ 5] = PartGrooveID.BTyre
_GrooveGroup[_IdxBase][ 6] = PartGrooveID.FTyre
_GrooveGroup[_IdxBase][ 7] = PartGrooveID.Motor
_GrooveGroup[_IdxBase][ 8] = PartGrooveID.Gears
_GrooveGroup[_IdxBase][ 9] = PartGrooveID.Head
_GrooveGroup[_IdxBase][10] = PartGrooveID.Wing
_GrooveGroup[_IdxBase][11] = PartGrooveID.Tail
_GrooveGroup[_IdxBase][12] = PartGrooveID.RearWing

_GrooveGroup[_IdxPullay1] = {}
_GrooveGroup[_IdxPullay1][1] = PartGrooveID.PulleyFrontButtom
_GrooveGroup[_IdxPullay1][2] = PartGrooveID.PulleyMiddleButtom1
_GrooveGroup[_IdxPullay1][3] = PartGrooveID.PulleyRearButtom

_GrooveGroup[_IdxExtr] = {}
_GrooveGroup[_IdxExtr][1] = PartGrooveID.Front
_GrooveGroup[_IdxExtr][2] = PartGrooveID.Middle
_GrooveGroup[_IdxExtr][3] = PartGrooveID.Rear

_GrooveGroup[_IdxPullay2] = {}
_GrooveGroup[_IdxPullay2][1] = PartGrooveID.PulleyFrontCenter
_GrooveGroup[_IdxPullay2][2] = PartGrooveID.PulleyMiddleCenter
_GrooveGroup[_IdxPullay2][3] = PartGrooveID.PulleyRearCenter

_GrooveGroup[_IdxTopRail] = {}
_GrooveGroup[_IdxTopRail][1] = PartGrooveID.TopRailFront
_GrooveGroup[_IdxTopRail][2] = PartGrooveID.TopRailRear


_GrooveGroup[_IdxPullay0] = {}
_GrooveGroup[_IdxPullay0][1] = PartGrooveID.PulleyFrontMinus
_GrooveGroup[_IdxPullay0][2] = PartGrooveID.PulleyRearMinus


_GrooveGroup[_IdxExtr2] = {}
_GrooveGroup[_IdxExtr2][1] = PartGrooveID.Front2
_GrooveGroup[_IdxExtr2][2] = PartGrooveID.Front3
_GrooveGroup[_IdxExtr2][3] = PartGrooveID.Rear2
_GrooveGroup[_IdxExtr2][4] = PartGrooveID.Rear3
_GrooveGroup[_IdxExtr2][5] = PartGrooveID.FrontExtr2
_GrooveGroup[_IdxExtr2][6] = PartGrooveID.RearExtr2
--_GrooveGroup[_IdxExtr2][7] = PartGrooveID.FrontExtr3
--_GrooveGroup[_IdxExtr2][8] = PartGrooveID.RearExtr3

--_GrooveGroup[_IdxPullay3] = {}
--_GrooveGroup[_IdxPullay3][1] = PartGrooveID.PulleyShell

_GrooveGroup[_IdxOther] = {}
_GrooveGroup[_IdxOther][1] = PartGrooveID.Strong1
_GrooveGroup[_IdxOther][2] = PartGrooveID.Strong2
_GrooveGroup[_IdxOther][3] = PartGrooveID.Strong3
_GrooveGroup[_IdxOther][4] = PartGrooveID.Strong4
_GrooveGroup[_IdxOther][5] = PartGrooveID.Strong5
_GrooveGroup[_IdxOther][6] = PartGrooveID.Strong6
_GrooveGroup[_IdxOther][7] = PartGrooveID.Strong7
_GrooveGroup[_IdxOther][8] = PartGrooveID.Strong8
--_GrooveGroup[_IdxOther][5] = PartGrooveID.FBrake
--_GrooveGroup[_IdxOther][6] = PartGrooveID.BBrake



---@class PreGarageAssembleMap_GrooveUI
PreGarageAssembleMap_GrooveUI = class("PreGarageAssembleMap_GrooveUI")
function PreGarageAssembleMap_GrooveUI:initialize()
    self.grooveid = -1
    ---@type dictparts_config_cell
    self.partCfg = nil
    ---@type grooveid_config_cell
    self.grooveCfg=nil
    self.partStar = 1
    self.partQuality = 1
    self.grooveEnbale = true
    self.partLv = 0
    self.partUsing = -1
    self.partLock = -1
    self.awake = false
    self.generation=1
    self.downType=PartDownType.Self
    self.source=PartSourceType.Self
    self.expireTime=0
    self.redflag=false
end
function PreGarageAssembleMap_GrooveUI:SetData(grooveid, cfg, star, quality, state, lv, using, lock,awake,generation,downType,source,expireTime,redflag)
    if lv == nil then lv = -1 end
    if using == nil then using = -1 end
    if lock == nil then lock = -1 end

    self.grooveid = grooveid
    self.partCfg = cfg
    self.partStar = star
    self.partQuality = quality
    self.grooveEnbale = state
    self.partLv = lv
    self.partUsing = using
    self.partLock = lock
    self.awake=awake
    self.generation=generation
    self.downType=downType
    self.source=source
    self.expireTime=expireTime
    self.redflag=redflag
    self.grooveCfg=CommonHelper:GetTableDataByID(ConfigNames.grooveid_config,self.grooveid)
end


---@class PreGarageAssembleMap
PreGarageAssembleMap = class("PreGarageAssembleMap")

function PreGarageAssembleMap:initialize()
    ---@type table<number, PreGarageAssembleMap_GrooveUI>
    self.GrooveList = {}

    self.ModuleId = UIModuleID.None
    self.FuncClickItem = nil
end

function PreGarageAssembleMap:CreateGrooveUIData(grooveid, cfgid, star, quality, enable, lv, using, lock,awake,generation,downType,source,expireTime,redflag)
    local temp = PreGarageAssembleMap_GrooveUI()
    local cfg = (cfgid > 0) and CommonHelper:GetTableDataByID(ConfigNames.parts_config, cfgid) or nil
    temp:SetData(grooveid, cfg, star, quality, enable ,lv, using, lock,awake,generation,downType,source,expireTime,redflag)
    self.GrooveList[grooveid] = temp
end


function PreGarageAssembleMap:SetUI(root, selectgroove, isresetPos)
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("CustomScrollViewTtoM", root, typeof(CustomScrollView))

    local data = {_IdxBase, _IdxPullay1, _IdxExtr, _IdxPullay2,_IdxTopRail,_IdxPullay0 ,_IdxExtr2, _IdxOther}
    CommonHelper:CustomView_Init(self.ScrollView, data, function(index, itemObj, scroll)
        self:UpdateScrollView(index,itemObj,scroll)
    end, isresetPos)

    self:AutoToItem(selectgroove)
end

function PreGarageAssembleMap:
UpdateScrollView(index, itemObj, scroll)
    local temp = _GrooveGroup[index]

    for i = 1, #temp do
        local grooveid = temp[i]
        local data = self.GrooveList[grooveid]
        local obj = UIUtil.GetChild(tostring(data.grooveid),itemObj)

        CommonHelper:SetGameObjectActive("groovepart", obj, (data.grooveEnbale==GrooveState.UnLock or data.grooveEnbale==GrooveState.NoMatching)  and data.partCfg ~= nil)
        CommonHelper:SetGameObjectActive("groovenomatching", obj, data.grooveEnbale==GrooveState.NoMatching and data.partCfg ~= nil)
        CommonHelper:SetGameObjectActive("RedPointPart", obj, data.redflag and  (data.grooveEnbale==GrooveState.UnLock or data.grooveEnbale==GrooveState.NoMatching))
        local noOpen= CommonHelper:SetGameObjectActive("grooveopen", obj, data.grooveEnbale==GrooveState.UnLock  and data.partCfg == nil)
        local lock= CommonHelper:SetGameObjectActive("groovelock", obj, data.grooveEnbale==GrooveState.Lock )
        CommonHelper:GetComponentSetUITexture("defaulticon",noOpen,data.grooveCfg.bgicon,self.ModuleId)
        CommonHelper:GetComponentSetUITexture("defaulticon",lock,data.grooveCfg.bgicon,self.ModuleId)
        if data.grooveEnbale and data.partCfg then

            local itemobj = UIUtil.GetChild("groovepart", obj)
            local param = Param_ItemPartParam()
            param.quality = data.partQuality
            param.star = data.partStar
            param.lv = data.partLv
            param.using = data.partUsing
            param.lock = data.partLock
            param.awaken=data.awake
            param.generation=data.generation
            param.downType=data.downType
            param.source = data.source
            param.expireTime = data.expireTime
            CommonHelper:SetItemPartGroup(itemobj, self.ModuleId, data.partCfg.C_ID, ItemPartUIType.Normal, param)
        end

        CommonHelper:HButtonSetCallback("groovebtn", obj,function (hbtn)
            if self.FuncClickItem then self.FuncClickItem(hbtn.intData) end
        end, grooveid)
    end
end

function PreGarageAssembleMap:AutoToItem(selectgroove)
    if selectgroove then
        for k,v in pairs(_GrooveGroup) do
            for i = 1, #v do
                if v[i] == selectgroove then
                    CommonHelper:CustomView_ScrollToItem(self.ScrollView, k)
                    break
                end
            end
        end
    end
end


























--{{{接口
---@param cardata CarData
---@param KnapsackData KnapsackData
function PreGarageAssembleMap:SetDataByCarData(uimoduleid, obj, cardata, selectgroove,isresetPos, func,KnapsackData)
    self.ModuleId = uimoduleid
    self.GrooveList = {}
    self.FuncClickItem = func

    for k, v in pairs(PartGrooveID) do
        local groove = cardata.assembleMgr:GetNodeByGrooveID(v)
        if groove then
            local cfgid = groove:GetPartId(false)
            local article = KnapsackData:GetArticleByCellID(groove:GetBagId())
            local star = article and article:GetStar() or 1
            local qulity = article and article:GetPartQuality() or 1
            local lv = article and article:GetPartLV() or 1
            local using = article and article:GetCarId() or 0
            local lock = article and article:GetPartLock() or 0
            local awake = article and article:GetAwaken() or false
            local generation = article and article:GetGeneration() or 1
            local downType = article and article:GetPartDownType() or PartDownType.Self
            local source = article and article:GetPartSource() or PartSourceType.Self
            local  extime= article and article:GetPartExpTime() or 0
            local  redflag=groove:GetRedFlag()
            self:CreateGrooveUIData(v, cfgid, star, qulity, groove:GetGrooveState(), lv, using, lock,awake,generation,downType,source,extime,redflag)
        end
    end

    self:SetUI(obj, selectgroove, isresetPos)
end
---@param list table<number, SC_PartInfo>
function PreGarageAssembleMap:SetDataByMsgPartInfo(uimodule, obj, list, func)

end
---@param data CarReviewData
function PreGarageAssembleMap:SetDataByCarReview(uimodule, obj, data, func,selectgroove,isresetPos)
    self.ModuleId = uimodule
    self.GrooveList = {}
    self.FuncClickItem = func

    local parts = data:GetPartList()
    for i = 1, #parts do

        self:CreateGrooveUIData(AssembleHelper:MsgIdxToGrooveID(i),parts[i].PartCfgID, parts[i].PartStar,parts[i].PartQuality, parts[i].PartCfgID>0 and GrooveState.UnLock or GrooveState.Lock,parts[i].PartLevel,PartDownType.Self,PartSourceType.Self,false)

    end
    self:SetUI(obj,selectgroove,isresetPos)
end
function PreGarageAssembleMap:SetDataBySuitId(uimodule, obj, suitid, func)--套装id

end
--}}}

