HttpHelperLua = class("HttpHelperLua")

function HttpHelperLua:initialize()
    self.ERROR404 = 404
    self.ERRORTIMEOUT = 1
    self.NotReachable = -1
    self.ERROR = 2
    self.count = 0
    self.maxcount = 3
    self.successCallback = nil
    self.successSimpleCallback = nil
    self.errorCallback = nil
    self.successCallback_Lua = nil
    self.successSimpleCallback_Lua = nil
    self.errorCallback_Lua = nil
    self.fileName = nil
    self.isSaveInCSharp = false
    self.url = nil
    self.lastJsonStr = nil
    self.lastPostData = nil
    self.lastform = nil
    self.request = nil
end

function HttpHelperLua:SendHttp(uri, ...)
    self.count = 0
    if CS.UnityEngine.Application.internetReachability == CS.UnityEngine.NetworkReachability.NotReachable then
        self:HandleError(self.NotReachable)
        return
    end

    uri = self:AddField(uri, ...)
    self.url = uri
    -- Start Coroutine to send GET request
    cs_coroutine.start(self.SendGetRequest, self, uri)
end

function HttpHelperLua:SendGetRequest(uri)
    self.request = CS.UnityEngine.Networking.UnityWebRequest.Get(uri)
    self.request.timeout = 25
    self.request:SendWebRequest()

    -- Yield until the request finishes
    while not self.request.isDone do
        coroutine.yield()  -- Yield execution until the request is completed
    end

    if self.request.result ~= CS.UnityEngine.Networking.UnityWebRequest.Result.Success then
        CS.UnityEngine.Debug.LogError("Error: " .. self.request.error)
        self:HandleError(self.request.responseCode)
    else
        self:HandleSuccess(self.request.downloadHandler.data)
    end
end

function HttpHelperLua:SendHttpPost(uri, ...)
    self.count = 0
    if CS.UnityEngine.Application.internetReachability == CS.UnityEngine.NetworkReachability.NotReachable then
        self:HandleError(self.NotReachable)
        return
    end

    local form = CS.UnityEngine.WWWForm()
    for i = 1, #arg, 2 do
        form:AddField(arg[i], arg[i + 1])
    end

    self.url = uri
    self.lastform = form
    -- Start Coroutine to send POST request
    cs_coroutine.start(self.SendPostRequest, self, uri, form)
end

function HttpHelperLua:SendPostRequest(uri, form)
    self.request = CS.UnityEngine.Networking.UnityWebRequest.Post(uri, form)
    self.request.timeout = 25
    self.request:SendWebRequest()

    -- Yield until the request finishes
    while not self.request.isDone do
        coroutine.yield()  -- Yield execution until the request is completed
    end

    if self.request.result ~= CS.UnityEngine.Networking.UnityWebRequest.Result.Success then
        CS.UnityEngine.Debug.LogError("Error: " .. self.request.error)
        self:HandleError(self.request.responseCode)
    else
        self:HandleSuccess(self.request.downloadHandler.data)
    end
end

function HttpHelperLua:SendHttpPostDicData(uri, postData)
    self.count = 0
    if CS.UnityEngine.Application.internetReachability == CS.UnityEngine.NetworkReachability.NotReachable then
        self:HandleError(self.NotReachable)
        return
    end

    self.url = uri
    self.lastPostData = postData
    -- Start Coroutine to send POST with dictionary data
    cs_coroutine.start(self.SendPostRequestDic, self, uri, postData)
end

function HttpHelperLua:SendPostRequestDic(uri, postData)
    local form = CS.UnityEngine.WWWForm()
    for key, value in pairs(postData) do
        form:AddField(key, value)
    end

    self.request = CS.UnityEngine.Networking.UnityWebRequest.Post(uri, form)
    self.request.timeout = 25
    self.request:SendWebRequest()

    -- Yield until the request finishes
    while not self.request.isDone do
        coroutine.yield()  -- Yield execution until the request is completed
    end

    if self.request.result ~= CS.UnityEngine.Networking.UnityWebRequest.Result.Success then
        CS.UnityEngine.Debug.LogError("Error: " .. self.request.error)
        self:HandleError(self.request.responseCode)
    else
        self:HandleSuccess(self.request.downloadHandler.data)
    end
