-- Đóng gói đối tượng Player được xuất từ C
if MODULE_GC_SERVER then
  return
end

local self -- Cung cấp UpValue cho các hàm dưới đây

---- Hàm kiểm tra/ví dụ
--function _KLuaPlayer.Test(x)	-- Chú ý, ở đây phải dùng “.” thay vì “:”
--	-- self ở đây là UpValue, sẽ được chương trình gán thành đối tượng Player tương ứng
--	self.Msg(x);
--	-- Khi sử dụng self này cần chú ý một điểm: vì tất cả các hàm sau đây đều sử dụng cùng một UpValue (self),
--	-- do đó, trong quá trình thực thi một hàm, có khả năng self sẽ bị thay đổi. Để tránh lỗi, các hàm ở đây nên
--	-- cố gắng ngắn gọn, nếu thực sự cần gọi phức tạp, nên chú ý lưu lại giá trị self ban đầu.
--end

-------------------------------------------------------------------------------
-- cho cả server & client

-- Lấy trang bị ở vị trí chỉ định trên người nhân vật
function _KLuaPlayer.GetEquip(nEquipPos)
  return self.GetItem(Item.ROOM_EQUIP, nEquipPos)
end

-- Lấy trang bị chuyển đổi ở vị trí chỉ định trên người nhân vật
function _KLuaPlayer.GetEquipEx(nEquipExPos)
  return self.GetItem(Item.ROOM_EQUIPEX, nEquipExPos)
end

-- Lấy đạo cụ trong túi chính
function _KLuaPlayer.GetMainBagItem(nX, nY)
  return self.GetItem(Item.ROOM_MAINBAG, nX, nY)
end

-- Lấy đạo cụ trong rương chứa đồ
function _KLuaPlayer.GetRepositoryItem(nX, nY)
  return self.GetItem(Item.ROOM_REPOSITORY, nX, nY)
end

-- Lấy túi mở rộng nhân vật đang mặc
function _KLuaPlayer.GetExtBag(nExtBagPos)
  return self.GetItem(Item.ROOM_EXTBAGBAR, nExtBagPos)
end

-- Lấy đạo cụ trong túi mở rộng của nhân vật
function _KLuaPlayer.GetExtBagItem(nExtBagPos, nX, nY)
  local nRoom = Item.EXTBAGPOS2ROOM[nExtBagPos]
  if nRoom then
    return self.GetItem(nRoom, nX, nY)
  end
end

-- Lấy đạo cụ trong rương chứa đồ mở rộng của nhân vật
function _KLuaPlayer.GetExtRepItem(nExtRepPos, nX, nY)
  local nRoom = Item.EXTREPPOS2ROOM[nExtRepPos]
  if nRoom then
    return self.GetItem(nRoom, nX, nY)
  end
end

-- Lấy đạo cụ trong giao diện tặng của nhân vật
function _KLuaPlayer.GetGiftItem(nX, nY)
  return self.GetItem(Item.ROOM_GIFT, nX, nY)
end

-- Lấy đạo cụ trong ô giao dịch của nhân vật
function _KLuaPlayer.GetTradeItem(nX, nY)
  return self.GetItem(Item.ROOM_TRADE, nX, nY)
end

-- Lấy đạo cụ trong ô giao dịch của đối phương
function _KLuaPlayer.GetTradeClientItem(nX, nY)
  return self.GetItem(Item.ROOM_TRADECLIENT, nX, nY)
end

-- Lấy đạo cụ trong hòm thư của nhân vật
function _KLuaPlayer.GetMailItem()
  return self.GetItem(Item.ROOM_MAIL)
end

-- Lấy đạo cụ trong không gian ô trang bị Cường hóa/Tách Huyền Tinh
function _KLuaPlayer.GetEnhanceEquip()
  return self.GetItem(Item.ROOM_ENHANCE_EQUIP)
end

-- Lấy đạo cụ trong không gian đặt Huyền Tinh Cường hóa/Tách Huyền Tinh
function _KLuaPlayer.GetEnhanceItem(nX, nY)
  return self.GetItem(Item.ROOM_ENHANCE_ITEM, nX, nY)
end

-- Lấy đạo cụ trong không gian ô trang bị Cường hóa/Tách Huyền Tinh
function _KLuaPlayer.GetHoleEquip()
  return self.GetItem(Item.ROOM_HOLE_EQUIP)
end

-- Lấy trang bị trong không gian tách trang bị
function _KLuaPlayer.GetBreakUpEquip(nX, nY)
  return self.GetItem(Item.ROOM_BREAKUP)
end

-- Lấy đạo cụ trong không gian mua lại
function _KLuaPlayer.GetRecycleItem(nX, nY)
  return self.GetItem(Item.ROOM_RECYCLE, nX, nY)
end

-- Lấy số lượng vật phẩm trong tất cả các túi
function _KLuaPlayer.GetItemCountInBags(nGenre, nDetail, nParticular, nLevel, nSeries, nBind)
  local nCount = 0
  for _, nRoom in ipairs(Item.BAG_ROOM) do
    nCount = nCount + self.GetItemCount(nRoom, nGenre or 0, nDetail or 0, nParticular or 0, nLevel or 0, nSeries or -1, nBind or -1)
  end
  return nCount
end

-- Lấy giá trị vật phẩm trong tất cả các túi
function _KLuaPlayer.GetItemPriceInBags()
  local nValue = 0

  local tbAllRoom = {
    Item.BAG_ROOM,
    Item.REPOSITORY_ROOM,
  }
  for _, tbRoom in pairs(tbAllRoom) do
    for _, nRoom in pairs(tbRoom) do
      local tbIdx = self.FindAllItem(nRoom)
      for i = 1, #tbIdx do
        local pItem = KItem.GetItemObj(tbIdx[i])
        if pItem.szClass == "xiang" then
          local nXiangCount = pItem.GetGenInfo(1)
          local tbXiang = Item:GetClass("xiang")
          nValue = nValue + pItem.nPrice * nXiangCount / tbXiang:GetMaxItemCount(pItem)
        elseif pItem.nGenre == Item.SCRIPTITEM or pItem.nGenre == Item.MEDICINE or pItem.nGenre == Item.SKILLITEM then
          nValue = nValue + pItem.nPrice
        end
      end
    end
  end

  local nPrice = self.GetTask(Player.ACROSS_TSKGROUPID, Player.ACROSS_TSKID_PRICE)
  local nUseTime = self.GetTask(Player.ACROSS_TSKGROUPID, Player.ACROSS_TSKID_USE_TIME)
  local nTimeOut = self.GetTask(Player.ACROSS_TSKGROUPID, Player.ACROSS_TSKID_TIME_OUT)
  local nNowTime = GetTime()
  local nLastTime = nNowTime - nUseTime
  local MIN_LAST_TIME = 10 * 60
  if nLastTime < MIN_LAST_TIME and nLastTime > 0 then
    nLastTime = MIN_LAST_TIME
  end
  if nLastTime < nTimeOut and nLastTime > 0 and nTimeOut > 0 then
    nValue = nValue + math.floor(nPrice * (nTimeOut - nLastTime) / nTimeOut)
  end

  return nValue
end

function _KLuaPlayer.GetCanOfferSellCountInBag(nGenre, nDetail, nParticular, nLevel, nSeries)
  local nCount = 0
  for _, nRoom in ipairs(Item.BAG_ROOM) do
    nCount = nCount + self.GetItemCount(nRoom, nGenre or 0, nDetail or 0, nParticular or 0, nLevel or 0, nSeries or -1, 0, 0)
  end
  return nCount
end

--Tìm đạo cụ loại chỉ định trong túi đồ và rương chứa đồ của người chơi
function _KLuaPlayer.FindItemInAllPosition(nGenre, nDetail, nParticular, nLevel, nSeries)
  local tbResult = self.FindItemInBags(nGenre, nDetail, nParticular, nLevel, nSeries)
  local tbResult_Ex = self.FindItemInRepository(nGenre, nDetail, nParticular, nLevel, nSeries)
  Lib:MergeTable(tbResult, tbResult_Ex)
  return tbResult
end
-- Tìm đạo cụ loại chỉ định trong túi đồ
function _KLuaPlayer.FindItemInBags(nGenre, nDetail, nParticular, nLevel, nSeries)
  local tbResult = {}
  for _, nRoom in ipairs(Item.BAG_ROOM) do
    local tbFind = self.FindItem(nRoom, nGenre or 0, nDetail or 0, nParticular or 0, nLevel or 0, nSeries or -1)
    if tbFind then
      for _, tbItem in ipairs(tbFind) do
        tbItem.nRoom = nRoom
      end
      Lib:MergeTable(tbResult, tbFind)
    end
  end
  return tbResult
end

-- Tìm đạo cụ loại chỉ định trên rương chứa đồ
function _KLuaPlayer.FindItemInRepository(nGenre, nDetail, nParticular, nLevel, nSeries)
  local tbResult = {}
  for _, nRoom in ipairs(Item.REPOSITORY_ROOM) do
    local tbFind = self.FindItem(nRoom, nGenre or 0, nDetail or 0, nParticular or 0, nLevel or 0, nSeries or -1)
    if tbFind then
      for _, tbItem in ipairs(tbFind) do
        tbItem.nRoom = nRoom
      end
      Lib:MergeTable(tbResult, tbFind)
    end
  end
  return tbResult
end

-- Tìm trong túi đồ của nhân vật các đạo cụ có cùng loại lớn, loại nhỏ, loại chi tiết, cấp độ, ngũ hành với đạo cụ chỉ định
function _KLuaPlayer.FindSameItemInBags(pItem)
  if not pItem then
    return
  end
  return self.FindItemInBags(pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel, pItem.nSeries)
end

-- Tìm trong túi đồ của nhân vật xem có sở hữu đạo cụ đó không
function _KLuaPlayer.IsHaveItemInBags(pItem)
  if not pItem then
    return
  end
  if self.GetItemPos(pItem) then
    return 1
  end
  return 0
end

-- Tìm đạo cụ có Class chỉ định trong túi đồ
function _KLuaPlayer.FindClassItemInBags(szClass)
  local tbResult = {}
  for _, nRoom in ipairs(Item.BAG_ROOM) do
    local tbFind = self.FindClassItem(nRoom, szClass)
    if tbFind then
      for _, tbItem in ipairs(tbFind) do
        tbItem.nRoom = nRoom
      end
      Lib:MergeTable(tbResult, tbFind)
    end
  end
  return tbResult
