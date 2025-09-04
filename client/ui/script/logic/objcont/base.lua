-- UI Object容器基类（通用逻辑）

local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbPreViewMgr = Ui.tbLogic.tbPreViewMgr
local tbBase = tbObject.tbContClass.base

------------------------------------------------------------------------------------------

tbBase.CDSPIN_MEDIUM = "\\image\\icon\\other\\cd_36x36.spr"
tbBase.CDSPIN_SMALL = "\\image\\icon\\other\\cd_18x18.spr"
tbBase.CDFLASH_MEDIUM = "\\image\\icon\\other\\cd_flash.spr"
tbBase.UNKNOW_ITEM_IMAGE = "\\image\\item\\other\\scriptitem\\unknown_item.spr"

tbBase.tbEffect = {
  [1] = "\\image\\effect\\other\\new_cheng1.spr",
  [2] = "\\image\\effect\\other\\new_cheng2.spr",
  [3] = "\\image\\effect\\other\\new_jin1.spr",
  [4] = "\\image\\effect\\other\\new_jin2.spr",
  [5] = "\\image\\effect\\other\\new_jin3.spr",
}

tbBase.szUnbindEffect = "\\image\\effect\\other\\img_unbind.spr"
function tbBase:init()
  self.szUiGroup = "" -- 该容器所对应ObjGrid控件所在UIGROUP
  self.szObjGrid = "" -- 该容器所对应ObjGrid控件名
  self.nRow = 0 -- 容器列数（宽度，单位Object）
  self.nLine = 0 -- 容器行数（高度，单位Object）
  self.tbObjs = {} -- Object数据表
  self.bShowCd = 1 -- 是否显示CD时间特效
  self.bSwitch = 1 -- 是否允许切换操作
  self.bUse = 1 -- 是否允许使用操作
  self.bLink = 1 -- 是否允许链接操作
  self.bPreView = 1 -- 是否允许预览
  self.bEnterLeave = 1 -- 是否响应鼠标进入离开
  self.bSendToGift = 0 -- 是否右键发送到给予界面
end

------------------------------------------------------------------------------------------
-- 通用接口方法

-- 获得容器中指定位置的Object数据
function tbBase:GetObj(nX, nY)
  nX = nX or 0
  nY = nY or 0
  if (nX < 0) or (nX >= self.nRow) or (nY < 0) or (nY >= self.nLine) then
    return
  end
  if not self.tbObjs[nY] then
    return
  end
  return self.tbObjs[nY][nX]
end

-- 将容器的指定位置设为指定Object
function tbBase:SetObj(tbObj, nX, nY)
  nX = nX or 0
  nY = nY or 0
  if (nX < 0) or (nX >= self.nRow) or (nY < 0) or (nY >= self.nLine) then
    return
  end

  if tbObj and (tbObject:CheckObj(tbObj) ~= 1) then
    Ui:Output("[ERR] 尝试放入格式不合法的Object！", tbObj)
    return
  end

  if self:CanSetObj(tbObj, nX, nY) ~= 1 then
    return
  end

  tbObj = self:PreSetObj(tbObj) -- tbObj预处理
  if tbObj then -- 放入
    if not self.tbObjs[nY] then
      self.tbObjs[nY] = {}
    end
    self:DoSetObj(nX, nY, tbObj) -- 加入到tbObjs
    self:DropObj(tbObj, nX, nY)
  else -- 拿出
    self:PickObj(nX, nY)
    if self.tbObjs[nY] then
      self:DoSetObj(nX, nY, nil) -- 从tbObjs移除
    end
  end
end

-- 清除容器中所有Object
function tbBase:ClearObj()
  for nY = 0, self.nLine - 1 do
    for nX = 0, self.nRow - 1 do
      self:PickObj(nX, nY)
      if self.tbObjs[nY] then
        self.tbObjs[nY][nX] = nil -- 从tbObjs移除
      end
    end
  end
end

-- 在容器来查找指定Object
function tbBase:FindObj(tbFind)
  local tbResult = {}
  if (not tbFind) or (tbObject:CheckObj(tbFind) ~= 1) then
    return tbResult
  end

  local fnCmp = self.FIND_COMPARE[tbFind.nType]
  for j = 0, self.nLine - 1 do
    if self.tbObjs[j] then
      for i = 0, self.nRow - 1 do
        local tbObj = self.tbObjs[j][i]
        if tbObj and (fnCmp(tbObj, tbFind) == 1) then
          table.insert(tbResult, { tbObj, i, j }) -- 返回Object数据结构，X坐标和Y坐标
        end
      end
    end
  end

  return tbResult
end

-- 根据指定条件搜索全部符合的Object
function tbBase:SearchObj(fnCond)
  local tbResult = {}
  for j = 0, self.nLine - 1 do
    if self.tbObjs[j] then
      for i = 0, self.nRow - 1 do
        local tbObj = self.tbObjs[j][i]
        if tbObj then
          if fnCond(tbObj) == 1 then
            table.insert(tbResult, { tbObj, i, j }) -- 放入搜索结果，继续遍历
          end
        end
      end
    end
  end
  return tbResult
end

-- 更新容器中指定位置的Object
function tbBase:Update(nX, nY)
  local tbObj = self:GetObj(nX, nY)
  if not tbObj then
    return
  end
  self:UpdateObj(tbObj, nX, nY)
end

-- 使用容器中指定位置的Object
function tbBase:Use(nX, nY)
  local tbObj = self:GetObj(nX, nY)
  if not tbObj then
    return
  end
  self:UseObj(tbObj, nX, nY)
end

-- 更新容器中所有Object
function tbBase:UpdateAll()
  for j = 0, self.nLine - 1 do
    for i = 0, self.nRow - 1 do
      self:Update(i, j)
    end
  end
end

------------------------------------------------------------------------------------------
-- 非固定逻辑，可根据具体需要覆盖，这里提供的是最常用的逻辑

function tbBase:CanSetObj(tbObj, nX, nY)
  return 1
end

function tbBase:PreSetObj(tbObj)
  return tbObj
end

function tbBase:DoSetObj(nX, nY, tbObj)
  self.tbObjs[nY][nX] = tbObj
end

-- 传给ObjGrid控件的格式化tbObj格式：
-- 	{
--		szBgImage		: 背景图素，nil则不显示
--		szCdSpin		: CD旋转特效图素，nil则不显示
--		szCdFlash		: CD闪光特效图素，nil则不显示
--		bShowSubScript	: 是否显示下标，默认为不显示
--		tbLayer			: 图层列表
--		tbSort			: 图层排序表
--	};

-- 将NPC具数据格式化为ObjGrid控件识别的Object格式
function tbBase:FormatNpc(tbNpc)
  local tbObj = {}
  local pNpc = tbNpc.pNpc
  if not pNpc then
    return
  end
  -- TODO:
  return tbObj
end

