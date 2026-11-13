---@field GetUIModuleID fun(param:self):string
---@field gameObject  CS.UnityEngine.GameObject
---@field RequestOpen fun(param:self):void @可选重写
---@field OnOpen fun(param:self):string @可选重写
---@field OnClose fun(param:self):string @可选重写
---@class Page_ExaminationView
Page_ExaminationView = class("Page_ExaminationView", Page_WelfareViewBase)

function Page_ExaminationView:GetPageName()
    return "Page_ExaminationView"
end

function Page_ExaminationView:initialize(parentPref)
    self.parentPref = parentPref
end

function Page_ExaminationView:OnAwake()
    self.msg_Details = nil
    self.questionNum = nil

end

function Page_ExaminationView:RequestOpen()
    ExaminationSubsystem:Get():SendMsg_Question()
end

function Page_ExaminationView:OnOpen()

    --策划和美术对过了,就三个,死都不改
    self.BtnChooseA = CommonHelper:HButtonSetCallback("BtnChooseA", self.parentPref, function(data)
        self:VerdictTureOrFalse(1, self.BtnChooseA)
        CommonHelper:SetBtnDelayClick(self.BtnChooseA, 1, false)
    end)

    self.BtnChooseB = CommonHelper:HButtonSetCallback("BtnChooseB", self.parentPref, function(data)
        self:VerdictTureOrFalse(2, self.BtnChooseB)
        CommonHelper:SetBtnDelayClick(self.BtnChooseB, 1, false)
    end)

    self.BtnChooseC = CommonHelper:HButtonSetCallback("BtnChooseC", self.parentPref, function(data)
        self:VerdictTureOrFalse(3, self.BtnChooseC)
        CommonHelper:SetBtnDelayClick(self.BtnChooseC, 1, false)
    end)

    self.ui_tween_true_scale = UIUtil.GetTypeChildWightInputPath("ui_tween_true", self.parentPref, typeof(TweenScale))
    self.ui_tween_false_scale = UIUtil.GetTypeChildWightInputPath("ui_tween_false", self.parentPref, typeof(TweenScale))

    CommonHelper:SetTextColorByName("###text", self.BtnChooseA.gameObject, "000000")
    CommonHelper:SetTextColorByName("###text", self.BtnChooseB.gameObject, "000000")
    CommonHelper:SetTextColorByName("###text", self.BtnChooseC.gameObject, "000000")

    self:SetExaminationBtnOnEnable(true)

    CommonHelper:CSGameObjectSetActive(self.ui_tween_true_scale.gameObject, false)
    CommonHelper:CSGameObjectSetActive(self.ui_tween_false_scale.gameObject, false)

end

function Page_ExaminationView:VerdictTureOrFalse(chooseID, BtnParentObj)
    local _answer = CommonHelper:GetTableDataByID(ConfigNames.dictquestion_config,
            tonumber(self.questionNum[self.msg_Details.finish + 1]))

    local parentObj = UIUtil.GetChild("parent_obj", BtnParentObj.gameObject)
    local textObj = UIUtil.GetChild("###text", BtnParentObj.gameObject)
    local m_text = UIUtil.GetGameobjectComponent(textObj, typeof(Text))
    CommonHelper:SetTextColor(m_text, "FFFFFF")

    self:SetExaminationBtnOnEnable(false)

    if _answer.rightoption == chooseID then
        UIUtil.SetParentTransform(parentObj, self.ui_tween_true_scale, true, true)

        self.ui_tween_true_scale:ResetToBeginning()
        CommonHelper:CSGameObjectSetActive(self.ui_tween_true_scale.gameObject, true)
        CommonHelper:PlayTween(self.ui_tween_true_scale)

        self.cs_Start_T = cs_coroutine.start(function()
            coroutine.yield(CS.UnityEngine.WaitForSeconds(1.0))
            CommonHelper:SetTextColor(m_text, "000000")

            ExaminationSubsystem:Get():SendMsg_Answer(self.msg_Details.finish + 1)
            CommonHelper:CSGameObjectSetActive(self.ui_tween_true_scale.gameObject, false)

            self:SetExaminationBtnOnEnable(true)
        end)


    else
        UIUtil.SetParentTransform(parentObj, self.ui_tween_false_scale, true, true)

        self.ui_tween_false_scale:ResetToBeginning()
        CommonHelper:CSGameObjectSetActive(self.ui_tween_false_scale.gameObject, true)
        CommonHelper:PlayTween(self.ui_tween_false_scale)

        self.cs_Start_F = cs_coroutine.start(function()
            coroutine.yield(CS.UnityEngine.WaitForSeconds(1.0))
            CommonHelper:SetTextColor(m_text, "000000")

            audioResult = CommonHelper:Audio_PlayAudio("misanswer.wav", AudioType.VOICE, false, 1, 0)
            CommonHelper:CSGameObjectSetActive(self.ui_tween_false_scale.gameObject, false)

            self:SetExaminationBtnOnEnable(true)
        end)

    end

