-------------------------------------------------------
--文件名		：	kinrecruitment.lua
--创建者		：	fenghewen
--创建时间		：	2009-08-20
--功能描述		：	家族招募界面
------------------------------------------------------
local uiKinRecruitment = Ui:GetClass("kinrecruitment")

uiKinRecruitment.BUTTON_CLOSE = "BtnClose"
uiKinRecruitment.BUTTON_PUBLISH = "BtnPublish"
uiKinRecruitment.BUTTON_ADD_MEMBER = "BtnAddMember"
uiKinRecruitment.BUTTON_DEL_MEMBER = "BtnDelMember"
uiKinRecruitment.BUTTON_ADD_LEVEL = "BtnAddLevel"
uiKinRecruitment.BUTTON_DEC_LEVEL = "BtnDecLevel"
uiKinRecruitment.BUTTON_ADD_HONOUR_LEVEL = "BtnAddHonourLevel"
uiKinRecruitment.BUTTON_DEC_HONOUR_LEVEL = "BtnDecHonourLevel"

uiKinRecruitment.BUTTON_EDIT_LEVEL = "BtnEditLevel"
uiKinRecruitment.BUTTON_EDIT_HONOUR = "BtnEditHonour"

uiKinRecruitment.EDIT_LEVEL = "EdtLevel"
uiKinRecruitment.EDIT_HONOUR = "EdtHonourLevel"
uiKinRecruitment.TEXT_PUBLISH = "TxtPublish"

uiKinRecruitment.LIST_MEMBER = "LstMember"

uiKinRecruitment.MAX_LEVEL = 150
uiKinRecruitment.MIN_LEVEL = 10

uiKinRecruitment.MAX_HONOUR_LEVEL = 10
uiKinRecruitment.MIN_HONOUR_LEVEL = 0

uiKinRecruitment.tbMember = {}
uiKinRecruitment.nPublish = 0
uiKinRecruitment.nNeedLevel = 0
uiKinRecruitment.nNeedHonour = 0
uiKinRecruitment.nLevel = 10
uiKinRecruitment.nHonour = 0

-- 界面打开
function uiKinRecruitment:OnOpen(tbParam)
  self.nNeedLevel = 0
  self.nNeedHonour = 0
  me.CallServerScript({ "KinCmd", "ApplyRecruitmentPublishInfo" })
  --	local pKin = KKin.GetSelfKin();
  --	self.nPublish = pKin.GetRecruitmentPublish();
  --	if self.nPublish == 1 then
  --		Txt_SetTxt(self.UIGROUP, self.TEXT_PUBLISH, "正在招募");
  --		Btn_SetTxt(self.UIGROUP, self.BUTTON_PUBLISH, "取消招募");
  --	else
  --		Txt_SetTxt(self.UIGROUP, self.TEXT_PUBLISH, "未招募");
  --		Btn_SetTxt(self.UIGROUP, self.BUTTON_PUBLISH, "发布招募");
  --	end
  --	self.nLevel	= pKin.GetRecruitmentLevel();
  --	self.nHonour = pKin.GetRecruitmentHonour();
  --	if self.nLevel and  self.nLevel > self.MIN_LEVEL then
  --		self.nNeedLevel = 1;
  --	end
  --	if self.nHonour and self.nHonour > 0 then
  --		self.nNeedHonour = 1;
  --	end
  --	Edt_SetInt(self.UIGROUP, self.EDIT_LEVEL, self.nLevel);
  --	Edt_SetInt(self.UIGROUP, self.EDIT_HONOUR, self.nHonour);

  --	ClearComboBoxItem(self.UIGROUP, self.COMBOBOX_HONOUR);
  --	for i, tbInfo in ipairs(PlayerHonor.tbHonorLevelInfo["money"].tbLevel) do
  --		ComboBoxAddItem(self.UIGROUP, self.COMBOBOX_HONOUR, i, tbInfo.szName);
  --	end
  --	ComboBoxSelectItem(self.UIGROUP, self.COMBOBOX_HONOUR, 0);
  print("Open")
  self:Refresh()
end

