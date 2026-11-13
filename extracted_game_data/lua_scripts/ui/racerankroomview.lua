


---@class RaceRankRoomView : ViewBase
RaceRankRoomView = class("RaceRankRoomView", ViewBase)

function RaceRankRoomView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRankRoomViewAction")

end

function RaceRankRoomView:Awake()
    self.BtnReady = CommonHelper:HButtonSetCallback("BtnReady",self.gameObject,function (hbtn)
        RaceRankSubsystem:Get():SendMsg_Ready()
        CommonHelper:SetHButtonClick(self.BtnReady, false, true)
    end)

    self.PlayerGroup = {}
    for i = 1, 5 do
        self.PlayerGroup[i] = UIUtil.GetChild("player"..i,self.gameObject)
    end

end

function RaceRankRoomView:OnOpen()
    --local port = CommonHelper:CameraPortUIFit("CameraUIFit",self.gameObject)
    --
    --HomeSceneHelper:SetRaceRoom(port)
    CommonHelper:SetHButtonClick(self.BtnReady, true, true)
end

function RaceRankRoomView:OnClose()
    self:StopTimer()
    CommonHelper:ReleasePool(UIModuleID.RaceRankRoom)
    --HomeSceneShowCarRoom:Get():Recycle()
end

function RaceRankRoomView:SetData()
    local data = RaceRankManager:Get():GetRoomData()

    self:StartTimer(RaceRankManager:Get():GetReadyEndTime())
    self:SetPlayerList(data:GetPlayerList())
    self:SetTrackInfo()
    self:SetCarMesh()

end

---@param list table<number, RaceRankPlayerData>
function RaceRankRoomView:SetPlayerList(list)
    for i = 1, #self.PlayerGroup do
        local obj = self.PlayerGroup[i]
        self:SetOnePlayer(obj,list[i],true)

    end
end

---@param player RaceRankPlayerData
function RaceRankRoomView:SetOnePlayer(obj, player, showdetail)
    CommonHelper:SetGameObjectActive("blank", obj, not player)
    local infoobj = CommonHelper:SetGameObjectActive("playerinfo", obj,player and showdetail)
    local listobj = CommonHelper:SetGameObjectActive("partlist", obj,player and not showdetail)

    if obj and player then

        if showdetail then
            local str = CommonHelper:GetTempStr_Default(TemplateStringID.RaceRoomPlayerName, player:GetLV(), player:GetName())
            CommonHelper:SetText("###playername", infoobj, str)
            CommonHelper:SetGameObjectActive("readystate", infoobj, player:IsReady())
            --CommonHelper:SetGameObjectActive("notready", obj, not player:GetReady())

            --log("---   ^^^   ", player:GetName(), player:GetIcon())
            CommonHelper:GetComponentSetUITexture("PlayerIcon/icon", infoobj, player:GetIcon(), UIModuleID.RaceRankRoom)
            --CommonHelper:SetPlayerIconById("PlayerIcon/icon", infoobj, player:GetIcon(),nil,nil, UIModuleID.RaceRankRoom)

            ---@type qualifyingrank_config_cell
            local curcfg = CommonHelper:GetRankCfgByScore(player:GetRankScore())
            CommonHelper:SetRankIconGroup("rankicon_s_1", infoobj, curcfg)

            local partlist = player:GetCarData():GetMainParts()
            for i = 1, 4 do
                local part = partlist[i]
                local partobj = CommonHelper:SetGameObjectActive("partitem"..i, infoobj, part ~= nil)
                if part then
                    local param = Param_PartItem()
                    param.moduleId = UIModuleID.RaceRankRoom
                    param.partId = part.PartCfgID
                    param.quality = part.PartQuality
                    CommonHelper:SetPartItem(partobj, param)
                end
            end

            CommonHelper:HButtonSetCallback("BtnList", infoobj, function(hbtn)
                self:SetOnePlayer(obj, player, false)
            end)
        else

            local ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", listobj, typeof(MoreRowScrollView))
            local temp = player:GetCarData():GetPartList()
            local list = {}
            for i = 1, #temp do
                if temp[i].PartCfgID > 0 then table.insert(list,temp[i]) end
            end
            CommonHelper:InitMoreRowScrollView(ScrollView, #list, 2,function(dataIndex, itemObj, scroll)
                local data = list[dataIndex + 1]
                local partobj = UIUtil.GetChild("partitem1", itemObj)
                local param = Param_PartItem()
                param.moduleId = UIModuleID.RaceRankRoom
                param.partId = data.PartCfgID
                param.quality = data.PartQuality
                CommonHelper:SetPartItem(partobj, param)
            end)

            CommonHelper:HButtonSetCallback("BtnDetail", listobj, function(hbtn)
                self:SetOnePlayer(obj, player, true)
            end)
        end
    end

