-------------------------------------------------------------------
--File		: baihutang_gc.lua
--Author	: ZouYing
--Date		: 2008-1-8 14:13
--Describe	: 白虎堂开始报名，开始PK和结束PK的触发
-------------------------------------------------------------------

if not MODULE_GC_SERVER then
  return
end

BaiHuTang.bOpenWritePlayerInfo = 1 --白虎参加角色收集写入数据库名单
BaiHuTang.nCheckPlayerTimeLimit = 3 * 30 * 24 * 3600 --收集参加名单时间限制
BaiHuTang.nTimeJianju = 15 * 60 * Env.GAME_FPS

function BaiHuTang:ApplyStart()
  GlobalExcute({ "BaiHuTang:ApplyStart_GS" })
end

function BaiHuTang:PKStop()
  GlobalExcute({ "BaiHuTang:PKStop_GS" })
end

function BaiHuTang:PKStart(nTaskId)
  local nServerStart = KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)
  if self.bOpenWritePlayerInfo == 1 and (GetTime() - nServerStart) <= self.nCheckPlayerTimeLimit then
    GlobalExcute({ "BaiHuTang:WritePlayerInfo__GS" })
    Timer:Register(self.nTimeJianju, self.__QueryGlobalSta, self, nTaskId)
  end

  GlobalExcute({ "BaiHuTang:PKStart_GS", nTaskId })
end

function BaiHuTang:__QueryGlobalSta(nTaskId)
  if nTaskId == 1 then
    Globalstat:Remove(0, "BaiHuTangCheck", "PlayGame", "", "")
  end
  Globalstat:Query(1, "BaiHuTangCheck", "ArrestPlayer")
  return 0
end

function BaiHuTang:NextPvpStart()
  GlobalExcute({ "BaiHuTang:NextPvpStart_GS" })
end

function BaiHuTang:ApplyGB_GCState(nLevel) --向大区gc申请跨服白虎状态,黄金白虎堂boss死亡后调用
  GlobalGCExcute(-1, { "KuaFuBaiHu:SendGB_GCState", nLevel })
end

function BaiHuTang:ReceiveGB_GCState(nState, nLevel) --接受大区gc的状态数据
  GlobalExcute({ "BaiHuTang:OpenGBTransferDoor", nState, nLevel }) --广播给每个gs
end

function BaiHuTang:WritePlayerInfo__GC(szAccount, szPlayerName, szIp)
  Globalstat:Collect("BaiHuTangCheck", "PlayGame", szAccount, szPlayerName, { szIp })
end

function BaiHuTang:__ArrestPlayer(tbDate)
  local nNowDate = tonumber(GetLocalDate("%Y%m%d%H"))
  for i, tb in ipairs(tbDate) do
    if tb.szGateway == GetGatewayName() and tb.szData and tb.szData[1] and tb.szData[2] and tonumber(tb.szData[2]) == nNowDate then
      GM:AddOnLine("", "", tb.szRole, 0, 0, string.format([[Player:Arrest("%s", %s)]], tb.szRole, tonumber(tb.szData[1])))
    end
  end
end

Globalstat:RegisterGlobalStatEventCallBack("BaiHuTangCheck", "ArrestPlayer", BaiHuTang.__ArrestPlayer, BaiHuTang)

----测试指令------------
function BaiHuTang:ApplyStart_GB()
  GlobalGCExcute(-1, { "KuaFuBaiHu:ApplyStart" })
end

function BaiHuTang:ClearState_GB()
  GlobalGCExcute(-1, { "KuaFuBaiHu:ClearAllState" })
end