end

function _KLuaPlayer.FindClassItemOnPlayer(szClass)
  local tbResult = {}
  local tbRoom = {}
  Lib:MergeTable(tbRoom, Item.BAG_ROOM)
  Lib:MergeTable(tbRoom, Item.REPOSITORY_ROOM)

  for _, nRoom in ipairs(tbRoom) do
    local tbFind = self.FindClassItem(nRoom, szClass)
    if tbFind then
      for _, tbItem in ipairs(tbFind) do
        tbItem.nRoom = nRoom
      end
      Lib:MergeTable(tbResult, tbFind)
    end
  end
  return tbResult
end
-- Lấy số lượng đạo cụ trong không gian chỉ định của nhân vật có cùng loại lớn, loại nhỏ, loại chi tiết, cấp độ, ngũ hành với đạo cụ chỉ định
function _KLuaPlayer.GetSameItemCount(nRoom, pItem)
  if not pItem then
    return
  end
  return self.GetItemCount(nRoom, pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel, pItem.nSeries)
end

-- Lấy số lượng đạo cụ trong túi đồ của nhân vật có cùng loại lớn, loại nhỏ, loại chi tiết, cấp độ, ngũ hành với đạo cụ chỉ định
function _KLuaPlayer.GetSameItemCountInBags(pItem)
  if not pItem then
    return
  end
  return self.GetItemCountInBags(pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel, pItem.nSeries)
end

-- Tính toán số lượng vật phẩm cùng loại với vật phẩm chỉ định có thể đặt thêm vào tất cả không gian túi đồ
function _KLuaPlayer.CalcFreeSameItemCountInBags(pItem)
  if not pItem then
    return 0
  end
  if pItem.IsStackable() ~= 1 then
    return self.CountFreeBagCell() -- Nếu là đạo cụ có thời hạn hoặc đạo cụ khóa thì không tính cộng dồn
  end
  return self.CalcFreeItemCountInBags(pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel, pItem.nSeries, pItem.IsBind())
end

-- Có thể sử dụng/trang bị đạo cụ chỉ định không
function _KLuaPlayer.CanUseItem(pItem)
  return KItem.CanPlayerUseItem(self, pItem)
end

function _KLuaPlayer.IsItemInBags(pItem)
  local tbFind = self.FindSameItemInBags(pItem)
  if not tbFind then
    return 0
  end
  for _, tbItem in ipairs(tbFind) do
    if tbItem.pItem.dwId == pItem.dwId then
      return 1
    end
  end

  return 0
end

function _KLuaPlayer.GetTempTable(szModelName)
  if not szModelName then
    print("Phải truyền tên module để lấy biến tạm thời của người chơi")
    assert(false)
  end

  if not Env.tbModelSet[szModelName] then
    print("Không có tên module này, hãy xem scripttable.txt")
    assert(false)
  end

  local tbTemp = self.GetPlayerTempTable()
  if not tbTemp[szModelName] then
    tbTemp[szModelName] = {}
  end

  return tbTemp[szModelName]
end

-- Nhân vật đã học kỹ năng sống chỉ định chưa
function _KLuaPlayer.HasLearnLifeSkill(nSkillId)
  return LifeSkill:HasLearnSkill(self, nSkillId)
end

function _KLuaPlayer.GetAttRoute()
  local tbFaction2AttRoute = {
    { 0, 0 }, -- Thiếu Lâm
    { 0, 0 }, -- Thiên Vương
    { 0, 0 }, -- Đường Môn
    { 0, 1 }, -- Ngũ Độc
    { 1, 1 }, -- Nga Mi
    { 1, 0 }, -- Thúy Yên
    { 1, 0 }, -- Cái Bang
    { 0, 1 }, -- Thiên Nhẫn
    { 1, 0 }, -- Võ Đang
    { 0, 1 }, -- Côn Lôn
    { 0, 1 }, -- Minh Giáo
    { 0, 1 }, -- Đoàn Thị
    { 0, 1 }, -- Cổ Mộ
  }
  if self.nFaction == 0 or self.nRouteId == 0 or not tbFaction2AttRoute[self.nFaction] or not tbFaction2AttRoute[self.nFaction][self.nRouteId] then
    return -1
  end
  return tbFaction2AttRoute[self.nFaction][self.nRouteId]
end

-- Tự động khớp vị trí Chân Nguyên
function _KLuaPlayer.GetZhenYuanPos()
  local nPos = Item.EQUIPPOS_ZHENYUAN_MAIN
  local pPlayer = self
  --[[Tạm thời chưa mở hai ô Chân Nguyên sau
	for i = Item.EQUIPPOS_ZHENYUAN_MAIN, Item.EQUIPPOS_ZHENYUAN_SUB2 do
		if not self.GetEquip(i) then
			nPos = i;
			break;
		end
	end
	]]
  --

  return nPos
end

--Kiểm tra xem đã kích hoạt nạp thẻ chưa
function _KLuaPlayer.GetPayActionState(nExtType)
  local tbType = Player.TSK_PAYACTION_EXT_ID
  if tbType[nExtType] then
    local nCurDate = tonumber(GetLocalDate("%Y%m"))
    local nDate = self.GetTask(Player.TSK_PAYACTION_GROUP, tbType[nExtType])
    if nDate == nCurDate then
      return 1 --Đã kích hoạt
    end
    local nExtState = self.GetActiveValue(nExtType)
    if nExtState == 1 then
      return 2 -- "Nhân vật khác dưới tài khoản đã kích hoạt tư cách nhận thưởng, không thể kích hoạt nữa!";
    end
    return 0 -- "Nhân vật hiện tại chưa kích hoạt tư cách nhận thưởng của tháng này";
  end
  return -1 -- "Xảy ra lỗi";
end

--Kích hoạt nạp thẻ
function _KLuaPlayer.SetPayActionState(nExtType)
  local tbType = Player.TSK_PAYACTION_EXT_ID
  if tbType[nExtType] then
    local nCurDate = tonumber(GetLocalDate("%Y%m"))
    if self.GetPayActionState(nExtType) == 0 then
      self.SetTask(Player.TSK_PAYACTION_GROUP, tbType[nExtType], nCurDate)
      self.SetActiveValue(nExtType, 1)
      return 1
    end
  end
  return 0
end

function _KLuaPlayer.GetKinSkillOffer()
  local nOffer = self.GetTask(Kin.TASK_GROUP, Kin.TASK_SKILLOFFER)
  return nOffer
end

function _KLuaPlayer.LockClientInput()
  self.SetTask(Player.TASK_OTHER_GROUP, Player.TASK_LOCK_INPUT, 1)
end

function _KLuaPlayer.UnLockClientInput()
  self.SetTask(Player.TASK_OTHER_GROUP, Player.TASK_LOCK_INPUT, 0)
end

-- Hạn chế không thể sử dụng dịch chuyển
function _KLuaPlayer.LimitTrans(nValue)
  self.SetTask(Player.TASK_OTHER_GROUP, Player.TASK_LIMIT_TRNAS, nValue)
end

function _KLuaPlayer.IsLimitTrans()
  return self.GetTask(Player.TASK_OTHER_GROUP, Player.TASK_LIMIT_TRNAS)
end

