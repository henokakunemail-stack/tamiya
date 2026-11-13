function MainStart()
	cs_coroutine.start(function()
		require ("require_list")
		coroutine.yield()
		Start_BeforeLogin1()
		coroutine.yield()
		Start_BeforeLogin2()
		CommonHelper:SendAdJustToken(TrackEventNames.App_Init,AnalysisType.App_Init)
		QuickTa:Get():TrackEvent(TrackEventNames.MainStart, nil,TrackEventType.Default,AnalysisType.MainStart)
	end)
end

function Start_BeforeLogin1()
if not CS.GameProperties:Get().IsFE then
	log(".......main start")
end
	HQualitySetting:OnInit()
	HQualitySetting:SetForceBright(false)
	UnifySDKManager:Get():OnInit()
	CSCameraManager.Get():OnInit(true)
	CameraStackHelper:SetUIDefaultGroup()
	AudioManager:OnInit()
	ClientDataManager:Get():SetGameState(GameState.After_Login)
	if GameProperties.AreaType==AreaType.AreaTypeKR then
		local type=GameProperties.languageType
		GameProperties.languageType=CS.Language_Type.KR
		LanguageSwitchManager.Get():OnInit(GameProperties.languageType)
		GameProperties.languageType=type
		LanguageSwitchManager.Get():ChangeLanguage(type)
	end
	UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitCG, false)
end
function Start_BeforeLogin2()
	require ("require_list_2")
	CS.MonoHelper.GameStart()
	NetManager:Get():OnInit()
	AdsManager:Init()
	ClientDataManager:Get():InitConfig()
	NetDelayManager:Get():Register()
	ScreenClickCtrl:Init()
	MsgErrorManager:Get():Init()
	ClientDataManager:Get().IsConfig2 =false
	ClientDataManager:Get():InitAppStartConfig()
	RedPointManager:Get():OnInit()
	CS.LuaHelper.Get():OnInitStringNumbers()
	RtHelper:Init()
	CommonHelper:InitSound()
	SceneHomeManager:Get():OnInit()
	MeshCacheMgr:Get():AdvanceLoad()
	PrefabCacheMgr:Get():AdvanceLoad()
	CarAttrRecommendManager:Get():Init()
	CarAssembleRule:Get():Init()
	Start_LuaAddNum()
	if HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Debug) then
		Debug.unityLogger.logEnabled = true
	end
end


function Start_AfterLogin()
	MatCacheDataMgr:Get():AdvanceLoad()
	PlotManager:Get():OnInit()
	ComicManager:Get():OnInit()
end
function Start_LuaAddNum()
	local numStrs = {}
	for i = 0, 201 do
		numStrs[i]=tostring(i-1)
	end CSLuaHelper:Get().num10Strings = numStrs
end

function RemoveRequiredByName( preName )
if not CS.GameProperties:Get().IsFE then
	logError("preName = "..preName)
end
	for key, _ in pairs(package.preload) do
		if string.find(tostring(key), preName) == 1 then
			package.preload[key] = nil
if not CS.GameProperties:Get().IsFE then
			logError("preload key = "..key)
end
		end
	end
	for key, _ in pairs(package.loaded) do
		if string.find(tostring(key), preName) == 1 then
			package.loaded[key] = nil
		end
	end

	require(preName)
end


--内网192.168.1.100
--外网111.229.19.127
--华松192.168.1.14

















