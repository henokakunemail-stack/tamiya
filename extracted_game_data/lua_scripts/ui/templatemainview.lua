

---@class TemplateMainView : ViewBase
TemplateMainView = class("TemplateMainView", ViewBase)

-- View必加
function TemplateMainView:initialize()
    ViewBase.initialize(self)
end

function TemplateMainView:Awake(  )
    -- body
    local BtnScrollView = self:GetChildWight("BtnScrollView", typeof(HButton))
    BtnScrollView.onClickAction = function(hbtn)
        print("---   无限滚动")
        UIManager:Get():OpenView("Template_ScrollView", CanvasType.MainCanvas, "Template_ScrollView")
    end

    CommonHelper:HButtonSetCallback("BtnCommonFunc",self.gameObject, function (hbtn)
        UIManager:Get():OpenView("Template_CommonFunc", CanvasType.MainCanvas, "Template_CommonFunc")
    end)

    CommonHelper:HButtonSetCallback("BtnScrollPageView",self.gameObject, function (hbtn)
        UIManager:Get():OpenView("Template_ScrollPageView", CanvasType.MainCanvas, "Template_ScrollPageView")
    end)

    CommonHelper:HButtonSetCallback("BtnCustomScrollView",self.gameObject, function (hbtn)
        UIManager:Get():OpenView("Template_CustomScrollView", CanvasType.MainCanvas, "Template_CustomScrollView")
    end)
 CommonHelper:HButtonSetCallback("BtnDropDown",self.gameObject, function (hbtn)
        UIManager:Get():OpenView("Template_DropDown", CanvasType.MainCanvas, "Template_DropDown")
    end)
    CommonHelper:HButtonSetCallback("BtnCalcPartLocalPos",self.gameObject, function (hbtn)
        self:GetAllObjs()
    end)
    CommonHelper:HButtonSetCallback("BtnBuilderCar",self.gameObject, function (hbtn)
       self:BuildCar()
    end)
    CommonHelper:HButtonSetCallback("BtnAR",self.gameObject, function (hbtn)
        print("---   BtnAR")
        --local asset = AssetsManager.Load("test_ar.prefab", typeof(GameObject))
        --local mesh = CommonHelper:InstantiateGameObjectByObject(asset.asset)
        --ARManager.Get():OnInit()
    end)
    CommonHelper:DragObjectSetCallback("BtnDrag",self.gameObject, function (hbtn)
       print("开始拖拽")
    end,function(other,hbtn)
        print("结束拖拽")
    end)
    CommonHelper:OnTriggerObjectSetCallback("BtnTrigger",self.gameObject, function (hbtn)
        print("开始碰撞")
    end,function(other,hbtn)
        print("结束碰撞")
    end,function(other,hbtn)
        print("碰撞中")
    end)

    CommonHelper:HButtonSetCallback("BtnWheelBlur",self.gameObject, function (hbtn)
        print("---   BtnWheelBlur")
        ---@type parts_config
        local tab = ClientDataManager:GetDataTable(ConfigNames.parts_config)
        local list = tab.GetConfigData()
        local idlist = {}
        local meshlist = {}
        for k,v in pairs(list) do
            if v.type == PartType.Hub then
                ---@type meshcfg_config_cell
                local meshcfg = CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config, v.recource)
                local partid = meshcfg.id
                local meshname = meshcfg and meshcfg.mesh or ""
                table.insert(idlist, partid)
                table.insert(meshlist, meshname)
            end

        end
        CS.WheelBlurTool.CreateHubBlurTex(idlist, meshlist)
    end)

    CommonHelper:HButtonSetCallback("BtnAssemble",self.gameObject, function (hbtn)
        UIManager:Get():OpenView("Template_Assemble", CanvasType.MainCanvas, "Template_Assemble")
    end)
    CommonHelper:HButtonSetCallback("BtnPicTrack",self.gameObject, function (hbtn)
        UIManager:Get():OpenView("Template_TrackPic", CanvasType.MainCanvas, "Template_TrackPic")
    end)

    CommonHelper:HButtonSetCallback("BtnMoreRowScrollView",self.gameObject, function (hbtn)
        UIManager:Get():OpenView("Template_MoreRowScrollView", CanvasType.MainCanvas, "Template_MoreRowScrollView")
    end)

    CommonHelper:HButtonSetCallback("BtnCarouselScrollView",self.gameObject, function (hbtn)
        UIManager:Get():OpenView("Template_CarouselScrollView", CanvasType.MainCanvas, "Template_CarouselScrollView")
    end)
    CommonHelper:HButtonSetCallback("BtnHotfixTest",self.gameObject, function (hbtn)
        UIManager:Get():OpenView("TemplateCSHotFix", CanvasType.MainCanvas, "TemplateCsHotfix")
    end)

    CommonHelper:HButtonSetCallback("BtnJSON",self.gameObject, function (hbtn)
        local tab =
        {
            aaa = "aaa",
            bbb = 123,
            ccc = true ,
            ddd =
            {
                fff = "中文"
            },
            eee =
            {
                {1,2,3},
                {4,5,6},
                {7,8,9,0,{A = "A", B = "B", C = "C"}}
            }
        }
        local str = Dll_JSON.encode(tab)
        print('json', str)
        local t = Dll_JSON.decode(str)
        print(t.aaa, type(t.aaa))
        print(t.bbb, type(t.bbb))
        print(t.ccc, type(t.ccc))
        print(t.ddd, type(t.ddd))
        print(t.eee, type(t.eee))
    end)

    CommonHelper:HButtonSetCallback("BtnRedPoint",self.gameObject, function (hbtn)
        local funAAA = function()
            local seed = math.random(0,10)
            print("------------    funAAA", seed)
            return seed < 5
        end

        local funBBB = function(param)
            print("------------    funBBB  接受模块数据，刷新模块manager",param)
        end

        local funCCC = function()
            local seed = math.random(0,10)
            print("------------    funCCC", seed)
            return seed < 3 or seed > 7
        end
        --RedPointManager:Get():ClearData()
        --RedPointManager:Get():RegistRedPoint(10001, RedPointFlagUpdate.RedMsg, RedPointFlagGetValue.Get)
        --RedPointManager:Get():RegistRedPoint(10003, RedPointFlagUpdate.FuncReturn, RedPointFlagGetValue.Get,funAAA)
        --RedPointManager:Get():RegistRedPoint(10004, RedPointFlagUpdate.Func, RedPointFlagGetValue.FuncReturn,funBBB,nil,"funBBB的参数",funCCC)
        --UIManager:Get():OpenView("Template_RedPoint", CanvasType.MainCanvas, "Template_RedPoint")
    end)
