---@class RaceFifaTeamListView : ViewBase
RaceFifaTeamListView = class("RaceFifaTeamListView", ViewBase)

function RaceFifaTeamListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceFifaTeamListViewAction")
end

function RaceFifaTeamListView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (data)
        self:OnCloseCallBack()
        UIManager:Get():ClosePopup()
    end)

    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (data)
        self:OnCloseCallBack()
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("SelectCost/BtnBack",self.gameObject,function (data)
        CommonHelper:SetGameObjectActive("SelectCost",self.gameObject,false)
        CommonHelper:SetGameObjectActive("SelectGuessCost",self.gameObject,false)
        CommonHelper:SetGameObjectActive("SelectCountry",self.gameObject,true)
    end)
    self.ScrollView=self:GetChildWight("MoreRowScrollView_V",typeof(MoreRowScrollView))
    self.ScrollViewCost1=self:GetChildWight("SelectCost/MoreRowScrollView_Cost",typeof(MoreRowScrollView))
    self.ScrollViewCost2=self:GetChildWight("SelectGuessCost/MoreRowScrollView_Cost",typeof(MoreRowScrollView))
end
function RaceFifaTeamListView:OnOpen()

end
function RaceFifaTeamListView:ReOpen()

end
function RaceFifaTeamListView:OnClose()

end
function RaceFifaTeamListView:OnAutoClose()

end
function RaceFifaTeamListView:OnOpenAnimEnd()

end
function RaceFifaTeamListView:SetDataCountry()
    ---@type dictuefacountry_config_cell[]
    local list=RaceFifaDataManager:Get():Get_RaceFifaChampionCountry()
    CommonHelper:SetGameObjectActive("SelectCost",self.gameObject,false)
    CommonHelper:SetGameObjectActive("SelectGuessCost",self.gameObject,false)
    CommonHelper:SetGameObjectActive("SelectCountry",self.gameObject,true)
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #list, 5,function(dataIndex, itemObj, scroll)
        CommonHelper:SetText("###name",itemObj,CommonHelper:GetTempStr_Default(list[dataIndex+1].name))
        CommonHelper:GetComponentSetUITexture("icon",itemObj,string.format("%s.png",list[dataIndex+1].icon),UIModuleID.RaceFifaTeamList)
        CommonHelper:HButtonSetCallback("HButton",itemObj,function (hbtn)
            CommonHelper:SetGameObjectActive("SelectCost",self.gameObject,true)
            CommonHelper:SetGameObjectActive("SelectCountry",self.gameObject,false)
            CommonHelper:SetGameObjectActive("SelectGuessCost",self.gameObject,false)
            self.SelectId=hbtn.intData
            local cfg=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,self.SelectId)
            CommonHelper:SetText("SelectCost/coustom/###selectname",self.gameObject,CommonHelper:GetTempStr_Default(cfg.name))
            CommonHelper:GetComponentSetUITexture("SelectCost/coustom/selecticon",self.gameObject,string.format("%s.png",cfg.icon),UIModuleID.RaceFifaTeamList)
        end,list[dataIndex+1].C_ID)
    end)
    local Cost=RaceFifaDataManager:Get():Get_RaceFifaData().PayNumS
    local CostId=RaceFifaDataManager:Get():Get_RaceFifaData().PayId
    CommonHelper:InitMoreRowScrollView(self.ScrollViewCost1, #Cost, 5,function(dataIndex, itemObj, scroll)
        local ArticleItem= UIUtil.GetChild("ItemArticle_138",itemObj)
        local param = Param_ItemArticleParam()
        param.count = Cost[dataIndex+1]
        CommonHelper:SetItemArticleGroup(ArticleItem, UIModuleID.RaceFifaTeamList, CostId, param,function()
            CommonHelper:ShowPartInfoByCfgId(CostId,UIModuleID.RaceFifaTeamList)
        end)
        CommonHelper:HButtonSetCallback("BtnResult",itemObj,function (hbtn)
            local boxFunc = function()
                ---@type dictarticle_config_cell
                local cell = CommonHelper:GetTableDataByID(ConfigNames.article_config, CostId)
                local name = CommonHelper:GetTempStr_Default(cell.name)
                local cfg=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,self.SelectId)
                local tips = CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaSelectChampion, name, Cost[hbtn.intData+1],CommonHelper:GetTempStr_Default(cfg.name))
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotEnter_Tittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
                if ret == MessageBoxHelp.BtnType.OK then
                    if PlayerDataManager:Get():CheckCurrencyEnough(CostId,Cost[hbtn.intData+1]) then
                        RaceFifaSubsystem:Get():SendMsg_SelectChampion(RaceFifaDataManager:Get():Get_RaceFifaSeasonId(),self.SelectId,hbtn.intData)
                    end
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        end,dataIndex)
    end)
    self:SetCost()