function tbBase:FormatNpcRes(tbNpcRes)
  local INTERVAL = 240 -- 绘制帧间隔时间，毫秒
  local tbObj = {}
  local tbRes = KNpc.GetNpcRes(tbNpcRes.nTemplateId, tbNpcRes.nAction, tbNpcRes.tbPart, tbNpcRes.bRideHorse)
  if tbRes then
    local tbLayer = {}
    local tbShadow = tbRes.tbShadow
    if tbShadow then
      local tb = {}
      tb.szImage = tbShadow.szFileName
      tb.nInterval = INTERVAL
      tb.nUseDir = tbNpcRes.nDir
      table.insert(tbLayer, tb)
    end
    local tbRes2Layer = {}
    for i, tbPart in pairs(tbRes.tbPart) do
      for j, tbSect in pairs(tbPart.tbSect) do
        local tb = {}
        tb.szImage = tbSect.szFileName
        tb.nInterval = INTERVAL
        tb.nUseDir = tbNpcRes.nDir
        tb.nChangeColor = tbPart.nChangeColor
        tb.bUseOffset = tbNpcRes.tbOffset and tbNpcRes.tbOffset[i].bUseOffset or 0
        tb.nOffsetX = tbNpcRes.tbOffset and tbNpcRes.tbOffset[i].nOffsetX or 0
        tb.nOffsetY = tbNpcRes.tbOffset and tbNpcRes.tbOffset[i].nOffsetY or 0
        table.insert(tbLayer, tb)
        tbRes2Layer[i * 4 + j] = #tbLayer - 1
      end
    end
    local tbSort = {}
    for i, tb in ipairs(tbRes.tbSort) do
      if tbShadow then
        tbSort[i] = { 0 } -- 影子总是第一个画的图层
      else
        tbSort[i] = {}
      end
      for j, v in ipairs(tb) do
        local nIndex = tbRes2Layer[v]
        if nIndex then
          table.insert(tbSort[i], nIndex)
        end
      end
    end
    tbObj.tbLayer = tbLayer
    tbObj.tbSort = tbSort
  end
  return tbObj
end

-- 将道具数据格式化为ObjGrid控件识别的Object格式
function tbBase:FormatItem(tbItem)
  local tbObj = {}
  local pItem = tbItem.pItem
  if not pItem then
    return
  end
  local tbImageParam = GetImageParam(pItem.szIconImage, 1)
  if not tbImageParam then --如果道具图素不存在，则用默认资源替代
    tbObj.szBgImage = self.UNKNOW_ITEM_IMAGE
  else
    tbObj.szBgImage = pItem.szIconImage
  end
  tbObj.szCdSpin = self.CDSPIN_MEDIUM
  tbObj.szCdFlash = self.CDFLASH_MEDIUM
  if pItem.nMaxCount > 1 then
    tbObj.bShowSubScript = 1 -- 如果是可叠加物品则显示下标数字
  end
  return tbObj
end

-- 将道具数据格式化为ObjGrid控件识别的Object格式
function tbBase:FormatOwnItem(tbOwnItem)
  local pItem = me.GetItem(tbOwnItem.nRoom, tbOwnItem.nX, tbOwnItem.nY)
  if not pItem then
    return
  end
  local tbItem = {}
  tbItem.nType = Ui.OBJ_ITEM
  tbItem.pItem = pItem
  return self:FormatItem(tbItem)
end

-- 将战斗技能数据格式化为ObjGrid控件识别的Object格式
function tbBase:FormatFightSkill(tbFightSkill)
  local tbObj = {}
  local nSkillId = tbFightSkill.nSkillId
  if KFightSkill.IsValidSkill(nSkillId) ~= 1 then
    return
  end
  tbObj.szBgImage = KFightSkill.GetSkillIcon(nSkillId)
  tbObj.szCdSpin = self.CDSPIN_MEDIUM
  tbObj.szCdFlash = self.CDFLASH_MEDIUM
  return tbObj
end

-- 将生活技能数据格式化为ObjGrid控件识别的Object格式
function tbBase:FormatLifeSkill(tbLifeSkill)
  local tbObj = {}
  local nSkillId = tbLifeSkill.nSkillId
  local tbLifeSkillData = LifeSkill.tbLifeSkillDatas[nSkillId]
  if not tbLifeSkillData then
    return
  end
  tbObj.szBgImage = tbLifeSkillData.Icon
  return tbObj
end

-- 将角色头像数据格式化为ObjGrid控件识别的Object格式
function tbBase:FormatPortrait(tbPortrait)
  local tbObj = {}
  local bSmall = (tbPortrait.bSmall == 1) and 1 or 0
  local szIcon = GetPortraitSpr(tbPortrait.nIndex, tbPortrait.bSex, bSmall)
  if szIcon == "" then
    return
  end
  tbObj.szBgImage = szIcon
  return tbObj
end

-- 将角色状态数据格式化为ObjGrid控件识别的Object格式
function tbBase:FormatBuff(tbBuff)
  local tbObj = {}
  local nBuffId = tbBuff.nBuffId
  local tbInfo = me.GetBuffInfo(nBuffId)
  if not tbInfo then
    return
  end
  tbObj.szBgImage = tbInfo.szIcon
  tbObj.szCdSpin = self.CDSPIN_SMALL
  return tbObj
end

-- 将任务数据格式化为ObjGrid控件识别的Object格式
function tbBase:FormatTaskIcon(tbTaskIcon)
  local tbObj = {}
  local szIcon = KTask.GetIconPath(tbTaskIcon.nIndex)
  if szIcon == "" then
    return
  end
  tbObj.szBgImage = szIcon
  if tbTaskIcon.nCount then
    tbObj.bShowSubScript = 1
  end
  return tbObj
end

-- 更新道具Object
function tbBase:UpdateItem(tbItem, nX, nY)
  local pItem = tbItem.pItem

  -- 不管是否显示叠加数目都把下标设上，以免一些需要中途显示的情况，因为数据同步造成的显示错误
  ObjGrid_ChangeSubScript(self.szUiGroup, self.szObjGrid, tostring(pItem.nCount), nX, nY)

  -- 显示背景色
  local nColor = (me.CanUseItem(pItem) ~= 1) and 0x60ff0000 or 0 -- 不可使用道具设置半透明红色背景色
  if me.GetStallPrice(pItem) then
    nColor = 0x30ff8000
    if UiManager:GetUiState(UiManager.UIS_BEGIN_STALL) == 1 then
      nColor = 0x60ffff00 -- 摆摊物品背景色
    end
  elseif me.GetOfferReq(pItem) then
    nColor = 0x3080c0ff
    if UiManager:GetUiState(UiManager.UIS_BEGIN_OFFER) == 1 then
      nColor = 0x60ffff00 -- 收购物品背景色
    end
  end
  ObjGrid_ChangeBgColor(self.szUiGroup, self.szObjGrid, nColor, nX, nY)

  -- TODO: 设置光环

  ObjGrid_SetTransparency(self.szUiGroup, self.szObjGrid, pItem.szTransparencyIcon, nX, nY) -- 设置透明图层
  ObjGrid_SetMaskLayer(self.szUiGroup, self.szObjGrid, pItem.szMaskLayerIcon, nX, nY) -- 设置掩膜图层

  --设置道具特效
  if pItem.nObjEffect and self.tbEffect[pItem.nObjEffect] then
    ObjGrid_SetTransparency(self.szUiGroup, self.szObjGrid, self.tbEffect[pItem.nObjEffect], nX, nY)
  end
  --	self:UpdateItemCd(pItem.nCdType);		-- 更新CD时间特效	-- TODO: xyf 因为效率问题先注释掉
  -- TODO: xyf 这段代码效率比较高，但是会造成多次打开关闭后不同步
  local nCdTime = Lib:FrameNum2Ms(GetCdTime(pItem.nCdType)) -- 总CD时间
  if nCdTime > 0 then
    local nCdPass = Lib:FrameNum2Ms(me.GetCdTimePass(pItem.nCdType)) -- 已经过CD时间
    ObjGrid_PlayCd(self.szUiGroup, self.szObjGrid, nCdTime, nCdPass, nX, nY)
  end
  --if pItem.IsBind() ~= 1 then
  --	ObjGrid_SetTransparency2(self.szUiGroup, self.szObjGrid, self.szUnbindEffect, nX, nY);
  --end