--function Start_BeforeLogin2()
--	log(".......main start")
--	ClientDataManager:Get():SetGameState(GameState.After_Login)
--	LanguageSwitchManager.Get():OnInit()
--	NetManager:Get():OnInit()
--	NetDelayManager:Get():Register()
--	ScreenClickCtrl:Init()
--	AudioManager:OnInit()
--	HQualitySetting:OnInit()
--	CSCameraManager.Get():OnInit(true)
--	CameraStackHelper:SetUIDefaultGroup()
--	MsgErrorManager:Get():Init()
--	ClientDataManager:Get():InitLoginConfig()
--	RedPointManager:Get():OnInit()
--	CS.LuaHelper.Get():OnInitStringNumbers()
--	CommonHelper:InitSound()
--	SDKManager:Get():OnInit()
--
--end
--function Start_BeforeLogin()
--	require ("common/luahelper")
--	cs_coroutine.start(function()
--		coroutine.yield()
--		CS.HBundle.BundlesManager.Unload(CS.AppPath.GetPlatformName())
--		CS.HBundle.AssetsManager.OnInit(function()
--			CS.LuaHelper.Get():Clear()
--			require ("require_list")
--			CS.LuaHelper.Get():OnFristInit()
--			CS.LuaHelper.Get():OnInit()
--			Start_BeforeLogin2()
--			CS.Horizon.Game.LogicLayer.TableDataLoader.Get():RegisterTable()
--		end)
--	end)
--
--	--CS.HBundle.AssetsManager.OnInit(function()
--	--	--coroutine.yield()
--	--	require ("require_list")
--	--	Start_BeforeLogin2()
--	--end)
--end
--
--function Start_AfterLogin()
--	ClientDataManager:Get():InitConfig()
--	MeshCacheMgr:Get():OnInit()
--	MeshCacheMgr:Get():AdvanceLoad()
--	PrefabCacheMgr:Get():OnInit()
--	PrefabCacheMgr:Get():AdvanceLoad()
--	MatCacheDataMgr:Get():AdvanceLoad()
--	SDKManager:Get():Init()
--	CarAssembleRule:Get():Init()
--	PlotManager:Get():OnInit()
--end
--
--function RemoveRequiredByName( preName )
--	logError("preName = "..preName)
--	for key, _ in pairs(package.preload) do
--		if string.find(tostring(key), preName) == 1 then
--			package.preload[key] = nil
--			logError("preload key = "..key)
--		end
--	end
--	for key, _ in pairs(package.loaded) do
--		if string.find(tostring(key), preName) == 1 then
--			package.loaded[key] = nil
--		end
--	end
--
--	require(preName)
--end
--function AssetFlagReLoad()
--	if CS.GameProperties:Get().AssetBundleMode and CS.GameProperties:Get().HotfixEnable and VersionManager:Get():GetVersionCheckResult()==SerE_VersionCheckResult.Assets then
--		local path = HotfixHelper:GetLocalHotfixMapPath()
--		local result = HotfixHelper:ReadFileString(path)
--		if result==nil or result=="" then
--
--		else
--			local w = CS.UnityEngine.WWW(HotfixHelper:GetPkgHotfixMapPath())
--			while not w.isDone do coroutine.yield() end
--			if w.error and w.error ~= "" then
--				if self.ErrorFun then
--					self.ErrorFun()
--				end
--			else
--				local LocalMap=HotfixManager:Get():AnalyseCfg(result)
--				local PkgMap=HotfixManager:Get():AnalyseCfg(w.text)
--				local flagMap={}
--				for k, v in pairs(PkgMap) do
--					local flagdata = AssetFlagData(v.FileName)
--					if LocalMap[k]==nil or LocalMap[k]~=PkgMap[k] then
--						flagdata.ReadFlag="1"
--					end
--					table.insert(flagMap,flagdata)
--				end
--				local data = ""
--				local tempTab = {}
--				for k,v in pairs(self.flagdata) do
--					table.insert(tempTab, v.Key)
--					table.insert(tempTab, ":")
--					table.insert(tempTab, v.ReadFlag)
--					table.insert(tempTab, "\n")
--				end
--				data = table.concat(tempTab)
--				local path = HotfixHelper:GetAssetFlagMapPath()
--				print("---   assetflagmap保存到本地，path = ", path)
--				HotfixHelper:WriteFileString(path, data)
--			end
--		end
--	end
--	--CS.HBundle.AssetsManager.ForceDisposeAll()
--end
--
--AssetFlagReLoad()

--内网192.168.1.100
--外网111.229.19.127
--华松192.168.1.14
