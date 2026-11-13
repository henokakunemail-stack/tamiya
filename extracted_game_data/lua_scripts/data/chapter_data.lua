

---@class LevelData
LevelData = class("LevelData")

function LevelData:initialize()
    self.newid = 0
    self.name = ""
    self.idxname = ""
    self.idx = 0
    self.icon = ""
    self.trackresname = ""
    self.nextlevel = -1
    self.lock = true
    self.state = -1   --0 没通过（进行中）      1 已通过（完成）
    self.isboss = false
    self.leveltips = "aaaaaaa"
    self.personRecord = 999
    self.rewardsid = {}
    self.rewardsnum = {}
    self.configName=""
    self.StoryGroup = {}
    self.trackId = -1

    ---@type table<number, RewardData>
    self.SomeDown = {}
    ---@type table<number, RewardData>
    self.FirstReward = {}
end
---@param cfg chapter_config_cell
function LevelData:SetData_Story(cfg)
    self.newid = cfg.NewID
    self.name = ClientDataManager:Get():GetTemplateString(cfg.name)
    self.idx = cfg.levelID
    self.icon = cfg.levelicon
    self.trackresname = cfg.trackresname
    self.nextlevel = cfg.nextIds
    self.isboss = (cfg.isboss == 1)
    self.leveltips = cfg.leveltips
    self.rewardsid = cfg.NewRewardShowId
    self.rewardsnum = cfg.NewRewardShowNum
    self.configName=cfg.resName
end
---@param cfg minichapter_config_cell
function LevelData:SetData_Custom(cfg)
    self.newid = cfg.NewID
    self.name = ClientDataManager:Get():GetTemplateString(cfg.name)
    self.idxname = ClientDataManager:Get():GetTemplateString(cfg.stageorder)
    self.idx = cfg.levelID
    self.icon = cfg.levelicon
    self.trackresname = cfg.trackresname
    self.nextlevel = cfg.nextIds
    self.isboss = (cfg.isboss == 1)
    self.leveltips = ClientDataManager:Get():GetTemplateString(cfg.leveltips)
    self.rewardsid = cfg.NewRewardShowId
    self.rewardsnum = cfg.NewRewardShowNum
    self.configName = cfg.resName
    self.StoryGroup = cfg.storygroup
    self.trackId = cfg.trackid
    self.FirstReward = CommonHelper:ParseToReward3(cfg.firstreward)
    self.SomeDown = CommonHelper:ParseToReward2(cfg.rewardshow)
end
---@param param SC_SelfChallengeLevelInfo
function LevelData:SetData_SelfChallenge(param ,i)
    self.newid = i
    self.name = "关卡"..i
    self.idxname = "第"..i.."关"
    self.idx = i
    self.icon = "chappic_item_zhishi_"

    self.trackresname = param.trackId
    self.nextlevel = -1
    self.isboss = false
    self.leveltips = "关卡描述"
    self.rewardsid = {12040202,12040202}
    self.rewardsnum = {2,2}
    ---@type racetrack_config_cell
    local track= CommonHelper:GetTableDataByID(ConfigNames.racetrack_config,param.trackId)
    self.configName=track.configName

end




---@class ChapterData
ChapterData = class("ChapterData")

function ChapterData:initialize()
    self.id = 0
    self.type = 0
    self.name = ""
    self.idx = ""
    self.icon = ""
    self.chapterbg = ""
    self.lock = true
    ---@type table<number, LevelData>
    self.LevelList = {}
    ---@type table<number, ChapterBoxData>
    self.BoxData = {}
    self.levelMap = {}
    self.BoxSlider = {}

    self.process = 0
end

---@class ChapterBoxData
ChapterBoxData = class("ChapterBoxData")
function ChapterBoxData:initialize(node)
    self.levelid = node[1]
    ---@type table<number, RewardData>
    self.rewards = CommonHelper:ParseToReward2(node[2])
    self.state = 0
end


