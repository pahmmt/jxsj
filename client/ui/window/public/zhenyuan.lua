-----------------------------------------------------
--文件名		：	zhenyuan.lua
--创建者		：	zhoupengfeng
--创建时间		：	2010-06-28
--功能描述		：	战斗力
------------------------------------------------------

local uiZhenYuan = Ui:GetClass("zhenyuan")

local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse

uiZhenYuan.BTN_CLOSE = "BtnClose"
uiZhenYuan.BTN_OK = "BtnOk"
uiZhenYuan.BTN_CANSEL = "BtnCansel"
uiZhenYuan.OBJ_REFINE = "ObjRefine"
uiZhenYuan.OBJ_EXP = "ObjExp"
uiZhenYuan.OBJ_EXPBOOK = "ObjExpBook"
uiZhenYuan.TXT_TIP = "TxtTip"
uiZhenYuan.TXT_TIPEXP = "TxtTipExp"
uiZhenYuan.TXT_BALANCEEXP = "TxtExpBalance"
uiZhenYuan.LST_ATTR = "LstAttr"
uiZhenYuan.IMG_EFFECT = "ImgEffect"
uiZhenYuan.BTNLEVEL1 = "BtnLevel1"
uiZhenYuan.BTNLEVEL10 = "BtnLevel10"
uiZhenYuan.BTNLEVELALL = "BtnLevelAll"
uiZhenYuan.BTN_LEVEL = "BtnLevel"
uiZhenYuan.BTN_APPLYUNBIND = "BtnApplyUnBind"
uiZhenYuan.BTN_BIND = "BtnBind"
uiZhenYuan.BTN_UNBIND = "BtnUnBind"
uiZhenYuan.TXT_ZHENYUANINTRODUCE = "TxtZhenYuanInfo"

uiZhenYuan.PAGE_SET = "PageSet"
-- 页面
uiZhenYuan.tbPAGES = {
  { szBtn = "BtnPageExperience", szPage = "PageExperience" },
  { szBtn = "BtnPageRefine", szPage = "PageRefine" },
  { szBtn = "BtnPageMain", szPage = "PageMain" },
}

local nPos1 = 0
local nPos2 = 1
local nPos3 = 2

--local tbRefineCont1		= { nOffsetX = nPos1, bUse = 0, nRoom = Item.ROOM_ZHENYUAN_REFINE, bSendToGift = 1};
--local tbRefineCont2		= { nOffsetX = nPOs2, bUse = 0, nRoom = Item.ROOM_ZHENYUAN_REFINE, bSendToGift = 1};
--local tbRefineCont3		= { nOffsetX = nPos3, bUse = 0, nRoom = Item.ROOM_ZHENYUAN_REFINE, bSendToGift = 1};
local tbRefineCont1 = { bUse = 0, nRoom = Item.ROOM_ZHENYUAN_REFINE_MAIN, bSendToGift = 1 }
local tbRefineCont2 = { bUse = 0, nRoom = Item.ROOM_ZHENYUAN_REFINE_CONSUME, bSendToGift = 1 }
local tbRefineCont3 = { bUse = 0, nRoom = Item.ROOM_ZHENYUAN_REFINE_RESULT, bSendToGift = 1 }
local tbXiuLianCont = { bUse = 0, nRoom = Item.ROOM_ZHENYUAN_XIULIAN_ZHENYUAN, bSendToGift = 1 }
local tbBookCont = { bUse = 0, nRoom = Item.ROOM_ZHENYUAN_XIULIAN_ITEM, bSendToGift = 1 }

-- 炼化
function tbRefineCont1:CheckSwitchItem(pDrop, pPick, nX, nY)
  if pDrop then
    if Ui(Ui.UI_ZHENYUAN).nRefineResult == 1 then
      Ui(Ui.UI_ZHENYUAN).nRefineResult = 0
      Ui(Ui.UI_ZHENYUAN).tbObjRefine3:ClearRoom(nil, 0, 0)
    end

    local ret = Item.tbZhenYuan:CheckRefineItem(pDrop, 1)
    if 1 ~= ret then
      me.Msg(ret)
      return 0
    end

    -- todo delete
    --[[
		if (3 == nX) then
			return 0;		-- 炼化后真元格 不能放真元
		end
		
		if (pDrop.szClass ~= "zhenyuan") then
			me.Msg("只能放置真元！");
			return	0;
		end
		
		if(2 == nX) then
			if (1 == Item.tbZhenYuan:GetEquiped(pDrop)) then
				me.Msg("只能放置未护体的真元！");
				return 0;
			end
		elseif(1 == nX) then
			if(1 == Ui(Ui.UI_ZHENYUAN):IsPrefect(pDrop)) then
				me.Msg("该真元所有资质已满，不需要炼化！");
				return 0;
			end
		end	
		--]]
  end

  Ui(Ui.UI_ZHENYUAN):PlaceZhenYuanRefine(1, pDrop)

  return 1
