Require("\\script\\task\\armycamp\\item\\army_token.lua")

-- Phù truyền tống

local tbChuangsongfu = Item:GetClass("chuansongfu")

tbChuangsongfu.nTime = 10 -- Thời gian trì hoãn (giây)
tbChuangsongfu.HORSE_SKILLID = 1417

-- UNDONE: zbl	Cách viết tạm thời, sau này sẽ thay đổi để kiểm tra tham số bảng cấu hình
tbChuangsongfu.tbTransItemId = {
  [3] = { "tbHomeMap", 1 }, --Tân Thủ Thôn giới hạn
  [4] = { "tbCityMap", 1 }, --Thành thị giới hạn
  [19] = { "tbGenreMap", 1 }, --Môn phái giới hạn
  [20] = { "tbHomeMap", 0 }, --Tân Thủ Thôn vô hạn
  [21] = { "tbCityMap", 0 }, --Thành thị vô hạn
  [22] = { "tbGenreMap", 0 }, --Môn phái vô hạn
  [55] = { "tbHomeMap", 1 }, --Tân Thủ Thôn giới hạn
} -- Id của các loại phù truyền tống

tbChuangsongfu.tbNewTransItem = { [195] = 0, [235] = 0 } --Phù truyền tống vô hạn

-- Phù truyền tống đến tân thủ thôn
tbChuangsongfu.tbHomeMap = {
  ["Vân Trung Trấn"] = { 1, 1389, 3102 },
  ["Vĩnh Lạc Trấn"] = { 3, 1693, 3288 },
  ["Thạch Cổ Trấn"] = { 6, 1572, 3106 },
  ["Long Tuyền Thôn"] = { 7, 1510, 3268 },
  ["Long Môn Trấn"] = { 2, 1785, 3586 },
  ["Giang Tân Thôn"] = { 5, 1597, 3131 },
  ["Đạo Hương Thôn"] = { 4, 1624, 3253 },
  ["Ba Lăng Huyện"] = { 8, 1721, 3381 },
}

-- Phù truyền tống đến thành thị
tbChuangsongfu.tbCityMap = {
  ["Dương Châu Phủ"] = { 26, 1641, 3129 },
  ["Tương Dương Phủ"] = { 25, 1630, 3169 },
  ["Lâm An Phủ"] = { 29, 1605, 3946 },
  ["Phượng Tường Phủ"] = { 24, 1767, 3540 },
  ["Đại Lý Phủ"] = { 28, 1439, 3366 },
  ["Thành Đô Phủ"] = { 27, 1666, 3260 },
  ["Biện Kinh Phủ"] = { 23, 1486, 3179 },
}

-- Phù truyền tống đến môn phái
tbChuangsongfu.tbGenreMap = {
  ["Võ Đang Phái"] = { 14, 1435, 2991 },
  ["Ngũ Độc Giáo"] = { 20, 1574, 3145 },
  ["Thiên Vương Bang"] = { 22, 1663, 3039 },
  ["Thiên Nhẫn Giáo"] = { 10, 1658, 3324 },
  ["Đường Môn"] = { 18, 1633, 3179 },
  ["Thiếu Lâm Phái"] = { 9, 1702, 3093 },
  ["Côn Lôn Phái"] = { 12, 1700, 3080 },
  ["Cái Bang"] = { 15, 1606, 3245 },
  ["Nga Mi Phái"] = { 16, 1584, 3041 },
  ["Thúy Yên Môn"] = { 17, 1487, 3093 },
  ["Đại Lý Đoàn Thị"] = { 19, 1618, 3120 },
  ["Minh Giáo"] = { 224, 1625, 3181 },
  ["Cổ Mộ Phái"] = { 2261, 1733, 3054 },
}

tbChuangsongfu.tbBaihutang = {
  ["Điểm đăng ký Dương Châu Phủ"] = { 26, 1454, 3220 },
  ["Điểm đăng ký Tương Dương Phủ"] = { 25, 1596, 3258 },
  ["Điểm đăng ký Lâm An Phủ"] = { 29, 1691, 3899 },
  ["Điểm đăng ký Phượng Tường Phủ"] = { 24, 1841, 3395 },
  ["Điểm đăng ký Đại Lý Phủ"] = { 28, 1549, 3242 },
  ["Điểm đăng ký Thành Đô Phủ"] = { 27, 1593, 3117 },
  ["Điểm đăng ký Biện Kinh Phủ"] = { 23, 1568, 3162 },
}

tbChuangsongfu.tbXiaoyaogu = {
  ["Điểm đăng ký Biện Kinh Phủ"] = { 23, 1460, 3081 },
}

tbChuangsongfu.tbSuperBattle = {
  ["Điểm đăng ký Tương Dương Phủ"] = { 25, 1638, 3300 },
  ["Điểm đăng ký Biện Kinh Phủ"] = { 23, 1680, 3090 },
}

