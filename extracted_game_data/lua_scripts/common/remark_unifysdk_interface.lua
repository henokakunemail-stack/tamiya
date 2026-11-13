
---@class IUnifySDK : CS.UnifySDK.IUnifySDK
---@field OnInit fun(param:self):void
---@field SetAppVersion fun(param:self,youAppVersion:string):void
---@field SetUserIdentifier fun(param:self,userIdentifier:string):void
---@field SetChannelID fun(param:self,channelID:string):void
---@field GetChannelID fun(param:self):string
---@field GetChannelName fun(param:self):string
---@field OnDestroy fun(param:self):void
---@field Priority number
---@field SDKType UnifySDKType
---@field AutoInit boolean
---@field OnInitData AEvent<InitSDKData>
---@field OnInitSuccess AEvent<InitSuccessData>
---@field OnInitFailed AEvent<InitFailedData>

---@class IUnifySDK_Account : CS.UnifySDK.IUnifySDK_Account
---@field Login fun(param:self,isShowMenu:boolean):void
---@field Logout fun(param:self):void
---@field AccountDeletion fun(param:self):void
---@field UnAccountDeletion fun(param:self):void
---@field IsUserGuest fun(param:self):boolean
---@field QuitGame fun(param:self):void
---@field CanQuitGame fun(param:self):boolean
---@field ShowMenu fun(param:self):void
---@field DismissMenu fun(param:self):void
---@field ShowUserCenter fun(param:self):void
---@field ShowCustomerCenter fun(param:self):void
---@field ShowPrivacy fun(param:self):void
---@field GetCPSChannelID fun(param:self):string
---@field callFunction fun(param:self,nType:number):void
---@field callFunctionWithResult fun(param:self,nType:number):string
---@field OnLoginSuccess AEvent<LoginSuccessData>
---@field OnSwitchAccountSuccess AEvent<SwitchAccountSuccessData>
---@field OnLoginFailed AEvent<LoginFailedData>
---@field OnLogoutSuccess AEvent<LogoutSuccessData>
---@field OnExitSuccess AEvent<ExitSuccessData>
---@field OnPrivacyAgree AEvent<PrivacyAgreeData>
---@field OnPrivacyRefuse AEvent<PrivacyRefuseData>
---@field OnCallFuncSucceed AEvent<CallFuncSuccessData>
---@field OnCallFuncFailed AEvent<CallFuncFailedData>
---@field OnAccountDeletion AEvent<AccountDeletionData>
---@field OnUnAccountDeletion AEvent<UnAccountDeletionData>

---@class IUnifySDK_Analysis : CS.UnifySDK.IUnifySDK_Analysis
---@field Order fun(param:self,data:OrderData):void
---@field SetCustomEvent fun(param:self,data:CustomEventData):void
---@field SetPrintLog fun(param:self,print:boolean):void
---@field SetTrackViewDuration fun(param:self,data:TrackViewDurationData):void
---@field SetTrackAdShow fun(param:self,data:TrackAdShowData):void
---@field SetTrackAdClick fun(param:self,data:TrackAdClickData):void
---@field SetTrackAppDuration fun(param:self,data:TrackAppDurationData):void
---@field getAttribution fun(param:self):string
---@field OnRegisterEvent AEvent<RegisterData>
---@field OnLoginEvent AEvent<LoginData>
---@field OnRechargeEvent AEvent<RechargeData>
---@field OnCustomEvent AEvent<CustomEventData>

---@class IUnifySDK_Crash : CS.UnifySDK.IUnifySDK_Crash
---@field SendScriptException fun(param:self,ex:CS.System.Exception):void
---@field SendScriptException fun(param:self,data:ScriptExceptionConfigData):void
---@field SetFlushOnlyOverWiFi fun(param:self,enabled:boolean):void
---@field SetIsBetaVersion fun(param:self,isBeta:boolean):void
---@field EnableCSharpStackTrace fun(param:self):void
---@field SetLogging fun(param:self,lines:number):void
---@field SetLogging fun(param:self,filter:string):void
---@field SetLogging fun(param:self,data:LoggingData):void
---@field SetURL fun(param:self,url:string):void

---@class IUnifySDK_Device : CS.UnifySDK.IUnifySDK_Device
---@field GetDeviceInfo fun(param:self,callBack:fun(param1:DeviceInfoData)):void
---@field Translate fun(param:self,data:TranslateData):void

---@class IUnifySDK_Purchase : CS.UnifySDK.IUnifySDK_Purchase
---@field QueryGoods fun(param:self):void
---@field Purchase fun(param:self,data:PurchaseOrderInfoData):void
---@field SubmitPurchaseRoleInfo fun(param:self,data:PurchaseRoleInfoData):void
---@field ConsumePurchase fun(param:self,token:string):void
---@field QueryPurchasesAsync fun(param:self):void
---@field OnPurchaseSuccess AEvent<PurchaseSuccessData>
---@field OnPurchaseFailed AEvent<PurchaseFailedData>
---@field OnPurchaseCancel AEvent<PurchaseCancelData>
---@field OnConsumeSuccess AEvent<ConsumeSucceedData>
---@field OnRePaySuccess AEvent<RePaySuccessData>

---@class IUnifySDK_Share : CS.UnifySDK.IUnifySDK_Share
---@field SharePhoto fun(param:self,data:SharePhotoData):void
---@field ShareUrl fun(param:self,data:ShareUrlData):void
---@field CaptureScreenshotSharePhoto fun(param:self):void
---@field OnSharePhotoComplete AEvent<SharePhotoResultData>
---@field OnShareUlrComplete AEvent<ShareUlrResultData>

EnvironmentVariableSettings = CS.UnifySDK.EnvironmentVariableSettings.Instance
---@class UnifySDKEventSystem
---@field Publish fun(param:self,data:CS.System.struct):void
UnifySDKEventSystem = CS.UnifySDK.Event.UnifySDKEventSystem.Instance