-------------------------------------------------------------------------------
-- for server
if MODULE_GAMESERVER then
  -- Client có bị debug không, một quá trình chạy của GS
  function _KLuaPlayer.ClientIsDebugging()
    return SelfProtect:IsDebugging(self.szName)
  end

  -- Client có sử dụng module không hợp lệ không
  function _KLuaPlayer.ClientHasInvalidModules()
    return SelfProtect:HasInvalidModules(self.szName)
  end

  function _KLuaPlayer.GetStudioLevel()
    return StudioScore:GetLevel(self)
  end

  -- Hiển thị hiệu ứng liên trảm (bShow:1 hiển thị, 0 hủy, nPkCount: số lượng liên trảm, nTimeSec: thời gian hiển thị, 0 là vĩnh viễn, mặc định 30 giây)
  function _KLuaPlayer.ShowSeriesPk(bShow, nPkCount, nTimeSec)
    if bShow == 1 then
      self.CallClientScript({ "UiManager:OpenWindow", "UI_SERIESKILL", nPkCount, nTimeSec })
    else
      self.CallClientScript({ "UiManager:CloseWindow", "UI_SERIESKILL" })
    end
  end

  -- tbItemInfo =
  --{
  --		nSeries or Env.SERIES_NONE,		Ngũ hành, mặc định không
  --		nEnhTimes or 0,					Số lần cường hóa, mặc định 0
  --		nLucky or 0,					May mắn
  --		tbGenInfo,
  --		tbRandomInfo, 				Phẩm chất ngẫu nhiên của trang bị
  --		nVersion or 0,
  --		uRandSeed or 0,					Hạt giống ngẫu nhiên
  --		bForceBind,						Cưỡng chế khóa, mặc định 0
  --		bTimeOut,						Có hết hạn không
  -- 		bMsg,							Có thông báo tin nhắn không
  --}

  function _KLuaPlayer.AddItemEx(nGenre, nDetail, nParticular, nLevel, tbItemInfo, nWay, nTimeout)
    if not tbItemInfo then
      tbItemInfo = {}
    end
    nGenre = tonumber(nGenre) or 0
    nDetail = tonumber(nDetail) or 0
    nParticular = tonumber(nParticular) or 0
    nLevel = tonumber(nLevel) or 0

    return KItem.AddPlayerItem(self, nGenre, nDetail, nParticular, nLevel, tbItemInfo.nSeries or Env.SERIES_NONE, tbItemInfo.nEnhTimes or 0, tbItemInfo.nLucky or 0, tbItemInfo.tbGenInfo, tbItemInfo.tbRandomInfo, tbItemInfo.nVersion or 0, tbItemInfo.uRandSeed or 0, tbItemInfo.bForceBind or 0, tbItemInfo.bTimeOut or 0, tbItemInfo.bMsg or 1, nWay or 100, nTimeout or 0)
  end

  function _KLuaPlayer.AddStackItem(nGenre, nDetail, nParticular, nLevel, tbItemInfo, nCount, nWay)
    if nCount < 1 then
      return 0, ""
    end
    local nCurCount = 0
    local nStackMax = 0
    nCount = tonumber(nCount) or 0
    local szName = ""
    if not tbItemInfo then
      tbItemInfo = {}
    end
    tbItemInfo.bMsg = tbItemInfo.bMsg or 0
    local pItem = self.AddItemEx(nGenre, nDetail, nParticular, nLevel, tbItemInfo, nWay)
    if pItem then
      nStackMax = pItem.nMaxCount
      szName = pItem.szName
      nCurCount = nCurCount + 1
    end
    while pItem and nCurCount ~= nCount do
      local nCanAddNum = nStackMax - pItem.nCount
      if nCanAddNum > 0 then
        if nCanAddNum + nCurCount > nCount then
          nCanAddNum = nCount - nCurCount
        end
        nCurCount = nCurCount + nCanAddNum

        local nItemAddWay = Item.emITEM_DATARECORD_SYSTEMADD
        local tbSystemAddWay = {
          Player.emKITEMLOG_TYPE_PEEL_PARTNER,
          Player.emKITEMLOG_TYPE_CYSTAL_COMPOSE,
          Player.emKITEMLOG_TYPE_UNENHANCE,
          Player.emKITEMLOG_TYPE_COMPOSE,
        }
        for _, nAddWay in pairs(tbSystemAddWay) do
          if nAddWay == nWay then
            nItemAddWay = Item.emITEM_DATARECORD_ROLLOUTADD
            break
          end
        end

        pItem.SetCount(pItem.nCount + nCanAddNum, nItemAddWay)
      end
      if nCurCount ~= nCount then
        pItem = self.AddItemEx(nGenre, nDetail, nParticular, nLevel, tbItemInfo, nWay)
        if pItem then
          nCurCount = nCurCount + 1
        end
      end
    end
    if nCurCount ~= nCount then
      Dbg:WriteLog("AddStackItem", "Tên nhân vật:" .. self.szName, "Tài khoản:" .. self.szAccount, "Đạo cụ" .. nGenre, nDetail, nParticular, nLevel, string.format("Thêm đạo cụ hàng loạt thất bại! Cần thêm %s cái, thực tế chỉ thêm được %s cái", nCount, nCurCount))
    end
    if nCurCount > 0 then
      self.Msg(string.format("Bạn đã nhận được tổng cộng %d cái %s", nCurCount, szName))
    end
    return nCurCount, szName
  end

  -- Thêm một đạo cụ cho nhân vật chỉ định
  function _KLuaPlayer.AddItem(nGenre, nDetail, nParticular, nLevel, nSeries, nEnhTimes, nLucky, tbGenInfo, tbRandomInfo, nVersion, uRandSeed, nWay)
    return KItem.AddPlayerItem(self, nGenre, nDetail, nParticular, nLevel, nSeries or Env.SERIES_NONE, nEnhTimes or 0, nLucky or 0, tbGenInfo, tbRandomInfo, nVersion or 0, uRandSeed or 0, 0, 0, 1, nWay or 100, 0)
  end

  -- Thêm một trang bị thường cho nhân vật
  function _KLuaPlayer.AddGeneralEquip(nDetail, nParticular, nLevel, nSeries, nEnhTimes, nLucky, nVersion, uRandSeed)
    return KItem.AddPlayerGeneralEquip(self, nDetail, nParticular, nLevel, nSeries, nEnhTimes, nLucky, nVersion, uRandSeed)
  end

  -- Thêm một trang bị hoàng kim cho nhân vật
  function _KLuaPlayer.AddGoldEquip(nDetail, nParticular, nLevel, nSeries, nEnhTimes, nVersion)
    return KItem.AddPlayerGoldEquip(self, nDetail, nParticular, nLevel, nSeries, nEnhTimes, nVersion)
  end

  -- Thêm một trang bị xanh cho nhân vật
  function _KLuaPlayer.AddGreenEquip(nDetail, nParticular, nLevel, nSeries, nEnhTimes, nVersion)
    return KItem.AddPlayerGreenEquip(self, nDetail, nParticular, nLevel, nSeries, nEnhTimes, nVersion)
  end

  -- Thêm một loại thuốc cho nhân vật
  function _KLuaPlayer.AddMedicine(nDetail, nParticular, nLevel, nSeries, nVersion)
    return KItem.AddPlayerMedicine(self, nDetail, nParticular, nLevel, nSeries, nVersion)
  end

  -- Thêm một đạo cụ kịch bản cho nhân vật
  function _KLuaPlayer.AddScriptItem(nDetail, nParticular, nLevel, nSeries, tbGenInfo, nVersion)
    return KItem.AddPlayerScriptItem(self, nDetail, nParticular, nLevel, nSeries, tbGenInfo, nVersion)
  end

  -- Thêm một đạo cụ kỹ năng cho nhân vật
  function _KLuaPlayer.AddSkillItem(nDetail, nParticular, nLevel, nSeries, nVersion)
    return KItem.AddPlayerSkillItem(self, nDetail, nParticular, nLevel, nSeries, nVersion)
  end

  -- Thêm một đạo cụ nhiệm vụ cho nhân vật
  function _KLuaPlayer.AddQuest(nDetail, nParticular, nLevel, nSeries, tbGenInfo, nVersion)
    return KItem.AddPlayerQuest(self, nDetail, nParticular, nLevel, nSeries, tbGenInfo, nVersion)
  end

  -- Thêm một túi mở rộng cho nhân vật
  function _KLuaPlayer.AddExtBag(nDetail, nParticular, nVersion)
    return KItem.AddPlayerExtBag(self, nDetail, nParticular, nVersion)
  end

  -- Thêm một nguyên liệu kỹ năng sống cho nhân vật
  function _KLuaPlayer.AddStuffItem(nDetail, nParticular, nLevel, nSeries, nVersion, nWay)
    return KItem.AddPlayerStuffItem(self, nDetail, nParticular, nLevel, nSeries, nVersion, nWay)
  end

  -- Thêm một công thức kỹ năng sống cho nhân vật
  function _KLuaPlayer.AddPlanItem(nDetail, nParticular, nLevel, nSeries, nVersion)
    return KItem.AddPlayerPlanItem(self, nDetail, nParticular, nLevel, nSeries, nVersion)
  end

  -- Xóa một đạo cụ nào đó trên người nhân vật
  function _KLuaPlayer.DelItem(pItem, nWay)
    return KItem.DelPlayerItem(self, pItem, (nWay or 100))
  end

  function _KLuaPlayer.ConsumeItemInBags2(nCount, nGenre, nDetail, nParticular, nLevel, nSeries, nBind)
    nSeries = tonumber(nSeries) or -1
    nBind = tonumber(nBind) or -1
    local nFreeItemCount = self.GetItemCountInBags(nGenre, nDetail, nParticular, nLevel, nSeries, nBind)
    if nFreeItemCount < nCount or nCount <= 0 then
      return 1
    end
    local nCalcCount = nCount
    local tbFind = self.FindItemInBags(nGenre, nDetail, nParticular, nLevel, nSeries)
    for _, tbItem in pairs(tbFind) do
      local pItem = tbItem.pItem
      local nNeedItem = 1
      if nBind >= 0 then
        if pItem.IsBind() ~= nBind then
          nNeedItem = 0
        end
      end
      if nNeedItem == 1 then
        local nDelItemCount = pItem.nCount
        if pItem.nCount > nCalcCount then
          nDelItemCount = nCalcCount
        end
        if pItem.nCount - nDelItemCount > 0 then
          pItem.SetCount(pItem.nCount - nDelItemCount, Item.emITEM_DATARECORD_REMOVE)
        else
          if self.DelItem(pItem, Player.emKLOSEITEM_USE) ~= 1 then
            return 1
          end
        end
        nCalcCount = nCalcCount - nDelItemCount
        if nCalcCount <= 0 then
          break
        end
      end
    end
    return 0
  end

  -- Chạy với tư cách người chơi hiện tại
  function _KLuaPlayer.Call(...)
    local pPlayerOld = me
    me = self
    local tbRet = { Lib:CallBack(arg) }
    me = pPlayerOld
    if tbRet[1] then
      return unpack(tbRet, 2)
    end
  end

  -- Thêm tâm đắc cho người chơi
  function _KLuaPlayer.AddInsight(nInsightNumber)
    if nInsightNumber <= 0 then
      return
    end

    Task:AddInsight(nInsightNumber)
  end

  -- Thêm kinh nghiệm kỹ năng sống cho nhân vật
  function _KLuaPlayer.AddLifeSkillExp(nSkillId, nExp)
    return LifeSkill:AddSkillExp(self, nSkillId, nExp)
  end

  -- Thêm tu vi mật tịch cho nhân vật
  function _KLuaPlayer.AddBookKarma(nAddKarma)
    return Item:AddBookKarma(self, nAddKarma)
  end

  -- Cổng vào tăng uy danh giang hồ
  function _KLuaPlayer.AddKinReputeEntry(nRepute, szWay)
    if nRepute <= 0 then
      return 0
    end
    local nTimes = KGblTask.SCGetDbTaskInt(DBTASK_WEIWANG_TIMES)
    if nTimes < 1 then
      nTimes = 1
    end
    nRepute = nRepute * nTimes
    if szWay and Player.PRESTIGE_LIMIT[szWay] then
      local nCurWeek = tonumber(os.date("%W", GetTime()))
      local nWeek = self.GetTask(Player.PRESTIGE_LIMIT_GROUP, Player.PRESTIGE_WEEK_ID)
      if nWeek ~= nCurWeek then
        for _, tbLimit in pairs(Player.PRESTIGE_LIMIT) do
          self.SetTask(Player.PRESTIGE_LIMIT_GROUP, tbLimit[1], 0)
        end
        self.SetTask(Player.PRESTIGE_LIMIT_GROUP, Player.PRESTIGE_WEEK_ID, nCurWeek)
      end
      local nCurValue = self.GetTask(Player.PRESTIGE_LIMIT_GROUP, Player.PRESTIGE_LIMIT[szWay][1])
      if nCurValue + nRepute > Player.PRESTIGE_LIMIT[szWay][2] then
        nRepute = Player.PRESTIGE_LIMIT[szWay][2] - nCurValue
      end
      if nRepute <= 0 then
        self.Msg("Thật lợi hại! Bạn đã nhận được tất cả “Uy Danh Giang Hồ” của hoạt động này trong tuần, muốn nhận thêm Uy Danh Giang Hồ có thể tham gia hoạt động khác hoặc quay lại vào tuần sau!")
        return 0
      end
      self.SetTask(Player.PRESTIGE_LIMIT_GROUP, Player.PRESTIGE_LIMIT[szWay][1], nCurValue + nRepute)
    end
    local nKinId, nMemberId = self.GetKinMember()
    local nTongId = self.dwTongId
    -- Tăng uy danh giang hồ của gia tộc
    GCExcute({ "Kin:AddKinTotalRepute_GC", nKinId, nMemberId, self.nId, nRepute })
    -- Tăng tổng uy danh giang hồ của bang hội
    if nTongId ~= 0 then
      GCExcute({ "Tong:AddTongTotalRepute_GC", nTongId, nRepute })
    end

    -- Cập nhật thời gian nhận uy danh khi nhận uy danh giang hồ
    Stats:UpdateGetReputeTime(self)
    Dbg:WriteLog("Prestige", self.szName, nRepute, szWay)
    return 1
  end

  -- Cổng vào tăng kinh nghiệm zounan add
  -- me.AddExp có nghĩa là trực tiếp thêm kinh nghiệm
  function _KLuaPlayer.AddExp2(nExp, szWay)
    if nExp <= 0 then
      return 0
    end

    if szWay and Player.EXP_TYPE[szWay] then
      if self.GetTiredDegree1() == 1 then
        nExp = nExp * 0.5
      elseif self.GetTiredDegree1() == 2 then
        nExp = 0
      end
    end

    if nExp > 0 then
      self.AddExp(nExp)
    end

    return math.floor(nExp)
  end

  -- Cổng vào tăng Bạc khóa zounan add
  --
  function _KLuaPlayer.AddBindMoney2(nMoney, szWay, szType)
    if nMoney <= 0 then
      return 0
    end

    if szWay and Player.BINDMONEY_TYPE[szWay] then
      if self.GetTiredDegree1() == 1 then
        nMoney = nMoney * 0.5
      elseif self.GetTiredDegree1() == 2 then
        nMoney = 0
      end
    end

    if nMoney > 0 then
      self.AddBindMoney(nMoney, szType)
    end

    return math.floor(nMoney)
  end

  -- Cổng vào tăng Ngân Đĩnh gia tộc liaoqiuyue add
  -- Ngân Đĩnh gia tộc được ghi trực tiếp vào biến nhiệm vụ của người chơi
  function _KLuaPlayer.AddKinSilverMoney(nMoney)
    --TODO or NOT: Kiểm tra xem người chơi đã gia nhập gia tộc chưa
    if nMoney <= 0 then
      return
    end
    local nYinding = self.GetTask(Kinsalary.TASK_GID, Kinsalary.TASK_YINDING)
    if nYinding + nMoney > Kinsalary.MAX_NUMBER then
      nMoney = Kinsalary.MAX_NUMBER - nYinding
    end

    self.SetTask(Kinsalary.TASK_GID, Kinsalary.TASK_YINDING, nYinding + nMoney)
    self.Msg(string.format("Bạn nhận được %s Ngân Đĩnh gia tộc, số Ngân Đĩnh hiện tại là %d", nMoney, nYinding + nMoney))
    if nYinding + nMoney >= Kinsalary.MAX_NUMBER then
      self.Msg("Ngân Đĩnh gia tộc của bạn đã đạt đến giới hạn, vui lòng tiêu dùng sớm trong cửa hàng Ngân Đĩnh.")
    end
    return
  end

  -- Dùng để kiểm tra xem người chơi có phải là người chơi cũ có thể chuyển thành thành viên chính thức ngay lập tức không
  function _KLuaPlayer.CanJoinKinImmediately()
    local bIsOldPAction = EventManager.ExEvent.tbPlayerCallBack:IsOpen(self, 2)
    if 1 == bIsOldPAction then
      local nOldPLastJoinKinTime = self.GetTask(Player.TASK_GROUP_OLDPLAYER, Player.TASK_ID_JOINKIN_TIME)
      if GetTime() > nOldPLastJoinKinTime then
        self.SetTask(Player.TASK_GROUP_OLDPLAYER, Player.TASK_ID_JOINKIN_TIME, GetTime() + Player.OLDPLAYER_ACTION_TIME)
        return 1
      end
    end
    return 0
  end

  -- Dùng để kiểm tra xem có phải là người chơi cũ có thể rời gia tộc ngay lập tức không
  function _KLuaPlayer.CanLeaveKinImmediately()
    local bIsOldPAction = EventManager.ExEvent.tbPlayerCallBack:IsOpen(self, 2)
    if 1 == bIsOldPAction then
      local nOldPLastLeaveKinTime = self.GetTask(Player.TASK_GROUP_OLDPLAYER, Player.TASK_ID_LEAVEKIN_TIME)
      if GetTime() > nOldPLastLeaveKinTime then
        self.SetTask(Player.TASK_GROUP_OLDPLAYER, Player.TASK_ID_LEAVEKIN_TIME, GetTime() + Player.OLDPLAYER_ACTION_TIME)
        return 1
      end
    end
    return 0
  end

  --Khấu trừ điểm cống hiến kỹ năng gia tộc
  function _KLuaPlayer.DecreaseKinSkillOffer(nDecreaseOffer)
    local nOffer = self.GetTask(Kin.TASK_GROUP, Kin.TASK_SKILLOFFER)
    if nOffer < nDecreaseOffer then
      return 0
    end
    self.SetTask(Kin.TASK_GROUP, Kin.TASK_SKILLOFFER, nOffer - nDecreaseOffer)
    return 1
  end

  -- Cổng vào cống hiến bang hội
  function _KLuaPlayer.AddTongOfferEntry(nOffer)
    local nKinId, nMemberId = self.GetKinMember()
    local cKin = KKin.GetKin(nKinId)
    if not cKin then
      return 0
    end
    local cMember = cKin.GetMember(nMemberId)
    if not cMember then
      return 0
    end
    if nOffer <= 0 then
      return 0
    end
    --Ẩn sĩ không thể nhận
    local nFigure = cMember.GetFigure()
    if nFigure == 0 or nFigure == Kin.FIGURE_RETIRE or nFigure == Kin.FIGURE_SIGNED then
      return 0
    end
    local nTongId = self.dwTongId
    if nTongId and nTongId ~= 0 then
      --self.AddTongOffer(nOffer);
      local nFund = math.floor(self.GetProductivity() * nOffer)
      --self.Msg(string.format("Quỹ xây dựng bang hội tăng %d", nFund));
      GCExcute({ "Tong:AddBuildFund_GC", nTongId, nKinId, nMemberId, nFund, 1, 0 })
    end
  end

  function _KLuaPlayer.__GetMonthPayExtValue()
    local nExtPoint = 1
    local nMonth = tonumber(GetLocalDate("%m"))
    if math.mod(nMonth, 2) == 0 then
      nExtPoint = 5
    end

    return self.GetExtPoint(nExtPoint)
  end

  function _KLuaPlayer.__AddMonthPayExtValue(nValue)
    local nExtPoint = 1
    local nMonth = tonumber(GetLocalDate("%m"))
    if math.mod(nMonth, 2) == 0 then
      nExtPoint = 5
    end

    return self.AddExtPoint(nExtPoint, nValue)
  end

  -- Trả về: số tiền điểm mà người chơi Shanda đã tiêu trong tháng/100
  -- bNeedExactValue tham số tùy chọn, nếu cần trả về giá trị chính xác mà người chơi Shanda đã tiêu trong tháng thì truyền vào 1
  function _KLuaPlayer.GetMonthPay(bNeedExactValue)
    local nConsume = self.GetSndaConsumeAmount()
    if nConsume <= 0 then
      return 0
    end
    if bNeedExactValue and 1 == bNeedExactValue then
      return nConsume
    else
      return math.floor(nConsume / 100)
    end
  end
  function _KLuaPlayer.__PayMonthPayExtValue(nValue)
    local nExtPoint = 1
    local nMonth = tonumber(GetLocalDate("%m"))
    if math.mod(nMonth, 2) == 0 then
      nExtPoint = 5
    end

    if self.GetExtPoint(nExtPoint) < nValue then
      return
    end
    return self.PayExtPoint(nExtPoint, nValue)
  end

  -- Lấy tình hình nạp thẻ trong tháng của người chơi, tháng lẻ dùng điểm mở rộng số 1, tháng chẵn dùng điểm mở rộng số 5
  function _KLuaPlayer.GetExtMonthPay(bNeedExactValue)
    if IVER_g_nSdoVersion == 1 then
      return self.GetMonthPay(bNeedExactValue)
    end
    local nValue = KLib.BitOperate(self.__GetMonthPayExtValue(), "&", 0x0fffffff)
    if jbreturn:GetMonLimit(self) > 0 then
      local nMonth = tonumber(GetLocalDate("%Y%m"))
      nValue = jbreturn:GetMonthPay(nMonth, nValue)
    end
    return nValue
  end

  -- Lấy tình hình nạp thẻ trong tháng của người chơi, tháng lẻ dùng điểm mở rộng số 1, tháng chẵn dùng điểm mở rộng số 5
  function _KLuaPlayer.GetExtMonthPay_VN(bNeedExactValue)
    if IVER_g_nSdoVersion == 1 then
      return self.GetMonthPay(bNeedExactValue)
    end
    local nValue = math.floor(KLib.BitOperate(self.__GetMonthPayExtValue(), "&", 0x0fffffff))
    if jbreturn:GetMonLimit(self) > 0 then
      local nMonth = tonumber(GetLocalDate("%Y%m"))
      nValue = jbreturn:GetMonthPay(nMonth, nValue)
    end
    return nValue
  end

  -- Lấy dữ liệu tài khoản int
  function _KLuaPlayer.GetAccTask(szKey)
    return Account:GetIntValue(self.szAccount, szKey)
  end

  -- Thiết lập dữ liệu tài khoản int
  function _KLuaPlayer.SetAccTask(szKey, nValue)
    return Account:ApplySetIntValue(self.szAccount, szKey, nValue, 0)
  end

  -- Lấy dữ liệu tài khoản str
  function _KLuaPlayer.GetAccTaskStr(szKey)
    return Account:GetBinValue(self.szAccount, szKey)
  end

  -- Thiết lập dữ liệu tài khoản str
  function _KLuaPlayer.SetAccTaskStr(szKey, nValue)
    return Account:ApplySetBinValue(self.szAccount, szKey, nValue)
  end

  -- Số lượng tài khoản đã kích hoạt trong tháng này
  function _KLuaPlayer.GetLinkTaskActiveAccountNum()
    local nValue = KLib.BitOperate(self.__GetMonthPayExtValue(), "&", 0xf0000000)
    return KLib.BitOperate(nValue, ">>", 28)
  end

  -- Thêm một tài khoản kích hoạt
  function _KLuaPlayer.AddLinTaskActiveAccount()
    return self.__AddMonthPayExtValue(0x10000000)
  end

  --Lấy giá trị bit kích hoạt hàng tháng (1-3 bit)
  function _KLuaPlayer.GetActiveValue(nBit)
    if not nBit or nBit <= 0 or nBit > 3 then
      print("GetActiveValue!!! nBit phải nằm trong khoảng từ 1 đến 3")
      return 0
    end
    local nExtValue = self.GetLinkTaskActiveAccountNum()
    local nExtBit = Lib:LoadBits(nExtValue, nBit - 1, nBit - 1)
    return nExtBit
  end

  --Thiết lập giá trị bit kích hoạt hàng tháng (1-3 bit)
  function _KLuaPlayer.SetActiveValue(nBit, nValue)
    if not nBit or nBit <= 0 or nBit > 3 then
      print("SetActiveValueError!!! nBit phải nằm trong khoảng từ 1 đến 3")
      return 0
    end
    if not nValue or nValue < 0 or nValue > 1 then
      print("SetActiveValueError!!! nValue phải là 0 hoặc 1")
      return 0
    end
    local nExtValue = self.GetLinkTaskActiveAccountNum()
    local nExtBitValue = Lib:SetBits(nExtValue, nValue, nBit - 1, nBit - 1)
    local nExt2 = nExtBitValue - nExtValue
    if nExt2 > 0 then
      self.__AddMonthPayExtValue((nExt2 * 2 ^ 28))
    elseif nExt2 < 0 then
      self.__PayMonthPayExtValue((-nExt2 * 2 ^ 28))
    end
    return 1
  end

  -- Thiết lập dữ liệu tài khoản
  function _KLuaPlayer.SetBankPayQualification(nValue)
    Account:ApplySetIntValue(self.szAccount, "OnlineBankPay.ActiveValue", nValue)
  end

  function _KLuaPlayer.GetBankPayQualification()
    return Account:GetIntValue(self.szAccount, "OnlineBankPay.ActiveValue")
  end

  ---- Nhốt vào thiên lao -------
  function _KLuaPlayer.TakeToPrison(nPrisonTime, nMapId)
    if nPrisonTime <= 0 then
      return 0
    end
    ---ID bản đồ thiên lao mặc định
    if nMapId == nil or nMapId <= 0 then
      nMapId = 399
    end

    self.SetTask(2000, 3, nPrisonTime)
    local nTianLaoX = 1651 -- Tọa độ X
    local nTianLaoY = 3260 -- Tọa độ Y
    self.NewWorld(nMapId, nTianLaoX, nTianLaoY)
  end

  --- Thả ra khỏi thiên lao
  function _KLuaPlayer.TakeOutPrison()
    self.DisabledStall(0) --Bày bán
    self.DisableOffer(0)
    self.SetForbidChat(0)
    -- Trả về 0, có nghĩa là đóng Timer này
    local tbTmp = self.GetTempTable("Npc")
    tbTmp.nPrisonLeftTimeId = nil
    self.SetTask(2000, 3, 0) -- Thời gian ngồi tù còn lại đặt thành 0
    local nMapId, nPointId, nXPos, nYPos = self.GetDeathRevivePos()
    self.NewWorld(nMapId, nXPos / 32, nYPos / 32)
  end

  function _KLuaPlayer.IsInPrison()
    local nArrestTime = self.GetArrestTime()
    local nLeftTime = self.GetTask(2000, 3)
    local bRet = 0
    if nArrestTime ~= 0 or nLeftTime ~= 0 then
      bRet = 1
    end
    return bRet
  end

  -- Có phải là phu thê không
  function _KLuaPlayer.IsCouple(szRelation)
    local tbRelation = self.GetRelationList(Player.emKPLAYERRELATION_TYPE_COUPLE)
    for _, szName in ipairs(tbRelation) do
      if szName == szRelation then
        return 1
      end
    end
    return 0
  end

  -- Lấy tên của bạn đời
  function _KLuaPlayer.GetCoupleName()
    -- Quan hệ phu thê cần thử vị trí chính và phụ để lấy thông tin của đối phương
    local tbRelation = self.GetRelationList(Player.emKPLAYERRELATION_TYPE_COUPLE, 1)
    if #tbRelation == 0 then
      tbRelation = self.GetRelationList(Player.emKPLAYERRELATION_TYPE_COUPLE, 0)
      if #tbRelation == 0 then
        return
      end
    end

    if #tbRelation ~= 1 then
      return
    end

    return tbRelation[1]
  end

  -- Truy vấn xem đã kết hôn chưa
  function _KLuaPlayer.IsMarried()
    if not self:GetCoupleName() then
      return 0
    end
    return 1
  end

  -- Có quan hệ bạn bè không
  function _KLuaPlayer.IsFriendRelation(szRelation)
    local tbRelation = self.GetRelationList(Player.emKPLAYERRELATION_TYPE_BIDFRIEND)
    for _, szName in ipairs(tbRelation) do
      if szName == szRelation then
        return 1
      end
    end
    return 0
  end

  function _KLuaPlayer.IsHaveRelation(szRelationPlayer, nRelatinId, bAsMaster)
    local tbRelation = nil
    if bAsMaster then
      tbRelation = self.GetRelationList(nRelatinId, bAsMaster)
    else
      tbRelation = self.GetRelationList(nRelatinId)
    end

    if not tbRelation then
      return 0
    end

    for _, szName in ipairs(tbRelation) do
      if szName == szRelationPlayer then
        return 1
      end
    end
    return 0
  end

  -- Kiểm tra có phải là quan hệ sư đồ không
  function _KLuaPlayer.IsTeacherRelation(szPlayerName, bAsMaster)
    local tbRelation = self.GetRelationList(Player.emKPLAYERRELATION_TYPE_TRAINING, bAsMaster)
    for _, szName in ipairs(tbRelation) do
      if szName == szPlayerName then
        return 1
      end
    end
    tbRelation = self.GetRelationList(Player.emKPLAYERRELATION_TYPE_TRAINED, bAsMaster)
    for _, szName in ipairs(tbRelation) do
      if szName == szPlayerName then
        return 1
      end
    end
    return 0
  end

  -- Lấy cấp độ thân mật
  function _KLuaPlayer.GetFriendFavorLevel(szFriendName)
    local nFavor = self.GetFriendFavor(szFriendName)
    local nLevel = math.ceil(math.sqrt(math.ceil(nFavor / 100)))
    return nLevel
  end

  function _KLuaPlayer.GetLogOutState()
    return self.GetTask(2029, 3)
  end

  function _KLuaPlayer.SetLogOutState(nMissionType)
    return self.SetTask(2029, 3, nMissionType)
  end

  -- Thiết lập ẩn giao diện tổ đội
  function _KLuaPlayer.SetDisableTeam(nState)
    self.CallClientScript({ "Ui:ServerCall", "UI_SYSTEM", "SetDisableTeam", nState or 0 })
  end

  -- Thiết lập ẩn giao diện giao dịch
  function _KLuaPlayer.SetDisableStall(nState)
    self.CallClientScript({ "Ui:ServerCall", "UI_SYSTEM", "SetDisableStall", nState or 0 })
  end

  -- Thiết lập ẩn giao diện bạn bè
  function _KLuaPlayer.SetDisableFriend(nState)
    self.CallClientScript({ "Ui:ServerCall", "UI_SYSTEM", "SetDisableFriend", nState or 0 })
  end

  -- Thêm Bạc khóa liên server
  function _KLuaPlayer.AddGlbBindMoney(nAddMoney, nWay)
    nWay = nWay or 0
    if GLOBAL_AGENT then
      if self.GetBindMoney() + nAddMoney > self.GetMaxCarryMoney() then
        Dbg:WriteLog("AddGlbBindMoney", "Fail", self.szName, nAddMoney, nWay)
        return 0
      end
      self.AddBindMoney(nAddMoney, nWay)
      Dbg:WriteLog("AddGlbBindMoney", "Success", self.szName, nAddMoney, nWay)
      return 1
    end

    local nCurrentMoney = KGCPlayer.OptGetTask(self.nId, KGCPlayer.TSK_CURRENCY_MONEY)
    if nCurrentMoney + nAddMoney > self.GetMaxCarryMoney() then
      Dbg:WriteLog("AddGlbBindMoney", "Fail", self.szName, nAddMoney, nWay)
      return 0
    end
    GCExcute({ "Player:Nor_DataSync_GC", self.szName, nAddMoney })
    self.Msg(string.format("Bạn đã thêm thành công %s lượng Bạc chuyên dụng liên server.", nAddMoney))
    Dbg:WriteLog("AddGlbBindMoney", "Success", self.szName, nAddMoney, nWay)
    return 1
  end

  -- Tiêu hao Bạc khóa liên server
  function _KLuaPlayer.CostGlbBindMoney(nMoney, nWay)
    nWay = nWay or 0
    if GLOBAL_AGENT then
      if nMoney > self.GetBindMoney() then
        Dbg:WriteLog("CostGlbBindMoney", "Fail", self.szName, nMoney, nWay)
        return 0
      end
      self.CostBindMoney(nMoney, nWay)
      Dbg:WriteLog("CostGlbBindMoney", "Success", self.szName, nMoney, nWay)
      return 1
    end

    local nCurrentMoney = KGCPlayer.OptGetTask(self.nId, KGCPlayer.TSK_CURRENCY_MONEY)
    if nMoney > nCurrentMoney then
      Dbg:WriteLog("CostGlbBindMoney", "Fail", self.szName, nMoney, nWay)
      return 0
    end
    GCExcute({ "Player:Nor_DataSync_GC", self.szName, -nMoney })
    self.Msg(string.format("Bạn đã tiêu hao %s lượng Bạc chuyên dụng liên server.", nMoney))
    Dbg:WriteLog("CostGlbBindMoney", "Success", self.szName, nMoney, nWay)
    return 1
  end

  -- Lấy Bạc khóa chuyên dụng liên server
  function _KLuaPlayer.GetGlbBindMoney()
    if GLOBAL_AGENT then
      return self.GetBindMoney()
    end
    local nCurrentMoney = KGCPlayer.OptGetTask(self.nId, KGCPlayer.TSK_CURRENCY_MONEY)
    return nCurrentMoney
  end

  --Vô hiệu hóa kênh trò chuyện (nType loại tương ứng trong bảng, nState 1 là vô hiệu hóa, 0 là bật)
  function _KLuaPlayer.SetChannelState(nType, nState)
    local nDisabledFlag = self.GetDisabledFuncFlag()
    local tbType = {
      --[-1]		--Tất cả các kênh
      [1] = 0, --Kênh chung
      [2] = 1, --Kênh phái
      [3] = 2, --Kênh tộc
      [4] = 3, --Kênh bang
      [5] = 4, --Kênh liên minh bang
      [6] = 5, --Kênh thành
      [7] = 6, --Kênh đội
      [8] = 7, --Kênh lân cận
      [9] = 8, --Kênh mật
      [10] = 22, --Kênh cùng server của liên server
      [11] = 24, --Bạn bè
    }
    if not nType or (not tbType[nType] and nType ~= -1) then
      return 0
    end
    if not nState or nState < 0 or nState > 1 then
      return 0
    end
    if nType == -1 then
      for i, nNum in pairs(tbType) do
        nDisabledFlag = Lib:SetBits(nDisabledFlag, nState, nNum, nNum)
      end
    else
      nDisabledFlag = Lib:SetBits(nDisabledFlag, nState, tbType[nType], tbType[nType])
    end
    self.SetDisabledFuncFlag(nDisabledFlag)
    return 1
  end

  function _KLuaPlayer.GetIp()
    local szAddr = self.GetPlayerIpAddress()
    local nPos = string.find(szAddr, ":")
    if not nPos then
      return szAddr
    end
    return string.sub(szAddr, 1, nPos - 1), string.sub(szAddr, nPos + 1)
  end

  function _KLuaPlayer.NewWorld2(dwMapId, nX, nY)
    if self.IsInCarrier() == 1 then
      local pCarrier = self.GetCarrierNpc()
      if pCarrier then
        pCarrier.NewWorld(dwMapId, nX, nY)
      end
    else
      self.NewWorld(dwMapId, nX, nY)
    end
  end