end

-- 更新属于自己的道具Object
function tbBase:UpdateOwnItem(tbOwnItem, nX, nY)
  local pItem = me.GetItem(tbOwnItem.nRoom, tbOwnItem.nX, tbOwnItem.nY)
  if not pItem then
    return
  end
  local tbItem = {}
  tbItem.nType = Ui.OBJ_ITEM
  tbItem.pItem = pItem
  return self:UpdateItem(tbItem, nX, nY)
end

-- 更新战斗技能Object
function tbBase:UpdateFightSkill(tbFightSkill, nX, nY)
  local nSkillId = tbFightSkill.nSkillId
  local tbTime = nil
  -- 在载具上
  if me.IsInCarrier() == 1 then
    local pCarrier = me.GetCarrierNpc()
    if pCarrier then
      tbTime = pCarrier.GetFightSkillCastTime(nSkillId)
    else
      return
    end
  else
    tbTime = me.GetNpc().GetFightSkillCastTime(nSkillId)
  end
  -- 播放CD特效，注意Core接口提供的单位是逻辑帧数，要换算为毫秒
  local nCdTime = Lib:FrameNum2Ms(tbTime.nDelay)
  local nCdPass = Lib:FrameNum2Ms(tbTime.nPass)

  local nMaxUsePoint = me.GetNpc().GetSkillMaxUsePoint(nSkillId)
  if nMaxUsePoint == 0 then
    ObjGrid_ChangeSubScript(self.szUiGroup, self.szObjGrid, "", nX, nY or 0)
    ObjGrid_PlayCd(self.szUiGroup, self.szObjGrid, nCdTime, nCdPass, nX, nY or 0)
  else
    ObjGrid_ShowSubScript(self.szUiGroup, self.szObjGrid, 1, nX, nY or 0)
    local nUsePoint = me.GetNpc().GetSkillUsePoint(nSkillId)
    local nUsePointChanged = Ui(Ui.UI_SHORTCUTBAR):SetSkillUsePoint(nSkillId, nUsePoint)
    local szUsePoint = nUsePoint / 100 .. "/" .. nMaxUsePoint / 100
    local szSubScript = ObjGrid_GetSubScript(self.szUiGroup, self.szObjGrid, nX, nY or 0)
    ObjGrid_ChangeSubScript(self.szUiGroup, self.szObjGrid, szUsePoint, nX, nY or 0)
    if szSubScript then -- 有下标的根据下标判断
      local nSeparate = string.find(szUsePoint, "/")
      local szSubUsePoint = string.sub(szSubScript, 1, nSeparate - 1)
      local nSubUsePoint = nUsePoint
      if tonumber(szSubUsePoint) then
        nSubUsePoint = tonumber(szSubUsePoint) * 100
      end

      if nUsePoint - nSubUsePoint >= 100 and nUsePoint >= 100 then
        ObjGrid_PlayCd(self.szUiGroup, self.szObjGrid, nCdTime, nCdTime, nX, nY or 0)
      elseif nUsePoint < 100 then
        ObjGrid_PlayCd(self.szUiGroup, self.szObjGrid, nCdTime, nCdPass, nX, nY or 0)
      end
    else
      if nUsePointChanged == 1 and nUsePoint >= 100 and nUsePoint / 100 == math.floor(nUsePoint / 100) then
        ObjGrid_PlayCd(self.szUiGroup, self.szObjGrid, nCdTime, nCdTime, nX, nY or 0)
      elseif nUsePoint < 100 then
        ObjGrid_PlayCd(self.szUiGroup, self.szObjGrid, nCdTime, nCdPass, nX, nY or 0)
      end
    end
  end

  if me.IsInCarrier() == 1 then
    ObjGrid_ChangeMaskColor(self.szUiGroup, self.szObjGrid, 0x00000000, nX, nY or 0)
  else
    local nLevel = me.GetNpc().GetFightSkillLevel(nSkillId)
    if nLevel == 0 then
      ObjGrid_ChangeMaskColor(self.szUiGroup, self.szObjGrid, 0x80000000, nX, nY or 0) -- 如果角色没学该技能则设置半透明黑色掩膜效果
    else
      -- 检查技能是否满足释放条件
      if me.CanCastSkillUI(nSkillId) ~= 1 then
        ObjGrid_ChangeMaskColor(self.szUiGroup, self.szObjGrid, 0x70000000, nX, nY or 0)
      else
        ObjGrid_ChangeMaskColor(self.szUiGroup, self.szObjGrid, 0x00000000, nX, nY or 0)
      end
    end
  end

  if me.GetActiveAuraSkill() == nSkillId then
    ObjGrid_SetTransparency(self.szUiGroup, self.szObjGrid, "\\image\\icon\\other\\autoskill.spr", nX, nY or 0) -- 设置透明图层
  else
    ObjGrid_SetTransparency(self.szUiGroup, self.szObjGrid, " ", nX, nY or 0) -- 设置透明图层
  end
end

-- 更新生活技能Object
function tbBase:UpdateLifeSkill(tbLifeSkill, nX, nY)
  local nSkillId = tbLifeSkill.nSkillId
  if not me.GetSingleLifeSkill(nSkillId) then
    ObjGrid_ChangeMaskColor(self.szUiGroup, self.szObjGrid, 0x80000000, nX, nY) -- 如果角色没学该技能则设置半透明黑色掩膜效果
  end
end

