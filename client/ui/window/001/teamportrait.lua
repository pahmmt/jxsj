-----------------------------------------------------
--文件名		：	teamportrait.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间	：	2007-02-09
--功能描述	：	交易面板。
------------------------------------------------------

local uiTeamPortrait = Ui:GetClass("teamportrait")

uiTeamPortrait.CLOSE_BUTTON = "BtnClose"
uiTeamPortrait.PORTRAIT_WINDOW = "WndPortrait"
uiTeamPortrait.TIME_TALKPOPSHOWTIME = 6
local tbViewPlayerMgr = Ui.tbLogic.tbViewPlayerMgr

uiTeamPortrait.PORTRAIT_WND = -- 控件句柄表
  {
    { "ImgMember1", "ImgPortrait1", "ImgPartBlood1", "ImgPartPower1", "TxtName1", "ImgFaction1", "TxtLevel1" },
    { "ImgMember2", "ImgPortrait2", "ImgPartBlood2", "ImgPartPower2", "TxtName2", "ImgFaction2", "TxtLevel2" },
    { "ImgMember3", "ImgPortrait3", "ImgPartBlood3", "ImgPartPower3", "TxtName3", "ImgFaction3", "TxtLevel3" },
    { "ImgMember4", "ImgPortrait4", "ImgPartBlood4", "ImgPartPower4", "TxtName4", "ImgFaction4", "TxtLevel4" },
    { "ImgMember5", "ImgPortrait5", "ImgPartBlood5", "ImgPartPower5", "TxtName5", "ImgFaction5", "TxtLevel5" },
  } -- [1]为PlayerID

uiTeamPortrait.MENU_ITEM = { " 密聊 ", " 查看 ", " 交易 ", " 跟随 ", " 离开队伍 ", " 加为好友 ", " 队长移交 ", " 踢出队伍 " }

uiTeamPortrait.ZHENFA_WND = { "ImgZhenFa", "ImgZhenFaChange" }

uiTeamPortrait.FACTION_FLAG = {
  "\\image\\icon\\player\\faction\\team_member_faction_flag_shaolin.spr",
  "\\image\\icon\\player\\faction\\team_member_faction_flag_tianwang.spr",
  "\\image\\icon\\player\\faction\\team_member_faction_flag_tangmen.spr",
  "\\image\\icon\\player\\faction\\team_member_faction_flag_wudu.spr",
  "\\image\\icon\\player\\faction\\team_member_faction_flag_emei.spr",
  "\\image\\icon\\player\\faction\\team_member_faction_flag_cuiyan.spr",
  "\\image\\icon\\player\\faction\\team_member_faction_flag_gaibang.spr",
  "\\image\\icon\\player\\faction\\team_member_faction_flag_tianren.spr",
  "\\image\\icon\\player\\faction\\team_member_faction_flag_wudang.spr",
  "\\image\\icon\\player\\faction\\team_member_faction_flag_kunlun.spr",
  "\\image\\icon\\player\\faction\\team_member_faction_flag_mingjiao.spr",
  "\\image\\icon\\player\\faction\\team_member_faction_flag_dali.spr",
}

uiTeamPortrait.ZHENGFA_SPR = {
  "image\\ui\\001a\\zhen\\zhenfa00.spr",
  "image\\ui\\001a\\zhen\\zhenfa01.spr",
  "image\\ui\\001a\\zhen\\zhenfa02.spr",
  "image\\ui\\001a\\zhen\\zhenfa03.spr",
  "image\\ui\\001a\\zhen\\zhenfa04.spr",
  "image\\ui\\001a\\zhen\\zhenfa05.spr",
}

uiTeamPortrait.PO_WND = {
  { "Member1_PoPo", "Member1_PoPo_Txt" },
  { "Member2_PoPo", "Member2_PoPo_Txt" },
  { "Member3_PoPo", "Member3_PoPo_Txt" },
  { "Member4_PoPo", "Member4_PoPo_Txt" },
  { "Member5_PoPo", "Member5_PoPo_Txt" },
}

function uiTeamPortrait:Init()
  self.m_bHidePortrait = 0
  self.m_tbPlayerId = { 0, 0, 0, 0, 0 }
  self.tbTalkTime = { 0, 0, 0, 0, 0 }
end

