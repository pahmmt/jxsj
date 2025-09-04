-- 文件名　：keju_huache.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-11-21 09:49:22
-- 功能说明：花车

SpecialEvent.JxsjKeju = SpecialEvent.JxsjKeju or {}
local JxsjKeju = SpecialEvent.JxsjKeju

function JxsjKeju:StartWelFare(szPlayerName)
  if IsMapLoaded(self.nHuaCheMapId) == 1 then
    if szPlayerName then
      local pNpc = KNpc.Add2(self.nHuaCheTemplateId, 50, -1, self.nHuaCheMapId, self.tbStartPos[1], self.tbStartPos[2])
      if pNpc then
        pNpc.SetTitle("状元游行")
        pNpc.szName = szPlayerName
        self:SetNpcBeginWelFare(pNpc.dwId)
      end
    end
  end
end

function JxsjKeju:Announce(szMsg)
  if not szMsg or #szMsg <= 0 then
    return 0
  end
  KDialog.NewsMsg(0, Env.NEWSMSG_NORMAL, szMsg)
  KDialog.Msg2SubWorld(szMsg)
end

function JxsjKeju:SetNpcBeginWelFare(nId)
  local pNpc = KNpc.GetById(nId)
  if not pNpc then
    return 0
  end
  pNpc.AI_ClearPath()
  for i = 1, #self.tbWelFareAiPosInfo do
    pNpc.AI_AddMovePos(self.tbWelFareAiPosInfo[i][1] * 32, self.tbWelFareAiPosInfo[i][2] * 32)
  end
  pNpc.SetActiveForever(1)
  pNpc.SetNpcAI(9, 0, 0, 0, 0, 0, 0, 0)
  pNpc.GetTempTable("Npc").tbOnArrive = { self.OnWelFareNpcArrive, self, pNpc.dwId }
  pNpc.GetTempTable("Npc").nGiveExpTimer = Timer:Register(self.nGetExpTime, self.OnGiveExp, self, pNpc.dwId)
  pNpc.GetTempTable("Npc").nGiveBoxTimer = Timer:Register(self.nGetAwardTime, self.OnGiveBox, self, pNpc.dwId)
  pNpc.GetTempTable("Npc").nWelFareExistTimer = Timer:Register(self.nAllTime, self.OnWelFareEnd, self, pNpc.dwId)
end

function JxsjKeju:OnWelFareNpcArrive(nId)
  local pNpc = KNpc.GetById(nId)
  if not pNpc then
    return 0
  end
  local tbAiPos = self.tbWelFareAiPosInfo[pNpc.nMapId]
  if not tbAiPos then
    return 0
  end
  pNpc.AI_ClearPath()
  pNpc.AI_AddMovePos(unpack(self.tbStartPos))
  for i = 1, #tbAiPos do
    pNpc.AI_AddMovePos(tbAiPos[i][1], tbAiPos[i][2])
  end
  pNpc.SetActiveForever(1)
  pNpc.SetNpcAI(9, 0, 0, 0, 0, 0, 0, 0)
end

--给经验
function JxsjKeju:OnGiveExp(nId)
  local pNpc = KNpc.GetById(nId)
  if not pNpc then
    return 0
  end
  local tbPlayer, nCount = KNpc.GetAroundPlayerList(nId, self.nWelFareGetPrizeRange)
  if nCount > 0 then
    for _, pPlayer in pairs(tbPlayer) do
      local nAddExp = pPlayer.GetBaseAwardExp() * self.nWelFareGiveExpRate
      local nAddExpPer = nAddExp / self.nWelFareGiveExpCount
      pPlayer.AddExp(nAddExpPer)
    end
  end
  return
end

--给箱子
function JxsjKeju:OnGiveBox(nId)
  local pNpc = KNpc.GetById(nId)
  if not pNpc then
    return 0
  end
  local nNum = 0
  local tbGetBoxList, nCount = KNpc.GetAroundPlayerList(nId, self.nWelFareGetPrizeRange)
  if #tbGetBoxList > 0 then
    for _, pPlayer in pairs(tbGetBoxList) do
      if pPlayer then
        local nDay = TimeFrame:GetServerOpenDay()
        local tbAward = Lib._CalcAward:RandomAward(3, 3, 2, 5000, Lib:_GetXuanReduce(nDay), { 0, 10, 0 })
        local nMaxMoney = Lib._CalcAward:GetMaxMoney(tbAward)
        if me.GetBindMoney() + nMaxMoney <= pPlayer.GetMaxCarryMoney() then
          local nRet, szAward = Lib._CalcAward:RandomItem(pPlayer, tbAward)
          if pItem then
            local szMsg = string.format("恭喜你获得了" .. szAward .. "。")
            Dialog:SendBlackBoardMsg(pPlayer, szMsg)
          end
          nNum = nNum + 1
          if nNum >= 10 then
            break
          end
        end
      end
    end
  end
  local _, x, y = pNpc.GetWorldPos()
  pNpc.CastSkill(self.nWelSkillId, 1, x * 32, y * 32, 1) --放一个特效
  return
end

--派利结束
function JxsjKeju:OnWelFareEnd(nId)
  local pNpc = KNpc.GetById(nId)
  if pNpc then
    pNpc.Delete()
  end
  return 0
end
