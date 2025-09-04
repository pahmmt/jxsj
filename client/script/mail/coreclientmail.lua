-- 文件名　：coreclientmail.lua
-- 创建者　：furuilei
-- 创建时间：2009-04-07 10:03:09

------------------------------------------------------
-- 信件内容格式说明
-- nStartSendTime: 邮件的开始发送时间														(必填)
-- szCaption: 邮件标题																		(必填)
-- szContent: 邮件内容																		(必填)
------------------------------------------------------

Mail.MAX_MAIL_COUNT = 20 -- 最多20封客户端系统邮件
Mail.MAIL_EXIST_TIME = 30 * 24 * 3600 -- 每封邮件从发送出去到自动删除的存在期限是1个月
Mail.DONOT_SEND_TIME = 60 * 24 * 3600 -- 每封邮件从建立的时刻起2个月之后无论情况如何，不需要发送了
Mail.TASK_GROUP_MAIL_TIME = 2087 -- 邮件的接收时间
Mail.TASK_GROUP_MAIL_STAT = 2088 -- 邮件的状态标记(0.未读 1.已读 2.删除)
Mail.TASK_GROUP_MAIL_INDEX = 2089 -- 邮件对应的序列号

Mail.IdMap = {} -- 用来标记某一个邮件是否被加载了
Mail.nCoverIndex = 0 -- 如果超过最大邮件数量的时候可以覆盖的邮件Index
Mail.nMaxMailIndex = 0 -- 记录当前时刻已经发送了的最大的邮件的ID

Mail.tbMailList = {
  ------------------------------------------------------
  -- 	一个演示示例如下：
  --	[1] =
  --	{
  --		nStartSendTime = 20090408; -- 邮件开始发送时间
  -- 		nExistTime = 60;			-- (可选)该邮件的有效期，超过该有效期不再发送，单位：天
  --		szCaption = "邮件示例";
  --		szContent = "邮件内容示例";
  --	},
  ------------------------------------------------------
  -- Attention: 如果要添加客户端系统邮件，邮件内容在这里添加！！！
}

-- 设置邮件状态
function Mail:SetTaskDoubleBit(nIndex, nState)
  if nIndex and nIndex >= 1 and nIndex <= self.MAX_MAIL_COUNT then
    if nState == 2 then
      me.SetTaskBit(self.TASK_GROUP_MAIL_STAT, 2 * nIndex - 1, 1)
      me.SetTaskBit(self.TASK_GROUP_MAIL_STAT, 2 * nIndex, 0)
    elseif nState == 1 then
      me.SetTaskBit(self.TASK_GROUP_MAIL_STAT, 2 * nIndex - 1, 0)
      me.SetTaskBit(self.TASK_GROUP_MAIL_STAT, 2 * nIndex, 1)
    elseif nState == 0 then
      me.SetTaskBit(self.TASK_GROUP_MAIL_STAT, 2 * nIndex - 1, 0)
      me.SetTaskBit(self.TASK_GROUP_MAIL_STAT, 2 * nIndex, 0)
    end
  end
end

-- 获取邮件状态
function Mail:GetTaskDoubleBit(nIndex)
  local nTemp1 = me.GetTaskBit(self.TASK_GROUP_MAIL_STAT, 2 * nIndex - 1)
  local nTemp2 = me.GetTaskBit(self.TASK_GROUP_MAIL_STAT, 2 * nIndex)
  if nTemp1 == 1 and nTemp2 == 0 then
    return 2
  elseif nTemp1 == 0 and nTemp2 == 1 then
    return 1
  elseif nTemp1 == 0 and nTemp2 == 0 then
    return 0
  end
end

function Mail:FindNextCoverIndex()
  local nId = me.GetTask(self.TASK_GROUP_MAIL_INDEX, 1)
  for i = 1, self.MAX_MAIL_COUNT do
    local nIndex = me.GetTask(self.TASK_GROUP_MAIL_INDEX, i)
    if nIndex <= nId then
      nId = nIndex
      self.nCoverIndex = i
    end
  end
