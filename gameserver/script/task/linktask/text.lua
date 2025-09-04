-- ====================== 文件信息 ======================

-- 剑侠世界门派任务链对话文件
-- Edited by peres
-- 2007/12/18 PM 03:05

-- 她是透彻的。
-- 只是一个容易感觉孤独的人，会想用某些幻觉来麻醉自己。
-- 一个手里紧抓着空洞的女子，最后总是会让自己失望。

-- ======================================================

LinkTask.Text = {}

LinkTask.Text[10000] = {}
LinkTask.Text[20000] = {}
LinkTask.Text[30000] = {}

LinkTask.Text[10000] = {
  [1] = "据悉，丐帮影社的高手近日在金国境内死伤惨重。白首领与丐帮石轩辕帮主素有深交，她已组织一只由高手组成的决死队，预备赶赴中原营救影社残余高手。现下仍缺少<Item>，你能否替我弄些来？",
  [2] = "白首领认为，鞑靼人有灭掉西夏与金国的打算。若他们真有如此图谋，则我宋朝危矣。现下我们对鞑靼人的了解极为稀少，当早做准备。所以你去弄<Item>来，据说那些东西都出自蒙古部落巧匠之手。",
  [3] = "昨日得到消息，义军任笑天所部的一只偏师奇袭了徐州。徐州沃野千里，乃古来兵家必争之地。若他们能守到秋后，来年的粮草就有着落了。不过任笑天部现下急缺<Item>，你能否替我弄来？",
}

LinkTask.Text[20000] = {
  [1] = "你去<MapName>处给我杀死<NpcDesc>吧。",
}

LinkTask.Text[30000] = {
  [1] = "据悉，丐帮影社的高手近日在金国境内死伤惨重。白首领与丐帮石轩辕帮主素有深交，她已组织一只由高手组成的决死队，预备赶赴中原营救影社残余高手。现下仍缺少<Item>，你能否替我弄些来？",
  [2] = "白首领认为，鞑靼人有灭掉西夏与金国的打算。若他们真有如此图谋，则我宋朝危矣。现下我们对鞑靼人的了解极为稀少，当早做准备。所以你去弄<Item>来，据说那些东西都出自蒙古部落巧匠之手。",
  [3] = "昨日得到消息，义军任笑天所部的一只偏师奇袭了徐州。徐州沃野千里，乃古来兵家必争之地。若他们能守到秋后，来年的粮草就有着落了。不过任笑天部现下急缺<Item>，你能否替我弄来？",
}

-- 在选择任务时就调用
-- 根据传进来的任务类型和任务参数来获取一段任务的描述，并且记录到任务变量中
function LinkTask:SetTaskText(pPlayer, nType)
  if not LinkTask.Text[nType] then
    self:_Debug("Get Task Text, Error Type: " .. nType)
    return
  end
  local nRandom = MathRandom(1, #LinkTask.Text[nType])
  pPlayer.SetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_TASKTEXT, nRandom)
  return nRandom
end

-- 根据任务类型和任务Id来获取一段文字
function LinkTask:GetTaskText(nType, nSubTaskId)
  local szMainText = ""
  local nTextId = self:GetTask(self.TSK_TASKTEXT)

  if nTextId <= 0 then
    self:_Debug("Error: Get Empty Text Id!")
    return
  end

  self:_Debug("Start get task text.")
  local szOrgText = LinkTask.Text[nType][nTextId]

  local tbTaget = Task.tbSubDatas[nSubTaskId].tbSteps[1].tbTargets[1]
  local szTargetName = tbTaget.szTargetName -- 得到这个目标的名字

  self:_Debug("Get task taget: " .. szTargetName)
  if szTargetName == "SearchItemWithDesc" then
    local szItemName = tbTaget.szItemName
    local nItemNum = tbTaget.nNeedCount
    szMainText = string.gsub(szOrgText, "<Item>", "<color=green>" .. nItemNum .. "个" .. szItemName .. "<color>")
    szMainText = szMainText .. "\n<color=yellow>此类物品可以由生活技能产出。<color>"
  elseif szTargetName == "SearchItemBySuffix" then
    local szItemName = tbTaget.szItemName
    local szSuffix = tbTaget.szSuffix

    local nItemNum = tbTaget.nNeedCount
    szMainText = string.gsub(szOrgText, "<Item>", "<color=green>" .. nItemNum .. "件" .. szItemName .. "·" .. szSuffix .. "<color>")
    szMainText = szMainText .. "\n<color=yellow>此类物品可以由生活技能产出。<color>"
  elseif szTargetName == "KillNpc" then
    local szNpcName = KNpc.GetNameByTemplateId(tbTaget.nNpcTempId)
    local szMapName = Task:GetMapName(tbTaget.nMapId)
    local nCount = tbTaget.nNeedCount
    local szNpcDesc = nCount .. "个" .. szNpcName

    szMainText = string.gsub(szOrgText, "<MapName>", "<color=green>" .. szMapName .. "<color>")
    szMainText = string.gsub(szMainText, "<NpcDesc>", "<color=green>" .. szNpcDesc .. "<color>")
  end

  return szMainText
end