function uiTeamPortrait:OnOpen()
  self:GetMemberBaseData()
  self.tbMenuFun = {
    { self.CmdChat },
    { self.CmdViewPlayer },
    { self.CmdTrade },
    { self.CmdFollow },
    { self.CmdLeaveTeam },
  }

  for i = 1, #self.PO_WND do
    Wnd_Hide(self.UIGROUP, self.PO_WND[i][1])
  end
  self.tbTalkTime = { 0, 0, 0, 0, 0 }
  self.nTimerRegisterId = Ui.tbLogic.tbTimer:Register(1 * 18, self.HideTalk, self)
end

function uiTeamPortrait:OnClose()
  if self.nTimerRegisterId and self.nTimerRegisterId > 0 then
    Ui.tbLogic.tbTimer:Close(self.nTimerRegisterId)
  end
  self.nTimerRegisterId = 0
end

function uiTeamPortrait:OnButtonClick(szWndName, nParam)
  if szWndName == self.CLOSE_BUTTON then
    self:MinProtraitWindow()
  end
end

function uiTeamPortrait:GetMemberBaseData()
  local tbMember = me.GetTeamMemberInfo()
  local nMemberCount = #tbMember

  for i = 1, #self.PORTRAIT_WND do
    if tbMember[i] and tbMember[i].szName and tbMember[i].nPlayerID then
      -- 显示头像
      self.m_tbPlayerId[i] = tbMember[i].nPlayerID
      if tbMember[i].nPortrait then
        local szSpr = tbViewPlayerMgr:GetPortraitSpr(tbMember[i].szName, tbMember[i].nPortrait, tbMember[i].nSex, 1)
        Img_SetImage(self.UIGROUP, self.PORTRAIT_WND[i][2], 1, szSpr)
      end

      Prg_SetPos(self.UIGROUP, self.PORTRAIT_WND[i][3], tbMember[i].nCurLife / 100 * 1000)
      Prg_SetPos(self.UIGROUP, self.PORTRAIT_WND[i][4], tbMember[i].nCurMana / 100 * 1000)
      -- 设置Tip提示
      local szFaction = Player:GetFactionRouteName(tbMember[i].nFaction)
      local szName = GetMapNameFormId(tbMember[i].nMapId)
      if not szName then
        szName = "未知"
      end
      Wnd_SetTip(self.UIGROUP, self.PORTRAIT_WND[i][2], string.format("等级：%d 门派：%s 所在地：%s", tbMember[i].nLevel, szFaction, szName))

      -- 在线状况
      if tbMember[i].nOnline == 0 then
        Txt_SetTxtColor(self.UIGROUP, self.PORTRAIT_WND[i][5], 0xffc0c0c0)
        Img_SetFrame(self.UIGROUP, self.PORTRAIT_WND[i][2], 1)
      else
        Txt_SetTxtColor(self.UIGROUP, self.PORTRAIT_WND[i][5], 0xff80d0a0)
        Img_SetFrame(self.UIGROUP, self.PORTRAIT_WND[i][2], 0)
      end

      local szBuf = tbMember[i].szName
      if tbMember[i].nLeader == 1 then
        szBuf = "<color=0xffffff68>" .. szBuf -- 队长
      end
      Txt_SetTxt(self.UIGROUP, self.PORTRAIT_WND[i][5], szBuf)
      --			Txt_SetTxt(self.UIGROUP, self.PORTRAIT_WND[i][7], tbMember[i].nLevel)

      if self.FACTION_FLAG[tbMember[i].nFaction] then
        Img_SetImage(self.UIGROUP, self.PORTRAIT_WND[i][6], 1, self.FACTION_FLAG[tbMember[i].nFaction])
      else
        Img_SetImage(self.UIGROUP, self.PORTRAIT_WND[i][6], 1, "")
      end
      Wnd_Show(self.UIGROUP, self.PORTRAIT_WND[i][1])
    else
      Txt_SetTxt(self.UIGROUP, self.PORTRAIT_WND[i][5], "")
      Wnd_Hide(self.UIGROUP, self.PORTRAIT_WND[i][1])
      --CancelCurPopupMenu(self.UIGROUP, self.PORTRAIT_WND[i][1]);
    end
  end

  -- 阵法
  local tbZhenFa = me.GetZhenFaInfo()
  if not tbZhenFa then
    return
  end

  Wnd_SetPos(self.UIGROUP, self.ZHENFA_WND[1], 2, (nMemberCount + 1) * 34)
  Img_SetImage(self.UIGROUP, self.ZHENFA_WND[1], 1, self.ZHENGFA_SPR[tbZhenFa.nLevel + 1])
  Wnd_Show(self.UIGROUP, self.ZHENFA_WND[1])