end

function tbRefineCont2:CheckSwitchItem(pDrop, pPick, nX, nY)
  if pDrop then
    if Ui(Ui.UI_ZHENYUAN).nRefineResult == 1 then
      Ui(Ui.UI_ZHENYUAN).nRefineResult = 0
      Ui(Ui.UI_ZHENYUAN).tbObjRefine3:ClearRoom(nil, 0, 0)
    end

    local ret = Item.tbZhenYuan:CheckRefineItem(pDrop, 2)
    if 1 ~= ret then
      me.Msg(ret)
      return 0
    end

    -- todo delete
    --[[
		if (3 == nX) then
			return 0;		-- 炼化后真元格 不能放真元
		end
		
		if (pDrop.szClass ~= "zhenyuan") then
			me.Msg("只能放置真元！");
			return	0;
		end
		
		if(2 == nX) then
			if (1 == Item.tbZhenYuan:GetEquiped(pDrop)) then
				me.Msg("只能放置未护体的真元！");
				return 0;
			end
		elseif(1 == nX) then
			if(1 == Ui(Ui.UI_ZHENYUAN):IsPrefect(pDrop)) then
				me.Msg("该真元所有资质已满，不需要炼化！");
				return 0;
			end
		end	
		--]]
  end

  Ui(Ui.UI_ZHENYUAN):PlaceZhenYuanRefine(2, pDrop)

  return 1
end

function tbRefineCont3:CheckSwitchItem(pDrop, pPick, nX, nY)
  -- 始终能拿出来
  if pPick then
    Ui(Ui.UI_ZHENYUAN).nRefineResult = 0
    return 1
  end

  -- 不能放入
  return 0
end

-- 修炼
function tbXiuLianCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  if pDrop then
    if pDrop.szClass ~= "zhenyuan" then
      me.Msg("只能放置真元！")
      return 0
    end
    if Item.tbZhenYuan:GetLevel(pDrop) == 120 then
      me.Msg("该真元已经满级，不需要修炼了！")
      return 0
    end
  end
  Ui(Ui.UI_ZHENYUAN):PlaceZhenYuanXiuLian(pDrop)
  return 1
end

function tbBookCont:CheckSwitchItem(pDrop, pPick, nX, nY)
  if pDrop then
    if pDrop.szClass ~= "partnerexpbook" then
      me.Msg("只能放置同伴经验书！")
      return 0
    end
    -- todo 是否添加检测过多经验书
  end
  return Ui(Ui.UI_ZHENYUAN):PlaceExpBook(pDrop, pPick, nX, nY)
end

-- 判断真元所有资质是否已满
function uiZhenYuan:IsPrefect(pItem)
  local nAttrMax = 20
  if nAttrMax == Item.tbZhenYuan:GetAttribPotential1(pItem) and nAttrMax == Item.tbZhenYuan:GetAttribPotential2(pItem) and nAttrMax == Item.tbZhenYuan:GetAttribPotential3(pItem) and nAttrMax == Item.tbZhenYuan:GetAttribPotential4(pItem) then
    return 1
  end
  return 0
end

--uiZhenYuan.szTipRefine		= "请在上方放入真元，炼化后<color=orange>副真元将消失<color>！已护体真元只能作为主真元炼化。<enter>请选择炼化";
uiZhenYuan.tbTip = {
  {
    "请在上方放入真元，炼化后<color=orange>副真元将消失<color>！<enter>已护体真元只能作为主真元炼化。",
    "请选择炼化哪条属性资质（<color=red>需要银两2万<color>）:<enter>",
  }, -- 炼化

  {
    "★ 使用同伴经验书前，真元可先用历练经验升级！<enter>",
    "★ 使用同伴经验书修炼可快速升级（无数量限制）",
  }, -- 修炼
}

local nPXIULIAN = 1
local nPREFINE = 2
local nPGMAIN = 3
local nExpBookMaxNum = 18

function uiZhenYuan:CanOpenWnd()
  if Item.tbZhenYuan.bOpen and Item.tbZhenYuan.bOpen == 1 then
    return 1
  end

  Ui:ServerCall("UI_TASKTIPS", "Begin", "真元系统还未开放，敬请期待")
  return 0
end

function uiZhenYuan:Init()
  self.nCurPageIndex = nPREFINE
  self.nRefineResult = 0
end

