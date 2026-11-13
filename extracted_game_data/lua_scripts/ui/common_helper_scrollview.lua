

--{{{废弃
-------------------------------------------------规则无限滚动，刷新当前items数据
function CommonHelper:RefreshCurItems(scrollView)
    if scrollView then
        scrollView:RefreshCurItems()
    end
end
-------------------------------------------------
-------------------------------------------------单列或单行无限滚动列表，初始化并移动到初始位置
function CommonHelper:InitScroll_OneRow(scroll, dataCount, funcUpdate,class, isForseInit)
    mono.SetInfinityScrollViewCallBack(scroll,function(scroll, index, itemObj)
        if class then
            funcUpdate(class, index, itemObj,scroll)
        else
            funcUpdate(index, itemObj,scroll)
        end
    end)
    scroll:Setup(dataCount, isForseInit or false)
    scroll:MoveToStartPos()
end
function CommonHelper:GetItem_OneRow(scroll, index)
    return scroll:GetItem(index)
end
-------------------------------------------------
-------------------------------------------------多列或多行无限滚动列表，初始化并移动到初始位置
function CommonHelper:InitScroll_MoreRows(scroll, dataCount,rowCount, funcUpdate, isForseInit)
    mono.SetInfinityScrollViewCallBack(scroll,function (scroll, index, itemObj)
        local totleCount = scroll:GetTotleItemCount()
        local rowcount = scroll:GetRowItemCount()
        for i = 0, rowcount-1 do
            local dataIndex = index * rowcount + i
            local rowitem = UIUtil.GetChild("RowItem"..i, itemObj)
            if i < rowcount and dataIndex < totleCount then
                rowitem:SetActive(true)
                funcUpdate(dataIndex, rowitem, scroll)
            else
                rowitem:SetActive(false)
            end
        end
    end)
    scroll:SetupRows(dataCount , rowCount, isForseInit or false)
    scroll:MoveToStartPos()
end
-------------------------------------------------
--}}}






--{{{自定义无限滚动
function CommonHelper:CustomView_Init(scroll, data, funcUpdate, isresetPos)
    if isresetPos == nil then isresetPos = true end

    mono.SetCustomScrollViewCallBack(scroll,function(scroll, index, itemObj)
        if funcUpdate then
            funcUpdate(index, itemObj,scroll)
        end

    end)
    scroll:Setup(data)
    if isresetPos then
        scroll:MoveToStartPos()
    end

    scroll:RefreshCurrentList()

    LuaRelevance:Get():AddCustomScrollView(scroll)
end
function CommonHelper:CustomView_Refresh(scrollView)
    if scrollView then scrollView:UpdateCurrentItems() end
end
function CommonHelper:CustomView_RefreshItem(scrollView, idx)

end
function CommonHelper:CustomView_ScrollToItem(scroll, index)
    scroll:ScrollToItem(index)
end
function CommonHelper:CustomScroll_ShowItems(scrollView, list)
    if scrollView then scrollView:ShowItems(list) end
end
function CommonHelper:CustomScroll_HideItems(scrollView, list)
    if scrollView then scrollView:HideItems(list) end
end
--}}}





-------------------------------------------------带标题无限滚动
function CommonHelper:InitTitleScrollView(scroll,data, itemrow, funcUpdate, isresetPos,isFold)
    if isresetPos == nil then isresetPos = true end
    if isFold == nil then isFold = true end

    mono.SetTitleScrollViewCallBack(scroll,function (scroll,title, itemObj, total, index, row)
        if total == -1 then
            funcUpdate(title, itemObj, -1, scroll)
        else
            for i = 0, 9 do
                local dataIndex = index * row + i
                local rowitem = UIUtil.GetChild("RowItem"..i, itemObj)
                if rowitem then
                    if i < row and dataIndex < total then
                        rowitem:SetActive(true)
                        funcUpdate(title, rowitem, dataIndex, scroll)
                    else
                        rowitem:SetActive(false)
                    end
                end
            end
        end

    end)
    scroll:ClearItem()

    local i = 1
    while i <= #data do
        scroll:AddItem(data[i],data[i + 1], itemrow,isFold)
        i = i + 2
    end
    scroll:SetContentSize()
    if isresetPos then
        scroll:MoveToStartPos()
    end
    scroll:RefreshCurList(false)

    LuaRelevance:Get():AddTitleScrollView(scroll)