tbChuangsongfu.tbBaseMap = {} -- Bản đồ cơ bản, có thể truyền tống trực tiếp (sẽ được các module khác gọi)

function tbChuangsongfu:Init()
  -- Bản đồ quân doanh
  local tbArmyMap = {}
  for _, tbPosInfo in ipairs(Item:GetClass("army_token").tbTransMap) do
    tbArmyMap[tbPosInfo[1]] = { unpack(tbPosInfo, 2) }
  end

  -- Tất cả bản đồ "cơ bản" mà phù truyền tống vô hạn có thể đến
  -- (Bạch Hổ, Tống Kim, Tiêu Dao khá phức tạp, không được phân loại là bản đồ cơ bản)
  local tbMapSet = {
    self.tbHomeMap, -- Tân Thủ Thôn
    self.tbCityMap, -- Thành thị
    self.tbGenreMap, -- Môn phái
    tbArmyMap, -- Quân doanh
  }
  self.tbBaseMap = {}
  for _, tbPosSet in ipairs(tbMapSet) do
    for szName, tbPos in pairs(tbPosSet) do
      if type(tbPos) == "table" then
        self.tbBaseMap[tbPos[1]] = {
          szName = szName,
          nMapId = tbPos[1],
          nX = tbPos[2],
          nY = tbPos[3],
        }
      end
    end
  end
end