function uiZhenYuan:OnCreate()
  self:CreateObjContainer()
end

-- 销毁OBJ容器
function uiZhenYuan:OnDestroy()
  tbObject:UnregContainer(self.tbObjRefine1)
  tbObject:UnregContainer(self.tbObjRefine2)
  tbObject:UnregContainer(self.tbObjRefine3)
  tbObject:UnregContainer(self.tbObjXiuLianZhenYuan)
  tbObject:UnregContainer(self.tbObjExpBook)
end

function uiZhenYuan:CreateObjContainer()
  -- 炼化格子
  self.tbObjRefine = {}
  for i = 1, 3 do
    --local tbCont = tbRefineCont;
    --tbCont.nOffsetX = i;
    --self.tbObjRefine[i].CheckSwitchItem = self.CheckSwitchItem;
  end

  self.tbObjRefine1 = tbObject:RegisterContainer(self.UIGROUP, (self.OBJ_REFINE .. 1), 1, 1, tbRefineCont1, "itemroom")

  self.tbObjRefine2 = tbObject:RegisterContainer(self.UIGROUP, (self.OBJ_REFINE .. 2), 1, 1, tbRefineCont2, "itemroom")

  self.tbObjRefine3 = tbObject:RegisterContainer(self.UIGROUP, (self.OBJ_REFINE .. 3), 1, 1, tbRefineCont3, "itemroom")

  -- 修炼 真元格子
  self.tbObjXiuLianZhenYuan = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_EXP, 1, 1, tbXiuLianCont, "itemroom")

  -- 修炼 经验书格子
  self.tbObjExpBook = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_EXPBOOK, 6, 3, tbBookCont, "itemroom")
end

function uiZhenYuan:OnOpen()
  me.ApplyZhenYuanEnhance(Item.tbZhenYuan.emZHENYUAN_ENHANCE_OPENWINDOW)

  if self.bFirstOpen then -- 第一次打开
    self.bFirstOpen = 1
    self:CreateObjContainer()
  end
  self.nCurPageIndex = nPXIULIAN --1.炼化分页，2.修炼分页
  self:UpdatePage(self.nCurPageIndex)
  self:UpdateObjCont()

  --UiManager:OpenWindow(Ui.UI_ITEMBOX);
end

function uiZhenYuan:OnClose()
  me.ApplyZhenYuanEnhance(Item.tbZhenYuan.emZHENYUAN_ENHANCE_NONE)
  if self.nCurPageIndex == nPREFINE then
    self:RefineCansel()
    UiManager:ReleaseUiState(UiManager.UIS_ZHENYUAN_REFINE)
  else
    self:XiuLianCansel()
    UiManager:ReleaseUiState(UiManager.UIS_ZHENYUAN_XIULIAN)
  end
end

function uiZhenYuan:OnButtonClick(szWnd, nParam)
  local nPage = self.nCurPageIndex
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_OK then
    if nPREFINE == nPage then
      self:ClickRefine()
    else
      self:ClickXiuLian()
    end
  elseif szWnd == self.BTN_CANSEL then
    UiManager:CloseWindow(self.UIGROUP)
    --[[
    elseif szWnd == self.BTNLEVEL1 then
    	self:ApplyLiLianExp(1);
    elseif szWnd == self.BTNLEVEL10 then
    	self:ApplyLiLianExp(2);
    elseif szWnd == self.BTNLEVELALL then
    	self:ApplyLiLianExp(3);
    	--]]
  elseif szWnd == self.BTN_LEVEL then
    -- TODO
    UiManager:CloseWindow(self.UIGROUP)
    me.CallServerScript({ "ZhenYuanCmd", "ApplyUseLilianTime" })
  elseif szWnd == self.BTN_UNBIND then
    me.CallServerScript({ "ZhenYuanCmd", "SwitchBind", me.nId, Item.SWITCHBIND_UNBIND })
  elseif szWnd == self.BTN_BIND then
    me.CallServerScript({ "ZhenYuanCmd", "SwitchBind", me.nId, Item.SWITCHBIND_BIND })
  elseif szWnd == self.BTN_APPLYUNBIND then
    me.CallServerScript({ "ZhenYuanCmd", "ApplyUnBind", me.nId })
  end

  for i = 1, 3 do
    if szWnd == self.tbPAGES[i].szBtn then
      self.nCurPageIndex = i
      self:UpdatePage(self.nCurPageIndex)
      return
    end
  end
end