end
function CommonHelper:TitleScrollView_RefreshCurList(scroll, ischeck)
    if ischeck == nil then ischeck = true end
    scroll:RefreshCurList(ischeck)

end
-------------------------------------------------







--{{{morerowscrollview
function CommonHelper:InitMoreRowScrollView(scroll, dataCount,rowCount, funcUpdate, isForseInit,funcUpdateLine, isresetPos)
    if isresetPos == nil then isresetPos = true end

    mono.SetMoreRowScrollViewCallBack(scroll,function (scroll,itemObj, index)
        funcUpdate(index, itemObj,scroll)
    end,function (scroll,itemObj, row,index)
        if funcUpdateLine then
            funcUpdateLine(index,row,itemObj,scroll)
        end
    end)
    scroll:Setup(dataCount , rowCount)
    if isresetPos then
        scroll:MoveToStartPos()
    end
    scroll:RefreshCurrentList(false)

    LuaRelevance:Get():AddMoreRowScrollView(scroll)
end
function CommonHelper:MoreRowView_ScrollToItem(scroll, index)
    scroll:ScrollToItem(index)
end
function CommonHelper:MoreRowView_RefreshCurList(scroll, ischeck)
    if ischeck == nil then ischeck = true end
    scroll:RefreshCurrentList(ischeck)
end
function CommonHelper:MoreRowView_CalcView(scroll, ischeck)
    if ischeck == nil then ischeck = true end
    scroll:RefreshView(ischeck)
end
function CommonHelper:MoreRowView_AniSelectItem(scroll, idx)
    scroll:Ani_SelectItem(idx)
end
function CommonHelper:MoreRowView_GetItemObj(scroll, idx)
    return scroll:GetItemObj(idx)
end

function CommonHelper:MoreRowView_SelectItem(scroll, idx,funcUpdate)
     scroll:SetItemSelect(idx,funcUpdate)
end

function CommonHelper:MoreRowView_ShowClickItem(scroll, idx)
     scroll:ShowClickItem(idx)
end
---进入动画1
function CommonHelper:MoreRowView_EnterAni1(scroll, delay)
     scroll:EnterAni_Alpha(delay)
end

---进入动画任务
function CommonHelper:MoreRowView_EnterAniTask(scroll, delay)
     scroll:EnterAni_AlphaTask(delay)
end
---进入动画任务
function CommonHelper:MoreRowView_EnterAniRace(scroll, delay)
     scroll:EnterAni_AlphaRace(delay)
end


---进入动画章节
function CommonHelper:MoreRowView_EnterAni2(scroll, delay)
     scroll:EnterAni_Alpha2(delay)
end


---离开动画
function CommonHelper:MoreRowView_OutAni(scroll, delay)
     scroll:OutAni_Alpha(delay)
end
------动画3
function CommonHelper:MoreRowView_EnterAni3(scroll, delay)
     scroll:EnterAni_MoreRowsAlpha(delay)
end
--}}}
------动画4
function CommonHelper:MoreRowView_EnterAni4(scroll, delay)
     scroll:EnterAni_MoreRowsScaleAlpha(delay)
end
--}}}

------动画4
function CommonHelper:MoreRowView_GetCurShow(scroll)
     local  result=scroll:GetCurShowIdx()
     local tab=stringSplitToNumber(result,',')
     return tab
end
--}}}





-------------------------------------------------翻页无限滚动列表（支持多列item）
function CommonHelper:InitPageScrollView(scroll, dataCount,rowCount,pagesize, funcUpdate,callbackMoveFinishCB)
    mono.SetMoreRowScrollViewPageMoveFinishCallBack(scroll,nil)
    mono.SetMoreRowScrollViewPageChangeCallBack(scroll,function (scroll,itemObj, index)
        funcUpdate(index, itemObj,scroll)
    end)
    scroll:Setup(dataCount , rowCount)
    scroll:SetPageSize(pagesize)
    scroll:MoveToStartPos()
    scroll:RefreshCurrentList(false)
end
function CommonHelper:InitPageScrollView_RefreshCurList(scroll, ischeck)
    if ischeck == nil then ischeck = true end
    scroll:RefreshCurrentList(ischeck)
end
function CommonHelper:InitPageScrollView_MoveToPage(scroll, index)
    scroll:MoveToPage(index)
end
function CommonHelper:InitPageScrollView_MoveNextPage(scroll)
    scroll:MoveNextPage()
end
function CommonHelper:InitPageScrollView_MoveLastPage(scroll)
    scroll:MoveLastPage()
