
¯
SelfRoom.protoUserCar.protoUserTrack.proto"¼
ReqCreateSelfRoom
rid (Rrid#
racer (2.SelfRaceInfoRracer
trackid (Rtrackid
groundid (Rgroundid
pwd (	Rpwd
roomname (	Rroomname
	tracktype (R	tracktype
serverid (Rserverid
seqno	 (Rseqno
	selftrack
 (R	selftrack

randomtype (R
randomtype"¥
ReqEnterSelfRoom
rid (Rrid
roomid (Rroomid
pwd (	Rpwd#
racer (2.SelfRaceInfoRracer
serverid (Rserverid
seqno (Rseqno"›
RetEnterSelfRoom
rid (Rrid
roomid (Rroomid
trackid (Rtrackid
groundid (Rgroundid
createid (Rcreateid#
racer (2.SelfRaceInfoRracer
enterRid (RenterRid
roomname (	Rroomname
seqno	 (Rseqno(
	selftrack
 (2
.UserTrackR	selftrack
pwd (	Rpwd
	tracktype (R	tracktype

randomtype (R
randomtype
s1 (Rs1
s2 (Rs2"U
ReqQuitSelfRoom
rid (Rrid
serverid (Rserverid
seqno (Rseqno"q
RetQuitSelfRoom
rid (Rrid
quitrid (Rquitrid
seqno (Rseqno
	errorcode (R	errorcode"X
ReqReleaseSelfRoom
rid (Rrid
serverid (Rserverid
seqno (Rseqno"<
RetReleaseSelfRoom
rid (Rrid
seqno (Rseqno"o
ReqKickSelfRoom
rid (Rrid
kickrid (Rkickrid
serverid (Rserverid
seqno (Rseqno"o
RetKickSelfRoom
rid (Rrid
kickrid (Rkickrid
serverid (Rserverid
seqno (Rseqno"V
ReqReadySelfRoom
rid (Rrid
serverid (Rserverid
seqno (Rseqno"V
RetReadySelfRoom
rid (Rrid
readyrid (Rreadyrid
seqno (Rseqno"°
SelfRaceInfo
rid (Rrid
rolename (	Rrolename
headicon (Rheadicon
	iconframe (R	iconframe
curlevel (Rcurlevel
car (2.UserCarRcar
position (Rposition
score (Rscore
ready	 (Rready
	titleback (R	titleback
titlecup (	Rtitlecup"Q
	SelfError
rid (Rrid
	errorcode (R	errorcode
seqno (Rseqno"R
ReqSelfStart
rid (Rrid
serverid (Rserverid
seqno (Rseqno"p
RetSelfStart
rid (Rrid
readyrid (Rreadyrid
seqno (Rseqno
	starttime (R	starttime"S
ReqSelfCancle
rid (Rrid
serverid (Rserverid
seqno (Rseqno"U
RetSelfCancle
rid (Rrid
	canclerid (R	canclerid
seqno (Rseqno"s
ReqSelfRoomList
rid (Rrid
serverid (Rserverid
seqno (Rseqno
	tracktype (R	tracktype"d
RetSelfRoomList
rid (Rrid)
roomlist (2.SelfRoomInfoRroomlist
seqno (Rseqno"×
SelfRoomInfo
roomid (Rroomid
trackid (Rtrackid
groundid (Rgroundid
pwd (	Rpwd
roomname (	Rroomname
	tracktype (R	tracktype
curnum (Rcurnum/
createracer	 (2.SelfRaceInfoRcreateracer(
	selftrack
 (2
.UserTrackR	selftrack

randomtype (R
randomtype
watchnum (Rwatchnum"…
ReqAlterCar
rid (Rrid
cardid (Rcardid
serverid (Rserverid
seqno (Rseqno
car (2.UserCarRcar"m
RetAlterCar
rid (Rrid
alterrid (Ralterrid
car (2.UserCarRcar
seqno (Rseqno"m
ReqAlterTrack
rid (Rrid
trackid (Rtrackid
serverid (Rserverid
seqno (Rseqno"Q
RetAlterTrack
rid (Rrid
trackid (Rtrackid
seqno (Rseqno"k
ReqSearchSelf
rid (Rrid
roomid (Rroomid
serverid (Rserverid
seqno (Rseqno"|
RetSearchSelf
rid (Rrid
trackid (Rtrackid)
selfroom (2.SelfRoomInfoRselfroom
seqno (Rseqno"S
ReqFinishSelf
rid (Rrid
serverid (Rserverid
seqno (Rseqno"7
RetFinishSelf
rid (Rrid
seqno (Rseqno"€
ReqWatchSelfRoom
rid (Rrid
roomid (Rroomid
pwd (	Rpwd
serverid (Rserverid
seqno (RseqnoB
MessagePackBSelfRoombufbproto3