function uiZhenYuan:UpdatePage(nPage)
  PgSet_ActivePage(self.UIGROUP, self.PAGE_SET, self.tbPAGES[nPage].szPage)
  Wnd_SetVisible(self.UIGROUP, self.BTN_OK, 1)
  Wnd_SetVisible(self.UIGROUP, self.BTN_CANSEL, 1)
  if nPREFINE == nPage then -- 炼化
    self:XiuLianCansel()
    Btn_SetTxt(self.UIGROUP, self.BTN_OK, "炼化")
    UiManager:ReleaseUiState(UiManager.UIS_ZHENYUAN_XIULIAN)
    UiManager:SetUiState(UiManager.UIS_ZHENYUAN_REFINE)
    self:UpdateTips(1)
  elseif nPXIULIAN == nPage then -- 修炼
    self:RefineCansel()
    self:UpdateLiLianInfo()
    Btn_SetTxt(self.UIGROUP, self.BTN_OK, "修炼")
    UiManager:ReleaseUiState(UiManager.UIS_ZHENYUAN_REFINE)
    UiManager:SetUiState(UiManager.UIS_ZHENYUAN_XIULIAN)
    self:UpdateTips(1)
  elseif nPGMAIN == nPage then
    Wnd_Hide(self.UIGROUP, self.BTN_OK)
    Wnd_Hide(self.UIGROUP, self.BTN_CANSEL)
    UiManager:ReleaseUiState(UiManager.UIS_ZHENYUAN_REFINE)
    UiManager:ReleaseUiState(UiManager.UIS_ZHENYUAN_XIULIAN)
    self:XiuLianCansel()
    self:RefineCansel()
    self:UpdateHelpPage()
  end
end

function uiZhenYuan:UpdateHelpPage()
  local nApplyTime = me.GetTask(Item.tbZhenYuan.TASK_GID_UNBIND, Item.tbZhenYuan.TASK_SUBID_UNBIND)
  if nApplyTime == 0 or GetTime() - nApplyTime < 0 or GetTime() - nApplyTime > Item.tbZhenYuan.UNBIND_MAX_TIME then
    Btn_SetTxt(self.UIGROUP, self.BTN_APPLYUNBIND, "申请解绑")
    Wnd_SetEnable(self.UIGROUP, self.BTN_UNBIND, 0)
  else
    Btn_SetTxt(self.UIGROUP, self.BTN_APPLYUNBIND, "取消解绑")
    if GetTime() - nApplyTime < Item.tbZhenYuan.UNBIND_MIN_TIME then
      Wnd_SetEnable(self.UIGROUP, self.BTN_UNBIND, 0)
    else
      Wnd_SetEnable(self.UIGROUP, self.BTN_UNBIND, 1)
    end
  end

  local szText = [[    真元是由1级同伴凝聚而来，只有部分同伴可以凝聚为真元，同伴界面有清楚的显示。<enter><color=green>1.真元属性<color>
	    每个真元有4条属性，属性值代表了该属性的等级，属性等级越高属性效果越好。<enter><color=green>2.真元属性资质星级<color>
	    真元每条属性下面的星级代表该属性的资质星级。星级越高，真元升级后提升的属性值越多。<enter><color=green>3.真元修炼<color>
	    修炼是指真元等级的提升，升级才能提升其属性值。<enter><color=green>4.真元炼化<color><enter>    真元属性资质星级的提升称为真元炼化。<enter><color=green>5.真元的价值<color>
	    属性资质星级决定了真元的价值，价值越高，排行榜排名越靠前，装备到角色身上后，附加的战斗力也越多。<enter><color=green>6.真元的绑定与解绑<color>
	    真元可以通过下面功能按钮将其绑定，当然也可以解绑。解除绑定需要申请解绑，申请时间是3天！
	    <color=orange>详细信息请参看F12帮助锦囊-详细帮助-真元<color>]]

  Txt_SetTxt(self.UIGROUP, self.TXT_ZHENYUANINTRODUCE, szText)
end

function uiZhenYuan:OnAnimationOver(szWnd)
  if szWnd == self.IMG_EFFECT then
    Wnd_Hide(self.UIGROUP, self.IMG_EFFECT) -- 播放完毕，隐藏图像
  end
end

function uiZhenYuan:OnListSel(szWnd, nParam)
  if szWnd == self.LST_ATTR then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LST_ATTR)
    self.nSelect = nKey
    local pItem = me.GetItem(Item.ROOM_ZHENYUAN_REFINE_CONSUME, 0, 0)
    if not pItem then
      Txt_SetTxt(self.UIGROUP, self.TXT_TIP, "请先放入副真元！")
      return
    end
    self:UpdateTips(2, self.tbAttrList[nKey].szTip)
    if self.nCurPageIndex == nPREFINE then
      self:UpdateRefine()
    end
  end
end

