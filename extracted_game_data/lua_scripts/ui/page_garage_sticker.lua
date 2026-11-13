

--车库右侧，涂装入口

---@class PageGarageSticker
PageGarageSticker = class("PageGarageSticker")

function PageGarageSticker:initialize()
    self.ArticleIdx = -1
    ---@type ArticleCell
    self.SelectArticle = nil
    ---@type CarData
    self.CarData = nil
end

---@param cardata CarData
function PageGarageSticker:SetData(root, cardata, funback)
    self.ArticleIdx = -1
    self.SelectArticle = nil
    self.CarData = cardata

    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)

    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if self.SelectArticle ~= nil then
            local count = KnapsackDataManager:Get():GetArticleCountByCfgid(self.SelectArticle.C_ID)
            local carshellid = self.CarData.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):GetBagId()
            if count > 0 then
                AppearanceSubsystem:Get():SendMsg_ShellSticker(carshellid , self.SelectArticle.C_ID)
            else
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ShellStickerNoCount))
            end
        else
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GarageNotSelectSticker))
        end

    end)

    CommonHelper:HButtonSetCallback("BtnReset",root,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.GarageView_ResetOrgCar)
    end)
    CommonHelper:HButtonSetCallback("BtnRestore",root,function (hbtn)
        local carshellid = self.CarData.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):GetBagId()
        if self.CarData:GetShellSticker(true)>0 then
            local id=CommonHelper:GetDictCalcData(CommonCfgKey.CarResetStickerCost,false)
            local value= 0
            if PlayerDataManager:Get():CheckCurrencyEnough(id,value) then
                --local boxFunc = function()
                --    ---@type article_config_cell
                --    local cell= CommonHelper:GetTableDataByID(ConfigNames.article_config,id)
                --    local tips=CommonHelper:GetTempStr_Default(TemplateStringID.StickerResetHit,CommonHelper:GetTempStr_Default(cell.name))
                --    local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.StickerResetTittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
                --    if ret == MessageBoxHelp.BtnType.OK then
              AppearanceSubsystem:Get():SendMsg_ResetSticker(carshellid,AppearanceType.Sticker , 0)
                --    end
                --end
                --MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
            end
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.StickerNoReset))
        end
    end)







    local datalist = {}
    local shell = cardata:GetShellCfg()
    for i = 1, #shell.NewExtrSticker do
        ---@type dictarticle_config_cell
        local tab = CommonHelper:GetTableDataByID(ConfigNames.article_config, shell.NewExtrSticker[i])
        if tab then
            ---@type apsticker_config_cell
            local stickercfg = CommonHelper:GetTableDataByID(ConfigNames.apsticker_config, tonumber(tab.propsadd))
            if stickercfg.ifPerson==1 and GameProperties.AssetBundleMode then
                if KnapsackDataManager:Get():GetArticleCountByCfgid(tab.C_ID)>0 then
                    table.insert(datalist, tab)
                end
            else
                table.insert(datalist, tab)
            end
        end
    end


    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #datalist, 4,function(dataIndex, itemObj, scroll)
        local data = datalist[dataIndex + 1]
        if data then
            local articleobj = UIUtil.GetChild("ItemArticle", itemObj)
            local param = Param_ItemArticleParam()
            CommonHelper:SetItemArticleGroup(articleobj, UIModuleID.Garage, data.C_ID, param, function()
                if   self.ArticleIdx == dataIndex then return end
                self.ArticleIdx = dataIndex
                self.SelectArticle = data
                CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
                UINotify:Get():SendNotification(UINotifyEvent.GarageView_ShellStickerReview, {cardata:GetShellArticle():GetID(),cardata:GetShellArticle():GetGeneration(),tonumber(data.propsadd)})
            end)
        end
        CommonHelper:SetText("idsticker",itemObj,data.C_ID.."_"..data.propsadd)
        CommonHelper:SetGameObjectActive("select", itemObj, self.ArticleIdx == dataIndex)
        CommonHelper:SetGameObjectActive("idsticker", itemObj,not GameProperties.AssetBundleMode)
        CommonHelper:SetGameObjectActive("partlock", itemObj, KnapsackDataManager:Get():GetArticleCountByCfgid(data.C_ID) <=0)

    end)




end


function PageGarageSticker:UpdateMsg()
    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)

end