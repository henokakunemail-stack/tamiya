---@class AEvent

---@class UnifySDKType
---@field All number
---@field QuickSDK number
---@field DeviceOAID number
---@field ReYunSDK number
---@field Crasheye number
---@field UltraSDK number
---@field QuickGAT number
---@field AdjustSDK number
---@field IsUseUltraSdk number
---@field IsUseUltraSdk2 number
UnifySDKType = CS.UnifySDK.UnifySDKType

------------------------------------------------------UnifySDK------------------------------------------------------
---@class InitSDKData 初始化
---@field InitSDKs  UnifySDK.UnifySDKType[]
InitSDKData = CS.UnifySDK.InitSDKData

---@class InitSuccessData 初始化成功
InitSuccessData = CS.UnifySDK.InitSuccessData

---@class InitFailedData 初始化失败
---@field errMsg  string
InitFailedData = CS.UnifySDK.InitFailedData

------------------------------------------------------UnifySDK------------------------------------------------------

------------------------------------------------------UnifySDK.Event.Share------------------------------------------------------
---@class SharePhotoData 
---@field imageName  string
---@field imagePath  string
---@field caption  string
---@field tag  string
SharePhotoData = CS.UnifySDK.Event.Share.SharePhotoData

---@class SharePhotoResultData 
---@field codeType  SharePhotoResultData.CodeType
SharePhotoResultData = CS.UnifySDK.Event.Share.SharePhotoResultData

---@class SharePhotoResultData.CodeType
---@field Succeed number
---@field Failed number
---@field Cancel number
SharePhotoResultData_CodeType = CS.UnifySDK.Event.Share.SharePhotoResultData.CodeType

---@class ShareUrlData 
---@field url  string
---@field quote  string
---@field tag  string
ShareUrlData = CS.UnifySDK.Event.Share.ShareUrlData

---@class ShareUlrResultData 
---@field codeType  ShareUlrResultData.CodeType
ShareUlrResultData = CS.UnifySDK.Event.Share.ShareUlrResultData

---@class ShareUlrResultData.CodeType
---@field Succeed number
---@field Failed number
---@field Cancel number
ShareUlrResultData_CodeType = CS.UnifySDK.Event.Share.ShareUlrResultData.CodeType

------------------------------------------------------UnifySDK.Event.Share------------------------------------------------------

------------------------------------------------------UnifySDK.Event.Purchase------------------------------------------------------
---@class PurchaseOrderInfoData 
---@field goodsID  string
---@field goodsName  string
---@field goodsDesc  string
---@field quantifier  string
---@field cpOrderID  string
---@field callbackUrl  string
---@field extrasParams  string
---@field price  number
---@field amount  number
---@field count  number
---@field productId  string
---@field roleName  string
---@field roleLv  string
---@field serverName  string
---@field currency  string
PurchaseOrderInfoData = CS.UnifySDK.Event.Purchase.PurchaseOrderInfoData

---@class PurchaseRoleInfoData 
---@field submitType  PurchaseRoleInfoData.SubmitType
---@field channelUserId  string
---@field gold1  string
---@field gold2  string
---@field serverName  string
---@field serverID  string
---@field gameRoleName  string
---@field gameRoleID  string
---@field gameRoleBalance  string
---@field vipLevel  string
---@field gameRoleLevel  string
---@field partyName  string
---@field roleCreateTime  string
---@field fightPower  string
---@field profession  string
---@field gameRoleGender  string
---@field gameRolePower  string
---@field partyId  string
---@field professionId  string
---@field partyRoleId  string
---@field partyRoleName  string
---@field friendlist  string
PurchaseRoleInfoData = CS.UnifySDK.Event.Purchase.PurchaseRoleInfoData

---@class PurchaseRoleInfoData.SubmitType
---@field StartGame number
---@field CreateRole number
---@field UpdateRole number
---@field Purchase number
PurchaseRoleInfoData_SubmitType = CS.UnifySDK.Event.Purchase.PurchaseRoleInfoData.SubmitType

---@class PurchaseSuccessData 
---@field orderId  string
---@field cpOrderId  string
---@field extraParam  string
PurchaseSuccessData = CS.UnifySDK.Event.Purchase.PurchaseSuccessData

---@class PurchaseFailedData 
---@field orderId  string
---@field cpOrderId  string
---@field extraParam  string
PurchaseFailedData = CS.UnifySDK.Event.Purchase.PurchaseFailedData

---@class PurchaseCancelData 
---@field orderId  string
---@field cpOrderId  string
---@field extraParam  string
PurchaseCancelData = CS.UnifySDK.Event.Purchase.PurchaseCancelData

---@class ConsumeSucceedData 
---@field purchaseToken  string
ConsumeSucceedData = CS.UnifySDK.Event.Purchase.ConsumeSucceedData

---@class RePaySuccessData 
---@field orderId  string
---@field cpOrderId  string
---@field goodsId  string
---@field purchaseTokenl  string
---@field packageName  string
RePaySuccessData = CS.UnifySDK.Event.Purchase.RePaySuccessData

---@class RestoreSuccessData 
---@field extraParam  string
RestoreSuccessData = CS.UnifySDK.Event.Purchase.RestoreSuccessData

------------------------------------------------------UnifySDK.Event.Purchase------------------------------------------------------

------------------------------------------------------UnifySDK.Event.Device------------------------------------------------------
---@class DeviceInfoData 
---@field OAID  string
---@field VAID  string
---@field IMEI  string
---@field SSAID  string
---@field UDID  string
---@field UUID  string
---@field GUID  string
---@field AAID  string
---@field IDFA  string
---@field errorMsg  string
DeviceInfoData = CS.UnifySDK.Event.Device.DeviceInfoData