-- 更新页面正中的提示文字
function uiZhenYuan:UpdateTips(nTipId, szTipEx, szTipEx2)
  local nPage = self.nCurPageIndex
  if nPREFINE == nPage then
    local szTip = self.tbTip[1][nTipId]
    if szTipEx then
      szTip = szTip .. szTipEx
    end
    Txt_SetTxt(self.UIGROUP, self.TXT_TIP, szTip)
  else
    local szTip = self.tbTip[2][1]
    if szTipEx then
      szTip = szTip .. szTipEx
    end
    szTip = szTip .. "<enter>"
    szTip = szTip .. self.tbTip[2][2]
    if szTipEx2 then
      szTip = szTip .. szTipEx2
    end
    Txt_SetTxt(self.UIGROUP, self.TXT_TIPEXP, szTip)
  end
end

-- 炼化面板：放入真元 nType = 1 主真元 or = 2  副真元 or = 0 清空
function uiZhenYuan:PlaceZhenYuanRefine(nType, pItem)
  self:UpdateTips(1)
  if not nType or 0 == nType then
    self.tbAttrList = nil
    self:UpdateAttrList()
    return
  end

  local pLocItem1 = nil
  local pLocItem2 = nil

  if 1 == nType then
    pLocItem1 = pItem
    pLocItem2 = self:GetZhenYuanRefine2()
  end

  if 2 == nType then
    pLocItem1 = self:GetZhenYuanRefine1()
    pLocItem2 = pItem
  end

  if pLocItem1 then -- 主真元
    self:UpdateTips(1)
    self.tbAttrList = {}

    local tbAttrName = {}
    for i = 1, 4 do
      local nAttrMagicId = Item.tbZhenYuan:GetAttribMagicId(pLocItem1, i)
      local szAttrName = Item.tbZhenYuan:GetAttribTipName(nAttrMagicId)
      tbAttrName[i] = szAttrName
    end
    local tbAttrVal = {}
    tbAttrVal[1] = Item.tbZhenYuan:GetAttribPotential1(pLocItem1)
    tbAttrVal[2] = Item.tbZhenYuan:GetAttribPotential2(pLocItem1)
    tbAttrVal[3] = Item.tbZhenYuan:GetAttribPotential3(pLocItem1)
    tbAttrVal[4] = Item.tbZhenYuan:GetAttribPotential4(pLocItem1)
    for i = 1, 4 do
      local szAttrStar = Item.tbZhenYuan:GetAttribStar(tbAttrVal[i])
      self.tbAttrList[i] = { string.format("%s： ", tbAttrName[i]), string.format("<color=gold>%s<color>", szAttrStar), "", color = nil, szTip = nil }
    end

    if pLocItem2 then -- 副真元
      if not self.tbAttrList then
        print("[zhenyuan]:self.tbAttrList is nil")
        return
      end

      local tbResult = Item.tbZhenYuan:GetAttribRefineInfo(pLocItem1, pLocItem2)
      if tbResult then
        for i = 1, 4 do
          if tbResult[i] then
            --self.tbAttrList[i].color = "green";
            local nAddedMin = tbResult[i][1][1]
            local szStarAddedMin = Item.tbZhenYuan:GetAttribStar(nAddedMin)
            local nMinProb = tbResult[i][1][2]
            local nAddedMax = tbResult[i][2][1]
            local szStarAddedMax = Item.tbZhenYuan:GetAttribStar(nAddedMax)
            local nMaxProb = tbResult[i][2][2]

            self.tbAttrList[i][1] = string.format("<color=green>%s<color>", self.tbAttrList[i][1])
            self.tbAttrList[i][3] = string.format("<color=green>增加<color> <color=gold>%s<color>", szStarAddedMin)
            --self.tbAttrList[i].szTip = string.format("<color=orange> %d%%概率增加 <color><color=gold>%s<color>", nMinProb, szStarAddedMin); -- 提示语句
            self.tbAttrList[i].szTip = string.format("<color=orange>%d%%概率额外增加<color> <color=gold>%s<color>", (100 - nMinProb), "☆")
          end
        end
      end
      self:UpdateTips(2)
    end
  else
    self.tbAttrList = nil
  end

  self:UpdateAttrList(self.tbAttrList)
end

function uiZhenYuan:GetStarStr(dwValue)
  local szStar = ""
  local nFloor = math.floor(dwValue)
  for i = 1, nFloor do
    szStar = szStar .. "★"
  end
  if dwValue ~= nFloor then
    szStar = szStar .. "☆"
  end
  return szStar
end

