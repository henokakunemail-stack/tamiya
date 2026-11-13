
---prefab,车库-组装图


local _IdxBase = 0--基础
local _IdxPullay1 = 1--一层导轮
local _IdxExtr = 2--扩展位
local _IdxPullay2 = 3--二层导轮
local _IdxPullay0 = 4--二层导轮
local _IdxExtr2 = 5--扩展位
--local _IdxPullay3 = 5
local _IdxOther = 6--增强位

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

_GrooveGroup[_IdxPullay0] = {}
_GrooveGroup[_IdxPullay0][1] = PartGrooveID.PulleyFrontMinus
_GrooveGroup[_IdxPullay0][2] = PartGrooveID.PulleyRearMinus

_GrooveGroup[_IdxExtr2] = {}
_GrooveGroup[_IdxExtr2][1] = PartGrooveID.Front2
_GrooveGroup[_IdxExtr2][2] = PartGrooveID.Front3
_GrooveGroup[_IdxExtr2][3] = PartGrooveID.FrontExtr2
_GrooveGroup[_IdxExtr2][4] = PartGrooveID.FrontExtr3
_GrooveGroup[_IdxExtr2][5] = PartGrooveID.Rear2
_GrooveGroup[_IdxExtr2][6] = PartGrooveID.Rear3
_GrooveGroup[_IdxExtr2][7] = PartGrooveID.RearExtr2
_GrooveGroup[_IdxExtr2][8] = PartGrooveID.RearExtr3

--_GrooveGroup[_IdxPullay3] = {}
--_GrooveGroup[_IdxPullay3][1] = PartGrooveID.PulleyShell

_GrooveGroup[_IdxOther] = {}
_GrooveGroup[_IdxOther][1] = PartGrooveID.Strong1
_GrooveGroup[_IdxOther][2] = PartGrooveID.Strong2
_GrooveGroup[_IdxOther][3] = PartGrooveID.Strong3
_GrooveGroup[_IdxOther][4] = PartGrooveID.Strong4
_GrooveGroup[_IdxOther][7] = PartGrooveID.Strong5
_GrooveGroup[_IdxOther][8] = PartGrooveID.Strong6
_GrooveGroup[_IdxOther][9] = PartGrooveID.Strong7
_GrooveGroup[_IdxOther][10] = PartGrooveID.Strong8
--_GrooveGroup[_IdxOther][6] = PartGrooveID.Strong6
--_GrooveGroup[_IdxOther][7] = PartGrooveID.Strong7
--_GrooveGroup[_IdxOther][8] = PartGrooveID.Strong8
_GrooveGroup[_IdxOther][5] = PartGrooveID.FBrake
_GrooveGroup[_IdxOther][6] = PartGrooveID.BBrake

---@class MiniCarInfoView : ViewBase
MiniCarInfoView = class("MiniCarInfoView", ViewBase)

function MiniCarInfoView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "MiniCarInfoViewAction")
end

function MiniCarInfoView:Awake()

    CommonHelper:HButtonSetCallback("BtnCloseMask2",self.gameObject,function(data)
        UIManager:Get():ClosePopup()
    end)
    self.PageRootDetail=self:GetChild("partdetailroot")
    self.Pre_CarView={[_IdxBase]=self:GetChild("basegroup"),
                      [_IdxPullay1]=self:GetChild("pullay1"),
                      [_IdxExtr]=self:GetChild("extrgroup"),
                      [_IdxPullay2]=self:GetChild("pullay2"),
                      [_IdxPullay0]=self:GetChild("pullay0"),
                      [_IdxExtr2]=self:GetChild("extrgroup2"),
                      [_IdxOther]=self:GetChild("othergroup")}
end

function MiniCarInfoView:OnOpen()

end

function MiniCarInfoView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.MiniCarInfoView)

end
function MiniCarInfoView:SetData(param)
    self.GrooveList = {}
    self:SetArticleData(param)

end
function MiniCarInfoView:CreateGrooveUIData(grooveid, cfgid, star, quality, enable,generation)
    local temp = PreGarageAssembleMap_GrooveUI()
    ---@type dictparts_config_cell
    local cfg = (cfgid > 0) and CommonHelper:GetTableDataByID(ConfigNames.parts_config, cfgid) or nil
    if cfg then
        temp:SetData(grooveid, cfg, star, cfg.quality, enable,nil,nil,nil,nil,generation,PartDownType.Self,PartSourceType.Self,0 )
    else
        temp:SetData(grooveid, cfg, star, quality, enable,nil,nil,nil,nil,generation,PartDownType.Self,PartSourceType.Self,0 )
    end
    print("MiniCarInfoView"..grooveid)
    self.GrooveList[grooveid] = temp
end
---@param data CarReviewData
function   MiniCarInfoView:SetArticleData(data)
    local parts = data:GetPartList()
    for k, v in pairs(parts) do
        if v.PartCfgID>0 then
            if AssembleHelper:MsgIdxToGrooveID(k)==PartGrooveID.Shell then
                self:CreateGrooveUIData(AssembleHelper:MsgIdxToGrooveID(k),v.PartOrgCfgID, v.PartStar,v.PartQuality, true,v.PartGeneration)
            else
                self:CreateGrooveUIData(AssembleHelper:MsgIdxToGrooveID(k),v.PartCfgID, v.PartStar,v.PartQuality, true,v.PartGeneration)
            end

        end
    end
    self:SetUI()
end
function MiniCarInfoView:SetUI()
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("CustomScrollViewTtoM", self.gameObject, typeof(CustomScrollView))

    local data = {_IdxBase, _IdxPullay1, _IdxExtr, _IdxPullay2,_IdxPullay0, _IdxExtr2, _IdxOther}
    for i = 1, #data do
        self:UpdateItem(self.Pre_CarView[data[i]],data[i])
    end
end

function    MiniCarInfoView:UpdateItem(itemObj,index)
    local temp = _GrooveGroup[index]
    for i = 1, #temp do
        local grooveid = temp[i]
        local data = self.GrooveList[grooveid]
        local obj = UIUtil.GetChild(tostring(grooveid),itemObj)
        if data then
            CommonHelper:SetGameObjectActive("part", obj, data.grooveEnbale == true and data.partCfg ~= nil)
            CommonHelper:SetGameObjectActive("open", obj, data.grooveEnbale == true and data.partCfg == nil)
            CommonHelper:SetGameObjectActive("lock", obj, data.grooveEnbale == false)

            if data.grooveEnbale and data.partCfg then
                --CommonHelper:GetComponentSetUITexture("icon", obj,data.partCfg.icon, UIModuleID.MiniCarInfoView)
                --for i = 0, 5 do
                --    CommonHelper:SetGameObjectActive("itemquality_color_"..i,obj,data.partQuality-1==i)
                --end
                local param= Param_ItemPartParam()
                param.generation=data.generation
                CommonHelper:SetItemPartGroup(obj,UIModuleID.MiniCarInfoView,data.partCfg.C_ID,ItemPartUIType.Simple,param,function(id)
                    CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.MiniCarInfoView)
                end,data.partCfg.C_ID)
                CommonHelper:SetGameObjectActive("ItemPartlist", obj,  true)
            else
                CommonHelper:SetGameObjectActive("ItemPartlist", obj,  false)
            end
        else
            CommonHelper:SetGameObjectActive("ItemPartlist", obj,  false)
        end
    end
end

