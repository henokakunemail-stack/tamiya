---@class DebugView : ViewBase
DebugView = class("DebugView", ViewBase)

-- View必加
function DebugView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "DebugViewAction")

end
local _SelectIp=0
local _SelectLogType=DebugLogType.Error
local _IsShowFps=false

function DebugView:Awake()
    self.main=self:GetChildWightByParent("function",self.gameObject,typeof(CanvasGroup))
    self.LogView=self:GetChildWightByParent("LogView",self.gameObject,typeof(CanvasGroup))
    self.LevelBattleView=self:GetChildWightByParent("LevelBattleView",self.gameObject,typeof(CanvasGroup))
    self.SelectServerView=self:GetChildWightByParent("SelectServerView",self.gameObject,typeof(CanvasGroup))
    self:InitLogView()
    self:InitMainView()
    self:InitSelectServerView()
    self:InitLevelBattleView()
end
function DebugView:InitSelectServerView()
    self.ipInput=self:GetChildWightByParent("IpInput",self.SelectServerView.gameObject,typeof(InputField))
    self.ipInput.text=GameProperties.LoginUrl
    for i = 1, #DebugLogDataManager:Get().IpList do
        if GameProperties.LoginUrl==DebugLogDataManager:Get().IpList[i] then
            _SelectIp=i
        end
    end
    CommonHelper:HButtonSetCallback("SelectServerOkBtn",self.SelectServerView.gameObject,function(param)
        if _SelectIp>#DebugLogDataManager:Get().IpList then
            DebugLogDataManager:Get():SetIp(_SelectIp,self.ipInput.text)
        else
            DebugLogDataManager:Get():SetIp(_SelectIp)
        end
        PlayerPrefsHelper:SetValue_LoginUrl(DebugLogDataManager:Get().selectIp)
        --GameProperties:OnGameToolsClose()
        UIUtil.ShowCanvasGroup(self.SelectServerView,false)
    end)
    self.ip1= CommonHelper:HButtonSetCallback("TogSelectText1",self.SelectServerView.gameObject,function(param)
        _SelectIp=1
        self:UpdateIpTog()
    end)
    self.ip2=CommonHelper:HButtonSetCallback("TogSelectText2",self.SelectServerView.gameObject,function(param)
        _SelectIp=2
        self:UpdateIpTog()
    end)
    self.ip3=CommonHelper:HButtonSetCallback("TogSelectText3",self.SelectServerView.gameObject,function(param)
        _SelectIp=3
        self:UpdateIpTog()
    end)
    self.ip4=CommonHelper:HButtonSetCallback("TogSelectText4",self.SelectServerView.gameObject,function(param)
        _SelectIp=4
        self:UpdateIpTog()
    end)
    self.ip5=CommonHelper:HButtonSetCallback("TogSelectText5",self.SelectServerView.gameObject,function(param)
        _SelectIp=5
        self:UpdateIpTog()
    end)
   self.ip6=CommonHelper:HButtonSetCallback("TogSelectText6",self.SelectServerView.gameObject,function(param)
        _SelectIp=6
        self:UpdateIpTog()
    end)
   self.ip7=CommonHelper:HButtonSetCallback("TogSelectText7",self.SelectServerView.gameObject,function(param)
        _SelectIp=7
        self:UpdateIpTog()
    end)
 self.ip9=CommonHelper:HButtonSetCallback("TogSelectText9",self.SelectServerView.gameObject,function(param)
        _SelectIp=9
        self:UpdateIpTog()
    end)
    self.ip8=CommonHelper:HButtonSetCallback("TogSelectText8",self.SelectServerView.gameObject,function(param)
        _SelectIp=8
        self:UpdateIpTog()
    end)
    CommonHelper:HButtonSetCallback("BackBth", self.SelectServerView.gameObject, function(param)
        -- UIUtil.ShowCanvasGroup(self.main,true)
        UIUtil.ShowCanvasGroup(self.SelectServerView,false)
    end)
end







