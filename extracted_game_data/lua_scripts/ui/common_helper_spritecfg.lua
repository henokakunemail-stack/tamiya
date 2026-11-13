---------------------------------------------------获取品质框底图

function CommonHelper:GetPartQualityImage(quality)
    -- 物品、配件品质框
    local table = {
        "common_bg_article_q_1_dt",
        "common_bg_article_q_2_dt",
        "common_bg_article_q_3_dt",
        "common_bg_article_q_4_dt",
        "common_bg_article_q_5_dt",
        "common_bg_article_q_6_dt",
    }
    if quality == 0 then
        return "common_bg_article_q_0_dt"
    end
    if table[quality] == nil then
        print("---   error:获取image异常，没有资源，GetPartQualityImage   quality = ", quality)
        return "common_bg_article_q_9_dt"
    end
    return table[quality]
end


--{{{通用_矩形配件品质框
function CommonHelper:GetAssembleMapPartQualityImage(quality)
    local table = {
        "common_icon_partbg_q_1_dt",
        "common_icon_partbg_q_2_dt",
        "common_icon_partbg_q_3_dt",
        "common_icon_partbg_q_4_dt",
        "common_icon_partbg_q_5_dt",
        "common_icon_partbg_q_6_dt",
    }
    --if quality == 0 then return "common_icon_partbg_q_1_dt" end
    if table[quality] == nil then
        log("---   error:获取image异常，没有资源，GetAssembleMapPartQualityImage   quality = ", quality)
        return "common_bg_default_white_dt"
    end
    return table[quality]
end
--}}}


--{{{通用_矩形article品质框
function CommonHelper:GetArticleQualityImage(quality)
    local table = {
        "common_icon_articlebg_q_1_dt",
        "common_icon_articlebg_q_2_dt",
        "common_icon_articlebg_q_3_dt",
        "common_icon_articlebg_q_4_dt",
        "common_icon_articlebg_q_5_dt",
        "common_icon_articlebg_q_6_dt",
    }
    --if quality == 0 then return "common_icon_partbg_q_1_dt" end
    if table[quality] == nil then
        log("---   error:获取image异常，没有资源，GetArticleQualityImage   quality = ", quality)
        return "common_bg_default_white_dt"
    end
    return table[quality]
end
--}}}
--{{{通用_矩形article品质框
function CommonHelper:GetArticleTypeImage(type,subType)
    local table = {}
    table[3]={}
    table[3][3] ="common_icon_item_article_3_3_type_dt"
    table[3][99] = "common_icon_item_article_3_99_type_dt"
    if table[type] and table[type][subType] then
        return table[type][subType]
    end
    return nil
end
--}}}

--{{{通用_正方形品质框
function CommonHelper:GetSquareQualityImage(quality)
    local table = {
        "common_icon_articlebg_square_q_1_dt",
        "common_icon_articlebg_square_q_2_dt",
        "common_icon_articlebg_square_q_3_dt",
        "common_icon_articlebg_square_q_4_dt",
        "common_icon_articlebg_square_q_5_dt",
        "common_icon_articlebg_square_q_6_dt",
    }
    --if quality == 0 then return "common_icon_partbg_q_1_dt" end
    if table[quality] == nil then
        log("---   error:获取image异常，没有资源，GetArticleQualityImage   quality = ", quality)
        return "common_bg_default_white_dt"
    end
    return table[quality]
end
--}}}

--{{{通用_配件改造品质框
function CommonHelper:GetReformQualityImage(quality)
    local table = {
        "garage_icon_reform_q_1_dt",
        "garage_icon_reform_q_2_dt",
        "garage_icon_reform_q_3_dt",
    }
    if table[quality + 1] == nil then
        log("---   error:获取image异常，没有资源，GetReformQualityImage   quality = ", quality)
        return "common_bg_default_white_dt"
    end
    return table[quality + 1]
end
--}}}



---------------------------------------------------

--{{{通用_段位图标小
function CommonHelper:GetRankLvIconSmall(lv)
    local table = {
        "common_icon_ranklv_s_1_dt",
        "common_icon_ranklv_s_2_dt",
        "common_icon_ranklv_s_3_dt",
        "common_icon_ranklv_s_4_dt",
        "common_icon_ranklv_s_5_dt",
    }
    if table[lv] == nil then
        log("---   error:获取image异常，没有资源，GetRankLvIconSmall   lv = ", lv)
        return "common_bg_default_white_dt"
    end
    return table[lv]
end
--}}}

--{{{通用_段位图标中
function CommonHelper:GetRankLvIconNormal(lv)
    local table = {
        "common_icon_ranklv_m_1_dt",
        "common_icon_ranklv_m_2_dt",
        "common_icon_ranklv_m_3_dt",
        "common_icon_ranklv_m_4_dt",
        "common_icon_ranklv_m_5_dt",
    }
    if table[lv] == nil then
        log("---   error:获取image异常，没有资源，GetRankLvIconNormal   lv = ", lv)
        return "common_bg_default_white_dt"
    end
    return table[lv]
end
--}}}




