-- Tên tệp　: playerhonor.lua
-- Người tạo　: zhouchenfei
-- Thời gian tạo: 2008-10-07 17:44:24


PlayerHonor.HONOR_CLASS_WULIN		= 1;	-- Hạng mục lớn vinh dự, Vinh dự Võ Lâm
PlayerHonor.HONOR_CLASS_FACTION		= 2;	-- Hạng mục lớn vinh dự, Vinh dự Môn phái
PlayerHonor.HONOR_CLASS_WLLS		= 3;	-- Hạng mục lớn vinh dự, Vinh dự Giải đấu
PlayerHonor.HONOR_CLASS_BATTLE		= 4;	-- Hạng mục lớn vinh dự, Vinh dự Chiến trường
PlayerHonor.HONOR_CLASS_LINGXIU		= 5;	-- Hạng mục lớn vinh dự, Vinh dự Thủ Lĩnh
PlayerHonor.HONOR_CLASS_AREARBATTLE	= 6;	-- Hạng mục lớn vinh dự, Vinh dự Tranh đoạt lãnh thổ
PlayerHonor.HONOR_CLASS_BAIHUTANG	= 7;	-- Hạng mục lớn vinh dự, Vinh dự Bạch Hổ Đường
PlayerHonor.HONOR_CLASS_MONEY		= 8;	-- Hạng mục lớn vinh dự, Vinh dự Tài phú
PlayerHonor.HONOR_CLASS_SPRING		= 9;	-- Hạng mục lớn vinh dự, Vinh dự Phi Nhứ Nhai
PlayerHonor.HONOR_CLASS_DRAGONBOAT	= 10;	-- Hạng mục lớn vinh dự, Vinh dự Thiền Cảnh Hoa Viên (Hoạt động Tết Thanh Minh)
PlayerHonor.HONOR_CLASS_WEIWANG		= 11;	-- Hạng mục lớn vinh dự, Vinh dự Uy danh giang hồ
PlayerHonor.HONOR_CLASS_PRETTYGIRL	= 12;	-- Hạng mục lớn vinh dự, Vinh dự Tuyển chọn mỹ nữ
PlayerHonor.HONOR_CLASS_XOYOGAME	= 13;	-- Hạng mục lớn vinh dự, Vinh dự Tiêu Dao
PlayerHonor.HONOR_CLASS_KAIMENTASK	= 14;	-- Hạng mục lớn vinh dự, Nhiệm vụ Khai Môn
PlayerHonor.HONOR_CLASS_EVENTPLANT_PLAYER	= 15;	-- Hạng mục lớn vinh dự, Điểm cá nhân nền tảng hoạt động
PlayerHonor.HONOR_CLASS_FIGHTPOWER_TOTAL	= 17;	-- Tổng lực chiến
PlayerHonor.HONOR_CLASS_FIGHTPOWER_ACHIEVEMENT = 18;-- Thành tựu
PlayerHonor.HONOR_CLASS_LEVEL		= 19;-- Cấp độ
PlayerHonor.HONOR_CLASS_BEAUTYHERO	= 20;	-- Hạng mục lớn vinh dự, Vinh dự giải Nữ Anh Hùng
PlayerHonor.HONOR_CLASS_LADDER1		= 21;	-- Hạng mục lớn vinh dự
PlayerHonor.HONOR_CLASS_LADDER2		= 22;	-- Dạ Lam Quan
PlayerHonor.HONOR_CLASS_LADDER3		= 23;	-- Bảng nộp mảnh thú cưỡi mới

PlayerHonor.WEALTH_TASK_GROUP		= 2053;	-- Biến nhiệm vụ xếp hạng trang bị người chơi

PlayerHonor.OPENSHOWLEVELTIME		= 1228072200; -- 12/01/08 03:10:00 Mở hiển thị cấp độ

PlayerHonor.TSK_GROUP				= 2054;	-- Biến nhiệm vụ khác
PlayerHonor.TSK_ID_REFRESH_TIME		= 1;	-- Thời gian làm mới điểm vinh dự lần trước GetTime()+1, chưa làm mới là 0
PlayerHonor.TSK_ID_HONORLEVEL_WULIN	= 2;	-- Cấp vinh dự (dùng để lưu)
PlayerHonor.TSK_ID_HONORLEVEL_LINGXIU = 3;	-- Cấp Thủ Lĩnh
PlayerHonor.TSK_ID_HONORLEVEL_MONEY	= 4;	-- Cấp tài phú
PlayerHonor.TSK_ID_COSUME_VALUE	= 5;		-- Lượng giá trị tiêu hao
PlayerHonor.TSK_ID_PARTNER_VALUE = 6;		-- Lượng giá trị đồng hành
PlayerHonor.TSK_ID_COSUME_VALUE_HIGH = 7	-- Lượng giá trị tiêu hao hàng cao

PlayerHonor.TSK_GIFT_GROUP			= 2186;	-- 	Đạo cụ áo choàng miễn phí
PlayerHonor.TSK_ID_GIFT_GETAWARD	= 1;	-- Đã nhận đạo cụ chưa
PlayerHonor.TSK_ID_GIFT_USEAWARD	= 2;	-- Đã sử dụng đạo cụ chưa
PlayerHonor.ITEM_FREEPIFENG_GIFT	= {18, 1, 1550, 1, -1};

PlayerHonor.NEW_HORSE_GET_LIMIT		= 300;	-- Giới hạn nhận Xích Dạ Thiên Tường trên bảng xếp hạng

PlayerHonor.tbHonorName	= {
		[PlayerHonor.HONOR_CLASS_WULIN] 		= "Võ Lâm";
		[PlayerHonor.HONOR_CLASS_FACTION]		= "Môn phái";
		[PlayerHonor.HONOR_CLASS_WLLS]			= "Giải đấu";
		[PlayerHonor.HONOR_CLASS_BATTLE]		= "Chiến trường Tống Kim";
		[PlayerHonor.HONOR_CLASS_LINGXIU] 		= "Thủ Lĩnh";
		[PlayerHonor.HONOR_CLASS_AREARBATTLE]	= "Tranh đoạt lãnh thổ";
		[PlayerHonor.HONOR_CLASS_BAIHUTANG]		= "Bạch Hổ Đường";
		[PlayerHonor.HONOR_CLASS_MONEY]			= "Tài phú";
		[PlayerHonor.HONOR_CLASS_SPRING]		= "Dân tộc đại đoàn viên";
		[PlayerHonor.HONOR_CLASS_DRAGONBOAT]	= "Thiền Cảnh Hoa Viên";
		[PlayerHonor.HONOR_CLASS_WEIWANG]		= "Uy danh giang hồ";
		[PlayerHonor.HONOR_CLASS_PRETTYGIRL]	= "Mỹ nữ";
		[PlayerHonor.HONOR_CLASS_KAIMENTASK]	= "Nhiệm vụ Khai Môn";
		[PlayerHonor.HONOR_CLASS_FIGHTPOWER_TOTAL]	= "Tổng lực chiến";
		[PlayerHonor.HONOR_CLASS_FIGHTPOWER_ACHIEVEMENT]	= "Thành tựu";
		[PlayerHonor.HONOR_CLASS_BEAUTYHERO]	= "Nữ Anh Hùng";
		[PlayerHonor.HONOR_CLASS_LADDER1] = "Di tích Hàn Vũ";
		[PlayerHonor.HONOR_CLASS_LADDER2] = "Dạ Lam Quan";
	};

PlayerHonor.tbFacContext = {
		[0] = "Bảng vinh dự Võ Lâm";
		[Env.FACTION_ID_SHAOLIN] 	= "Bảng vinh dự Thiếu Lâm";
		[Env.FACTION_ID_TIANWANG]	= "Bảng vinh dự Thiên Vương";
		[Env.FACTION_ID_TANGMEN]	= "Bảng vinh dự Đường Môn";
		[Env.FACTION_ID_WUDU]		= "Bảng vinh dự Ngũ Độc";
		[Env.FACTION_ID_EMEI]		= "Bảng vinh dự Nga Mi";
		[Env.FACTION_ID_CUIYAN]		= "Bảng vinh dự Thúy Yên";
		[Env.FACTION_ID_GAIBANG]	= "Bảng vinh dự Cái Bang";
		[Env.FACTION_ID_TIANREN]	= "Bảng vinh dự Thiên Nhẫn";
		[Env.FACTION_ID_WUDANG]		= "Bảng vinh dự Võ Đang";
		[Env.FACTION_ID_KUNLUN]		= "Bảng vinh dự Côn Lôn";
		[Env.FACTION_ID_MINGJIAO]	= "Bảng vinh dự Minh Giáo";
		[Env.FACTION_ID_DALIDUANSHI] = "Bảng vinh dự Đoàn Thị";
		[Env.FACTION_ID_GUMU]		= "Bảng vinh dự Cổ Mộ";
	};
	
PlayerHonor.tbFacName = {
		[0] = "Võ Lâm";
		[Env.FACTION_ID_SHAOLIN]		= "Thiếu Lâm";
		[Env.FACTION_ID_TIANWANG]		= "Thiên Vương";
		[Env.FACTION_ID_TANGMEN]		= "Đường Môn";
		[Env.FACTION_ID_WUDU]			= "Ngũ Độc";
		[Env.FACTION_ID_EMEI]			= "Nga Mi";
		[Env.FACTION_ID_CUIYAN]			= "Thúy Yên";
		[Env.FACTION_ID_GAIBANG]		= "Cái Bang";
		[Env.FACTION_ID_TIANREN]		= "Thiên Nhẫn";
		[Env.FACTION_ID_WUDANG]			= "Võ Đang";
		[Env.FACTION_ID_KUNLUN]			= "Côn Lôn";
		[Env.FACTION_ID_MINGJIAO]		= "Minh Giáo";
		[Env.FACTION_ID_DALIDUANSHI]	= "Đoàn Thị";
		[Env.FACTION_ID_GUMU]			= "Cổ Mộ";
	};  

PlayerHonor.tbBookToValue = 
{
	[1] = 150000,
	[2] = 450000,
	[3] = 1000000, --Bánh chưng
}

local HONOR_KEY_WULIN	= "wulin";
local HONOR_KEY_MONEY	= "money";
local HONOR_KEY_LINGXIU	= "lingxiu";

PlayerHonor.tbHonorLevelInfo	= {
	[HONOR_KEY_WULIN]	= {
		nHonorId	= PlayerHonor.HONOR_CLASS_WULIN,
		nLevelTaskId= PlayerHonor.TSK_ID_HONORLEVEL_WULIN;
		szName		= "Võ Lâm",
		tbLevel		= {};
	},
	[HONOR_KEY_MONEY]	= {
		nHonorId	= PlayerHonor.HONOR_CLASS_MONEY,
		nLevelTaskId= PlayerHonor.TSK_ID_HONORLEVEL_MONEY;
		szName		= "Tài phú",
		tbLevel		= {};
	},
	[HONOR_KEY_LINGXIU]	= {
		nHonorId	= PlayerHonor.HONOR_CLASS_LINGXIU,
		nLevelTaskId= PlayerHonor.TSK_ID_HONORLEVEL_LINGXIU;
		szName		= "Thủ Lĩnh",
		tbLevel		= {};
	},
};

function PlayerHonor:GetHonorName(nClass, nType)
	return self.tbHonorName[nClass];
end

