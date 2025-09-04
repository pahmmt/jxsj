-- Định nghĩa hằng số môn phái
Player.FACTION_NONE = 0 -- Không có môn phái
Player.FACTION_SHAOLIN = Env.FACTION_ID_SHAOLIN -- Thiếu Lâm
Player.FACTION_TIANWANG = Env.FACTION_ID_TIANWANG -- Thiên Vương
Player.FACTION_TANGMEN = Env.FACTION_ID_TANGMEN -- Đường Môn
Player.FACTION_WUDU = Env.FACTION_ID_WUDU -- Ngũ Độc
Player.FACTION_EMEI = Env.FACTION_ID_EMEI -- Nga Mi
Player.FACTION_CUIYAN = Env.FACTION_ID_CUIYAN -- Thúy Yên
Player.FACTION_GAIBANG = Env.FACTION_ID_GAIBANG -- Cái Bang
Player.FACTION_TIANREN = Env.FACTION_ID_TIANREN -- Thiên Nhẫn
Player.FACTION_WUDANG = Env.FACTION_ID_WUDANG -- Võ Đang
Player.FACTION_KUNLUN = Env.FACTION_ID_KUNLUN -- Côn Lôn
Player.FACTION_MINGJIAO = Env.FACTION_ID_MINGJIAO -- Minh Giáo
Player.FACTION_DUANSHI = Env.FACTION_ID_DALIDUANSHI -- Đại Lý Đoàn Thị
Player.FACTION_GUMU = Env.FACTION_ID_GUMU -- Cổ Mộ
Player.FACTION_NUM = Env.FACTION_NUM -- Số lượng môn phái

-- TODO: Lưu Sướng, những cái dưới đây chỉ dùng cho nhiệm vụ, tạm thời chưa sửa
Player.ROUTE_DAOSHAOLIN = 1
Player.ROUTE_GUNSHAOLIN = 2

Player.ROUTE_QIANGTIANWANG = 1
Player.ROUTE_CHUITIANWANG = 2

Player.ROUTE_FEIDAOTANGMEN = 1
Player.ROUTE_XIUJIANTANGMEN = 2

Player.ROUTE_DAOWUDU = 1
Player.ROUTE_ZHANGWUDU = 2

Player.ROUTE_ZHANGEMEI = 1
Player.ROUTE_FUZHUEMEI = 2

Player.ROUTE_JIANCUIYAN = 1
Player.ROUTE_DAOCUIYAN = 2

Player.ROUTE_ZHANGGAIBANG = 1
Player.ROUTE_GUNGAIBANG = 2

Player.ROUTE_ZHANTIANREN = 1
Player.ROUTE_MOTIANREN = 2

Player.ROUTE_QIWUDANG = 1
Player.ROUTE_JIANWUDANG = 2

Player.ROUTE_DAOKUNLUN = 1
Player.ROUTE_JIANKUNLUN = 2

Player.ROUTE_CHUIMINGJIAO = 1
Player.ROUTE_JIANMINGJIAO = 2

Player.ROUTE_ZHIDUANSHI = 1
Player.ROUTE_QIDUANSHI = 2

Player.ROUTE_JIANGUMU = 1
Player.ROUTE_ZHENGUMU = 2

-- Enum quan hệ xã hội include\gamecenter\playerrelation_i.h
-- KEPLAYERRELATION_TYPE
Player.emKPLAYERRELATION_TYPE_TMPFRIEND = 0 -- Bạn tạm thời, quan hệ một chiều, A thêm B làm bạn tạm thời
Player.emKPLAYERRELATION_TYPE_BLACKLIST = 1 -- Danh sách đen, quan hệ một chiều, A thêm B vào danh sách đen
Player.emKPLAYERRELATION_TYPE_BIDFRIEND = 2 -- Bạn bè thông thường, quan hệ hai chiều tương đương, A và B là bạn của nhau
Player.emKPLAYERRELATION_TYPE_SIBLING = 3 -- Kết bái (huynh đệ, tỷ muội), quan hệ hai chiều tương đương, A và B kết bái với nhau (huynh đệ, tỷ muội)
Player.emKPLAYERRELATION_TYPE_ENEMEY = 4 -- Kẻ thù, quan hệ hai chiều không tương đương, A đã từng bị B giết
Player.emKPLAYERRELATION_TYPE_TRAINING = 5 -- Sư đồ, quan hệ hai chiều không tương đương, A là sư phụ của B (chưa xuất sư)
Player.emKPLAYERRELATION_TYPE_TRAINED = 6 -- Sư đồ, quan hệ hai chiều không tương đương, A là sư phụ của B (đã xuất sư)
Player.emKPLAYERRELATION_TYPE_COUPLE = 7 -- Phu thê, quan hệ hai chiều không tương đương, A là chồng của B
Player.emKPLAYERRELATION_TYPE_INTRODUCTION = 8 -- Giới thiệu, quan hệ hai chiều không tương đương, A là người giới thiệu của B
Player.emKPLAYERRELATION_TYPE_BUDDY = 9 -- Tri kỷ chỉ định, quan hệ hai chiều tương đương, A và B là tri kỷ của nhau đồng thời cũng là bạn bè thông thường của nhau
Player.emKPLAYERRELATION_TYPE_COUNT = 10
Player.emKPLAYERRELATION_TYPE_GLOBALFRIEND = 100 -- Bạn liên server, quan hệ này chỉ dùng để hiển thị trên bảng quan hệ, không sử dụng logic quan hệ

