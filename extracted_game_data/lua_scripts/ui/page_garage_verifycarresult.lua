---@class PageGarageVerifyCarResult
PageGarageVerifyCarResult = class("PageGarageVerifyCarResult")

function PageGarageVerifyCarResult:initialize()

end
---@param attr VerifyCarAttrData[]
function PageGarageVerifyCarResult:SetData(root,caridx,attr,type, funback)
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)
    CommonHelper:HButtonSetCallback("BtnSave",root,function (hbtn)
        UIManager:Get():ShowPersistentView("CarVerifyHistoryView",CanvasType.FrontCanvas,"CarVerifyHistoryView")
        UINotify:Get():SendNotification(UINotifyEvent.CarVerifyHistoryView_SetData, {caridx,CarVerifyHistoryOpenType.Save} )
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", root, function(hbtn)
        CommonHelper:ShowHelpView(PageDetailType.VerifyCarAttr)
    end)
    CommonHelper:SetGameObjectActive("BtnSave",root,type==CarVerifyHistoryOpenType.Save)
    if type==CarVerifyHistoryOpenType.Save and CommonHelper:GetNowTime().Day~=PlayerPrefsHelper:GetValue_VerifyCarTips() and not CommonHelper:CheckPlayerIsNewGuide() then
        PlayerPrefsHelper:SetValue_VerifyCarTips(CommonHelper:GetNowTime().Day)
        UIManager:Get():OpenPopup("PlayerTipsView", CanvasType.FrontCanvas, "PlayerTipsView")
        local param = PlayerTipsViewParam()
        param.TitleName = CommonHelper:GetTempStr_Default(TemplateStringID.PageGarageVerifyTipsTittle)
        param.Value = CommonHelper:GetTempStr_Default(TemplateStringID.PageGarageVerifyTipsContent)
        param.PlayerId = ""
        UINotify:Get():SendNotification(UINotifyEvent.PlayerTipsView_SetData, param)
    end
    local CarData=CarDataManager:Get():GetCarDataByCarID(caridx)
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #attr, 1,function(dataIndex, itemObj, scroll)
        ---@type carinspectattr_config_cell
        local cfg=CommonHelper:GetTableDataByID(ConfigNames.carinspectattr_config,attr[dataIndex+1].id)
        local attrValue=string.format(cfg.format,attr[dataIndex+1].value)
        if cfg.unit~="0" then
            attrValue=attrValue .. cfg.unit
        end
        if cfg.attrcontrast~=0 then
           local value=CarData:GetAttrValueById(cfg.attrcontrast).value/1000
            if value>tonumber(attr[dataIndex+1].value) then
                attrValue=CommonHelper:GetTempStr_Default(TemplateStringID.VerifyResultCarResultGreen,attrValue)
            elseif value<tonumber(attr[dataIndex+1].value) then
                attrValue=CommonHelper:GetTempStr_Default(TemplateStringID.VerifyResultCarResultRed,attrValue)
            elseif value==tonumber(attr[dataIndex+1].value) then
                attrValue=CommonHelper:GetTempStr_Default(TemplateStringID.VerifyResultCarResultYellow,attrValue)
            end
        end
        CommonHelper:SetText("###name",itemObj,attr[dataIndex+1].Name)
        CommonHelper:SetText("###value2",itemObj,attrValue)
        CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
            CommonHelper:ShowGarageTipsView(GarageTipsTpye.VerifyCarAttr, hbtn.intData,attr[hbtn.intData].value)
        end,dataIndex+1)
    end)
end