function PlayerHonor:Init()
	self.tbHonorSettings = {};
	
	local tbData	= Lib:LoadTabFile("\\setting\\player\\honor_level.txt", {LEVEL=1,MAXRANK=1,MINVALUE=1});
	local tbHonorLevelInfo	= self.tbHonorLevelInfo;
	for _, tbRow in ipairs(tbData) do
		tbHonorLevelInfo[tbRow.TYPE].tbLevel[tbRow.LEVEL]	= {
			nLevel		= tbRow.LEVEL,
			nMaxRank	= tbRow.MAXRANK,
			nMinValue	= tbRow.MINVALUE,
			szName		= tbRow.NAME,
		};
		if (tbRow.TYPE == "money") then
			tbHonorLevelInfo[tbRow.TYPE].tbLevel[tbRow.LEVEL].nMaxValue = math.floor(tbRow.MINVALUE * 1.5);
		else
			tbHonorLevelInfo[tbRow.TYPE].tbLevel[tbRow.LEVEL].nMaxValue = 0;
		end
	end

	self:_InitWuLinHonorSetting();
	self:_InitLingXiuHonorSetting();
	self:_InitMoneyHonorSetting();
	self:_InitFactionHonorSetting();
	self:_InitWllsHonorSetting();
	self:_InitSongJinBattleHonorSetting();
	self:_InitAreaBattleHonorSetting();
	self:_InitBaiHuTangHonorSetting();
	self:_InitEventHonorSetting();
	self:_InitFightPowerSetting();
	
	if (MODULE_GAMESERVER) then
		self:_InitGaojiMijiValue();
	end

	if (MODULE_GAMECLIENT) then
		self.tbPlayerHonorData.tbHonorData = self.tbHonorSettings
	end
	
end

function PlayerHonor:_InitGaojiMijiValue()
	self.tbGaojiMijiValue = {};

	local tbData	= Lib:LoadTabFile("\\setting\\item\\001\\extern\\value\\gaojimijivalue.txt");
	for _, tbRow in ipairs(tbData) do
		local nSkillId = tonumber(tbRow["SkillId"]);
		local nSkillLevel = tonumber(tbRow["SkillLevel"]);
		local nSkillValue = tonumber(tbRow["SkillValue"]);
		if (nSkillId > 0 and nSkillLevel > 0 and nSkillValue > 0) then
			if (not self.tbGaojiMijiValue[nSkillId]) then
				self.tbGaojiMijiValue[nSkillId] = {};
			end
			self.tbGaojiMijiValue[nSkillId][nSkillLevel] = nSkillValue;
		end
	end
end

function PlayerHonor:TryGetGlobalDataBuffer()
	local tbBuffer = GetGblIntBuf(GBLINTBUF_LADDER_BATCH, 0); 
	if type(tbBuffer) == "table" then
		self.tbInvalidTimeData = self.tbInvalidTimeData or tbBuffer;
	else
		self.tbInvalidTimeData = self.tbInvalidTimeData or {};
	end
end

-- Vinh dự Võ Lâm
function PlayerHonor:_InitWuLinHonorSetting()
	local nClass = self.HONOR_CLASS_WULIN;
	local tbHonorSubList		= {};
	tbHonorSubList[1]			= {};
	tbHonorSubList[1].szName	= "Võ Lâm"
	tbHonorSubList[1].nValue	= 0;
	tbHonorSubList[1].nRank		= 0;	
	tbHonorSubList[1].nClass	= nClass;
	tbHonorSubList[1].nLevel	= 0;

	self.tbHonorSettings[1] = {};
	self.tbHonorSettings[1].tbHonorSubList	= tbHonorSubList
	self.tbHonorSettings[1].szName			= "<color=yellow>Vinh dự Võ Lâm<color>";
end

-- Vinh dự Thủ Lĩnh
function PlayerHonor:_InitLingXiuHonorSetting()
	local nClass = self.HONOR_CLASS_LINGXIU;

	local tbHonorSubList		= {};
	tbHonorSubList[1]			= {};
	tbHonorSubList[1].szName	= "Thủ Lĩnh"
	tbHonorSubList[1].nValue	= 0;
	tbHonorSubList[1].nRank		= 0;	
	tbHonorSubList[1].nClass	= nClass;
	tbHonorSubList[1].nLevel	= 0;
	
	self.tbHonorSettings[2] = {};
	self.tbHonorSettings[2].tbHonorSubList	= tbHonorSubList
	self.tbHonorSettings[2].szName			= "<color=red>Vinh dự Thủ Lĩnh<color>";	
end

-- Vinh dự Tài phú
function PlayerHonor:_InitMoneyHonorSetting()
	local nClass = self.HONOR_CLASS_MONEY;
	local tbHonorSubList		= {};
	tbHonorSubList[1]			= {};
	tbHonorSubList[1].szName	= "Tài phú"
	tbHonorSubList[1].nValue	= 0;
	tbHonorSubList[1].nRank		= 0;
	tbHonorSubList[1].nClass	= nClass;
	tbHonorSubList[1].nLevel	= 0;
	
	self.tbHonorSettings[3] = {};
	self.tbHonorSettings[3].tbHonorSubList	= tbHonorSubList
	self.tbHonorSettings[3].szName			= "<color=green>Vinh dự Tài phú<color>";	
end

-- Vinh dự Môn phái
function PlayerHonor:_InitFactionHonorSetting()
	local nClass = self.HONOR_CLASS_FACTION;
	local tbHonorSubList = {};
	tbHonorSubList[1]			= {};
	tbHonorSubList[1].szName	= "Môn phái"
	tbHonorSubList[1].nValue	= 0;
	tbHonorSubList[1].nRank		= 0;
	tbHonorSubList[1].nClass	= nClass;
	tbHonorSubList[1].nLevel	= 0;
	tbHonorSubList[2]			= {};
	tbHonorSubList[2].szName	= "Bản môn"
	tbHonorSubList[2].nValue	= 0;
	tbHonorSubList[2].nRank		= 0;
	tbHonorSubList[2].nClass	= nClass;
	tbHonorSubList[2].nLevel	= 0;

	self.tbHonorSettings[4] = {};
	self.tbHonorSettings[4].tbHonorSubList	= tbHonorSubList
	self.tbHonorSettings[4].szName			= "Môn phái";
end

-- Vinh dự Giải đấu
function PlayerHonor:_InitWllsHonorSetting()
	local nClass = self.HONOR_CLASS_WLLS;
	local tbHonorSubList		= {};
	tbHonorSubList[1]			= {};
	tbHonorSubList[1].szName	= "Giải đấu"
	tbHonorSubList[1].nValue	= 0;
	tbHonorSubList[1].nRank		= 0;
	tbHonorSubList[1].nClass	= nClass;
	tbHonorSubList[1].nLevel	= 0;

	self.tbHonorSettings[5] = {};
	self.tbHonorSettings[5].tbHonorSubList	= tbHonorSubList
	self.tbHonorSettings[5].szName			= "Giải đấu";	
end

-- Vinh dự Chiến trường Tống Kim
function PlayerHonor:_InitSongJinBattleHonorSetting()
	local nClass = self.HONOR_CLASS_BATTLE;
	local tbHonorSubList		= {};
	tbHonorSubList[1]			= {};
	tbHonorSubList[1].szName	= "Chiến trường Tống Kim"
	tbHonorSubList[1].nValue	= 0;
	tbHonorSubList[1].nRank		= 0;
	tbHonorSubList[1].nClass	= nClass;
	tbHonorSubList[1].nLevel	= 0;	
	
	self.tbHonorSettings[6] = {};
	self.tbHonorSettings[6].tbHonorSubList	= tbHonorSubList
	self.tbHonorSettings[6].szName			= "Chiến trường Tống Kim";	
end

-- Tranh đoạt lãnh thổ
function PlayerHonor:_InitAreaBattleHonorSetting()
	local nClass = self.HONOR_CLASS_AREARBATTLE;
	local tbHonorSubList		= {};
	tbHonorSubList[1]			= {};
	tbHonorSubList[1].szName	= "Tranh đoạt lãnh thổ"
	tbHonorSubList[1].nValue	= 0;
	tbHonorSubList[1].nRank		= 0;
	tbHonorSubList[1].nClass	= nClass;
	tbHonorSubList[1].nLevel	= 0;	
	
	self.tbHonorSettings[7] = {};
	self.tbHonorSettings[7].tbHonorSubList	= tbHonorSubList
	self.tbHonorSettings[7].szName			= "Tranh đoạt lãnh thổ";	
end

-- Bạch Hổ Đường
function PlayerHonor:_InitBaiHuTangHonorSetting()
	local nClass = self.HONOR_CLASS_BAIHUTANG;
	local tbHonorSubList		= {};
	tbHonorSubList[1]			= {};
	tbHonorSubList[1].szName	= "Bạch Hổ Đường"
	tbHonorSubList[1].nValue	= 0;
	tbHonorSubList[1].nRank		= 0;
	tbHonorSubList[1].nClass	= nClass;
	tbHonorSubList[1].nLevel	= 0;	
	
	self.tbHonorSettings[8] = {};
	self.tbHonorSettings[8].tbHonorSubList	= tbHonorSubList
	self.tbHonorSettings[8].szName			= "Bạch Hổ Đường";	
end

-- Hoạt động năm mới
function PlayerHonor:_InitEventHonorSetting()
	local tbHonorSubList		= {};
--	tbHonorSubList[1]			= {};
--	tbHonorSubList[1].szName	= "Dân tộc đại đoàn viên"
--	tbHonorSubList[1].nValue	= 0;
--	tbHonorSubList[1].nRank		= 0;
--	tbHonorSubList[1].nClass	= self.HONOR_CLASS_SPRING;
--	tbHonorSubList[1].nLevel	= 0;	
	
	tbHonorSubList[1]			= {};
	tbHonorSubList[1].szName	= "Thiền Cảnh Hoa Viên"
	tbHonorSubList[1].nValue	= 0;
	tbHonorSubList[1].nRank		= 0;
	tbHonorSubList[1].nClass	= self.HONOR_CLASS_DRAGONBOAT;
	tbHonorSubList[1].nLevel	= 0;	
	
	tbHonorSubList[2]			= {};
	tbHonorSubList[2].szName	= "Uy danh giang hồ"
	tbHonorSubList[2].nValue	= 0;
	tbHonorSubList[2].nRank		= 0;
	tbHonorSubList[2].nClass	= self.HONOR_CLASS_WEIWANG;
	tbHonorSubList[2].nLevel	= 0;
	
