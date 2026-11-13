---@class TestView : ViewBase
TestView = class("TestView", ViewBase)

-- View必加
function TestView:initialize()
	ViewBase.initialize(self)
	ViewBase.RegisteAction(self, "TestViewAction")
end

function TestView:Awake(  )
end


function TestView:Start(  )
	-- body
	print("start111111222333")
	local CloseButton = self:GetChildWight("CloseButton", typeof(HButton))

	CloseButton.onClickAction = function(tempBtn)
		UIManager:Get():HidePersistentView("TestView", CanvasType.MainCanvas, nil)
    end

	local loginBtn = self:GetChildWight("LoginBtn", typeof(HButton))
	loginBtn.onClickAction = function(tempBtn)
		logError("connect....")
		NetManager:Get():OnInit()
		NetManager:Get():ConnectGameServer("10.142.6.214", 11006)
	end


	--self:SequenceTest()
end


function TestView:SequenceTest()

end

function TestView:OnEnable( ... )
	-- body
	print("OnEnable")
end

function TestView:OnOpen( ... )
	print("OnOpen")
end

function TestView:ReOpen( ... )
	-- body
	print("ReOpen")
	
end


function TestView:OnOpenAnimEnd( ... )
	-- body
	print("OnOpenAnimEnd")
end

function TestView:OnCloseAnimEnd( ... )
	-- body
	print("OnCloseAnimEnd")
end

function TestView:OnClose( ... )
	-- body
	print("OnClose")
end

function TestView:Debug( ... )
	-- body-- 如果调试过程中热加载，需要在对应的view里面写上这个类，名字要准确
	--function TestView:GetRequirePath()
	--	return "ui/view/testview/testview"
	--end
	print("Debug Print.......")
end

function TestView:OnDisable()
end



