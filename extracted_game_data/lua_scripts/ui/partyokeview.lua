---@class PartYokeView : ViewBase
PartYokeView = class("PartYokeView", ViewBase)

function PartYokeView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PartYokeViewAction")
end

function PartYokeView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.ScrollView1 = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function PartYokeView:OnOpen()
    self:SetData()
end

function PartYokeView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.PartYoke)
end


function PartYokeView:SetData()
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.dictpartyoke_config)
    local List={}
    for k, v in pairs(cfg.GetConfigData()) do
        for i = 1, #v.NewLinkPartAttrs do
            table.insert(List,v.NewLinkPartAttrs[i])
        end
    end
    table.sort(List,function(a, b)
        return a.PartIds[1]<b.PartIds[1]
    end)
    CommonHelper:InitMoreRowScrollView(self.ScrollView1,#List,2,function(index, itemObj,scroll)
        ---@type PartYokeCfg
        local temp=List[index+1]
        for i = 1, #temp.PartIds do
            local partobj = UIUtil.GetChild("ItemPart_"..i, itemObj)
            CommonHelper:SetItemPartGroup(partobj,UIModuleID.PartYoke,temp.PartIds[i],ItemPartUIType.Simple,nil,function(id)
                CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.PartYoke)
            end,temp.PartIds[i])
            CommonHelper:SetText("###name"..i,itemObj,CommonHelper:GetPartOrArticleName(temp.PartIds[i]))
        end
        local  desc=string.gsub(CommonHelper:GetTempStr_Default(temp.Desc), "f6ff00", "dd740d")
        CommonHelper:SetText("###desc",itemObj,desc)
    end)
end
