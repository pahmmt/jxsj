-------------------------------------------------------
-- 文件名　：newland_item_pad.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-10-12 18:32:16
-- 文件描述：
-------------------------------------------------------

Require("\\script\\globalserverbattle\\newland\\newland_def.lua")

local tbItem = Newland.Item or {}
Newland.Item = tbItem

tbItem.nTaskGID = 1025
tbItem.tbInfo = {
  [1] = { 18, 870, "铁浮勇士·群雄逐日", "255,181,0", "勇士", 1629 },
  [2] = { 17, 869, "铁浮城主·傲世凌天", "255,255,0", "城主", 2000 },
}

function tbItem:CalcBufferTime()
  local nDay = tonumber(os.date("%w", GetTime()))
  local nLeft = 6 - nDay
  if nLeft <= 0 then
    nLeft = 7
  end
  local nTime = (nLeft + 1) * 24 * 3600
  return nTime + Lib:GetDate2Time(GetLocalDate("%Y%m%d")) - GetTime()
end

local tbLing = Item:GetClass("newland_pad")

function tbLing:OnUse()
  for nLevel, tbInfo in ipairs(Newland.Item.tbInfo) do
    if me.GetTask(Newland.Item.nTaskGID, tbInfo[1]) == 1 and it.nParticular == tbInfo[2] then
      local nRemainTime = Newland.Item:CalcBufferTime() * Env.GAME_FPS
      me.AddSkillState(tbInfo[6], nLevel, 2, nRemainTime, 1, 0, 1)
      me.RemoveSpeTitle(tbInfo[3])
      me.AddSpeTitle(tbInfo[3], GetTime() + Newland.Item:CalcBufferTime(), tbInfo[4])
      me.Msg(string.format("恭喜您获得使用铁浮城%s披风的资格！", tbInfo[5]))
      return 1
    end
  end

  local szMsg = string.format("您可以带着这个<color=yellow>%s<color>到各大城市找铁浮城佑鲁使者<color=yellow>修木泽<color>处领取一个任务。", it.szName)
  Dialog:Say(szMsg, { "我知道了" })

  return 0
end

function tbLing:InitGenInfo()
  it.SetTimeOut(0, GetTime() + Newland.Item:CalcBufferTime())
  return {}
end

local tbBindLing = Item:GetClass("newland_pad_bind")

function tbBindLing:OnUse()
  local nRemainTime = Newland.Item:CalcBufferTime() * Env.GAME_FPS
  local nLevel = 3 - it.nLevel
  me.AddSkillState(Newland.Item.tbInfo[nLevel][6], nLevel, 2, nRemainTime, 1, 0, 1)
  me.RemoveSpeTitle(Newland.Item.tbInfo[nLevel][3])
  me.AddSpeTitle(Newland.Item.tbInfo[nLevel][3], GetTime() + Newland.Item:CalcBufferTime(), Newland.Item.tbInfo[nLevel][4])
  me.Msg(string.format("恭喜您获得使用铁浮城%s披风的资格！", Newland.Item.tbInfo[nLevel][5]))
  return 1
end

function tbBindLing:InitGenInfo()
  it.SetTimeOut(0, GetTime() + Newland.Item:CalcBufferTime())
  return {}
end