-- 更新角色状态Object
function tbBase:UpdateBuff(tbBuff, nX, nY)
  local nBuffId = tbBuff.nBuffId
  local tbInfo = me.GetBuffInfo(nBuffId)
  if not tbInfo then
    return
  end

  -- 播放CD特效，注意Core接口提供的单位是逻辑帧数，要换算为毫秒
  local nCdTime = Lib:FrameNum2Ms(tbInfo.nTotalTime)
  local nCdPass = Lib:FrameNum2Ms(tbInfo.nTotalTime - tbInfo.nLeftTime)
  ObjGrid_PlayCd(self.szUiGroup, self.szObjGrid, nCdTime, nCdPass, nX, nY)
  if tbInfo.nSkillId <= 0 then
    return
  end
  local tbStateInfo = KFightSkill.GetStateInfo(tbInfo.nSkillId, tbInfo.nLevel)
  if not tbStateInfo then
    return
  end
  for szDesc, tbMagic in pairs(tbStateInfo.tbWholeMagic) do
    if szDesc == "superposemagic" and tbMagic[2] > 0 then
      --print(self.szUiGroup, self.szObjGrid, tostring(tbMagic[2]), nX, nY);
      ObjGrid_ShowSubScript(self.szUiGroup, self.szObjGrid, 1, nX, nY)
      ObjGrid_ChangeSubScript(self.szUiGroup, self.szObjGrid, tostring(tbMagic[2]), nX, nY)
      break
    end
  end
end

-- 更新任务图标Object
function tbBase:UpdateTaskIcon(tbTaskIcon, nX, nY)
  if tbTaskIcon.nCount then
    ObjGrid_ChangeSubScript(self.szUiGroup, self.szObjGrid, tostring(tbTaskIcon.nCount)) -- 设置任务奖励数目作为下标显示
  end
end

-- 使用属于自己的道具Object
function tbBase:UseOwnItem(tbOwnItem, nX, nY)
  local pItem = me.GetItem(tbOwnItem.nRoom, tbOwnItem.nX, tbOwnItem.nY)
  if not pItem then
    return
  end
  if UiManager:GetUiState(UiManager.UIS_TRADE_PLAYER) == 1 then
  --		if Ui(Ui.UI_TRADE):AutoAddTradeItem(tbOwnItem.nRoom, tbOwnItem.nX, tbOwnItem.nY) == 1 then
  --			self:SetObj(nil, nX, nY);	-- 自动设为交易物品成功后则要清掉容器中的Object
  --		end
  elseif UiManager:GetUiState(UiManager.UIS_ITEM_REPAIR) == 1 then
    UiManager:ReleaseUiState(UiManager.UIS_ITEM_REPAIR)
  elseif UiManager:GetUiState(UiManager.UIS_BEGIN_STALL) == 1 then
  elseif UiManager:GetUiState(UiManager.UIS_BEGIN_OFFER) == 1 then
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_NPC) == 1 then
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_BUY) == 1 then
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_SELL) == 1 then
  elseif UiManager:GetUiState(UiManager.UIS_OPEN_REPOSITORY) == 1 then
  elseif UiManager:GetUiState(UiManager.UIS_OPEN_KINREPOSITORY) == 1 then
  else -- TODO: xyf 怀疑这里的逻辑不严谨
    UiManager:UseItem(pItem)
  end
end

-- 使用属于战斗技能Object
function tbBase:UseFightSkill(tbFightSkill, nX, nY)
  UseSkill(tbFightSkill.nSkillId)
end

-- 链接属于自己的道具Object
function tbBase:LinkOwnItem(tbOwnItem, nX, nY)
  local pItem = me.GetItem(tbOwnItem.nRoom, tbOwnItem.nX, tbOwnItem.nY)
  if pItem then
    SetItemLink(pItem.nIndex) -- 旧的装备链接机制
  end
end

-- 发送属于自己的道具Object装备预览
function tbBase:PreViewItem(tbPreViewItem, nX, nY)
  local pItem = me.GetItem(tbPreViewItem.nRoom, tbPreViewItem.nX, tbPreViewItem.nY)
  if pItem then
    tbPreViewMgr:SetPreViewItem(pItem)
    -- SetItemLink(pItem.nIndex);			-- 调用装备预览
  end
end

function tbBase:PreViewTempItem(tbPreViewTempItem, nX, nY)
  local pItem = tbPreViewTempItem.pItem
  if pItem then
    tbPreViewMgr:SetPreViewItem(pItem)
    -- SetItemLink(pItem.nIndex);			-- 调用装备预览
  end
end

function tbBase:EnchaseStoneItem(tbItemObj, nX, nY)
  local pItem = me.GetItem(tbItemObj.nRoom, tbItemObj.nX, tbItemObj.nY)
  if not pItem then
    return
  end
  --拍卖行单独处理
  if UiManager:WindowVisible(Ui.UI_AUCTIONROOM) == 1 then
    local tbUiAuctionRoom = Ui(Ui.UI_AUCTIONROOM)
    Wnd_SetFocus(tbUiAuctionRoom.UIGROUP, "EditSearch")
    Edt_SetTxt(tbUiAuctionRoom.UIGROUP, "EditSearch", pItem.szName)
    return
  end
  if pItem.szClass == "jinxi" then -- 金犀单独处理
    Item:GetClass("jinxi"):OnAllRepair(pItem)
    return
  end
  if me.nFightState == 1 then
    me.Msg("战斗状态无法镶嵌/剥离宝石。")
    return
  end
  local bRet, szMsg = Item:CheckCanEnchaseStone(pItem)
  if bRet ~= 1 then
    me.Msg(szMsg)
    return
  end

  -- dengyong:与金犀修理、宝石升级鼠标状态有冲突，进入到该事件处理中时，去掉这两个鼠标状态
  -- 从逻辑上讲，该事件与这两个鼠标状态也应该是互斥的！！
  UiManager:ReleaseUiState(UiManager.UIS_ITEM_REPAIR)
  UiManager:ReleaseUiState(UiManager.UIS_STONE_UPGRADE)

  self:SwitchObj(nX, nY)
  UiManager:OpenWindow(Ui.UI_EQUIPHOLE, Item.HOLE_MODE_ENCHASE) -- 打开镶嵌面板
  UiNotify:OnNotify(UiNotify.emUIEVENT_OBJ_STATE_USE, self.szUiGroup)
end

-- 鼠标进入道具Object
function tbBase:EnterItem(tbItem, nX, nY)
  self:ShowItemTip(tbItem.pItem, 1, tbItem.szBindType)
end

-- 鼠标进入属于自己的道具Object
function tbBase:EnterOwnItem(tbOwnItem, nX, nY)
  local pItem = me.GetItem(tbOwnItem.nRoom, tbOwnItem.nX, tbOwnItem.nY)
  if tbOwnItem.nRoom == Item.ROOM_EQUIP then
    self:ShowItemTip(pItem, 0)
  else
    self:ShowItemTip(pItem)
  end
  if UiVersion == Ui.Version002 then
    if tbOwnItem.nRoom == Item.ROOM_EXTBAGBAR then
      Ui(Ui.UI_ITEMBOX):ShowHighLight(nX, nY) -- todo 没有回调的地方，暂时放在这里回调
    end
  end
end

