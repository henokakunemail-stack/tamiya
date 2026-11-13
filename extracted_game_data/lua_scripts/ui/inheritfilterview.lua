---@class InheritFilterView : ViewBase
InheritFilterView = class("InheritFilterView", ViewBase)

function InheritFilterView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "InheritFilterViewAction")
end

function InheritFilterView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("InheritFilterView")
        if self.CallBack then
            local data={}
            for k, v in pairs(self.List) do
                if v.flag then
                    table.insert(data,v.type)
                end
            end
            self.CallBack(data)
        end
    end)
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("InheritFilterView")
        if self.CallBack then
            local data={}
            for k, v in pairs(self.List) do
                if v.flag then
                    table.insert(data,v.type)
                end
            end
            self.CallBack(data)
        end
    end)
end

function InheritFilterView:OnOpen()

end


function InheritFilterView:OnClose()

end
local MaxSelectCount=1
function InheritFilterView:SetData(func)
    self.CallBack=func
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.dictinherit_config)
    ---@type dictinherit_config_cell[]
    local data= cfg.GetConfigData()
    local AttrDic={}
    for k, v in pairs(data) do
        AttrDic[v.AttrIds[1]]=1
    end
    self.List={}
    for k, v in pairs(AttrDic) do
        table.insert(self.List,{type=k,flag=false})
    end
    if MaxSelectCount==-1 then
        MaxSelectCount=#self.List
    end
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.List, 4,function(dataIndex, itemObj, scroll)
         CommonHelper:SetText("###name",itemObj,CommonHelper:GetAttrName(self.List[dataIndex+1].type))
        local Tog= CommonHelper:HButtonSetCallback("Tog",itemObj,function (data)
            if MaxSelectCount==1 then
                self.List[data.intData+1].flag=not self.List[data.intData+1].flag
                for i = 1, #self.List do
                    if data.intData+1~=i then
                        self.List[i].flag=false
                    end
                end
                CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
            else
                local count=0
                for i = 1, #self.List do
                    if self.List[i].flag and data.intData~=i then
                        count=count+1
                    end
                end
                if count<MaxSelectCount or not self.List[data.intData+1].flag==false then
                    self.List[data.intData+1].flag=not self.List[data.intData+1].flag
                    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
                end
            end
        end,dataIndex)
        CommonHelper:SetToggleState(Tog,self.List[dataIndex+1].flag)
    end)
end
