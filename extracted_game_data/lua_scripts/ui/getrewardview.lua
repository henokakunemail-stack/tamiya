---@type table<number,SC_Tuple2_64_32>
local __Items
local __CloseFun = nil
local _ShowRewardQueue=Queue()
---@class GetRewardView : ViewBase
GetRewardView = class("GetRewardView", ViewBase)

function GetRewardView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "GetRewardViewAction")

    print("---   GetReward 初始化完成")
end

function GetRewardView:Awake()
    print("---   GetReward awake")
    self.Show=false
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function()
        if _ShowRewardQueue:GetSize()<=0 then
            self.Show=false
            UIManager:Get():ClosePopup()
            self:CheckNewBieGuide("PveChapterListView")
        else
            self:ShowReward(_ShowRewardQueue:DeQueueFront())
        end
    end)


end

function GetRewardView:OnClose()
    self:CheckExitNewBieGuide()
    if __CloseFun then
        __CloseFun()
    else
        PopUpGiftDataManager:Get():DelayPopUpShow()
    end
end
function GetRewardView:OnOpen()
    self:CheckNewBieGuide()
end

---@param items SC_SomeDown
function GetRewardView:SetRewardInfo(items)
    if items == nil then
        return
    end
    local  __Items = {}

    for i = 1, #items do
        local flag = -1
        local propType= CommonHelper:GetPropTypeById(items[i].num1)
        for j = 1, #__Items do
            if __Items[j].num1 == items[i].num1 then
                flag = j
            end
        end
        if flag ~= -1 and propType~=PropType.Part then
            __Items[flag].num2 = __Items[flag].num2 + items[i].num2
        else
            table.insert(__Items, items[i])
        end
    end
    self:InitMoreScrollView(__Items)
end

---@param items table<number,RewardData>
function GetRewardView:SetRewardInfoByRewardData(items)
    if items == nil then
        return
    end
    local __Items={}
    for k, v in pairs(items) do
        local propType= CommonHelper:GetPropTypeById(v.id)
        if propType~=PropType.Part then
            if __Items[v.id]~=nil then
                __Items[v.id]=__Items[v.id]+v.num
            else
                __Items[v.id]=v.num
            end
        end
    end
    local idxTable = {}
    for k, v in pairs(items) do
        local propType= CommonHelper:GetPropTypeById(v.id)
        if propType==PropType.Part then
           table.insert(idxTable, { num1 = v.id, num2 = 1,num3=v.partIdx })
        end
    end
    for k, v in pairs(__Items) do
        table.insert(idxTable, { num1 = k, num2 =v})
    end
    self:InitMoreScrollView(idxTable)
end
function GetRewardView:OnOpenAnimEnd()
end

function GetRewardView:InitMoreScrollView(value)
    if self.Show==false then
        _ShowRewardQueue:EnQueueBack(value)
        self:ShowReward(_ShowRewardQueue:DeQueueFront())
    else
        _ShowRewardQueue:EnQueueBack(value)
    end
end
function GetRewardView:ShowReward(value)
    self.ScrollView = UIUtil.GetTypeChildWightByParent("ScrollHorizontalOneRow", self.gameObject, typeof(MoreRowScrollView))
    if value then
        self.Show=true
        CommonHelper:InitMoreRowScrollView(self.ScrollView, #value, 5, function(dataIndex, itemObj, scroll)
            local data = value[dataIndex + 1]
            if data == nil then
                return
            end
            local param = Param_ItemArticleParam()
            param.count = data.num2
            local type=ItemPartUIType.Simple
            local cell=nil
            if data.num3~=nil then
                cell=KnapsackDataManager:Get():GetArticleByCellID(data.num3)
                if cell then
                    param.quality = cell:GetPartQuality()
                    param.star = cell:GetStar()
                    param.lv = cell:GetPartLV()
                    param.using = cell:GetCarId()
                    param.lock = cell:GetPartLock()
                    param.awaken=cell:GetAwaken()
                    param.generation=cell:GetGeneration()
                    param.downType=cell:GetPartDownType()
                    param.source = cell:GetPartSource()
                    param.expireTime = cell:GetPartExpTime()
                    type=ItemPartUIType.Normal
                end
            end
            CommonHelper:SetItemComGroup(itemObj, UIModuleID.GetReward, tonumber(data.num1), param, function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.GetReward, false,nil,cell)
            end, tonumber(data.num1),type)
        end, true)
        CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
        CommonHelper:MoreRowView_EnterAniRace(self.ScrollView, 0.4)
    else
        self.Show=false
    end
end
function GetRewardView:SetCloseFun(fun)
    __CloseFun = fun
end

