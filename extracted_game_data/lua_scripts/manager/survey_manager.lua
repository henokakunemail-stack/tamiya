---@class SurveyDataManager
SurveyDataManager = class("SurveyDataManager")

---@return SurveyDataManager
function SurveyDataManager:Get()
    if self._instance == nil then
        self._instance = SurveyDataManager()
    end
    return self._instance
end

function SurveyDataManager:initialize()
    self.surveyMsgDic = {}--协议返回的已经领取过奖励的ID
    self.surveyIndexId = {}--这个是总的
    self.surveyMsgDicCount = 0

    self.curSelectId = -1

    CacheClearTrigger:Get():RegisterEvent(self, self.ClearData)
end


function SurveyDataManager:SetCurSelectId(id)
    self.curSelectId = id
end
function SurveyDataManager:GetCurSelectId()
    return self.curSelectId
end

function SurveyDataManager:InitData()
    ---@type questionnaire_config
    local questionnaire_config = ClientDataManager:Get():GetDataTable(ConfigNames.questionnaire_config)

    questionnaire_config = questionnaire_config.GetConfigData()

    ---@param cell questionnaire_config_cell
    for id, cell in pairs(questionnaire_config) do
        table.insert(self.surveyIndexId, cell.C_ID)
    end
end

---@param msg table<number,number>
function SurveyDataManager:InitMsgData(msg)
    for i = 1, #msg do
        self.surveyMsgDic[msg[i]] = msg[i]
        self.surveyMsgDicCount = self.surveyMsgDicCount + 1
    end
end
function SurveyDataManager:AddMsgData(id)
    self.surveyMsgDic[id] = id
    self.surveyMsgDicCount = self.surveyMsgDicCount + 1
end

function SurveyDataManager:IsHaveReceive(id)
    return self.surveyMsgDic[id] ~= nil
end

---@return  questionnaire_config_cell
function SurveyDataManager:GetDataByIndex(idx)
    local id = self.surveyIndexId[idx]

    return CommonHelper:GetTableDataByID(ConfigNames.questionnaire_config, id)
end

function SurveyDataManager:GetRewardById(id)
    local items = {}
    ---@type questionnaire_config_cell
    local cell = CommonHelper:GetTableDataByID(ConfigNames.questionnaire_config, id)

    local reward = stringSplit(cell.reward, ';')
    for i = 1, #reward do
        local rewardItem = stringSplit(reward[i], ',')
        table.insert(items, { num1 = tonumber(rewardItem[2]), num2 = tonumber(rewardItem[1]) })
    end
    return items
end

function SurveyDataManager:GetSurveyCount()
    return #self.surveyIndexId
end

function SurveyDataManager:IsHaveRedPoint()

    return #self.surveyIndexId > 0 and self.surveyMsgDicCount < #self.surveyIndexId

end

function SurveyDataManager:ClearData()
    self.curSelectId = -1
end



