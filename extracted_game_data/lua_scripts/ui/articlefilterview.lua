---@class ArticleFilterView : ViewBase
ArticleFilterView = class("ArticleFilterView", ViewBase)
local QualityType={
    TogWhite=1,
    TogGreen=2,
    TogBlue=3,
    TogPurple=4,
    TogOrange=5,
    TogRed=6
}
local PartStarType={
    Star1=1,
    Star2=2,
    Star3=3,
    Star4=4,
    Star5=5
}
local PartLvType={
    Low=1,--0-5
    Middle=2,--5-10
    High=3,--10-15
}
local PartLevel={
    Level_0=0,
    Level_5 =5,
    Level_10 =10,
    Level_15 =15

}
local ReformType={
    Yes=1,
    No=2,
}
local TurnOffOrOn={
    On=1,
    Off=0,
}
local _QualityGroup={true,true,true,true,true}
local _StarGroup={true,true,true,true,true}
local _LevelGroup={true,true,true}
local _IsReform={true,true}
local _TogAll_QualityGroup=true
local _TogAll_StarGroup=true
local _TogAll_LevelGroup=true
local _TogAll_IsReform=true
function ArticleFilterView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ArticleFilterViewAction")
    ---@type table<number,ArticleCell>
    self._ArticleData=nil
    ---@type table<number,AssembleSiftData>
    self._AssembleSiftData=nil
    self._CallBack=nil
end
function ArticleFilterView:Awake()

    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (data)
        self:OnCloseCallBack()
        UIManager:Get():ClosePopup()
    end)

    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (data)
        self:OnCloseCallBack()
        UIManager:Get():ClosePopup()
    end)

    self.TogWhite=CommonHelper:HButtonSetCallback("TogWhite",self.gameObject,function (data)
        self:Update_QualityGroup(QualityType.TogWhite)
      end)
    self.TogGreen=CommonHelper:HButtonSetCallback("TogGreen",self.gameObject,function (data)
        self:Update_QualityGroup(QualityType.TogGreen)
      end)
    self.TogBlue=CommonHelper:HButtonSetCallback("TogBlue",self.gameObject,function (data)
        self:Update_QualityGroup(QualityType.TogBlue)
      end)
     self.TogPurple=CommonHelper:HButtonSetCallback("TogPurple",self.gameObject,function (data)
         self:Update_QualityGroup(QualityType.TogPurple)
      end)
    self.TogOrange=CommonHelper:HButtonSetCallback("TogOrange",self.gameObject,function (data)
        self:Update_QualityGroup(QualityType.TogOrange)
      end)
    self.TogRed=CommonHelper:HButtonSetCallback("TogRed",self.gameObject,function (data)
        self:Update_QualityGroup(QualityType.TogRed)
      end)
    self.Tog5Star=CommonHelper:HButtonSetCallback("Tog5Star",self.gameObject,function (data)
        self:Update_StarGroup(PartStarType.Star5)
      end)
    self.Tog4Star=CommonHelper:HButtonSetCallback("Tog4Star",self.gameObject,function (data)
        self:Update_StarGroup(PartStarType.Star4)
      end)
    self.Tog3Star=  CommonHelper:HButtonSetCallback("Tog3Star",self.gameObject,function (data)
        self:Update_StarGroup(PartStarType.Star3)
      end)
    self.Tog2Star= CommonHelper:HButtonSetCallback("Tog2Star",self.gameObject,function (data)
        self:Update_StarGroup(PartStarType.Star2)
      end)
    self.Tog1Star=  CommonHelper:HButtonSetCallback("Tog1Star",self.gameObject,function (data)
        self:Update_StarGroup(PartStarType.Star1)
      end)
    self.TogLow= CommonHelper:HButtonSetCallback("TogLow",self.gameObject,function (data)
        self:Update_LevelGroup(PartLvType.Low)
     end)
    self.TogMiddle= CommonHelper:HButtonSetCallback("TogMiddle",self.gameObject,function (data)
        self:Update_LevelGroup(PartLvType.Middle)
     end)
    self.TogHigh= CommonHelper:HButtonSetCallback("TogHigh",self.gameObject,function (data)
        self:Update_LevelGroup(PartLvType.High)
     end)
    self.TogYes= CommonHelper:HButtonSetCallback("TogYes",self.gameObject,function (data)
        self:Update_IsReform(ReformType.Yes)
     end)
    self.TogNo= CommonHelper:HButtonSetCallback("TogNo",self.gameObject,function (data)
        self:Update_IsReform(ReformType.No)
     end)




    self.TogAll1= CommonHelper:HButtonSetCallback("TogAll1",self.gameObject,function (data)
        _TogAll_QualityGroup=not _TogAll_QualityGroup
        self:Update_TogAllGroup()
        _QualityGroup={_TogAll_QualityGroup,_TogAll_QualityGroup,_TogAll_QualityGroup,_TogAll_QualityGroup,_TogAll_QualityGroup}
        self:Update_QualityGroup(nil,false)
     end)
    self.TogAll2= CommonHelper:HButtonSetCallback("TogAll2",self.gameObject,function (data)
        _TogAll_StarGroup=not _TogAll_StarGroup
        self:Update_TogAllGroup()
        _StarGroup={_TogAll_StarGroup,_TogAll_StarGroup,_TogAll_StarGroup,_TogAll_StarGroup,_TogAll_StarGroup}
        self:Update_StarGroup(nil,false)
     end)
    self.TogAll3= CommonHelper:HButtonSetCallback("TogAll3",self.gameObject,function (data)
        _TogAll_LevelGroup=not _TogAll_LevelGroup
        self:Update_TogAllGroup()
        _LevelGroup={_TogAll_LevelGroup,_TogAll_LevelGroup,_TogAll_LevelGroup}
        self:Update_LevelGroup(nil,false)
     end)
    self.TogAll4= CommonHelper:HButtonSetCallback("TogAll4",self.gameObject,function (data)
        _TogAll_IsReform=not _TogAll_IsReform
        self:Update_TogAllGroup()
        _IsReform={_TogAll_IsReform,_TogAll_IsReform}
        self:Update_IsReform(nil,false)
     end)