--	tbHonorSubList[3]			= {};
--	tbHonorSubList[3].szName	= "Anh hùng thiếp Võ Lâm Đại Hội"	--"Mỹ nữ"
--	tbHonorSubList[3].nValue	= 0;
--	tbHonorSubList[3].nRank		= 0;
--	tbHonorSubList[3].nClass	= self.HONOR_CLASS_PRETTYGIRL;
--	tbHonorSubList[3].nLevel	= 0;	

	tbHonorSubList[3]			= {};
	tbHonorSubList[3].szName	= "Bá Chủ Ấn"
	tbHonorSubList[3].nValue	= 0;
	tbHonorSubList[3].nRank		= 0;
	tbHonorSubList[3].nClass	= self.HONOR_CLASS_KAIMENTASK;
	tbHonorSubList[3].nLevel	= 0;
	
	tbHonorSubList[4]			= {};
	tbHonorSubList[4].szName	= "Mỹ nữ"
	tbHonorSubList[4].nValue	= 0;
	tbHonorSubList[4].nRank		= 0;
	tbHonorSubList[4].nClass	= self.HONOR_CLASS_PRETTYGIRL;
	tbHonorSubList[4].nLevel	= 0;
	
	tbHonorSubList[5]			= {};
	tbHonorSubList[5].szName	= "Di tích Hàn Vũ"
	tbHonorSubList[5].nValue	= 0;
	tbHonorSubList[5].nRank	= 0;
	tbHonorSubList[5].nClass	= self.HONOR_CLASS_LADDER1;
	tbHonorSubList[5].nLevel	= 0;	
	
	tbHonorSubList[6]			= {};
	tbHonorSubList[6].szName	= "Dạ Lam Quan"
	tbHonorSubList[6].nValue	= 0;
	tbHonorSubList[6].nRank	= 0;
	tbHonorSubList[6].nClass	= self.HONOR_CLASS_LADDER2;
	tbHonorSubList[6].nLevel	= 0;			
		
	
	self.tbHonorSettings[9] = {};
	self.tbHonorSettings[9].tbHonorSubList	= tbHonorSubList
	self.tbHonorSettings[9].szName			= "Hoạt động";
end

-- Lực chiến
function PlayerHonor:_InitFightPowerSetting()
	local tbHonorSubList		= {};
	
	tbHonorSubList[1]			= {};
	tbHonorSubList[1].szName	= "Tổng lực chiến"
	tbHonorSubList[1].nValue	= 0;
	tbHonorSubList[1].nRank		= 0;
	tbHonorSubList[1].nClass	= self.HONOR_CLASS_FIGHTPOWER_TOTAL;
	tbHonorSubList[1].nLevel	= 0;
	
	tbHonorSubList[2]			= {};
	tbHonorSubList[2].szName	= "Thành tựu"
	tbHonorSubList[2].nValue	= 0;
	tbHonorSubList[2].nRank		= 0;
	tbHonorSubList[2].nClass	= self.HONOR_CLASS_FIGHTPOWER_ACHIEVEMENT;
	tbHonorSubList[2].nLevel	= 0;
	
	self.tbHonorSettings[10] = {};
	self.tbHonorSettings[10].tbHonorSubList	= tbHonorSubList
	self.tbHonorSettings[10].szName			= "<color=green>Lực chiến<color>";	
end

function PlayerHonor:GetHonorLevel(pPlayer, nClass)
	local nLevel = 0;
	
	if (self.HONOR_CLASS_WULIN == nClass) then -- Cấp vinh dự Võ Lâm
		nLevel = pPlayer.GetTask(self.TSK_GROUP, self.TSK_ID_HONORLEVEL_WULIN);
	elseif (self.HONOR_CLASS_LINGXIU == nClass) then	-- Cấp vinh dự Thủ Lĩnh
		nLevel = pPlayer.GetTask(self.TSK_GROUP, self.TSK_ID_HONORLEVEL_LINGXIU);
	elseif (self.HONOR_CLASS_MONEY == nClass) then	-- Cấp vinh dự Tài phú
		nLevel = pPlayer.GetTask(self.TSK_GROUP, self.TSK_ID_HONORLEVEL_MONEY);	
	end
	return nLevel;
end

-- Script gamecenter ---------------------------------------------------------------------------

