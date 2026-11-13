
local __CarID
local __CarID2
local __CarID3
local __CarID4


local __GrooveList = {}
local __PartsList = {}
local __grooveInput
local __partsInput
local __carIdInput
local __PartScrollView
local __GrooveScrollView
local SelectFx

---@class Template_Assemble : ViewBase
Template_Assemble = class("Template_Assemble", ViewBase)

-- View必加
function Template_Assemble:initialize()
    ViewBase.initialize(self)
end
local SetPartsScrollView = function()
    CommonHelper:InitMoreRowScrollView(__PartScrollView, #__PartsList, 1,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
            local data = __PartsList[dataIndex + 1]
            __partsInput.text = tostring(data[1])
        end, dataIndex)

        local data = __PartsList[dataIndex + 1]
        CommonHelper:SetText("Text",itemObj,tostring(data[1]).."_"..data[3].." : "..CommonHelper:GetTempStr_Default(data[2]))
    end)
end

local SetPartsData = function(type, type2)
    __PartsList = {}
    ---@type dictparts_config
    local cfg = ClientDataManager:Get():GetDataTable(ConfigNames.parts_config)
    local templist = cfg.GetConfigData()
    for k,v in pairs(templist) do
        local baseData=CommonHelper:GetPartBaseCfg(v.C_ID)
        if baseData then
            if baseData.parttype == type then
                table.insert(__PartsList, {v.C_ID,v.partname,v.recource})
            end
            if type2 and baseData.parttype == type2 then
                table.insert(__PartsList, {v.C_ID,v.partname,v.recource})
            end
        else
            print(v.C_ID)
        end
    end

    SetPartsScrollView()
end

function Template_Assemble:Awake()
    CommonHelper:HButtonSetCallback("BtnLoadCar",self.gameObject, function (hbtn)
        self:BuildCar()
    end)
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject, function (hbtn)
       UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnChangePart",self.gameObject, function (hbtn)
        self:ChangePart()
    end)

    CommonHelper:HButtonSetCallback("BtnSurprise",self.gameObject, function (hbtn)
        self:ChangeGrooveByGrooveId(tonumber(__grooveInput.text))
    end)
    CommonHelper:HButtonSetCallback("BtnFxList",self.gameObject, function (hbtn)
        self:SetFxList()
    end)
    CommonHelper:HButtonSetCallback("BtnFx",self.gameObject, function (hbtn)
        self:LoadFx()
    end)
    CommonHelper:HButtonSetCallback("BtnSavePic",self.gameObject, function (hbtn)
        self:SaveToLoacl(tonumber(__partsInput.text))
    end)


    __grooveInput = UIUtil.GetTypeChildWightInputPath("ReplaceGroove", self.gameObject, typeof(InputField))
    __partsInput = UIUtil.GetTypeChildWightInputPath("ReplacePart", self.gameObject, typeof(InputField))
    __carIdInput = UIUtil.GetTypeChildWightInputPath("CarID", self.gameObject, typeof(InputField))

    __PartScrollView = UIUtil.GetTypeChildWightInputPath("ScrollViewParts", self.gameObject, typeof(MoreRowScrollView))
    __GrooveScrollView = UIUtil.GetTypeChildWightInputPath("ScrollViewGroove", self.gameObject, typeof(MoreRowScrollView))

    --CommonHelper:HButtonSetCallback("BtnReverseCombine",self.gameObject, function (hbtn)
    --    CarBuilderManager:Get():ReverseCombine(__CarID)
    --    print("---   @@@@@@@@    解除合批   ", __CarID)
    --end)

    --CommonHelper:HButtonSetCallback("BtnCombine",self.gameObject, function (hbtn)
    --    CarBuilderManager:Get():Combine(__CarID)
    --    print("---   @@@@@@@@    合批   ", __CarID)
    --end)

end

function Template_Assemble:OnOpen()
    self:SetGrooveData()
    self:SetGrooveScrollView()

    self.CarRoot1 = GameObject("CarRoot1")
    self.CarRoot1.transform.position = Vector3(100,0,0)

    self.CarRoot2 = GameObject("CarRoot2")
    self.CarRoot2.transform.position = Vector3(104,0,0)

    self.CarRoot3 = GameObject("CarRoot3")
    self.CarRoot3.transform.position = Vector3(108,0,0)

    self.CarRoot4 = GameObject("CarRoot4")
    self.CarRoot4.transform.position = Vector3(112,0,0)