function DebugView:InitLevelBattleView()

    CommonHelper:HButtonSetCallback("BackBth", self.LevelBattleView.gameObject, function(param)
        -- UIUtil.ShowCanvasGroup(self.main,true)
        UIUtil.ShowCanvasGroup(self.LevelBattleView,false)
    end)
    if CommonHelper:IsNullOrEmpty(CommonHelper:GetInputFieldText("IndexInput",self.LevelBattleView.gameObject)) then
        CommonHelper:SetInputFieldText("IndexInput",self.LevelBattleView.gameObject,1)
    end
    CommonHelper:SetInputFieldText("IndexInputspeed",self.LevelBattleView.gameObject,PlayerPrefsHelper:GetValue_GuideBattleSpeed())
    self.NpcBtn={}
    for i = 1, 5 do
        self.NpcBtn[i]=CommonHelper:HButtonSetCallback("NpcNum"..i, self.LevelBattleView.gameObject, function(param)
            self.SelectNpc=self.LevelData.BattleInfoList[self.LevelSession].NpcIds[param.intData]
            self:SetAttrsData()
        end,i)
    end
    CommonHelper:SetInputFieldOnValueChanged("IndexInput", self.LevelBattleView.gameObject,function(str)
        local  inx=tonumber(CommonHelper:GetInputFieldText("IndexInput",self.LevelBattleView.gameObject))
        if self.LevelData and self.LevelData.BattleInfoList[inx]~=nil  then
            self.LevelSession=inx
            if self.LevelData.BattleInfoList[self.LevelSession].NpcIds[self.SelectNpc]==nil then
                self.SelectNpc=self.LevelData.BattleInfoList[self.LevelSession].NpcIds[1]
            end
            self:SetAttrsData()
        else
            CommonHelper:SetInputFieldText("IndexInput",self.LevelBattleView.gameObject,tostring(#self.LevelData.BattleInfoList))
            CommonTipsHelper:Get():ShowCenterTips("最大就是--->"..tostring(#self.LevelData.BattleInfoList))
        end
    end)
    CommonHelper:SetInputFieldOnValueChanged("IpInput", self.LevelBattleView.gameObject,function(str)
        local  id=tonumber(CommonHelper:GetInputFieldText("IpInput",self.LevelBattleView.gameObject))
        local data=nil
        ---@type pvelevel_config
        local pvelevel_config= ClientDataManager:Get():GetDataTable(ConfigNames.dictactivitycopy_config)
        for k,v in pairs(pvelevel_config.GetConfigData())  do
            if v.copytype~=LevelType.Story and v.C_ID==id then
                data=v
                break
            end
        end
        if data==nil then
            ---@type pvelevel_config
            pvelevel_config= ClientDataManager:Get():GetDataTable(ConfigNames.pvelevel_config)
            for k,v in pairs(pvelevel_config.GetConfigData())  do
                if v.copytype~=LevelType.Story and v.C_ID==id then
                    data=v
                    break
                end
            end
        else
            self.LevelType="活动章节"
        end
        if data==nil then
            ---@type pvelevel_config
            pvelevel_config= ClientDataManager:Get():GetDataTable(ConfigNames.dicthidecopy_config)
            for k,v in pairs(pvelevel_config.GetConfigData())  do
                if v.copytype~=LevelType.Story and v.C_ID==id then
                    data=v
                    break
                end
            end
            if data then
                self.LevelType="难点测试"
            end
        else
            self.LevelType="剧情"
        end
        if data  then

            self.LevelSession=1
            self.LevelId=id
            self.LevelData=data
            self.SelectNpc=self.LevelData.BattleInfoList[self.LevelSession].NpcIds[1]
            if data.BattleInfoList[self.LevelSession]==nil then
                return
            end
            self:SetAttrsData()
        end
    end)



    CommonHelper:HButtonSetCallback("SelectServerOkBtn", self.LevelBattleView.gameObject, function(param)
      UIManager:Get():ClosePopup()
      UIUtil.ShowCanvasGroup(self.LevelBattleView,false)
        PlayerPrefsHelper:SetValue_GuideBattleSpeed(tonumber(CommonHelper:GetInputFieldText("IndexInputspeed",self.LevelBattleView.gameObject)))
      CommonHelper:PlayLevelBattleMore(tonumber(CommonHelper:GetInputFieldText("IpInput",self.LevelBattleView.gameObject)),self.SelectNpc)
    end)

  CommonHelper:HButtonSetCallback("BattleOne", self.LevelBattleView.gameObject, function(param)
      UIManager:Get():ClosePopup()
      UIUtil.ShowCanvasGroup(self.LevelBattleView,false)
      PlayerPrefsHelper:SetValue_GuideBattleSpeed(tonumber(CommonHelper:GetInputFieldText("IndexInputspeed",self.LevelBattleView.gameObject)))
      CommonHelper:PlayLevelBattleOne(tonumber(CommonHelper:GetInputFieldText("IpInput",self.LevelBattleView.gameObject)),self.SelectNpc)
      for i = 1, #self.attrs do
          print(i,self.attrs[i][3])
      end
    end)
  CommonHelper:HButtonSetCallback("SelectServerOkBtn2", self.LevelBattleView.gameObject, function(param)
      UIManager:Get():ClosePopup()
      UIUtil.ShowCanvasGroup(self.LevelBattleView,false)
      PlayerPrefsHelper:SetValue_GuideBattleSpeed(tonumber(CommonHelper:GetInputFieldText("IndexInputspeed",self.LevelBattleView.gameObject)))
      CommonHelper:PlayActivityLevelBattleMore(tonumber(CommonHelper:GetInputFieldText("IpInput",self.LevelBattleView.gameObject)),self.SelectNpc)
    end)
  CommonHelper:HButtonSetCallback("BattleOne2", self.LevelBattleView.gameObject, function(param)
      UIManager:Get():ClosePopup()
      UIUtil.ShowCanvasGroup(self.LevelBattleView,false)
      PlayerPrefsHelper:SetValue_GuideBattleSpeed(tonumber(CommonHelper:GetInputFieldText("IndexInputspeed",self.LevelBattleView.gameObject)))
      CommonHelper:PlayActivityLevelBattleOne(tonumber(CommonHelper:GetInputFieldText("IpInput",self.LevelBattleView.gameObject)),self.SelectNpc)
    end)

    CommonHelper:HButtonSetCallback("BattleOne4", self.LevelBattleView.gameObject, function(param)
        UIManager:Get():ClosePopup()
        UIUtil.ShowCanvasGroup(self.LevelBattleView,false)
        PlayerPrefsHelper:SetValue_GuideBattleSpeed(tonumber(CommonHelper:GetInputFieldText("IndexInputspeed",self.LevelBattleView.gameObject)))
        CommonHelper:PlayRaceSeniorTrainBattleOne(tonumber(CommonHelper:GetInputFieldText("IpInput",self.LevelBattleView.gameObject)),self.SelectNpc)
    end)
    CommonHelper:HButtonSetCallback("SelectServerOkBtn4", self.LevelBattleView.gameObject, function(param)
        UIManager:Get():ClosePopup()
        UIUtil.ShowCanvasGroup(self.LevelBattleView,false)
        PlayerPrefsHelper:SetValue_GuideBattleSpeed(tonumber(CommonHelper:GetInputFieldText("IndexInputspeed",self.LevelBattleView.gameObject)))
        CommonHelper:PlayRaceSeniorTrainBattleMore(tonumber(CommonHelper:GetInputFieldText("IpInput",self.LevelBattleView.gameObject)),self.SelectNpc)
    end)

    CommonHelper:HButtonSetCallback("BattleOne3", self.LevelBattleView.gameObject, function(param)
      UIManager:Get():ClosePopup()
      UIUtil.ShowCanvasGroup(self.LevelBattleView,false)
        PlayerPrefsHelper:SetValue_GuideBattleSpeed(tonumber(CommonHelper:GetInputFieldText("IndexInputspeed",self.LevelBattleView.gameObject)))
        if self.RaceLocalData then
            local index=self.RaceLocalData:GetDefaultId()
            for i = 1, #self.attrs do
                self.RaceLocalData.PlayerList[index].attr[i]=self.attrs[i][3]
            end
            CommonHelper:PlayLevelBattleOneByRaceLocalData(self.RaceLocalData)
        end
    end)
end
function DebugView:SetAttrsData()
    local temp=RaceLocalData()
    temp:SetDataByLevelData(self.LevelId.."_"..self.LevelSession,self.LevelData.BattleInfoList[self.LevelSession],self.SelectNpc)
    self:SetAttrs(temp)
    self:SetBtnState()
    CommonHelper:SetText("leveltype",self.gameObject,self.LevelType.."_"..#self.LevelData.BattleInfoList)
    CommonHelper:SetInputFieldText("IndexInput",self.gameObject,tostring(self.LevelSession))
end




function DebugView:SetBtnState()
    for i = 1, #self.NpcBtn do
        CommonHelper:SetGameObjectActive("select",self.NpcBtn[i].gameObject,self.SelectNpc==self.LevelData.BattleInfoList[self.LevelSession].NpcIds[i])
        CommonHelper:CSGameObjectSetActive(self.NpcBtn[i].gameObject,self.LevelData.BattleInfoList[self.LevelSession].NpcIds[i]~=nil)
    end
end
---@param param RaceLocalData
function DebugView:SetAttrs(param)
    self.attrs={}
    self.RaceLocalData=param
    --if self.RaceLocalData then
    --    local levelId=stringSplitToNumber(self.RaceLocalData.LevelId,'_')[1]
    --    local count=stringSplitToNumber(self.RaceLocalData.LevelId,'_')[2]
    --    self.SelectNpc=count
    --    self:SetBtnState()
    --end
    if param then
        ---@type RaceLocalPlayerData[]
        local NpcList=param.PlayerList
        for i = 1, #NpcList do
            if NpcList[i].pid==self.SelectNpc then
                for k, v in pairs(NpcList[i].attr) do
                    table.insert(self.attrs,{param.Default,k,v})
                end
            end
        end
        table.sort(self.attrs,function(a, b)
            return a[2]<b[2]
        end)
        local MoreRowScrollView = self:GetChildWightByParent("MoreRowScrollView_H", self.LevelBattleView.gameObject, typeof(MoreRowScrollView))
        CommonHelper:InitMoreRowScrollView(MoreRowScrollView,#self.attrs,1,function(index, itemObj,scroll)
            CommonHelper:SetText("Text",itemObj,"id:"..self.attrs[index+1][1]..":属性id:"..self.attrs[index+1][2]..":"..CommonHelper:GetAttrName(self.attrs[index+1][2]-1))
            CommonHelper:SetInputFieldText("IpInput",itemObj,self.attrs[index+1][3])
            CommonHelper:InputFieldRemoveAllListener("IpInput",itemObj)
            CommonHelper:HButtonSetCallback("HButton",itemObj,function(data)
                if self.attrs[data.intData+1] then
                    self.attrs[data.intData+1][3]=tonumber(CommonHelper:GetInputFieldText("IpInput",itemObj))
                end
            end,index)
        end)

        local sceneCfg=CommonHelper:GetTableDataByID(ConfigNames.scene_config,param.SceneID)
        local weatherCfg=CommonHelper:GetTableDataByID(ConfigNames.weather_config,sceneCfg.weather)
        print("天气"..CommonHelper:GetTempStr_Default(weatherCfg.name))
    end

end
function DebugView:InitLogView()
    self.ExceptionView=self:GetChildWightByParent("ExceptionView",self.LogView.gameObject,typeof(Text))
    --self.Content=self:GetChild("errorview")
    --self.tempChilds=self:GetChild("tempChilds")
    --self.errortext=self:GetChild("errortext")
    --{{{
    self.TogLog=CommonHelper:HButtonSetCallback("TogLog",self.LogView.gameObject,function(param)
        _SelectLogType=DebugLogType.Log
        self:UpdateLogView()
    end)
    self.TogWarring=CommonHelper:HButtonSetCallback("TogWarring",self.LogView.gameObject,function(param)
        _SelectLogType=DebugLogType.Warning
        self:UpdateLogView()
    end)
    self.TogError=CommonHelper:HButtonSetCallback("TogError",self.LogView.gameObject,function(param)
        _SelectLogType=DebugLogType.Error
        self:UpdateLogView()
    end)
    self.TogException=CommonHelper:HButtonSetCallback("TogException",self.LogView.gameObject,function(param)
        _SelectLogType=DebugLogType.Exception
        self:UpdateLogView()
    end)
    self.TogAssert=CommonHelper:HButtonSetCallback("TogAssert",self.LogView.gameObject,function(param)
        _SelectLogType=DebugLogType.Assert
        self:UpdateLogView()
    end)
    CommonHelper:HButtonSetCallback("copybtn",self.LogView.gameObject,function(param)
       local temp= self.ExceptionView.text
        CommonHelper:WriteClipboart(temp)
    end)
    --}}}
    --self. bigBgImageTrans = self:GetChildByParent("ScrollView/Viewport/Content", self.gameObject)
    CommonHelper:HButtonSetCallback("BackBth", self.LogView.gameObject, function(param)
        -- UIUtil.ShowCanvasGroup(self.main,true)
        UIManager:Get():ClosePopup()
    end)
end
function DebugView:InitMainView()

    CommonHelper:HButtonSetCallback("FpsBtn",self.main.gameObject,function(param)
        if _IsShowFps==false then
            _IsShowFps=true
            GameProperties:ShowFps()
        else
            --_IsShowFps=false
            --GameProperties:CloseFps()
        end

    end)
    CommonHelper:HButtonSetCallback("LogBtn", self.main.gameObject, function(param)
        --UIUtil.ShowCanvasGroup(self.main,false)
        --self:SetLogView(_SelectLogType)
        UIUtil.ShowCanvasGroup(self.LogView,true)
    end)
    CommonHelper:HButtonSetCallback("GmBtn", self.main.gameObject, function(param)
        UIManager:Get():OpenView("GMView",CanvasType.TopCanvas,"GMView")
    end)
    CommonHelper:HButtonSetCallback("IPAddres",self.main.gameObject,function(param)
        LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, false, nil, false)
    end)
  CommonHelper:HButtonSetCallback("SelectServerBtn",self.main.gameObject,function(param)
      UIUtil.ShowCanvasGroup(self.SelectServerView,true)
    end)
  CommonHelper:HButtonSetCallback("ClearRes",self.main.gameObject,function(param)
     LoginFuncHelper:ReleaseAllAssets()
    end)
    CommonHelper:HButtonSetCallback("RankListTestVerify",self.main.gameObject,function(param)
        RankListTestVerifyDataManager:Get():Begin()
    end)
    CommonHelper:HButtonSetCallback("RankListRlCurServerTestVerify",self.main.gameObject,function(param)
        RankListTestVerifyDataManager:Get():LoginRlSpeedRankData()
    end)
    CommonHelper:HButtonSetCallback("RankListCurServerTestVerify",self.main.gameObject,function(param)
        RankListTestVerifyDataManager:Get():LoginSpeedRankData()
    end)


    CommonHelper:HButtonSetCallback("SeasonBtn",self.main.gameObject,function(param)
        CommonSubsystem:SendMsg_RePlayBattle(CommonHelper:GetInputFieldText("seasonInput",self.main.gameObject),CommonHelper:GetInputFieldText("idInput",self.main.gameObject),RaceProtectType.Normal)
    end)
    CommonHelper:HButtonSetCallback("SeasonBtn1",self.main.gameObject,function(param)
        CommonSubsystem:SendMsg_RePlayBattle(CommonHelper:GetInputFieldText("seasonInput",self.main.gameObject),CommonHelper:GetInputFieldText("idInput",self.main.gameObject),RaceProtectType.Protect)
    end)
    CommonHelper:HButtonSetCallback("PveBackBtn",self.main.gameObject,function(param)
        local  param=stringSplitToNumber(CommonHelper:GetInputFieldText("idInput",self.main.gameObject),":")
        ChapterSubsystem:Get():SendMsg_GetChapterRank(param[1],param[2],param[3],param[4])
    end)


    CommonHelper:HButtonSetCallback("BgBth", self.main.gameObject, function(param)
        --GameProperties:OnGameToolsClose()
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:SetSpeedChange()
    CommonHelper:HButtonSetCallback("LocalBattle", self.main.gameObject, function(param)
        CommonHelper:PlayLocalBattle()
    end)
    CommonHelper:HButtonSetCallback("LevelBattle", self.main.gameObject, function(param)
        UIUtil.ShowCanvasGroup(self.LevelBattleView,true)
        self:SetAttrs(PveLevelTestBattleDataManager:Get().CurBattleData)
    end)
    CommonHelper:HButtonSetCallback("TestBattleDone", self.main.gameObject, function(param)
        PveLevelTestBattleDataManager:Get():Break()
    end)
    CommonHelper:HButtonSetCallback("SkipGuide", self.main.gameObject, function(param)
        --baonameC103
        NewBieSubSystem:Get():SendMsgUpdateGuideStepRes(CommonHelper:GetInputFieldText("seasonInput",self.main.gameObject))
    end)
    CommonHelper:HButtonSetCallback("ExecuteGuide", self.main.gameObject, function(param)
        GuideManager:Get():Init(tonumber(CommonHelper:GetInputFieldText("seasonInput",self.main.gameObject)),true)
        self:CheckNewBieGuide(nil,GuideTriggerType.LevelTrigger)
    end)
    CommonHelper:HButtonSetCallback("Getlog", self.main.gameObject, function(param)
        local Datas={}
        mono.ReadAllLogLinesFile(CommonHelper:GetInputFieldText("seasonInput",self.main.gameObject),function(str)
            table.insert(Datas,Dll_JSON.decode(str))
        end)
     --{{{ 1
        local Temp={}
        local Temp2={}
        for k, v in pairs(Datas) do
            if not CommonHelper:IsNullOrEmpty(v.properties) then
               local properties=Dll_JSON.decode(v.properties)
                if Temp[properties.device]==nil then
                     Temp[properties.device]={}
                end
                if Temp2[properties.Error]==nil then
                    Temp2[properties.Error]={}
                end
                if Temp[properties.device][properties.FileName]==nil then
                    Temp[properties.device][properties.FileName]={}
                end
                if  Temp[properties.device][properties.FileName][properties.Error]==nil then
                    Temp[properties.device][properties.FileName][properties.Error]={}
                end
                table.insert( Temp2[properties.Error],properties)
                if properties.Error~="404" or properties.Error~="5" then
                    table.insert( Temp[properties.device][properties.FileName][properties.Error],properties)
                else
                    print("errorfile---",properties.FileName,properties.Error)
                end
            end
        end
        --local errorPlayerCount=0
        --for k, v in pairs(Temp) do
        --    errorPlayerCount=errorPlayerCount+1
        --    local errorFileCount=0
        --    for m, n in pairs(v) do
        --        errorFileCount=errorFileCount+1
        --        local errorFileCountError=0
        --        for f, g in pairs(n) do
        --            print("errorFileCountError----->>>>",k,m,f,#g)
        --        end
        --        print("errorFileCountError",k,m,errorFileCountError)
        --    end
        --    print("errorFileCount",k,errorFileCount)
        --end
        for k, v in pairs(Temp2) do
            print("errorFileCount",k,#v)
        end
      --  print("errorPlayerCount",errorPlayerCount)
        --}}}
        --{{{
        --local Temp={}
        --local Temps={}
        --for k, v in pairs(Datas) do
        --    if v.event_name=="AppStart" then
        --        if not CommonHelper:IsNullOrEmpty(v.properties) then
        --            local properties=Dll_JSON.decode(v.properties)
        --            if Temp[properties.State]==nil then
        --                Temp[properties.State]={}
        --            end
        --            if Temps[properties.device]==nil then
        --                Temps[properties.device]={}
        --            end
        --            if Temps[properties.device][properties.State]==nil then
        --                Temps[properties.device][properties.State]={}
        --            end
        --            if Temp[properties.State][properties.device]==nil then
        --                Temp[properties.State][properties.device]={}
        --            end
        --            table.insert( Temp[properties.State][properties.device],properties)
        --            table.insert( Temps[properties.device][properties.State],properties)
        --        end
        --    end
        --end
        --local States={}
        --
        --   States["App_Init"]=1
        --   States["HotFix_Start"]=2
        --   States["HotFix_End"]=3
        --   States["App_NoHotFix_Init"]=4
        --   States["App_Hotfix_End_Init"]=5
        --local result={}
        --for k, v in pairs(Temps) do
        --    for m, n in pairs(States) do
        --        if v[m]==nil  then
        --            if result[k]==nil then
        --                result[k]={}
        --                result[k]={value=k,flag={},otherData=v}
        --            end
        --            table.insert(result[k].flag,m)
        --        end
        --    end
        --end
        --for k, v in pairs(result) do
        --    print("状态筛选结果",#result)
        --    CS.MonoHelper.AppendToRankListFileExist("State没有",Dll_JSON.encode(v).."\n")
        --end

        --for k, v in pairs(Temp) do
        --    for m, n in pairs(v) do
        --        print(k,m,#n)
        --        for i, j in pairs(n) do
        --
        --        end
        --    end
        --    print("State",k)
        --end

        --}}}
    end)

end
function DebugView:UpdateIpTog()
    CommonHelper:SetToggleState(self.ip1,_SelectIp==1)
    CommonHelper:SetToggleState(self.ip2,_SelectIp==2)
    CommonHelper:SetToggleState(self.ip3,_SelectIp==3)
    CommonHelper:SetToggleState(self.ip4,_SelectIp==4)
    CommonHelper:SetToggleState(self.ip5,_SelectIp==5)
    CommonHelper:SetToggleState(self.ip6,_SelectIp==6)
    CommonHelper:SetToggleState(self.ip7,_SelectIp==7)
    CommonHelper:SetToggleState(self.ip8,_SelectIp==8)
    CommonHelper:SetToggleState(self.ip9,_SelectIp==9)
end
function DebugView:UpdateLogView()
    CommonHelper:SetToggleState(self.TogLog,_SelectLogType==DebugLogType.Log)
    CommonHelper:SetToggleState(self.TogWarring,_SelectLogType==DebugLogType.Warning)
    CommonHelper:SetToggleState(self.TogError,_SelectLogType==DebugLogType.Error)
    CommonHelper:SetToggleState(self.TogAssert,_SelectLogType==DebugLogType.Assert)
    CommonHelper:SetToggleState(self.TogException,_SelectLogType==DebugLogType.Exception)
    self:SetLogView(_SelectLogType)
end
function DebugView:PopupException(error)
    UIUtil.ShowCanvasGroup(self.LogView,true)
    self.ExceptionView.text=error
    --_SelectLogType=type
    --self:SetLogView(_SelectLogType)
end
local childs={}
function DebugView:SetLogView(type)
    --local data=DebugLogDataManager:Get():GetLogListByType(type)
    --for i=1,#childs do
    --      UIUtil.SetParentGameObject(self.tempChilds,childs[i])
    --end
    --
    --for i = 1, #data do
    --    local temp=data[i]
    --    local tempObj=nil
    --    if childs[i]~=nil then
    --        tempObj=UIUtil.GetGameobjectComponent(childs[i].gameObject,typeof(Text))
    --    else
    --        local  obj=UIUtil.InstantiateGameObject(self.errortext)
    --        table.insert(childs,obj)
    --        tempObj=UIUtil.GetGameobjectComponent(obj,typeof(Text))
    --    end
    --    tempObj.text=temp
    --    UIUtil.SetParentGameObject(self.Content,tempObj.gameObject)
    --    CommonHelper:HButtonSetCallback("HButton",tempObj.gameObject,function()
    --         CommonHelper:WriteClipboart(temp)
    --    end,temp)
    --end
    --self.Content:SetActive(false)
    --self.Content:SetActive(true)
end
function DebugView:OnOpen()
    UIUtil.ShowCanvasGroup(self.main,true)
    UIUtil.ShowCanvasGroup(self.LogView,false)
    UIUtil.ShowCanvasGroup(self.SelectServerView,false)
    UIUtil.ShowCanvasGroup(self.LevelBattleView,false)
    GameProperties:OnGameToolsOpen()
end
function DebugView:OnClose()
    GameProperties:OnGameToolsClose()
end

function DebugView:OnDisable()

end

function DebugView:OnDestroy()
    self.TogLog = nil
    self.TogWarring = nil
    self.TogError = nil
    self.TogException = nil
    self.TogAssert = nil
end