---------------------------------------------------


---------------------------------------------------获取赛道索引号对应的icon
function CommonHelper:GetCarTrackIdxIcon(idx)
    local table = {
        "common_icon_trackidx_1_dt",
        "common_icon_trackidx_2_dt",
        "common_icon_trackidx_3_dt",
        "common_icon_trackidx_4_dt",
        "common_icon_trackidx_5_dt",
    }
    if table[idx] == nil then
        print("---   error:获取image异常，没有资源，GetCarTrackIdxIcon   type = ", idx)
        return "common_bg_default_white_dt"
    end
    return table[idx]
end

---------------------------------------------------


---------------------------------------------------获取自建赛事阶段对应的icon
function CommonHelper:GetRaceSelfStateIcon(idx)
    local table = {
        "raceself_text_state1_dt",
        "raceself_text_state2_dt",
        "raceself_text_state3_dt",
        "raceself_text_state4_dt",
        "raceself_text_state5_dt",
    }
    if idx == nil then
        return "common_bg_default_white_dt"
    end
    if table[idx] == nil then
        print("---   error:获取image异常，没有资源，GetRaceSelfStateIcon   type = ", idx)
        return "common_bg_default_white_dt"
    end
    return table[idx]
end

---------------------------------------------------
-------------------------------------------------获取自建关卡的难度图片
function CommonHelper:GetSelfChallengeDifferentIcon(idx)
    local table = {
        "selfchallenge_icon_6_dt",
        "selfchallenge_icon_7_dt",
        "selfchallenge_icon_8_dt",
    }
    if idx == nil then
        return "common_bg_default_white_dt"
    end
    if table[idx] == nil then
        print("---   error:获取image异常，没有资源，SelfChallengeDifferentIcon   type = ", idx)
        return "common_bg_default_white_dt"
    end
    return table[idx]
end
----------------------------------------------------------------
-------------------------------------------------获取自建关卡的Npc背景图片
function CommonHelper:GetSelfChallengeNpcIcon(idx)
    local table = {
        "selfchallenge_icon_10_dt",
        "selfchallenge_icon_11_dt",
        "selfchallenge_icon_12_dt",
        "selfchallenge_icon_13_dt",
        "selfchallenge_icon_14_dt",
    }
    if idx == nil then
        return "common_bg_default_white_dt"
    end
    if table[idx] == nil then
        print("---   error:获取image异常，没有资源，GetSelfChallengeNpcIcon   type = ", idx)
        return "common_bg_default_white_dt"
    end
    return table[idx]
end
-----------------------------------------------------------------------------------



---------------------------------------------------玩家头像
---@param headType HeadIconType
---@param attrType HeadIconAttrType
function CommonHelper:GetPlayerIconById(id, headType,attrType)
    headType = headType or HeadIconType.PlayerIcon
    attrType =attrType or HeadIconAttrType.Head
    local result = "playericon_z_default.png"
    if attrType==HeadIconAttrType.Head then
        ---@type dictheadicon_config
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.headicon_config, id)
        if cfg then
            if headType == HeadIconType.PlayerIcon then
                cfg = CommonHelper:GetTableDataByID(ConfigNames.hero_config, tonumber(cfg.icon))
            end
            if cfg then
                result = cfg.NewIcon
            end
        end
    else
        result = "player_kuangicon_1.png"
        ---@type headicon_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.headicon_config, id)
        if cfg then
            if headType == HeadIconType.PlayerIcon and cfg.subtype==HeadIconAttrType.Frame then
                result = string.format("%s.png",cfg.icon)
            end
        end
    end

    return result
end
-------------------------------------------------任务图片
---task_state_1_dt
---task_state_2_dt
---task_title_1_dt
---task_title_2_dt
function CommonHelper:GetTaskStateImageByState(taskState)
    if taskState == TaskStatus.IsDoneAndGet then
        return "task_state_1_dt"

    elseif taskState == TaskStatus.IsRally then
        return "task_state_1_dt"
    elseif taskState == TaskStatus.IsDoneNoGet then
        return "task_state_2_dt"
    end
end
function CommonHelper:GetTaskTittleBgByState(taskState)
    if taskState == TaskStatus.IsDoneAndGet then
        return "task_title_1_dt"
    elseif taskState == TaskStatus.IsRally then
        return "task_title_1_dt"
    elseif taskState == TaskStatus.IsDoneNoGet then
        return "task_title_2_dt"
    end
end

function CommonHelper:GetScoreLvIcon(idx)
    local table = {
        "common_icon_scorelv_c_dt",
        "common_icon_scorelv_b_dt",
        "common_icon_scorelv_a_dt",
        "common_icon_scorelv_s_dt",
        "common_icon_scorelv_ss_dt",
        "common_icon_scorelv_sss_dt",
    }
    if idx == nil then
        return "common_bg_default_white_dt"
    end
    if table[idx] == nil then
        print("---   error:获取image异常，没有资源，GetBaseAttrLvIcon   type = ", idx)
        return "common_bg_default_white_dt"
    end
    return table[idx]