end

function HttpHelperLua:SendHttpPost_Json(uri, jsonStr)
    self.count = 0
    if CS.UnityEngine.Application.internetReachability == CS.UnityEngine.NetworkReachability.NotReachable then
        self:HandleError(self.NotReachable)
        return
    end

    self.url = uri
    self.lastJsonStr = jsonStr
    -- Start Coroutine to send POST with JSON data
    cs_coroutine.start(self.SendPostRequestJson, self, uri, jsonStr)
end

function HttpHelperLua:SendPostRequestJson(uri, jsonStr)
    local jsonToSend = CS.System.Text.UTF8Encoding:GetBytes(jsonStr)
    self.request = CS.UnityEngine.Networking.UnityWebRequest(uri, "POST")
    self.request.uploadHandler = CS.UnityEngine.Networking.UploadHandlerRaw(jsonToSend)
    self.request.downloadHandler = CS.UnityEngine.Networking.DownloadHandlerBuffer()
    self.request:SetRequestHeader("Content-Type", "application/json")
    self.request.timeout = 25
    self.request:SendWebRequest()

    -- Yield until the request finishes
    while not self.request.isDone do
        coroutine.yield()  -- Yield execution until the request is completed
    end

    if self.request.result ~= CS.UnityEngine.Networking.UnityWebRequest.Result.Success then
        CS.UnityEngine.Debug.LogError("Error: " .. self.request.error)
        self:HandleError(self.request.responseCode)
    else
        self:HandleSuccess(self.request.downloadHandler.data)
    end
end

function HttpHelperLua:HandleError(errorCode)
    if self.count < self.maxcount then
        self.count = self.count + 1
        CS.UnityEngine.Debug.Log("Retrying... Attempt " .. self.count .. " of " .. self.maxcount)
        if self.lastJsonStr then
            -- Retry with JSON data
            cs_coroutine.start(self.SendPostRequestJson, self, self.url, self.lastJsonStr)
        elseif self.lastPostData then
            -- Retry with dictionary data
            cs_coroutine.start(self.SendPostRequestDic, self, self.url, self.lastPostData)
        elseif self.lastform then
            -- Retry with form data
            cs_coroutine.start(self.SendPostRequest, self, self.url, self.lastform)
        else
            -- Retry with GET request
            cs_coroutine.start(self.SendGetRequest, self, self.url)
        end
    else
        self.count = 0
        if self.errorCallback then
            self.errorCallback(errorCode)
            self.errorCallback = nil
        end
        if self.errorCallback_Lua then
            self.errorCallback_Lua(errorCode)
            self.errorCallback_Lua = nil
        end
    end
end

function HttpHelperLua:HandleSuccess(data)
    self.count = 0
    if self.isSaveInCSharp then
        if self.successSimpleCallback then
            self.successSimpleCallback(#data)
            self.successSimpleCallback = nil
        end
        -- Save to file
        CS.MonoHelper.WriteFileBytes(self.fileName, data)
        if self.successSimpleCallback_Lua then
            self.successSimpleCallback_Lua(#data)
            self.successSimpleCallback_Lua = nil
        end
    else
        if self.successCallback then
            self.successCallback(data)
            self.successCallback = nil
        end
        if self.successCallback_Lua then
            self.successCallback_Lua(data)
            self.successCallback_Lua = nil
        end
    end
end

function HttpHelperLua:AddField(uri, ...)
    local builder = uri
    local args = {...}
    for i = 1, #args, 2 do
        local key = args[i]
        local value = args[i + 1]
        local temp = (i == 1) and string.format("%s=%s", key, value) or string.format("&%s=%s", key, value)
        builder = builder .. temp
    end
    return builder
end

function HttpHelperLua:AbortRequest()
    if self.request then
        self.request:Abort()
        CS.UnityEngine.Debug.Log("Request aborted.")
    end
end

function HttpHelperLua.HttpQuit()
    -- UnityWebRequest does not require explicit quit handling in Lua
end