end

function ArticleFilterView:Update_TogAllGroup()
    CommonHelper:SetToggleState(self.TogAll1,_TogAll_QualityGroup)
    CommonHelper:SetToggleState(self.TogAll2,_TogAll_StarGroup)
    CommonHelper:SetToggleState(self.TogAll3,_TogAll_LevelGroup)
    CommonHelper:SetToggleState(self.TogAll4,_TogAll_IsReform)
end
function ArticleFilterView:Update_QualityGroup(type,change)
      change=change==nil and true or change
    if change then
        _QualityGroup[type]=not _QualityGroup[type]
    end

     CommonHelper:SetToggleState(self.TogWhite,_QualityGroup[QualityType.TogWhite])
     CommonHelper:SetToggleState(self.TogGreen,_QualityGroup[QualityType.TogGreen])
     CommonHelper:SetToggleState(self.TogBlue,_QualityGroup[QualityType.TogBlue])
     CommonHelper:SetToggleState(self.TogPurple,_QualityGroup[QualityType.TogPurple])
     CommonHelper:SetToggleState(self.TogOrange,_QualityGroup[QualityType.TogOrange])
     CommonHelper:SetToggleState(self.TogOrange,_QualityGroup[QualityType.TogRed])

end
function ArticleFilterView:Update_StarGroup(type,change)
    change=change==nil and true or change
    if change then
        _StarGroup[type]=not _StarGroup[type]
    end
    CommonHelper:SetToggleState(self.Tog1Star,_StarGroup[PartStarType.Star1])
    CommonHelper:SetToggleState(self.Tog2Star,_StarGroup[PartStarType.Star2])
    CommonHelper:SetToggleState(self.Tog3Star,_StarGroup[PartStarType.Star3])
    CommonHelper:SetToggleState(self.Tog4Star,_StarGroup[PartStarType.Star4])
    CommonHelper:SetToggleState(self.Tog5Star,_StarGroup[PartStarType.Star5])
end
function ArticleFilterView:Update_LevelGroup(type,change)
    change=change==nil and true or change
    if change then
        _LevelGroup[type]=not _LevelGroup[type]
    end
    CommonHelper:SetToggleState(self.TogLow,_LevelGroup[PartLvType.Low])
    CommonHelper:SetToggleState(self.TogMiddle,_LevelGroup[PartLvType.Middle])
    CommonHelper:SetToggleState(self.TogHigh,_LevelGroup[PartLvType.High])
end
function ArticleFilterView:Update_IsReform(type,change)
    change=change==nil and true or change
    if change then
        _IsReform[type]=not _IsReform[type]
    end
    CommonHelper:SetToggleState(self.TogYes,_IsReform[ReformType.Yes])
    CommonHelper:SetToggleState(self.TogNo,_IsReform[ReformType.No])
end

function ArticleFilterView:OnOpen()

end

function ArticleFilterView:OnClose()
   self:SaveLocal()