end


--{{{获取赛道特性icon
function CommonHelper:GetTrackFeatureIcon(id)
    ---@type sign_config_cell
    local cfg= CommonHelper:GetTableDataByID(ConfigNames.sign_config,id)
    if cfg==nil then
        log("---   error:获取image异常，没有资源，GetTrackFeatureIcon   id = ", id)
        return "common_bg_default_white_dt"
    end
    return cfg.icon
end
--}}}

--{{{获取配件锁icon
function CommonHelper:GetPartLockIcon(id)
    local table = {
        "common_icon_lock_flag_4_dt",
        "common_icon_lock_flag_4_dt",
        "common_icon_lock_flag_4_dt",
        "common_icon_lock_flag_4_dt",
        "common_icon_lock_flag_4_dt",
        "common_icon_lock_flag_4_dt",
        "common_icon_lock_flag_4_dt",
    }
    if id == nil then
        return "common_bg_default_alpha0_dt"
    end
    if table[id] == nil then
        --log("---   error:获取image异常，没有资源，GetPartLockIcon   id = ", id)
        return "common_bg_default_alpha0_dt"
    end
    return table[id]
end
--}}}

--{{{获取赛道号icon
function CommonHelper:GetBattleTrackIcon(id,trackNum)
    local table1 = {
        "battle_rankitem_bg_1_dt",
        "battle_rankitem_bg_2_dt",
        "battle_rankitem_bg_3_dt",
        "battle_rankitem_bg_4_dt",
        "battle_rankitem_bg_5_dt",
    }
    local table2 = {
        "battle_rankitem_bg_5_dt",
        "battle_rankitem_bg_4_dt",
        "battle_rankitem_bg_3_dt",
    }
    local table=nil
    if trackNum==TrackSegmentNumbers.Three then
        table=table2
    else
        table=table1
    end
    if id == nil then
        return "common_bg_default_alpha0_dt"
    end
    if table[id] == nil then
        --log("---   error:获取image异常，没有资源，GetPartLockIcon   id = ", id)
        return "common_bg_default_alpha0_dt"
    end
    return table[id]
end
--}}}

--{{{获取战斗排名icon
function CommonHelper:GetBattleRankIcon(id)
    local table = {
        "common_icon_rank_1_1_dt",
        "common_icon_rank_1_2_dt",
        "common_icon_rank_1_3_dt",
        "common_icon_rank_1_4_dt",
        "common_icon_rank_1_5_dt",
    }
    if id == nil then
        return "common_bg_default_alpha0_dt"
    end
    if table[id] == nil then
        --log("---   error:获取image异常，没有资源，GetPartLockIcon   id = ", id)
        return "common_bg_default_alpha0_dt"
    end
    return table[id]
end
--}}}
--{{{获取品质获取颜色
local _LuaColorQualityTable = {
    LuaColor(210,209,210,255),
    LuaColor(105,175,78,255),
    LuaColor(79,143,212,255),
    LuaColor(188,64,233,255),
    LuaColor(232,116,63,255),
    LuaColor(234,23,28,255),
}
function CommonHelper:GetColorByQuality(id)
    if id == nil then
        return  _LuaColorQualityTable[1]
    end
    if _LuaColorQualityTable[id] == nil then
        --log("---   error:获取image异常，没有资源，GetPartLockIcon   id = ", id)
        return _LuaColorQualityTable[1]
    end
    return _LuaColorQualityTable[id]
end
local _StringColorQualityTable = {
    "B3B3B3",
    "5AB26C",
    "4C8DE2",
    "8A63DE",
    "FED061",
    "EA171C",
}
function CommonHelper:GetColorStringByQuality(id)
    if id == nil then
        return  _StringColorQualityTable[1]
    end
    if _StringColorQualityTable[id] == nil then
        --log("---   error:获取image异常，没有资源，GetPartLockIcon   id = ", id)
        return _StringColorQualityTable[1]
    end
    return _StringColorQualityTable[id]
end
--}}}
local _StringShellColorQualityTable = {
    "<color=#FFFFFF>%s</color>",
    "<color=#27D55B>%s</color>",
    "<color=#6088FF>%s</color>",
    "<color=#E649EC>%s</color>",
    "<color=#FF7E00>%s</color>",
    "<color=#EA171C>%s</color>",
}
function CommonHelper:GetColorShellStringByQuality(id)
    if id == nil then
        return  _StringShellColorQualityTable[1]
    end
    if _StringShellColorQualityTable[id] == nil then
        --log("---   error:获取image异常，没有资源，GetPartLockIcon   id = ", id)
        return _StringShellColorQualityTable[1]
    end
    return _StringShellColorQualityTable[id]
end