-- 按钮点击
function uiKinRecruitment:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_PUBLISH then
    if self.nNeedLevel == 1 then
      self.nLevel = Edt_GetInt(self.UIGROUP, self.EDIT_LEVEL)
    else
      self.nLevel = self.MIN_LEVEL
      Edt_GetInt(self.UIGROUP, self.EDIT_LEVEL, self.MIN_LEVEL)
    end

    if self.nNeedHonour == 1 then
      self.nHonour = Edt_GetInt(self.UIGROUP, self.EDIT_HONOUR)
    else
      self.nHonour = self.MIN_HONOUR_LEVEL
      Edt_GetInt(self.UIGROUP, self.EDIT_HONOUR, self.MIN_HONOUR_LEVEL)
    end

    if self.nPublish == 0 then
      self.nPublish = 1
    else
      self.nPublish = 0
    end
    me.CallServerScript({ "KinCmd", "RecruitmentPublish", self.nPublish, self.nLevel, self.nHonour })
  elseif szWnd == self.BUTTON_ADD_MEMBER then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_MEMBER)
    if nKey == 0 or not self.tbMember[nKey] then
      me.Msg("请选择你要任命的人员")
      return 0
    end
    me.CallServerScript({ "KinCmd", "RecruitmentAgree", self.tbMember[nKey].szName })
    self.Refresh()
  elseif szWnd == self.BUTTON_DEL_MEMBER then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_MEMBER)
    if nKey == 0 or not self.tbMember[nKey] then
      me.Msg("请选择你要拒绝的人员")
      return 0
    end
    me.CallServerScript({ "KinCmd", "RecruitmentReject", self.tbMember[nKey].szName })
    self.Refresh()
  elseif szWnd == self.BUTTON_ADD_LEVEL then
    local nLevel = Edt_GetInt(self.UIGROUP, self.EDIT_LEVEL)
    if nLevel + 10 <= self.MAX_LEVEL and nLevel + 10 >= self.MIN_LEVEL then
      Edt_SetInt(self.UIGROUP, self.EDIT_LEVEL, nLevel + 10)
    else
      Edt_SetInt(self.UIGROUP, self.EDIT_LEVEL, self.MAX_LEVEL)
    end
  elseif szWnd == self.BUTTON_DEC_LEVEL then
    local nLevel = Edt_GetInt(self.UIGROUP, self.EDIT_LEVEL)
    if nLevel - 10 <= self.MAX_LEVEL and nLevel - 10 >= self.MIN_LEVEL then
      Edt_SetInt(self.UIGROUP, self.EDIT_LEVEL, nLevel - 10)
    else
      Edt_SetInt(self.UIGROUP, self.EDIT_LEVEL, self.MIN_LEVEL)
    end
  elseif szWnd == self.BUTTON_ADD_HONOUR_LEVEL then
    local nLevel = Edt_GetInt(self.UIGROUP, self.EDIT_HONOUR)
    if nLevel + 1 <= self.MAX_HONOUR_LEVEL and nLevel + 1 >= self.MIN_HONOUR_LEVEL then
      Edt_SetInt(self.UIGROUP, self.EDIT_HONOUR, nLevel + 1)
    else
      Edt_SetInt(self.UIGROUP, self.EDIT_HONOUR, self.MAX_HONOUR_LEVEL)
    end
  elseif szWnd == self.BUTTON_DEC_HONOUR_LEVEL then
    local nLevel = Edt_GetInt(self.UIGROUP, self.EDIT_HONOUR)
    if nLevel - 1 <= self.MAX_HONOUR_LEVEL and nLevel - 1 >= self.MIN_HONOUR_LEVEL then
      Edt_SetInt(self.UIGROUP, self.EDIT_HONOUR, nLevel - 1)
    else
      Edt_SetInt(self.UIGROUP, self.EDIT_HONOUR, self.MIN_HONOUR_LEVEL)
    end
  elseif szWnd == self.BUTTON_EDIT_LEVEL then
    if self.nNeedLevel == 0 then
      self.nNeedLevel = 1
    else
      self.nNeedLevel = 0
    end
  elseif szWnd == self.BUTTON_EDIT_HONOUR then
    if self.nNeedHonour == 0 then
      self.nNeedHonour = 1
    else
      self.nNeedHonour = 0
    end
  end
end

-- 编辑框变动
function uiKinRecruitment:OnEditChange(szWnd, nParam)
  if szWnd == self.EDIT_LEVEL then
    local nLevel = Edt_GetInt(self.UIGROUP, self.EDIT_LEVEL)
    if nLevel > self.MAX_LEVEL then
      Edt_SetInt(self.UIGROUP, self.EDIT_LEVEL, self.MAX_LEVEL)
    end
  --		if nLevel < self.MIN_LEVEL then
  --			Edt_SetInt(self.UIGROUP, self.EDIT_LEVEL, self.MIN_LEVEL);
  --		end
  elseif szWnd == self.EDIT_HONOUR then
    local nHonourLevel = Edt_GetInt(self.UIGROUP, self.EDIT_HONOUR)
    if nHonourLevel > self.MAX_HONOUR_LEVEL then
      Edt_SetInt(self.UIGROUP, self.EDIT_HONOUR, self.MAX_HONOUR_LEVEL)
    end
    if nHonourLevel < self.MIN_HONOUR_LEVEL then
      Edt_SetInt(self.UIGROUP, self.EDIT_HONOUR, self.MIN_HONOUR_LEVEL)
    end
  end