end

function uiTeamPortrait:UpdateMemberData(nZhenFaChange)
  local tbMember = me.GetTeamMemberInfo()
  for i = 1, #self.PORTRAIT_WND do
    if tbMember[i] then
      Prg_SetPos(self.UIGROUP, self.PORTRAIT_WND[i][3], tbMember[i].nCurLife / 100 * 1000)
      Prg_SetPos(self.UIGROUP, self.PORTRAIT_WND[i][4], tbMember[i].nCurMana / 100 * 1000)
      -- 设置Tip提示
      local szFaction = Player:GetFactionRouteName(tbMember[i].nFaction)
      local szName = GetMapNameFormId(tbMember[i].nMapId)
      if not szName then
        szName = "未知"
      end
      Wnd_SetTip(self.UIGROUP, self.PORTRAIT_WND[i][2], string.format("等级：%d 门派：%s 所在地：%s", tbMember[i].nLevel, szFaction, szName))

      if tbMember[i].nOnline == 0 then
        Txt_SetTxtColor(self.UIGROUP, self.PORTRAIT_WND[i][5], 0xffc0c0c0)
        Img_SetFrame(self.UIGROUP, self.PORTRAIT_WND[i][2], 1)
      else
        Txt_SetTxtColor(self.UIGROUP, self.PORTRAIT_WND[i][5], 0xff80d0a0)
        Img_SetFrame(self.UIGROUP, self.PORTRAIT_WND[i][2], 0)
      end
    else
      Wnd_Hide(self.UIGROUP, self.PORTRAIT_WND[i][1])
      --CancelCurPopupMenu(self.UIGROUP, self.PORTRAIT_WND[i][1]);
    end
  end

  -- 阵法
  local nMemberCount = #tbMember
  local tbZhenFa = me.GetZhenFaInfo()

  if not tbZhenFa then
    Wnd_Hide(self.UIGROUP, self.ZHENFA_WND[1])
    return
  end
  if nZhenFaChange == 1 then
    local tbZhenFa = me.GetZhenFaInfo()
    if not tbZhenFa then
      Wnd_Hide(self.UIGROUP, self.ZHENFA_WND[1])
      return
    end
    Wnd_SetPos(self.UIGROUP, self.ZHENFA_WND[1], 2, (nMemberCount + 1) * 34)
    Img_SetImage(self.UIGROUP, self.ZHENFA_WND[1], 1, self.ZHENGFA_SPR[tbZhenFa.nLevel + 1])
    Wnd_Show(self.UIGROUP, self.ZHENFA_WND[1])

    local nWidth1, nHeight1 = Wnd_GetSize(self.UIGROUP, self.ZHENFA_WND[1])
    local nWidth2, nHeight2 = Wnd_GetSize(self.UIGROUP, self.ZHENFA_WND[2])
    Wnd_SetPos(self.UIGROUP, self.ZHENFA_WND[2], 2 - (nHeight2 - nHeight1) / 2, (nMemberCount + 1) * 34 - (nWidth2 - nWidth1) / 2)
    Wnd_Show(self.UIGROUP, self.ZHENFA_WND[2])
    Img_PlayAnimation(self.UIGROUP, self.ZHENFA_WND[2])
  end
end

function uiTeamPortrait:MinProtraitWindow()
  if self.m_bHidePortrait == 1 then
    Wnd_Show(self.UIGROUP, self.PORTRAIT_WINDOW)
    --		Wnd_SetSize(self.UIGROUP, self.MAIN_WINDOW, 132, 220)
    self.m_bHidePortrait = 0
  else
    Wnd_Hide(self.UIGROUP, self.PORTRAIT_WINDOW)
    --		Wnd_SetSize(self.UIGROUP, self.MAIN_WINDOW, 16, 16)
    self.m_bHidePortrait = 1
  end
end

