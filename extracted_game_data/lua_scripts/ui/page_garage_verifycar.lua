

---@class PageGarageVerifyCar
PageGarageVerifyCar = class("PageGarageVerifyCar")

function PageGarageVerifyCar:initialize()

end

---@param caridx
function PageGarageVerifyCar:SetData(root, caridx, funback,funcVerify)
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)
    local VerifyCarCostId= CommonHelper:GetDictCalcData(CommonCfgKey.VerifyCarCostId, false)
    local BtnVerify= CommonHelper:HButtonSetCallback("BtnVerify",root,function (hbtn)
        if CarDataManager:Get():CheckCarCompleteness(caridx) then
            if PlayerDataManager:Get():CheckCurrencyEnough(VerifyCarCostId,1) then
                if CommonHelper:CheckPlayerIsNewGuide() then
                    ReformSubsystem:Get():SendMsg_VerifyCor(caridx)
                else
                    local boxFunc = function()
                        local str = CommonHelper:GetTempStr_Default(TemplateStringID.VerifyCarCostHits)
                        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Orange, str)
                        if ret == MessageBoxHelp.BtnType.OK then
                            ReformSubsystem:Get():SendMsg_VerifyCor(caridx)
                        end
                    end
                    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
                end
            end
        end
    end)
    CommonHelper:HButtonSetCallback("BtnHelp",root, function(hbtn)
        CommonHelper:ShowHelpView(PageDetailType.VerifyCarAttr)
    end)
    local BtnHistory= CommonHelper:HButtonSetCallback("BtnHistory",root,function (hbtn)
       UIManager:Get():ShowPersistentView("CarVerifyHistoryView",CanvasType.FrontCanvas,"CarVerifyHistoryView")
       UINotify:Get():SendNotification(UINotifyEvent.CarVerifyHistoryView_SetData, {caridx,CarVerifyHistoryOpenType.Look} )
    end)
    local carData= CarDataManager:Get():GetCarDataByCarID(caridx)
    ---@type VerifyCarHistoryData
    local data=carData:GetVerifyAttrHistoryDataRecommend()
    local max= CommonHelper:GetDictCalcData(CommonCfgKey.VerifyCarMaxCount, false)
    local articleCfg= CommonHelper:GetTableDataByID(ConfigNames.article_config,VerifyCarCostId)
    local temp= UIUtil.GetChildInputPath("Article1", root,false)
    local param = Param_ItemArticleParam()
    param.count = 1
    CommonHelper:SetItemArticleGroup(temp,UIModuleID.Garage,VerifyCarCostId,param,function(id)
        CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.Garage,true)
    end,VerifyCarCostId)
    CommonHelper:SetText("###articlename",root,CommonHelper:GetTempStr_Default(articleCfg.name))
    CommonHelper:SetText("###desc",root,CommonHelper:GetTempStr_Default(articleCfg.description))
    CommonHelper:SetText("###cost",root,CommonHelper:GetTempStr_Default(TemplateStringID.CollectWordNum,tostring(KnapsackDataManager:Get():GetArticleCountByCfgid(VerifyCarCostId))))
    CommonHelper:SetText("###count",BtnHistory.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.CarVerifyHistoryCount,carData:GetCurHistoryCount(),max))
    CommonHelper:SetGameObjectActive("norecord",root,data.id==0)
    CommonHelper:SetGameObjectActive("recorddata",root,data.id~=0)
    if data.id~=0 then
        self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", root, typeof(MoreRowScrollView))
        CommonHelper:InitMoreRowScrollView(self.ScrollView, #data.verifyAttr, 1,function(dataIndex, itemObj, scroll)
            ---@type carinspectattr_config_cell
            local cfg=CommonHelper:GetTableDataByID(ConfigNames.carinspectattr_config,data.verifyAttr[dataIndex+1].id)
            local attrValue=string.format(cfg.format,data.verifyAttr[dataIndex+1].value)
            if cfg.unit~="0" then
                attrValue=attrValue .. cfg.unit
            end
            if cfg.attrcontrast~=0 then
                local value=carData:GetAttrValueById(cfg.attrcontrast).value/1000
                if value>tonumber(data.verifyAttr[dataIndex+1].value) then
                    attrValue=CommonHelper:GetTempStr_Default(TemplateStringID.VerifyResultCarResultGreen,attrValue)
                elseif value<tonumber(data.verifyAttr[dataIndex+1].value) then
                    attrValue=CommonHelper:GetTempStr_Default(TemplateStringID.VerifyResultCarResultRed,attrValue)
                elseif value==tonumber(data.verifyAttr[dataIndex+1].value) then
                    attrValue=CommonHelper:GetTempStr_Default(TemplateStringID.VerifyResultCarResultYellow,attrValue)
                end
            end
            CommonHelper:SetText("###name",itemObj,data.verifyAttr[dataIndex+1].Name)
           CommonHelper:SetText("###value2",itemObj,attrValue)
            CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
                CommonHelper:ShowGarageTipsView(GarageTipsTpye.VerifyCarAttr, hbtn.intData,data.verifyAttr[hbtn.intData].value)
            end,dataIndex+1)
        end)
    end
end
