-----------------------------------------------------
--文件名		：	uishortcutalias.lua
--创建者		：	wuwei1
--创建时间		：	2007-03-17
--功能描述		：	快捷键配置
------------------------------------------------------

-- TODO: xyf 该文件需要重新设计，不使用loadstring，Lua向C层发送快捷键映射表，以及处理一些互斥的逻辑，其余的扔进C处理，
-- P.S.: 换个名字吧。。。uikeyboard之类的

function UiShortcutAlias:init()
  self.tbName2Key = {}
  self.tbKey2Name = {}
  self.m_nControlMode = 0 -- 当前使用的界面模式
  -- 向后支持，为了兼容以前的
  self.m_Alias = {}
end

function UiShortcutAlias:DoCommand(szAlias)
  -- 向后兼容
  if szAlias and self.m_Alias[szAlias] then
    szAlias = self.m_Alias[szAlias]
  end

  local fnCmd = loadstring(szAlias)
  if fnCmd then
    local bSuc, szMsg = pcall(fnCmd)
    if true == bSuc then
      return 1
    end
    print("客户端指令执行错误", szMsg)
  end

  error()
  return 0
end

function UiShortcutAlias:HandleCommand(szAlias)
  local tbKey = self:GetKeyDefine(szAlias)

  -- 向后兼容
  if not tbKey or (szAlias and self.m_Alias[szAlias]) then
    -- 直接执行客户端指令
    -- 通过聊天频道(/me.Msg 测试)来执行
    return self:DoCommand(szAlias)
  end

  if tbKey.nExcute == UiShortcutAlias.emDETAIL_EXCUTE_STRING then
    return self:DoCommand(tbKey.tbExcute[1])
  elseif tbKey.nExcute == UiShortcutAlias.emDETAIL_EXCUTE_CALLBACK then
    Lib:CallBack(tbKey.tbExcute)
    return 1
  elseif tbKey.nExcute == UiShortcutAlias.emDETAIL_EXCUTE_UIGROUP then
    local tbWnd = Ui.tbWnd[tbKey.szBelong or ""]
    if tbWnd and tbWnd.OnShortcutAlias then
      tbWnd:OnShortcutAlias(szAlias, unpack(tbKey.tbExcute))
      return 1
    else
      print("没有对应的窗口", szAlias)
      Lib:ShowTB(tbKey)
    end
  else
    print("执行类型错误", szAlias)
    Lib:ShowTB(tbKey)
  end
  return 0
end

function UiShortcutAlias:ShortcutSkill(nKey)
  if UiManager:WindowVisible(Ui.UI_SKILLTREE) == 0 then
    Ui(Ui.UI_SKILLTREE):UseShortcutSkill(nKey)
  else
    Ui(Ui.UI_SKILLTREE):OnSetShortcutSkill(nKey)
  end
end

-- 打开活动界面
function UiShortcutAlias:OpenCampaignUi()
  if self.szLastGroup then
    -- 如果上次打开的活动界面仍然打开则只关闭就返回了
    if UiManager:WindowVisible(self.szLastGroup) == 1 then
      UiManager:CloseWindow(self.szLastGroup)
      return 0
    end
  end
  local szType, tbDate = me.GetCampaignDate()
  if not szType then -- 数据失效了，不打开活动界面
    return 0
  end
  if self.tbCampaignUiTable and self.tbCampaignUiTable[szType] then
    UiManager:OpenWindow(self.tbCampaignUiTable[szType])
    self.szLastGroup = self.tbCampaignUiTable[szType]
  end
end

-- 注册活动界面表，活动界面必须注册才能根据szType应打开的界面
function UiShortcutAlias:RegisterCampaignUi(szType, szUiGroup)
  if not self.tbCampaignUiTable then
    self.tbCampaignUiTable = {}
  end
  self.tbCampaignUiTable[szType] = szUiGroup
end

-- 快捷键按下释放通知
function UiShortcutAlias:OnCommandDown(szAlias)
  local tbKey = self:GetKeyDefine(szAlias)
  if not tbKey then
    print("快捷键未定义", szAlias)
    return
  end

  local tbWnd = Ui.tbWnd[tbKey.szBelong]
  if tbWnd and tbWnd.OnAliasDown then
    tbWnd:OnAliasDown(szAlias, unpack(tbKey.tbExcute))
  end
end

function UiShortcutAlias:OnCommandUp(szAlias)
  local tbKey = self:GetKeyDefine(szAlias)
  if not tbKey then
    print("未定义", tbKey, szAlias)
    return
  end

  local tbWnd = Ui.tbWnd[tbKey.szBelong]
  if tbWnd and tbWnd.OnAliasUp then
    tbWnd:OnAliasUp(szAlias, unpack(tbKey.tbExcute))
  end
end