Player.RELATION_NAME = --Chủ yếu dùng để thông báo tin nhắn
  {
    [Player.emKPLAYERRELATION_TYPE_TMPFRIEND] = "Bạn bè",
    [Player.emKPLAYERRELATION_TYPE_BLACKLIST] = "Danh sách đen",
    [Player.emKPLAYERRELATION_TYPE_BIDFRIEND] = "Bạn bè",
    [Player.emKPLAYERRELATION_TYPE_SIBLING] = "Kết bái",
    [Player.emKPLAYERRELATION_TYPE_ENEMEY] = "Kẻ thù",
    [Player.emKPLAYERRELATION_TYPE_TRAINING] = "Sư đồ",
    [Player.emKPLAYERRELATION_TYPE_TRAINED] = "Sư đồ",
    [Player.emKPLAYERRELATION_TYPE_COUPLE] = "Phu thê",
    [Player.emKPLAYERRELATION_TYPE_BUDDY] = "Tri kỷ",
  }

Player.NPC = -1 -- Npc không phân biệt nam nữ - -#
Player.MALE = 0
Player.FEMALE = 1

Player.SEX = {
  [Player.NPC] = "?",
  [Player.MALE] = "Nam",
  [Player.FEMALE] = "Nữ",
}

-- Enum này phải đảm bảo nhất quán với enum trong ktaskfuns.h của chương trình
Player.ProcessBreakEvent = {
  emEVENT_MOVE = 0, -- Di chuyển
  emEVENT_ATTACK = 1, -- Chủ động tấn công (sử dụng một số kỹ năng)
  emEVENT_SITE = 2, -- Tọa thiền
  emEVENT_RIDE = 3, -- Lên xuống ngựa
  emEVENT_USEITEM = 4, -- Sử dụng đạo cụ
  emEVENT_ARRANGEITEM = 5, -- Di chuyển đạo cụ trong túi đồ
  emEVENT_DROPITEM = 6, -- Vứt bỏ vật phẩm
  emEVENT_CHANGEEQUIP = 7, -- Thay đổi trang bị
  emEVENT_SENDMAIL = 8, -- Gửi thư điện tử
  emEVENT_TRADE = 9, -- Giao dịch
  emEVENT_CHANGEFIGHTSTATE = 10, -- Thay đổi trạng thái chiến đấu
  emEVENT_ATTACKED = 11, -- Bị tấn công
  emEVENT_DEATH = 12, -- Tử vong
  emEVENT_LOGOUT = 13, -- Thoát game
  emEVENT_REVIVE = 14, -- Hồi sinh bị gián đoạn
  emEVENT_CLIENTCOMMAND = 15, -- Lệnh client, cưỡng chế gián đoạn
  emEVENT_BUYITEM = 16, -- Mua đồ
  emEVENT_SELLITEM = 17, -- Bán đồ
  EVENT_CHANGEDOING = 18, -- Thay đổi hành vi
}

-- Enum trạng thái PK
Player.emKPK_STATE_PRACTISE = 0 -- Luyện công
Player.emKPK_STATE_CAMP = 1 -- Trận doanh
Player.emKPK_STATE_TONG = 2 -- Bang hội
Player.emKPK_STATE_BUTCHER = 3 -- Đồ sát
Player.emKPK_STATE_UNION = 4 -- Liên minh
Player.emKPK_STATE_EXTENSION = 5 -- Chế độ tùy chỉnh
Player.emKPK_STATE_KIN = 6 -- Chế độ gia tộc

