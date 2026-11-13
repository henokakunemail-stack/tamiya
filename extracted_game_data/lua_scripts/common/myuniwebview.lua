---@class MyUniWebView
MyUniWebView = class("MyUniWebView")

function MyUniWebView:Get()
    if self._instance == nil then
        self._instance = MyUniWebView()
    end
    return self._instance
end

function MyUniWebView:OpenUrlWithTransform(uri, referenceRectTransform)
    --CS.MyUniWebView:Get():OpenUrlWithTransform(uri, referenceRectTransform)
end

function MyUniWebView:load(uri)
    --CS.MyUniWebView:Get():load(uri)
end

function MyUniWebView:loadUrl(uri, x, y, width, height)
    --CS.MyUniWebView:Get():loadUrl(uri, x, y, width, height)
end

function MyUniWebView:closeWebView()
    --CS.MyUniWebView:Get():closeWebView()
end
