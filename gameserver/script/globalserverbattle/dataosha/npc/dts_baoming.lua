-- 文件名　：dts_baoming.lua
-- 创建者　：jiazhenwei
-- 创建时间：2009-10-13
-- 描  述  ：英雄岛报名官

local tbNpc = Npc:GetClass("dataosha_baoming")

function tbNpc:OnDialog()
  local nFlag = 0
  local nTime = tonumber(GetLocalDate("%H%M"))
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  local nWeek = tonumber(GetLocalDate("%w"))
  if nDate >= DaTaoSha.nStatTime and nDate <= DaTaoSha.nEndTime then
    if (nTime >= DaTaoSha.OPENTIME[1] and nTime <= DaTaoSha.CLOSETIME[1]) or (nTime >= DaTaoSha.OPENTIME[2] and nTime <= DaTaoSha.CLOSETIME[2] and nWeek ~= 6) then
      nFlag = 1
    end
  end
  if nFlag == 0 then
    Dialog:Say(string.format("现在还未到活动开启时间，请在正确的时间来找我吧。\n\n活动开启时间:\n<color=yellow>%s--%s\n早11点--下午2点\n晚6点--晚9点<color>\n<color=red>注：周六晚有铁浮城战故不开放<color>", os.date("%Y年%m月%d日", Lib:GetDate2Time(DaTaoSha.nStatTime)), os.date("%Y年%m月%d日", Lib:GetDate2Time(DaTaoSha.nEndTime))), { "知道了" })
    return
  end

  local nLevel = DaTaoSha.MACTH_PRIM
  local tbOpt = {
    { "单人报名参赛", DaTaoSha.tbNpc.JoinOne, DaTaoSha.tbNpc, DaTaoSha.MACTH_PRIM },
    { "组队报名参赛", DaTaoSha.tbNpc.JoinTeam, DaTaoSha.tbNpc, DaTaoSha.MACTH_PRIM },
    --{"请送我去高级场", DaTaoSha.tbNpc.Join, DaTaoSha.tbNpc, DaTaoSha.MACTH_ADV},
    --{"参加大逃杀", DaTaoSha.tbNpc.Join, DaTaoSha.tbNpc, nLevel},
    { "不了" },
  }
  Dialog:Say("寒风长漠漠，武侯征四方。雪魂释离殇，傲雪独飞扬。在这漫天冰雪中，谁能体会当年的战火无情？", tbOpt)
end
