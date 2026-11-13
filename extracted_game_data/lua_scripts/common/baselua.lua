


class = require ("common/middleclass")
util = require ("common/xluautil")
cs_coroutine = require ("common/cs_coroutine")
require ("common/luarelevance")
require ("app/app")
require ("json/json_require")
require ("common/try_catch_finally")
require ("common/lua_vector3")
require ("common/lua_colorrgba")
Dll_PB = require "pb"
ProtoMsgHelp = require "proto/serpent"
--assert(Dll_PB.load(CS.MonoHelper.LoadProtoPB("proto/pb/Version")) ,"找不到Version.pb")--热更协议