end

function RaceRankRoomView:SetTime()
    local temp = ClientDataManager:Get():GetTemplateString(TemplateStringID.RaceRankJoinTimeFromat)
    CommonHelper:SetText("###waitingvalue", self.gameObject,  string.format(temp,math.modf(self.Time)))
end

function RaceRankRoomView:SetTrackInfo()
    local trackdata = RaceRankManager:Get():GetRoomTrackData()
    CommonHelper:GetComponentSetTrackIconByData("trackicon", self.gameObject, trackdata, UIModuleID.RaceRankRoom)

    CommonHelper:SetTrackFeatureByParent("trackfeature", self.gameObject, trackdata:GetFeature())


    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, RaceRankManager:Get():GetSceneID())
    if cfg then
        CommonHelper:GetComponentSetUITexture("sceneicon",self.gameObject,cfg.icon,UIModuleID.RaceRankRoom)
        CommonHelper:SetText("###scenename", self.gameObject, ClientDataManager:GetTemplateString(cfg.name))
    end

end

function RaceRankRoomView:SetCarMesh()
    --local carlist = {}
    --local roomdata = RaceRankManager:Get():GetRoomData()
    --for i = 1, 5 do
    --    local player = roomdata:GetPlayerByIdx(i)
    --    if player then
    --        table.insert(carlist, player:GetCarData())
    --    else
    --        table.insert(carlist, nil)
    --    end
    --end
    --HomeSceneShowCarRoom:Get():Show(carlist)
end




function RaceRankRoomView:UpdatePlayerReady(pid)
    local data = RaceRankManager:Get():GetRoomData()
    self:SetPlayerList(data:GetPlayerList())
end

function RaceRankRoomView:UpdateCarMesh(pid)
    --self:SetCarMesh()
end

function RaceRankRoomView:RefreshUI()
    self:UpdatePlayerReady()
    self:UpdateCarMesh()
end



function RaceRankRoomView:StartTimer(endtime)
    self:StopTimer()
    self.Time = CommonHelper:SubTime(endtime) * -0.001
    --self.Time = 30
    self.TimerID = TimerManager:Get():CreateTimerLoop(0.1, function()
        self:TimerGoing()
    end)
end

function RaceRankRoomView:TimerGoing()
    self.Time = self.Time - 0.1
    self:SetTime()
    if self.Time < 0 then
        self:StopTimer()
    end
end

function RaceRankRoomView:StopTimer()
    TimerManager:Get():StopTimer(self.TimerID)
    self.TimerID = -1
end










-----@param data RaceRankPlayerData
--function RaceRankRoomView:ClickBtnPlayer(idx, ischeck)
--    if ischeck == nil then ischeck = true end
--    if ischeck and self.SelectPlayerIdx == idx then
--        return
--    end
--
--    self.SelectPlayerIdx = idx
--
--    self:UpdatePlayerSelect()
--
--    local roomdata = RaceRankManager:Get():GetRoomData()
--    local data = roomdata:GetPlayerByIdx(idx)
--
--    if not data:IsRobot() and data:GetPid() ~= PlayerDataManager:Get():GetPlayerID()  then
--        RaceRankSubsystem:Get():SendMsg_GetPlayerCar(data:GetPid())
--    else
--        self:SetMesh()
--    end
--end

function RaceRankRoomView:ChangeCar()
    --local roomdata = RaceRankManager:Get():GetRoomData()
    --local data = roomdata:GetSelfPlayer()
    --local cardata = self.Page_SelectCar:GetCurCar()
    --if data:GetSelfCarId() ~= cardata.carIdx then
    --    RaceRankSubsystem:Get():SendMsg_ChangeCar(cardata.carIdx)
    --end
end