-- 鼠标进入战斗技能Object
function tbBase:EnterFightSkill(tbFightSkill, nX, nY)
  local nSkillId = tbFightSkill.nSkillId
  if nSkillId <= 0 then
    return
  end
  local szTitle, szText, szView = nil
  -- 在载具上
  if me.IsInCarrier() == 1 then
    local pCarrier = me.GetCarrierNpc()
    if pCarrier then
      --NPC没有取tip的接口，就自己取咯
      local nLevel = pCarrier.GetFightSkillLevel(nSkillId)
      szTitle, szText, szView = FightSkill:GetDesc(nSkillId, nLevel, 0, nil, pCarrier)
    else
      return
    end
  else
    szTitle, szText, szView = me.GetFightSkillTip(nSkillId, 0)
  end
  if not szTitle or not szText then
    return
  end
  Wnd_ShowMouseHoverInfo(self.szUiGroup, self.szObjGrid, szTitle, szText, szView or "")
end

-- 鼠标进入生活技能Object
function tbBase:EnterLifeSkill(tbLifeSkill, nX, nY)
  local nSkillId = tbLifeSkill.nSkillId
  if nSkillId <= 0 then
    return
  end
  Wnd_ShowMouseHoverInfo(self.szUiGroup, self.szObjGrid, me.GetLifeSkillTip(nSkillId))
end

-- 鼠标进入角色状态Object
function tbBase:EnterBuff(tbBuff, nX, nY)
  local szTip = me.GetBuffTip(tbBuff.nBuffId)
  if szTip then
    Wnd_ShowMouseHoverInfo(self.szUiGroup, self.szObjGrid, "", szTip)
  end
end

-- 鼠标进入任务图标
function tbBase:EnterTaskIcon(tbTaskIcon, nX, nY)
  if not tbTaskIcon.szTip then
    return
  end
  Wnd_ShowMouseHoverInfo(self.szUiGroup, self.szObjGrid, tbTaskIcon.szTip, "")
end

-- 鼠标离开道具Object
function tbBase:LeaveItem(tbItem, nX, nY)
  Wnd_HideMouseHoverInfo()
end

-- 鼠标离开属于自己的道具Object
function tbBase:LeaveOwnItem(tbOwnItem, nX, nY)
  Wnd_HideMouseHoverInfo()
  if UiVersion == Ui.Version002 then
    if tbOwnItem.nRoom == Item.ROOM_EXTBAGBAR then
      Ui(Ui.UI_ITEMBOX):HideHighLight(nX, nY)
    end
  end
end

-- 鼠标离开战斗技能Object
function tbBase:LeaveFightSkill(tbFightSkill, nX, nY)
  Wnd_HideMouseHoverInfo()
end

-- 鼠标离开生活技能Object
function tbBase:LeaveLifeSkill(tbLifeSkill, nX, nY)
  Wnd_HideMouseHoverInfo()
end

-- 鼠标离开角色状态Object
function tbBase:LeaveBuff(tbBuff, nX, nY)
  Wnd_HideMouseHoverInfo()
end

-- 鼠标离开任务图标
function tbBase:LeaveTaskIcon(tbTaskIcon, nX, nY)
  Wnd_HideMouseHoverInfo()
end

-- 交换Object检查鼠标和状态，注意该函数如果返回1则不要对鼠标作任何改动
function tbBase:CheckMouse(tbMouseObj)
  return 1
end

-- 交换Object检查容器内Object和状态，注意该函数如果返回1则不要对鼠标作任何改动
function tbBase:ClickMouse(tbObj, nX, nY)
  return 1
end

-- 鼠标和容器交换Object
function tbBase:SwitchMouse(tbMouseObj, tbObj, nX, nY)
  tbMouse:SetObj(tbObj) -- 鼠标要在前设置，以免被过滤
  self:SetObj(tbMouseObj, nX, nY)
  return 1
end

-- 将鼠标上的Object放进容器
function tbBase:DropMouse(tbMouseObj, nX, nY)
  tbMouse:SetObj(nil) -- 先清掉鼠标下面的才能设置成功
  self:SetObj(tbMouseObj, nX, nY)
  return 1
end

-- 从容器中拿起Object到鼠标
function tbBase:PickMouse(tbObj, nX, nY)
  return 1
end

-- 结束切换操作的处理
function tbBase:EndSwitchMouse(tbMouseObj, tbObj, nX, nY)
  -- 基类什么都不做
end

function tbBase:CanSendStateUse()
  return 0
end

------------------------------------------------------------------------------------------
-- 固定显示逻辑或者私有逻辑

-- 格式化Object回调函数名表
tbBase.FORMAT_PROC = {
  [Ui.OBJ_NPC] = "FormatNpc",
  [Ui.OBJ_NPCRES] = "FormatNpcRes",
  [Ui.OBJ_ITEM] = "FormatItem",
  [Ui.OBJ_TEMPITEM] = "FormatItem",
  [Ui.OBJ_OWNITEM] = "FormatOwnItem",
  [Ui.OBJ_FIGHTSKILL] = "FormatFightSkill",
  [Ui.OBJ_LIFESKILL] = "FormatLifeSkill",
  [Ui.OBJ_PORTRAIT] = "FormatPortrait",
  [Ui.OBJ_BUFF] = "FormatBuff",
  [Ui.OBJ_TASKICON] = "FormatTaskIcon",
}

-- 更新Object回调函数名表
tbBase.UPDATE_PROC = {
  [Ui.OBJ_NPC] = "UpdateNpc",
  [Ui.OBJ_NPCRES] = "UpdateNpcRes",
  [Ui.OBJ_ITEM] = "UpdateItem",
  [Ui.OBJ_TEMPITEM] = "UpdateItem",
  [Ui.OBJ_OWNITEM] = "UpdateOwnItem",
  [Ui.OBJ_FIGHTSKILL] = "UpdateFightSkill",
  [Ui.OBJ_LIFESKILL] = "UpdateLifeSkill",
  [Ui.OBJ_PORTRAIT] = "UpdatePortrait",
  [Ui.OBJ_BUFF] = "UpdateBuff",
  [Ui.OBJ_TASKICON] = "UpdateTaskIcon",
}

-- 使用（右键）Object回调函数名表
tbBase.USE_PROC = {
  [Ui.OBJ_NPC] = "UseNpc",
  [Ui.OBJ_NPCRES] = "UseNpcRes",
  [Ui.OBJ_ITEM] = "UseItem",
  [Ui.OBJ_TEMPITEM] = "UseItem",
  [Ui.OBJ_OWNITEM] = "UseOwnItem",
  [Ui.OBJ_FIGHTSKILL] = "UseFightSkill",
  [Ui.OBJ_LIFESKILL] = "UseLifeSkill",
  [Ui.OBJ_PORTRAIT] = "UsePortrait",
  [Ui.OBJ_BUFF] = "UseBuff",
  [Ui.OBJ_TASKICON] = "UseTaskIcon",
}

