---@class Page_ChallengeSelectCar:Page_SelectCarBase
Page_ChallengeSelectCar=class("Page_ChallengeSelectCar",Page_SelectCarBase)
function Page_ChallengeSelectCar:initialize()

end
---@param page_selectCar Page_SelectCar
function Page_ChallengeSelectCar:SetData(root,param,page_selectCar)

    ---
    local data=SpecialTrainingDataManager:Get():GetSelectCopy()
    local temData=SpecialTrainingDataManager:Get():GetCurChallengeTeam()
    CommonHelper:SetText("###challengeTittle",root,CommonHelper:GetTempStr_Default(temData.name))
    CommonHelper:SetText("###challengeDesc",root,CommonHelper:GetTempStr_Default(temData.desc))
    local reward1=CommonHelper:ParseToReward2(data.reward3)
    local reward2=CommonHelper:ParseToReward2(data.reward4)
    local moreRowScrollView1=UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_1",root,typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(moreRowScrollView1,#reward1,1,function(index, itemObj,scroll)
        local temp = reward1[index + 1]
        local obj = UIUtil.GetChild("ItemArticleSelectTeam", itemObj)
        local param = Param_PropParam()
        param.moduleId = UIModuleID.SelectTeam
        param.id = temp.id
        param.count = temp.num
        param.BtnFun=true
        CommonHelper:SetPropGroup(obj, param)
        CommonHelper:HButtonSetCallback("BtnItem",itemObj,function(data)
            CommonHelper:ShowPartInfoByCfgId(data.intData,UIModuleID.SelectTeam)
        end,temp.id)
        CommonHelper:SetGameObjectActive("first", itemObj, false)
    end)
    local moreRowScrollView2=UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_2",root,typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(moreRowScrollView2,#reward2,1,function(index, itemObj,scroll)
        local temp = reward2[index + 1]
        local obj = UIUtil.GetChild("ItemArticleSelectTeam", itemObj)
        local param = Param_PropParam()
        param.moduleId = UIModuleID.SelectTeam
        param.id = temp.id
        param.count = temp.num
        param.BtnFun=true
        CommonHelper:SetPropGroup(obj, param)
        CommonHelper:HButtonSetCallback("BtnItem",itemObj,function(data)
            CommonHelper:ShowPartInfoByCfgId(data.intData,UIModuleID.SelectTeam)
        end,temp.id)
        CommonHelper:SetGameObjectActive("first", itemObj, false)
    end)

    CommonHelper:HButtonSetCallback("BtnFight",root,function(data)
        local data = page_selectCar:GetCurCar()
        if data then
            SpecialTrainingDataManager:Get():SetCurSelectCarData(data)
            local rankData=SpecialTrainingDataManager:Get():GetSelectCopy()
            ChallengeSubsystem:Get():SendBeginChallenge(rankData.id,data:GetID())
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarInParkingLot))
        end
    end)

end