--Player toàn cục
--GC, GS, Client dùng chung
--sunduoliang

Require("\\script\\player\\define.lua")

function Player:_Init()
  local tbFactions = Player:LoadFactionXmlFile()
  self.tbFactions = {}
  for nFactionId = self.FACTION_NONE, self.FACTION_NUM do
    self.tbFactions[nFactionId] = tbFactions[nFactionId]
  end

  if MODULE_GAMESERVER then
    local tbSkillAuto, tbShortcutAuto = Player:LoadSkillAutoFile()
    self.tbSkillAuto = tbSkillAuto
    self.tbShortcutAuto = tbShortcutAuto
    Player:ReStoreSkillPointAdd()
  end
end

--Sửa lỗi cộng dư điểm kỹ năng
function Player:ReStoreSkillPointAdd()
  local nMaxPoint = 0
  local tbSkillAuto = self.tbSkillAuto
  for nKind, tb1 in pairs(tbSkillAuto) do
    for nFactionId, tb2 in pairs(tb1) do
      if type(nFactionId) == "number" then
        local nAddSkillPoint = 0
        for nRouteId, tb3 in pairs(tb2) do
          for nLevel, nSkillPoint in pairs(tb3) do
            nAddSkillPoint = nAddSkillPoint + nSkillPoint
          end
        end
        if nMaxPoint < nAddSkillPoint then
          nMaxPoint = nAddSkillPoint
        end
      end
    end

    nMaxPoint = nMaxPoint - nKind + 1
    if nMaxPoint < 0 then
      nMaxPoint = 0
    end

    tbSkillAuto[nKind]["AddSkillPoint"] = nMaxPoint
  end
end

-- Lấy tên nhánh môn phái
--	Nếu nRouteId là 0 hoặc bỏ qua, sẽ trả về tên môn phái, ngược lại trả về tên nhánh
function Player:GetFactionRouteName(nFactionId, nRouteId)
  local tbFaction = self.tbFactions[nFactionId]
  local tbRoute = tbFaction.tbRoutes[nRouteId or 0]
  return (tbRoute or tbFaction).szName
end

-- Lấy ID kỹ năng
-- nFactionId Môn phái
-- nRouteId	  Nhánh
-- nLevel 	  Cấp kỹ năng, 10 là kỹ năng cấp 10, 20 là kỹ năng cấp 20;
function Player:GetFactionRouteSkillId(nFactionId, nRouteId, nLevel)
  local tbFaction = self.tbFactions[nFactionId]
  local tbRoute = tbFaction.tbRoutes[nRouteId]
  if not tbRoute then
    print("[GetFactionRouteSkillId] Không có dữ liệu nhánh này:" .. nRouteId)
    return 0
  end
  local tbSkill = tbRoute.tbSkills[math.floor(nLevel / 10)]
  if not tbSkill then
    print("[GetFactionRouteSkillId] Không có dữ liệu cấp này:" .. nLevel)
    return 0
  end
  return tbSkill.nId
end

-- Lấy số điểm tự động cộng kỹ năng
-- Loại nKind (cấp 69, cấp 89, cấp 99)
-- nFactionId Môn phái
-- nRouteId	  Nhánh
-- nLevel 	  Cấp kỹ năng, 10 là kỹ năng cấp 10, 20 là kỹ năng cấp 20;
function Player:GetSkillAutoPoint(nKind, nFactionId, nRouteId, nLevel)
  if not self.tbSkillAuto[nKind] then
    print("[GetSkillAutoPoint] Phân đoạn cấp độ sai, không có dữ liệu phân đoạn cấp độ này: " .. nKind)
    return 0
  end
  if not self.tbSkillAuto[nKind][nFactionId] then
    print("[GetSkillAutoPoint] ID môn phái sai, không có dữ liệu môn phái này: " .. nFactionId)
    return 0
  end

  if not self.tbSkillAuto[nKind][nFactionId][nRouteId] then
    print("[GetSkillAutoPoint] ID nhánh sai, không có dữ liệu nhánh này: " .. nRouteId)
    return 0
  end

  if not self.tbSkillAuto[nKind][nFactionId][nRouteId][nLevel] then
    print("[GetSkillAutoPoint] Cấp độ sai, không có dữ liệu cấp độ này: " .. nLevel)
    return 0
  end
  return self.tbSkillAuto[nKind][nFactionId][nRouteId][nLevel]
end

-- Lấy số điểm cần tăng (có thể điểm kỹ năng tăng nhiều hơn điểm kỹ năng của người chơi)
-- Loại nKind (cấp 69, cấp 89, cấp 99)
function Player:GetAddSkillPoint(nKind)
  if not self.tbSkillAuto[nKind] then
    print("[GetAddSkillPoint] Phân đoạn cấp độ sai, không có dữ liệu phân đoạn cấp độ này: " .. nKind)
    return 0
  end
  return self.tbSkillAuto[nKind]["AddSkillPoint"]
end