function uiTeamPortrait:OnPopUpMenu(szWnd, nParam)
  local nPlayer = nil -- 判断菜单属于第几个队友
  for i = 1, #self.PORTRAIT_WND do
    for j = 1, #self.PORTRAIT_WND[i] do
      if szWnd == self.PORTRAIT_WND[i][j] then
        nPlayer = i
        break
      end
    end
  end
  if nPlayer then
    local tbMember = me.GetTeamMemberInfo()
    if tbMember[nPlayer].nOnline ~= 0 then -- 如果在线者弹出菜单
      local tbRelationList, _ = me.Relation_GetRelationList()
      local bFriend, bTeamLeader = 0, 0
      if tbRelationList and tbRelationList[Player.emKPLAYERRELATION_TYPE_BIDFRIEND] then
        local tbFrined = tbRelationList[Player.emKPLAYERRELATION_TYPE_BIDFRIEND]
        for szPlayer, _ in pairs(tbFrined) do -- 判断是否好友
          if tbMember[nPlayer].szName == szPlayer then
            bFriend = 1 -- 是自己好友
          end
        end
      end

      if tbRelationList and tbRelationList[Player.emKPLAYERRELATION_TYPE_TMPFRIEND] then
        local tbTmpFrined = tbRelationList[Player.emKPLAYERRELATION_TYPE_TMPFRIEND] -- 判断是否是临时好友
        for szPlayer, _ in pairs(tbTmpFrined) do
          if tbMember[nPlayer].szName == szPlayer then
            bFriend = 1 -- 是自己临时好友
          end
        end
      end

      if self:IsTeamLeader() == 1 then
        bTeamLeader = 1 -- 自己不是队长
      end
      self.tbMenuFun[9] = tbMember[nPlayer] -- 被选中的玩家信息放入 第9项
      if (bFriend == 0) and (bTeamLeader == 0) then -- 显示加为好友, 不显示队长移交和踢出队伍
        self.tbMenuFun[6] = { self.CmdAddFriend }
        DisplayPopupMenu(self.UIGROUP, szWnd, 6, nParam, self.MENU_ITEM[1], 1, self.MENU_ITEM[2], 2, self.MENU_ITEM[3], 3, self.MENU_ITEM[4], 4, self.MENU_ITEM[5], 5, self.MENU_ITEM[6], 6)
      end
      if (bFriend == 0) and (bTeamLeader == 1) then -- 显示加为好友, 显示队长移交和踢出队伍
        self.tbMenuFun[6] = { self.CmdAddFriend }
        self.tbMenuFun[7] = { self.CmdChangeLeader }
        self.tbMenuFun[8] = { self.CmdKickOut }
        DisplayPopupMenu(self.UIGROUP, szWnd, 8, nParam, self.MENU_ITEM[1], 1, self.MENU_ITEM[2], 2, self.MENU_ITEM[3], 3, self.MENU_ITEM[4], 4, self.MENU_ITEM[5], 5, self.MENU_ITEM[6], 6, self.MENU_ITEM[7], 7, self.MENU_ITEM[8], 8)
      end
      if (bFriend == 1) and (bTeamLeader == 0) then -- 不显示加为好友, 不显示队长移交和踢出队伍
        DisplayPopupMenu(self.UIGROUP, szWnd, 5, nParam, self.MENU_ITEM[1], 1, self.MENU_ITEM[2], 2, self.MENU_ITEM[3], 3, self.MENU_ITEM[4], 4, self.MENU_ITEM[5], 5)
      end
      if (bFriend == 1) and (bTeamLeader == 1) then -- 不显示加为好友, 显示队长移交和踢出队伍
        self.tbMenuFun[6] = { self.CmdChangeLeader }
        self.tbMenuFun[7] = { self.CmdKickOut }
        DisplayPopupMenu(self.UIGROUP, szWnd, 7, nParam, self.MENU_ITEM[1], 1, self.MENU_ITEM[2], 2, self.MENU_ITEM[3], 3, self.MENU_ITEM[4], 4, self.MENU_ITEM[5], 5, self.MENU_ITEM[7], 6, self.MENU_ITEM[8], 7)
      end
    end
  end
end

function uiTeamPortrait:OnMenuItemSelected(szWnd, nItemId, nListIndex)
  if nItemId and nItemId <= #self.MENU_ITEM then
    if self.tbMenuFun[nItemId] then
      self.tbMenuFun[nItemId][1](self, self.tbMenuFun[9])
    end
  end