end
function  ArticleFilterView:SetDefault(isUseLastResult)
    if isUseLastResult then
        _QualityGroup[QualityType.TogWhite]=PlayerPrefsHelper:GetValue_ArticleFilterTogWhite()
        _QualityGroup[QualityType.TogGreen]=PlayerPrefsHelper:GetValue_ArticleFilterTogGreen()
        _QualityGroup[QualityType.TogBlue]=PlayerPrefsHelper:GetValue_ArticleFilterTogBlue()
        _QualityGroup[QualityType.TogPurple]= PlayerPrefsHelper:GetValue_ArticleFilterTogPurple()
        _QualityGroup[QualityType.TogOrange]= PlayerPrefsHelper:GetValue_ArticleFilterTogOrange()
        _QualityGroup[QualityType.TogRed]= PlayerPrefsHelper:GetValue_ArticleFilterTogRed()
        _StarGroup[PartStarType.Star1]=PlayerPrefsHelper:GetValue_ArticleFilterStar1()
        _StarGroup[PartStarType.Star2]=PlayerPrefsHelper:GetValue_ArticleFilterStar2()
        _StarGroup[PartStarType.Star3]=PlayerPrefsHelper:GetValue_ArticleFilterStar3()
        _StarGroup[PartStarType.Star4]=PlayerPrefsHelper:GetValue_ArticleFilterStar4()
        _StarGroup[PartStarType.Star5]=PlayerPrefsHelper:GetValue_ArticleFilterStar5()
        _LevelGroup[PartLvType.Low]=PlayerPrefsHelper:GetValue_ArticleFilterLevelLow()
        _LevelGroup[PartLvType.Middle]=PlayerPrefsHelper:GetValue_ArticleFilterLevelMiddle()
        _LevelGroup[PartLvType.High]=PlayerPrefsHelper:GetValue_ArticleFilterLevelHigh()
        _IsReform[ReformType.Yes]=PlayerPrefsHelper:GetValue_ArticleFilterTogReformYes()
        _IsReform[ReformType.No]=PlayerPrefsHelper:GetValue_ArticleFilterTogReformNo()
        _TogAll_QualityGroup=true
        _TogAll_StarGroup=true
        _TogAll_LevelGroup=true
        _TogAll_IsReform=true
    else
        _QualityGroup={true,true,true,true,true}
        _StarGroup={true,true,true,true,true}
        _LevelGroup={true,true,true}
        _IsReform={true,true}
         _TogAll_QualityGroup=true
         _TogAll_StarGroup=true
         _TogAll_LevelGroup=true
         _TogAll_IsReform=true
    end
    self:Update_TogAllGroup()
    self:Update_QualityGroup(nil,false)
    self:Update_StarGroup(nil,false)
    self:Update_LevelGroup(nil,false)
    self:Update_IsReform(nil,false)
end
---@param articleList  AssembleSiftData[]
function ArticleFilterView:SetDataAssembleSift(articles,curarticle,isUseLastResult,func)
    self._ArticleData=nil
    self._AssembleSiftData=articles
    self._CallBack=func
    self._CurNode=curarticle
    self:SetDefault(isUseLastResult)
end
---@param articleList  ArticleCell[]
function ArticleFilterView:SetDataArticleCell(articles,isUseLastResult,func)
    self._ArticleData=articles
    self._AssembleSiftData=nil
    self._CallBack=func
    self:SetDefault(isUseLastResult)
end