end

---- 列表选择
--function uiKinRecruitment:OnListSel(szWnd, nParam)
--	if szWnd == self.LIST_MEMBER then
--		Lst_SetCurKey(self.UIGROUP, self.LIST_MEMBER, nKey);
--		local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_MEMBER);
--		if (nKey == 0 or not self.tbMember[nKey]) then
--			me.Msg("请选择你要任命的人员");
--			return 0;
--		end
--		me.CallServerScript({ "KinCmd", "CheckRecruitment", self.tbMember[nKey].szName});
--		KKin.ApplyKinRecruitment();
--	end
--end

-- 更新招募状态
function uiKinRecruitment:UpdatePublish()
  local pKin = KKin.GetSelfKin()
  self.nPublish = pKin.GetRecruitmentPublish()
  if self.nPublish == 1 then
    Txt_SetTxt(self.UIGROUP, self.TEXT_PUBLISH, "正在招募")
    Btn_SetTxt(self.UIGROUP, self.BUTTON_PUBLISH, "取消招募")
  else
    Txt_SetTxt(self.UIGROUP, self.TEXT_PUBLISH, "未招募")
    Btn_SetTxt(self.UIGROUP, self.BUTTON_PUBLISH, "发布招募")
  end
  self.nLevel = pKin.GetRecruitmentLevel()
  self.nHonour = pKin.GetRecruitmentHonour()
  if self.nPublish == 1 and self.nLevel > self.MIN_LEVEL then
    print("self.nLevel" .. self.nLevel)
  else
    self.nLevel = self.MIN_LEVEL
  end

  if self.nPublish == 1 and self.nHonour and self.nHonour > self.MIN_HONOUR_LEVEL then
    print("self.nHonour " .. self.nHonour)
  else
    self.nHonour = self.MIN_HONOUR_LEVEL
  end
  Edt_SetInt(self.UIGROUP, self.EDIT_LEVEL, self.nLevel)
  Edt_SetInt(self.UIGROUP, self.EDIT_HONOUR, self.nHonour)
end

-- 接收服务器数据，更新客户端
function uiKinRecruitment:UpdateRecruitment()
  self:UpdatePublish()

  local nCount, tbInducteeTable = KKin.GetRecruitmentData()
  if not tbInducteeTable then
    return
  end
  self.tbMember = {}
  Lst_Clear(self.UIGROUP, self.LIST_MEMBER)
  local nIndex = 1
  --print("UpdateRecruitment")
  --Lib:ShowTB(tbInducteeTable)
  for i, tbMember in pairs(tbInducteeTable) do
    table.insert(self.tbMember, tbMember)
    Lst_SetCell(self.UIGROUP, self.LIST_MEMBER, i, 1, tbMember.szName)
    Lst_SetCell(self.UIGROUP, self.LIST_MEMBER, i, 2, tbMember.nLevel)
    Lst_SetCell(self.UIGROUP, self.LIST_MEMBER, i, 3, Player:GetFactionRouteName(tbMember.nFaction))
    local nHonorLevel = PlayerHonor:CalcHonorLevel(tbMember.nHonor, tbMember.nHonorRank, "money")
    Lst_SetCell(self.UIGROUP, self.LIST_MEMBER, i, 4, nHonorLevel)
    Lst_SetCell(self.UIGROUP, self.LIST_MEMBER, i, 5, tbMember.nRepute)
    if tbMember.nOnline == 0 then
      Lst_SetLineColor(self.UIGROUP, self.LIST_MEMBER, nIndex, 0xff808080)
    end
    nIndex = nIndex + 1
  end
  --Lib:ShowTB(tbInducteeTable)
end

-- 刷新，客户端发送更新请求
function uiKinRecruitment:Refresh()
  me.CallServerScript({ "KinCmd", "KinRecruitmenClean", me.dwKinId })
  KKin.ApplyKinRecruitment()
end

function uiKinRecruitment:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_KINRECRUITMENT_STATE, self.UpdatePublish },
    { UiNotify.emCOREEVENT_KINRECRUITMENT, self.UpdateRecruitment },
  }
  return tbRegEvent
end