end

function uiTeamPortrait:CmdChat(tbMemberPlayer)
  if tbMemberPlayer then
    ChatToPlayer(tbMemberPlayer.szName)
  end
end

function uiTeamPortrait:CmdViewPlayer(tbMemberPlayer)
  if tbMemberPlayer then
    local bSucess = 1
    local pNpc = KNpc.GetByPlayerId(tbMemberPlayer.nPlayerID)
    if pNpc then
      bSucess = ProcessNpcById(pNpc.dwId, UiManager.emACTION_VIEWITEM)
    end
    if (bSucess == 0) or not pNpc then
      me.Msg("虽然您很想查看该玩家，但无奈距离太远了！")
    end
  end
end

function uiTeamPortrait:CmdTrade(tbMemberPlayer)
  if tbMemberPlayer then
    local bSucess = 1
    local pNpc = KNpc.GetByPlayerId(tbMemberPlayer.nPlayerID)
    if pNpc then
      bSucess = ProcessNpcById(pNpc.dwId, UiManager.emACTION_TRADE)
    end
    if (bSucess == 0) or not pNpc then
      me.Msg("虽然您很想与该玩家交易，但无奈距离太远了！")
    end
  end
end

function uiTeamPortrait:CmdFollow(tbMemberPlayer)
  local bSucess = 1
  if tbMemberPlayer then
    self:CBFollow(tbMemberPlayer.nPlayerID)
  end
end

function uiTeamPortrait:CBFollow(nPlayerId)
  local pNpc = KNpc.GetByPlayerId(nPlayerId)
  if pNpc then -- 距离很近，尝试直接跟随
    if ProcessNpcById(pNpc.dwId, UiManager.emACTION_FOLLOW) == 1 then
      return
    end
  end
  local tbMember = me.GetTeamMemberInfo()
  for _, tbMemberPlayer in ipairs(tbMember) do
    if tbMemberPlayer.nPlayerID == nPlayerId then
      local tbPos = {
        nMapId = tbMemberPlayer.nMapId,
      }
      for _, tbNpc in ipairs(SyncNpcInfo() or {}) do
        if tbNpc.szName == tbMemberPlayer.szName then
          tbPos.nX = tbNpc.nX / 2
          tbPos.nY = tbNpc.nY
          break
        end
      end
      Ui.tbLogic.tbAutoPath:GotoPos(tbPos, self.CBFollow, self, nPlayerId)
      return
    end
  end
  me.Msg("该玩家已消失得无影无踪！")
end

function uiTeamPortrait:CmdLeaveTeam(tbMemberPlayer)
  me.TeamLeave()
end

function uiTeamPortrait:CmdAddFriend(tbMemberPlayer)
  local bSucess = 1
  if tbMemberPlayer then
    local pNpc = KNpc.GetByPlayerId(tbMemberPlayer.nPlayerID)
    if pNpc then
      bSucess = ProcessNpcById(pNpc.dwId, UiManager.emACTION_MAKEFRIEND)
    end

    if (bSucess == 0) or not pNpc then
      me.Msg("虽然您很想加该玩家为好友，但无奈距离太远了！")
    end
  end
end

function uiTeamPortrait:CmdChangeLeader(tbMemberPlayer)
  if tbMemberPlayer then
    me.TeamAppoint(tbMemberPlayer.nPlayerID)
  end
end

function uiTeamPortrait:CmdKickOut(tbMemberPlayer)
  if tbMemberPlayer then
    me.TeamKick(tbMemberPlayer.nPlayerID)
  end
end

function uiTeamPortrait:IsTeamLeader()
  local tbMember = me.GetTeamMemberInfo()
  if tbMember then
    for i = 1, #tbMember do
      if tbMember[i].nLeader == 1 then
        return 0
      end
    end
  end
  return 1
end

function uiTeamPortrait:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_TEAM_MEMBER_CHANGED, self.UpdateMemberData },
  }
  return tbRegEvent
end