end
function CommonHelper:InitPageScrollView_GetCurPage(scroll)
    return scroll:GetCurPage()
end
function CommonHelper:InitPageScrollView_SetPageMoveFinishCB(scroll, funcUpdate)
    mono.SetMoreRowScrollViewPageMoveFinishCallBack(scroll,function(idx)
        funcUpdate(idx)
    end)
end
-------------------------------------------------



--{{{关卡无限滚动
function CommonHelper:LevelListView_Init(scroll, data, process, funcUpdate)
    mono.SetLevelListScrollViewCallBack(scroll,function(scroll, itemObj, index )
        funcUpdate(index, itemObj,scroll)
    end)
    scroll:Setup(data, process)
    scroll:MoveToStartPos()
    scroll:RefreshCurrentList(false)
end
function CommonHelper:LevelListView_GetItemObj(scroll, idx)
    return scroll:GetItemObj(idx)
end
--}}}




-------------------------------------------------自动翻页
function CommonHelper:InitCarouselScrollView(scroll, dataCount, time, funcUpdate, moveCB,defaultIndex)
    mono.SetCarouselScrollViewCallBack(scroll,function (scroll,itemObj, index)
        funcUpdate(index, itemObj,scroll)
    end,function(index)
        if moveCB then
            moveCB(index)
        end
    end)
    scroll:Setup(dataCount)
    scroll:MoveToStartPos()
    scroll:RefreshCurrentList(false)
    scroll:StartTimer(time and time or 0)
    scroll:MoveToPage(defaultIndex or 0)

    LuaRelevance:Get():AddCarouselScrollView(scroll)
end
function CommonHelper:InitCarouselScrollView_RefreshCurList(scroll, ischeck)
    if ischeck == nil then ischeck = true end
    scroll:RefreshCurrentList(ischeck)
end
function CommonHelper:InitCarouselScrollView_MoveToPage(scroll, index)
    scroll:MoveToPage(index)
end
function CommonHelper:InitCarouselScrollView_MoveNextPage(scroll)
    scroll:MoveNextPage()
end
function CommonHelper:InitCarouselScrollView_MoveLastPage(scroll)
    scroll:MoveLastPage()
end
function CommonHelper:InitCarouselScrollView_GetCurPage(scroll)
    return scroll:GetCurPage()
end
function CommonHelper:InitCarouselScrollView_SetPageMoveFinishCB(scroll, funcUpdate)
    mono.SetCarouselScrollViewMoveFinishCB(scroll,function(idx)
        funcUpdate(idx)
    end)
end
-------------------------------------------------














-------------------------------------------------轮播图
function CommonHelper:InitCarouselView(carouselView,dataCount,funcUpdate,isAuto)
    carouselView:InitCarouseView(dataCount,funcUpdate)
    if isAuto then
        carouselView:IsAuto(true)
        carouselView:AutoPlayImage()
    else
        carouselView:IsAuto(false)
    end
end
function CommonHelper:CarousePlayNextItem(carouselView)
    carouselView:SwitchNextItem()
end
function CommonHelper:CarousePlayLastItem(carouselView)
    carouselView:SwitchLastItem()
end
function CommonHelper:CarousePlayItemByIndex(carouselView,index)
    carouselView:SwitchItemByIndex(index)
end
function CommonHelper:CloseAutoPlayImage(carouselView)
    carouselView:CloseAutoPlayImage()
end

function CommonHelper:ScrollViewEnableDrag(scrollView,horizontalenable,verticalenable)
    local h=scrollView.horizontal
    local v=scrollView.vertical
    scrollView.horizontal=horizontalenable
    scrollView.vertical=verticalenable
    return h,v
end


--{{{  下拉列表
function CommonHelper:InitDropDown(uiDropDown,dataCount,funcUpdate,funcClick,defaultIndex,isAutoPop,ClickDropFunction)
    defaultIndex =defaultIndex or 0
    if isAutoPop==nil then isAutoPop=true end
    uiDropDown:SetChangeFun(funcUpdate)
    uiDropDown:SetClickItemAction(funcClick)
    uiDropDown:SetClickDropFun(ClickDropFunction)
    uiDropDown:SetUp(dataCount,defaultIndex,isAutoPop)

    LuaRelevance:Get():AddDropDown(uiDropDown)
end
function CommonHelper:DropDown_PopList(uiDropDown)
    uiDropDown:PopList()
end
function CommonHelper:DropDown_GetItem(uiDropDown,idx)
    return uiDropDown:GetItem(idx)
end
function CommonHelper:Enter_PlayeAni(uiDropDown,delay)
    uiDropDown:Enter_PlayAni(delay)
end


function CommonHelper:InitDropDownScrollList(uiDropDown,dataCount,funcUpdate,funcClick,defaultIndex)
    defaultIndex =defaultIndex or 0
    uiDropDown:SetChangeFun(funcUpdate)
    uiDropDown:SetClickItemAction(funcClick)
    uiDropDown:SetUp(dataCount,defaultIndex)

    LuaRelevance:Get():AddDropDownScroll(uiDropDown)
end
--}}}