-- 链接（CTRL+左键）Object回调函数名表
tbBase.LINK_PROC = {
  [Ui.OBJ_NPC] = "LinkNpc",
  [Ui.OBJ_NPCRES] = "LinkNpcRes",
  [Ui.OBJ_ITEM] = "LinkItem",
  [Ui.OBJ_TEMPITEM] = "LinkItem",
  [Ui.OBJ_OWNITEM] = "LinkOwnItem",
  [Ui.OBJ_FIGHTSKILL] = "LinkFightSkill",
  [Ui.OBJ_LIFESKILL] = "LinkLifeSkill",
  [Ui.OBJ_PORTRAIT] = "LinkPortrait",
  [Ui.OBJ_BUFF] = "LinkBuff",
  [Ui.OBJ_TASKICON] = "LinkTaskIcon",
}

-- 鼠标进入Object回调函数名表
tbBase.ENTER_PROC = {
  [Ui.OBJ_NPC] = "EnterNpc",
  [Ui.OBJ_NPCRES] = "EnterNpcRes",
  [Ui.OBJ_ITEM] = "EnterItem",
  [Ui.OBJ_TEMPITEM] = "EnterItem",
  [Ui.OBJ_OWNITEM] = "EnterOwnItem",
  [Ui.OBJ_FIGHTSKILL] = "EnterFightSkill",
  [Ui.OBJ_LIFESKILL] = "EnterLifeSkill",
  [Ui.OBJ_PORTRAIT] = "EnterPortrait",
  [Ui.OBJ_BUFF] = "EnterBuff",
  [Ui.OBJ_TASKICON] = "EnterTaskIcon",
}

-- 鼠标离开Object回调函数名表
tbBase.LEAVE_PROC = {
  [Ui.OBJ_NPC] = "LeaveNpc",
  [Ui.OBJ_NPCRES] = "LeaveNpcRes",
  [Ui.OBJ_ITEM] = "LeaveItem",
  [Ui.OBJ_TEMPITEM] = "LeaveItem",
  [Ui.OBJ_OWNITEM] = "LeaveOwnItem",
  [Ui.OBJ_FIGHTSKILL] = "LeaveFightSkill",
  [Ui.OBJ_LIFESKILL] = "LeaveLifeSkill",
  [Ui.OBJ_PORTRAIT] = "LeavePortrait",
  [Ui.OBJ_BUFF] = "LeaveBuff",
  [Ui.OBJ_TASKICON] = "LeaveTaskIcon",
}

tbBase.PREVIEW_PROC = {
  [Ui.OBJ_ITEM] = "PreViewTempItem",
  [Ui.OBJ_TEMPITEM] = "PreViewTempItem",
  [Ui.OBJ_OWNITEM] = "PreViewItem",
}

tbBase.ENCHASESTONE_PROC = -- alt+LButton
  {
    [Ui.OBJ_OWNITEM] = "EnchaseStoneItem",
  }

-- Object查找比较条件表
tbBase.FIND_COMPARE = {
  [Ui.OBJ_NPC] = function(tbObj, tbFind)
    return (tbFind.pNpc.nIndex == tbObj.pNpc.nIndex) and 1 or 0
  end,
  [Ui.OBJ_ITEM] = function(tbObj, tbFind)
    return (tbFind.pItem.nIndex == tbObj.pItem.nIndex) and 1 or 0
  end,
  [Ui.OBJ_TEMPITEM] = function(tbObj, tbFind)
    return (tbFind.pItem.nIndex == tbObj.pItem.nIndex) and 1 or 0
  end,
  [Ui.OBJ_OWNITEM] = function(tbObj, tbFind)
    return ((tbFind.nRoom == tbObj.nRoom) and (tbFind.nX == tbObj.nX) and (tbFind.nY == tbObj.nY)) and 1 or 0
  end,
  [Ui.OBJ_FIGHTSKILL] = function(tbObj, tbFind)
    return (tbFind.nSkillId == tbObj.nSkillId) and 1 or 0
  end,
  [Ui.OBJ_LIFESKILL] = function(tbObj, tbFind)
    return (tbFind.nSkillId == tbObj.nSkillId) and 1 or 0
  end,
  [Ui.OBJ_PORTRAIT] = function(tbObj, tbFind)
    return ((tbFind.nId == tbObj.nPortraitId) and (tbFind.bSex == tbObj.bSex)) and 1 or 0
  end,
  [Ui.OBJ_BUFF] = function(tbObj, tbFind)
    return (tbFind.nBuffId == tbObj.nBuffId) and 1 or 0
  end,
  [Ui.OBJ_TASKICON] = function(tbObj, tbFind)
    return (tbFind.nIndex == tbTaskIcon.nIndex) and 1 or 0
  end,
}

function tbBase:DropObj(tbObj, nX, nY)
  local fnProc = self[self.FORMAT_PROC[tbObj.nType]] -- 取格式化回调
  if not fnProc then
    return
  end

  -- 格式化好Object并放进ObjGrid控件
  local tbFmtObj = fnProc(self, tbObj)
  if not tbFmtObj then
    return
  end

  ObjGrid_DropObj(self.szUiGroup, self.szObjGrid, tbFmtObj, nX, nY)
  self:UpdateObj(tbObj, nX, nY) -- 更新控件中的Object显示
end

function tbBase:PickObj(nX, nY)
  ObjGrid_PickObj(self.szUiGroup, self.szObjGrid, nX, nY) -- 把Object从ObjGrid控件里取出
end

function tbBase:UpdateObj(tbObj, nX, nY)
  local fnProc = self[self.UPDATE_PROC[tbObj.nType]] -- 取更新回调
  if fnProc then
    fnProc(self, tbObj, nX, nY) -- 初始化更新ObjGrid控件中的Object
  end
end

