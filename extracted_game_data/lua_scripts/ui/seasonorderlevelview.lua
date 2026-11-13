---@class SeasonOrderLevelView : ViewBase
SeasonOrderLevelView = class("SeasonOrderLevelView", ViewBase)
function SeasonOrderLevelView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SeasonOrderLevelViewAction")
end

function SeasonOrderLevelView:Awake()
    self.WillView = self:GetChildWightByParent("InfoBaseScroll", self.gameObject, typeof(MoreRowScrollView))

    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function(data)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnClose2",self.gameObject,function(data)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnSub",self.gameObject,function(data)
      self:SetData(self.msg,-1)
    end)
    CommonHelper:HButtonSetCallback("BtnAdd",self.gameObject,function(data)
        self:SetData(self.msg,1)
    end)
    CommonHelper:HButtonSetCallback("BtnGetLv",self.gameObject,function(data)
        SeasonOrderSubsystem:Get():SendMsg_GetSeasonLevel(self.AddLev)
    end)

end

function SeasonOrderLevelView:OnOpen()

end

function SeasonOrderLevelView:OnClose()
    self.AddLev=nil
end

---@param msg SC_ActToken
function SeasonOrderLevelView:SetData(msg,addlev)
    self.msg=msg
    if self.AddLev==nil then
        self.AddLev=addlev
    else
        self.AddLev= self.AddLev+addlev
        if self.AddLev<1 then
            self.AddLev=1
        end
    end

    ---@type act_token_lev_config
    local config= ClientDataManager:Get():GetDataTable(ConfigNames.act_token_lev_config)
    ---@type act_token_config_cell
    local cell=CommonHelper:GetTableDataByID(ConfigNames.act_token_config,msg.tokenid)
    ---@type act_token_lev_config_cell[]
    local data= config.GetTokenData(PlayerDataManager:Get():GetPlayerServerID(),msg.tokenid)
    if msg.lev+self.AddLev>data[#data].lev then
        self.AddLev=data[#data].lev-msg.lev
    end
    ---@type act_token_lev_config_cell
    local cell_lev=config.GetDataByAndLevel(PlayerDataManager:Get():GetPlayerServerID(),msg.tokenid,msg.lev)

    local cfg= CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config,CommonCfgKey.SeasonOrderLevelDiamond)
    local value=tonumber(cfg.varval)
    CommonHelper:SetText("###CurLv",self.gameObject,msg.lev)
    CommonHelper:SetText("###DestLv",self.gameObject,msg.lev+self.AddLev)
    CommonHelper:SetText("###buyhit",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderBuyLevel,self.AddLev))
    CommonHelper:SetText("###paymoney",self.gameObject,self.AddLev*value)

    local GetWill={}
    for i = msg.lev+1, #data do
        if data[i].lev<=msg.lev+self.AddLev then
            if msg.ifbuy==1 then
                if GetWill[tonumber(data[i].hawardids)]==nil then
                    GetWill[tonumber(data[i].hawardids)]=tonumber(data[i].hawardnums)
                else
                    GetWill[tonumber(data[i].hawardids)]=GetWill[tonumber(data[i].hawardids)]+tonumber(data[i].hawardnums)
                end
            end
            if GetWill[tonumber(data[i].awardids)]==nil then
                GetWill[tonumber(data[i].awardids)]=tonumber(data[i].awardnums)
            else
                GetWill[tonumber(data[i].awardids)]=GetWill[tonumber(data[i].awardids)]+tonumber(data[i].awardnums)
            end
        end
    end
    local GetWillList={}
    for k, v in pairs(GetWill) do
        local data=RewardData()
        data:SetDataIdNum(k,v)
        table.insert(GetWillList,data)
    end
    CommonHelper:InitMoreRowScrollView(self.WillView,#GetWillList,4,function(index, itemObj,scroll)
        ---@type RewardData
        local temp=GetWillList[index+1]
        local param = Param_ItemArticleParam()
        param.count = temp.num
        CommonHelper:SetItemComGroup(itemObj,UIModuleID.SeasonOrder,tonumber(temp.id),param,function(data)
            CommonHelper:ShowPartInfoByCfgId(tonumber(temp.id), UIModuleID.SeasonOrder)
        end)
    end)
end