-- Lấy ô kỹ năng nhanh tương ứng
-- Loại nKind (cấp 69, cấp 89, cấp 99)
-- nFactionId Môn phái
-- nRouteId	  Nhánh
-- varLevel 	  Cấp kỹ năng, 10 là kỹ năng cấp 10, 20 là kỹ năng cấp 20; hoặc "LeftSkill" "RightSkill" tương ứng với cấp kỹ năng môn phái của phím tắt trái và phải
function Player:GetShortcutAuto(nKind, nFactionId, nRouteId, valLevel)
  if not self.tbShortcutAuto[nKind] then
    print("[GetShortcutAuto] Phân đoạn cấp độ sai, không có dữ liệu phân đoạn cấp độ này: " .. nKind)
    return 0
  end
  if not self.tbShortcutAuto[nKind][nFactionId] then
    print("[GetShortcutAuto] ID môn phái sai, không có dữ liệu môn phái này: " .. nFactionId)
    return 0
  end

  if not self.tbShortcutAuto[nKind][nFactionId][nRouteId] then
    print("[GetShortcutAuto] ID nhánh sai, không có dữ liệu nhánh này: " .. nRouteId)
    return 0
  end

  if not self.tbShortcutAuto[nKind][nFactionId][nRouteId][valLevel] then
    return 0
  end

  return self.tbShortcutAuto[nKind][nFactionId][nRouteId][valLevel]
end

function Player:LoadFactionXmlFile()
  local tbCamp = {
    ["Tân thủ"] = 0,
    ["Chính phái"] = 1,
    ["Tà phái"] = 2,
    ["Trung lập"] = 3,
  }
  local tbFactionsXml = KFile.LoadXmlFile("\\setting\\faction\\faction.xml").children
  local tbFactions = {}
  for _, tbFaction in pairs(tbFactionsXml) do
    local nFactionId = tonumber(tbFaction.attrib.id) or 0
    tbFactions[nFactionId] = {}
    tbFactions[nFactionId].nId = nFactionId

    tbFactions[nFactionId].szName = tbFaction.attrib.name or "" --Tên môn phái
    tbFactions[nFactionId].nSeries = tonumber(tbFaction.attrib.series) or 0 --ID ngũ hành môn phái
    tbFactions[nFactionId].szCamp = tbFaction.attrib.camp or "" --Mô tả phe phái
    tbFactions[nFactionId].nSexLimit = tonumber(tbFaction.attrib.sexlimit) or 0 --Thuộc tính giới tính môn phái
    tbFactions[nFactionId].nCamp = 0
    if tbCamp[tbFactions[nFactionId].szCamp] then
      tbFactions[nFactionId].nCamp = tbCamp[tbFactions[nFactionId].szCamp]
    end
    tbFactions[nFactionId].tbRoutes = {}
    tbFactions[nFactionId].tbRoutes.n = 0
    if tbFaction.children and type(tbFaction.children) == "table" then
      for _, tbRoute in pairs(tbFaction.children) do
        local nRouteId = tonumber(tbRoute.attrib.id) or 0
        if nRouteId > 0 then
          tbFactions[nFactionId].tbRoutes.n = tbFactions[nFactionId].tbRoutes.n + 1
        end
        local tbRouteTmp = {}
        tbFactions[nFactionId].tbRoutes[nRouteId] = tbRouteTmp
        tbRouteTmp.nId = nRouteId
        tbRouteTmp.szName = tbRoute.attrib.name or "" --Tên môn phái
        tbRouteTmp.szDesc = tbRoute.attrib.desc or "" --Tên môn phái
        tbRouteTmp.tbSkills = {}
        if tbRoute.children and type(tbRoute.children) == "table" then
          for _, tbSkill in pairs(tbRoute.children) do
            local nSkillId = tonumber(tbSkill.attrib.id) or 0
            local szName = tbSkill.attrib.name or ""
            table.insert(tbRouteTmp.tbSkills, { nId = nSkillId, szName = szName })
          end
        end
      end
    end
  end
  return tbFactions
end

