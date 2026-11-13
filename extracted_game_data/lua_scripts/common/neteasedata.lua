---@class Sauth
Sauth = class("Sauth")

function Sauth:initialize()
    self.  gameid = ""
    self.  login_channel = ""
    self.  app_channel = ""
    self.  platform = ""
    self.  sdkuid = ""
    self.  udid = ""
    self.  sessionid = ""
    self.  sdk_version = ""
    self.  is_unisdk_guest = -1
    self.  ip = ""
    self.  hostid = -1
    ---@type Aim_info
    self.  aim_info = Aim_info()
    self.  source_app_channel = ""
    self.  source_platform = ""
    self.  deviceid = ""
    self.  client_login_sn = ""
    self.  step = ""
    self.  step2 = ""
end

---@class Aim_info
Aim_info = class("Aim_info")
function Aim_info:initialize()
    self. tz = ""
    self. tzid = ""
    self. aim = ""
    self. country = ""
end

---@class SauthReturn
SauthReturn = class("SauthReturn")
function SauthReturn:initialize()
    self.  code = -1
    self.  subcode = -1
    self.  uid = 0

    self.  status = ""
    self.  aid = -1
    self.  username = ""
    self.  gamepoint = -1
    self.  balpoint = -1
    self.  SN = ""
    self.  type = false
    self. events = -1
    self. uidcount = -1
    self. newtm = -1
    self. vipgrade = -1
    self. cardpoint = -1
    self. expire_tm = -1
    self. cardtype = -1
    self. data = nil
    self. message = nil
    self. login_type = nil
    self. sessioncode = ""
    self.  aas_msg = Aas_msg()
    self.  aas_ban = Aas_ban()
    self.  realname_msg = Realname_msg()
    self.  unisdk_login_json = Unisdk_login_json()
    self.  universal_info = {}--table<number,Universal_info>
end
---@param jsonReturn SauthReturn
function SauthReturn:SetData(jsonReturn)
    self.  code = jsonReturn.code
    self.  subcode = jsonReturn.subcode
    self.  uid = jsonReturn.uid
    self.  status = jsonReturn.status
    self.  aid = jsonReturn.aid
    self.  username = jsonReturn.username
    self.  gamepoint = jsonReturn.gamepoint
    self.  balpoint = jsonReturn.balpoint
    self.  SN = jsonReturn.SN
    self.  type = jsonReturn.type
    self. events = jsonReturn.events
    self. uidcount = jsonReturn.uidcount
    self. newtm = jsonReturn.newtm
    self. vipgrade = jsonReturn.vipgrade
    self. cardpoint = jsonReturn.cardpoint
    self. expire_tm = jsonReturn.expire_tm
    self. cardtype = jsonReturn.cardtype
    self. data = jsonReturn.data
    self. object = jsonReturn.object
    self. sessioncode = jsonReturn.sessioncode
    self.  aas_msg = jsonReturn.aas_msg == nil and "" or Dll_JSON.encode(jsonReturn.aas_msg)
    --self.  realname_msg = jsonReturn.realname_msg == nil and "" or Dll_JSON.encode(jsonReturn.realname_msg)
    self.  aas_ban = jsonReturn.aas_ban
    self.  unisdk_login_json = jsonReturn.unisdk_login_json
    self.  universal_info = jsonReturn.universal_info
    self.login_type=tostring(jsonReturn.login_type)
    ---@type SdkSauthMessage
    --self.message = jsonReturn.message == nil and "" or Dll_JSON.decode(monoAndroidUtility.DecodeBase64(jsonReturn.message))
end

---@class Unisdk_login_json
Unisdk_login_json = class("Unisdk_login_json")

function Unisdk_login_json:initialize()
    self.  aid = ""
    self.  sdkuid = ""
    self.  username = ""
    self.  access_token = ""
    self.  expires_in = ""
    self.  refresh_token = ""
    self.  realname_msg = Realname_msg_Now()
    self.  chl_sdk_json = Chl_sdk_json()
end

---@class Realname_msg_Now
Realname_msg_Now = class("Realname_msg_Now")

function Realname_msg_Now:initialize()
    self. realname_status = ""--0代表未实名  1表示已实名
    self. is_adult = ""--0 代表未成年 1表示已成年
end

---@class Chl_sdk_json
Chl_sdk_json = class("Chl_sdk_json")

function Chl_sdk_json:initialize()
    self.  sdkuid = ""
    self.  aid = ""
    self.  timestamp = ""
    self.  sign = ""
end

---@class Realname_msg
Realname_msg = class("Realname_msg")

function Realname_msg:initialize()
    self.  oversea = false
    self.  id_hash = ""
    self.  verify_status = -1
    self.  birthday = -1
    self.  age_range = -1
end

---@class Aas_msg
Aas_msg = class("Aas_msg")

function Aas_msg:initialize()
    self.  need_realname = false
    self.  reason = ""
    self.  need_role_enter = false