--[[
-- 炼化的真元， nPos = 1->3 对应 主真元、副真元、炼化后真元
function uiZhenYuan:GetZhenYuanRefine(nPos)
	-- todo change
	if (nPos1 == nPos) then
		--
		return self.pItem1;
	else
		--return me.GetItem(Item.ROOM_ZHENYUAN_REFINE_CONSUME, 0, 0);
		return self.pItem2;
	end
end
--]]

-- 炼化主真元
function uiZhenYuan:GetZhenYuanRefine1()
  return me.GetItem(Item.ROOM_ZHENYUAN_REFINE_MAIN, 0, 0)
end

-- 炼化副真元
function uiZhenYuan:GetZhenYuanRefine2()
  return me.GetItem(Item.ROOM_ZHENYUAN_REFINE_CONSUME, 0, 0)
end

-- 修炼的真元
function uiZhenYuan:GetZhenYuanXiuLian()
  local pItem = me.GetItem(Item.ROOM_ZHENYUAN_XIULIAN_ZHENYUAN, 0, 0)
  return pItem
end

-- 格子中的经验书 nX、nY除外
function uiZhenYuan:GetExpBookTab(pDrop, pPick, nX, nY)
  local tbExpBook = {}

  local nCnt = 1
  -- 经验书格子为 3*6 共18个
  for i = 0, 5 do
    for j = 0, 2 do
      local pItem = me.GetItem(Item.ROOM_ZHENYUAN_XIULIAN_ITEM, i, j)
      if pItem and (i ~= nX or j ~= nY) then
        tbExpBook[nCnt] = pItem
        nCnt = nCnt + 1
      end
    end
  end

  if pDrop then
    --tbExpBook[nY * 6 + nX] = pDrop;
    tbExpBook[nCnt] = pDrop
  end

  return tbExpBook
end

-- 更新真元属性列表
function uiZhenYuan:UpdateAttrList(tbAttrList)
  Lst_Clear(self.UIGROUP, self.LST_ATTR)
  if not tbAttrList then
    return
  end
  for i = 1, #tbAttrList do
    local szCell1 = tbAttrList[i][1]
    local szCell2 = tbAttrList[i][2]
    local szCell3 = tbAttrList[i][3]
    local szColor = tbAttrList[i].color
    if szColor and string.len(szColor) > 0 then
      szCell1 = string.format("<color=%s>%s<color>", szColor, tbAttrList[i][1])
      szCell2 = string.format("<color=%s>%s<color>", szColor, tbAttrList[i][2])
      szCell3 = string.format("<color=%s>%s<color>", szColor, tbAttrList[i][3])
    end
    Lst_SetCell(self.UIGROUP, self.LST_ATTR, i, 1, szCell1)
    Lst_SetCell(self.UIGROUP, self.LST_ATTR, i, 2, szCell2)
    Lst_SetCell(self.UIGROUP, self.LST_ATTR, i, 3, szCell3)
  end
end

-- 点击按钮 炼化
function uiZhenYuan:ClickRefine()
  local pItemRefine = self:GetZhenYuanRefine1() -- 主真元
  local pItemSub = self:GetZhenYuanRefine2() -- 副真元
  if (not pItemRefine) or not pItemSub then
    me.Msg("请先放入欲炼化的主副真元！")
    return
  end

  local nSelectAttrId = Lst_GetCurKey(self.UIGROUP, self.LST_ATTR)
  if not nSelectAttrId or nSelectAttrId <= 0 or nSelectAttrId > Item.tbZhenYuan.ATTRIB_COUNT then
    me.Msg("请选择您需要炼化的属性资质进行炼化！")
    return
  end

  local nAttrMagicId = Item.tbZhenYuan:GetAttribMagicId(pItemRefine, nSelectAttrId)
  --local szSubZhenYuan  = pItemSub.szName;

  -- 炼化
  local nRet = Item.tbZhenYuan:ApplyRefine(pItemRefine, pItemSub, nAttrMagicId)
end

-- 鼠标掠过列表
function uiZhenYuan:OnListOver(szWnd, nItemIndex)
  local nAttrId = Lst_GetCurKey(self.UIGROUP, self.LST_ATTR) + 1
  if (szWnd == self.LIST_MEMBER) and nItemIndex >= 0 then
    nAttrId = nItemIndex + 1
    --self.szTipSelected = self.tbAttrList[nAttrId].szTip;
  end
  --self:UpdateTips(2, self.tbAttrList[nAttrId].szTip);
end

-- 取消炼化
function uiZhenYuan:RefineCansel()
  -- todo
  for i = 1, 3 do
    --self.tbObjRefine[i]:ClearRoom();
  end
  self.tbObjRefine1:ClearRoom()
  self.tbObjRefine2:ClearRoom()
  self.tbObjRefine3:ClearRoom()
  self:PlaceZhenYuanRefine()