end


function TemplateMainView:CalcPartLocalPosition()
    self.DummyDic={}
    CS.MonoHelper.WriteFileString( CS.UnityEngine.Application.dataPath.."/PartDummy.txt", "")
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dummy_config)
    ---@type dummy_config_cell[]
    local data=cfg.GetConfigData()
    local count=0
    for i, v in pairs(data) do
        count=count+1
    end
    local loadCount=0
    local x=0
    local y=0
    local z=0
    self.Empty=GameObject("Empty")
    for i, v in pairs(data) do
        print(v.resname)
        PrefabCacheMgr:Get():SwapPrefabAsync(v.resname,nil,nil,function(param,obj)
            self.DummyDic[v.C_ID]=obj
            x=x+loadCount*3
            obj.transform.position=Vector3(x,y,z)
            loadCount=loadCount+1
            if loadCount>=count then
               print("加载dummy完毕开始遍历挂点表")
               self:CalcAssemblerule()
            end
        end)
    end
end
function TemplateMainView:CalcAssemblerule()
    local part_cfg=ClientDataManager:Get():GetDataTable(ConfigNames.parts_config)
    local partData=part_cfg.GetConfigData()
    local PartDic={}
    for k, v in pairs(partData) do
       local baseData=CommonHelper:GetPartBaseCfg(v.C_ID)
       local meshCfgData=CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config,v.recource)
        if baseData then
            if PartDic[baseData.parttype]==nil then
                PartDic[baseData.parttype]={}
            end
            table.insert(PartDic[baseData.parttype],{v,baseData,meshCfgData})
        end
    end
    local count=0

    self.MeshDic={}
    for k, v in pairs(PartDic) do
        if k==PartType.Chassis then
            for i = 1, #PartDic[k] do
                ---@type assemblerule_config
                local assemblerule_config=ClientDataManager:Get():GetDataTable(ConfigNames.assemblerule_config)
                local result=assemblerule_config.GetAssembleByGroveAndFlag(PartGrooveID.Chassis,PartDic[k][i][3].flag)
                for j = 1, #result do
                    if  self.MeshDic[PartDic[k][i][3].mesh]==nil then
                        local Asset = AssetsManager.Load(PartDic[k][i][3].mesh, typeof(GameObject))
                        self.MeshDic[PartDic[k][i][3].mesh]=Asset
                    end
                    local obj = CommonHelper:InstantiateGameObjectByObject(self.MeshDic[PartDic[k][i][3].mesh].asset)
                    local point=UIUtil.GetChild(result[j].hpoint,self.DummyDic[PartDic[k][i][3].flag])
                    UIUtil.SetParentTransform(point,obj,true)
                    obj.transform:LocalPosition(result[j].NewOffset)
                    obj.transform:localScale(result[j].NewScale)
                    local text=PartDic[k][i][1].C_ID..":"..PartGrooveID.Chassis..":"..PartDic[k][i][3].flag..":"..result[j].hpoint.."\n"
                    self:WriteText(text)
                end
            end
        else
            for i = 1, #PartDic[k] do
                local grovves=stringSplitToNumber(PartDic[k][i][2].installid,"#")
                for g = 1, #grovves do
                    ---@type assemblerule_config
                    local assemblerule_config=ClientDataManager:Get():GetDataTable(ConfigNames.assemblerule_config)
                    local result=assemblerule_config.GetAssembleByGroveAndFlag(grovves[g],PartDic[k][i][3].flag)
                    if result then
                        for j = 1, #result do
                            for k3, v3 in pairs(self.DummyDic) do
                                if  self.MeshDic[PartDic[k][i][3].mesh]==nil then
                                    local Asset = AssetsManager.Load(PartDic[k][i][3].mesh, typeof(GameObject))
                                    self.MeshDic[PartDic[k][i][3].mesh]=Asset
                                end
                                local point=UIUtil.GetChild(result[j].hpoint,self.DummyDic[k3])
                                    if point then
                                        local mesh= UIUtil.GetChild(PartDic[k][i][3].mesh,point)
                                        if mesh==nil then
                                            local obj = CommonHelper:InstantiateGameObjectByObject(self.MeshDic[PartDic[k][i][3].mesh].asset)
                                            count=count+1
                                            if obj then
                                                UIUtil.SetParentTransform(point,obj,true)
                                                obj.transform:LocalPosition(result[j].NewOffset)
                                                obj.transform:LocalScale(result[j].NewScale)
                                                local text=PartDic[k][i][1].C_ID..":"..grovves[g]..":"..k3..":"..result[j].hpoint.."\n"
                                                self:WriteText(text)
                                            end
                                        end
                                    end
                            end
                        end
                    end
                end
            end
        end
    end
    -----@type meshcfg_config
    --local meshcfg_config=ClientDataManager:Get():GetDataTable(ConfigNames.meshcfg_config)
    --
    --local assembleruleconfig= assemblerule_config.GetConfigData()
    --for k, v in pairs(self.DummyDic) do
    --    for k1, v1 in pairs(assembleruleconfig) do
    --        local result=
    --        for i = 1, #result do
    --            PrefabCacheMgr:Get():SwapPrefabAsync(result[i].mesh,nil,nil,function(param,obj)
    --                 local point=UIUtil.GetChild(assembleruleconfig[k1].hpoint,v)
    --                 UIUtil.SetParentTransform(point,obj,true)
    --            end)
    --        end
    --    end
    --end