end

function Template_Assemble:BuildCar()

    local param = CarBuilderParam()
    param.tableID = tonumber(__carIdInput.text)
    param.buildType = CarBuilderType.Table
    param.parent = self.CarRoot1
    param.BuilderTexture = true
    param.lightweight = {true,true,true,true,true}  -- 玩家轻量化数据
    param.finishEvt = function(obj)
        print("---   @@@@@@@@    BuildCar  1   ", obj)
    end
    __CarID = CarBuilderManager:Get():BuildCar(param)

    local param = CarBuilderParam()
    param.tableID = tonumber(__carIdInput.text)
    param.buildType = CarBuilderType.Table
    param.parent = self.CarRoot2
    param.finishEvt = function(obj)
        print("---   @@@@@@@@    BuildCar  2   ", obj)
    end
    __CarID2 = CarBuilderManager:Get():BuildCar(param)

    local param = CarBuilderParam()
    param.tableID = tonumber(__carIdInput.text)
    param.buildType = CarBuilderType.Table
    param.parent = self.CarRoot3
    param.finishEvt = function(obj)
        print("---   @@@@@@@@    BuildCar  3   ", obj)
    end
    __CarID3 = CarBuilderManager:Get():BuildCar(param)

    local param = CarBuilderParam()
    param.tableID = tonumber(__carIdInput.text)
    param.buildType = CarBuilderType.Table
    param.parent = self.CarRoot4
    param.finishEvt = function(obj)
        self:SetCamera()
        print("---   @@@@@@@@    BuildCar  4   ", obj)
    end
    __CarID4 = CarBuilderManager:Get():BuildCar(param)
end
function Template_Assemble:SetCamera()
    CSCameraManager:Get():RecoverMaskLayer()
    CSCameraManager:Get().gameObject.transform.position=Vector3(100,3.2,1077)
    CSCameraManager:Get().gameObject.transform.localRotation=Quaternion.Euler(10,180,0)
end
local ChassisQueue=nil
function Template_Assemble:ChangeGrooveByGrooveId(grooveID)
    ChassisQueue=Queue()
    for i = 1, #__PartsList do
        ---@type meshcfg_config_cell
        local cfg= CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config,__PartsList[i][3])
        if __PartsList[i] and cfg and cfg.mesh~="0" and cfg.mesh~="-1" and cfg.mesh~="" then
            ChassisQueue:EnQueueBack({name=__PartsList[i][2],id=__PartsList[i][1],groove=grooveID})
        end
    end
    local data=ChassisQueue:DeQueueFront()
    self:ReviewPartOnPart(data)
end
function Template_Assemble:ChangeChassis()
    ChassisQueue=Queue()
    local ChassisList={}
    ChassisList["S1"]=10010001
    ChassisList["S2"]=10010002
    ChassisList["TZ"]=10010003
    ChassisList["TZX"]=10010004
    ChassisList["VS"]=10010064
    ChassisList["AR"]=10010204
   -- ChassisList["FM"]=10010074
   -- ChassisList["SFM"]=10010084
   -- ChassisList["SX"]=10010094
    ChassisQueue:EnQueueBack({name="S1",id=10010001,groove=PartGrooveID.Chassis})
    ChassisQueue:EnQueueBack({name="S2",id=10010002,groove=PartGrooveID.Chassis})
    ChassisQueue:EnQueueBack({name="TZ",id=10010003,groove=PartGrooveID.Chassis})
    ChassisQueue:EnQueueBack({name="TZX",id=10010004,groove=PartGrooveID.Chassis})
    ChassisQueue:EnQueueBack({name="VS",id=10010064,groove=PartGrooveID.Chassis})
    ChassisQueue:EnQueueBack({name="AR",id=10010204,groove=PartGrooveID.Chassis})
    local data=ChassisQueue:DeQueueFront()
    self:ReviewPartOnPart(data)
end
function Template_Assemble:ReviewPartOnPart(data)
    CarBuilderManager:Get():ReviewPart(__CarID ,data.groove, data.id,{},nil,nil,nil,nil,nil,function(id,obj,param)
        print(param.id,"------------->",param.name,"----------->",param.groove)
        cs_coroutine.start(function(class)
            class:SaveToLoacl(data.id)
            coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
            local data=ChassisQueue:DeQueueFront()
            if data then
                class:ReviewPartOnPart(data)
            end
        end,self)
    end,data)
