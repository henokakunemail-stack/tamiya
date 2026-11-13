
Ò
BattleRoom.protoUserTrack.protoConsume.protoUserCar.proto"Ÿ
ReqCreateBattle
rid (Rrid
awardid (	Rawardid
trackid (	Rtrackid
scenceid (	Rscenceid
rolename (	Rrolename
	guildname (	R	guildname
seqno (Rseqno
serverid (Rserverid

createtime	 (R
createtime

resulttime
 (R
resulttime
headicon (Rheadicon
	iconframe (R	iconframe"◊
	RetBattle
rid (Rrid%
battles (2.BattleInfoRbattles'
records (2.BattleRecordRrecords
fightnum (Rfightnum 
maxfightnum (Rmaxfightnum*
consumelist (2.ConsumeRconsumelist"S
ReqBattleList
rid (Rrid
seqno (Rseqno
serverid (Rserverid"~
RetBattleList
rid (Rrid%
battles (2.BattleInfoRbattles
seqno (Rseqno

createflag (R
createflag"É

BattleInfo
	createrid (R	createrid
rolename (	Rrolename
awardid (	Rawardid
scenceid (	Rscenceid
	guildname (	R	guildname

createtime (	R
createtime

resulttime (	R
resulttime
overtime (	Rovertime 
diamondpool	 (Rdiamondpool(
	trackinfo
 (2
.UserTrackR	trackinfo$
	rank3list (2.rank3R	rank3list/

firstracer (2.BattleRaceInfoR
firstracer
agree (Ragree
headicon (Rheadicon
	iconframe (R	iconframe
trackid (Rtrackid"ù
rank3
rid (Rrid
rolename (	Rrolename
headicon (	Rheadicon
	iconframe (	R	iconframe
rankid (	Rrankid
score (	Rscore"p
BattleRecord
battleid (Rbattleid
curnum (Rcurnum
maxnum (Rmaxnum
agree (Ragree"q
ReqSearchBattle
rid (Rrid
seqno (Rseqno
serverid (Rserverid
battleid (Rbattleid"â
RetSearchBattle
rid (Rrid
seqno (Rseqno%
battles (2.BattleInfoRbattles'
records (2.BattleRecordRrecords"q
ReqBattleDetail
rid (Rrid
seqno (Rseqno
serverid (Rserverid
battleid (Rbattleid"â
RetBattleDetail
rid (Rrid
seqno (Rseqno%
battles (2.BattleInfoRbattles'
records (2.BattleRecordRrecords"o
ReqBattleRank
rid (Rrid
seqno (Rseqno
serverid (Rserverid
battleid (Rbattleid"Å
RetBattleRank
rid (Rrid
rankid (Rrankid
score (Rscore
rankjson (	Rrankjson
seqno (Rseqno"p
ReqBattleAgree
rid (Rrid
seqno (Rseqno
serverid (Rserverid
battleid (Rbattleid">
RetBattleAgree
rid (Rrid
battleid (Rbattleid"â
ReqJoinBattle
rid (Rrid
seqno (Rseqno
serverid (Rserverid
battleid (Rbattleid
addCoin (RaddCoin"ê
RetJoinBattle
rid (Rrid*
consumelist (2.ConsumeRconsumelist'
records (2.BattleRecordRrecords
addcoin (Raddcoin"˝
RetBeginBattle
rid (Rrid
	starttime (R	starttime
curnum (Rcurnum
battleid (Rbattleid
scenceid (Rscenceid(
	trackinfo (2
.UserTrackR	trackinfo'
racers (2.BattleRaceInfoRracers
trackid (Rtrackid"o
RetFinishBattle
rid (Rrid
curnum (Rcurnum
maxnum (Rmaxnum
battleid (Rbattleid"Ü
BattleRaceInfo
rid (Rrid
rolename (	Rrolename
position (Rposition
car (2.UserCarRcar
headicon (Rheadicon
	iconframe (R	iconframe
	titleback (R	titleback
titlecup (	Rtitlecup
curlevel	 (Rcurlevel"S
BattleError
rid (Rrid
	errorcode (R	errorcode
seqno (Rseqno"R
RetBattleRecord%
start (2.RetBeginBattleRstart
lookrid (RlookridB
MessagePackBBattleRoombufbproto3