end
function TemplateMainView:WriteText(text)
    local result= CS.MonoHelper.ReadFileString( CS.UnityEngine.Application.dataPath.."/PartDummy.txt")
    result=result..text
    CS.MonoHelper.WriteFileString( CS.UnityEngine.Application.dataPath.."/PartDummy.txt", result)
end



function TemplateMainView:BuildCar()
    self.CarTable={
        {SuitId=20001,BuilderId=-1,Parent=-1,Center=-1,dummy="s1"},
        {SuitId=20002,BuilderId=-1,Parent=-1,Center=-1,dummy="s2"},
        {SuitId=20003,BuilderId=-1,Parent=-1,Center=-1,dummy="tz"},
        {SuitId=20004,BuilderId=-1,Parent=-1,Center=-1,dummy="tzx"},
        {SuitId=20005,BuilderId=-1,Parent=-1,Center=-1,dummy="vs"},
        {SuitId=20006,BuilderId=-1,Parent=-1,Center=-1,dummy="fm"},
        {SuitId=20007,BuilderId=-1,Parent=-1,Center=-1,dummy="sfm"},
        {SuitId=20008,BuilderId=-1,Parent=-1,Center=-1,dummy="sx"},
        {SuitId=20008,BuilderId=-1,Parent=-1,Center=-1,dummy="ar"},
        {SuitId=20009,BuilderId=-1,Parent=-1,Center=-1,dummy="ms_l"},
    }
    local startX=100
    self.index=0
    for k, v in pairs(self.CarTable) do
        self.CarTable[k].Parent = GameObject("CarRoot"..self.index+1)
        self.CarTable[k].Parent.transform.position = Vector3(startX+(self.index*4),0,0)
        self.index=self.index+1
    end
    self:BuildAllCar()