function tbBase:SwitchObj(nX, nY)
  if self.bSwitch ~= 1 then
    return
  end

  local tbObj = self:GetObj(nX, nY)
  local tbMouseObj = tbMouse.tbObj
  local b1 = tbMouseObj and self:CheckMouse(tbMouseObj) or 1 -- 检查鼠标Object和状态
  local b2 = tbObj and self:ClickMouse(tbObj, nX, nY) or 1 -- 检查容器内Object和状态

  if (b1 ~= 1) or (b2 ~= 1) then
    return
  end

  assert(tbMouseObj == tbMouse.tbObj) -- 对上面两个函数是否对鼠标Object作了改动的检查
  local bSuccess = 0

  -- 锁定不允许脱装备的提示，太复杂的逻辑了……
  if tbMouseObj and tbMouseObj.nRoom then
    if self.nRoom then
      if Item:IsEquipRoom(self.nRoom) ~= Item:IsEquipRoom(tbMouseObj.nRoom) and me.IsAccountLock() == 1 then
        if Item:IsEquipRoom(tbMouseObj.nRoom) ~= 1 then
        else
          me.Msg("您目前处于锁定状态，不能脱下身上装备")
          Account:OpenLockWindow()
          return 0
        end
      end
    elseif Item:IsEquipRoom(tbMouseObj.nRoom) == 1 then
      me.Msg("您目前处于锁定状态，不能脱下身上装备")
      return 0
    end
  end

  if tbMouseObj then
    if tbObj then -- 鼠标和容器中都有东西，交换操作
      bSuccess = self:SwitchMouse(tbMouseObj, tbObj, nX, nY)
    else -- 鼠标上有东西容器中没有，放下操作
      Tutorial:DropObj(self.szUiGroup, self.szObjGrid, nX, nY)
      bSuccess = self:DropMouse(tbMouseObj, nX, nY)
      if bSuccess == 1 then
        tbMouse:SetObj(nil) -- 清掉鼠标上的Object
      end
    end
  else
    if tbObj then -- 鼠标上没东西容器中有，拿起操作
      Tutorial:GetObj(self.szUiGroup, self.szObjGrid, nX, nY)
      bSuccess = self:PickMouse(tbObj, nX, nY)
      if bSuccess == 1 then
        self:SetObj(nil, nX, nY) -- 清掉容器里的Object
        tbMouse:SetObj(tbObj) -- 将容器中原Object放到鼠标上
      end
    else -- 两边都没东西，什么都不做
      return
    end
  end

  self:EndSwitchMouse(tbMouseObj, tbObj, nX, nY) -- 交换操作后的处理
end

function tbBase:UseObj(tbObj, nX, nY)
  if self:CanSendStateUse() == 1 and self.bSendToGift == 1 then
    --self:SetObj(nil, nX, nY);					-- 清掉容器里的Object
    --tbMouse:ResetObj();
    --tbMouse:SetObj(tbObj);						-- 将容器中原Object放到鼠标上
    self:SwitchObj(nX, nY)
    UiNotify:OnNotify(UiNotify.emUIEVENT_OBJ_STATE_USE, self.szUiGroup)
  end

  if self.bUse ~= 1 then
    return
  end
  local fnProc = self[self.USE_PROC[tbObj.nType]] -- 取使用回调
  if fnProc then
    fnProc(self, tbObj, nX, nY) -- 使用Object操作
  end
end

function tbBase:LinkObj(tbObj, nX, nY)
  if self.bLink ~= 1 then
    return
  end
  local fnProc = self[self.LINK_PROC[tbObj.nType]] -- 取链接回调
  if fnProc then
    fnProc(self, tbObj, nX, nY) -- 链接Object操作
  end
end

function tbBase:PreViewObj(tbObj, nX, nY)
  if self.bPreView ~= 1 then
    return
  end
  local fnProc = self[self.PREVIEW_PROC[tbObj.nType]] -- 取链接回调
  if fnProc then
    fnProc(self, tbObj, nX, nY) -- 链接Object操作
  end
end

function tbBase:EnchaseStone(tbObj, nX, nY)
  local fnProc = self[self.ENCHASESTONE_PROC[tbObj.nType]] -- 取链接回调
  if fnProc then
    fnProc(self, tbObj, nX, nY) -- 链接Object操作
  end
end

function tbBase:EnterObj(tbObj, nX, nY)
  if self.bEnterLeave ~= 1 then
    return
  end
  local fnProc = self[self.ENTER_PROC[tbObj.nType]] -- 取鼠标进入回调
  if fnProc then
    fnProc(self, tbObj, nX, nY) -- 鼠标进入Object操作
  end
end

function tbBase:LeaveObj(tbObj, nX, nY)
  if self.bEnterLeave ~= 1 then
    return
  end
  local fnProc = self[self.LEAVE_PROC[tbObj.nType]] -- 取鼠标离开回调
  if fnProc then
    fnProc(self, tbObj, nX, nY) -- 鼠标离开Object操作
  end
end

------------------------------------------------------------------------------------------
-- 基类特定私有逻辑

-- 显示道具Tip
function tbBase:ShowItemTip(pItem, bCompare, szBindType)
  bCompare = bCompare or 1
  if not pItem then
    return
  end
  local nTipState = Item.TIPS_NORMAL
  if UiManager:GetUiState(UiManager.UIS_TRADE_REPAIR) == 1 then
    nTipState = Item.TIPS_CREPAIR
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_REPAIR_EX) == 1 then
    nTipState = Item.TIPS_SREPAIR
  elseif UiManager:GetUiState(UiManager.UIS_ITEM_REPAIR) == 1 then
    nTipState = Item.TIPS_IREPAIR
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_BUY) == 1 then
    nTipState = Item.TIPS_SHOP
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_SELL) == 1 then
    nTipState = Item.TIPS_SHOP
  elseif UiManager:GetUiState(UiManager.UIS_TRADE_NPC) == 1 then
    nTipState = Item.TIPS_SHOP
  elseif UiManager:GetUiState(UiManager.UIS_STALL_BUY) == 1 then
    nTipState = Item.TIPS_STALL
  elseif UiManager:GetUiState(UiManager.UIS_STALL_SETPRICE) == 1 then
    nTipState = Item.TIPS_STALL
  elseif UiManager:GetUiState(UiManager.UIS_OFFER_SELL) == 1 then
    nTipState = Item.TIPS_OFFER
  elseif UiManager:GetUiState(UiManager.UIS_OFFER_SETPRICE) == 1 then
    nTipState = Item.TIPS_OFFER
  elseif UiManager:GetUiState(UiManager.UIS_BEGIN_STALL) == 1 then
    nTipState = Item.TIPS_STALL
  elseif UiManager:GetUiState(UiManager.UIS_BEGIN_OFFER) == 1 then
    nTipState = Item.TIPS_OFFER
  elseif UiManager:GetUiState(UiManager.UIS_EQUIP_ENHANCE) == 1 then
    nTipState = Item.TIPS_ENHANCE
  elseif UiManager:GetUiState(UiManager.UIS_EQUIP_STRENGTHEN) == 1 then --改造的TIP状态
    nTipState = Item.TIPS_STRENGTHEN
  elseif UiManager:GetUiState(UiManager.UIS_EQUIP_TRANSFER) == 1 then --强化转移tip
    nTipState = Item.TIPS_TRANSFER
  elseif UiManager:GetUiState(UiManager.UIS_STALL_SALE) == 1 then
    nTipState = Item.TIPS_STALL
  elseif UiManager:GetUiState(UiManager.UIS_OFFER_BUY) == 1 then
    nTipState = Item.TIPS_OFFER
  end
  if bCompare == 1 then
    Wnd_ShowMouseHoverInfo(self.szUiGroup, self.szObjGrid, pItem.GetCompareTip(nTipState, szBindType))
  else
    Wnd_ShowMouseHoverInfo(self.szUiGroup, self.szObjGrid, pItem.GetTip(nTipState, szBindType))
  end
end