end
function Template_Assemble:GetChassisCenter()

end
function Template_Assemble:SaveToLoacl(id)
    local cfg= CommonHelper:GetTableDataByID(ConfigNames.parts_config,id)
	CarBuilderManager:Get():GetCarBuilder(__CarID):BuilderTexture()
	cs_coroutine.start(function(class)
	    coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
		mono.SetTextTure_ToLocal(CarBuilderManager:Get():GetCarBuilder(__CarID).CarIcon,CommonHelper:GetTempStr_Default(cfg.partname).."_"..id)
		CarBuilderManager:Get():GetCarBuilder(__CarID):RecycleIcon()
     end)
   
end

function Template_Assemble:SetFxList()
    ---@type newskill_config
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.newskill_config)
    local data={}
    table.insert(data,-1)
    for i, v in pairs(cfg.GetConfigData()) do
        table.insert(data,v)
    end
    CommonHelper:InitMoreRowScrollView(__PartScrollView, #data, 1,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        ---@type newskill_config_cell
        local temp=data[dataIndex+1]
        CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
            local fx = data[hbtn.intData + 1]
            if fx==-1 then
                __partsInput.text = tostring(-1)
                SelectFx=-1
               return
            end
            __partsInput.text = tostring(fx.id)
            SelectFx=fx.name..".prefab"
        end, dataIndex)
        if temp~=-1 then
            CommonHelper:SetText("Text",itemObj,tostring(temp.id).."_"..temp.name)
        else
            CommonHelper:SetText("Text",itemObj,tostring(-1))
        end

    end)
end
local CarFx1
function Template_Assemble:LoadFx()
    if CarFx1 then
        print("回收特效")
       PrefabCacheMgr:Get():DestoryMesh(CarFx1)
        CarFx1=-1
    end
    if SelectFx=="-1" then return end
    PrefabCacheMgr:Get():SwapPrefabAsync(SelectFx,nil,nil,function(param,obj)
          CarFx1=obj
          UIUtil.SetParentGameObject(self.CarRoot1,obj,true)
    end)
end

function Template_Assemble:ChangePart()
    print("---   @@@@@@@@    替换配件   ")
    CarBuilderManager:Get():ReviewPart(__CarID , tonumber(__grooveInput.text), tonumber(__partsInput.text),{})
    CarBuilderManager:Get():ReviewPart(__CarID2, tonumber(__grooveInput.text), tonumber(__partsInput.text),{})
    CarBuilderManager:Get():ReviewPart(__CarID3, tonumber(__grooveInput.text), tonumber(__partsInput.text),{})
    CarBuilderManager:Get():ReviewPart(__CarID4, tonumber(__grooveInput.text), tonumber(__partsInput.text),{})

end
--S1 10010001  S2 10010002 TZ 10010003  TZX 10010004  VS 10010064 FM 10010074 SFM 10010084 SX 10010094
function Template_Assemble:Surprise()
    print("---   @@@@@@@@    四种默认底盘   ")
    CarBuilderManager:Get():ReviewPart(__CarID , PartGrooveID.Chassis,10010008,{})
    CarBuilderManager:Get():ReviewPart(__CarID2, PartGrooveID.Chassis,10010019,{})
    CarBuilderManager:Get():ReviewPart(__CarID3, PartGrooveID.Chassis,10010046,{})
    CarBuilderManager:Get():ReviewPart(__CarID4, PartGrooveID.Chassis,10010062,{})

end