end

-- 点击按钮 修炼
function uiZhenYuan:ClickXiuLian()
  me.ApplyZhenYuanEnhance(Item.tbZhenYuan.emZHENYUAN_ENHANCE_XIULIAN)
end

-- todo 错误反馈

-- 取消修炼
function uiZhenYuan:XiuLianCansel()
  -- todoo
  self.tbObjXiuLianZhenYuan:ClearRoom()
  self.tbObjExpBook:ClearRoom()
  self:PlaceZhenYuanXiuLian()
end

-- 放入真元 修炼
function uiZhenYuan:PlaceZhenYuanXiuLian(pItem)
  self:UpdateTips(1)

  if not pItem then
    --self:UpdateTips(1);
    return
  end

  local tbExpBook = self:GetExpBookTab()

  self:UpdateXiuLianTip(pItem, tbExpBook)
end

function uiZhenYuan:PlaceExpBook(pDrop, pPick, nX, nY)
  local tbExpBook = self:GetExpBookTab(pDrop, pPick, nX, nY)

  local pZhenYuan = self:GetZhenYuanXiuLian()
  if not pZhenYuan then
    me.Msg("请先放入要修炼的真元！")
    return 0
  end
  --[[
	if (pDrop) then
		table.insert(tbExpBook, pDrop);
	end--]]

  return self:UpdateXiuLianTip(pZhenYuan, tbExpBook)
end

function uiZhenYuan:UpdateXiuLianTip(pItem, tbExpBook)
  local szTipEx1 = ""
  local szTipEx2 = ""
  if not pItem then
    self:UpdateTips(1, "", "")
    return 0
  end

  local nLevelOld = Item.tbZhenYuan:GetLevel(pItem)

  if tbExpBook and Lib:CountTB(tbExpBook) >= 1 then
    local bOver, nLevelNew, nExpRemain = Item.tbZhenYuan:GetExpAdded(pItem, tbExpBook)
    if 1 == bOver then
      me.Msg("您放入的同伴经验书太多！")
      return 0
    end
    szTipEx2 = string.format("   真元等级：%0.2f <color=gold>→ %0.2f<color><enter>", nLevelOld, nLevelNew)
  end

  local nLiLianTime = me.GetTask(Item.tbZhenYuan.EXPSTORE_TASK_MAIN, Item.tbZhenYuan.EXPSTORE_TASK_SUB)
  if 0 < nLiLianTime then
    local nLevelUp = Item.tbZhenYuan:CalExpFromTime(pItem, nLiLianTime)
    if 0 < math.floor(nLevelUp) then
      szTipEx1 = string.format("   目前的历练经验最多可使该真元升至<color=gold>%d级<color>！", (nLevelOld + nLevelUp))
    end
  end
  self:UpdateTips(1, szTipEx1, szTipEx2)
  return 1
end

function uiZhenYuan:UpdateRefine()
  for i = 1, 3 do
    --Lib:ShowTB(self.tbObjRefine[i]);
    --self.tbObjRefine[i]:UpdateRoom();
  end
end

function uiZhenYuan:UpdateXiuLian()
  self:UpdateLiLianInfo()
  --self.tbObjXiuLianZhenYuan:UpdateRoom();
  --self.tbObjExpBook:UpdateRoom();
end

function uiZhenYuan:UpdateLiLianInfo()
  local nLiLianTime = me.GetTask(Item.tbZhenYuan.EXPSTORE_TASK_MAIN, Item.tbZhenYuan.EXPSTORE_TASK_SUB)
  local tbEnable = { 0, 0, 0 }
  local pItem = me.GetItem(Item.ROOM_ZHENYUAN_XIULIAN_ZHENYUAN, 0, 0)

  if pItem and nLiLianTime > 0 then
    local nLevelUp = Item.tbZhenYuan:CalExpFromTime(pItem, nLiLianTime)
    if nLevelUp >= 1 then
      tbEnable[1] = 1
    end

    if nLevelUp >= 10 then
      tbEnable[2] = 1
    end
  end

  if nLiLianTime > 0 then
    tbEnable[3] = 1
    Wnd_SetEnable(self.UIGROUP, self.BTN_LEVEL, 1)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_LEVEL, 0)
  end

  --[[
	Wnd_SetEnable(self.UIGROUP,		self.BTNLEVEL1, 	tbEnable[1]);
	Wnd_SetEnable(self.UIGROUP,		self.BTNLEVEL10, 	tbEnable[2]);
	Wnd_SetEnable(self.UIGROUP,		self.BTNLEVELALL, 	tbEnable[3]);
	--]]

  local szTime = "历练经验<enter>"
  szTime = szTime .. string.format("%d时%d分", math.floor(nLiLianTime / 60), nLiLianTime % 60)
  Txt_SetTxt(self.UIGROUP, self.TXT_BALANCEEXP, szTime)