function tbChuangsongfu:OnUse()
  if self.tbNewTransItem[it.nParticular] then
    local szMsg = "Muốn đi đâu thì đi đó!<pic=48>"
    local tbOpt = {
      { "Tân Thủ Thôn", self.OnTransItem, self, it, self.tbHomeMap, self.tbNewTransItem[it.nParticular] },
      { "Thành thị", self.OnTransItem, self, it, self.tbCityMap, self.tbNewTransItem[it.nParticular] },
      { "Môn phái", self.OnTransItem, self, it, self.tbGenreMap, self.tbNewTransItem[it.nParticular] },
      { "Bạch Hổ Đường", self.OnTransItem, self, it, self.tbBaihutang, self.tbNewTransItem[it.nParticular] },
      { "Chiến trường Tống Kim", self.OnTransBattle, self, it.dwId },
      { "Tiêu Dao Cốc", self.OnTransItem, self, it, self.tbXiaoyaogu, self.tbNewTransItem[it.nParticular] },
      { "Quân doanh", self.OnTransArmyCamp, self, it.dwId },
      { "<color=yellow>Tống Kim liên server<color>", self.OnTransItem, self, it, self.tbSuperBattle, self.tbNewTransItem[it.nParticular] },
    }

    local nSkillLevel = me.GetSkillState(self.HORSE_SKILLID)
    if nSkillLevel > 0 then
      local nIndex = Map.tbChuanSongMapInfo.tbMapIndex["Bản đồ ngoại ô"]
      local tbSubMap = Map.tbChuanSongMapInfo.tbSubMap[nIndex]
      table.insert(tbOpt, #tbOpt + 1, { "<color=yellow>Bản đồ ngoại ô<color>", self.OnTransItemEx, self, it, tbSubMap, self.tbNewTransItem[it.nParticular] })
    end

    if Wlls:GetMacthState() == Wlls.DEF_STATE_ADVMATCH and me.nFightState == 0 then
      table.insert(tbOpt, { "<color=yellow>【Quan sát】Bán kết giải đấu<color>", Wlls.OnLookDialog, Wlls })
    end
    if HomeLand:GetMapIdByPlayerId(me.nId) > 0 and me.nFightState == 0 then
      table.insert(tbOpt, { "<color=yellow>Lãnh thổ gia tộc<color>", self.OnTransHomeLand, self })
    end
    table.insert(tbOpt, #tbOpt + 1, { "Ta suy nghĩ thêm" })

    Dialog:Say(szMsg, tbOpt)
    return 0
  end
  if not self.tbTransItemId[it.nParticular] then
    return 0
  end
  self:OnTransItem(it, self[self.tbTransItemId[it.nParticular][1]], self.tbTransItemId[it.nParticular][2])
  return 0 -- Hàm OnUse trả về 0 không xóa; trả về 1 có nghĩa là xóa
end

function tbChuangsongfu:OnTransHomeLand()
  local tbOpt = {
    { "Xác nhận", HomeLand.EnterHomeLand, HomeLand },
    { "Ta suy nghĩ thêm" },
  }
  Dialog:Say("Xác nhận đến lãnh thổ gia tộc?\n", tbOpt)
end

-- Chức năng:	Nhấp vào phù truyền tống, chọn nơi có thể đến
-- Tham số:	pItem		Đối tượng phù truyền tống này
-- Tham số:	tbPos		Table thông tin một tân thủ thôn, thành thị hoặc môn phái nào đó
-- Tham số:	nIsLimit	Đánh dấu là phù truyền tống hay phù truyền tống vô hạn (nIsLimit=1 nghĩa là đang sử dụng phù truyền tống thường, nIsLimit=0 nghĩa là phù truyền tống vô hạn)
-- Tham số:	szFrom		Từ khóa của trang hiện tại bắt đầu từ tùy chọn tiếp theo của szFrom
function tbChuangsongfu:OnTransItem(pItem, tbPosTb, nIsLimit, szFrom)
  local tbOpt = {}
  local nCount = 9

  -- TODO: zbl Chưa xử lý trường hợp khi một trang không chứa hết dữ liệu này
  for szName, tbPos in next, tbPosTb, szFrom do
    local tbPerPos = tbPosTb[szName]
    if nCount <= 0 then
      tbOpt[#tbOpt] = { "Trang tiếp", self.OnTransItem, self, pItem, tbPosTb, nIsLimit, tbOpt[#tbOpt - 1][1] }
      break
    end
    tbOpt[#tbOpt + 1] = { szName, self.DelayTime, self, pItem, tbPerPos, nIsLimit, szName }
    nCount = nCount - 1
  end
  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }
  Dialog:Say("Muốn đi đâu thì đi đó!<pic=48>", tbOpt)
end

function tbChuangsongfu:OnTransItemEx(pItem, tbPosTb, nIsLimit, szFrom)
  local tbOpt = {}

  if not tbPosTb then
    return
  end

  if tbPosTb.tbMapList and #tbPosTb.tbMapList > 0 then
    self:OnShowMapList(pItem, tbPosTb, 1, nIsLimit, szFrom)
    return
  end

  if not tbPosTb.tbMapIndex then
    return
  end

  if not tbPosTb.tbSubMap then
    return
  end

  for i, tbPos in ipairs(tbPosTb.tbSubMap) do
    tbOpt[#tbOpt + 1] = { tbPos.szSubName, self.OnTransItemEx, self, pItem, tbPos, nIsLimit, szFrom }
  end

  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }
  Dialog:Say("Muốn đi đâu thì đi đó!<pic=48>", tbOpt)
end

function tbChuangsongfu:OnShowMapList(pItem, tbPosTb, nPage, nIsLimit, szFrom)
  local tbOpt = {}
  local tbMapList = tbPosTb.tbMapList
  local nStart = (nPage - 1) * 10 + 1
  local nEnd = nPage * 10
  if nEnd > #tbMapList then
    nEnd = #tbMapList
  end
  if nPage > 1 then
    tbOpt[#tbOpt + 1] = { "Trang trước", self.OnShowMapList, self, pItem, tbMapList, nPage - 1, nIsLimit, szFrom }
  end
  for i = nStart, nEnd do
    local szName = tbMapList[i].szName
    local tbPerPos = { tbMapList[i].nMapId, tbMapList[i].nX, tbMapList[i].nY }
    local nFightState = tbMapList[i].nFightsSate
    tbOpt[#tbOpt + 1] = { szName, self.DelayTime, self, pItem, tbPerPos, nIsLimit, szName, nFightState }
  end

  if nEnd < #tbMapList then
    tbOpt[#tbOpt + 1] = { "Trang sau", self.OnShowMapList, self, pItem, tbMapList, nPage + 1, nIsLimit, szFrom }
  end

  tbOpt[#tbOpt + 1] = { "Kết thúc đối thoại" }
  Dialog:Say("Muốn đi đâu thì đi đó!<pic=48>", tbOpt)
end

-- Chức năng:	Sau khi nhấp vào phù truyền tống, người chơi trong trạng thái chiến đấu sẽ bị trì hoãn self.nTime (giây), ngược lại không trì hoãn
-- Tham số:	pItem		Đối tượng phù truyền tống này
-- Tham số:	tbPos		Table thông tin một tân thủ thôn, thành thị hoặc môn phái nào đó
-- Tham số:	nIsLimit	Có phải phù truyền tống vô hạn hay không
-- Tham số:	szName		Tên nơi mà phù truyền tống hiện tại sẽ truyền tống đến
function tbChuangsongfu:DelayTime(pItem, tbPos, nIsLimit, szName, nFightState)
  if not me or not pItem then
    return
  end
  local szForbitMap = KItem.GetOtherForbidType(unpack(pItem.TbGDPL()))
  local nCanUse = 1
  if szForbitMap then
    nCanUse = KItem.CheckLimitUse(me.nMapId, szForbitMap)
  end
  if not nCanUse or nCanUse == 0 then
    me.Msg("Đạo cụ này bị cấm sử dụng ở bản đồ hiện tại!")
    return
  end
  -- Người chơi trong trạng thái không chiến đấu truyền tống không trì hoãn, truyền tống bình thường
  -- Nếu là CallClientScript thì không trì hoãn, gọi trực tiếp
  if 0 == me.nFightState or type(tbPos) == "string" then
    self:TransPlayer(pItem.dwId, tbPos, nIsLimit, szName, nFightState)
    return
  end
  local tbEvent = {
    Player.ProcessBreakEvent.emEVENT_MOVE,
    Player.ProcessBreakEvent.emEVENT_ATTACK,
    Player.ProcessBreakEvent.emEVENT_SITE,
    Player.ProcessBreakEvent.emEVENT_USEITEM,
    Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
    Player.ProcessBreakEvent.emEVENT_DROPITEM,
    Player.ProcessBreakEvent.emEVENT_SENDMAIL,
    Player.ProcessBreakEvent.emEVENT_TRADE,
    Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
    Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
    Player.ProcessBreakEvent.emEVENT_LOGOUT,
    Player.ProcessBreakEvent.emEVENT_DEATH,
    Player.ProcessBreakEvent.emEVENT_ATTACKED,
  }
  GeneralProcess:StartProcess("Đang truyền tống...", self.nTime * Env.GAME_FPS, { self.TransPlayer, self, pItem.dwId, tbPos, nIsLimit, szName, nFightState }, nil, tbEvent)
end

-- Chức năng:	Truyền tống người chơi
-- Tham số:	pItem		Đối tượng phù truyền tống này
-- Tham số:	tbPos		Table thông tin một tân thủ thôn, thành thị hoặc môn phái nào đó
-- Tham số:	nIsLimit	Đánh dấu là phù truyền tống thường hay phù truyền tống vô hạn (nIsLimit=1 nghĩa là đang sử dụng phù truyền tống thường, nIsLimit=0 nghĩa là phù truyền tống vô hạn)
-- Tham số:	szName		Tên nơi mà phù truyền tống hiện tại sẽ truyền tống đến
function tbChuangsongfu:TransPlayer(nItemId, tbPos, nIsLimit, szName)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return
  end
  if nIsLimit == 1 then
    if me.DelItem(pItem, Player.emKLOSEITEM_USE) ~= 1 then
      me.Msg("Xóa phù truyền tống thất bại!")
      return
    end
  end
  if type(tbPos) == "table" then
    me.Msg(string.format("Ngồi vững, %s!", szName))
    me.NewWorld(unpack(tbPos))
    if nFightState then
      me.SetFightState(nFightState)
    end
    Npc.tbFollowPartner:FollowNewWorld(me, unpack(tbPos))
  elseif type(tbPos) == "string" then
    me.CallClientScript({ tbPos })
  end
end

function tbChuangsongfu:OnTransBattle(nItemId)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return
  end
  Setting:SetGlobalObj(me, him, pItem)
  Item:GetClass("songjinzhaoshu"):OnUse()
  Setting:RestoreGlobalObj()
end

function tbChuangsongfu:OnTransArmyCamp(nItemId)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return
  end
  Setting:SetGlobalObj(me, him, pItem)
  Item:GetClass("army_token"):OnUse()
  Setting:RestoreGlobalObj()
end

-- Kiểm tra có phù truyền tống vô hạn hay không (sẽ được các module khác gọi)
function tbChuangsongfu:GetUnlimitedTrans()
  if me.IsInCarrier() == 1 then
    return
  end

  if me.IsLimitTrans() == 1 then
    return
  end

  for nParticular, nIsLimit in pairs(self.tbNewTransItem) do
    local tbItem = me.FindItemInBags(18, 1, nParticular, 1)[1]
    if tbItem and nIsLimit == 0 then
      return tbItem.pItem
    end
  end
  -- Người dùng đặc quyền không cần sử dụng đạo cụ
  local nCurDate = tonumber(GetLocalDate("%y%m%d"))
  if math.floor(me.GetTask(2038, 7) / 100) >= math.floor(nCurDate / 100) then
    return 1
  end
  return nil
end

-- Client gửi lệnh bay trực tiếp đến bản đồ nào đó
function tbChuangsongfu:OnClientCall(nMapId)
  local pItem = self:GetUnlimitedTrans()
  if not pItem then
    me.Msg("Này đại hiệp, xin ngươi hãy kiếm phù truyền tống trước đã.")
    return
  end
  local tbPos = self.tbBaseMap[nMapId]
  if not tbPos then
    me.Msg("Nơi này không thể đến được.")
    return
  end
  if type(pItem) == "number" then -- Trả về là số thì là người dùng đặc quyền
    SpecialEvent.tbTequan.tbChuansong:DelayTime({ tbPos.nMapId, tbPos.nX, tbPos.nY }, tbPos.szName)
  else
    self:DelayTime(pItem, { tbPos.nMapId, tbPos.nX, tbPos.nY }, 0, tbPos.szName)
  end
end

tbChuangsongfu:Init()