function Template_Assemble:SetGrooveData()
    __GrooveList = {}
    __GrooveList[ 1] = {PartGrooveID.Shell, PartType.Shell, "车壳"}
    __GrooveList[ 2] = {PartGrooveID.Chassis, PartType.Chassis, "底盘"}
    __GrooveList[ 3] = {PartGrooveID.Motor, PartType.Motor, "马达"}
    __GrooveList[ 4] = {PartGrooveID.Gears, PartType.Gears, "齿轮组"}
    __GrooveList[ 5] = {PartGrooveID.FHub, PartType.Hub, "前轮毂"}
    __GrooveList[ 6] = {PartGrooveID.BHub, PartType.Hub, "后轮毂"}
    __GrooveList[ 7] = {PartGrooveID.FTyre, PartType.Tyre, "前轮胎"}
    __GrooveList[ 8] = {PartGrooveID.BTyre, PartType.Tyre, "后轮胎"}
    __GrooveList[ 9] = {PartGrooveID.Head, PartType.Head, "龙头"}
    __GrooveList[10] = {PartGrooveID.Wing, PartType.Wing, "中翼"}
    __GrooveList[11] = {PartGrooveID.Tail, PartType.Tail, "凤尾"}
    __GrooveList[12] = {PartGrooveID.RearWing, PartType.RearWing, "风翼"}
    __GrooveList[13] = {PartGrooveID.Front, PartType.Rail, "前扩展"}
    __GrooveList[14] = {PartGrooveID.Front2, PartType.Rail, "前扩展2号"}
    __GrooveList[15] = {PartGrooveID.Front3, PartType.Rail, "前扩展3号", PartType.Weight}
    __GrooveList[16] = {PartGrooveID.Middle, PartType.Rail, "中扩展"}
    __GrooveList[17] = {PartGrooveID.Rear, PartType.Rail, "后扩展"}
    __GrooveList[18] = {PartGrooveID.Rear2, PartType.Rail, "后扩展2号"}
    __GrooveList[19] = {PartGrooveID.Rear3, PartType.Rail, "后扩展3号", PartType.Weight}
    __GrooveList[20] = {PartGrooveID.PulleyFrontCenter, PartType.Pulley, "前上导轮"}
    __GrooveList[21] = {PartGrooveID.PulleyFrontButtom, PartType.Pulley, "前中导轮"}
    __GrooveList[22] = {PartGrooveID.PulleyFrontMinus, PartType.Pulley, "前下导轮"}
    __GrooveList[23] = {PartGrooveID.PulleyMiddleCenter, PartType.Pulley, "中上导轮"}
    __GrooveList[24] = {PartGrooveID.PulleyMiddleButtom1, PartType.Pulley, "中中导轮"}
    __GrooveList[25] = {PartGrooveID.PulleyMiddleMinus, PartType.Pulley, "中下导轮"}
    __GrooveList[26] = {PartGrooveID.PulleyRearCenter, PartType.Pulley, "后上导轮"}
    __GrooveList[27] = {PartGrooveID.PulleyRearButtom, PartType.Pulley, "后中导轮"}
    __GrooveList[28] = {PartGrooveID.PulleyRearMinus, PartType.Pulley, "后下导轮"}
    __GrooveList[29] = {PartGrooveID.TopRailFront, PartType.TopRail, "前顶轨"}
    __GrooveList[30] = {PartGrooveID.TopRailRear, PartType.TopRail, "后顶轨"}
    __GrooveList[31] = {PartGrooveID.PulleyShell, PartType.Pulley, "车壳导轮"}
    __GrooveList[32] = {PartGrooveID.FrontExtr2, PartType.Nail, "前扩展2号  钉钉"}
    __GrooveList[33] = {PartGrooveID.FrontExtr3, PartType.Weight, "前扩展3号  配重"}
    __GrooveList[34] = {PartGrooveID.RearExtr2, PartType.Nail, "后扩展2号  钉钉"}
    __GrooveList[35] = {PartGrooveID.RearExtr3, PartType.Weight, "后扩展3号  配重"}


    --__GrooveList[16] = {PartGrooveID.ConductiveSheet, PartType.Stronger, "导电片"}
    --__GrooveList[17] = {PartGrooveID.DriveAxle, PartType.Stronger, "驱动轴"}
    --__GrooveList[18] = {PartGrooveID.WheelAxle, PartType.Stronger, "轮轴"}
    --__GrooveList[19] = {PartGrooveID.ChassisBearing, PartType.Stronger, "底盘轴承"}
    --__GrooveList[20] = {PartGrooveID.Battery, PartType.Stronger, "电池"}
end

function Template_Assemble:SetGrooveScrollView()
    CommonHelper:InitMoreRowScrollView(__GrooveScrollView, #__GrooveList, 1,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
            local data = __GrooveList[dataIndex + 1]
            __grooveInput.text = tostring(data[1])
            __partsInput.text = "-1"
            SetPartsData(data[2], data[4])
        end, dataIndex)

        local data = __GrooveList[dataIndex + 1]
        CommonHelper:SetText("Text",itemObj,tostring(data[1]).." : "..tostring(data[3]))
    end)
end