--{{{关卡无限滚动,树形结构图
function CommonHelper:LevelMapView_Init(scroll, data, isresetpos, funcUpdate)
    if isresetpos == nil then isresetpos = true end
    mono.SetLevelMapScrollViewCallBack(scroll,function(scroll, itemObj, index )
        funcUpdate(index, itemObj,scroll)
    end)
    scroll:Setup(data, isresetpos)
    scroll:MoveToStartPos()
    scroll:RefreshCurList(true)

    LuaRelevance:Get():AddLevelMapScrollView(scroll)
end
function CommonHelper:LevelMapView_Refresh(scroll,ischeck)
    local check= ischeck or false
    scroll:RefreshCurList(check)
end
function CommonHelper:LevelMapView_MoveToItem(scroll, id, istween)
    if istween == nil then istween = false end
    scroll:MoveToItem(id,istween)
end
function CommonHelper:LevelMapView_GetItemById(scroll, id)
    return scroll:GetItem(id)
end
--}}}
--{{{标题无限滚动
function CommonHelper:MoreRowTitle_Init(scroll, data,rowCount, funcUpdate, isresetPos)
    if isresetPos == nil then isresetPos = true end

    mono.SetMoreRowScrollViewTittleCallBack(scroll,function (scroll,itemObj,tittle,tittleIdx,type,index)
        funcUpdate(tittle,tittleIdx,itemObj, type,index,scroll)
    end)
    scroll:SetUp(data,rowCount)
    if isresetPos then
        scroll:MoveToStartPos()
    end
    scroll:RefreshCurrentList(false)

    LuaRelevance:Get():AddMoreRowScrollView(scroll)
end
function CommonHelper:MoreRowTitle_Refresh(scroll,ischeck)
    local check= ischeck or false
    scroll:RefreshCurrentList(check)
end
function CommonHelper:MoreRowTitle_MoveToItem(scroll, tittle,id, istween)
    if istween == nil then istween = true end
    scroll:ScrollToItem(tittle,id,istween)
end
function CommonHelper:MoreRowTitle_GetItemById(scroll,tittle ,id)
    return scroll:GetItem(tittle,id)
end
--}}}


--{{{胶片滚动
function CommonHelper:FilmView_Init(scroll, count, funcUpdate,isReset)
    mono.SetFilmScrollViewCallBack(scroll,function(scroll, itemObj, index )
        funcUpdate(index, itemObj,scroll)
    end)
    scroll:Setup(count)
    if isReset then
        scroll:MoveToStartPos()
    end
    scroll:RefreshCurrentList(false)

    LuaRelevance:Get():AddFilmScrollView(scroll)
end
function CommonHelper:FilmView_GetCurItem(scroll)
    return scroll:GetCurItem()
end
function CommonHelper:FilmView_SetPageMoveFinishCB(scroll,funFinished)
    mono.SetFilmScrollViewMoveFinishCB(scroll,function(idx)
        funFinished(idx)
    end)
end
--}}}
--{{{胶片滚动
function CommonHelper:AutoScroll_Init(scroll,loop,value,func)
    if scroll then
        scroll:Move(loop or false)
        scroll:SetValue(value)
        mono.SetAutoMoveScrollViewCallBack(scroll,func)
        scroll:BreakMove(false)
    end
end
function CommonHelper:AutoScroll_SetLoop(scroll,value)
    if scroll then
        scroll:SetLoop(value or false)
    end

end
function CommonHelper:AutoScroll_PauseMove(scroll,value)
    if scroll then
        scroll:PauseMove(value or false)
    end
end
function CommonHelper:AutoScroll_BreakMove(scroll,value)
    if scroll then
        scroll:BreakMove(value or false)  
    end
end
function CommonHelper:AutoScroll_SetValue(scroll,value)
    if scroll then
        scroll:BreakMove(value)
    end
end

--}}}