-- 更新容器中指定CD时间类型的CD时间特效
function tbBase:UpdateItemCd(nCdType)
  local nCdTime = Lib:FrameNum2Ms(GetCdTime(nCdType)) -- 总CD时间
  if nCdTime <= 0 then
    return
  end

  if self.bShowCd == 1 then -- 检查是否显示CD特效
    local fnCond = function(tbObj) -- 查找条件
      local pItem = nil
      if tbObj.nType == Ui.OBJ_OWNITEM then
        pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
      elseif (tbObj.nType == Ui.OBJ_ITEM) or (tbObj.nType == Ui.OBJ_TEMPITEM) then
        pItem = tbObj.pItem
      end
      if not pItem then
        return 0
      end
      return (pItem.nCdType == nCdType) and 1 or 0
    end

    local tbFind = self:SearchObj(fnCond) -- 寻找该容器中所有该CD时间类型相同的Object
    for _, tb in ipairs(tbFind) do -- 遍历查找结果
      local tbObj, nX, nY = unpack(tb)
      -- 播放CD特效，注意Core接口提供的单位是逻辑帧数，要换算为毫秒
      local nCdPass = Lib:FrameNum2Ms(me.GetCdTimePass(nCdType)) -- 已经过CD时间
      ObjGrid_PlayCd(self.szUiGroup, self.szObjGrid, nCdTime, nCdPass, nX, nY)
    end
  end

  --[[
	for _, tbCont in ipairs(tbObject.tbContainer) do	-- 遍历所有容器

		if (tbCont.bShowCd == 1) then					-- 检查是否显示CD特效

			local fnCond = function(tbObj)				-- 查找条件
				local pItem = nil;
				if (tbObj.nType == Ui.OBJ_OWNITEM) then
					pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY);
				elseif (tbObj.nType == Ui.OBJ_ITEM) or (tbObj.nType == Ui.OBJ_TEMPITEM) then
					pItem = tbObj.pItem;
				end
				if (not pItem) then
					return 0;
				end
				return (pItem.nCdType == nCdType) and 1 or 0;
			end

			local tbFind = tbCont:SearchObj(fnCond);	-- 寻找该容器中所有该CD时间类型相同的Object
			for _, tb in ipairs(tbFind) do				-- 遍历查找结果
				local tbObj, nX, nY = unpack(tb);
				-- 播放CD特效，注意Core接口提供的单位是逻辑帧数，要换算为毫秒
				local nCdPass = Lib:FrameNum2Ms(me.GetCdTimePass(nCdType));		-- 已经过CD时间
				ObjGrid_PlayCd(tbCont.szUiGroup, tbCont.szObjGrid, nCdTime, nCdPass, nX, nY);
			end

		end

	end
--]]
  -- TODO: xyf 因为效率不这么做了
end

function tbBase:OnCastFightSkill(nSkillId)
  if self.bShowCd ~= 1 then
    return
  end
  local tbFightSkill = {}
  tbFightSkill.nType = Ui.OBJ_FIGHTSKILL
  tbFightSkill.nSkillId = nSkillId
  local tbResult = self:FindObj(tbFightSkill)
  for _, tb in ipairs(tbResult) do
    local tbObj, i, j = unpack(tb)
    self:UpdateObj(tbObj, i, j)
  end
end

function tbBase:OnSkillCDChange(nSkillId)
  self:OnCastFightSkill(nSkillId)
end

function tbBase:OnObjGridSwitch(nX, nY)
  self:SwitchObj(nX, nY)
end

function tbBase:OnObjGridUse(nX, nY)
  local tbObj = self:GetObj(nX, nY)
  if tbObj then
    self:UseObj(tbObj, nX, nY)
  end
end

function tbBase:OnObjGridLink(nX, nY)
  local tbObj = self:GetObj(nX, nY)
  if tbObj then
    self:LinkObj(tbObj, nX, nY)
  end
end

function tbBase:OnObjGridPreView(nX, nY)
  local tbObj = self:GetObj(nX, nY)
  if tbObj then
    self:PreViewObj(tbObj, nX, nY)
  end
end

function tbBase:OnObjGridEnchaseStone(nX, nY)
  local tbObj = self:GetObj(nX, nY)
  if tbObj then
    self:EnchaseStone(tbObj, nX, nY)
  end
end

function tbBase:OnObjGridEnter(nX, nY)
  local tbObj = self:GetObj(nX, nY)
  if tbObj then
    self:EnterObj(tbObj, nX, nY)
  end
  tbMouse.tbOverObj = tbObj -- 设置鼠标悬停Object
end

function tbBase:OnObjGridLeave(nX, nY)
  tbMouse.tbOverObj = nil -- 清除鼠标悬停Object
  local tbObj = self:GetObj(nX, nY)
  if tbObj then
    self:LeaveObj(tbObj, nX, nY)
  end
end

function tbBase:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_CDTYPE, self.UpdateItemCd, self }, -- CD时间类型状态改变事件
    { UiNotify.emCOREEVENT_CAST_FIGHTSKILL, self.OnCastFightSkill, self }, -- 角色释放战斗技能事件
    { UiNotify.emCOREEVENT_SYNC_SERIES, self.UpdateAll, self }, -- 角色五行改变事件
    { UiNotify.emCOREEVENT_SYNC_LEVEL, self.UpdateAll, self }, -- 角色等级变化事件
    { UiNotify.emCOREEVENT_SYNC_FACTION, self.UpdateAll, self }, -- 角色门派变化事件
    { UiNotify.emCOREEVENT_SYNC_ROUTE, self.UpdateAll, self }, -- 角色路线变化事件
    { UiNotify.emCOREEVENT_SYNC_MAKEPRICE, self.UpdateAll, self }, -- 标价之后刷新
    { UiNotify.emCOREEVENT_SKILL_USEPOINT, self.OnCastFightSkill, self }, -- 角色释放战斗技能事件
    { UiNotify.emCOREEVENT_CHAGNE_SKILLCD, self.OnSkillCDChange, self },
  }
  return tbRegEvent
end

function tbBase:RegisterMessage()
  local tbRegMsg = {
    { Ui.MSG_OBJGRID_SWITCH, self.szObjGrid, self.OnObjGridSwitch, self }, -- 切换Object消息
    { Ui.MSG_OBJGRID_USE, self.szObjGrid, self.OnObjGridUse, self }, -- 使用Object消息
    { Ui.MSG_OBJGRID_LINK, self.szObjGrid, self.OnObjGridLink, self }, -- 链接Object消息
    { Ui.MSG_OBJGRID_ENTER, self.szObjGrid, self.OnObjGridEnter, self }, -- 鼠标进入Object消息
    { Ui.MSG_OBJGRID_LEAVE, self.szObjGrid, self.OnObjGridLeave, self }, -- 鼠标离开Object消息
    { Ui.MSG_OBJGRID_PREVIEW, self.szObjGrid, self.OnObjGridPreView, self }, -- 装备预览Object消息
    { Ui.MSG_OBJGRID_ENCHASESTONE, self.szObjGrid, self.OnObjGridEnchaseStone, self }, -- 镶嵌宝石Object消息
  }
  return tbRegMsg
end

------------------------------------------------------------------------------------------
