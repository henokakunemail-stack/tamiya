---@class HelloView : ViewBase
HelloView = class("HelloView", ViewBase)

-- View必加
function HelloView:initialize()
	ViewBase.initialize(self)
	ViewBase.RegisteAction(self, "HelloViewAction")

end

function HelloView:Awake(  )
	print("Awake"..tostring(self))
	self.monoBaseView.hintCall = teee
end


function HelloView:Start(  )
	-- body
	print("start")
	local OpenPersitBtn = self:GetChildWight("OpenPersitBtn", typeof(HButton))
	local ClosePersitBtn = self:GetChildWight("ClosePersitBtn", typeof(HButton))
	local OpenViewBtn = self:GetChildWight("OpenViewBtn", typeof(HButton))
	local CloseViewBtn = self:GetChildWight("CloseViewBtn", typeof(HButton))
	local OpenPopViewBtn = self:GetChildWight("OpenPopViewBtn", typeof(HButton))
	local ClosePopViewBtn = self:GetChildWight("ClosePopViewBtn", typeof(HButton))
	local ChangeSceneBtn = self:GetChildWight("ChangeSceneBtn", typeof(HButton))
	local OpenTestViewBtn = self:GetChildWight("OpenTestViewBtn", typeof(Button))

	OpenPersitBtn.onClickAction = function(tempBtn)
        	UIManager:Get():ShowPersistentView("PersistView", CanvasType.MainCanvas, nil)
    end
	ClosePersitBtn.onClickAction = function(tempBtn)

		local isPersityViewShow = UIManager:Get():IsPersistentViewShow("PersistView")
		if isPersityViewShow then
        	UIManager:Get():HidePersistentView("PersistView")
        end
    end

	OpenViewBtn.onClickAction = function(tempBtn)
        	UIManager:Get():OpenView("CommonView", CanvasType.MainCanvas, nil, true)
    end

	CloseViewBtn.onClickAction = function(tempBtn)
        	UIManager:Get():CloseView()
    end
	OpenPopViewBtn.onClickAction = function(tempBtn)
        	UIManager:Get():OpenPopup("PopView", CanvasType.MainCanvas, nil)
    end
	ClosePopViewBtn.onClickAction = function(tempBtn)
        --	UIManager:Get():ClosePopup()
    end

	ChangeSceneBtn.onClickAction = function(tempBtn)
        --SceneManager:Get():LoadingMainCity("001_zd_gujingjiedao_rain.unity")
    end

	OpenTestViewBtn.onClickAction = function(tempBtn)

	end


	--self:SequenceTest()
end

function HelloView:CorTest()


end

function HelloView:SequenceTest()
	--self.transform:Delayer(1, function()
	--	logError("1. Delayer..............")
	--end)
	--self.monoBaseView:Sequence():Interval(1):Action(function ()
	--	logError("2. Sequence:Delay")
	--end)
	--
	--self.transform:LooperInt(1, 10, true, function(count)
	--	logError("3. LooperInt 10 = "..count)
	--end)
	--
	--self.monoBaseView:Sequence():Loop(3):Interval(3):Action(function ()
	--	logError("4. Sequence:Loop.Interval")
	--end)
	--
	--self.monoBaseView:Sequence():Interval(3):Action(function ()
	--	logError("5. test1")
	--end):Interval(3):Action(function ()
	--	logError("5. test2")
	--end):Interval(3):Action(function ()
	--	logError("5. test3")
	--end)

	--self.monoBaseView:Sequence():Loop():Interval(1):WaitFor(function ()
	--	return CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Q)
	--end):ActionInt(function(count)
	--	logError("按下Q的次数"..tostring(count))
	--end)


	--local ChangeSceneBtn = self:GetChildWight("ChangeSceneBtn", typeof(HButton))
	--ChangeSceneBtn.transform:Hider(10)
	--ChangeSceneBtn.transform:Sequence():Interval(0.5):ToggleActive():Loop();

	--------ActionSequenceHandle----------------------------
	--local seqHandle = CS.UnrealM.ActionSequenceHandle()
	--seqHandle:Looper(2, function ()
	--	ChangeSceneBtn.transform:Rotate(0, 0, 15)
	--	end
	--	):ActionInt(
	--		function(count)
	--			logError("count"..count)
	--				if count == 5 then
	--					seqHandle:StopSequence()
	--				end
	--	end)
end

function HelloView:OnEnable( ... )	
	-- body
	print("OnEnable")
end

function HelloView:OnOpen( ... )	
	print("OnOpen")
end

function HelloView:ReOpen( ... )
	-- body
	print("ReOpen")
	
end


function HelloView:OnOpenAnimEnd( ... )
	-- body
	print("OnOpenAnimEnd")
end

function HelloView:OnCloseAnimEnd( ... )
	-- body
	print("OnCloseAnimEnd")
end

function HelloView:OnClose( ... )
	-- body
	print("OnClose")
end

function HelloView:Debug( ... )
	-- body
	print("Debug Print.......")
end

function HelloView:OnDisable()
	self.transform:StopSequence()
end




