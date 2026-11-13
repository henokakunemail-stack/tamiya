---@class CarVerifyHistoryView : ViewBase
CarVerifyHistoryView = class("CarVerifyHistoryView", ViewBase)

function CarVerifyHistoryView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "CarVerifyHistoryViewAction")
end

function CarVerifyHistoryView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("CarVerifyHistoryView")
    end)
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("CarVerifyHistoryView")
    end)
end

function CarVerifyHistoryView:OnOpen()

end
function CarVerifyHistoryView:SetData(idx,type)
    local str=""
    if type==CarVerifyHistoryOpenType.Save then
        str=CommonHelper:GetTempStr_Default(TemplateStringID.CarVerifyHistorySave)
    elseif type==CarVerifyHistoryOpenType.Look then
        str=CommonHelper:GetTempStr_Default(TemplateStringID.CarVerifyHistoryLook)
    end
    CommonHelper:SetText("###title",self.gameObject,str)
    self.CarData= CarDataManager:Get():GetCarDataByCarID(idx)
    ---@type VerifyCarHistoryData[]
    local list=self.CarData:GetVerifyAttrHistoryDataList()
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #list, 1,function(dataIndex, itemObj, scroll)
        CommonHelper:SetText("###idx",itemObj,dataIndex+1)
        if list[dataIndex+1].id==0 then
            CommonHelper:SetText("###name",itemObj,"")
            CommonHelper:SetText("###time",itemObj,"")
            CommonHelper:SetGameObjectActive("norecord",itemObj,true)
        else
            CommonHelper:SetText("###name",itemObj,list[dataIndex+1].Name)
            CommonHelper:SetText("###time",itemObj,list[dataIndex+1].Time)
            CommonHelper:SetGameObjectActive("norecord",itemObj,false)
        end
        CommonHelper:SetGameObjectActive("BtnReplase",itemObj,list[dataIndex+1].id~=0 and type==CarVerifyHistoryOpenType.Save)
        CommonHelper:SetGameObjectActive("BtnSave",itemObj,list[dataIndex+1].id==0 and type==CarVerifyHistoryOpenType.Save)
        CommonHelper:SetGameObjectActive("BtnLook",itemObj,list[dataIndex+1].id~=0 and type==CarVerifyHistoryOpenType.Look)
        CommonHelper:HButtonSetCallback("BtnReplase",itemObj,function (hbtn)
            UIManager:Get():OpenPopup("CommonInputView", CanvasType.FrontCanvas, "CommonInputView")
            local param = CommonInputViewParam()
            param.TitleName = CommonHelper:GetTempStr_Default(TemplateStringID.CarVerifyHistoryInputName)
            param.DefaultValue = list[hbtn.intData].Name
            param.InputHit = CommonHelper:GetTempStr_Default(TemplateStringID.CarVerifyHistoryInputNameHit)
            param.CharacterLimit = 8
            param.Func = self.SaveVerifyData
            param.FuncClass = self
            param.FuncParam = hbtn.intData
            UINotify:Get():SendNotification(UINotifyEvent.CommonInputView_SetData, param)
        end,dataIndex+1)
        CommonHelper:HButtonSetCallback("BtnSave",itemObj,function (hbtn)
            UIManager:Get():OpenPopup("CommonInputView", CanvasType.FrontCanvas, "CommonInputView")
            local param = CommonInputViewParam()
            param.TitleName = CommonHelper:GetTempStr_Default(TemplateStringID.CarVerifyHistoryInputName)
            param.DefaultValue = CommonHelper:GetTempStr_Default(TemplateStringID.CarVerifyHistoryNameDefault,hbtn.intData)
            param.InputHit = CommonHelper:GetTempStr_Default(TemplateStringID.CarVerifyHistoryInputNameHit)
            param.Func = self.SaveVerifyData
            param.CharacterLimit = 8
            param.FuncClass = self
            param.FuncParam = hbtn.intData
            UINotify:Get():SendNotification(UINotifyEvent.CommonInputView_SetData, param)
        end,dataIndex+1)
       CommonHelper:HButtonSetCallback("BtnLook",itemObj,function (hbtn)
           UINotify:Get():SendNotification(UINotifyEvent.Msg_PartVerifyAttr,{CarVerifyHistoryOpenType.Look,list[hbtn.intData].verifyAttr})
           UIManager:Get():HidePersistentView("CarVerifyHistoryView")
        end,dataIndex+1)
    end)
end

function CarVerifyHistoryView:OnClose()

end
function CarVerifyHistoryView:SaveVerifyData(param,value)
    local list=self.CarData:GetVerifyAttrHistoryDataList()
    if list[param].Time=="" then
       CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.VerifyCarSaveSuccess))
    end
    if list[param].Time~="" then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.VerifyCarUpdateSuccess))
    end
    self.CarData:SaveHistoryVerifyCar(param,value)
    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
end