end

function uiZhenYuan:OnSyncItem(nRoom, nX, nY)
  self:UpdateObjCont()
end

function uiZhenYuan:UpdateObjCont()
  local nPage = self.nCurPageIndex
  if nPREFINE == nPage then
    self:UpdateRefine()
  else
    self:UpdateXiuLian()
  end
end

-- 注册事件更新回调
function uiZhenYuan:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnSyncItem },
    { UiNotify.emCOREEVENT_ENHANCE_ZHENYUAN_RESULT, self.OnResult },
    { UiNotify.emUIEVENT_OBJ_STATE_USE, self.StateRecvUse },
  }
  for i = 1, 3 do
    --tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbObjRefine[i]:RegisterEvent());
  end
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbObjRefine1:RegisterEvent())
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbObjRefine2:RegisterEvent())
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbObjRefine3:RegisterEvent())
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbObjXiuLianZhenYuan:RegisterEvent())
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbObjExpBook:RegisterEvent())
  return tbRegEvent
end

-- 注册技能界面OBJ的消息回调
function uiZhenYuan:RegisterMessage()
  local tbRegMsg = {}
  for i = 1, 3 do
    --tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbObjRefine[i]:RegisterMessage());
  end
  tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbObjRefine1:RegisterMessage())
  tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbObjRefine2:RegisterMessage())
  tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbObjRefine3:RegisterMessage())
  tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbObjXiuLianZhenYuan:RegisterMessage())
  tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbObjExpBook:RegisterMessage())
  return tbRegMsg
end

function uiZhenYuan:OnResult(nMode, nResult)
  if Item.tbZhenYuan.emZHENYUAN_ENHANCE_REFINE == nMode then
    if nResult == 1 then
      Item.tbZhenYuan:RefineResult(self.tbObjRefine1, self.tbObjRefine3)
      -- 播放特效
      Wnd_Show(self.UIGROUP, self.IMG_EFFECT)
      Img_PlayAnimation(self.UIGROUP, self.IMG_EFFECT)

      -- 炼化成功之后，结果格子中有东西，在下次做操作的时候要将这个格子里的东西弹出
      self.nRefineResult = 1

      local pItemRefine = self:GetZhenYuanRefine1() -- 主真元
      local pItemSub = self:GetZhenYuanRefine2() -- 副真元
      if not pItemRefine or not pItemSub then
        return
      end
    else
      me.Msg("真元无法炼化!")
    end
    self:UpdateTips(1)
  elseif Item.tbZhenYuan.emZHENYUAN_ENHANCE_XIULIAN == nMode then
    --self.tbObjXiuLianZhenYuan:ClearRoom();
    self.tbObjExpBook:ClearRoom()
    self:UpdateLiLianInfo()

    self:UpdateXiuLianTip()
  end
end

function uiZhenYuan:ApplyLiLianExp(nType)
  local pItem = me.GetItem(Item.ROOM_ZHENYUAN_XIULIAN_ZHENYUAN, 0, 0)
  if pItem then
    me.CallServerScript({ "ZhenYuanCmd", "ApplyUseLilianTime", pItem.dwId, nType })
  else
    me.Msg("请先放入要增加经验的真元！")
  end
end

function uiZhenYuan:OnMouseEnter(szWnd)
  local szTip = ""
  if szWnd == self.BTNLEVELALL or szWnd == self.BTNLEVEL1 or szWnd == self.BTNLEVEL10 then
    szTip = "使用历练经验提升真元等级，可选择升级幅度<enter>若真元满级，则剩余历练经验仍将累积并可使用"
  end
  if szWnd == self.BTN_LEVEL then
    szTip = "使用历练经验提升真元等级, 可放入多个真元！"
  end

  if szTip ~= "" then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
  end
end

function uiZhenYuan:StateRecvUse(szUiGroup)
  if szUiGroup == self.szUiGroup then
    return
  end

  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end

  if self.nCurPageIndex ~= nPXIULIAN then
    return
  end

  local tbObj = tbMouse:GetObj()
  if not tbObj then
    return
  end
  local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)

  if pItem.IsEquip() == 1 then
    self.tbObjXiuLianZhenYuan:ClearRoom()
    self.tbObjXiuLianZhenYuan:SpecialStateRecvUse()
  else
    self.tbObjExpBook:SpecialStateRecvUse()
  end
end