-- Enum nguồn gốc tiền tệ
Player.emKEARN_BEGIN = 100 -- Bắt đầu từ 100
Player.emKEARN_HELP_QUESTION = 101 -- Hệ thống trợ giúp
Player.emKEARN_EVENT = 102 -- Hệ thống hoạt động
Player.emKEARN_FUDAI = 103 -- Túi phúc
Player.emKEARN_FUDAI2 = 104 -- Túi phúc 100 bạc
Player.emKEARN_RANDOM_ITEM = 105 -- Vật phẩm ngẫu nhiên
Player.emKEARN_YIJUN = 106 -- Nghĩa quân
Player.emKEARN_TASK = 107 -- Nhiệm vụ cốt truyện
Player.emKEARN_FULI = 108 -- Phúc lợi
Player.emKEARN_WAGE = 109 -- Lương
Player.emKEARN_TONG_FUN = 110 -- Rút tiền bang hội
Player.emKEARN_TONG_DISPAND = 111 -- Phát tiền bang hội
Player.emKEARN_BAI_QIU_LIN = 112 -- Bạch Thu Lâm phát tiền
Player.emKEARN_TMP_LOGIN = 113 -- tmplogin
Player.emKEARN_TASK_TOKE = 114 -- Cốt truyện Toke
Player.emKEARN_TASK_GIVE = 115 -- Cốt truyện Give
Player.emKEARN_TASK_ACT = 116 -- Cốt truyện Act
Player.emKEARN_TASK_JITIAO = 117 -- Thỏi vàng
Player.emKEARN_COLLECT_CARD = 118 -- Hoạt động mùa hè, liên quan đến hoạt động thu thập thẻ
Player.emKEARN_ERROR_REAWARD = 119 -- Lỗi dòng thời gian, đền bù Bạc
Player.emKEARN_TASK_ARMYCAMP = 120 -- Nhiệm vụ quân doanh
Player.emKEARN_EXCHANGE_BUYFAIL = 121 -- Mua đơn Đồng thất bại trên sàn giao dịch, hoàn trả Bạc
Player.emKEARN_EXCHANGE_BIND = 122 -- Đổi Bạc khóa
Player.emKEARN_DRAWBANK = 123 -- Rút Bạc từ tiền trang
Player.emKEARN_CHANGELIVE_MONEY = 125 -- Chuyển từ JX1 sang JXW nhận Bạc
Player.emKEARN_BAIBAOXIANG_MONEY = 126 -- Nhận Bạc từ Rương Bách Bảo
Player.emKEARN_VIP_TRANSFER = 128 -- Bạc chuyển server VIP
Player.emKEARN_PRESENT_ITEM = 129 -- Mở ra từ đạo cụ gói quà
Player.emKEARN_KIN_FUND = 130 --Rút tiền gia tộc
Player.emKEARN_EUROPEAN = 131 --Euro Cup 2012
Player.emKEARN_KIN_SALARY = 132 -- Lương gia tộc