end
function TemplateMainView:BuildAllCar()
    local index=0
    for k, v in pairs(self.CarTable) do
        local param = CarBuilderParam()
        param.tableID = v.SuitId
        param.buildType = CarBuilderType.Table
        param.parent = v.Parent
        param.finishParam=v
        param.finishEvt = function(id, obj, param)
            print("---   @@@@@@@@    BuildCar  1   ",id, obj, param)
            index=index+1
        end
        self.CarTable[k].BuilderId = CarBuilderManager:Get():BuildCar(param)
    end
end

function TemplateMainView:GetAllObjs()
    CS.MonoHelper.WriteFileString( CS.UnityEngine.Application.dataPath.."/PartDummy.txt", "")
    for k, v in pairs(self.CarTable) do
        self.CarTable[k].Center=UIUtil.GetChild(self.CarTable[k].dummy,self.CarTable[k].Parent)
        if self.CarTable[k].Center then
            self.CarTable[k].Center.transform.localScale=Vector3.one
            local CarBuilder= CarBuilderManager:Get():GetCarBuilder(v.BuilderId)
            self:GetObjsByGrovveId(v,CarBuilder,self.CarTable[k].Center)
        end
    end
end
---@param CarBuilder CarBuilder
function TemplateMainView:GetObjsByGrovveId(carParam,CarBuilder,Center)
    for k, v in pairs(PartGrooveID) do
        if v~=-1 then
            if CarBuilder then
                local objs= CarBuilder:GetPulleyObjsByGrooveID(v)
                local ChassisId=CarBuilder:GetPartDataID(PartGrooveID.Chassis)
                if #objs==1 then
                    for i = 1, #objs do
                        UIUtil.SetParentGameObject(Center,objs[i].transform,false)
                        objs[i].transform.localScale=Vector3.one
                        local vector3=objs[i].transform.localPosition
                        local text=carParam.SuitId..":"..ChassisId..":"..v..":"..vector3.x..","..vector3.y..","..vector3.z..":"..objs[1].name.."\n"
                        self:WriteText(text)
                    end
                else
                    if #objs>0 then
                        local vector3=Vector3(0,0,0)
                        for i = 1, #objs do
                            UIUtil.SetParentGameObject(Center,objs[i].transform,false)
                            objs[i].transform.localScale=Vector3.one
                            vector3=objs[i].transform.localPosition+vector3
                        end
                        vector3=vector3/#objs
                        local text=carParam.SuitId..":"..ChassisId..":"..v..":"..vector3.x..","..vector3.y..","..vector3.z..":"..objs[1].name.."\n"
                        self:WriteText(text)
                    end

                end
            end
        end
    end
end







