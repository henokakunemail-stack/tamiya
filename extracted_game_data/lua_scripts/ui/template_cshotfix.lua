

---@class TemplateCsHotfix : ViewBase
TemplateCsHotfix = class("TemplateCsHotfix", ViewBase)

-- View必加
function TemplateCsHotfix:initialize()
    ViewBase.initialize(self)
end

function TemplateCsHotfix:Awake()

   local HotfixCalc=CS.HotfixCalc()
    CommonHelper:HButtonSetCallback("BtnFunc1",self.gameObject, function (hbtn)
       print("Test1Add,2+1=",HotfixCalc:Add(2,1))
    end)
    CommonHelper:HButtonSetCallback("BtnFunc2",self.gameObject, function (hbtn)
        print("Test1Add,Vector3(2, 3, 4) + Vector3(1, 2, 3) = ",HotfixCalc:Add(Vector3(2, 3, 4), Vector3(1, 2, 3)))
    end)

    CommonHelper:HButtonSetCallback("BtnFunc3",self.gameObject, function (hbtn)
        local out1
        local ref1
        local a,b,c=HotfixCalc:TestOut(3,out1,ref1)
        print("TestOut",a..b..c)
    end)
    CommonHelper:HButtonSetCallback("BtnFunc4",self.gameObject, function (hbtn)
        CS.LuaHelper.Get():ContinueToBattle2()
    end)
    CommonHelper:HButtonSetCallback("BtnHotfix",self.gameObject, function (hbtn)
        require("hotfixcs/hotfix_test")
        print("更新")
    end)

end










