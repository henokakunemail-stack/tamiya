---@class UIManager
UIManager = class("UIManager")

---@class CanvasType
CanvasType = {
	BackCanvas = 0,
	MainCanvas = 1,
	FrontCanvas = 2,
	FrontTipCanvas = 3,
	LoadingCanvas = 4,
	TopCanvas = 5,
	CacheCanvas = 6,
	BackgroundCanvas = 7
}

---@return UIManager
function UIManager:Get()
    if self._instance == nil then
        self._instance = UIManager()
    end
    return self._instance
end

-----------------------------------------------Cache view -------------------------------------------

function UIManager:CacheViewWithActiveFasle(name)
	return monoUIManager:CacheViewWithActiveFasle(name)
end


----------------------------------------------------persit view -------------------------------------------------
---@param name string
---@param canvasType number
---@param luaPath string
---@param isBack boolean
---@param keepPersistShowSelf boolean
function UIManager:ShowPersistentView( name, canvasType, luaPath, isBack, keepPersistShowSelf )
	if name=="ScreenEffectView" then
		print("ScreenEffectView打开",debug.traceback())
	end
	return monoUIManager:ShowPersistentView(name, canvasType, isBack or false, keepPersistShowSelf or false, luaPath or nil)
end

function UIManager:ShowPersistentView2( name, canvasType, luaPath, siblingIndex, keepPersistShowSelf )
	return monoUIManager:ShowPersistentViewWithIndex(name, canvasType, siblingIndex, keepPersistShowSelf or false, luaPath or nil)
end

function UIManager:HidePersistentView(name)
	return monoUIManager:HidePersistentView(name)
end

function UIManager:IsPersistentViewShow( name )
	return monoUIManager:IsPersistentViewShow(name)
end


----------------------------------------------------common view -------------------------------------------------
function UIManager:OpenView( name, canvasType, luaPath, lastviewshow, lastViewRemove )
	return monoUIManager:OpenView(name, canvasType, "", lastviewshow or false, lastViewRemove or false, luaPath)
end

function UIManager:CloseView()
	return monoUIManager:CloseView()
end

function UIManager:CloseToView( name )
	return monoUIManager:CloseToView( name )
end

function UIManager:CloseUntilView( name )
	return monoUIManager:CloseUntilView( name )
end

function UIManager:CloseAllViews()
	return monoUIManager:CloseAllViews()
end

function UIManager:GetActiveView( name )
	return monoUIManager:GetActiveView(name)
end

function UIManager:IsViewShow( name )
	return monoUIManager:IsViewShow(name)
end

function UIManager:IsPopViewShow( name )
	return monoUIManager:IsPopViewShow(name)
end

function UIManager:CheckViewExist( name )
	return monoUIManager:CheckViewExist(name)
end

function UIManager:HasViewOpen( )
	return monoUIManager:HasViewOpen()
end

----------------------------------------------------pop view -------------------------------------------------
function UIManager:OpenPopup( name, canvasType, luaPath, keepShowPrevious, lastViewRemove )
	return monoUIManager:OpenPopup(name, canvasType, "", keepShowPrevious or false, lastViewRemove or false, luaPath)
end

function UIManager:ClosePopup()
	return monoUIManager:ClosePopup()
end

function UIManager:CloseAllPopups()
	return monoUIManager:CloseAllPopups()
end
function UIManager:CloseAllPersistentView()
	return monoUIManager:CloseAllPersistentView()
end


------------------------------------------------------------------------------------
function UIManager:EnableMinimap(enable)
	monoUIManager:EnableMinimap(enable)
end
function UIManager:GetMinimapRaw()
	return monoUIManager:GetMinimapRaw()
end
function UIManager:GetMiniMapConfig()
	return monoUIManager:GetMiniMapConfig()
end
function UIManager:InitMinimapCamera(topleft,buttomright,y)
	monoUIManager:InitMinimapCamera(topleft,buttomright,y)
end
function UIManager:UpdateMinimapCamerePosition(x,z)
	monoUIManager:UpdateMinimapCamerePosition(x,z)
end


------------------------------------------------------------------------------------
function UIManager:EnableMeshCamera(enable)
	monoUIManager:EnableMeshCamera(enable)
end
function UIManager:GetMeshCanvasRoot()
	return monoUIManager:GetMeshCanvasRoot()
end
--function UIManager:SetPostionRotationMeshCamera(pos, rot)
--	return monoUIManager:SetPostionRotationMeshCamera(pos, rot)
--end
function UIManager:GetMeshCamera()
	return monoUIManager:GetMeshCamera()
end
function UIManager:GetCanvasByType(type)
	return monoUIManager:GetCanvasByType(type)
end


function UIManager:SetMeshCameraCullingMask(layer)
	 monoUIManager:SetMeshCameraCullingMask(layer)
end
function UIManager:SetMeshCameraCullingMaskDefault()
	 monoUIManager:SetMeshCameraCullingMaskDefault()
end

--function UIManager:SetMeshCameraFOV()
--	return monoUIManager:SetMeshCameraFOV()
--end

------------------------------------------------------------------------------------
function UIManager:ShowCanvas(enable, type)
	return monoUIManager:ShowCanvas(enable, type)
end

function UIManager:GetSecondBaseCameraRT()
	return monoUIManager:GetSecondBaseCameraRT()
end

function UIManager:GetTopViewName()
	return monoUIManager:GetTopViewName()
end

function UIManager:GetTopPopViewName()
	return monoUIManager:GetTopPopViewName()
end
function UIManager:GetTopPopStackView()
	return monoUIManager:GetTopPopStackView()
end

function UIManager:TotalViewsOnStack()
	return monoUIManager:TotalViewsOnStack()
end