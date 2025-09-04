-------------------------------------------------------------------
--File: playerprofile_c.lua
--Author: Brianyao
--Date: 2008-9-25 14:57
--Describe: 客户端玩家协议
-------------------------------------------------------------------
if not PProfile then --调试需要
  PProfile = {}
  print(GetLocalDate("%Y\\%m\\%d  %H:%M:%S") .. " build ok ..")
else
  if not MODULE_GAMECLIENT then
    return
  end
end

function PProfile:Require(szName)
  KPProfile.RequirePlayerProfile(szName)
end

function PProfile:ApplyEditStr(oper, szName)
  me.CallServerScript({ "ProCmd", "EditStr", oper, szName })
end

function PProfile:ApplyEditInt(oper, nParam)
  me.CallServerScript({ "ProCmd", "EditInt", oper, nParam })
end

function PProfile:EditAllInfo(nSex, nBirth, nReins, nOnline, nFriendOnly, szRealName, szAGName, szProfession, szCity, szTag, szFavorite, szBLOGURL, szComment)
  me.CallServerScript({
    "ProCmd",
    "EditAll",
    nSex,
    nBirth,
    nReins,
    nOnline,
    nFriendOnly,
    szRealName,
    szAGName,
    szProfession,
    szCity,
    szTag,
    szFavorite,
    szBLOGURL,
    szComment,
  })
end

function PProfile:EditAllInfo2(szRealName, nSex, nBirth, szCity, nReins, szQianming, nFriendOnly)
  me.CallServerScript({ "ProCmd", "EditAll2", szRealName, nSex, nBirth, szCity, nReins, szQianming, nFriendOnly })
end

--SNS信息异步请求任务存储
PProfile.tbSnsInfo = { ["nId"] = 1 }

--向GS请求指定玩家列表的SNS数据
function PProfile:RequireSnsInfo(tbPlayerName, fnCallback)
  local function GetNextRequestId(fnCallback)
    local nId = PProfile.tbSnsInfo.nId
    PProfile.tbSnsInfo[nId] = fnCallback
    PProfile.tbSnsInfo.nId = nId + 1
    return nId
  end
  local nId = GetNextRequestId(fnCallback)
  me.CallServerScript({ "ProCmd", "GetSnsInfo", nId, tbPlayerName })
end

--GS回调此函数来处理获取到的SNS数据
function PProfile:OnSnsInfoReceived(nRequestId, tbInfo)
  local fnCallback = self.tbSnsInfo[nRequestId]
  if fnCallback then
    self.tbSnsInfo[nRequestId] = nil
    fnCallback(tbInfo)
  end
end
