



---@return qualifyingrank_config_cell
function CommonHelper:GetRankCfgByScore(score)
    local maxscore = 0
    local minscore = 0
    ---@type dictseasonaward_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.dictseasonaward_config)
    local list = tab.GetDataList()
    local result
    for i = 1, #list do
        if score <= list[i].integral then
            result = list[i]
            maxscore = list[i].integral
            if i > 1 then
                minscore = list[i - 1].integral
            end
            break
        end
    end
    if result == nil then
        result = list[#list]
    end
    return result, minscore, maxscore
end

---@param cfg qualifyingrank_config_cell
function CommonHelper:SetRankIconGroup(name, parent, cfg)
    local obj = UIUtil.GetChildInputPath(name, parent)
    if obj and cfg then
        for i = 1, 5 do
            local rankobj = CommonHelper:SetGameObjectActive("rank_"..i, obj, i == cfg.rankidx)
            if i == cfg.rankidx then
                for m = 1, 5 do
                    local tempobj = CommonHelper:SetGameObjectActive("value_"..m, rankobj, m == cfg.star)
                    CommonHelper:SetText("###text", tempobj,CommonHelper:GetTempStr_Default(cfg.name))
                end
            end
        end
    end
end

---@return dictfastlevel_config_cell
function CommonHelper:GetTrotCfgByScore(score,isself)
    local maxscore = 0
    local minscore = 0
    -----@type dictfastlevel_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.dictfastlevel_config)
    local list = tab.GetDataList()
    local result
    if isself and  RaceTrotManager:Get():GetUpMatch()>-1 then
        for i = 1, #list do
                local flag=i+1
                if flag >= #list then
                    flag=i
                end
               if score>=list[i].endpoint and score<list[flag].endpoint then
                    result=list[i]
                    break
               end
        end
    else
        for i = 1, #list do
            if score < list[i].endpoint then
                result = list[i]
                maxscore = list[i].endpoint
                if i > 1 then
                    minscore = list[i - 1].endpoint
                end
                break
            end
        end
    end

    if result == nil then
        result = list[#list]
    end
    return result, minscore, maxscore
end


---@param cfg dictfastlevel_config_cell
function CommonHelper:SetTrotIconGroup(name, parent, cfg)
    local obj = UIUtil.GetChildInputPath(name, parent)
    if obj and cfg then
        for i = 1, 5 do
            local rankobj = CommonHelper:SetGameObjectActive("rank_"..i, obj, i == cfg.biglev)
            if i == cfg.biglev then
                for m = 1, 5 do
                    local tempobj = CommonHelper:SetGameObjectActive("value_"..m, rankobj, m == cfg.levsection)
                    CommonHelper:SetText("###text", tempobj,CommonHelper:GetTempStr_Default(cfg.lev_name))
                end
            end
        end
    end
end
---@param data RaceTrotData
function CommonHelper:SetTrotGroupByData(name, parent,data)
    local obj = UIUtil.GetChildInputPath(name, parent)
    if obj then
        ---@type dictfastlevel_config_cell
        local cfg,minscore, maxscore= CommonHelper:GetTrotCfgByScore(data.CurScore,true)
        CommonHelper:SetTrotIconGroup("rankicon_s_3", obj, cfg)
        CommonHelper:SetTrotIconGroup("rankicon_s_4", obj, cfg)
        CommonHelper:SetTrotIconGroup("rankicon_l", obj, cfg)
       local rank_up_match=  CommonHelper:SetGameObjectActive("rank_up_match",obj,data.UpMatch>-1)
       local rank_value=  CommonHelper:SetGameObjectActive("rank_value",obj,data.UpMatch==-1)
        if data.UpMatch>-1 then
            for i = 1, 5 do
                local pos=UIUtil.GetChildInputPath("Pos"..i, rank_up_match)
                if data.MatchWin[i]==nil then
                    CommonHelper:SetGameObjectActive("lock",pos,true )
                    CommonHelper:SetGameObjectActive("open",pos,false)
                    CommonHelper:SetGameObjectActive("pass",pos,false)
                    CommonHelper:SetGameObjectActive("fail",pos,false)
                else
                    CommonHelper:SetGameObjectActive("lock",pos,data.MatchWin[i]==0)
                    CommonHelper:SetGameObjectActive("open",pos,data.MatchWin[i]==0 and i==data.UpMatch+1)
                    CommonHelper:SetGameObjectActive("fail",pos,data.MatchWin[i]==0 and i<data.UpMatch+1)
                    CommonHelper:SetGameObjectActive("pass",pos,data.MatchWin[i]==1)
                end

            end
        else
           local CurScore= data.CurScore-cfg.beginpoint
           local MaxScore= cfg.endpoint-cfg.beginpoint
           CommonHelper:SetText("###value",rank_value,string.format("%d/%d",CurScore,MaxScore))
           CommonHelper:SetSlider("SliderBaseColor",rank_value,CurScore/MaxScore)
        end
    end
end