-- Chi tiêu
Player.emKPAY_BEGIN = 100 -- Bắt đầu từ 100
Player.emKPAY_HELP_QUESTION = 101 -- Trả lời câu hỏi
Player.emKPAY_EVENT = 102 -- Hệ thống hoạt động
Player.emKPAY_EVENT2 = 103 -- Hệ thống hoạt động
Player.emKPAY_COMPOSE = 104 -- Dùng Bạc hợp thành Huyền Tinh không khóa
Player.emKPAY_ENHANCE = 105 -- Cường hóa
Player.emKPAY_REPAIR = 106 -- Sửa chữa
Player.emKPAY_REPAIR2 = 107 -- Sửa chữa 2
Player.emKPAY_JBEXCHANGE = 108 -- Sàn giao dịch
Player.emKPAY_CREATEKIN = 109 -- Tạo gia tộc
Player.emKPAY_KIN_CAMP = 110 -- Gia tộc đổi phe
Player.emKPAY_DALAO = 111 -- Đại lao
Player.emKPAY_MIJI = 112 -- Mật tịch
Player.emKPAY_DEL_BUDDY = 113 -- Xóa tri kỷ
Player.emKPAY_DEL_TEACHER = 114 -- Xóa sư phụ
Player.emKPAY_DEL_STUDENT = 115 -- Xóa đệ tử
Player.emKPAY_ANSWER = 116 -- Trả lời câu hỏi
Player.emKPAY_CREATETONG = 117 -- Lập bang
Player.emKPAY_TONGFUND = 118 -- Quỹ bang hội
Player.emKPAY_BUILDFUND = 119 -- Quỹ xây dựng
Player.emKPAY_PEEL = 120 -- Tách Huyền Tinh
Player.emKPAY_CAMPSEND = 121 -- Dịch chuyển phụ bản quân doanh
Player.emKPAY_RESTOREBANK = 122 -- Gửi Bạc vào tiền trang
Player.emKPAY_DRAWBANK = 123 -- Rút Bạc từ tiền trang  furuilei nhận Bạc, nguồn này có lỗi
Player.emKPAY_BUILD_FLAG_TIME = 124 -- Sửa cờ gia tộc
Player.emKPAY_CHANGELIVE_MONEY = 125 -- Chuyển từ JX1 sang JXW nhận Bạc by zhangjinpin@kingsoft furuilei nhận Bạc, nguồn này có lỗi
Player.emKPAY_BAIBAOXIANG_MONEY = 126 -- Nhận Bạc từ Rương Bách Bảo by zhangjinpin@kingsoft furuilei nhận Bạc, nguồn này có lỗi
Player.emKPAY_STRENGTHEN = 127 -- Cải tạo
Player.emKPAY_VIP_TRANSFER = 128 -- Bạc chuyển server VIP by zhangjinpin@kingsoft furuilei nhận Bạc, nguồn này có lỗi
Player.emKPAY_REFINE = 129 -- Luyện hóa trang bị
Player.emKPAY_COMPOSE_BIND = 130 -- Dùng Bạc hợp thành Huyền Tinh khóa
Player.emKPAY_CONVERT_PARTNER = 131 -- Ngưng tụ chân nguyên
Player.emKPAY_ZHENYUAN_REFINE = 132 -- Luyện hóa chân nguyên
Player.emKPAY_KIN_FUND = 133 -- Gửi tiền gia tộc
Player.emKPAY_EQUIP_RECAST = 134 -- Đúc lại trang bị
Player.emKPAY_ENHANCE_TRANSFER = 135 -- Chuyển cường hóa
Player.emKPAY_MAKEHOLE = 136 -- Đục lỗ trang bị
Player.emKPAY_BREAKUPSTONE = 137 -- Tách/Đổi đá
Player.emKPAY_EUROPEAN = 138 -- Euro Cup 2012
Player.emKPAY_SKIPTASK = 139 -- Bỏ qua nhiệm vụ khấu trừ
-- Nhận vật phẩm
Player.emKADDITEM_BEGIN = 100 -- Bắt đầu từ 100
Player.emKITEMLOG_TYPE_UNENHANCE = 101 -- Tách Huyền Tinh
Player.emKITEMLOG_TYPE_COMPOSE = 102 -- Hợp thành Huyền Tinh
Player.emKITEMLOG_TYPE_PRODUCE = 103 -- Chế tạo kỹ năng sống
Player.emKITEMLOG_TYPE_FINISHTASK = 104 -- Hoàn thành nhiệm vụ
Player.emKITEMLOG_TYPE_STOREHOUSE = 105 -- Sử dụng Tàng Bảo Đồ
Player.emKITEMLOG_TYPE_JOINEVENT = 106 -- Nhận được khi tham gia hoạt động
Player.emKITEMLOG_TYPE_BREAKUP = 107 -- Tách Huyền Tinh, trang bị
Player.emKITEMLOG_TYPE_PEEL_PARTNER = 108 -- Tách đồng hành
Player.emKITEMLOG_TYPE_CYSTAL_COMPOSE = 109 -- Hợp thành Thủy Tinh
Player.emKITEMLOG_TYPE_MANTLE_SHOP = 110 -- Đổi áo choàng lấy Hồn Thạch
Player.emKITEMLOG_TYPE_BAZHUZHIYIN_AWARD = 111 -- Phần thưởng Bá Chủ Chi Ấn là Huyền Tinh
Player.emKITEMLOG_TYPE_PEELSTONE = 112 -- Tách đá quý

-- Mất vật phẩm
Player.emKLOSEITEM_USE = 5
Player.emKLOSEITEM_BEGIN = 100 -- Bắt đầu từ 100
Player.emKLOSEITEM_TYPE_COMPOSE = 101 -- Hợp thành Huyền Tinh
Player.emKLOSEITEM_TYPE_ENHANCE = 102 -- Cường hóa trang bị mất Huyền Tinh
Player.emKLOSEITEM_TYPE_EVENTUSED = 103 -- Khấu trừ vật phẩm yêu cầu cho ải hoạt động, khấu trừ khi đổi thưởng
Player.emKLOSEITEM_TYPE_TASKUSED = 104 -- Khấu trừ nhiệm vụ
Player.emKLOSEITEM_TYPE_DESTROY = 105 -- Hủy
Player.emKLOSEITEM_BREAKUP = 106 -- Tách trang bị
Player.emKLOSEITEM_CHANGE_HUN = 107 -- Đổi Hồn Thạch
Player.emKLOSEITEM_REPAIR = 108 -- Tiêu hao vật phẩm sửa chữa
Player.emKLOSEITEM_SERIES_STONE = 109 -- Nâng cấp Ngũ Hành Ấn
Player.emKLOSEITEM_KILLER = 110 -- Khấu trừ khi đổi thưởng nhiệm vụ truy nã của quan phủ
Player.emKLOSEITEM_JINTIAO = 111 -- Khấu trừ khi sử dụng Thỏi Vàng
Player.emKLOSEITEM_MANTLE_SHOP = 112 -- Khấu trừ khi đổi áo choàng lấy Hồn Thạch
Player.emKLOSEITEM_STRENGTHEN = 113 -- Cải tạo khấu trừ Huyền Tinh
Player.emKLOSEITEM_PARTNER_TALENT = 114 -- Đồng hành lĩnh ngộ
Player.emKLOSEITEM_CYSTAL_COMPOSE = 115 -- Hợp thành Thủy Tinh
Player.emKLOSEITEM_EXCHANGE_PARTEQ = 116 -- Đổi mảnh trang bị đồng hành
Player.emKLOSEITEM_BAZHUZHIYIN_TAKEIN = 117 -- Nộp Bá Chủ Chi Ấn
Player.emKLOSEITEM_RECAST_DEL = 118 -- Khấu trừ đạo cụ khi đúc lại
Player.emKLOSEITEM_VALUE_TRANSFER_DEL = 119 -- Khấu trừ đạo cụ khi chuyển cường hóa
Player.emKLOSEITEM_ENCHASESTONE = 120 -- Khảm đá quý
Player.emKLOSEITEM_HANDIN_HOSRE_FRAG = 121 -- Nộp mảnh thú cưỡi mới
Player.emKLOSEITEM_LONGEQUIP_EXCHANGE = 122 -- Tiền tệ đổi trang bị Long Hồn