if (MODULE_GC_SERVER) then
	function PlayerHonor:ResetPlayerHonorByGS(szName, tbItems)
		for _, v in ipairs(tbItems) do
			local _, _, nDataClass, nDataType = string.find(v, "(%d+) (%d+)");
			nDataClass = tonumber(nDataClass);
			nDataType = tonumber(nDataType);
			SetPlayerHonorByName(szName, nDataClass, nDataType, 0);
		end
	end
	
	
	function PlayerHonor:LadderDeletedCallBack(nDataClass, nDataType)
		if not nDataClass or not  nDataType then
			print("Gọi LatticeSortedCallBack với tham số không hợp lệ, nDataClass, nDataType", nDataClass, nDataType);
			return;
		end
		
		if not self.nServerStartTime then
			self.nServerStartTime = GetServerStartTime();
		end
		if not self.nLeastValidLogoutTime then
			self.szNormalValueFile = self.szNormalValueFile or "\\setting\\gc_normalvalue.ini";
			local tbData = Lib:LoadIniFile(self.szNormalValueFile);
			if not tbData then
				return;
			end
			self.nLogoutTime = self.nLogoutTime or tbData.PlayerDBLoad.LogoutTime; -- Lần đăng xuất trước cách đây nhiều ngày, dữ liệu của nó sẽ được tải rút gọn
			self.nLeastValidLogoutTime = self.nServerStartTime - self.nLogoutTime * 86400;
		end
		
		if not self.tbInvalidTimeData then
			self:TryGetGlobalDataBuffer();
		end
		
		local szKey = string.format("%s %s", nDataClass, nDataType);
		self.tbInvalidTimeData[szKey]  = self.nLeastValidLogoutTime;
		SetGblIntBuf(GBLINTBUF_LADDER_BATCH, 0, 1, self.tbInvalidTimeData); 
		GlobalExcute{"PlayerHonor:SynDataItem", szKey, self.nLeastValidLogoutTime};
	end

	function PlayerHonor:OnSchemeUpdateHonorLadder()
		local nCurTime = GetTime();
		local nWeekDay	= tonumber(os.date("%w", nCurTime));
		self:DbgOut_GC("OnSchemeUpdateHonorLadder", "Open Honor", nWeekDay);
		
		local nDay	= tonumber(GetLocalDate("%d"));
		self:DbgOut_GC("OnSchemeUpdateSongJinBattleHonorLadder", "Open Honor", nDay);
		-- 先衰减
		if (28 == nDay) then
			print(string.format("OnSchemeLoadFactionHonorLadder Decrease Honor  nDay = %d", nDay));
			DecreaseFactionHonor();		
			print(string.format("OnSchemeUpdateSongJinBattleHonorLadder Decrease Honor  nDay = %d", nDay));
			DecreaseSongJinHonor();	
			DecreaseLeaderHonor();	-- Giảm vinh dự Thủ Lĩnh		
		end
		
		self:OnSchemeLoadFactionHonorLadder();
		self:OnSchemeUpdateSongJinBattleHonorLadder();		
		
		self:UpdateFightPowerHonorLadder();
		self:UpdateAchievementHonorLadder();
		self:UpdateLevelHonorLadder();
		Ladder.tbGuidLadder:UpdateRank();
		Ladder:DailySchedule();

		if (1 == nWeekDay or EventManager.IVER_bOpenTiFu == 1) then
			self:UpdateWuLinHonorLadder();
			self:UpdateMoneyHonorLadder();
			self:UpdateLeaderHonorLadder();
		
			KGblTask.SCSetDbTaskInt(DBTASD_HONOR_LADDER_TIME, GetTime());
			GlobalExcute({"PlayerHonor:OnLadderSorted"});			
			
			print(string.format("OnSchemeUpdateHonorLadder Update Honor  nDay = %d", nWeekDay));
		end
		
		-- 通知所有GS刷新玩家战斗力
		GSExecute(-1, {"Player.tbFightPower:RefreshAllPlayer"});
		
		--飞絮崖荣誉点
		local nCurDate = tonumber(os.date("%Y%m%d", nCurTime));
		--if nCurDate >= Esport.SNOWFIGHT_STATE[1] and nCurDate <= Esport.SNOWFIGHT_STATE[2] then
		--self:UpdateSpringHonorLadder();
		--end
		
		--龙舟荣誉榜(考虑到合服,领奖期间不进行排行)(合服后,排名一样的名次会自动清0)
		if (nCurDate <= TowerDefence.SNOWFIGHT_STATE[2] + 1 or nCurDate > TowerDefence.SNOWFIGHT_STATE[1]) then
		self:OnSchemeUpdateDragonBoatHonorLadder();
		end
		
		-- Reset trạng thái Long Ảnh Châu
		Player:ResetAllPlayerDragonBallState_GC();
		
		-- Bảng xếp hạng thú cưỡi mới
		--self:OnSchemeUpdateHorseFragHonorLadder();

		GlobalExcute{"Ladder:RefreshLadderName"};
	end
	
	-- Vinh dự Võ Lâm
	function PlayerHonor:UpdateWuLinHonorLadder()
		print("Bảng xếp hạng Võ Lâm bắt đầu");
		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_WULIN];
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);	

		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local nNowTime	= GetTime();
		local tbToday	= os.date("*t", nNowTime - 3600*24);
		local szDate	= string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate .. "Bảng vinh dự Võ Lâm";
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
	
		UpdateLadderDataForFaction(nType, 0);
		-- 分榜
		for i=1, Env.FACTION_NUM do
			local tbSubShow = GetTotalLadderPart(nType + i, 1, 10);
			local szSubContext	= szDate .. self.tbFacContext[i];
			local szLadderName	= self.tbFacContext[i];
			self:SetShowLadder(tbSubShow, nType + i, szLadderName, szSubContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
		end
		print("Bảng xếp hạng Võ Lâm kết thúc");
	end
	
	-- Vinh dự Tài phú
	function PlayerHonor:UpdateMoneyHonorLadder()
		print("Bảng xếp hạng Tài phú bắt đầu");
		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_MONEY];
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);
		-- Ở đây thực hiện hàm thay đổi giá trị
		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local nNowTime	= GetTime();
		local tbToday	= os.date("*t", nNowTime - 3600*24);
		local szDate	= string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate .. "Bảng vinh dự Tài phú";	
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
		self:GetHonorStatInfo(self.HONOR_CLASS_MONEY, 500, "moneyhonor", "Money");
		print("Bảng xếp hạng Tài phú kết thúc");
	end
	
	-- Vinh dự Thủ Lĩnh
	function PlayerHonor:UpdateLeaderHonorLadder()
		print("Bảng xếp hạng Thủ Lĩnh bắt đầu");
		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_LINGXIU];
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);
		-- Ở đây thực hiện hàm thay đổi giá trị
		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local nNowTime	= GetTime();
		local tbToday	= os.date("*t", nNowTime - 3600*24);
		local szDate	= string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate .. "Bảng vinh dự Thủ Lĩnh";	
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
		print("Bảng xếp hạng Thủ Lĩnh kết thúc");
	end
	
	-- Lực chiến——Tổng
	function PlayerHonor:UpdateFightPowerHonorLadder()
		print("Bảng xếp hạng Tổng lực chiến bắt đầu");
		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_FIGHTPOWER_TOTAL];
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);
		-- Ở đây thực hiện hàm thay đổi giá trị
		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local nNowTime	= GetTime();
		local tbToday	= os.date("*t", nNowTime - 3600*24);
		local szDate	= string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate .. "Bảng xếp hạng Lực chiến";
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
		print("Bảng xếp hạng Tổng lực chiến kết thúc");
	end
	
	-- Lực chiến——Thành tựu
	function PlayerHonor:UpdateAchievementHonorLadder()
		print("Bảng xếp hạng Thành tựu bắt đầu");
		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_FIGHTPOWER_ACHIEVEMENT];
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);
		-- Ở đây thực hiện hàm thay đổi giá trị
		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local nNowTime	= GetTime();
		local tbToday	= os.date("*t", nNowTime - 3600*24);
		local szDate	= string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate .. "Bảng vinh dự Thành tựu";	
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
		print("Bảng xếp hạng Thành tựu kết thúc");
	end
	
	-- Cấp độ
	function PlayerHonor:UpdateLevelHonorLadder()
		print("Bảng xếp hạng Cấp độ bắt đầu");
		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_LEVEL];
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);
		-- Ở đây thực hiện hàm thay đổi giá trị
		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local nNowTime	= GetTime();
		local tbToday	= os.date("*t", nNowTime - 3600*24);
		local szDate	= string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate .. "Bảng vinh dự Cấp độ";
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
		print("Bảng xếp hạng Cấp độ kết thúc");
	end
	
	-- Bảng vinh dự Phi Nhứ Nhai
	function PlayerHonor:UpdateSpringHonorLadder()
		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_SPRING];

		if (not tbLadderCfg) then
			return 0;
		end		
		
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);
		-- Ở đây thực hiện hàm thay đổi giá trị
		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local nNowTime	= GetTime();
		local tbToday	= os.date("*t", nNowTime - 3600*24);
		local szDate	= string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate .. tbLadderCfg.szLadderName;	
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
		GlobalExcute{"Ladder:RefreshLadderName"};
	end
	
		-- Bảng vinh dự Tiêu Dao
	function PlayerHonor:UpdateXoyoLadder(nFlag)
		print("Bảng xếp hạng Tiêu Dao Cốc bắt đầu");
		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_XOYOGAME];
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);
		-- Ở đây thực hiện hàm thay đổi giá trị
		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local nNowTime	= GetTime();
		local tbToday	= os.date("*t", nNowTime - 3600*24);
		local szDate	= string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate .. "Bảng thu thập Tiêu Dao";	
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
		GlobalExcute{"Ladder:RefreshLadderName"};
		
		print("Bảng xếp hạng Tiêu Dao Cốc kết thúc");
		
		if (0 == nFlag) then
			return;
		end
		SetXoyoAwardResult();
	end
	
	-- Vinh dự Môn phái
	function PlayerHonor:OnSchemeLoadFactionHonorLadder()
		self:DbgOut_GC("OnSchemeLoadFactionHonorLadder", "Update faction honor");

		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_FACTION];
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);	

		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local nNowTime	= GetTime();
		local tbToday	= os.date("*t", nNowTime - 3600*24);
		local szDate	= string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate .. "Bảng vinh dự Môn phái";
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
	
		UpdateLadderDataForFaction(nType, 1);
		-- 分榜
		for i=1, Env.FACTION_NUM do
			local tbSubShow = GetTotalLadderPart(nType + i, 1, 10);
			local szSubContext	= szDate .. self.tbFacContext[i];
			local szLadderName	= self.tbFacContext[i];
			self:SetShowLadder(tbSubShow, nType + i, szLadderName, szSubContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
		end
	end
	
		-- Vinh dự Tống Kim
	function PlayerHonor:OnSchemeUpdateSongJinBattleHonorLadder()
		self:DbgOut_GC("OnSchemeUpdateSongJinBattleHonorLadder", "Update songjin battle honor");

		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_BATTLE];
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);	

		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local nNowTime	= GetTime();
		local tbToday	= os.date("*t", nNowTime - 3600*24);
		local szDate	= string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate .. "Bảng vinh dự Tống Kim";
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
	end
	
		-- Vinh dự Thiền Cảnh Hoa Viên (Hoạt động Tết Thanh Minh)
	function PlayerHonor:OnSchemeUpdateDragonBoatHonorLadder()
		self:DbgOut_GC("OnSchemeUpdateDragonBoatHonorLadder", "Update DragonBoat honor");

		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_DRAGONBOAT];
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);

		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local nNowTime	= GetTime();
		local tbToday	= os.date("*t", nNowTime - 3600*24);
		local szDate	= string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate .. "Bảng vinh dự Thiền Cảnh Hoa Viên";
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
	end
	
	function PlayerHonor:OnSchemeUpdateWeiwangHonorLadder()
		self:DbgOut_GC("OnSchemeUpdateWeiwangHonorLadder", "Update DragonBoat honor");

		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_WEIWANG];
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);	

		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local nNowTime	= GetTime();
		local tbToday	= os.date("*t", nNowTime - 3600*24);
		local szDate	= string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate .. "Bảng uy danh giang hồ";
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
	end	

	function PlayerHonor:OnSchemeUpdatePrettygirlHonorLadder()
		self:DbgOut_GC("OnSchemeUpdatePrettygirlHonorLadder", "Update DragonBoat honor");

		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_PRETTYGIRL];
		
		if (not tbLadderCfg) then
			return 0;
		end
		
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);
		-- Ở đây thực hiện hàm thay đổi giá trị
		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local nNowTime	= GetTime();
		local tbToday	= os.date("*t", nNowTime - 3600*24);
		local szDate	= string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate .. "Bảng tuyển chọn mỹ nữ";		--"Bảng tuyển chọn mỹ nữ";
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
		GlobalExcute{"Ladder:RefreshLadderName"};
	end		
	
	
	function PlayerHonor:OnSchemeUpdateBeautyHeroHonorLadder()
		self:DbgOut_GC("OnSchemeUpdateBeautyHeroHonorLadder", "Update BeautyHero honor");

		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_BEAUTYHERO];
		
		if (not tbLadderCfg) then
			return 0;
		end
		
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);	

		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local szContext = "Võ Lâm Quần Phương Phổ";
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
		GlobalExcute{"Ladder:RefreshLadderName"};
	end			

	function PlayerHonor:OnSchemeUpdateHanWuHonorLadder()
		self:DbgOut_GC("OnSchemeUpdateHanWuHonorLadder", "Update HanWuYiJi");

		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_LADDER1];
		
		if (not tbLadderCfg) then
			return 0;
		end
		
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);	

		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local szContext = "Bảng dũng sĩ Di tích Hàn Vũ";
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
		GlobalExcute{"Ladder:RefreshLadderName"};
	end		
	
	
	function PlayerHonor:OnSchemeUpdateCastleFightHonorLadder()
		self:DbgOut_GC("OnSchemeUpdateCastleFightHonorLadder", "Update YELANGUAN");

		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_LADDER2];
		
		if (not tbLadderCfg) then
			return 0;
		end
		
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);	

		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local szContext = "Bảng vinh dự Dạ Lam Quan";
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
		GlobalExcute{"Ladder:RefreshLadderName"};
	end			
	
	function PlayerHonor:OnSchemeUpdateKaimenTaskHonorLadder()
		self:DbgOut_GC("OnSchemeUpdateKaimenTaskHonorLadder", "Update DragonBoat honor");

		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_KAIMENTASK];
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);	

		local tbShowLadder	= GetTotalLadderPart(nType, 1, 10);
		local nNowTime	= GetTime();
		local tbToday	= os.date("*t", nNowTime - 3600*24);
		local szDate	= string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate .. "Bảng Bá Chủ Ấn";
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
	end	
	
	--Bảng nộp mảnh thú cưỡi mới, sau khi làm mới bảng cần reset số lượng của người đứng đầu về 0
	function PlayerHonor:OnSchemeUpdateHorseFragHonorLadder(nSeqNum, bForce)
		local nCurTime = GetTime();
		local nWeekDay	= tonumber(os.date("%w", nCurTime));
		bForce = bForce or 0;
		
		self:DbgOut_GC("OnSchemeUpdateHorseFragHonorLadder", "Update HorseFrag honor");
		
		local nType = 0;
		local tbLadderCfg = Ladder.tbLadderConfig[self.HONOR_CLASS_LADDER3];
		nType = Ladder:GetType(0, tbLadderCfg.nLadderClass, tbLadderCfg.nLadderType, tbLadderCfg.nLadderSmall);
		UpdateTotalLadder(nType, tbLadderCfg.nDataClass, 0);
		
		local tbShowLadder = GetTotalLadderPart(nType, 1, 10);
		local nNowTime = GetTime();
		local tbToday = os.date("*t", nNowTime - 3600 * 24);
		local szDate = string.format("%d tháng %d ngày", tbToday.month, tbToday.day);
		local szContext = szDate.."Bảng thu thập Xích Dạ Phi Linh";
		self:SetShowLadder(tbShowLadder, nType, tbLadderCfg.szLadderName, szContext, tbLadderCfg.szPlayerContext, tbLadderCfg.szPlayerSimpleInfo);
		
		-- Thứ 4 hàng tuần xóa người mua thú cưỡi mới
		if nWeekDay == 3 or bForce == 1 then
			KGblTask.SCSetDbTaskInt(DBTASK_NEW_HORSE_OWNER, 0);
			KGblTask.SCSetDbTaskStr(DBTASK_NEW_HORSE_OWNER, "");
		end		
		
		-- Chủ nhật thiết lập người mua thú cưỡi
		if nWeekDay == 0 or bForce == 1 then
			-- Lấy dữ liệu 20 người đứng đầu
			for i = 1, 20 do
				local tbRankInfo = GetHonorLadderInfoByRank(nType, i);
				if not tbRankInfo then
					break;
				end
				
				-- Điểm dữ liệu
				local cKin = KKin.GetKin(KGCPlayer.GetKinId(tbRankInfo.nPlayerId));
				local szKinName = "Không gia tộc";
				local szTongName = "Không bang hội";
				if cKin then
					szKinName = cKin.GetName();
					local nTongId = cKin.GetBelongTong();
					local pTong = KTong.GetTong(nTongId);
					if pTong then
						szTongName = pTong.GetName();
					end
				end			
				local szLog = string.format("%d,%d,%s,%s,%s", i, tbRankInfo.nHonor, 
					tbRankInfo.szPlayerName, szKinName, szTongName);
				StatLog:WriteStatLog("stat_info", "keyimen_battle", "chip_collect_rank", 0, szLog);
				
				-- Người đứng đầu cần thiết lập thông tin trạng thái thú cưỡi, cần không dưới 300 cái mới có thể nhận thú cưỡi
				if i == 1 and tbRankInfo.nHonor >= self.NEW_HORSE_GET_LIMIT then
					--KGblTask.SCSetDbTaskInt(DBTASK_NEW_HORSE_OWNER, tbRankInfo.nPlayerId);   Không lưu ID nữa, lưu tên nhân vật
					KGblTask.SCSetDbTaskStr(DBTASK_NEW_HORSE_OWNER, tbRankInfo.szPlayerName);
					local szMsg = string.format("Chúc mừng hiệp sĩ %s đã nhận được một con thần câu [Xích Dạ Thiên Tường] do thương nhân Khắc Di Môn tặng!!", tbRankInfo.szPlayerName);
					Dialog:GlobalNewsMsg_GC(szMsg);
					Dialog:GlobalMsg2SubWorld_GC(szMsg);				
					
					local szMailMsg = [[Hiệp sĩ kính gửi: 
    Ngài đã tặng rất nhiều Phi Linh, đặc biệt tặng một con thần câu để tỏ lòng biết ơn. Mong ngài tiếp tục ra tiền tuyến, dũng cảm diệt địch.
    Kính báo, không phiền hồi đáp.
                            Thương nhân chiến trường Khắc Di Môn

 Mẹo nhỏ: Vui lòng đến gặp thương nhân trang bị chiến trường Khắc Di Môn để nhận sau khi nhận thư, tư cách nhận được giữ lại đến 21: 30 tối thứ 4 tuần sau.]]
					SendMailGC(tbRankInfo.nPlayerId, "Thư từ thương nhân chiến trường", szMailMsg);

					self:SetPlayerHonor(tbRankInfo.nPlayerId, PlayerHonor.HONOR_CLASS_LADDER3 , 0, 0);	-- Reset về 0
				end
			end
		end
		-- TODO:Gộp server thì sao???
	end

	function PlayerHonor:SetShowLadder(tbLadderResult, nType, szLadderName, szContext, szPlayerContext, szSimpleInfo)
		if (not tbLadderResult) then
			print("Ở đây không có dữ liệu bảng xếp hạng.....");
			return;
		end
		
		if (not szLadderName) then
			return;
		end
		
		DelShowLadder(nType);
		AddNewShowLadder(nType);
		SetShowLadderName(nType, szLadderName, string.len(szLadderName) + 1);
		self:ProcessShowLadderDetail(tbLadderResult, nType, szContext, szLadderName, szPlayerContext, szSimpleInfo);
	end
	
	function PlayerHonor:ProcessShowLadderDetail(tbLadderResult, nType, szContext, szLadderName, szPlayerContext, szSimpleInfo)
		local tbShowWorldLadder = {};
		for i, tbInfo in ipairs(tbLadderResult) do
			local tbPlayerInfo = GetPlayerInfoForLadderGC(tbInfo.szPlayerName);
			if (tbPlayerInfo) then
				local tbShowInfo = {};
				tbShowInfo.szName		= tbInfo.szPlayerName;
				tbShowInfo.szTxt1		= string.format(szSimpleInfo, tbInfo.dwValue);
				tbShowInfo.szContext	= string.format(szPlayerContext, tbInfo.dwValue);
				tbShowInfo.dwImgType	= tbPlayerInfo.nSex;
				tbShowInfo.szTxt2		= Player:GetFactionRouteName(tbPlayerInfo.nFaction, tbPlayerInfo.nRoute);
				tbShowInfo.szTxt3		= string.format("%d cấp", tbPlayerInfo.nLevel);
				local szKinName			= tbPlayerInfo.szKinName
				if (not szKinName or string.len(szKinName) <= 0) then
					szKinName	= "Không phải thành viên gia tộc";
				end
				tbShowInfo.szTxt4 = "Gia tộc: " .. szKinName;
				
				local szTongName			= tbPlayerInfo.szTongName
				if (not szTongName or string.len(szTongName) <= 0) then
					szTongName	= "Không phải thành viên bang hội";
				end
				tbShowInfo.szTxt5 = "Bang hội: " .. szTongName;
				tbShowInfo.szTxt6	= "0";
				tbShowWorldLadder[#tbShowWorldLadder + 1] = tbShowInfo;
			end
		end
		SetShowLadder(nType, szContext, string.len(szContext) + 1, tbShowWorldLadder);
		SetShowLadderName(nType, szLadderName, string.len(szLadderName) + 1);
	end
	
	function PlayerHonor:DbgOut_GC(szMode, ...)
		Dbg:Output("PlayerHonor", szMode, unpack(arg));
	end
	
	function PlayerHonor:AddPlayerHonor(nPlayerId, nClass, nType, nAddHonor)
		local nHonor = GetPlayerHonor(nPlayerId, nClass, nType);
		SetPlayerHonor(nPlayerId, nClass, nType, nAddHonor + nHonor);
	end
	
	function PlayerHonor:SetPlayerHonor(nPlayerId, nClass, nType, nAddHonor)
		SetPlayerHonor(nPlayerId, nClass, nType, nAddHonor);
	end
	
	function PlayerHonor:SetPlayerHonorByName(szName, nClass, nType, nHonor)
		SetPlayerHonorByName(szName, nClass, nType, nHonor);
	end
	
	function PlayerHonor:SetPlayerXoyoPointsByName(szName, nHonor)
		SetXoyoPointsByName(szName, nHonor);
	end
	
	function PlayerHonor:GetPlayerHonorByName(szName, nClass, nType)
		return GetPlayerHonorByName(szName, nClass, nType);
	end
	
	function PlayerHonor:GetPlayerHonor(nPlayerId, nClass, nType)
		return GetPlayerHonor(nPlayerId, nClass, nType);
	end

	function PlayerHonor:GetPlayerHonorRank(nPlayerId, nClass, nType)
		return GetPlayerHonorRank(nPlayerId, nClass, nType);
	end

	function PlayerHonor:GetPlayerHonorRankByName(szName, nClass, nType)
		return GetPlayerHonorRankByName(szName, nClass, nType);
	end
end



-- Script gameserver ---------------------------------------------------------------------------
if (MODULE_GAMESERVER) then
	
function PlayerHonor:SynDataItem(szKey, nValue)
	if not self.tbInvalidTimeData then
		self:TryGetGlobalDataBuffer();
	end
	self.tbInvalidTimeData[szKey]  = nValue;	
end

function PlayerHonor:SendHonorData()
	local nPlayerId	= me.nId;
	local nFaction	= me.nFaction;
	local nTime		= GetTime();
	
	local tbHonorData = {};
	for nRow, tbSetting in ipairs(self.tbHonorSettings) do
		local tbHonorSubList = {};
		
		for nType, tbData in ipairs(tbSetting.tbHonorSubList) do
			local nClass	= tbData.nClass;
			local tbHonorDataDetail		= {};
			tbHonorDataDetail.szName	= tbData.szName;
			local nValue	= 0;
			local nRank		= 0;

			local nSmallType = 0;
			if (self.HONOR_CLASS_FACTION == nClass) then
				nSmallType = nType - 1;
			end

			nValue	= GetPlayerHonor(nPlayerId, nClass, nSmallType);
			nRank	= GetPlayerHonorRank(nPlayerId, nClass, nSmallType);

			tbHonorDataDetail.nValue	= nValue;
			tbHonorDataDetail.nRank		= nRank;
			tbHonorDataDetail.nLevel	= 0;
			tbHonorDataDetail.nClass	= nClass;
			tbHonorSubList[nType] 		= tbHonorDataDetail;
		end
		
		tbHonorData[nRow]	= {};
		tbHonorData[nRow].tbHonorSubList	= tbHonorSubList;
		tbHonorData[nRow].szName			= tbSetting.szName;
	end
	me.CallClientScript({"PlayerHonor:OnSyncHonorData", tbHonorData});
end

function PlayerHonor:AddPlayerHonor(pPlayer, nClass, nType, nAddHonor)
	local szHonorName = self:GetHonorName(nClass, nType);
	if (not szHonorName) then
		return;
	end
	local nHonor = GetPlayerHonor(pPlayer.nId, nClass, nType);
	GCExcute({"PlayerHonor:AddPlayerHonor", pPlayer.nId, nClass, nType, nAddHonor});
	pPlayer.Msg("Của bạn" .. szHonorName .. "đã tăng" .. string.format("%d điểm", nAddHonor));
end

function PlayerHonor:AddPlayerHonorById_GS(nPlayerId, nClass, nType, nAddHonor)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
	if pPlayer then
		PlayerHonor:AddPlayerHonor(pPlayer, nClass, nType, nAddHonor);
	else
		GCExcute({"PlayerHonor:AddPlayerHonor", nPlayerId, nClass, nType, nAddHonor});
	end
end

function PlayerHonor:SetPlayerHonor(nPlayerId, nClass, nType, nAddHonor)
	GCExcute({"PlayerHonor:SetPlayerHonor", nPlayerId, nClass, nType, nAddHonor});
end

function PlayerHonor:SetPlayerHonorByName(szName, nClass, nType, nHonor)
	GCExcute({"PlayerHonor:SetPlayerHonorByName", szName, nClass, nType, nHonor});
end

function PlayerHonor:SetPlayerXoyoPointsByName(szName, nHonor)
	GCExcute({"PlayerHonor:SetPlayerXoyoPointsByName", szName, nHonor});
end

function PlayerHonor:GetPlayerHonorByName(szName, nClass, nType)
	return GetPlayerHonorByName(szName, nClass, nType);
end

function PlayerHonor:GetPlayerHonor(nPlayerId, nClass, nType)
	return GetPlayerHonor(nPlayerId, nClass, nType);
end

function PlayerHonor:GetPlayerHonorRank(nPlayerId, nClass, nType)
	return GetPlayerHonorRank(nPlayerId, nClass, nType);
end

function PlayerHonor:GetPlayerHonorRankByName(szName, nClass, nType)
	return GetPlayerHonorRankByName(szName, nClass, nType);
end

function PlayerHonor:AddConsumeValue(pPlayer, nValue, szWay)
	
	if not pPlayer or nValue < 0 then
		return 0;
	end
	local nLowValue = KLib.Number2UInt(pPlayer.GetTask(self.TSK_GROUP, self.TSK_ID_COSUME_VALUE));
	local nHighValue = KLib.Number2UInt(pPlayer.GetTask(self.TSK_GROUP, self.TSK_ID_COSUME_VALUE_HIGH)) * 10^9;
	local nConsumeValue = nLowValue + nHighValue + nValue;
	local nSaveLowValue = math.mod(nConsumeValue, 10^9);
	local nSaveHighValue = math.floor(nConsumeValue / 10^9);
	pPlayer.SetTask(self.TSK_GROUP, self.TSK_ID_COSUME_VALUE, nSaveLowValue);
	pPlayer.SetTask(self.TSK_GROUP, self.TSK_ID_COSUME_VALUE_HIGH, nSaveHighValue);
	Dbg:WriteLog("AddConsumeValue", nValue, pPlayer.szAccount, pPlayer.szName, (szWay or "Nguồn không rõ"))
	self:UpdataMaxWealth(pPlayer);
end


end


-- Script client ------------------------------------------------------------------------------
if (MODULE_GAMECLIENT) then

if (not PlayerHonor.tbPlayerHonorData) then
	PlayerHonor.tbPlayerHonorData = {};
	PlayerHonor.tbPlayerHonorData.tbHonorData	= {};
	PlayerHonor.tbPlayerHonorData.nSaveTime		= 0;
end

function PlayerHonor:ApplyHonorData()
	local nNowTime	= GetTime();
	local tbPlayerHonorData	= self.tbPlayerHonorData;
	if (tbPlayerHonorData and tbPlayerHonorData.nSaveTime > 0 and nNowTime - tbPlayerHonorData.nSaveTime <= 10) then
		return;
	end
	me.CallServerScript{"HonorDataApplyCmd"};
end

function PlayerHonor:OnSyncHonorData(tbHonorData)
	if (not tbHonorData) then
		return;
	end
	local nNowTime			= GetTime();
	
	for _, tbDate in ipairs(tbHonorData) do
		local tbSubDate = tbDate.tbHonorSubList;
		for nType, tbInfo in ipairs(tbSubDate) do
			local nClass = tbInfo.nClass;
			tbInfo.nLevel = self:GetHonorLevel(me, nClass);
		end
	end
	
	PlayerHonor.tbPlayerHonorData.tbHonorData	= tbHonorData;
	PlayerHonor.tbPlayerHonorData.nSaveTime		= nNowTime;
	CoreEventNotify(UiNotify.emCOREEVENT_HONORDATAREFRESH);
end

end

function PlayerHonor:CalcHonorLevel(nHonorValue, nHonorRank, szTypeName)
	local nRetLevel	= 0;
	for nLevel, tb in ipairs(self.tbHonorLevelInfo[szTypeName].tbLevel) do
		if (nHonorRank > 0) then
			if ((nHonorRank > tb.nMaxRank or nHonorValue < tb.nMinValue) and (tb.nMaxValue <= 0 or nHonorValue < tb.nMaxValue)) then
				break;
			end
		else
			if (tb.nMaxValue <= 0 or nHonorValue < tb.nMaxValue) then
				break;
			end
		end
		nRetLevel	= nLevel;
	end
	return nRetLevel;
end

--Lấy cấp độ vinh dự tài phú của người chơi
function PlayerHonor:GetPlayerMoneyHonorLevel(nPlayerId)
	local nHonorValue = self:GetPlayerHonor(nPlayerId, self.HONOR_CLASS_MONEY, 0);
	local nRank = self:GetPlayerHonorRank(nPlayerId, self.HONOR_CLASS_MONEY, 0);
	return self:CalcHonorLevel(nHonorValue, nRank, HONOR_KEY_MONEY);
end

function PlayerHonor:RefreshHonorLevel(pPlayer)
	local nLadderTime	= KGblTask.SCGetDbTaskInt(DBTASD_HONOR_LADDER_TIME) + 1;	-- 按照+1计算，保证不会有0
	local nRefreshTime	= pPlayer.GetTask(self.TSK_GROUP, self.TSK_ID_REFRESH_TIME);
	
	if (nRefreshTime == nLadderTime) then	-- Sau khi xếp hạng, người chơi này chưa làm mới
		local nHonorLevel = self:GetPlayerMaxHonorLevel(pPlayer);
		pPlayer.SetHonorLevel(nHonorLevel);	-- Thiết lập cấp độ vinh dự hiện tại
		return;
	end
	
	-- Đang ở liên server HOẶC đăng xuất, không làm mới cấp độ vinh dự
	if pPlayer.nIsExchangingOrLogout == 1 then
		return;
	end

	local nHonorLevel	= 0;
	local szLevelName	= "";
	local tbMyLevel		= {};
	local tbLevelDate	= {};	-- Ba loại cấp vinh dự lưu trữ ở đây
	for szType, tbTypeInfo in pairs(self.tbHonorLevelInfo) do
		local nHonorId		= tbTypeInfo.nHonorId;
		local nHonorRank	= self:GetPlayerHonorRank(pPlayer.nId, nHonorId, 0);
		local nHonorValue	= self:GetPlayerHonor(pPlayer.nId, nHonorId, 0);
		local nThisLevel	= self:CalcHonorLevel(nHonorValue, nHonorRank, szType);
		if (nThisLevel > 0) then
			tbMyLevel[#tbMyLevel+1]	= string.format("%s xếp hạng cấp %d", tbTypeInfo.szName, nThisLevel);
			if (nThisLevel > nHonorLevel) then
				nHonorLevel	= nThisLevel;
				szLevelName	= tbTypeInfo.tbLevel[nThisLevel].szName;
			end
		end
		tbLevelDate[szType] = nThisLevel;
	end
	
	local szMyLevel	= table.concat(tbMyLevel, "、");
	if (nHonorLevel > 0) then	-- Khi có xếp hạng sẽ gửi một thư thông báo
		local szMailMsg		= string.format([[
    Tình hình xếp hạng vinh dự của bạn vào 3 giờ sáng thứ 2 tuần này như sau: %s, nội dung chi tiết có thể xem trong <link=openwnd:Bảng Xếp Hạng,UI_LADDER>.
    Đồng thời, bạn đã nhận được danh hiệu %s, và có thể đến <color=yellow>chủ Tiền Trang để mua trang bị quan trọng nhất trong thế giới Kiếm Hiệp - Áo choàng<color>, nội dung cụ thể bạn có thể xem thông tin liên quan trong <link=openwnd:Cẩm nang trợ giúp,UI_HELPSPRITE>.]],
			szMyLevel, szLevelName);
		KPlayer.SendMail(pPlayer.szName, "Cập nhật Bảng Xếp Hạng Vinh dự", szMailMsg);
		-- Lần đầu nhận danh hiệu sẽ tặng đạo cụ, có thể trả lại Hồn Thạch
		if pPlayer.GetTask(self.TSK_GIFT_GROUP, self.TSK_ID_GIFT_GETAWARD) == 0 then
			local szMailMsg2 = string.format([[
    Trên bảng xếp hạng vinh dự lúc 3 giờ sáng thứ 2 tuần này, %s của bạn, Thu Dì xin chúc mừng bạn.
    Bạn có thể đến <color=yellow>chủ Tiền Trang để mua trang bị quan trọng nhất trong thế giới Kiếm Hiệp - Áo choàng<color>, nội dung cụ thể bạn có thể xem thông tin liên quan trong <link=openwnd:Cẩm nang trợ giúp,UI_HELPSPRITE>.
    <color=red>Quà tặng của Thu Dì<color> là Hồn Thạch trợ cấp mà Thu Dì tặng bạn, có thể sử dụng sau khi trang bị áo choàng.]],
	szMyLevel);
			local nRet = KPlayer.SendMail(pPlayer.szName, "Quà tặng của Thu Dì", szMailMsg2, 
					0, 0, 1, unpack(self.ITEM_FREEPIFENG_GIFT));
			if nRet == 1 then
				pPlayer.SetTask(self.TSK_GIFT_GROUP, self.TSK_ID_GIFT_GETAWARD, 1);
			end
		end
	end
	
	self:WriteLog(Dbg.LOG_INFO, "RefreshHonorLevel", pPlayer.szName, nHonorLevel, szMyLevel, nRefreshTime, nLadderTime);

	pPlayer.SetHonorLevel(nHonorLevel);	-- Thiết lập cấp độ vinh dự hiện tại
	for szType, nLevel in pairs(tbLevelDate) do
		self:SavePlayerHonorLevel(pPlayer, szType, nLevel);
	end
	pPlayer.SetTask(self.TSK_GROUP, self.TSK_ID_REFRESH_TIME, nLadderTime);	-- Ghi lại thời gian làm mới
	self:ClearMaxWealth(pPlayer);
end

function PlayerHonor:GetPlayerMaxHonorLevel(pPlayer)
	local nHonorLevel = 0;
	for szType, tbTypeInfo in pairs(self.tbHonorLevelInfo) do
		local nLevelTaskId	= tbTypeInfo.nLevelTaskId;
		local nThisLevel	= pPlayer.GetTask(self.TSK_GROUP, nLevelTaskId);
		if (nThisLevel > 0) then
			if (nThisLevel > nHonorLevel) then
				nHonorLevel	= nThisLevel;
			end
		end
	end
	return nHonorLevel;	
end

function PlayerHonor:SavePlayerHonorLevel(pPlayer, szType, nLevel)
	local tbInfo = self.tbHonorLevelInfo[szType];
	if (tbInfo and tbInfo.nLevelTaskId > 0) then
		pPlayer.SetTask(self.TSK_GROUP, tbInfo.nLevelTaskId, nLevel);
	end
end

function PlayerHonor:OnLadderSorted()
	for _, pPlayer in ipairs(KPlayer.GetAllPlayer()) do
		self:RefreshHonorLevel(pPlayer);
	end
end

function PlayerHonor:OnLogin(bExchangeServerComing)--modified by zhangzhixiong in 2011.4.15
	if GLOBAL_AGENT then
		local nHonorLevel = self:GetPlayerMaxHonorLevel(me);
		me.SetHonorLevel(nHonorLevel);	-- Thiết lập cấp độ vinh dự hiện tại
	else 
		if bExchangeServerComing ~= 1 then
			self:UpdataEquipWealth(me, Item.EQUIPPOS_MANTLE)
			self:UpdataEquipWealth(me, Item.EQUIPPOS_ZHENYUAN_MAIN)
			self:UpdataEquipWealth(me, Item.EQUIPPOS_ZHENYUAN_SUB1)
			self:UpdataEquipWealth(me, Item.EQUIPPOS_ZHENYUAN_SUB2)
			self:UpdatePartnerValue(me, 0);
		end
		self:RefreshHonorLevel(me);
	end
	if bExchangeServerComing ~= 1 then
		self:SendHonorData();
	end
	
	if not self.tbInvalidTimeData then
		self:TryGetGlobalDataBuffer();
	end
	
	local nLastLogoutTime = me.GetLastLogoutTime();
	if nLastLogoutTime > 0 then
		local tbItems = {};
		for k, v in pairs(self.tbInvalidTimeData) do
			if v > nLastLogoutTime then
				table.insert(tbItems, k); -- me的k需要重置
			end
		end
		if #tbItems ~= 0 then
			GCExcute{"PlayerHonor:ResetPlayerHonorByGS", me.szName, tbItems};
		end
	end
	
    --Add by zhangzhixiong in 2011.4.14
    if (bExchangeServerComing ~= 1) then
	    local szCurIp = "Không có";
	    local nIp = me.dwIp;
	    if (nIp and nIp ~= 0) then
	        szCurIp = Lib:IntIpToStrIp(me.dwIp);
	    end
	    local bMiniClient, nRepresentMode = me.GetLoginCollectInfo();
	    local szComputerId = me.GetMacAddr();
	    local szLogMsg = string.format("%s,%s,%s,%s,%s,%s", szCurIp, me.nLevel, me.GetHonorLevel(), szComputerId, bMiniClient, nRepresentMode);
	    StatLog:WriteStatLog("stat_info", "login", "login", me.nId, szLogMsg);
	 end
	--zhangzhangxiong add end
end

function PlayerHonor:UpdataEquipWealth(pPlayer, nEquipPos, bClear)
	local nTaskId = nEquipPos + 1;		-- nEquipPos是从0开始算的，nTaskId是从1开始算的
	if not pPlayer then
		return 0;
	end
	
	-- Cộng thêm trang bị đồng hành
	if (nEquipPos >= Item.EQUIPPOS_NUM + Item.PARTNEREQUIP_NUM) then
		return 0;
	end
	
	local nTotleValue = 0;
	
	if (nEquipPos >= Item.EQUIPPOS_NUM) then		-- 同伴装备
		local pItem = pPlayer.GetItem(Item.ROOM_PARTNEREQUIP, nEquipPos - Item.EQUIPPOS_NUM, 0);
		if (pItem) then
			nTotleValue = pItem.nValue;		-- Hiện tại chỉ cộng thêm tài phú cơ bản của trang bị đồng hành, sau này có thể có tài phú bồi dưỡng
		end
	elseif nEquipPos >= Item.EQUIPPOS_ZHENYUAN_MAIN and nEquipPos <= Item.EQUIPPOS_ZHENYUAN_SUB2 then
		local pItem = pPlayer.GetItem(Item.ROOM_EQUIP, nEquipPos, 0);
		if (pItem) then
			nTotleValue = Item.tbZhenYuan:GetZhenYuanValue(pItem);
		end
	else					-- Là trang bị người chơi
		local nValue1	= self:CaculateTotalEquipValue(pPlayer, Item.ROOM_EQUIPEX, Item.ROOM_EQUIP, nEquipPos);
		local nValue2	= self:CaculateTotalEquipValue(pPlayer, Item.ROOM_EQUIP, Item.ROOM_EQUIPEX, nEquipPos);

		nTotleValue = math.max(nValue1, nValue2);		
	end

	if nEquipPos >= Item.EQUIPPOS_ZHENYUAN_MAIN and nEquipPos <= Item.EQUIPPOS_ZHENYUAN_SUB2 then
		if (nTotleValue ~= pPlayer.GetTask(self.WEALTH_TASK_GROUP, nTaskId)) then
			pPlayer.SetTask(self.WEALTH_TASK_GROUP, nTaskId, nTotleValue);
			self:UpdataMaxWealth(pPlayer);
		end
	else
		local nCurMax = pPlayer.GetTask(self.WEALTH_TASK_GROUP, nTaskId);
		if (nTotleValue > nCurMax) or (bClear and bClear == 1) then
			pPlayer.SetTask(self.WEALTH_TASK_GROUP, nTaskId, nTotleValue);
		end
		if (nTotleValue > nCurMax) and (not bClear or bClear ~= 1) then		-- Khi xóa dữ liệu không cập nhật ở đây
			self:UpdataMaxWealth(pPlayer);
		end
	end
end

function PlayerHonor:UpdateFightPower(pPlayer, pItem)
	--local nCurMax =	pPlayer.GetTask(Player.tbFightPower.TASK_GROUP, Player.tbFightPower.TASK_FIGHTPOWER);
	local nPower = Player.tbFightPower:GetFightPower(pPlayer);
	--print("New:", Player.tbFightPower:GetFightPower(pPlayer), "Old:", pPlayer.GetFightPower(), "Cur:", nCurMax);
	if nPower ~= math.floor(pPlayer.GetFightPower() * 100) then
		-- 刷新战斗力
		local nSync = (pPlayer.nMapId == Atlantis.MAP_ID and 1) or nil;
		Player.tbFightPower:RefreshFightPower(pPlayer, nSync);
	end
end

--Làm mới lượng giá trị đồng hành đã ghi
function PlayerHonor:UpdatePartnerValue(pPlayer, bClear)
	local tbPartnerValue = {};
	for i = 0, pPlayer.nPartnerCount - 1 do
		local nValue = Partner:GetPartnerValue(pPlayer.GetPartner(i));
		table.insert(tbPartnerValue, i + 1, {nValue, i});
	end
	
	table.sort(tbPartnerValue, function(a, b) return a[1] > b[1] end);

	local nPartnerValue = 0;
	for i = 1, Partner.VALUE_CALC_MAX_NUM do
		if (tbPartnerValue[i]) then
			nPartnerValue = nPartnerValue + tbPartnerValue[i][1];
		end		
	end

	local nTaskPartnerValue = pPlayer.GetTask(self.TSK_GROUP, self.TSK_ID_PARTNER_VALUE);
	if nPartnerValue > nTaskPartnerValue or bClear == 1 then
		pPlayer.SetTask(self.TSK_GROUP, self.TSK_ID_PARTNER_VALUE, nPartnerValue);
		if bClear ~= 1 then
			self:UpdataMaxWealth(pPlayer);
		end
	end
end

function PlayerHonor:CaculateTotalEquipValue(pPlayer, nRoomType1, nRoomType2, nEquipPos)
	local nTotleValue = 0;
	-- Trước tiên tính toán giá trị cường hóa của ô trang bị dự phòng
	local pEquip = pPlayer.GetItem(nRoomType1, nEquipPos, 0);
	if pEquip and pEquip.nOrgValue > 0 then
		local tbSetting = Item:GetExternSetting("value", pEquip.nVersion);
		if (tbSetting) then
			local nTypeRate = ((tbSetting.m_tbEquipTypeRate[pEquip.nDetail] or 100) / 100) or 1;
			local nEnhTimes = pEquip.nEnhTimes;
			repeat
				local nEnhValue = tbSetting.m_tbEnhanceValue[nEnhTimes] or 0;
				nTotleValue = nTotleValue + nEnhValue * nTypeRate;
				nEnhTimes = nEnhTimes - 1;
			until (nEnhTimes <= 0);
			
			--需要算上改造价值量  added by dengyong 2009-11-12
			if pEquip.nStrengthen == 1 then
				local nStrengthenValue = tbSetting.m_tbStrengthenValue[pEquip.nEnhTimes] or 0;
				nTotleValue = nTotleValue + nStrengthenValue * nTypeRate;
			end	
			-- zjq tính giá trị đục lỗ/2
			local nHoleValue = Item:GetClass("equip"):CalcHoleValue(pEquip) / 2;
			nTotleValue = nTotleValue + nHoleValue;
		end
	end
	-- Sau đó lấy giá trị trang bị
	pEquip = pPlayer.GetItem(nRoomType2, nEquipPos, 0);
	if pEquip and pEquip.nOrgValue > 0 then
		nTotleValue = nTotleValue + pEquip.nValue;
	end

	return nTotleValue;
end

function PlayerHonor:UpdataMaxWealth(pPlayer)
	local nTotleValue = 0;
	-- 获取各个位置的装备总和
	for i = 1, Item.EQUIPPOS_NUM + Item.PARTNEREQUIP_NUM do
		local nValue = pPlayer.GetTask(self.WEALTH_TASK_GROUP, i);
		if nValue < 0 then
			nValue = KLib.Number2UInt(nValue);
		end
		
		nTotleValue = nTotleValue + nValue;
	end
	local tbWuLin = Item:GetClass("wulinmiji");
	local tbXiShui = Item:GetClass("xisuijing");

	for i, tbParam in ipairs(tbWuLin.tbBook) do
		if self.tbBookToValue[i] then
			nTotleValue = nTotleValue + self.tbBookToValue[i] * pPlayer.GetTask(tbParam[2], tbParam[3]);
		end
	end
	for i, tbParam in ipairs(tbXiShui.tbBook) do
		if self.tbBookToValue[i] then
			nTotleValue = nTotleValue + self.tbBookToValue[i] * pPlayer.GetTask(tbParam[2], tbParam[3]);
		end
	end
	
	nTotleValue = nTotleValue + 1000000 * pPlayer.GetTask(2040, 20);	--Cộng bánh trung thu kỹ năng (Thái Vân Truy Nguyệt)
	nTotleValue = nTotleValue + 1000000 * pPlayer.GetTask(2040, 21);	--Cộng bánh trung thu tiềm năng (Thương Hải Nguyệt Minh)
	
	-- Khi sở hữu kỹ năng mật tịch cao cấp, cộng thêm tài phú mật tịch
	for nSkillId, tbSkill in pairs(self.tbGaojiMijiValue) do		
		local nLevel = pPlayer.GetSkillBaseLevel(nSkillId);
		if (nLevel > 0 and tbSkill[nLevel] and tbSkill[nLevel] > 0) then
			nTotleValue = nTotleValue + tbSkill[nLevel];
		end
	end
	
	--Tính giá trị đồng hành, zhaoyu 2009/12/16 14:51:54
	nTotleValue = nTotleValue + pPlayer.GetTask(self.TSK_GROUP, self.TSK_ID_PARTNER_VALUE);	
	
	-- Tính toán tích lũy tài phú tiêu hao
	local nLowValue = KLib.Number2UInt(pPlayer.GetTask(self.TSK_GROUP, self.TSK_ID_COSUME_VALUE));
	local nHighValue = KLib.Number2UInt(pPlayer.GetTask(self.TSK_GROUP, self.TSK_ID_COSUME_VALUE_HIGH)) * 10^9;
	nTotleValue = nTotleValue + nHighValue + nLowValue;
	
	self:WriteLog(Dbg.LOG_INFO, "UpdataMaxWealth", pPlayer.szName, pPlayer.nId, PlayerHonor.HONOR_CLASS_MONEY , 0, nTotleValue);
	nTotleValue = math.floor(nTotleValue / 10000);
	self:SetPlayerHonor(pPlayer.nId, PlayerHonor.HONOR_CLASS_MONEY , 0, nTotleValue); --Thiết lập tài phú qua id người chơi
end

function PlayerHonor:CheckMaxMoneyValue(pPlayer)
	local bNeedReCal = 0;
	local nCalcValue = self:UpdataMaxWealth(pPlayer, 0);
	local nOldValue = nCalcValue;
	
	-- Chỉ có Chân Nguyên là hay có vấn đề, ở đây chỉ kiểm tra Chân Nguyên
	local pZhenYuanValue = 0;
	for i = Item.EQUIPPOS_ZHENYUAN_MAIN, Item.EQUIPPOS_ZHENYUAN_SUB2 do
		local pZhenYuan = pPlayer.GetItem(Item.ROOM_EQUIP, i, 0);
		if pZhenYuan then
			local pCurValue = Item.tbZhenYuan:GetZhenYuanValue(pZhenYuan);
			pZhenYuanValue = pZhenYuanValue + pCurValue;
			if pCurValue ~= pPlayer.GetTask(self.WEALTH_TASK_GROUP, i + 1) then
				Dbg:WriteLog("PlayerHonor", "CheckMaxMoneyValue", pPlayer.szName.."của Chân Nguyên"..(i-Item.EQfUIPPOS_ZHENYUAN_MAIN+1).."ghi nhận tài phú sai, giá trị ghi nhận là: "..
					pPlayer.GetTask(self.WEALTH_TASK_GROUP, i + 1)..",thực tế phải là: "..pCurValue);
				pPlayer.SetTask(self.WEALTH_TASK_GROUP, i, pCurValue);
				bNeedReCal = 1;
			end
			-- Vì phải tính lại tài phú Chân Nguyên, nên trừ đi tài phú Chân Nguyên trong biến nhiệm vụ khỏi tổng tài phú
			nCalcValue = nCalcValue - pPlayer.GetTask(self.WEALTH_TASK_GROUP, i);
		end
	end
	
	-- Dù sao cứ có vấn đề là lại cho là Chân Nguyên...
	if (nCalcValue + pZhenYuanValue ~= GetPlayerHonor(pPlayer.nId, PlayerHonor.HONOR_CLASS_MONEY, 0)) then
		bNeedReCal = 1;
	end
	
	-- TODO:Trong trường hợp xấu nhất, ở đây có thể dẫn đến vòng lặp logic vô hạn, cân nhắc giới hạn
	if bNeedReCal == 1 then
		local nNewValue = self:UpdataMaxWealth(pPlayer);
		Dbg:WriteLog("PlayerHonor", "CheckMaxMoneyValue", pPlayer.szName.."Vấn đề tài phú Chân Nguyên đã được sửa, cập nhật lại tổng tài phú! OldValue: "..nOldValue..", NewValue: "..nNewValue);
	end
end

function PlayerHonor:ClearMaxWealth(pPlayer)
	for i = 0, Item.EQUIPPOS_NUM + Item.PARTNEREQUIP_NUM- 1 do		-- 加上同伴装备的
		self:UpdataEquipWealth(pPlayer, i, 1);
	end
	self:UpdatePartnerValue(pPlayer, 1)
	self:UpdataMaxWealth(pPlayer);
end

function PlayerHonor:GetHonorStatInfo(nHonorClass, nMaxSize, szFileName, szHonorName)
	nMaxSize = nMaxSize or 100;
	local szGateway		= GetGatewayName();
	local nLadderType	= GetLadderTypeByDataType(nHonorClass, 0);
	if (not szFileName or string.len(szFileName) <= 0) then
		print("PlayerHonor:GetHonorStatInfo there is no szFileName!!!");
		return;
	end
	
	if (not szHonorName or string.len(szHonorName) <= 0) then
		print("PlayerHonor:GetHonorStatInfo there is no szHonorName!!!");
		return;
	end
	
	if (nHonorClass <= 0) then
		print("PlayerHonor:GetHonorStatInfo there is no nHonorClass!!!");
		return;
	end

	print("PlayerHonor:GetHonorStatInfo() start ", szFileName);
	
	local szOutFile = "\\playerladder\\" .. szFileName .. "_" .. szGateway .. ".txt";
	
	local szTime	= os.date("%Y-%m-%d %H:%M:%S", GetTime());
	
	local szContext = "Rank\tGateWay\tAccount\tPlayerName\tFaction\tRoute\tLevel\tSex\tKinName\tTongName\t" .. szHonorName .. "Honor\t" .. szTime .. "\n";
	
	--"Xếp hạng\tServer\tTài khoản\tTên nhân vật\tMôn phái\tNhánh\tCấp người chơi\tGiới tính\tGia tộc\tBang hội\t" .. szHonorName .. "Điểm vinh dự\n";
	KFile.WriteFile(szOutFile, szContext);
	for i=1, nMaxSize do
		local tbLadderInfo = GetPlayerLadderInfoByRank(nLadderType, i);
		if (tbLadderInfo) then
			local tbInfo = GetPlayerInfoForLadderGC(tbLadderInfo.szPlayerName);
			if (tbInfo) then
				local szOut = i .. "\t" .. szGateway .. "\t" .. tbInfo.szAccount .. "\t" .. tbLadderInfo.szPlayerName .. "\t" .. Player:GetFactionRouteName(tbInfo.nFaction) .. "\t" .. Player:GetFactionRouteName(tbInfo.nFaction, tbInfo.nRoute) .. "\t" .. tbInfo.nLevel .. "\t" .. Player.SEX[tbInfo.nSex] .. "\t";

				if (string.len(tbInfo.szKinName) > 0) then
					szOut = szOut .. tbInfo.szKinName .. "\t";
				else
					szOut = szOut .. "Không gia tộc\t";
				end 

				if (string.len(tbInfo.szTongName) > 0) then
					szOut = szOut .. tbInfo.szTongName .. "\t";
				else
					szOut = szOut .. "Không bang hội\t";
				end
				szOut = szOut .. tbLadderInfo.dwValue .. "\n";
				--szContext = szContext .. szOut;
				KFile.AppendFile(szOutFile, szOut);	
			end
		end
	end
	--KFile.WriteFile(szOutFile, szContext);

	for i=1, GbWlls.DEF_ADV_MAXGBWLLS_MONEY_RANK do
		local tbLadderInfo = GetPlayerLadderInfoByRank(nLadderType, i);
		if (tbLadderInfo) then
			Dbg:WriteLogEx(Dbg.LOG_INFO, "GbWlls_Join_" .. szHonorName, i, tbLadderInfo.szPlayerName, tbLadderInfo.dwValue);
		end
	end


	print("PlayerHonor:GetHonorStatInfo() end\n");
end


---------------------------------------------------------------------------------
-- sutingwei thêm hàm tính toán các loại tài phú
---------------------------------------------------------------------------------
--	2012/7/31 12:00:55  Tập hợp các hàm trong tệp HonorCalculator vào đây
--Bảng lưu giá trị cường hóa của trang bị trong ô trang bị
local tbEquipFwdEnh = {};
--Bảng lưu giá trị cường hóa của trang bị trong ô trang bị dự phòng
local tbEquipBakEnh = {};

--Tính toán giá trị gốc của trang bị này	
function PlayerHonor:CaculateEquipOrgValue(nRoomType,nEquipPos)
	local nOrgValue = 0;
	local nEnhValue = 0;
	local nTotleValue = 0;
	local pEquip = me.GetItem(nRoomType, nEquipPos, 0);
	if pEquip then
		local tbSetting = Item:GetExternSetting("value", pEquip.nVersion);
		if (tbSetting) then
			local nTypeRate = ((tbSetting.m_tbEquipTypeRate[pEquip.nDetail] or 100) / 100) or 1;
			local nEnhTimes = pEquip.nEnhTimes;
			repeat
				local nEnhValue = tbSetting.m_tbEnhanceValue[nEnhTimes] or 0;
				nTotleValue = nTotleValue + nEnhValue * nTypeRate;
				nEnhTimes = nEnhTimes - 1;
			until (nEnhTimes <= 0);
			
			--需要算上改造价值量  added by dengyong 2009-11-12
			if pEquip.nStrengthen == 1 then
				local nStrengthenValue = tbSetting.m_tbStrengthenValue[pEquip.nEnhTimes] or 0;
				nTotleValue = nTotleValue + nStrengthenValue * nTypeRate;
			end	
			-- zjq tính giá trị đục lỗ/2
			local nHoleValue = Item:GetClass("equip"):CalcHoleValue(pEquip) / 2;
			nTotleValue = nTotleValue + nHoleValue;
		end
	 	nTotleValue = pEquip.nValue;
    end
    nOrgValue = nTotleValue - nEnhValue; 
    return nOrgValue;
end

-- Tính toán giá trị cường hóa của trang bị. Nếu không cung cấp nEnhTimes thì mặc định là độ cường hóa của trang bị, ngược lại tính theo nEnhTimes đã cho
function PlayerHonor:CaculateEquipEnhValue(nRoomType,nEquipPos,nEnhTimes)
	local nEnhValue = 0;
	local nTotleValue = 0;
	local nStrengthen = 0;
	
	local pEquip = me.GetItem(nRoomType, nEquipPos, 0);
	if pEquip then
		local tbSetting = Item:GetExternSetting("value", pEquip.nVersion);
		if (not nEnhTimes) then
			nEnhTimes = pEquip.nEnhTimes;
			if pEquip.nStrengthen == 1 then
				nStrengthen = 1;
			end
 		end
		if nEnhTimes == 15.5 then
			nStrengthen = 1;
			nEnhTimes = 15;
		end
		
		if (tbSetting) then
			local nTypeRate = ((tbSetting.m_tbEquipTypeRate[pEquip.nDetail] or 100) / 100) or 1;
			repeat
				local nEnhValue = tbSetting.m_tbEnhanceValue[nEnhTimes] or 0;
				nTotleValue = nTotleValue + nEnhValue * nTypeRate;
				nEnhTimes = nEnhTimes - 1;
			until (nEnhTimes <= 0);
				
			if nStrengthen == 1 then
				local nStrengthenValue = tbSetting.m_tbStrengthenValue[pEquip.nEnhTimes] or 0;
				nTotleValue = nTotleValue + nStrengthenValue * nTypeRate;
			end			
				
			nEnhValue = nTotleValue;
			if nRoomType == Item.ROOM_EQUIP then
				tbEquipFwdEnh[nEquipPos] = nEnhValue;
			elseif nRoomType == Item.ROOM_EQUIPEX then
				tbEquipBakEnh[nEquipPos] = nEnhValue;
		    end
		end
	end
    return nEnhValue; 
end

--Tính toán giá trị của trang bị này
function PlayerHonor:CaculateEquipTotalValue(nRoomType,nEquipPos)
	local nValue = 0;
	local pEquip = me.GetItem(nRoomType, nEquipPos, 0);
   	if pEquip then
		nValue = pEquip.nValue;
    end
	return nValue;
end

--Tính toán số lần đã cường hóa của trang bị này
function PlayerHonor:GetEquipEnhTimes(nRoomType,nEquipPos)
	local nEnhTimes = 0;
    local pEquip = me.GetItem(nRoomType, nEquipPos, 0);
    if pEquip then 
 	   nEnhTimes = pEquip.nEnhTimes;
    end
    return nEnhTimes;
end

--Tính toán giá trị của ô trang bị này	
function PlayerHonor:CaculateEquipPosValue(nEquipPos)
	local nTotleValue = 0;
	if nEquipPos < 0 then 
		return 0;
	end
	if nEquipPos < Item.EQUIPEXPOS_NUM	 then  
		local nEnhValue =( tbEquipFwdEnh[nEquipPos] or self:CaculateEquipEnhValue(Item.ROOM_EQUIP, nEquipPos))
		                +( tbEquipBakEnh[nEquipPos] or self:CaculateEquipEnhValue(Item.ROOM_EQUIPEX, nEquipPos));
		local nValue1	= self:CaculateEquipOrgValue(Item.ROOM_EQUIP, nEquipPos);
		local nValue2	= self:CaculateEquipOrgValue(Item.ROOM_EQUIPEX, nEquipPos);		
	    nTotleValue = math.max(nValue1,nValue2);
		nTotleValue = nTotleValue + nEnhValue;
	elseif nEquipPos < Item.EQUIPPOS_NUM then
		nTotleValue = self:CaculateEquipTotalValue(Item.ROOM_EQUIP, nEquipPos);
	else
		 return 0;
    end	
	return nTotleValue;
end

function PlayerHonor:GetWulinmijiValue()
	local nTotleValue = 0;
	local tbWuLin = Item:GetClass("wulinmiji");
	for i, tbParam in ipairs(tbWuLin.tbBook) do
		if self.tbBookToValue[i] then
			nTotleValue = nTotleValue + self.tbBookToValue[i] * me.GetTask(tbParam[2], tbParam[3]);
		end
	end
	return nTotleValue;
end

function PlayerHonor:GetXisuijingValue()
	local tbXiShui = Item:GetClass("xisuijing");
	local nTotleValue = 0;
	for i, tbParam in ipairs(tbXiShui.tbBook) do
		if self.tbBookToValue[i] then
			nTotleValue = nTotleValue + self.tbBookToValue[i] * me.GetTask(tbParam[2], tbParam[3]);
		end
	end
	return nTotleValue;
end

function PlayerHonor:GetXiaohaoValue()
	local nTotleValue = 0;
	nTotleValue = me.GetTask(self.TSK_GROUP, self.TSK_ID_COSUME_VALUE);
	return nTotleValue;
end

function PlayerHonor:GetYuebingValue()
	local nTotleValue = 0;
	nTotleValue = nTotleValue + 1000000 * me.GetTask(2040, 20);	--Cộng bánh trung thu kỹ năng (Thái Vân Truy Nguyệt)
	nTotleValue = nTotleValue + 1000000 * me.GetTask(2040, 21);	--Cộng bánh trung thu tiềm năng (Thương Hải Nguyệt Minh)
	return nTotleValue;	
end

function PlayerHonor:GetPartnerValue()
	local nTotleValue = 0;
	nTotleValue = me.GetTask(self.TSK_GROUP, self.TSK_ID_PARTNER_VALUE);
	return nTotleValue;	
end

function PlayerHonor:GetPartnerEquipValue()
	local nValue = 0;
	for i = 1,Item.PARTNEREQUIP_NUM do
		local pEquip = me.GetItem(Item.ROOM_PARTNEREQUIP,i-1,0)
		if pEquip then
			nValue = nValue + pEquip.nOrgValue;
		end
	end
	return nValue;
end

--Tính toán vinh dự tài phú hiện tại	
function PlayerHonor:CaculateTotalWealthValue()
	local nTotalValue = 0;
  	for i = 0 , Item.EQUIPPOS_NUM-1  do
			nTotalValue = nTotalValue + 
			 	self:CaculateEquipPosValue(i);
	end
 	nTotalValue = nTotalValue + self:GetWulinmijiValue();
	nTotalValue = nTotalValue + self:GetXisuijingValue();
	nTotalValue = nTotalValue + self:GetXiaohaoValue();
	nTotalValue = nTotalValue + self:GetYuebingValue();
	nTotalValue = nTotalValue + self:GetPartnerValue();
	nTotalValue = nTotalValue + self:GetPartnerEquipValue();
   	nTotalValue = math.floor(nTotalValue / 10000);
   	return nTotalValue;
end


PlayerHonor:Init();



if (MODULE_GAMESERVER) then
	PlayerEvent:RegisterGlobal("OnLogin", PlayerHonor.OnLogin, PlayerHonor);
--	PlayerSchemeEvent:RegisterGlobalWeekEvent({PlayerHonor.OnWeekEvent_DecreaseFactionHonor, PlayerHonor});
end