function ArticleFilterView:SaveLocal()
    PlayerPrefsHelper:SetValue_ArticleFilterTogWhite(_QualityGroup[QualityType.TogWhite] and TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterTogGreen(_QualityGroup[QualityType.TogGreen] and TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterTogBlue(_QualityGroup[QualityType.TogBlue] and TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterTogPurple(_QualityGroup[QualityType.TogPurple] and TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterTogOrange(_QualityGroup[QualityType.TogOrange] and TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterTogRed(_QualityGroup[QualityType.TogRed] and TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterStar1(_StarGroup[PartStarType.Star1] and  TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterStar2(_StarGroup[PartStarType.Star2] and  TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterStar3(_StarGroup[PartStarType.Star3] and  TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterStar4(_StarGroup[PartStarType.Star4] and  TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterStar5(_StarGroup[PartStarType.Star5] and TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterLevelLow(_LevelGroup[PartLvType.Low]and TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterLevelMiddle(_LevelGroup[PartLvType.Middle]and TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterLevelHigh(_LevelGroup[PartLvType.High]and TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterTogReformYes(_IsReform[ReformType.Yes]and TurnOffOrOn.On or TurnOffOrOn.Off)
    PlayerPrefsHelper:SetValue_ArticleFilterTogReformNo(_IsReform[ReformType.No]and TurnOffOrOn.On or TurnOffOrOn.Off)
end

function ArticleFilterView:OnCloseCallBack()
    local result={}
    if self._ArticleData then
        for i, v in pairs(self._ArticleData) do
            if self:ArticleFilterQuality(v) then
                table.insert(result,v)
            end
        end
        result =self:ArticleFilterArticleCell(result)
    end
    if self._AssembleSiftData then
        for i, v in pairs(self._AssembleSiftData) do
            if self:ArticleFilterQuality(v:GetArticle()) or (self._CurNode and  self._CurNode:GetCellID() == v:GetArticle():GetCellID()) then
                table.insert(result,v)
            end
        end
        result =self:ArticleFilter_AssembleSiftData(result)
    end

    if self._CallBack then
        self._CallBack(result)
    end
end
function ArticleFilterView:ArticleFilterArticleCell(result)
    local result2={}
    local result3={}
    local result4={}
    for i, v in pairs(result) do
        if self:ArticleFilterStar(v) then
            table.insert(result2,v)
        end
    end
    for i, v in pairs(result2) do
        if self:ArticleFilterLV(v) then
            table.insert(result3,v)
        end
    end
    for i, v in pairs(self.result3) do
        if self:ArticleFilterReform(v) then
            table.insert(result4,v)
        end
    end
    return result4
end

function ArticleFilterView:ArticleFilter_AssembleSiftData(result)
    local result2={}
    local result3={}
    local result4={}
    for i, v in pairs(result) do
        if self:ArticleFilterStar(v:GetArticle()) or (self._CurNode and  self._CurNode:GetCellID() == v:GetArticle():GetCellID()) then
            table.insert(result2,v)
        end
    end
    for i, v in pairs(result2) do
        if self:ArticleFilterLV(v:GetArticle()) or (self._CurNode and  self._CurNode:GetCellID() == v:GetArticle():GetCellID()) then
            table.insert(result3,v)
        end
    end
    for i, v in pairs(result3) do
        if self:ArticleFilterReform(v:GetArticle()) or (self._CurNode and  self._CurNode:GetCellID() == v:GetArticle():GetCellID()) then
            table.insert(result4,v)
        end
    end
    return result4
end

---@param arg ArticleCell
function ArticleFilterView:ArticleFilterQuality(arg)
    local result=false
    if _QualityGroup[QualityType.TogWhite] and arg:GetPartQuality()==QualityType.TogWhite then
        result=true
    elseif _QualityGroup[QualityType.TogGreen] and arg:GetPartQuality()==QualityType.TogGreen then
        result=true
    elseif _QualityGroup[QualityType.TogBlue] and arg:GetPartQuality()==QualityType.TogBlue then
        result=true
    elseif _QualityGroup[QualityType.TogPurple] and arg:GetPartQuality()==QualityType.TogPurple then
        result=true
    elseif _QualityGroup[QualityType.TogOrange] and arg:GetPartQuality()==QualityType.TogOrange then
        result=true
    elseif _QualityGroup[QualityType.TogRed] and arg:GetPartQuality()==QualityType.TogRed then
        result=true
    end
    return result
end

function ArticleFilterView:ArticleFilterStar(arg)
    local result=false
    if _StarGroup[PartStarType.Star1] and arg:GetStar()==PartStarType.Star1 then
        result=true
    elseif _StarGroup[PartStarType.Star2] and arg:GetStar()==PartStarType.Star2 then
        result=true
    elseif _StarGroup[PartStarType.Star3] and arg:GetStar()==PartStarType.Star3 then
        result=true
    elseif _StarGroup[PartStarType.Star4] and arg:GetStar()==PartStarType.Star4 then
        result=true
    elseif _StarGroup[PartStarType.Star5] and arg:GetStar()==PartStarType.Star5 then
        result=true
    end
    return result
end
function ArticleFilterView:ArticleFilterLV(arg)
    local result=false
    if _LevelGroup[PartLvType.Low] and arg:GetPartLV()>=PartLevel.Level_0 and arg:GetPartLV()<=PartLevel.Level_5 then
        result=true
    elseif _LevelGroup[PartLvType.Middle] and arg:GetPartLV()>PartLevel.Level_5 and arg:GetPartLV()<=PartLevel.Level_10 then
        result=true
    elseif _LevelGroup[PartLvType.High] and arg:GetPartLV()>PartLevel.Level_10 and arg:GetPartLV()<=PartLevel.Level_15 then
        result=true
    end
    return result
end
function ArticleFilterView:ArticleFilterReform(arg)
    local result=false
    if _IsReform[ReformType.Yes] and arg:GetPartIsReform() then
        result=true
    elseif _IsReform[ReformType.No] and arg:GetPartIsReform()==false then
        result=true
    end
    return result
end