end

-- 计算有效TaskId的数目
function Mail:CountAvailableTaskId()
  local nSum = 0
  for i = 1, self.MAX_MAIL_COUNT do
    if 0 ~= me.GetTask(self.TASK_GROUP_MAIL_INDEX, i) then
      nSum = nSum + 1
    end
  end
  return nSum
end

-- 如果没有对应的任务变量表示邮件的话，为该邮件分配任务变量
-- 返回对应邮件的发送时间和状态
function Mail:CreateNewMail(nIndex)
  if nIndex < 1 or not self.tbMailList[nIndex] then
    return
  end
  -- 是否需要为该邮件设置一组新的任务变量
  if self.tbMailList[nIndex] then
    local tbMail = self.tbMailList[nIndex]
    local nExistTime = self.DONOT_SEND_TIME
    if tbMail.nExistTime then
      nExistTime = tbMail.nExistTime * 24 * 3600
    end
    if Lib:GetDate2Time(tbMail.nStartSendTime) > GetTime() then
      return
    end
    if GetTime() - Lib:GetDate2Time(tbMail.nStartSendTime) < nExistTime and self.nMaxMailIndex < nIndex and (not self.IdMap[nIndex] or (self.IdMap[nIndex] and 1 ~= self.IdMap[nIndex])) then
      for i = 1, self.MAX_MAIL_COUNT do
        if 0 == me.GetTask(self.TASK_GROUP_MAIL_INDEX, i) then
          me.SetTask(self.TASK_GROUP_MAIL_INDEX, i, nIndex)
          me.SetTask(self.TASK_GROUP_MAIL_TIME, i, GetTime())
          self:SetTaskDoubleBit(i, 0)
          self.IdMap[nIndex] = 1
          if self.nMaxMailIndex < nIndex then
            self.nMaxMailIndex = nIndex
          end
          return GetTime(), 0
        end
      end
      -- 如果超过最多能够表示的邮件数量，覆盖前面的邮件
      if self.MAX_MAIL_COUNT <= self:CountAvailableTaskId() then
        self:FindNextCoverIndex()
        me.SetTask(self.TASK_GROUP_MAIL_INDEX, self.nCoverIndex, nIndex)
        me.SetTask(self.TASK_GROUP_MAIL_TIME, self.nCoverIndex, GetTime())
        self:SetTaskDoubleBit(self.nCoverIndex, 0)
        self.IdMap[nIndex] = 1
        if self.nMaxMailIndex < nIndex then
          self.nMaxMailIndex = nIndex
        end
        return GetTime(), 0
      end
    end
  end
  return
end

-- 检查第nTaskId个任务变量是否可用
-- 该变量代表的信件开始发送时间后的2个月后可再次用来表示其他邮件
function Mail:IsTaskIdAvailable(nTaskId)
  local nIndex = me.GetTask(self.TASK_GROUP_MAIL_INDEX, nTaskId)
  if nIndex <= 0 then
    return 0
  end
  if self.tbMailList[nIndex] then
    local tbMail = self.tbMailList[nIndex]
    if tbMail.nExistTime then
      local nExistTime = tbMail.nExistTime * 24 * 3600
      if GetTime() - Lib:GetDate2Time(tbMail.nStartSendTime) >= nExistTime then
        return 0
      end
    else
      if GetTime() - Lib:GetDate2Time(tbMail.nStartSendTime) >= self.DONOT_SEND_TIME then
        return 0
      end
    end
    local nSendTime = me.GetTask(self.TASK_GROUP_MAIL_TIME, nTaskId)
    if nSendTime ~= 0 and GetTime() - nSendTime >= self.MAIL_EXIST_TIME then
      return 2
    end
    return 1
  end
  return 0
end

