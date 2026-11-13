---@class ComicView:ViewBase
ComicView = class("ComicView", ViewBase)

function ComicView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ComicViewAction")

end

function ComicView:Awake()
    CommonHelper:HButtonSetCallback("NextBtn",self.gameObject,function(data)
        ComicManager:Get():SkipStep()
    end)

    CommonHelper:HButtonSetCallback("SkipBtn",self.gameObject,function(data)
        ComicManager:Get():EndPlot()
    end)
    self.AutoScrollView=self:GetChildWight("AutoMoveScrollView1",typeof(AutoMoveScrollView))
    self.StartPos={}
    for i = 1, 13 do
        self.StartPos[i]=self:GetChild("StartPos"..i)
    end
    self.TweenGroup={}
    for i = 1, 12 do
        self.TweenGroup[i]=self:GetChild("TweenTemp_Comic"..i)
    end
end
function ComicView:OnOpen()

end
function ComicView:ReOpen()

end

function ComicView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.Comic)
end

function ComicView:AutoClose()

end

---@param data ComicAction
function ComicView:PlayAction(data, isquick)
    CommonHelper:AutoScroll_Init(self.AutoScrollView,false,1,function()

    end)
end

---@param data ComicAction
function ComicView:PlayActionImage(image, isquick)
    CommonHelper:GetComponentSetUITexture("ComicImg",self.gameObject,image,UIModuleID.Comic)
    CommonHelper:AutoScroll_Init(self.AutoScrollView,false,1,function()

    end)
end



function ComicView:PlayComic()



end

