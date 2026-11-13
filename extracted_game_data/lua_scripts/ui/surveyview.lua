---@class SurveyView : ViewBase
SurveyView = class("SurveyView", ViewBase)

function SurveyView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SurveyViewAction")
end

function SurveyView:Awake()
    self:CacheBaseData()
    self:InitBtnFunc()
end

function SurveyView:OnOpen()
    self:InitSurveyList()
end
function SurveyView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.SurveyView)
end

function SurveyView:CacheBaseData()
    self.SurveyListScrollView = self:GetChildWight("SurveyList", typeof(MoreRowScrollView))


end

----初始话界面信息
function SurveyView:InitBtnFunc()
    self.BtnClose = CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)
end

----------------------------------------------初始化俱乐部列表信息
function SurveyView:InitSurveyList()

    local itemCount = SurveyDataManager:Get():GetSurveyCount()

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        ---@type questionnaire_config_cell
        local questionNair = SurveyDataManager:Get():GetDataByIndex(dataIndex + 1)

        CommonHelper:SetText("###SurveyName", itemObj, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), CommonHelper:GetTempStr_Default(TemplateStringID.Survey), tostring(dataIndex + 1)))

        local reward = stringSplit(questionNair.reward, ';')
        for i = 1, 3 do
            local rewardItem = CommonHelper:SetGameObjectActive(string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), CommonHelper:GetTempStr_Default(TemplateStringID.SurveyReward), tostring(i)), itemObj, i <= #reward)
            if i <= #reward then
                local rewardStr = stringSplit(reward[i], ',')
                self:SetProp(rewardItem, rewardStr[2], rewardStr[1])
            end
        end

        --local HaveReceiveText = SurveyDataManager:Get():IsHaveReceive(questionNair.id) and CommonHelper:GetTempStr_Default(TemplateStringID.HaveReceive) or CommonHelper:GetTempStr_Default(TemplateStringID.HaveNoReceive)
        --CommonHelper:SetText("###HaveReceiveText", itemObj, HaveReceiveText)

        local BtnGo = CommonHelper:HButtonSetCallback("BtnGo", itemObj, function(param)
            SurveyDataManager:Get():SetCurSelectId(questionNair.id)
            SDKManager:Get():OpenWebView(questionNair.questiondress)
        end)

        CommonHelper:SetHButtonClick(BtnGo, not SurveyDataManager:Get():IsHaveReceive(questionNair.id), true)

        --CommonHelper:HButtonSetCallback("BtnReceive", itemObj, function(param)
        --    SurveyDataManager:Get():SetCurSelectId(questionNair.id)
        --   SurveySubsystem:Get():SendMsg_GetReward(questionNair.id)
        --end)

    end
    CommonHelper:InitMoreRowScrollView(self.SurveyListScrollView, itemCount, 1, UpdateFunc, true)
end

function SurveyView:UpdateScrollList()
    CommonHelper:MoreRowView_RefreshCurList(self.SurveyListScrollView, false)
end

function SurveyView:SetProp(itemObj, id, count)
    local param = Param_PropParam()
    param.moduleId = UIModuleID.SurveyView
    param.count = tostring(count)
    param.id = tonumber(id)
    param.showcount = true
    param.showname = false
    CommonHelper:SetPropGroup(itemObj, param)
end