---@class TranslateData 
---@field targetLand  string
---@field textInput  string
---@field callBack  System.Action`2[System.String,System.String]
TranslateData = CS.UnifySDK.Event.Device.TranslateData

------------------------------------------------------UnifySDK.Event.Device------------------------------------------------------

------------------------------------------------------UnifySDK.Event.Crash------------------------------------------------------
---@class ScriptExceptionConfigData 
---@field errorTitle  string
---@field stacktrace  string
---@field language  string
ScriptExceptionConfigData = CS.UnifySDK.Event.Crash.ScriptExceptionConfigData

---@class LoggingData 
---@field lines  number
---@field filter  string
LoggingData = CS.UnifySDK.Event.Crash.LoggingData

------------------------------------------------------UnifySDK.Event.Crash------------------------------------------------------

------------------------------------------------------UnifySDK.Event.Analysis------------------------------------------------------
---@class RegisterData 
---@field account  string
---@field customParam  string
RegisterData = CS.UnifySDK.Event.Analysis.RegisterData

---@class LoginData 
---@field account  string
---@field serverId  string
---@field customParam  string
LoginData = CS.UnifySDK.Event.Analysis.LoginData

---@class RechargeData 
---@field eventName  string
---@field orderID  string
---@field paymentType  string
---@field currencyType  string
---@field currencyAmount  number
---@field customParam  string
---@field itemID  string
RechargeData = CS.UnifySDK.Event.Analysis.RechargeData

---@class OrderData 
---@field eventName  string
---@field orderID  string
---@field currencyType  string
---@field currencyAmount  number
OrderData = CS.UnifySDK.Event.Analysis.OrderData

---@class CustomEventData 
---@field eventName  string
---@field customParam  string
---@field eventCode  string
CustomEventData = CS.UnifySDK.Event.Analysis.CustomEventData

---@class TrackViewDurationData 
---@field pageID  string
---@field duration  number
---@field customParam  string
TrackViewDurationData = CS.UnifySDK.Event.Analysis.TrackViewDurationData

---@class TrackAdShowData 
---@field adPlatform  string
---@field adId  string
---@field playSuccess  boolean
---@field customParam  string
TrackAdShowData = CS.UnifySDK.Event.Analysis.TrackAdShowData

---@class TrackAdClickData 
---@field adPlatform  string
---@field adId  string
---@field customParam  string
TrackAdClickData = CS.UnifySDK.Event.Analysis.TrackAdClickData

---@class TrackAppDurationData 
---@field duration  number
---@field customParam  string
TrackAppDurationData = CS.UnifySDK.Event.Analysis.TrackAppDurationData

------------------------------------------------------UnifySDK.Event.Analysis------------------------------------------------------

------------------------------------------------------UnifySDK.Event.Account------------------------------------------------------
---@class LoginSuccessData 登录成功
---@field uid  string
---@field userName  string
---@field token  string
---@field channelId  string
---@field channelName  string
---@field errMsg  string
LoginSuccessData = CS.UnifySDK.Event.Account.LoginSuccessData

---@class SwitchAccountSuccessData 切换账号失败
---@field uid  string
---@field userName  string
---@field token  string
---@field errMsg  string
SwitchAccountSuccessData = CS.UnifySDK.Event.Account.SwitchAccountSuccessData

---@class SwitchAccountFaileData 切换账号成功
---@field errMsg  string
SwitchAccountFaileData = CS.UnifySDK.Event.Account.SwitchAccountFaileData

---@class SwitchAccountCancelData 切换账号取消
---@field errMsg  string
SwitchAccountCancelData = CS.UnifySDK.Event.Account.SwitchAccountCancelData

---@class LoginFailedData 登录失败
---@field errMsg  string
LoginFailedData = CS.UnifySDK.Event.Account.LoginFailedData

---@class LoginCancelData 登录取消
---@field errMsg  string
LoginCancelData = CS.UnifySDK.Event.Account.LoginCancelData

---@class LogoutSuccessData 账号退出成功
---@field errMsg  string
LogoutSuccessData = CS.UnifySDK.Event.Account.LogoutSuccessData

---@class CallFuncSuccessData 调用函数成功
---@field SuccessMsg  string
CallFuncSuccessData = CS.UnifySDK.Event.Account.CallFuncSuccessData

---@class CallFuncFailedData 调用函数失败
---@field errMsg  string
CallFuncFailedData = CS.UnifySDK.Event.Account.CallFuncFailedData

---@class LogoutFailedData 账号退出失败
---@field errMsg  string
LogoutFailedData = CS.UnifySDK.Event.Account.LogoutFailedData

---@class ExitSuccessData 游戏退出成功
---@field errMsg  string
ExitSuccessData = CS.UnifySDK.Event.Account.ExitSuccessData

---@class ExitFailedData 游戏退出失败
---@field errMsg  string
ExitFailedData = CS.UnifySDK.Event.Account.ExitFailedData

---@class AccountDeletionData 游戏销毁
---@field state  string
AccountDeletionData = CS.UnifySDK.Event.Account.AccountDeletionData

---@class UnAccountDeletionData 取消游戏销毁
---@field state  string
UnAccountDeletionData = CS.UnifySDK.Event.Account.UnAccountDeletionData

---@class PrivacyAgreeData 隐私协议
PrivacyAgreeData = CS.UnifySDK.Event.Account.PrivacyAgreeData

---@class PrivacyRefuseData 隐私拒绝
PrivacyRefuseData = CS.UnifySDK.Event.Account.PrivacyRefuseData

------------------------------------------------------UnifySDK.Event.Account------------------------------------------------------