function uiTeamPortrait:OnMouseEnter(szWnd)
  if szWnd ~= self.ZHENFA_WND[1] then
    return
  end

  local tbZhenFa = me.GetZhenFaInfo()
  if not tbZhenFa then
    return
  end

  local szMsg = self:GetZhenFaDesc(tbZhenFa.nNearSkillId, tbZhenFa.nMapSkillId, tbZhenFa.nLevel)
  szMsg = string.format("<color=yellow>%s<color>\n\n", tbZhenFa.szName) .. szMsg
  szMsg = string.gsub(szMsg, "持续时间：<color=gold>%d*秒<color>\n", "")
  Wnd_ShowMouseHoverInfo(self.UIGROUP, self.ZHENFA_WND[1], "", szMsg)
end

function uiTeamPortrait:OnAnimationOver(szWnd)
  if szWnd == self.ZHENFA_WND[2] then
    Wnd_Hide(self.UIGROUP, self.ZHENFA_WND[2]) -- 播放完毕，隐藏图像
  end
end

function uiTeamPortrait:GetZhenFaDesc(nNearSkillId, nMapSkillId, nLevel)
  local tbZhen = Item:GetClass("zhen")

  local szCurMsg = ""
  if nLevel == 0 then
    szCurMsg = "<color=cyan>当前阵法未激活<color>\n\n"
  end
  if nLevel > 0 then
    if nLevel < 5 then
      szCurMsg = string.format("<color=cyan>当前阵法激活等级：<color><color=cyan>%s级<color>\n", nLevel)
    else
      nLevel = 5
      szCurMsg = string.format("<color=cyan>当前阵法激活等级：<color><color=cyan>%s级<color>[<color=red>最高级<color>]\n", nLevel)
    end
    if nMapSkillId > 0 then
      local szInfo = self:GetZhenFaSkillInfo(nMapSkillId, nLevel)
      szCurMsg = szCurMsg .. "<color=green>全地图效果<color>\n" .. szInfo .. "\n"
    end
    if nNearSkillId > 0 then
      local szInfo = self:GetZhenFaSkillInfo(nNearSkillId, nLevel)
      szCurMsg = szCurMsg .. "<color=green>近距离额外效果<color>\n" .. szInfo .. "\n"
    end
  end

  local szNextMsg = ""
  if nLevel < 5 then
    szNextMsg = string.format("<color=cyan>下一阵法激活等级：<color><color=cyan>%s级<color>\n", nLevel + 1)
    if nMapSkillId > 0 then
      local szInfo = self:GetZhenFaSkillInfo(nMapSkillId, nLevel + 1)
      szNextMsg = szNextMsg .. "<color=green>全地图效果<color>\n" .. szInfo .. "\n"
    end
    if nNearSkillId > 0 then
      local szInfo = self:GetZhenFaSkillInfo(nNearSkillId, nLevel + 1)
      szNextMsg = szNextMsg .. "<color=green>近距离额外效果<color>\n" .. szInfo .. "\n"
    end
  end

  szCurMsg = szCurMsg .. szNextMsg

  szCurMsg = string.gsub(szCurMsg, "<color=white>持续时间：<color><color=gold>%d*秒<color>\n", "") --以后的技能tips中的持续时间格式
  szCurMsg = string.gsub(szCurMsg, "持续时间：<color=gold>%d*秒<color>\n", "") --现在的技能tips中的持续时间格式

  return szCurMsg
end

function uiTeamPortrait:GetZhenFaSkillInfo(nSkillId, nLevel)
  local tbInfo = nil

  if nLevel > 0 then
    tbInfo = KFightSkill.GetSkillInfo(nSkillId, nLevel)
  else
    nLevel = 0
  end

  if not tbInfo then
    return
  end

  local szClassName = tbInfo.szClassName
  local tbSkill = assert(FightSkill.tbClass[szClassName], "Skill{" .. szClassName .. "} bot found!")
  local tbMsg = {}
  tbSkill:GetDescAboutLevel(tbMsg, tbInfo)
  return table.concat(tbMsg, "\n") .. "\n"
end

