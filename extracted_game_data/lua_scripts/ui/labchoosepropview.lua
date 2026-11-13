---@class LabChoosePropView : ViewBase
LabChoosePropView = class("LabSelectPopView", ViewBase)

function LabChoosePropView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "LabChoosePropViewAction")
    self.chooseData = {}
end
local _List = nil
local _CallBack = nil
function LabChoosePropView:Awake()
    self.BtnClose = CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)

    self.leftPartSVC = self:GetChildWightByParent("leftPartSVC", self.gameObject, typeof(MoreRowScrollView))
    self.ArticleSVC = self:GetChildWightByParent("ArticleSVC", self.gameObject, typeof(MoreRowScrollView))

    self.EnsureResolveBtn = CommonHelper:HButtonSetCallback("EnsureResolveBtn", self.gameObject, function(data)
        local boxFunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, CommonHelper:GetTempStr_Default(TemplateStringID.LabChoosePropTips))
            if ret == MessageBoxHelp.BtnType.OK then
                if _CallBack then
                    _CallBack(self.CurSelectPart:GetCellID())
                end
                UIManager:Get():ClosePopup()
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    end)
end

---@param list ArticleCell[]
function LabChoosePropView:SetData(list, callBack)
    self.selectItemID = 0
    _CallBack = callBack
    _List = list
    ---@type ArticleCell
    self.CurSelectPart = list[1]
    self:SetPartListScrollView()
    self:RefreshRightInfo(self.CurSelectPart)
end

function LabChoosePropView:SetPartListScrollView()
    CommonHelper:InitMoreRowScrollView(self.leftPartSVC, #_List, 6, function(dataIndex, itemObj, scroll)
        local obj = UIUtil.GetChild("ItemPart_138", itemObj)
        ---@type ArticleCell
        local _data = _List[dataIndex + 1]
        local param = Param_ItemPartParam()
        param.star = _data:GetStar()
        param.lv = _data:GetPartLV()
        param.using = _data:GetCarId()
        param.lock = _data:GetPartLock()
        param.awaken = _data:GetAwaken()
        param.generation = _data:GetGeneration()
        param.downType = _data:GetPartDownType()
        param.source = _data:GetPartSource()
        param.expireTime = _data:GetPartExpTime()
        CommonHelper:SetItemPartGroup(obj, UIModuleID.LabChooseProp, _data:GetID(), ItemPartUIType.Normal, param, function(data)
            if self.CurSelectPart:GetCellID() ~= data:GetCellID() then
                self.CurSelectPart = data
                CommonHelper:MoreRowView_RefreshCurList(self.leftPartSVC, false)
                self:RefreshRightInfo(self.CurSelectPart)
            end
        end, _data)
        CommonHelper:SetGameObjectActive("chooseShow", itemObj, self.CurSelectPart:GetCellID() == _data:GetCellID())
    end)
end
---@param _Data ArticleCell
function LabChoosePropView:RefreshRightInfo(_Data)
    local part = UIUtil.GetChild("partview", self.gameObject)
    local cfg = _Data:GetPartConfig()
    CommonHelper:SetText("###articleName", part, ClientDataManager:Get():GetTemplateString(cfg.partname))
    CommonHelper:GetComponentSetUITexture("partIcon", part, cfg.icon, UIModuleID.LabChooseProp)
    CommonHelper:SetText("scroes/###value", part, string.format("%0.0f", _Data:GetPartScore()))
    CommonHelper:SetText("###level", part, CommonHelper:GetTempStr_Default(TemplateStringID.BagPartLevel, _Data:GetPartLV()))
    CommonHelper:SetComponentPartStar("PartStar", part, _Data:GetStar())
    --{{{ 属性
    ---@type table<number, PartAttrData>
    local attrlist = {}
    local templist = _Data:GetPartSecondAttrs()
    for i = 1, #templist do
        if not CommonHelper:PartAttrShowValueEqualZero(templist[i].value) then
            table.insert(attrlist, templist[i])
        end
    end
    for i = 1, 8 do
        local temp = attrlist[i]
        local obj = CommonHelper:SetGameObjectActive("grid/attr" .. i, part, temp ~= nil)
        if temp then
            CommonHelper:SetText("###key", obj, CommonHelper:GetAttrName(temp.type))
            CommonHelper:SetText("###value", obj, CommonHelper:GetAttrValue(temp.type, temp.value))
            CommonHelper:HButtonSetCallback("BtnAttr", obj, function(hbtn)
                CommonHelper:ShowAttrInfoView(temp.type)
            end)
        end
    end
    --}}}
end
function LabChoosePropView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.LabChoosePropView)
end