end

---@class Aas_ban
Aas_ban = class("Aas_ban")
function Aas_ban:initialize()
    self.  ban = -1
    self.  ban_msg = ""
end

---@class Universal_info
Universal_info = class("Universal_info")

function Universal_info:initialize()
    self.  aid = -1
    self.  username = ""
end

---@class ExtendFunc  @所有回调的基本json 数据类型
ExtendFunc = class("ExtendFunc")

function ExtendFunc:initialize()

    self.  methodId = ""
end

---@class ExtendFuncGetDiaResult  @获取实名制状态的返回结果
ExtendFuncGetDiaResult = class("ExtendFuncGetDiaResult")
function ExtendFuncGetDiaResult:initialize()
    self.  status = -1
end

---@class ExtendFuncShowDiaResult  @打开实名制窗口的返回结果
ExtendFuncShowDiaResult = class("ExtendFuncShowDiaResult")
function ExtendFuncShowDiaResult:initialize()

    self.  result = -1
end

---@class ExtendFuncAASResult  @防沉迷状态的返回结果
ExtendFuncAASResult = class("ExtendFuncAASResult")
function ExtendFuncAASResult:initialize()
    self.  methodId = ""
    self.  code = -1
    self.  needAAS = -1
    self.  leftTimeSeconds = -1
end

---@class ExtendFuncQueryAASLeftTimeResult  @查询放沉迷返回时间 的返回结果 例如：{"result":{"leftTime":3225, "isRealname":false} }
ExtendFuncQueryAASLeftTimeResult = class("ExtendFuncQueryAASLeftTimeResult")
function ExtendFuncQueryAASLeftTimeResult:initialize()
    self.     methodId = ""
    self.    result = QueryAASLeftTimeResultInfo()
end

---@class QueryAASLeftTimeResultInfo  @查询放沉迷返回时间 的返回结果 例如：{"result":{"leftTime":3225, "isRealname":false} }
QueryAASLeftTimeResultInfo = class("QueryAASLeftTimeResultInfo")
function QueryAASLeftTimeResultInfo:initialize()
    self.     leftTime = -1
    self.  isRealname = false
end

---@class CallbackLeaveSdkResult  @ 从 SDK 界面（如登录、支付、用户中心）回到游戏界面时，会通过 extendFuncCall 回调给游戏
CallbackLeaveSdkResult = class("CallbackLeaveSdkResult")

function CallbackLeaveSdkResult:initialize()
    self.     CallbackLeaveSdkResultInfo = CallbackLeaveSdkResultInfo()
end

---@class CallbackLeaveSdkResultInfo
CallbackLeaveSdkResultInfo = class("CallbackLeaveSdkResultInfo")
function CallbackLeaveSdkResultInfo:initialize()
    self.  methodId = ""
    self.     code = -1
end

---@class NtCloseWebView  @ 关闭问卷调查界面
NtCloseWebView = class("NtCloseWebView")

function NtCloseWebView:initialize()
    self.  methodId = ""
    self.     result = -1
end
---@class LogInfo
LogInfo = class("LogInfo")
function LogInfo:initialize()
    self. deviceModel = ""
    self. osName = ""
    self. osVer = ""
    self. mac = ""
    self. udid = ""
    self. appChannel = ""
    self. appVer = ""
    self. network = ""
    self. transId = ""
    self. unisdkDeviceId = ""
    self. isEmulator = 0
    self. isRoot = 0
    self. oldAccoutId = ""
    self. oaid = ""
    self. engineVer = ""
    self. ip = ""
    self. ipv6 = ""
    self. countryCode = ""
    self. width = 0
    self. height = 0
    self. isp = ""
    self. accountId = ""
    self. imei = ""
    self. caid = ""
end


---@class NetEaseOrbitFinished
---@field code     --int 下载结果
---@field progress --double 下载进度
---@field section  --NSUInteger
---@field size     -- long 全部文件大小
---@field bytes    --long 已下载大小
---@field fileName --NSString 文件名字
---@field filePath --NSString 文件路径
---@field codeDescription--NSString  结果描述，对于code而言
---@field error    --NSError * 错误信息
---@field downloadId--NSString 产品每次调用start方法传的值，用于标识哪次任务
---@field fileBytes--NSData *

---@class NetEaseEnvNickName
---@field code     --int 过滤结果
---@field message  --string 处理理结果的⽂文字提示;
---@field regularId--(字符串串) 匹配到的正则 id, 没有匹配到是为 -1  --NSUInteger

---@class NetEaseCutoutInfo
---@field methodId  string
---@field hasCutout  boolean
---@field width  number
---@field height  number
---@field left  number
---@field right  number
---@field top  number
---@field bottom  number


---@class NetEaseCaid
---@field methodId  string
---@field caid  string
---@field message  string
---@field errorCode  number  @0 或-1  0代表成功，-1代表失败




logLuaStr = "logInLua------------------"