-- 解释快捷键(类似于LButton->鼠标左键)
function UiShortcutAlias:ExplanationAlias(szKey, bShortName)
  local szAlias = szKey or ""
  for sz, szDesc in pairs(self.tbExplanAlias) do
    if string.find(szAlias, sz) then
      szAlias = string.gsub(szAlias, sz, szDesc)
    end
  end

  -- 是否需要短名字
  if 1 == bShortName then
    for sz, szDesc in pairs(self.tbShortExplanAlias) do
      if string.find(szAlias, sz) then
        szAlias = string.gsub(szAlias, sz, szDesc)
      end
    end
    -- 还是超长了就只能截取了
    if string.len(szAlias) > 4 then
      szAlias = string.sub(szAlias, 1, 3) .. "*"
    end
  end

  return szAlias
end

function UiShortcutAlias:SetControlModel(nMode)
  if not nMode or nMode < 1 or nMode > 2 then
    nMode = 1
  end

  if nMode ~= self.m_nControlMode then
    self.m_nControlMode = nMode
    self:RegisterAlias(nMode)
  end
end

-- 注册快捷键
function UiShortcutAlias:RegisterAlias(nMode)
  assert((nMode == 1 or nMode == 2) and "快捷键就只用两种模式，不是1就是2")
  -- 先卸载
  self:UnRegister()
  -- 默认的快捷键
  for szName, tbItem in pairs(self.tbDefault) do
    self:AddAlisKey(tbItem.tbKey[nMode], szName, tbItem.nState)
  end
end

-- 卸载快捷键
function UiShortcutAlias:UnRegister()
  for szKey, szName in pairs(self.tbKey2Name) do
    self:RemoveAliasKey(szKey)
  end
  self:RemoveAliasKey("")

  self.tbKey2Name = {}
  self.tbName2Key = {}
end
-----------------------------------------------------------------------------------------
-- 注意：这里只是为了支持插件，做的特殊处理，后续维护，请不要使用该接口
-- AddAlias
function UiShortcutAlias:AddAlias(szAlias, szCmd)
  self.m_Alias[szAlias] = szCmd
end

-- 添加快捷键(如果szName在tbDefault表中找不到，则认为szName==szDo，将直接执行szName)
function UiShortcutAlias:AddAlisKey(szKey, szName, nState)
  if not szKey or not szName or szKey == "" or szName == "" then
    return
  end

  local tbKey = {}
  tbKey.szKey = szKey
  tbKey.szName = szName
  tbKey.nState = nState or UiShortcutAlias.emKSTATE_INGAME

  if self.tbName2Key[szName] then
    print("[warning]\t重名了", szName, "覆盖", szKey, self.tbName2Key[szName].szKey)
  end

  -- 注意啦,后注册的将会被忽略
  if self.tbKey2Name[szKey] then
    print("[warning]\t快捷键重了", szKey, "key覆盖", szName, self.tbKey2Name[szKey])
    tbKey.szKey = ""
    szKey = ""
  else
    AddCommand(szKey, "", szName, tbKey.nState)
    self.tbKey2Name[szKey] = szName
  end

  self.tbName2Key[szName] = tbKey
end

-- 删除快捷键
function UiShortcutAlias:RemoveAliasKey(szKey)
  local szName = self.tbKey2Name[szKey] or ""
  self.tbName2Key[szName] = nil
  self.tbKey2Name[szKey] = nil

  RemoveCommand(szKey, "")
end

function UiShortcutAlias:GetKeyDefine(szName)
  return self.tbDefault[szName or ""]
end

-- 获取默认的配置
function UiShortcutAlias:GetDefault()
  return self.tbDefault
end

-- 获取名字对应的快捷键
function UiShortcutAlias:GetNameKey(szName)
  szName = szName or ""
  if self.tbName2Key[szName] then
    return self.tbName2Key[szName].szKey
  end
end

function UiShortcutAlias:GetTipsText(tbTips, szKey)
  if not tbTips then
    return ""
  end

  local MAX_TIPS_TXT_WIDTH = 240
  local TIPS_TXT_FONT_SIZT = 12

  local szMsg = ""
  if szKey ~= "" then
    local szTemp = string.format("%s[快捷键：%s]", tbTips[1], szKey)
    local nTempLen = string.len(szTemp)
    local nSpaceCount = MAX_TIPS_TXT_WIDTH / (TIPS_TXT_FONT_SIZT / 2) - nTempLen

    szMsg = string.format("<color=gold>%s<color>", tbTips[1])
    for i = 1, nSpaceCount do
      szMsg = szMsg .. " "
    end
    szMsg = string.format("%s<color=130,255,0>[快捷键：%s]<color>", szMsg, szKey)
  else
    szMsg = string.format("<color=gold>%s<color>", tbTips[1])
  end

  if tbTips[2] ~= "" then
    szMsg = szMsg .. "\n" .. tbTips[2]
  end

  return szMsg
end

-- 这个是干什么的呀
function UiShortcutAlias:GetSkillShortcut(nKey)
  local szKey = "ShortcutSkill" .. (nKey or "")
  local tbItem = self:GetKeyDefine(szKey)

  assert((self.m_nControlMode == 1 or self.m_nControlMode == 2) and "快捷键就只用两种模式，不是1就是2")

  if tbItem then
    return tbItem.tbKey[self.m_nControlMode]
  end
  return nil
end

-- 初始化
UiShortcutAlias:init()