-- Trạng thái bày bán
Player.STALL_STAT_NORMAL = 0 -- Ở trạng thái bình thường
Player.STALL_STAT_STALL_SELL = 1 -- Bán: Trạng thái rao bán
Player.STALL_STAT_STALL_BUY = 2 -- Bán: Trạng thái mua sắm
Player.STALL_STAT_OFFER_SELL = 3 -- Thu mua: Trạng thái bán
Player.STALL_STAT_OFFER_BUY = 4 -- Thu mua: Trạng thái thu mua

-- Định nghĩa phe danh vọng
Player.CAMP_TASK = 1 -- Danh vọng nhiệm vụ
Player.CAMP_BATTLE = 2 -- Danh vọng chiến trường Tống Kim
Player.CAMP_FACTION = 3 -- Danh vọng môn phái

Player.ATTRIB_STR = 1
Player.ATTRIB_DEX = 2
Player.ATTRIB_VIT = 3
Player.ATTRIB_ENG = 4

Player.nBeProtectedStateSkillId = 786
Player.HEAD_STATE_AUTOPATH = 147

-- Định nghĩa cổng uy vọng
Player.PRESTIGE_LIMIT_GROUP = 2015 -- ID nhóm nhiệm vụ
Player.PRESTIGE_WEEK_ID = 1 -- Số tuần

Player.PRESTIGE_LIMIT = {
  --ID biến	Giới hạn tuần
  ["treasuremap"] = { 2, 40 },
  ["linktask"] = { 3, 10 }, -- Sửa từ 30 thành 10 điểm, by zhangjinpin@kingsoft
  ["baihutang"] = { 4, 60 },
  ["battle"] = { 5, 60 },
  ["huihuangzhiguo"] = { 6, 20 },
  ["wlls"] = { 7, 200 }, -- Giải đấu tạm thời bỏ giới hạn, một tuần tối đa chỉ có thể là 144
  ["kingame"] = { 8, 30 },
  ["uniqueboss"] = { 9, 60 },
  ["xoyogame"] = { 10, 100 }, -- Sửa từ 60 thành 100 điểm, by zhangjinpin@kingsoft
  ["factionbattle"] = { 11, 60 },
  ["tongji"] = { 12, 30 }, -- Nhiệm vụ truy nã quan phủ, tăng giới hạn hàng tuần lên 30, by zhangjinpin@kingsoft
  ["superbattle"] = { 13, 60 }, -- Chiến trường liên server
  ["newcangbaotu"] = { 1010, 40 }, -- Tàng Bảo Đồ cao cấp
  ["kingame_quwei"] = { 1021, 40 }, -- Thi đấu vui gia tộc
}

--zounan add Các cách tăng kinh nghiệm
Player.EXP_TYPE = {

  ["gouhuo"] = 1, --Lửa trại
  ["jiazuchaqi"] = 1, --Cắm cờ gia tộc
  ["guessgame"] = 1, --Đoán đèn lồng
  ["army"] = 1, --Quân doanh
  ["task"] = 1, --Nhiệm vụ
  ["battle"] = 1, --Tống Kim
  ["pvp"] = 1, --Thi đấu môn phái
  --	["uniqueboss"]		= 1,
  --	["xoyogame"]		= 1,
  --	["factionbattle"]	= 1,
  --	["tongji"]			= 1,
}

--zounan add Các cách tăng Bạc khóa
Player.BINDMONEY_TYPE = {

  ["army"] = 1, --Quân doanh
  ["task"] = 1, --Nhiệm vụ
  --	["wlls"]			= 1,
  --	["kingame"]			= 1,
  --	["uniqueboss"]		= 1,
  --	["xoyogame"]		= 1,
  --	["factionbattle"]	= 1,
  --	["tongji"]			= 1,
}

Player.ATTACT_TRAUMA = 0 -- Nội công
Player.ATTACT_INNER = 1 -- Ngoại công

