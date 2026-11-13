---@class RaceGVGResultView : ViewBase
RaceGVGResultView = class("RaceGVGResultView", ViewBase)

function RaceGVGResultView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceGVGResultViewAction")
end

function RaceGVGResultView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)

end

function RaceGVGResultView:OnOpen()
     self:SetData()
end

function RaceGVGResultView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceGVGResult)
end

function RaceGVGResultView:SetData()
    if RaceGVGManager:Get():GetGuildId()>0 then
        CommonHelper:GetComponentSetUITexture("GuildIcon", self.gameObject, CommonHelper:GetPlayerIconById(RaceGVGManager:Get():GetGuildIcon(), HeadIconType.ClubIcon)..".png", UIModuleID.RaceGVGResult)
        CommonHelper:SetText("###GuildName",self.gameObject,RaceGVGManager:Get():GetGuildName())
        CommonHelper:SetText("###GuildScore",self.gameObject,RaceGVGManager:Get():GetGuildScore())
    else
        CommonHelper:SetText("###GuildName",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGGuildNull))
        CommonHelper:SetText("###GuildScore",self.gameObject,"--")
        CommonHelper:GetComponentSetUITexture("GuildIcon", self.gameObject, "guild_icon_default.png", UIModuleID.RaceGVGResult)
    end
    if RaceGVGManager:Get():GetFGuildId()>0 then
        CommonHelper:GetComponentSetUITexture("FGuildIcon", self.gameObject, CommonHelper:GetPlayerIconById(RaceGVGManager:Get():GetFGuildIcon(), HeadIconType.ClubIcon)..".png", UIModuleID.RaceGVGResult)
        CommonHelper:SetText("###FGuildName",self.gameObject,RaceGVGManager:Get():GetFGuildName())
        CommonHelper:SetText("###FGuildScore",self.gameObject,RaceGVGManager:Get():GetFGuildScore())
    else
        CommonHelper:SetText("###FGuildName",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGGuildNull))
        CommonHelper:SetText("###FGuildScore",self.gameObject,"--")
        CommonHelper:GetComponentSetUITexture("FGuildIcon", self.gameObject, "guild_icon_default.png", UIModuleID.RaceGVGResult)
    end
    local value=0
    local FguideValue =0
    local guideValue =0
    local score1=RaceGVGManager:Get():GetGuildScore()
    local score2=RaceGVGManager:Get():GetFGuildScore()
    if RaceGVGManager:Get():GetFGuildId()>0 and RaceGVGManager:Get():GetGuildId()>0 then
        if score1==0 and score2==0 then
            value=0.5
            FguideValue =50
            guideValue =50
        else
            value=score1/(score1+score2)
            FguideValue =math.floor(value*100)
            guideValue =100- FguideValue
        end
    else
        if RaceGVGManager:Get():GetFGuildId()<=0 then
            value=1
            guideValue =0
            FguideValue=100
        end
        if RaceGVGManager:Get():GetGuildId()<=0 then
            value=0
            guideValue =0
            FguideValue=100
        end
    end

    CommonHelper:SetSlider("SliderBaseColor",self.gameObject,value)
    CommonHelper:SetText("###SliderValue",self.gameObject, guideValue .."%")
    CommonHelper:SetText("###FSliderValue",self.gameObject, FguideValue .."%")
    ---@type dictgvgpointgroupaward_config
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictgvgpointgroupaward_config)
    ---@type dictgvgpointgroupaward_config_cell[]
   local rewards=  cfg.GetDataByRank(1,RaceGVGManager:Get():GetSeasonId())
    rewards=CommonHelper:SetDataByStrIdAndNum(rewards.awardids,rewards.awardnums)
    local scrollview = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H", self.gameObject, typeof(MoreRowScrollView))
    local count= #rewards>=7 and #rewards or 7
    CommonHelper:InitMoreRowScrollView(scrollview, count, 1,function(dataIndex, itemObj, scroll)
        if rewards[dataIndex+1] then
            CommonHelper:SetGameObjectActive("ItemCom_118",itemObj,true)
            local param = Param_ItemArticleParam()
            param.count = rewards[dataIndex+1].num
            CommonHelper:SetItemComGroup(itemObj, UIModuleID.RaceGVGResult,rewards[dataIndex+1].id,param,function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.RaceGVGResult)
            end,rewards[dataIndex+1].id)
        else
           CommonHelper:SetGameObjectActive("ItemCom_118",itemObj,false)
        end

    end)
end