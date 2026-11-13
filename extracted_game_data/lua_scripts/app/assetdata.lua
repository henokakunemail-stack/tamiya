
AssetDataSaveType={
    Normal="1",
    Error="-1"
}

---@class AssetData @资源信息 资源名+相对路径，MD5 size 和version
AssetData = class("AssetData")

function AssetData:initialize()
    self.FileName = "" -- 资源名+相对路径
    --self.Path = ""
    self.MD5 = -1
    self.Size = -1
    self.SaveType=-1
    self.Version = ""--资源所属patch版本，格式 "X_X_X"
    self.BeginTime=0
end