-------------------------------------------------------------------------------
-- for client
elseif MODULE_GAMECLIENT then
  function _KLuaPlayer.GetSelectNpc()
    local tbTemp = self.GetTempTable("Npc")
    local pNpc = KNpc.GetById(tbTemp.nSelectpNpcId or 0)
    return pNpc
  end

  -- Lấy chuỗi Tip của kỹ năng chỉ định của nhân vật
  function _KLuaPlayer.GetFightSkillTip(nSkillId, nAddPoint, bViewNext)
    local pNpc = self.GetNpc()
    if not pNpc then
      return ""
    end
    local nLevel = pNpc.GetFightSkillLevel(nSkillId)
    local szTitle, szInfo = FightSkill:GetDesc(nSkillId, nLevel + nAddPoint, nAddPoint, bViewNext, pNpc)
    return szTitle, szInfo
  end

  -- Lấy chuỗi Tip tương ứng với tiềm năng
  function _KLuaPlayer.GetPotentialTip(nPotential)
    local tbInfo = {
      [Player.ATTRIB_STR] = {
        szName = "Sức mạnh",
        tbValue = { self.nBaseStrength, self.nStrength - self.nBaseStrength },
        tbProperty = {
          { "Tấn công thường hệ ngoại công", KPlayer.GetStrength2DamagePhysics },
        },
      },
      [Player.ATTRIB_DEX] = {
        szName = "Thân pháp",
        tbValue = { self.nBaseDexterity, self.nDexterity - self.nBaseDexterity },
        tbProperty = {
          { "Tấn công thường hệ ngoại công", KPlayer.GetDexterity2DamagePhysics },
          { "Chính xác", KPlayer.GetDexterity2AttackRate },
          { "Né tránh", KPlayer.GetDexterity2Defence },
        },
      },
      [Player.ATTRIB_VIT] = {
        szName = "Ngoại công",
        tbValue = { self.nBaseVitality, self.nVitality - self.nBaseVitality },
        tbProperty = {
          { "Sinh lực", KPlayer.GetVitality2Life },
        },
      },
      [Player.ATTRIB_ENG] = {
        szName = "Nội công",
        tbValue = { self.nBaseEnergy, self.nEnergy - self.nBaseEnergy },
        tbProperty = {
          { "Tấn công thường hệ nội công", KPlayer.GetEnergy2DamageMagic },
          { "Nội lực", KPlayer.GetEnergy2Mana },
        },
      },
    }

    local tb = tbInfo[nPotential]
    if not tb then
      return ""
    end

    -- Tip giá trị liên quan đến tiềm năng
    local szTipName = string.format("%s: <color=green>%d<color> + <color=gold>%d<color>\n", tb.szName, tb.tbValue[1], tb.tbValue[2])

    -- Tip giá trị thuộc tính bị ảnh hưởng
    local szTipProperty = ""
    for i = 1, #tb.tbProperty do
      local nProperty = tb.tbProperty[i][2](self.nFaction, self.nRouteId, tb.tbValue[1] + tb.tbValue[2])
      if nProperty > 0 then
        szTipProperty = szTipProperty .. string.format("Tăng %s %d điểm\n", tb.tbProperty[i][1], nProperty)
      end
    end

    if szTipProperty == "" then
      szTipProperty = "Tiềm năng này không có ý nghĩa đối với nhánh bạn đã chọn"
    end

    return szTipName .. szTipProperty
  end

  function _KLuaPlayer.GetStateTip(nState)
    local tbInfo = {
      [Npc.STATE_HURT] = "Bị thương",
      [Npc.STATE_SLOWALL] = "Làm chậm",
      [Npc.STATE_WEAK] = "Suy yếu",
      [Npc.STATE_BURN] = "Bỏng",
      [Npc.STATE_STUN] = "Choáng",
    }
    local szInfo = tbInfo[nState]
    if not szInfo then
      return ""
    end

    local nValue = self.GetNpc().GetState(nState).nResistTime
    local szMsg = nValue >= 0 and "Rút ngắn" or "Tăng"
    nValue = math.abs(nValue)
    return string.format("%s thời gian hiệu ứng %s phải chịu %d%%", szMsg, szInfo, math.floor(nValue / (nValue + 250) * 100))
  end

  -- Lấy chuỗi Tip tương ứng với kháng tính
  function _KLuaPlayer.GetResistTip(nResist)
    local tbInfo = {
      [Env.SERIES_METAL] = { "Tấn công thường", self.nGR },
      [Env.SERIES_WOOD] = { "Tấn công độc", self.nPR },
      [Env.SERIES_WATER] = { "Tấn công băng", self.nCR },
      [Env.SERIES_FIRE] = { "Tấn công hỏa", self.nFR },
      [Env.SERIES_EARTH] = { "Tấn công lôi", self.nLR },
    }
    local tb = tbInfo[nResist]
    if not tb then
      return ""
    end

    local pReduce = Player:CountReduceDefence(tb[2])
    local pDefenceValue = 1 / (1 - pReduce / 100) --Giá trị phòng ngự, phần trăm..

    return string.format("Khi bị kẻ địch cùng cấp tấn công %s, sát thương %s<color=gold>%s%%<color>\nTức là khi bị kẻ địch cùng cấp tấn công %s, sát thương chia cho <color=gold>%s%%<color>", tb[1], (pReduce >= 0) and "giảm" or "tăng", math.floor(100 * pReduce) / 100, tb[1], math.floor(100 * pDefenceValue))
  end

  -- Lấy chuỗi Tip tương ứng với tốc độ tấn công
  function _KLuaPlayer.GetAttackSpeedTip()
    local tbSet = KFightSkill.GetSetting()
    local nAttackPerSecond = math.max(tbSet.nAttackFrameMin, Env.GAME_FPS - math.floor(self.nAttackSpeed / 10))
    nAttackPerSecond = math.min(tbSet.nAttackFrameMax, nAttackPerSecond) / Env.GAME_FPS
    nAttackPerSecond = math.floor(nAttackPerSecond * 100 + 0.5) / 100 -- Làm tròn và giữ lại 2 chữ số thập phân
    local nCastPerSecond = math.max(tbSet.nCastFrameMin, Env.GAME_FPS - math.floor(self.nCastSpeed / 10))
    nCastPerSecond = math.min(tbSet.nCastFrameMax, nCastPerSecond) / Env.GAME_FPS
    nCastPerSecond = math.floor(nCastPerSecond * 100 + 0.5) / 100 -- Làm tròn và giữ lại 2 chữ số thập phân

    return "Tốc độ ra đòn của kỹ năng hệ ngoại công, mỗi " .. nAttackPerSecond .. " giây ra đòn 1 lần;\nTốc độ ra đòn của kỹ năng hệ nội công, mỗi " .. nCastPerSecond .. " giây ra đòn 1 lần;\nTốc độ ra đòn của kỹ năng hệ chiến đấu không bị ảnh hưởng bởi tốc độ tấn công."
  end

  -- Lấy kỹ năng tương ứng với vũ khí nhân vật đang cầm
  function _KLuaPlayer.GetWeaponSkill()
    return KFightSkill.GetPlayerWeaponSkill(self)
  end

  -- Danh sách xin gia nhập gia tộc, dữ liệu core lưu trữ lệnh GM.
  function _KLuaPlayer.KinRequest_InitRequestList()
    local tbTemp = self.GetTempTable("Kin")
    if tbTemp then
      if not tbTemp.Kin_tbRequest then
        tbTemp.Kin_tbRequest = {}
        tbTemp.Kin_tbRequest.tbRequestList = {}
        tbTemp.Kin_tbRequest.nCount = Kin.REQUEST_REST_BEGIN -- ID chỉ mục dành riêng cho thao tác cố định
      end
      return 1
    end
    return 0
  end

  function _KLuaPlayer.KinRequest_GetRequestList()
    local tbTemp = self.GetTempTable("Kin")
    if (not tbTemp) or not tbTemp.Kin_tbRequest or not tbTemp.Kin_tbRequest.tbRequestList then
      return nil
    end
    return tbTemp.Kin_tbRequest.tbRequestList
  end

  function _KLuaPlayer.KinRequest_AddRequset(tbRequest, nIndex)
    local tbTemp = self.GetTempTable("Kin")
    if (not tbTemp) or not tbTemp.Kin_tbRequest then
      if self.KinRequest_InitRequestList() ~= 1 then
        return 0
      end
    end
    tbTemp.Kin_tbRequest.nCount = tbTemp.Kin_tbRequest.nCount + 1
    if nIndex then
      tbTemp.Kin_tbRequest.tbRequestList[nIndex] = tbRequest
    else
      tbTemp.Kin_tbRequest.tbRequestList[tbTemp.Kin_tbRequest.nCount] = tbRequest
    end
  end

  function _KLuaPlayer.KinRequest_DelRequest(nKey)
    local tbTemp = self.GetTempTable("Kin")
    if (not tbTemp) or not tbTemp.Kin_tbRequest then
      if self.KinRequest_InitRequestList() ~= 1 then
        return 0
      end
    end
    local tbRequest = tbTemp.Kin_tbRequest.tbRequestList[nKey]
    tbTemp.Kin_tbRequest.tbRequestList[nKey] = nil
    return tbRequest
  end

  -- Danh sách xin gia nhập bang hội, dữ liệu CORE lưu trữ lệnh GM
  function _KLuaPlayer.TongRequest_InitRequestList()
    local tbTemp = self.GetTempTable("Tong")
    if tbTemp then
      if not tbTemp.Tong_tbRequest then
        tbTemp.Tong_tbRequest = {}
        tbTemp.Tong_tbRequest.tbRequestList = {}
      end
      return 1
    end
    return 0
  end

  function _KLuaPlayer.TongRequest_GetRequestList()
    local tbTemp = self.GetTempTable("Tong")
    if (not tbTemp) or not tbTemp.Tong_tbRequest or not tbTemp.Tong_tbRequest.tbRequestList then
      return nil
    end
    return tbTemp.Tong_tbRequest.tbRequestList
  end

  function _KLuaPlayer.TongRequest_AddRequest(nKey, tbRequest)
    local tbTemp = self.GetTempTable("Tong")
    if (not tbTemp) or not tbTemp.Tong_tbRequest then
      if self.TongRequest_InitRequestList() ~= 1 then
        return 0
      end
    end
    if not tbTemp.Tong_tbRequest.tbRequestList then
      tbTemp.Tong_tbRequest.tbRequestList = {}
    end
    tbTemp.Tong_tbRequest.tbRequestList[nKey] = tbRequest
  end

  function _KLuaPlayer.TongRequest_DelRequest(nKey)
    local tbTemp = self.GetTempTable("Tong")
    if (not tbTemp) or not tbTemp.Tong_tbRequest then
      if self.TongRequest_InitRequestList() ~= 1 then
        return 0
      end
    end
    if not tbTemp.Tong_tbRequest.tbRequestList then
      tbTemp.Tong_tbRequest.tbRequestList = {}
    end
    local tbRequest = tbTemp.Tong_tbRequest.tbRequestList[nKey]
    tbTemp.Tong_tbRequest.tbRequestList[nKey] = nil
  end

  -- Bảng quan hệ xã hội, dữ liệu CORE lưu trữ lệnh GM
  function _KLuaPlayer.Relation_InitRelationList()
    local tbTemp = self.GetTempTable("Relation")
    if tbTemp then
      if not tbTemp.Relation_tbRelation then
        tbTemp.Relation_tbRelation = {}
      end
      tbTemp.Relation_tbRelation.tbRelationList = {}
      tbTemp.Relation_tbRelation.tbInfo = {}

      if not tbTemp.Relation_tbRelationGroup then
        tbTemp.Relation_tbRelationGroup = {}
      end

      return 1
    end
    return 0
  end

  function _KLuaPlayer.Relation_AddRelation(tbRelation)
    local tbTemp = self.GetTempTable("Relation")
    if (not tbTemp) or not tbTemp.Relation_tbRelation then
      if self.Relation_InitRelationList() ~= 1 then
        return 0
      end
    end
    local tbList = tbTemp.Relation_tbRelation.tbRelationList
    if not tbList[tbRelation.nType] then
      tbList[tbRelation.nType] = {}
    end

    if tbRelation.nType == Player.emKPLAYERRELATION_TYPE_TMPFRIEND or tbRelation.nType == Player.emKPLAYERRELATION_TYPE_BLACKLIST or tbRelation.nType == Player.emKPLAYERRELATION_TYPE_ENEMEY then
      if tbTemp.Relation_tbRelation.tbInfo[tbRelation.szPlayer] then
        tbTemp.Relation_tbRelation.tbInfo[tbRelation.szPlayer] = nil
      end
    end
    if tbList[tbRelation.nType][tbRelation.szPlayer] then
      return 0
    end
    if not tbList[tbRelation.nType][tbRelation.szPlayer] then
      tbList[tbRelation.nType][tbRelation.szPlayer] = {}
    end
    tbList[tbRelation.nType][tbRelation.szPlayer] = tbRelation
    if tbRelation.nType == Player.emKPLAYERRELATION_TYPE_BIDFRIEND then
      tbTemp.Relation_tbRelation.nFriendNum = (tbTemp.Relation_tbRelation.nFriendNum or 0) + 1
    elseif tbRelation.nType == Player.emKPLAYERRELATION_TYPE_TRAINING then
      if tbRelation.nRole == 0 then
        tbTemp.Relation_tbRelation.nStudentNum = (tbTemp.Relation_tbRelation.nStudentNum or 0) + 1
      else
        tbTemp.Relation_tbRelation.nTeacherNum = (tbTemp.Relation_tbRelation.nTeacherNum or 0) + 1
      end
      tbTemp.Relation_tbRelation.nFriendNum = (tbTemp.Relation_tbRelation.nFriendNum or 0) + 1
    elseif tbRelation.nType == Player.emKPLAYERRELATION_TYPE_TRAINED then
      if tbRelation.nRole == 0 then
        tbTemp.Relation_tbRelation.nStudentNum = (tbTemp.Relation_tbRelation.nStudentNum or 0) + 1
        tbTemp.Relation_tbRelation.nMiyouNum = (tbTemp.Relation_tbRelation.nMiyouNum or 0) + 1
      else
        tbTemp.Relation_tbRelation.nTeacherNum = (tbTemp.Relation_tbRelation.nTeacherNum or 0) + 1
      end
      tbTemp.Relation_tbRelation.nFriendNum = (tbTemp.Relation_tbRelation.nFriendNum or 0) + 1
    elseif (tbRelation.nType == Player.emKPLAYERRELATION_TYPE_INTRODUCTION and tbRelation.nRole == 0) or tbRelation.nType == Player.emKPLAYERRELATION_TYPE_BUDDY then
      tbTemp.Relation_tbRelation.nMiyouNum = (tbTemp.Relation_tbRelation.nMiyouNum or 0) + 1
      if tbRelation.nType == Player.emKPLAYERRELATION_TYPE_BUDDY then
        tbTemp.Relation_tbRelation.nFriendNum = (tbTemp.Relation_tbRelation.nFriendNum or 0) + 1
      end
    end
    return 1
  end

  function _KLuaPlayer.GetRelationNum()
    local tbTemp = self.GetTempTable("Relation")
    local nStudentNum = 0
    local nTeacherNum = 0
    local nMiyouNum = 0

    if not tbTemp.Relation_tbRelation then
      return
    end

    if nil ~= tbTemp.Relation_tbRelation.nStudentNum then
      nStudentNum = tbTemp.Relation_tbRelation.nStudentNum
    end
    if nil ~= tbTemp.Relation_tbRelation.nTeacherNum then
      nTeacherNum = tbTemp.Relation_tbRelation.nTeacherNum
    end
    if nil ~= tbTemp.Relation_tbRelation.nMiyouNum then
      nMiyouNum = tbTemp.Relation_tbRelation.nMiyouNum
    end
    return nStudentNum, nTeacherNum, nMiyouNum
  end

  function _KLuaPlayer.Relation_SetOnlineState(szPlayer, nOnline, nGBOnline)
    nGBOnline = nGBOnline or 0
    local tbTemp = self.GetTempTable("Relation")
    local tbList = tbTemp.Relation_tbRelation.tbRelationList
    for nType, tbRelationData in pairs(tbList) do
      if tbRelationData[szPlayer] then
        tbRelationData[szPlayer].nOnline = nOnline
        tbRelationData[szPlayer].nGBOnline = nGBOnline
      end
    end
  end

  function _KLuaPlayer.Relation_SetRelationInfo(szPlayer, tbInfo)
    local tbTemp = self.GetTempTable("Relation")
    if (not tbTemp) or not tbTemp.Relation_tbRelation then
      if self.Relation_InitRelationList() ~= 1 then
        return 0
      end
    end
    tbTemp.Relation_tbRelation.tbInfo[szPlayer] = tbInfo
    return 1
  end

  function _KLuaPlayer.Relation_DelRelation(nRelationType, szPlayer)
    local tbTemp = self.GetTempTable("Relation")
    if (not tbTemp) or not tbTemp.Relation_tbRelation then
      return
    end
    local tbList = tbTemp.Relation_tbRelation.tbRelationList
    local tbRet
    if tbList[nRelationType] and tbList[nRelationType][szPlayer] then
      tbRet = tbList[nRelationType][szPlayer]
      tbList[nRelationType][szPlayer] = nil
      local nNum = tbTemp.Relation_tbRelation.nFriendNum
      if nNum and nNum > 1 and nRelationType == Player.emKPLAYERRELATION_TYPE_BIDFRIEND then
        tbTemp.Relation_tbRelation.nFriendNum = tbTemp.Relation_tbRelation.nFriendNum - 1
      end
    end
    return tbRet
  end

  function _KLuaPlayer.Relation_GetRelationList()
    local tbTemp = self.GetTempTable("Relation")
    if (not tbTemp) or not tbTemp.Relation_tbRelation then
      return
    end
    return tbTemp.Relation_tbRelation.tbRelationList, tbTemp.Relation_tbRelation.tbInfo, tbTemp.Relation_tbRelation.nFriendNum
  end

  ----- Phân nhóm bạn bè tùy chỉnh
  function _KLuaPlayer.Relation_InitRelationGroupList()
    local tbTemp = self.GetTempTable("Relation")
    if tbTemp then
      if not tbTemp.Relation_tbRelationGroup then
        tbTemp.Relation_tbRelationGroup = {}
      end
      return 1
    end
    return 0
  end

  function _KLuaPlayer.Relation_GetRelationGroupList(nGroupId)
    local tbTemp = self.GetTempTable("Relation")
    if (not tbTemp) or not tbTemp.Relation_tbRelationGroup then
      return
    end
    return tbTemp.Relation_tbRelationGroup[nGroupId]
  end

  function _KLuaPlayer.Relation_AddRelationGroup(nGroupId, tbGroupList)
    local tbTemp = self.GetTempTable("Relation")
    if (not tbTemp) or not tbTemp.Relation_tbRelationGroup then
      if self.Relation_InitRelationGroupList() ~= 1 then
        return 0
      end
    end

    tbTemp.Relation_tbRelationGroup[nGroupId] = tbGroupList

    return 1
  end

  function _KLuaPlayer.Relation_DelRelationGroup(nGroupId)
    local tbTemp = self.GetTempTable("Relation")
    if (not tbTemp) or not tbTemp.Relation_tbRelationGroup then
      if self.Relation_InitRelationGroupList() ~= 1 then
        return 0
      end
    end

    tbTemp.Relation_tbRelationGroup[nGroupId] = nil
    return 1
  end

  function _KLuaPlayer.Relation_DelRelationGroupPlayer(nGroupId, szPlayerName)
    self.CallServerScript({ "RelationCmd", "DelRelationGroupPlayer_C2S", nGroupId, szPlayerName })
  end

  function _KLuaPlayer.Relation_ApplyCreateRelationGroup(nGroupId)
    local tbTemp = self.GetTempTable("Relation")
    if (not tbTemp) or not tbTemp.Relation_tbRelationGroup then
      if self.Relation_InitRelationGroupList() ~= 1 then
        return 0
      end
    end

    self.CallServerScript({ "RelationCmd", "ApplyCreateRelationGroup_C2S", nGroupId })
  end

  function _KLuaPlayer.Relation_ApplyAddRelationGroupPlayer(nGroupId, szPlayerName)
    self.CallServerScript({ "RelationCmd", "ApplyAddRelationGroupPlayer_C2S", nGroupId, szPlayerName })
  end

  function _KLuaPlayer.Relation_ApplyRenameRelationGroup(nGroupId)
    self.CallServerScript({ "RelationCmd", "ApplyRenameRelationGroup_C2S", nGroupId })
  end

  function _KLuaPlayer.Relation_ApplyDelRelationGroup(nGroupId)
    self.CallServerScript({ "RelationCmd", "ApplyDelRelationGroup_C2S", nGroupId })
  end

  function _KLuaPlayer.GetMySelfCheckTime()
    local tbTemp = self.GetTempTable("Relation")
    if (not tbTemp) or not tbTemp.nCheckTime then
      return 0
    else
      return tbTemp.nCheckTime or 0
    end
  end

  function _KLuaPlayer.SetMySelfCheckTime(nTime)
    local tbTemp = self.GetTempTable("Relation")
    tbTemp.nCheckTime = nTime
  end

  -- Lấy danh sách quan hệ sư đồ (bao gồm cả sư phụ và đệ tử)
  function _KLuaPlayer.Relation_GetTrainingRelation()
    local tbList = {}
    local tbRelationList, tbInfoList = self.Relation_GetRelationList()
    if not tbRelationList then
      return
    end
    local tbData = {
      tbRelationList[Player.emKPLAYERRELATION_TYPE_TRAINING],
      tbRelationList[Player.emKPLAYERRELATION_TYPE_TRAINED],
    }
    for i = 1, #tbData do
      if tbData[i] then
        for szPlayer, tbRelation in pairs(tbData[i]) do
          local tbTraining = {}
          local tbInfo = tbInfoList[szPlayer]
          tbTraining.szPlayer = szPlayer
          tbTraining.nType = tbRelation.nType
          tbTraining.nRole = tbRelation.nRole
          if tbInfo then
            tbTraining.nLevel = tbInfo.nLevel
            tbTraining.nFaction = tbInfo.nFaction
            tbTraining.nSex = tbInfo.nSex
            tbTraining.nFavor = tbInfo.nFavor
          else
            tbTraining.nLevel = 0
            tbTraining.nFaction = 0
            tbTraining.nSex = 0
            tbTraining.nFavor = 0
          end
          table.insert(tbList, tbTraining)
        end
      end
    end
    return tbList
  end

  function _KLuaPlayer.GetGoldSuiteAttrib(...)
    return KItem.GetPlayerGoldSuiteAttrib(self, unpack(arg))
  end

  function _KLuaPlayer.GetGreenSuiteAttrib(...)
    return KItem.GetPlayerGreenSuiteAttrib(self, unpack(arg))
  end

  -- Lấy nội dung phần thưởng chuỗi nhiệm vụ
  function _KLuaPlayer.GetChainTaskAward()
    local tbTemp = self.GetTempTable("Task")
    return tbTemp.Task_tbChainTaskAward
  end

  -- Lưu trữ nội dung phần thưởng chuỗi nhiệm vụ
  function _KLuaPlayer.SetChainTaskAward(tbAward)
    local tbTemp = self.GetTempTable("Task")
    tbTemp.Task_tbChainTaskAward = tbAward
  end
  -- Lưu trữ dữ liệu của một hoạt động
  -- szType		: Loại hoạt động
  -- tbDate		: Dữ liệu hoạt động
  -- nUsefulTime 	: Thời gian hiệu lực (số khung hình), sau khi hết thời gian dữ liệu sẽ không hợp lệ, nil là vĩnh viễn
  function _KLuaPlayer.SetCampaignDate(szType, tbDate, nUsefulTime)
    local tbTemp = self.GetTempTable("Ui")
    if not tbTemp.tbCampaignDate then
      tbTemp.tbCampaignDate = {}
    end
    tbTemp.tbCampaignDate.szType = szType
    tbTemp.tbCampaignDate.tbDate = tbDate
    tbTemp.tbCampaignDate.nValdState = 1 -- Đánh dấu dữ liệu hợp lệ
    if tbTemp.tbCampaignDate.nTimerId and tbTemp.tbCampaignDate.nTimerId ~= 0 then
      Player:CloseTimer(tbTemp.tbCampaignDate.nTimerId)
      tbTemp.tbCampaignDate.nTimerId = 0
    end
    if nUsefulTime and nUsefulTime > 0 then
      tbTemp.tbCampaignDate.nTimerId = Player:RegisterTimer(nUsefulTime, self.CampaignDateTimeOut)
    end
    CoreEventNotify(UiNotify.emCOREEVENT_SYNC_CAMPAIGN_DATE, szType) -- Dữ liệu hoạt động đã thay đổi
  end

  -- Lấy dữ liệu giao diện hoạt động đã lưu trữ
  -- Nếu dữ liệu đã không hợp lệ thì trả về nil, ngược lại trả về loại hoạt động szType và bảng dữ liệu tbDate
  function _KLuaPlayer.GetCampaignDate()
    local tbTemp = self.GetTempTable("Ui")
    if not tbTemp.tbCampaignDate then
      return
    end
    if tbTemp.tbCampaignDate.nValdState == 0 then
      return
    end
    return tbTemp.tbCampaignDate.szType, tbTemp.tbCampaignDate.tbDate
  end

  -- Dữ liệu hoạt động đã lưu trữ hết hạn
  function _KLuaPlayer.CampaignDateTimeOut()
    local tbTemp = self.GetTempTable("Ui")
    if not tbTemp.tbCampaignDate then
      return 0
    end
    tbTemp.tbCampaignDate.nValdState = 0
    tbTemp.tbCampaignDate.nTimerId = 0
    CoreEventNotify(UiNotify.emCOREEVENT_SYNC_CAMPAIGN_DATE, tbTemp.tbCampaignDate.szType)
    return 0
  end

  --	Lưu trữ thông tin hóa đơn giao dịch của nhân vật
  function _KLuaPlayer.SetPlayerBillInfo(tbBillInfo)
    local tbTemp = self.GetTempTable("JbExchange")
    tbTemp.JbExchange_tbPlayerBillInfo = tbBillInfo
  end

  --	Lấy thông tin hóa đơn giao dịch của nhân vật
  function _KLuaPlayer.GetPlayerBillInfo()
    local tbTemp = self.GetTempTable("JbExchange")
    return tbTemp.JbExchange_tbPlayerBillInfo
  end

  --	Lưu trữ thông tin hóa đơn giao dịch cần hiển thị trong sàn giao dịch
  function _KLuaPlayer.SetShowBillList(tbInfo, tbShowBill)
    local tbTemp = self.GetTempTable("JbExchange")
    tbTemp.JbExchange_tbShowBill = tbShowBill
    tbTemp.JbExchange_tbInfo = tbInfo
  end

  --	Lấy thông tin hóa đơn giao dịch cần hiển thị
  function _KLuaPlayer.GetShowBillList()
    local tbTemp = self.GetTempTable("JbExchange")
    return tbTemp.JbExchange_tbShowBill
  end

  --	Lấy một số thông tin cơ bản của sàn giao dịch
  function _KLuaPlayer.GetExchangeInfo()
    local tbTemp = self.GetTempTable("JbExchange")
    return tbTemp.JbExchange_tbInfo
  end

  -- Lấy id mẫu của bản đồ người chơi đang ở
  function _KLuaPlayer.GetMapTemplateId()
    local nMapId = self.GetWorldPos()
    return nMapId
  end

  function _KLuaPlayer.SetMailBoxLoadOk()
    local tbTemp = self.GetTempTable("Mail")
    tbTemp.MailBoxLoadOk = 1
  end

  function _KLuaPlayer.GetMailBoxLoadOk()
    local tbTemp = self.GetTempTable("Mail")
    if not tbTemp.MailBoxLoadOk then
      return 0
    else
      return 1
    end
  end

  function _KLuaPlayer.UseSkill(nSkillId, nX, nY)
    UseSkill(nSkillId)
  end

  function _KLuaPlayer.LandInSelCarrier()
    local pNpc = self.GetSelectNpc()
    if not pNpc or pNpc.IsCarrier() == 0 then
      return
    end

    self.CallServerScript({ "LandInClientSelCarrier", pNpc.dwId })
  end

--------------------------------------------------------------------------------
end --if MODULE_GAMESERVER then else end
