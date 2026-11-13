---@class FriendData
FriendData = class("FriendData")

function FriendData:initialize()

end
---@param msg SC_FriendInfo
function FriendData:SetFullData(msg)
    self. friendrid = msg.friendrid--好友rid
    self. headicon = tonumber(msg.headicon)--头像
    self. iconframe = tonumber(msg.iconframe)--边框
    self. rolename = msg.rolename--昵称
    self. curlevel = tonumber(msg.curlevel)--等级
    self. lastlogin = msg.lastlogin--最后登陆时间   0代表当前在线 时间戳代表最后登陆时间
    self. ifadd = msg.ifadd--0没有申请过 1已申请好友 2已经是好友
    self. score = msg.score--0没有申请过 1已申请好友 2已经是好友
end

----0没有申请过 1已申请好友 2已经是好友
---@return FriendAddType
function FriendData:GetIfAdd()
    return self.ifadd
end

function FriendData:GetBasePlayerData()
    return self.basePlayerData
end

function FriendData:GetPlayerId()
    return self.friendrid
end

function FriendData:GetPlayerLV()
    return self.curlevel
end

function FriendData:GetPlayerIcon()
    return self.headicon
end

function FriendData:GetPlayerIconFrame()
    return self.iconframe
end

function FriendData:GetPlayerName()
    return self.rolename
end

function FriendData:GetServerName()
    return "不分服"
end

function FriendData:GetLeaveTime()
    return self.lastlogin == 0 and -1 or self.lastlogin * 1000
end

function FriendData:GetRankScore()
    return self.score
end
