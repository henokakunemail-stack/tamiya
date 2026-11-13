---@class ViewBase
---@field UIUtil UnityEngine.MonoBehaviour
---@field monoBaseView UnityEngine.MonoBehaviour
---@field gameObject UnityEngine.GameObject
---@field transform UnityEngine.Transform
ViewBase = class("ViewBase")

function ViewBase:GetChild( controlName, isDirectChild )
	-- body
	return UIUtil.GetChild(controlName, self.gameObject, isDirectChild or false)
end

function ViewBase:GetChildByParent( controlName, parent, isDirectChild )
	-- body
	return UIUtil.GetChild(controlName, parent, isDirectChild or false)
end

function ViewBase:GetChildWightByParent( controlName, parent, ctype, isDirectChild )
	-- body
	return UIUtil.GetTypeChildWightByParent(controlName, parent, ctype, isDirectChild or false)
end

function ViewBase:GetChildWight( controlName, ctype, isDirectChild )
	-- body
	return UIUtil.GetTypeChildWightByParent(controlName, self.gameObject, ctype, isDirectChild or  false)
end

function ViewBase:SetLabel( parentObj, controlName, content, charLimit )
	-- body
	--return self.monoBaseView:SetLabel(parentObj, controlName, content, charLimit)
	return UIUtil.SetLabel(parentObj, controlName, content, charLimit)
end

-- 如果一个action对应多个view，继承这个方法进行重写
function ViewBase:RegisteAction( actionName )
	-- body
	local action = UINotify:Get():GetAction(actionName)
	--print("**********RegisteAction .."..tostring(action))
	action:SetView(self)
end

function ViewBase:GetViewInfo()
	return self.monoBaseView.CurrentViewInfo
end
function ViewBase:isPopView()
	return self.monoBaseView.isPopView
end
function ViewBase:GetLuaViewInfo(idx)
	if self.LuaViewInfo == nil then self.LuaViewInfo = LuaViewInfo() end
	return self.LuaViewInfo:GetParam(idx)
end
function ViewBase:SetLuaViewInfo(idx, param)
	if self.LuaViewInfo == nil then self.LuaViewInfo = LuaViewInfo() end
	self.LuaViewInfo:SetParam(idx, param)
end
function ViewBase:ClearLuaViewInfo()
	if self.LuaViewInfo == nil then self.LuaViewInfo = LuaViewInfo() end
	self.LuaViewInfo:ClearParam()
end

function ViewBase:CheckNewBieGuide(viewName,type,endFunc,param)
	local view=viewName or self.gameObject.name
	GuideManager:Get():Execute(view,type,endFunc,param)
end
function ViewBase:CheckExitNewBieGuide()
	if GuideManager:Get():IsCompleteTypeIsClose() then
		GuideManager:Get():End(self.gameObject.name)
	end
end
function ViewBase:ViewFixScreen()
	local fixRectTransform = UIUtil.GetGameobjectComponent(self.gameObject, typeof(RectTransform))
	fixRectTransform.offsetMin = Vector2((CSScreen.safeArea.xMax - CSScreen.safeArea.width)/2, 0);
	fixRectTransform.offsetMax = Vector2((CSScreen.safeArea.width - CSScreen.safeArea.xMax)/2, 0);
end

function ViewBase:OnBackKey()
	if  UIManager:Get():IsPersistentViewShow("NewbieGuideView") then
		return
	end
	local info = self:GetViewInfo()
	if info == nil then
		return
	end
	if info.viewName == self.gameObject.name and info.IsViewShow then
		if self:isPopView() and UIManager:Get():GetTopPopViewName() == self.gameObject.name then
			UIManager:Get():ClosePopup()
		elseif (UIManager:Get():TotalViewsOnStack() > 1 and UIManager:Get():GetTopViewName() == self.gameObject.name) then
			UIManager:Get():CloseView()
		elseif UIManager:Get():GetTopViewName() == "EmptyView" then
			print("EmptyView不关闭")
		end
	end
end

---@class LuaViewInfo
LuaViewInfo = class("LuaViewInfo")
function LuaViewInfo:initialize()
	self.Params = {}
end
function LuaViewInfo:GetParam(idx)
	if idx ~= nil then return self.Params[idx] end
	return nil
end
function LuaViewInfo:SetParam(idx, param)
	if idx ~= nil then self.Params[idx] = param end
end
function LuaViewInfo:ClearParam()
	self.Params = {}
end









