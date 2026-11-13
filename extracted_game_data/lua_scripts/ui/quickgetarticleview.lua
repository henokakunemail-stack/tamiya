---@class QuickGetArticleView : ViewBase
QuickGetArticleView = class("QuickGetArticleView", ViewBase)

function QuickGetArticleView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "QuickGetArticleViewAction")
end

function QuickGetArticleView:Awake()

    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)

    self.ScrollView = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_H", self.gameObject, typeof(MoreRowScrollView))
end

function QuickGetArticleView:OnOpen()

end

function QuickGetArticleView:OnClose()

end

function QuickGetArticleView:SetScrollView()

end
---@param msg SC_GetWay
function QuickGetArticleView:SetData(msg)
    local cfg=CommonHelper:GetTableDataByID(ConfigNames.article_config,tonumber(msg.propid))
    CommonHelper:SetText("###tittle",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.LackArticle,CommonHelper:GetTempStr_Default(cfg.name)))
    local way=stringSplitToNumber(cfg.accessWay,":")
    local data={}
    for i = 1, #way do
        local levelData=  PVEChapterDataManager:Get():GetLevelDataByLevelId(way[i])
        if levelData then
            table.insert(data,way[i])
        end
    end
    for i = 1, #msg.copyids do
        ---@type PVELevelData
        local levelData=  PVEChapterDataManager:Get():GetLevelDataByLevelId(msg.copyids[i].copyid)
        if levelData then
            levelData:UpdateLevelDataCount(msg.copyids[i].num)
        end
    end
    table.sort(data)
    CommonHelper:InitMoreRowScrollView(self.ScrollView,#data,1,function(index, itemObj,scroll)

        local levelData= PVEChapterDataManager:Get():GetLevelDataByLevelId(data[index+1])
          CommonHelper:SetText("###value",itemObj,levelData.name)
          CommonHelper:SetText("###levelname",itemObj,levelData.name)
        local isPass=false
        local num=0
        for i = 1, #msg.copyids do
            if data[index+1]==msg.copyids[i].copyid then
                isPass=true
                num=msg.copyids[i].num
                break
            end
        end
        if levelData.levelCfg.maxenter>0 then
            CommonHelper:SetText("###subcount", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.ChapterLevelPassNumSubCount,levelData.levelCfg.maxenter-num))
        else
            CommonHelper:SetText("###subcount", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.ChapterLevelPassNumNoLimit))
        end
          CommonHelper:HButtonSetCallback("BtnSeap",itemObj,function(data)
              if levelData.levelCfg.maxenter==0 or levelData.levelCfg.maxenter-num >0 then
                  CommonHelper:SetUnlockFunc({ GameFunction.Swap }, function()
                      UIManager:Get():OpenPopup("SwapView", CanvasType.FrontCanvas, "SwapView")
                      UINotify:Get():SendNotification(UINotifyEvent.SwapView_SetData, levelData)
                  end)
              else
                 CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChapterLevelPassNumNoSubCount))
              end
          end)
          CommonHelper:SetGameObjectActive("pass",itemObj,isPass)
          CommonHelper:SetGameObjectActive("nopass",itemObj,not isPass)

    end)
end