--Định nghĩa enum loại xóa kỹ năng
Player.emKNPCFIGHTSKILLKIND_NONE = 0
Player.emKNPCFIGHTSKILLKIND_NEGATIVE = 1 -- Loại tiêu cực
Player.emKNPCFIGHTSKILLKIND_POSITIVE = 2 -- Loại tích cực
Player.emKNPCFIGHTSKILLKIND_DOMAINENABLE = 4 -- Loại có thể dùng trong chiến tranh giành khu vực
Player.emKNPCFIGHTSKILLKIND_CLEARDWHENENTERBATTLE = 8 -- Kỹ năng cần xóa khi vào một số chiến trường

-- Biến liên quan đến triệu hồi người chơi cũ
Player.TASK_GROUP_OLDPLAYER = 2082
Player.TASK_ID_LEAVEKIN_TIME = 15 -- Thời gian người chơi cũ rời gia tộc trong thời gian hoạt động sau khi được triệu hồi
Player.TASK_ID_JOINKIN_TIME = 16 -- Thời gian người chơi cũ gia nhập gia tộc trong thời gian hoạt động sau khi được triệu hồi
Player.OLDPLAYER_ACTION_TIME = 3600 * 24 * 7 -- Thời gian hoạt động ưu đãi của người chơi cũ (7 ngày)

-- Liên server
Player.ACROSS_TSKGROUPID = 2104
Player.ACROSS_TSKID = 1
Player.ACROSS_TSKID_USE_TIME = 2
Player.ACROSS_TSKID_TIME_OUT = 3
Player.ACROSS_TSKID_PRICE = 4

-- Nguồn thêm Bạc khóa
Player.emKBINDMONEY_ADD_BEGIN = 100 -- Bắt đầu từ 100
Player.emKBINDMONEY_ADD_QUESTION = 101 -- Hệ thống trợ giúp
Player.emKBINDMONEY_ADD_EVENT = 102 -- Hệ thống hoạt động
Player.emKBINDMONEY_ADD_FUDAI = 103 -- Túi phúc
Player.emKBINDMONEY_ADD_FUDAI2 = 104 -- Túi phúc 100 bạc
Player.emKBINDMONEY_ADD_RANDOMITEM = 105 -- Vật phẩm ngẫu nhiên
Player.emKBINDMONEY_ADD_YIJUN = 106 -- Nghĩa quân
Player.emKBINDMONEY_ADD_TASK = 107 -- Nhiệm vụ cốt truyện
Player.emKBINDMONEY_ADD_FULI = 108 -- Phúc lợi
Player.emKBINDMONEY_ADD_WAGE = 109 -- Lương
Player.emKBINDMONEY_ADD_TONG_FUN = 110 -- Rút tiền bang hội
Player.emKBINDMONEY_ADD_TONG_DISPAND = 111 -- Phát tiền bang hội
Player.emKBINDMONEY_ADD_BAI_QIU_LIN = 112 -- Bạch Thu Lâm phát tiền
Player.emKBINDMONEY_ADD_TMP_LOGIN = 113 -- tmplogin
Player.emKBINDMONEY_ADD_TASK_TOKE = 114 -- Cốt truyện Toke
Player.emKBINDMONEY_ADD_TASK_GIVE = 115 -- Cốt truyện Give
Player.emKBINDMONEY_ADD_TASK_ACT = 116 -- Cốt truyện Act
Player.emKBINDMONEY_ADD_JITIAO = 117 -- Thỏi vàng
Player.emKBINDMONEY_ADD_COLLECT_CARD = 118 -- Hoạt động mùa hè, liên quan đến hoạt động thu thập thẻ
Player.emKBINDMONEY_ADD_ERROR_REAWARD = 119 -- Lỗi dòng thời gian, đền bù Bạc
Player.emKBINDMONEY_ADD_TASK_ARMYCAMP = 120 -- Nhiệm vụ quân doanh
Player.emKBINDMONEY_ADD_EXCHANGE_BUYFAIL = 121 -- Mua đơn Đồng thất bại trên sàn giao dịch, hoàn trả Bạc
Player.emKBINDMONEY_ADD_VIP_TRANSFER = 122 -- Chuyển server VIP
Player.emKBINDMONEY_ADD_HAPPYEGG = 123 -- Trứng Vui Vẻ (Mùa hè và Du Long)
Player.emKBINDMONEY_ADD_PEEL = 124 -- Tách trang bị
Player.emKBINDMONEY_ADD_CHANGELIVE = 125 -- Chuyển từ JX1 sang JXW nhận Bạc khóa
Player.emKBINDMONEY_ADD_HUNDREDKIN = 126 -- Phần thưởng bình chọn trăm gia tộc
Player.emKBINDMONEY_ADD_YOULONG_ITEM = 127 -- Đạo cụ Du Long Bí Bảo
Player.emKBINDMONEY_ADD_XISHANYIDING = 128 -- Ngân Đĩnh Tây Sơn
Player.emKBINDMONEY_ADD_MARRY = 129 -- Liên quan đến kết hôn
Player.emKBINDMONEY_ADD_SHANGHUI = 130 -- Đổi nguyên liệu thương hội lấy Bạc khóa
Player.emKBINDMONEY_ADD_PRESENTITEM = 131 -- Mở Bạc khóa từ gói quà
Player.emKBINDMONEY_ADD_EQUIP_TRANSFER = 132 -- Chuyển cường hóa

