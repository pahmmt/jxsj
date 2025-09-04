-------------------------------------------------------
-- 文件名　：newland_npc_task.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-10-07 17:22:06
-- 文件描述：
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\globalserverbattle\\newland\\newland_def.lua")

local tbNpc = Npc:GetClass("newland_npc_task")

tbNpc.TASK_GID = 1025 -- 令牌任务组ID
tbNpc.TASK_CHENGZHU_SHOP = 17 -- 开启城主商店
tbNpc.TASK_SHIWEI_SHOP = 18 -- 开启侍卫商店
tbNpc.TASK_IS_FINSH = 19 -- 城主交和氏璧的数目是否够200(0 or 1)
tbNpc.TASK_GID_CCHENGZHU = 2125 -- 城主令牌任务交和氏璧任务组
tbNpc.TASK_ALREADY_NUM = 21 -- 城主交和氏璧的数目
tbNpc.NeedNum = 10 -- 需要的和氏璧数目
tbNpc.szItemGDPL = "18,1,377,1" -- 和氏璧GDPL
tbNpc.nTaskID = 471 -- 城主任务ID
tbNpc.tbShop = { 173, 174 } -- 侍卫马店173，城主马店174

function tbNpc:OnDialog()
  local szMsg = "亦狂亦侠真名士，能哭能歌迈俗流！\n\n"
  local tbOpt = { { "我知道了" } }

  if me.GetTask(self.TASK_GID, self.TASK_SHIWEI_SHOP) == 1 then
    table.insert(tbOpt, 1, { "我要购买勇士披风", self.GetPiFengAward, self, 2 })
  end
  if me.GetTask(self.TASK_GID, self.TASK_CHENGZHU_SHOP) == 1 then
    table.insert(tbOpt, 1, { "我要购买城主披风", self.GetPiFengAward, self, 1 })
  end

  if me.GetTask(self.TASK_GID, self.TASK_SHIWEI_SHOP) == 1 and me.GetTask(self.TASK_GID, self.TASK_CHENGZHU_SHOP) == 1 then
    szMsg = szMsg .. "您在我这里可以购买<color=yellow>城主及勇士<color>披风。"
  elseif me.GetTask(self.TASK_GID, self.TASK_SHIWEI_SHOP) == 1 then
    szMsg = szMsg .. "您已经获得购买<color=yellow>勇士<color>披风的资格。"
  elseif me.GetTask(self.TASK_GID, self.TASK_CHENGZHU_SHOP) == 1 then
    szMsg = szMsg .. "您已经获得购买<color=yellow>城主<color>披风的资格。"
  end

  local nLevel, nState, nTime = me.GetSkillState(1629)
  if nLevel == 1 and nTime > 0 then
    szMsg = szMsg .. "您已经获得购买<color=yellow>逐日<color>神驹的资格。"
    table.insert(tbOpt, 1, { "我要购买逐日神驹", self.OpenHorseShop, self, 1 })
  end

  local nLevel2, nState2, nTime2 = me.GetSkillState(2000)
  if nLevel2 == 2 and nTime2 > 0 then
    szMsg = szMsg .. "您已经获得购买<color=yellow>凌天<color>神驹的资格。"
    table.insert(tbOpt, 1, { "我要购买凌天神驹", self.OpenHorseShop, self, 2 })
  end

  if Task:GetPlayerTask(me).tbTasks[self.nTaskID] and Task:GetPlayerTask(me).tbTasks[self.nTaskID].nCurStep == 5 then
    szMsg = szMsg .. "这里可以上交和氏璧，完成<color=yellow>凯旋铁浮城<color>任务。"
    table.insert(tbOpt, 1, { "<color=yellow>上交和氏璧<color>", self.HandInHeshibi, self })
  end

  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:OpenHorseShop(nLevel)
  me.OpenShop(self.tbShop[nLevel], 3)
end

function tbNpc:GetPiFengAward(nId)
  if me.GetTask(self.TASK_GID, self.TASK_CHENGZHU_SHOP) == 1 and nId == 1 then
    me.OpenShop(172, 3)
  end
  if me.GetTask(self.TASK_GID, self.TASK_SHIWEI_SHOP) == 1 and nId == 2 then
    me.OpenShop(171, 3)
  end
end

function tbNpc:HandInHeshibi()
  if not Task:GetPlayerTask(me).tbTasks[self.nTaskID] and Task:GetPlayerTask(me).tbTasks[self.nTaskID].nCurStep == 5 then
    Dialog:Say("您没有<color=yellow>凯旋铁浮城<color>这个任务是不能上交和氏璧的！", { "知道了" })
    return 0
  end
  if me.GetTask(self.TASK_GID_CCHENGZHU, self.TASK_ALREADY_NUM) >= self.NeedNum then
    Dialog:Say("您上交的和氏璧已经够了！", { "知道了" })
    return 0
  end
  local nCount = me.GetTask(self.TASK_GID_CCHENGZHU, self.TASK_ALREADY_NUM)
  local szContent = string.format("请放入要上交的和氏璧\n您已经上交了%s个和氏璧了，还需要上交%s个。", nCount, self.NeedNum - nCount)
  Dialog:OpenGift(szContent, nil, { self.OnOpenGiftOk, self })
end

function tbNpc:OnOpenGiftOk(tbItemObj)
  local nAlreadyCount = me.GetTask(self.TASK_GID_CCHENGZHU, self.TASK_ALREADY_NUM)
  local nNeedCount = self.NeedNum - nAlreadyCount
  for _, tbItem in pairs(tbItemObj) do
    local szItemInfo = string.format("%s,%s,%s,%s", tbItem[1].nGenre, tbItem[1].nDetail, tbItem[1].nParticular, tbItem[1].nLevel)
    if szItemInfo ~= self.szItemGDPL then
      Dialog:Say("您放的物品不对!", { "知道了" })
      return 0
    end
  end
  local nCount = 0
  for _, tbItem in pairs(tbItemObj) do
    nCount = nCount + tbItem[1].nCount
  end
  if nNeedCount < nCount then
    Dialog:Say("您交的和氏璧太多了！", { "知道了" })
    return 0
  end
  for _, tbItem in pairs(tbItemObj) do
    tbItem[1].Delete(me)
  end
  me.SetTask(self.TASK_GID_CCHENGZHU, self.TASK_ALREADY_NUM, me.GetTask(self.TASK_GID_CCHENGZHU, self.TASK_ALREADY_NUM) + nCount)
  if me.GetTask(self.TASK_GID_CCHENGZHU, self.TASK_ALREADY_NUM) >= self.NeedNum then
    me.SetTask(self.TASK_GID, self.TASK_IS_FINSH, 1)
  end
  EventManager:WriteLog(string.format("[铁浮城城主令牌任务]上交和氏璧%s", nCount), me)
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("[铁浮城城主令牌任务]上交和氏璧%s", nCount))
end