---@param cfg map_config_cell
function ChapterData:SetData(cfg)
    self.type = cfg.type
    self.id = cfg.id
    self.name = ClientDataManager:Get():GetTemplateString(cfg.mapname)
    self.idx = ClientDataManager:Get():GetTemplateString(cfg.mapidx)
    self.icon = cfg.mapicon
    self.chapterbg = cfg.bg
    self.BoxData[1] = ChapterBoxData({cfg.progress1, cfg.reward1})
    self.BoxData[2] = ChapterBoxData({cfg.progress2, cfg.reward2})
    self.BoxData[3] = ChapterBoxData({cfg.progress3, cfg.reward3})
    self.BoxSlider = cfg.NewBoxSlider

    ---@type lvlocation_config
    local tablv = ClientDataManager:Get():GetDataTable(ConfigNames.lvlocation_config)
    self.levelMap = tablv.GetGroupNewId(cfg.lvlocation)


    if cfg.type == ChapterTypeCustom then
        ---@type minichapter_config
        local tab = ClientDataManager:Get():GetDataTable(ConfigNames.minichapter_config)
        local list = tab.GetLevelList(cfg.id)
        for i = 1, #list do
            local data = LevelData()
            data:SetData_Custom(list[i])
            table.insert(self.LevelList, data)
        end

        table.sort(self.LevelList,function (a, b)
            return a.idx < b.idx
        end)
    end

    if cfg.type == ChapterTypeStory then
        ---@type chapter_config
        local tab = ClientDataManager:Get():GetDataTable(ConfigNames.chapter_config)
        local list = tab.GetLevelList(cfg.id)
        for i = 1, #list do
            local data = LevelData()
            data:SetData_Story(list[i])
            table.insert(self.LevelList, data)
        end
        table.sort(self.LevelList,function (a, b)
            return a.idx < b.idx
        end)
    end


end

function ChapterData:SetLock(lock)
    self.lock = lock
end

function ChapterData:SetProcess(value)
    self.process = value
end

function ChapterData:SetAllBoxState(list)
    for i = 1, #list do
        self.BoxData[i].state = list[i].num2
    end
end

function ChapterData:SetBoxState(levelid, value)
    for i = 1, #self.BoxData do
        if self.BoxData[i].levelid == levelid then
            self.BoxData[i].state = value
            break
        end
    end

end

---@param param SC_SelfChallengeInfo
function ChapterData:SetDataSelfChallenge(param)
    self.type = 1
    self.id = param.miniInfo.id
    self.name = param.miniInfo.name
    self.idx = param.miniInfo.ticketId
    self.masterName=param.miniInfo.masterName
    self.icon = "chappic_title_zhishi_1.png"
    self.chapterbg = "chpaterbg_zhishi.prefab"
    local selfChallengeData= SelfChallengeDataManager:Get():GetSelfChallengeDataByTicket(self.idx)
    self.BoxData[1] = ChapterBoxData({selfChallengeData.needSetLv[1],param.finishRewards[1].num1 ,1})
    self.BoxData[2] = ChapterBoxData({selfChallengeData.needSetLv[2],param.finishRewards[2].num1,1})
    self.BoxData[3] = ChapterBoxData({selfChallengeData.needSetLv[3], param.finishRewards[3].num1,1})

    local tablv = ClientDataManager:Get():GetDataTable(ConfigNames.lvlocation_config)
    self.levelMap = tablv.GetGroupNewId(100101)

    for i = 1, #param.levelInfos  do
        local data = LevelData()
        data:SetData_SelfChallenge(param.levelInfos[i],i)
        if param.miniInfo.curLevel==0 then
            param.miniInfo.curLevel=1
        end
        data.lock = param.miniInfo.curLevel <i
        if param.miniInfo.curLevel==i then
            data.state=0
        elseif param.miniInfo.curLevel>i then
            data.state=1
        end
        table.insert(self.LevelList, data)
    end
    table.sort(self.LevelList,function (a, b)
         return a.idx < b.idx
    end)

end