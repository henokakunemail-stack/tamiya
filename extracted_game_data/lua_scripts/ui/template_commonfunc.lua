

local __CarID


---@class Template_CommonFunc : ViewBase
Template_CommonFunc = class("Template_CommonFunc", ViewBase)

-- View必加
function Template_CommonFunc:initialize()
    ViewBase.initialize(self)
end


function Template_CommonFunc:Awake()
    print("start")

    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject, function (hbtn)
        UIManager:Get():CloseView()
    end)


    CommonHelper:HButtonSetCallback("BtnBuy",self.gameObject, function (hbtn)

        local boxfunc = function()
            print("启动成功")
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, "你将要要花10块买100钻石...","买钻石","买","不买",true)
            if ret == MessageBoxHelp.BtnType.OK then
                local ret2 = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue,"确定要买？？？？？","提示","必须买","考虑考虑",false,true)
                if ret2 == MessageBoxHelp.BtnType.OK then
                    MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue,"买好了，多谢...","购买反馈",nil,nil,false,false,true)
                    print("---   关闭框   resrlt = ")
                else
                    MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue,"是该慎重一点...","可惜","嗯嗯",nil,false,false,true)
                end
            else
                MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue,"呵，穷人...","嘲讽",nil,nil,false,false,true)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    end)

    CommonHelper:HButtonSetCallback("BtnTipsBox",self.gameObject, function (hbtn)
        local boxfunc = function()
            local ret, tog = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue,"记住选项，以后不再提示这个框？","询问提示","是","否",false,false,true)
            if ret == MessageBoxHelp.BtnType.OK and tog == true then
                CommonTipsHelper.Get():ShowCenterTips("提示框按钮不能点击了")
                CommonHelper:SetHButtonClick(UIUtil.GetTypeChildWightByParent("BtnTipsBox", self.gameObject, typeof(HButton)),false)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    end)


    CommonHelper:HButtonSetCallback("BtnGetreward",self.gameObject, function (hbtn)
        local boxfunc = function()
            MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue,"获得神秘礼物","标题",nil,nil,true,true,true)
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    end)


    CommonHelper:HButtonSetCallback("BtnTips",self.gameObject, function (hbtn)
        CommonTipsHelper:Get():ShowCenterTips("哈哈哈哈哈哈哈")
    end)


    CommonHelper:HButtonSetCallback("BtnPush",self.gameObject, function (hbtn)
        PopupPushManager:Get():Add("推送推送推送推送推送推送")
    end)

    CommonHelper:HButtonSetCallback("BtnLuaCallCSTable",self.gameObject, function (hbtn)
        print("点击查询")
        loadSqlData("TestClient",{"C_ID",'TestString','TestFloat','TestLong'},function(str)
            print(str)
        end)
    end)
    CommonHelper:HButtonSetCallback("BtnAddUpdate",self.gameObject, function (hbtn)
        GameUpdate.Get():AddUpdate(GameUpdateID.Default, function (param) print("1+1=2",param) end, nil, "参数")
    end)


    CommonHelper:HButtonSetCallback("BtnAddUpdate2",self.gameObject, function (hbtn)
        local class = {}
        class.data = 2
        function class:UpdateFunc(param)
            print("1+1=10",param,self.data)
        end
        GameUpdate.Get():AddUpdate(GameUpdateID.Default, class.UpdateFunc, class, "参数")
    end)


    CommonHelper:HButtonSetCallback("BtnRemoveUpdate",self.gameObject, function (hbtn)
        GameUpdate.Get():RemoveUpdate(GameUpdateID.Default)
    end)

    CommonHelper:HButtonSetCallback("BtnTemplateStr",self.gameObject, function (hbtn)
        local str = ClientDataManager:Get():GetTemplateString(CommonHelper:GetTempStr_Default(TemplateStringID.Welcome))
        CommonTipsHelper.Get():ShowCenterTips(str)
    end)


    CommonHelper:HButtonSetCallback("BtnStory",self.gameObject, function (hbtn)
        local input = UIUtil.GetTypeChildWightInputPath("BtnStory/StoryId", self.gameObject, typeof(InputField))
        PlotManager:Get():StartPlot(tonumber(input.text) )
    end)
    CommonHelper:HButtonSetCallback("BtnComic",self.gameObject, function (hbtn)
        ComicHelper:TriggerComicImg("comic_pic_001.png")
        --local input = UIUtil.GetTypeChildWightInputPath("BtnComic/ComicId", self.gameObject, typeof(InputField))
        --ComicManager:Get():StartPlot(tonumber(input.text) )
    end)



    local start=UIUtil.GetChild("doustartpostion",self.gameObject)
    CommonHelper:HButtonSetCallback("BtnFlyIcon",self.gameObject, function (hbtn)
       --local position
        CommonHelper:PlayCollectCurrency("battle_2_boost_normal_dt", nil, nil, nil,maxCount,80,function() end)
    end)
    CommonHelper:HButtonSetCallback("BtnFlyDou",self.gameObject, function (hbtn)
       --local position
        local  go=GameObject("Target")
        go.transform.position=Vector3(math.random(0,200),math.random(0,200),math.random(0,200))
       CommonHelper:PlayFlyPeasEffect(start,go,true,function()
           GameObject.DestroyImmediate(go)
       end)
    end)


    CommonHelper:HButtonSetCallback("BtnPrinttLuaTable",self.gameObject, function (hbtn)

        --local mgr  = AssembleManager()
        --mgr:NewNode(PartGrooveID.BHub)
        --local node = AssembleNode({1,mgr})
        --local equipmentData = AssembleEquipmentData(node)
        --local grooveData = AssembleGrooveData({123,node})
        --node:SetNode(equipmentData, grooveData)
        --
        --local rrr = {}
        --table.insert(rrr, 100)
        --table.insert(rrr, 222)
        --table.insert(rrr, 333)
        --local ttt = {}
        --table.insert(ttt, "sss")
        --table.insert(ttt, "ddd")
        --table.insert(ttt, "ggg")
        --node = {
        --    aaa = 1,
        --    bbb = {
        --        ccc = 2,
        --        ddd = {
        --            eee = 3,
        --            fff = {
        --                ggg = 5,
        --                hhh = {
        --                    iii = 6,
        --                    jjj = {
        --                        kkk = 7,
        --                        lll = {
        --                            mmm = 8,
        --                            nnn = {
        --                                ooo = 9,
        --                                qqq = 10,
        --                                rrr = rrr,
        --                                ttt = ttt,
        --                            },
        --                        },
        --                    },
        --                },
        --            },
        --        },
        --    },
        --}
        LuaLogHelper.LogTable("",node)
    end)


    --local aaaaa = function(id)
    --    local param = CarBuilderParam()
    --    param.newCarId = id
    --    param.buildType = CarBuilderType.Table
    --    param.finishEvt = function(obj)
    --        print("---   @@@@@@@@    999999   ", obj)
    --    end
    --    __CarID = CarBuilderManager:Get():BuildCar(param)
    --end
    --CommonHelper:HButtonSetCallback("BtnLoadCar",self.gameObject, function (hbtn)
    --    local input = UIUtil.GetTypeChildWightInputPath("BtnLoadCar/CarID", self.gameObject, typeof(InputField))
    --    local param = CarBuilderParam()
    --    param.newCarId = tonumber(input.text)
    --    param.buildType = CarBuilderType.Test
    --    param.finishEvt = function(obj)
    --        print("---   @@@@@@@@    BtnLoadCar   ", obj)
    --    end
    --    __CarID = CarBuilderManager:Get():BuildCar(param)
    --    --aaaaa(101001001000)
    --    --aaaaa(101002001000)
    --    --aaaaa(101003001000)
    --    --aaaaa(101004001000)
    --    --aaaaa(101005001000)
    --    --aaaaa(101006001000)
    --    --aaaaa(101007001000)
    --    --aaaaa(101008001000)
    --    --aaaaa(101009001000)
    --    --aaaaa(101010001000)
    --    --
    --    --aaaaa(101011001000)
    --    --aaaaa(101012001000)
    --    --aaaaa(101013001000)
    --    --aaaaa(101014001000)
    --    --aaaaa(101015001000)
    --    --aaaaa(101016001000)
    --    --aaaaa(101017001000)
    --    --aaaaa(101018001000)
    --    --aaaaa(101019001000)
    --    --aaaaa(101020001000)
    --    --
    --    --aaaaa(101021001000)
    --    --aaaaa(101022001000)
    --    --aaaaa(101023001000)
    --    --aaaaa(101024001000)
    --    --aaaaa(101025001000)
    --    --aaaaa(101026001000)
    --    --aaaaa(101027001000)
    --    --aaaaa(101028001000)
    --    --aaaaa(101029001000)
    --    --aaaaa(101030001000)
    --    --
    --    --aaaaa(101031001000)
    --    --aaaaa(101032001000)
    --    --aaaaa(101033001000)
    --    --aaaaa(101034001000)
    --    --aaaaa(101035001000)
    --    --aaaaa(101036001000)
    --    --aaaaa(101037001000)
    --    --aaaaa(101038001000)
    --    --aaaaa(101039001000)
    --    --aaaaa(101040001000)
    --    --
    --    --aaaaa(101041001000)
    --    --aaaaa(101042001000)
    --    --aaaaa(101043001000)
    --    --aaaaa(101044001000)
    --    --aaaaa(101045001000)
    --    --aaaaa(101046001000)
    --    --aaaaa(101047001000)
    --    --aaaaa(101048001000)
    --    --aaaaa(101049001000)
    --    --aaaaa(101050001000)
    --    --
    --    --aaaaa(101051001000)
    --    --aaaaa(101052001000)
    --    --aaaaa(101053001000)
    --    --aaaaa(101054001000)
    --    --aaaaa(101055001000)
    --    --aaaaa(101056001000)
    --    --aaaaa(101057001000)
    --    --aaaaa(101058001000)
    --    --aaaaa(101059001000)
    --    --aaaaa(101060001000)
    --    --
    --    --
    --    --
    --    --aaaaa(101061001000)
    --    --aaaaa(101062001000)
    --    --aaaaa(101063001000)
    --    --aaaaa(101064001000)
    --    --aaaaa(101065001000)
    --    --aaaaa(101066001000)
    --    --aaaaa(101067001000)
    --    --aaaaa(101068001000)
    --    --aaaaa(101069001000)
    --end)

    --CommonHelper:HButtonSetCallback("BtnCombine",self.gameObject, function (hbtn)
    --    CarBuilderManager:Get():Combine(__CarID)
    --    print("---   @@@@@@@@    合批   ", __CarID)
    --end)
    --
    --CommonHelper:HButtonSetCallback("BtnChangePart",self.gameObject, function (hbtn)
    --    local grooveid = UIUtil.GetTypeChildWightInputPath("BtnLoadCar/ReplaceGroove", self.gameObject, typeof(InputField))
    --    local partid = UIUtil.GetTypeChildWightInputPath("BtnLoadCar/ReplacePart", self.gameObject, typeof(InputField))
    --    CarBuilderManager:Get():ReviewPart(__CarID,tonumber(partid.text), tonumber(grooveid.text))
    --    print("---   @@@@@@@@    替换配件   ", __CarID)
    --end)
    --
    --CommonHelper:HButtonSetCallback("BtnReverseCombine",self.gameObject, function (hbtn)
    --    CarBuilderManager:Get():ReverseCombine(__CarID)
    --    print("---   @@@@@@@@    解除合批   ", __CarID)
    --end)

    CommonHelper:HButtonSetCallback("BtnLoadPart",self.gameObject, function (hbtn)
        local input = UIUtil.GetTypeChildWightInputPath("BtnLoadPart/PartID", self.gameObject, typeof(InputField))

        PartBuilder:Get():BuildPartByCfg(tonumber(input.text))
    end)

end



function Template_CommonFunc:OnOpen()
    CommonHelper:SetHButtonClick(UIUtil.GetTypeChildWightByParent("BtnTipsBox", self.gameObject, typeof(HButton)),true)
end