end
---@param data RaceFifaVenueData
function RaceFifaTeamListView:SetDataGuess(data,type)
    CommonHelper:SetGameObjectActive("SelectCost",self.gameObject,false)
    CommonHelper:SetGameObjectActive("SelectCountry",self.gameObject,false)
    CommonHelper:SetGameObjectActive("SelectGuessCost",self.gameObject,true)
    local cfgA=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,data.TeamA)
    local cfgB=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,data.TeamB)
    CommonHelper:SetText("SelectGuessCost/coustom1/###selectname",self.gameObject,CommonHelper:GetTempStr_Default(cfgA.name))
    CommonHelper:GetComponentSetUITexture("SelectGuessCost/coustom1/selecticon",self.gameObject,string.format("%s.png",cfgA.icon),UIModuleID.RaceFifaTeamList)
    CommonHelper:SetText("SelectGuessCost/coustom2/###selectname",self.gameObject,CommonHelper:GetTempStr_Default(cfgB.name))
    CommonHelper:GetComponentSetUITexture("SelectGuessCost/coustom2/selecticon",self.gameObject,string.format("%s.png",cfgB.icon),UIModuleID.RaceFifaTeamList)
    CommonHelper:SetGameObjectActive("SelectGuessCost/result1",self.gameObject,type==RaceFifaBattleResult.Win)
    CommonHelper:SetGameObjectActive("SelectGuessCost/result2",self.gameObject,type==RaceFifaBattleResult.Flat)
    CommonHelper:SetGameObjectActive("SelectGuessCost/result3",self.gameObject,type==RaceFifaBattleResult.Lose)
    local Cost=RaceFifaDataManager:Get():Get_RaceFifaData().PayNumS
    local CostId=RaceFifaDataManager:Get():Get_RaceFifaData().PayId
    CommonHelper:InitMoreRowScrollView(self.ScrollViewCost2, #Cost, 5,function(dataIndex, itemObj, scroll)
        local ArticleItem= UIUtil.GetChild("ItemArticle_138",itemObj)
        local param = Param_ItemArticleParam()
        param.count = Cost[dataIndex+1]
        CommonHelper:SetItemArticleGroup(ArticleItem, UIModuleID.RaceFifaTeamList, CostId, param,function()
            CommonHelper:ShowPartInfoByCfgId(CostId,UIModuleID.RaceFifaTeamList)
        end)
        CommonHelper:HButtonSetCallback("BtnResult",itemObj,function (hbtn)
            local boxFunc = function()
                ---@type dictarticle_config_cell
                local cell = CommonHelper:GetTableDataByID(ConfigNames.article_config, CostId)
                local name = CommonHelper:GetTempStr_Default(cell.name)
                local tips = CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGuessWin, name, Cost[hbtn.intData+1],CommonHelper:GetTempStr_Default(cfgA.name),CommonHelper:GetTempStr_Default(cfgB.name),CommonHelper:GetTempStr_Default(cfgA.name))
                if type==RaceFifaBattleResult.Flat then
                    tips = CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGuessFlat, name, Cost[hbtn.intData+1],CommonHelper:GetTempStr_Default(cfgA.name),CommonHelper:GetTempStr_Default(cfgB.name),CommonHelper:GetTempStr_Default(cfgA.name))
                end
                if type==RaceFifaBattleResult.Lose then
                    tips = CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGuessLose, name, Cost[hbtn.intData+1],CommonHelper:GetTempStr_Default(cfgA.name),CommonHelper:GetTempStr_Default(cfgB.name),CommonHelper:GetTempStr_Default(cfgA.name))
                end
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotEnter_Tittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
                if ret == MessageBoxHelp.BtnType.OK then
                    if PlayerDataManager:Get():CheckCurrencyEnough(CostId,Cost[hbtn.intData+1]) then
                        RaceFifaSubsystem:Get():SendMsg_SelectWinner(RaceFifaDataManager:Get():Get_RaceFifaSeasonId(),data.Id,type,hbtn.intData)
                    end
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        end,dataIndex)
    end)
    self:SetCost()
end

function RaceFifaTeamListView:OnCloseCallBack()
    if self._CallBack then
        self._CallBack()
    end
end
function RaceFifaTeamListView:SetCost()
    local CostId=RaceFifaDataManager:Get():Get_RaceFifaData().PayId
    CommonHelper:SetText("###GuessodCostCount",self.gameObject,KnapsackDataManager:Get():GetArticleCountByCfgid(CostId))
    local cell = CommonHelper:GetTableDataByID(ConfigNames.article_config, CostId)
    CommonHelper:GetComponentSetUITexture("GuessodCostIcon",self.gameObject,cell.NewIcon,UIModuleID.RaceFifaKnockout)
end