-- Nguồn tiêu hao Bạc khóa
Player.emKBINDMONEY_COST_BEGIN = 100 -- Bắt đầu từ 100
Player.emKBINDMONEY_COST_HELP_QUESTION = 101 -- Hệ thống trợ giúp
Player.emKBINDMONEY_COST_EVENT = 102 -- Hệ thống hoạt động
Player.emKBINDMONEY_COST_COMPOSE = 103 -- Hợp thành
Player.emKBINDMONEY_COST_ENHANCE = 104 -- Cường hóa
Player.emKBINDMONEY_COST_REFINE = 105 -- Luyện hóa
Player.emKBINDMONEY_COST_STRENGTHEN = 106 -- Cải tạo
Player.emKBINDMONEY_COST_REPAIR = 107 -- Sửa chữa
Player.emKBINDMONEY_COST_REPAIR2 = 108 -- Sửa chữa 2
Player.emKBINDMONEY_COST_EXCHANGE = 109 -- Đổi Bạc khóa lấy Bạc
Player.emKBINDMONEY_COST_GM = 110 -- GM khấu trừ
Player.emKBINDMONEY_COST_TRANSFER = 111 --Khấu trừ chuyển cường hóa
Player.emKBINDMONEY_COST_SKIPTASK = 112 --Bỏ qua nhiệm vụ khấu trừ Bạc khóa

-- Nguồn nhận Đồng khóa
Player.emKBINDCOIN_ADD_BEGIN = 100 -- Bắt đầu từ 100
Player.emKBINDCOIN_ADD_HELP_QUESTION = 101 -- Hệ thống trợ giúp
Player.emKBINDCOIN_ADD_EVENT = 102 -- Hoạt động
Player.emKBINDCOIN_ADD_TASK = 103 -- Nhiệm vụ
Player.emKBINDCOIN_ADD_BAIBAOXIANG = 104 -- Rương Bách Bảo
Player.emKBINDCOIN_ADD_FUDAI = 105 -- Túi phúc
Player.emKBINDCOIN_ADD_CHANGELIFE = 106 -- Chuyển từ JX1 sang JXW nhận Đồng khóa
Player.emKBINDCOIN_ADD_CHANGESERVER_AWARD = 107 -- Phần thưởng di dân
Player.emKBINDCOIN_ADD_GUOQING_CARD = 108 -- Thẻ Quốc Khánh
Player.emKBINDCOIN_ADD_ERROR_REAWARD = 109 -- Lỗi dòng thời gian, đền bù Đồng khóa
Player.emKBINDCOIN_ADD_CALLBACK = 110 -- Hoạt động triệu hồi người chơi cũ
Player.emKBINDCOIN_ADD_XMAS_REBACK = 111 -- Hoàn trả Giáng sinh
Player.emKBINDCOIN_ADD_SALARY = 112 -- Lương
Player.emKBINDCOIN_ADD_HAPPYEGG = 113 -- Trứng Vui Vẻ
Player.emKBINDCOIN_ADD_RANDOM_ITEM = 114 -- Vật phẩm ngẫu nhiên
Player.emKBINDCOIN_ADD_XISHANJINDING = 115 -- Kim Đĩnh Tây Sơn
Player.emKBINDCOIN_ADD_TONG_JINTIAO = 116 -- Thỏi Vàng bang hội
Player.emKBINDCOIN_ADD_RELATION = 117 -- Phần thưởng số lượng bạn bè
Player.emKBINDCOIN_ADD_VIP_TRANSFER = 118 -- Chuyển server VIP
Player.emKBINDCOIN_ADD_VIP_REBACK = 119 -- Hoàn trả VIP
Player.emKBINDCOIN_ADD_PRESENT_ITEM = 120 -- Mở ra từ gói quà
Player.emKBINDCOIN_ADD_LOTTERY_ITEM = 121 -- Mở ra từ vé số nạp tiền
Player.emKBINDCOIN_ADD_PAY_RETURN = 122 -- Hoàn trả khi nạp trên 1000
Player.emKBINDCOIN_ADD_LOTTERY_GET = 123 -- Nhận được từ rút thăm nạp tiền
Player.emKBINDCOIN_ADD_OLD_RETURN = 124 -- Hoàn trả hoạt động người chơi cũ quay lại
Player.emKBINDCOIN_ADD_ONLINE_AWARD = 125 -- Nhận thưởng online

