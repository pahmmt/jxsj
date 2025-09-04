-- 文件名　：hongniang.lua
-- 创建者　：furuilei
-- 创建时间：2009-11-26 10:19:50
-- 描述	   : 结婚相关npc（红娘）

local tbNpc = Npc:GetClass("marry_hongniang")

function tbNpc:OnDialog()
  if Marry:CheckState() == 0 then
    return 0
  end
  local szMsg = "    金镶玉凤求凰，人间最难配成双。举目瞧那太阳月亮又一双，又一双。"
  local tbOpt = {
    { "【了解侠侣闯天下】", self.Introduce, self },
    { "【结束对话】" },
  }
  if EventManager.IVER_bOpenDivorce == 1 then
    table.insert(tbOpt, 2, { "【私自解除侠侣关系】", Marry.DialogNpc.OnSingleDivorce, Marry.DialogNpc })
    table.insert(tbOpt, 2, { "【双方解除侠侣关系】", Marry.DialogNpc.OnDivorce, Marry.DialogNpc })
    table.insert(tbOpt, 2, { "【私自解除纳吉关系】", Marry.DialogNpc.OnSingleRemoveQiuhun, Marry.DialogNpc })
    table.insert(tbOpt, 2, { "【双方解除纳吉关系】", Marry.DialogNpc.OnRemoveQiuhun, Marry.DialogNpc })
  end
  -- 周年庆活动
  local tbGift = SpecialEvent.ZhouNianQing2011:BuildHongNiangZhouNianQingOption()
  if tbGift then
    table.insert(tbOpt, #tbOpt, tbGift)
  end
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:Introduce()
  local tbNpc = Npc:GetClass("marry_dlgjiaoyunpc")
  tbNpc:OnDialog()
end