function uiTeamPortrait:GetMemberTalk(szSendName, szMsg)
  local tbMember = me.GetTeamMemberInfo()
  local nNowTalk = 0

  -- 确定这个名字队友的序号
  for i = 1, #tbMember do
    if tbMember[i].szName == szSendName then
      nNowTalk = i
      break
    end
  end

  if nNowTalk == 0 then
    return
  end

  -- 转义可能的Emote Tag等
  local szFirstChar = string.sub(szMsg, 1, 1)
  if szFirstChar == "#" then
    local szEmote = string.sub(szMsg, 2, -1)
    local szEscapedMsg = AddEmoteMsg(szEmote, szSendName)
    if szEscapedMsg then
      szMsg = szEscapedMsg
    end
  end

  -- 处理剪裁文字，不超过 12 个汉字，多余的用 "..." 来显示
  local szShowMsg = self:GetFormatMsg(szMsg)

  -- 队长聊天颜色高亮
  if tbMember[nNowTalk].nLeader == 1 then
    Txt_SetTxt(self.UIGROUP, self.PO_WND[nNowTalk][2], "<color=orange>" .. szShowMsg .. "<color>")
  else
    Txt_SetTxt(self.UIGROUP, self.PO_WND[nNowTalk][2], "<color=white>" .. szShowMsg .. "<color>")
  end

  Wnd_Show(self.UIGROUP, self.PO_WND[nNowTalk][1])
  self.tbTalkTime[nNowTalk] = self.TIME_TALKPOPSHOWTIME
end

function uiTeamPortrait:HideTalk()
  for nNowTalk, tbInfo in ipairs(self.PO_WND) do
    local nTimeCount = self.tbTalkTime[nNowTalk]
    if nTimeCount > 0 then
      nTimeCount = nTimeCount - 1
      if 0 >= nTimeCount then
        Wnd_Hide(self.UIGROUP, tbInfo[1])
      end
      self.tbTalkTime[nNowTalk] = nTimeCount
    end
  end
  return
end

-- Bổ sung 2 helper functions
function uiTeamPortrait:GetUTF8CharLength(byte)
  if byte < 128 then
    return 1 -- ASCII
  elseif byte < 224 then
    return 2 -- 2-byte UTF-8
  elseif byte < 240 then
    return 3 -- 3-byte UTF-8 (tiếng Việt thường dùng)
  elseif byte < 248 then
    return 4 -- 4-byte UTF-8
  else
    return 1 -- Fallback
  end
end

function uiTeamPortrait:GetNextUTF8Char(text)
  if string.len(text) <= 0 then
    return "", ""
  end

  local firstByte = string.byte(text, 1)
  local charLen = self:GetUTF8CharLength(firstByte)

  -- Đảm bảo không vượt quá độ dài string
  charLen = math.min(charLen, string.len(text))

  local char = string.sub(text, 1, charLen)
  local remaining = string.sub(text, charLen + 1)

  return char, remaining
end

-- Thay thế hàm GetFormatMsg() cũ
function uiTeamPortrait:GetFormatMsg(szMsg)
  local szShow = ""
  local szTempMsg = szMsg
  local nMsgLen = string.len(szMsg)

  while string.len(szShow) < 26 and string.len(szTempMsg) > 0 do
    local szRead = ""
    local nSpcFlag = 0

    -- Xử lý tags trước
    if string.sub(szTempMsg, 1, 1) == "<" then
      local nPicStart, nPicEnd = string.find(szTempMsg, ">")
      if nPicStart and nPicEnd then
        szRead = string.sub(szTempMsg, 1, nPicEnd)
        szTempMsg = string.sub(szTempMsg, nPicEnd + 1)

        -- Kiểm tra nếu không phải <pic=...> tag thì đánh dấu để thêm "..."
        local szTempPic = string.sub(szRead, 1, 5)
        if szTempPic ~= "<pic=" then
          nSpcFlag = 1
        end
      else
        -- Không tìm thấy tag đóng, lấy ký tự UTF-8
        szRead, szTempMsg = self:GetNextUTF8Char(szTempMsg)
      end
    else
      -- Lấy ký tự UTF-8 tiếp theo
      szRead, szTempMsg = self:GetNextUTF8Char(szTempMsg)
    end

    -- Thêm vào chuỗi hiển thị
    if 1 == nSpcFlag then
      szShow = szShow .. "..."
    else
      szShow = szShow .. szRead
    end

    -- Cập nhật độ dài còn lại
    nMsgLen = nMsgLen - string.len(szRead)
  end

  -- Nếu còn ký tự chưa hiển thị thì thêm "..."
  if string.len(szTempMsg) > 0 then
    szShow = szShow .. "..."
  end

  return szShow
end