end

function Page_ExaminationView:InitDetailsData()
    self.msg_Details = WelfareBoxDataManager:Get():GetExaminationMsgData()
    self.questionNum = stringSplit(self.msg_Details.questions, ':')

    CommonHelper:SetText("###rateOfProgress", self.parentPref,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ExaminationRateOfProgress), self.msg_Details.finish + 1, #self.questionNum))
    CommonHelper:SetGameObjectActive("###rateOfProgress", self.parentPref, self.msg_Details.finish < #self.questionNum + 1)

    if self.msg_Details.finish == #self.questionNum + 1 then
        CommonHelper:SetText("DetailsTxt", self.parentPref,
                CommonHelper:GetTempStr_Default(TemplateStringID.ExaminationTodayOver))
        CommonHelper:CSGameObjectSetActive(self.BtnChooseA.gameObject, false)
        CommonHelper:CSGameObjectSetActive(self.BtnChooseB.gameObject, false)
        CommonHelper:CSGameObjectSetActive(self.BtnChooseC.gameObject, false)
    else
        self:InitShowData(self.questionNum[self.msg_Details.finish + 1])
        CommonHelper:CSGameObjectSetActive(self.BtnChooseA.gameObject, true)
        CommonHelper:CSGameObjectSetActive(self.BtnChooseB.gameObject, true)
        CommonHelper:CSGameObjectSetActive(self.BtnChooseC.gameObject, true)
    end
end

function Page_ExaminationView:InitShowData(showID)
    local question_Details = CommonHelper:GetTableDataByID(ConfigNames.dictquestion_config, tonumber(showID))
    CommonHelper:SetText("DetailsTxt", self.parentPref,
            CommonHelper:GetTempStr_Default(question_Details.questioncont))
    CommonHelper:SetText("BtnChooseA/###text", self.parentPref,
            CommonHelper:GetTempStr_Default(question_Details.option1))
    CommonHelper:SetText("BtnChooseB/###text", self.parentPref,
            CommonHelper:GetTempStr_Default(question_Details.option2))
    CommonHelper:SetText("BtnChooseC/###text", self.parentPref,
            CommonHelper:GetTempStr_Default(question_Details.option3))

end

function Page_ExaminationView:SetExaminationBtnOnEnable(isBool)
    self.BtnChooseA.enabled = isBool
    self.BtnChooseB.enabled = isBool
    self.BtnChooseC.enabled = isBool
end

function Page_ExaminationView:GetRedPointActive()
    return RedPointManager:Get():GetValue(RedPointID.S_Examination)
end

function Page_ExaminationView:OnClear()
    self.msg_Details = nil
    self.questionNum = nil

    if self.cs_Start_T then
        cs_coroutine.stop(self.cs_Start_T)
        self.cs_Start_T = nil
    end

    if self.cs_Start_F then
        cs_coroutine.stop(self.cs_Start_F)
        self.cs_Start_F = nil
    end

end

function Page_ExaminationView:OnClose()
    self:OnClear()
    CommonHelper:ReleasePool(UIModuleID.Examination)
end