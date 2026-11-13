---@class  RaceRoomShareData
---@field  id
---@field  pwd
---@field  name
---@field  maxNum
---@field  joinNum
---@field  shareType
---@field  mapIcon

---@class  ClubShareData
---@field  icon
---@field  count
---@field  maxCount
---@field  shareType
---@field  name

---@class  ChallengeMatchShareData
---@field  id
---@field  resultTime
---@field  awardID

---@class CsBattleResultData
---@field pid
---@field rank
---@field error
---@field time
---@field trackidx


---@class PropData
---@field propId table<number,number> @消耗道具的ID索引表
---@field count @当前道具需要消耗的数量
---@field gridIdx number @当前消耗道具的格子

---@class FinalLeftPropData
---@field part table<number,ArticleCell> @背包里还剩的配件
---@field article table<number,number> @configId,count

---@class KnapsackPropData
---@field part table<number,ArticleCell>
---@field article table<number,ArticleCell>

---@class ComposeSelectPropData
---@field part table<number,table<number,number>>@第一个是gridIdx,第二个是表{cellId,cellId}
---@field article table<number,table<number,number>>@第一个是gridIdx,第二个是表{configId,count}

---@class ComposeSelectPropDataAndCount
---@field part ComposeSelectPropDataAndCountItem@第一个是gridIdx
---@field article table<number,table<number,number>>@第一个是gridIdx,第二个是表{configId,count}


---@class ComposeSelectPropDataAndCountItem
---@field prop table<number,table<number,number>>@第一个是gridIdx,第二个table {cellId,cellId}
---@field count table<number,number> @第一个是gridIdx，第二个是数量


---@class ConvertTime
---@field hour string
---@field minute
---@field second
---@field milliSecond


---@class ActivityPreviewData
---@field fix table<number,number>@ key 索引 value 物品ID
---@field select table<number,number>@ key 索引 value 物品ID
---@field fixCount
---@field selectCount


---@class SdkSauthMessage
---@field user SdkSauthMessageSub

---@class SdkSauthMessageSub
---@field login_type  number @1
---@field login_time  number @1446543992


---@class SdkEnterData
---@field realNameMsg  string
---@field sauthLoginType  number
---@field aasMsg  string
---@field logInfoTab  LogInfo


---@class OtherResultData
---@field data
---@field items  SC_SomeDown

