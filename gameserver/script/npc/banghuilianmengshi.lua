-------------------------------------------------------------------
--File: banghuiLianmengshi.lua
--Author: fenghewen
--Date: 2009-6-17 15:56
--Describe: 帮会联盟使
-------------------------------------------------------------------
--	帮会联盟使;
local tbBangHuiLianMengShi = Npc:GetClass("banghuilianmengshi")

function tbBangHuiLianMengShi:OnDialog()
  local szSay = "你的帮会要进行联盟相关操作的话，可以到我这里申请。"
  if me.dwUnionId and me.dwUnionId ~= 0 then
    local pUnion = KUnion.GetUnion(me.dwUnionId)
    if pUnion then
      szSay = "你的帮会已加入了<color=green>" .. pUnion.GetName() .. "<color>联盟\n联盟成员包括：<color=green>"
      local pTongItor = pUnion.GetTongItor()
      local nTongId = pTongItor.GetCurTongId()
      while nTongId ~= 0 do
        local pTong = KTong.GetTong(nTongId)
        if pTong then
          szSay = szSay .. pTong.GetName() .. " "
        end
        nTongId = pTongItor.NextTongId()
      end

      local nMasterTongId = pUnion.GetUnionMaster()
      local pMasterTong = KTong.GetTong(nMasterTongId)
      if not pMasterTong then
        local szMsg = string.format("[%s] 联盟没盟主帮会", pUnion.GetName())
        Dbg:WriteLog("Union", "联盟没盟主帮会", szMsg)
        return 0
      end
      local nMasterId = Tong:GetMasterId(nMasterTongId)
      local szMasterName = KGCPlayer.GetPlayerName(nMasterId)

      szSay = szSay .. "<color>\n盟主为：<color=green>" .. pMasterTong.GetName() .. "<color>的帮主<color=green>" .. szMasterName .. "<color>"
    end
  end
  Dialog:Say(szSay, {
    { "联盟创建", Union.DlgCreateUnion, Union },
    { "加入联盟", Union.DlgTongJoin, Union },
    { "退出联盟", Union.DlgTongLeave, Union },
    { "移交盟主", Union.DlgChangeUnionMaster, Union },
    { "分配领土", Union.DlgDispenseDomain, Union },
    { "关闭" },
  })
end
