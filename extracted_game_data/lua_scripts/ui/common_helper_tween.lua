function CommonHelper:Tween_Alpha(obj, valueA, valueB, during)
    if obj then
        TweenAlpha.Begin(obj.gameObject, valueA, valueB, during)
    end
end

function CommonHelper:Tween_Position(obj, valueA, valueB, during, delay)
    if obj then
        TweenPosition.Begin(obj.gameObject, valueA, valueB, during, delay or 0)
    end
end


function CommonHelper:Tween_PlayerTweenScaleByParent(name,Parent,beginValue,endValue,during,delay)
    local tween= UIUtil.GetChildInputPath(name, Parent)
    TweenScale.Begin(tween, beginValue,endValue,during or 0,delay or 0)

end
function CommonHelper:Tween_PlayerTweenPositionByParent(name,Parent,beginValue,endValue,during,delay)
    local tween= UIUtil.GetChildInputPath(name, Parent)
    TweenPosition.Begin(tween, beginValue,endValue,during or 0,delay or 0)
end

function CommonHelper:TweenGroupUILeft(name, parent, isopen, func, isforce)
    local tween = UIUtil.GetTypeChildWightInputPath(name, parent, typeof(FXUITweenPageGroup))
    if tween then
        if isforce == nil then
            isforce = false
        end
        if isopen then
            tween:Open(func, isforce)
        else
            tween:Close(nil, isforce)
        end
    end
end

function CommonHelper:TweenGroupUIRight()

end

function CommonHelper:TweenGroupUILeftScale()

end

function CommonHelper:TweenGroupSetStateClose(name, parent)
    local tween = UIUtil.GetTypeChildWightInputPath(name, parent, typeof(FXUITweenPageGroup))
    if tween then
        tween:SetStateClose()
    end
end

function CommonHelper:TweenGroupSetStateOpen(name, parent)
    local tween = UIUtil.GetTypeChildWightInputPath(name, parent, typeof(FXUITweenPageGroup))
    if tween then
        tween:SetStateOpen()
    end
end

function CommonHelper:TweenSlider(objName, parent, from, to, duration, delay)
    local slider = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(Slider))
    if slider then
        local tween = TweenSlider.Begin(slider, from, to, duration, delay)
    end
end

function CommonHelper:TweenGroupScale(name, parent, group)
    local tween = UIUtil.GetTypeChildWightInputPath(name, parent, typeof(FXUITweenChangeGroup))
    if tween then
        tween:PlayTweenByGroup(group)
    end
end

function CommonHelper:PlayTween(playTween)
    if playTween then
        playTween:Play()
    end
end

function CommonHelper:TMG_PlayAllTweenByName(name, parent,tweenGroup)
    local tween = UIUtil.GetTypeChildWightInputPath(name, parent, typeof(FXUITweenMoreGroup))
    self:TMG_PlayAllTween(tween,tweenGroup)
end

---@param FXUITweenMoreGroup
function CommonHelper:TMG_PlayAllTween(FXUITweenMoreGroup, tweenGroup)
    if FXUITweenMoreGroup then
        tweenGroup = tweenGroup or 0
        FXUITweenMoreGroup:PlayAllTween(tweenGroup)
    end
end

---@param FXUITweenMoreGroup
function CommonHelper:TMG_StopAllTween(FXUITweenMoreGroup, tweenGroup)
    if FXUITweenMoreGroup then
        tweenGroup = tweenGroup or 0
        FXUITweenMoreGroup:StopAllTween(tweenGroup)
    end
end

function CommonHelper:TMG_SetAllTweenCallBack(FXUITweenMoreGroup, callBack, tweenerIdx)
    if FXUITweenMoreGroup then
        tweenerIdx = tweenerIdx or 0
        FXUITweenMoreGroup:SetAllFinishCallBack(callBack, tweenerIdx)
    end
end

function CommonHelper:TMG_SetTweenCallBackByIdx(FXUITweenMoreGroup, idx, callBack, tweenerIdx)
    if FXUITweenMoreGroup then
        tweenerIdx = tweenerIdx or 0
        FXUITweenMoreGroup:SetFinishCallBack(idx, callBack, tweenerIdx)
    end
end

function CommonHelper:TMG_SetTweenPosValue(FXUITweenMoreGroup, fromValue, endValue)
    if FXUITweenMoreGroup then
        FXUITweenMoreGroup:SetTweenValue(fromValue, endValue)
    end
end

function CommonHelper:TMG_SetPlayTweenGroup(FXUITweenMoreGroup, tweenerIdx, tweenGroup)
    if FXUITweenMoreGroup then
        FXUITweenMoreGroup:SetPlayTweenGroup(tweenerIdx, tweenGroup)
    end
end

function CommonHelper:TMG_SetAllTweenGroup(FXUITweenMoreGroup, tweenGroup)
    if FXUITweenMoreGroup then
        FXUITweenMoreGroup:SetAllTweenGroup(tweenGroup)
    end
end

function CommonHelper:TweenGroupPlotRole(obj, posobj, enter, out, height, gary, moveobj)
    local tween = UIUtil.GetGameobjectComponent(obj, typeof(FXUITweenPlotRole))
    if tween then
        if posobj then
            tween:SetPos(posobj)
        end
        if enter then
            tween:PlayEnter()
        end
        if out then
            tween:PlayOut()
        end
        if height then
            tween:PlayHeight()
        end
        if gary then
            tween:PlayGary()
        end
        if moveobj then
            tween:PlayMove(moveobj)
        end
    end
end

function CommonHelper:TweenGroupPlotPlayMiniIconEnter(name, parent)
    local tween = UIUtil.GetTypeChildWightInputPath(name, parent, typeof(FXUITweenPlot))
    if tween then
        tween:PlayMiniIconEnter()
    end
end
function CommonHelper:TweenGroupPlotSetStateMiniIcon(name, parent, isopen)
    local tween = UIUtil.GetTypeChildWightInputPath(name, parent, typeof(FXUITweenPlot))
    if tween then
        tween:SetStateMiniIcon(isopen)
    end
end
function CommonHelper:TweenGroupPlotPlayDialog(name, parent)
    local tween = UIUtil.GetTypeChildWightInputPath(name, parent, typeof(FXUITweenPlot))
    if tween then
        tween:PlayDialog()
    end
end
function CommonHelper:TweenGroupPlotSetStateDialog(name, parent, isopen)
    local tween = UIUtil.GetTypeChildWightInputPath(name, parent, typeof(FXUITweenPlot))
    if tween then
        tween:SetStateDialog(isopen)
    end
end