-- Nguồn tiêu hao Đồng khóa
Player.emKBINDCOIN_COST_BEGIN = 100 -- Bắt đầu từ 100
Player.emKBINDCOIN_COST_CHANGESERVER = 101 -- Di dân
Player.emKBINDCOIN_COST_GM = 102 -- GM khấu trừ
Player.emKBINDCOIN_COST_OFFLINE = 103 -- Ủy thác offline tự động mua Bạch Câu
Player.emKBINDCOIN_COST_JBRETURN = 104 -- Hoàn trả tiêu hao Đồng
Player.emKBINDCOIN_COST_BAIJU_LOGOUT = 105 -- Mua Bạch Câu Hoàn bằng Đồng khóa khi offline
Player.emKBINDCOIN_COST_SKIPTASK = 106 -- Bỏ qua nhiệm vụ khấu trừ

-- Nhiệm vụ hướng dẫn người chơi mới
Player.TSKGROUP_NEWPLAYER_GUIDE = 1022 -- Nhiệm vụ hướng dẫn tân thủ
Player.TSKID_NEWPLAYER_FACTION = 222 -- Hướng dẫn tân thủ, tình hình hoàn thành hướng dẫn môn phái
Player.TSKID_NEWPLAYER_FRIEND = 223 -- Hướng dẫn tân thủ, bạn bè
Player.TSKID_NEWPLAYER_KIN = 224 -- Hướng dẫn tân thủ, gia tộc

-- Nguồn đóng băng Đồng
Player.emKCOIN_FREEZE_XKLAND = 1 -- Đảo Hiệp Khách đóng băng Đồng

Player.TSK_PAYACTION_GROUP = 2027
Player.TSK_PAYACTION_EXT_ID = { 156, 157, 75 } --

Player.TSK_GROUP_HIDE_MANTLE = 2145
Player.TSK_SUB_HIDE_MANTLE = 1

Player.tbViewEquipMsg = {
  [0] = "Đang nhìn bạn từ trên xuống dưới!",
  [1] = "Đang chống cằm, xem trang bị của bạn!",
  [4] = "Đang tò mò nhìn trang bị của bạn!",
  [7] = "Đang nhìn chằm chằm vào trang bị của bạn, hai mắt sáng rực!",
  [9] = "Đang nhìn trang bị lộng lẫy của bạn, nước miếng chảy đầy đất!",
  [10] = "Đang vô cùng ngưỡng mộ nhìn toàn thân bạn, mắt sắp bị chói mù rồi!",
}
Player.tbViewEquipMsg[2] = Player.tbViewEquipMsg[1]
Player.tbViewEquipMsg[3] = Player.tbViewEquipMsg[1]
Player.tbViewEquipMsg[5] = Player.tbViewEquipMsg[4]
Player.tbViewEquipMsg[6] = Player.tbViewEquipMsg[4]
Player.tbViewEquipMsg[8] = Player.tbViewEquipMsg[7]

--Player.szBeViewdEquipMsg = "Đối phương lạnh gáy, phát hiện bạn đang nhìn trộm!";

Player.tbRouteName = {
  "Đao Thiếu Lâm",
  "Côn Thiếu Lâm",
  "Thương Thiên Vương",
  "Chùy Thiên Vương",
  "Bẫy Đường Môn",
  "Tụ Tiễn Đường Môn",
  "Đao Ngũ Độc",
  "Chưởng Ngũ Độc",
  "Chưởng Nga Mi",
  "Phụ Trợ Nga Mi",
  "Kiếm Thúy Yên",
  "Đao Thúy Yên",
  "Chưởng Cái Bang",
  "Côn Cái Bang",
  "Chiến Thiên Nhẫn",
  "Ma Thiên Nhẫn",
  "Khí Võ Đang",
  "Kiếm Võ Đang",
  "Đao Côn Lôn",
  "Kiếm Côn Lôn",
  "Chùy Minh Giáo",
  "Kiếm Minh Giáo",
  "Chỉ Đoàn Thị",
  "Khí Đoàn Thị",
  "Kiếm Cổ Mộ",
  "Châm Cổ Mộ", --"Tố Tâm", "Lệ Ảnh",
}

Player.TASK_MAIN_GROUP = 1024
Player.TASK_SUB_GROUP_STATE = 67 -- Trạng thái hiện tại
Player.TASK_SUB_GROUP_RESET_DAY = 68 -- Số ngày từ lần reset trước

Player.TASK_OTHER_GROUP = 2000
Player.TASK_LOCK_INPUT = 5
Player.TASK_LIMIT_TRNAS = 7
Player.nGlobalLoginState_Logout = 0
Player.nGlobalLoginState_Login = 1