function Mail:Init()
  self.IdMap = {}
  self.nMaxMailIndex = 0
  for i = 1, self.MAX_MAIL_COUNT do
    local nCurIndex = me.GetTask(self.TASK_GROUP_MAIL_INDEX, i)
    if nCurIndex > self.nMaxMailIndex then
      self.nMaxMailIndex = nCurIndex
    end
    local bIsTaskIdAvailable = self:IsTaskIdAvailable(i)
    if 0 == bIsTaskIdAvailable then
      me.SetTask(self.TASK_GROUP_MAIL_INDEX, i, 0)
      me.SetTask(self.TASK_GROUP_MAIL_TIME, i, 0)
      self:SetTaskDoubleBit(i, 2)
    elseif 2 == bIsTaskIdAvailable then
      self:SetTaskDoubleBit(i, 2)
    end
  end
end

function Mail:ReadClientMail()
  local tbMailList = {}
  for i = self.nMaxMailIndex + 1, #self.tbMailList do
    self:CreateNewMail(i)
  end
  for i = 1, self.MAX_MAIL_COUNT do
    local nIndex = me.GetTask(self.TASK_GROUP_MAIL_INDEX, i)
    if nIndex > 0 and self.tbMailList[nIndex] then
      local tbMail = self.tbMailList[nIndex]
      local nSendTime = me.GetTask(self.TASK_GROUP_MAIL_TIME, i)
      local nState = self:GetTaskDoubleBit(i)
      if tbMail.szCaption and tbMail.szContent and tbMail.nStartSendTime and Lib:GetDate2Time(tbMail.nStartSendTime) < GetTime() then
        tbMail.nId = -nIndex
        tbMail.nState = nState or 0
        tbMail.nType = 0 -- 邮件类型是系统邮件，一定为0
        tbMail.szReceiver = me.szName
        local szSenderName = "系统"
        if IVER_g_nSdoVersion == 1 then
          szSenderName = "盛大网络"
        end
        tbMail.szSender = szSenderName
        tbMail.nSendTime = nSendTime
        tbMail.nTime = math.floor((GetTime() - nSendTime) / (3600 * 24))
        if nState ~= 2 then
          table.insert(tbMailList, tbMail)
        end
      end
    end
  end
  return tbMailList, Lib:CountTB(tbMailList)
end

-- 把tbMailList当中的第nIndex封信设置为nState状态
function Mail:SetState(nIndex, nState)
  if nIndex < 1 or not self.tbMailList[nIndex] or nState < 0 or nState > 2 then
    return
  end
  for i = 1, self.MAX_MAIL_COUNT do
    local nMailIndex = me.GetTask(self.TASK_GROUP_MAIL_INDEX, i)
    if nIndex == nMailIndex then
      self:SetTaskDoubleBit(i, nState)
      return 1
    end
  end
  return
end

function Mail:SelectClientMail(nMailId)
  if nMailId >= 0 then
    return
  end
  local nIndex = -nMailId
  if self.tbMailList[nIndex] then
    local tbMailTemp = self.tbMailList[nIndex]
    if nIndex then
      local tbMail = {}
      tbMail.nMailId = nMailId
      tbMail.nPicId = 0
      tbMail.szContent = tbMailTemp.szContent
      tbMail.nMoney = 0
      tbMail.nItemCount = 0
      tbMail.nItemIdx = 0
      self:AddMailContent(tbMail)
      self:SetState(nIndex, 1)
    end
  end
end

function Mail:DeleteMail(nMailId)
  if nMailId >= 0 then
    return
  end
  local nIndex = -nMailId
  if self.tbMailList[nIndex] then
    for i = 1, self.MAX_MAIL_COUNT do
      local nId = me.GetTask(self.TASK_GROUP_MAIL_INDEX, i)
      if nId == nIndex then
        self:SetTaskDoubleBit(i, 2)
      end
    end
  end
end