function Player:LoadSkillAutoFile()
  local tbFile = Lib:LoadTabFile("\\setting\\player\\skillauto.txt")
  if not tbFile then
    print("[Lỗi đọc tệp] skillauto.txt")
    return {}, {}
  end
  local tbSkillAuto = {} --Tự động phân phối kỹ năng
  local tbShortcutAuto = {} -- Tự động phân phối ô phím tắt
  for nId, tbSkills in ipairs(tbFile) do
    if nId >= 2 then
      local nSkillCount = 0
      local nKind = tonumber(tbSkills.Kind)
      local nFactionId = tonumber(tbSkills.FactionId)
      local nRouteId = tonumber(tbSkills.RouteId)
      tbSkillAuto[nKind] = tbSkillAuto[nKind] or {}
      tbSkillAuto[nKind][nFactionId] = tbSkillAuto[nKind][nFactionId] or {}
      tbSkillAuto[nKind][nFactionId][nRouteId] = tbSkillAuto[nKind][nFactionId][nRouteId] or {}

      tbShortcutAuto[nKind] = tbShortcutAuto[nKind] or {}
      tbShortcutAuto[nKind][nFactionId] = tbShortcutAuto[nKind][nFactionId] or {}
      tbShortcutAuto[nKind][nFactionId][nRouteId] = tbShortcutAuto[nKind][nFactionId][nRouteId] or {}

      --Đã kiểm tra kỹ năng đến cấp 150
      for i = 1, 15 do
        local tbData = Lib:SplitStr(tbSkills["Skill" .. (i * 10)] or "", "|")
        local nSkill = tonumber(tbData[1]) or 0
        local nPosition = tonumber(tbData[2]) or 0
        tbSkillAuto[nKind][nFactionId][nRouteId][i * 10] = nSkill
        nSkillCount = nSkillCount + nSkill
        if nPosition > 0 and nPosition <= Item.SHORTCUTBAR_OBJ_MAX_SIZE then
          tbShortcutAuto[nKind][nFactionId][nRouteId][i * 10] = nPosition
        end
      end
      local nAddSkillPoint = nSkillCount - nKind --Điểm còn thiếu,
      if nAddSkillPoint >= 0 then
        tbSkillAuto[nKind]["AddSkillPoint"] = nAddSkillPoint + 1
      end
      local nLeft = tonumber(tbSkills.LeftSkill) or 0
      tbShortcutAuto[nKind][nFactionId][nRouteId]["LeftSkill"] = nLeft
      local nRight = tonumber(tbSkills.RightSkill) or 0
      tbShortcutAuto[nKind][nFactionId][nRouteId]["RightSkill"] = nRight
    end
  end
  return tbSkillAuto, tbShortcutAuto
end

Player:_Init()

--Lấy loại hành vi của người chơi
--Loại 0: Người chơi mặc định
--Loại 1: Người chơi bình thường
--Loại 2: Người chơi mới hoặc tài khoản phụ
--Loại 3: Tài khoản phụ hoặc phòng làm việc nhỏ
--Loại 4: Phòng làm việc vừa và nhỏ
--Loại 5: Phòng làm việc có quy mô nhất định
--Loại 6: Phòng làm việc quy mô lớn
--Loại 7: Phòng làm việc quy mô
--Tên nhân vật, loại, GCGS tự động đồng bộ (không điền hoặc điền nil, 0 thì tự động đồng bộ, 1 thì không đồng bộ)
function Player:SetActionKind(szName, nKind, nSync)
  if nKind < 0 or nKind > 128 then
    return 0
  end
  if MODULE_GAMESERVER then
    if KGCPlayer.SetActionKind(szName, nKind) == 1 then
      if nSync ~= 1 then
        GCExcute({ "Player:SetActionKind", szName, nKind })
      end
      return 1
    end
  end
  if MODULE_GC_SERVER then
    if KGCPlayer.SetActionKind(szName, nKind) == 1 then
      if nSync ~= 1 then
        GlobalExcute({ "KGCPlayer.SetActionKind", szName, nKind })
      end
      return 1
    end
  end
  return 0
end

--Thiết lập
function Player:SetActionKind_G(szName, nKind)
  return KGCPlayer.SetActionKind(szName, nKind)
end

--Lấy loại hành vi của người chơi
--Loại 0: Người chơi mặc định
--Loại 1: Người chơi bình thường
--Loại 2: Người chơi mới hoặc tài khoản phụ
--Loại 3: Tài khoản phụ hoặc phòng làm việc nhỏ
--Loại 4: Phòng làm việc vừa và nhỏ
--Loại 5: Phòng làm việc có quy mô nhất định
--Loại 6: Phòng làm việc quy mô lớn
--Loại 7: Phòng làm việc quy mô
function Player:GetActionKind(szName)
  local nId = KGCPlayer.GetPlayerIdByName(szName)
  if nId then
    local tbInfo = KGCPlayer.GCPlayerGetInfo(nId)
    if tbInfo then
      return tbInfo.nActionKind or -1
    end
    return -1
  end
  return -1
end

function Player:SetActionKindByFile(szFilePath)
  local tbFile = Lib:LoadTabFile(szFilePath)
  if not tbFile then
    return "Tệp không tồn tại"
  end
  local nSCount = 0
  local nFCount = 0
  for _, tb in ipairs(tbFile) do
    if tb.szGateway == GetGatewayName() then
      local nId = KGCPlayer.GetPlayerIdByName(tb.szName)
      if nId and Player:SetActionKind(tb.szName, tonumber(tb.nKind) or 0, 1) == 1 then
        nSCount = nSCount + 1
      else
        nFCount = nFCount + 1
      end
    end
  end
  if MODULE_GC_SERVER then
    --Cách viết này không tốt, tên máy chủ hoặc kiến trúc thay đổi sẽ không thể sử dụng đồng bộ, cách viết tạm thời. todo
    local szGStoGCPath = "\\..\\gamecenter" --Chỉ mục thư mục GS chuyển vào GC
    GlobalExcute({ "Player:SetActionKindByFile", szGStoGCPath .. szFilePath })
  end
  return string.format("Thành công(%s);Thất bại(%s)", nSCount, nFCount)
end
