

--车库右侧，涂装入口

---@class PageGarageGridList
PageGarageGridList = class("PageGarageGridList")

function PageGarageGridList:initialize()
    self.ArticleIdx = -1
    ---@type ArticleCell
    self.SelectArticle = nil
    ---@type CarData
    self.CarData = nil
    self.HoleIdx = -1

end

---@param cardata CarData
function PageGarageGridList:SetData(root, cardata,holeidx, funback)
    self.ArticleIdx = -1
    self.SelectArticle = nil
    self.CarData = cardata
    self.HoleIdx = holeidx+1

    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)

    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if self.SelectArticle ~= nil then
            local count = KnapsackDataManager:Get():GetArticleCountByCfgid(self.SelectArticle.C_ID)
            local carshellid = self.CarData.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):GetBagId()
            if count > 0 then
                AppearanceSubsystem:Get():SendMsg_ShellGrid(carshellid, holeidx, self.SelectArticle.C_ID)
            else
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ShellGridNoCount))
            end
        else
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GarageNotSelectGrid))
        end

    end)
    CommonHelper:HButtonSetCallback("BtnRestore",root,function (hbtn)
        local carshellid = self.CarData.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):GetBagId()
            if self.CarData:GetShellGridList()[holeidx+1]>2  then
                local id=CommonHelper:GetDictCalcData(CommonCfgKey.CarResetGridCost,false)
                local value= 1
                if PlayerDataManager:Get():CheckCurrencyEnough(id,value) then
                    local boxFunc = function()
                        ---@type article_config_cell
                        local cell= CommonHelper:GetTableDataByID(ConfigNames.article_config,id)
                        local tips=CommonHelper:GetTempStr_Default(TemplateStringID.ShellGridResetHit,CommonHelper:GetTempStr_Default(cell.name))
                        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.ShellGridResetTittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
                        if ret == MessageBoxHelp.BtnType.OK then
                            AppearanceSubsystem:Get():SendMsg_ResetSticker(carshellid,AppearanceType.Grid , holeidx)
                        end
                    end
                    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
                end

            else
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ShellGridNoReset))
            end
    end)


    CommonHelper:HButtonSetCallback("BtnReset",root,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.GarageView_ResetOrgCar)
    end)





    ---@type dictarticle_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.article_config)
    local list = tab.GetArticleListType2(GoodsType2.Article_Appearance, GoodsType3.Article_Appearance_Grid)
    ---@type table<number, article_config_cell>
    local datalist = {}
    for k,v in pairs(list) do
        table.insert(datalist, v)
    end
    table.sort(datalist,function (a, b)
            return a.C_ID < b.C_ID
    end)


    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #datalist, 4,function(dataIndex, itemObj, scroll)
        local data = datalist[dataIndex + 1]
        if data then
            local articleobj = UIUtil.GetChild("ItemArticle", itemObj)
            local param = Param_ItemArticleParam()
            param.count = KnapsackDataManager:Get():GetArticleCountByCfgid(data.C_ID)
            CommonHelper:SetItemArticleGroup(articleobj, UIModuleID.Garage, data.C_ID, param, function()
                self.ArticleIdx = dataIndex
                self.SelectArticle = data
                CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
                UINotify:Get():SendNotification(UINotifyEvent.GarageView_ShellGridReview, {self.HoleIdx, tonumber(data.propsadd)})
            end)
        end

        CommonHelper:SetGameObjectActive("select", itemObj, self.ArticleIdx == dataIndex)

    end)
end


function PageGarageGridList:UpdateMsg()
    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)

end