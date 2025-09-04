-----------------------------------------------------
--Tên tệp		：	mailnew.lua
--Người tạo		：	ZouYing@kingsoft.net
--Thời gian tạo		：	2007-10-25
--Mô tả chức năng		：	Script thư hệ thống
------------------------------------------------------

------------------------------------------------------
-- Hướng dẫn định dạng nội dung thư
-- szTitle : Tiêu đề thư
-- szContent : <Sender>XXX<Sender> ：Chỉ người gửi, phải điền trước nội dung thư, nếu không điền mặc định là Hệ thống, XXX: là tên người gửi, ví dụ như Trừng Huệ, Quý Thúc Ban...
------------------------------------------------------

Mail.tbMail = {
  [Env.FACTION_ID_SHAOLIN] = {
    szTitle = "Giới Thư Đệ Tử Nhập Thất", --Thiếu Lâm
    szContent = "<Sender>Trừng Huệ<Sender>Gửi các đệ tử nhập thất:\n\n    Sau nhiều tháng khảo sát, các vị đệ tử nhập thất đều đã chính thức trở thành đệ tử Thiếu Lâm của ta, được truyền thụ Phật pháp vô thượng và võ học tinh thâm của Thiếu Lâm.\n\n    Võ học của bản phái dùng để cường thân kiện thể, trừ ma vệ đạo. Bất kể là đệ tử xuất gia hay đệ tử tục gia đều phải ghi nhớ giới lệnh, không được giết người bừa bãi, không được có lòng hiếu thắng, không được tùy tiện truyền thụ võ học bản môn cho người khác, càng không được dùng võ học bản môn làm điều sai trái, gây họa cho võ lâm. Nếu có ai vi phạm, nhất định sẽ bị trừng trị nghiêm khắc theo môn quy Thiếu Lâm.\n\n     <color=green> Bộ tâm pháp nhập môn này, mỗi đệ tử nhập thất đều có một bản, có thể cùng nhau tham khảo nghiên cứu, hỗ trợ cùng tiến bộ. Chớ để tâm ma nảy sinh, tham công liều lĩnh, hoặc là lén lút luyện tập, giải sai kinh văn, dẫn đến tẩu hỏa nhập ma, hối hận thì đã muộn!\n\n<color>",
  },
  [Env.FACTION_ID_TIANWANG] = {
    szTitle = "Mật Lệnh Về Bang", --Thiên Vương
    szContent = "<Sender>Quý Thúc Ban<Sender>    Ngươi gia nhập bản bang cũng đã được một thời gian, trong khoảng thời gian này, bản bang đã nhiều lần cử người ngầm điều tra hành tung của ngươi, đối với biểu hiện của ngươi, các trưởng lão trong bang đều hết lời khen ngợi. Vì vậy, <color=green>bản bang quyết định từ hôm nay chính thức thu nhận ngươi vào Thiên Vương, và truyền cho ngươi một số võ công tương đối sâu sắc. Một là để giúp ngươi hành tẩu giang hồ; hai là để sau này gặp phải kẻ địch mạnh cũng không làm mất uy phong của Thiên Vương Bang ta. Bộ công pháp này là tâm pháp nhập môn của võ học thượng thừa của Thiên Vương Bang ta, ngươi phải ghi nhớ luyện tập chăm chỉ, không được lơ là, để không bị tụt hậu so với các đồng môn mới gia nhập khác.<color>\n\n   Ngoài ra, chưởng môn nhân Dương Anh sắp trở về bang. Bản bang có được uy danh như ngày hôm nay đều nhờ vào tâm huyết của bang chủ, việc nghênh đón bang chủ là đại sự hàng đầu của bản bang trong những năm gần đây, đệ tử bản bang dù ở đâu cũng phải trở về bang, đích thân nghênh đón bang chủ.\n\n    Lúc này còn một thời gian nữa bang chủ mới về bang, đệ tử bản bang có thể thong thả trở về sau khi giải quyết xong mọi việc trong tay, không cần vội vàng.\n\n",
  },
  [Env.FACTION_ID_TANGMEN] = {
    szTitle = "Thư Tay của Đường Hạc", --(Đường Môn)
    szContent = "<Sender>Đường Hạc<Sender>     Đường Môn từ trước đến nay không thu nhận đệ tử không mang họ Đường, chắc hẳn ngươi cũng biết rõ điều này. Ngày đó nể tình ngươi là hậu duệ của nghĩa quân, lại có Bạch Thu Lâm hết lòng tiến cử mới thu nhận ngươi vào môn hạ, để quan sát.\n\n    Nay ngươi vừa có thể hòa thuận với các đệ tử Đường Môn, vừa có thể chuyên tâm rèn luyện, tự mình thực hành, thực sự là điều mà các đệ tử Đường Môn ta không bằng. Vì vậy, <color=green>bản môn quyết định truyền thụ cho ngươi công pháp nhập môn của tuyệt kỹ Đường Môn, ngươi phải chăm chỉ luyện tập, nếu có chỗ nào không hiểu, có thể hỏi các vị trưởng lão.\n\n    Bản môn nghiêm cấm đệ tử tự ý truyền thụ võ học, ngay cả đệ tử họ Đường cũng vậy, ngươi phải ghi nhớ, để tránh vô tình phạm phải.\n\n<color>",
  },
  [Env.FACTION_ID_WUDU] = {
    szTitle = "Ngũ Độc Thánh Lệnh", --(Ngũ Độc)
    szContent = "<Sender>Hồ Hiến Cơ<Sender>Bản giáo bị triều đình và võ lâm hợp lực truy sát, phải trốn vào vùng đất man di này, đã được vài năm. Sự ẩn náu và chờ đợi trong vài năm này đã khiến cho giáo chúng bản giáo gần như tuyệt vọng. May mà giáo chủ hồng phúc tề thiên, thánh dung quảng trí, đã mưu tính cho bản giáo kế sách vươn lên, thành công sắp đến rồi.\n\n     Vào giáo ta, phải nghe lệnh giáo chủ, xả thân bảo vệ giáo, nếu có ai chống lại, sẽ bị rắn kiến cắn tim, vạn kiếp bất phục, lời này các ngươi phải ghi nhớ kỹ, để tránh sau này tự hủy hoại tiền đồ.\n\n    <color=green>Việc hưng giáo đang cấp bách, cũng chính vì vậy mà các đệ tử mới gia nhập mới được hưởng thánh ân, được ban cho tâm pháp nhập môn của độc công vô thượng của bản giáo, các ngươi phải chuyên tâm khổ luyện, để chuẩn bị cho việc bảo vệ giáo sau này.<color>Ngoài ra, Thiên Vương Bang và bản giáo thù sâu như biển, Dương Anh lão yêu bà đó càng đáng hận. Gần đây nghe tin Dương Anh trở lại Thiên Vương, đệ tử bản giáo phải điều tra khắp nơi, chú ý mọi hành động của Thiên Vương Bang, nếu có dị tượng, phải báo cáo sớm.\n\n                       \n",
  },

  [Env.FACTION_ID_EMEI] = {
    szTitle = "Nga Mi Giới Thư", -- (Nga Mi)
    szContent = "<Sender>Vô Niệm Sư Thái<Sender>Đệ tử bản phái đều do Phật Tổ dẫn lối mới được cùng tồn tại trong một phái, thực sự là duyên phận tu từ kiếp trước, các đệ tử trong môn phải kính yêu nhau, hỗ trợ nhau cùng tiến bộ, cùng tu đại nghiệp Phật môn.\n\n    Võ công của bản phái dùng để hộ thân cho đệ tử trong môn, nếu có kẻ dám cậy tài khinh người, phẩm hạnh không đoan chính, sẽ bị thu hồi võ công, trục xuất khỏi sư môn, vĩnh viễn không được ghi nhận lại.\n\n     Đệ tử bản phái sau khi nhập phái, sẽ được truyền thụ võ học tùy theo tư chất và tiến bộ. <color=green>Nay chưởng môn đích thân ra lệnh truyền cho ngươi tâm pháp nhập môn của võ học thượng thừa, ngươi phải kiềm chế kiêu căng, nóng nảy, khi luyện võ, không quên Phật pháp, không quên từ bi, không quên chúng sinh khổ nạn, mới có thể thành chính quả.<color>\n\n    Con đường tu hành, không ngoài việc tự mình thực hành, tự mình cảm ngộ. Nếu có thời gian rảnh, có thể trở về sư môn, nghe chưởng môn dạy bảo, cũng sẽ được lợi ích sâu sắc.\n\n",
  },

  [Env.FACTION_ID_CUIYAN] = {
    szTitle = "Tử Yên Dụ Lệnh", --(Thúy Yên Môn)
    szContent = "<Sender>Lệ Thu Thủy<Sender>Đệ tử Thúy Yên nghe lệnh:\n\n    Vài tháng sau, bản môn sẽ có đại sự xảy ra. <color=green>Để phòng sự việc đột biến, môn chủ đặc biệt cho phép các đệ tử trong môn bắt đầu tu luyện tâm pháp nhập môn của thần công bản môn. Các đệ tử phải chuyên tâm khổ luyện, để chuẩn bị cho việc bảo vệ bản môn sau này. Các đệ tử có thể cùng nhau nghiên cứu, cảm ngộ, cùng nhau khuyến khích, cùng nhau tiến bộ; không được tham lam học lén, giấu giếm, vội vàng liều lĩnh, dẫn đến tẩu hỏa nhập ma, hối hận thì đã muộn!<color>\n\n",
  },
  [Env.FACTION_ID_GAIBANG] = {
    szTitle = "Mật thư từ Lãnh Thu Vân", --(Cái Bang)
    szContent = "<Sender>Lãnh Thu Vân<Sender>Sau trận Thái Thạch Kê, uy phong của Cái Bang ta đã không còn như xưa, nghĩ đến Cái Bang ta vì chính nghĩa võ lâm, vì non sông xã tắc, tráng sĩ chặt tay là nghĩa cử cao cả và thảm liệt biết bao, nhưng vì trận này mà bang lực suy yếu, không còn sức để hiệu lệnh quần hùng như xưa, gánh vác trọng trách thiên hạ đệ nhất bang! Buồn thay! Than thay!\n\n    Lãnh mỗ chỉ là một thư sinh, được Thạch bang chủ không chê bai thu nhận vào môn hạ, cùng nhau tạo dựng sự nghiệp, phục hưng uy phong ngày xưa của Cái Bang ta, lòng thành惶恐. Tuy nhiên, hôm nay nhìn thấy những đệ tử mới gia nhập của bản bang, Lãnh mỗ không còn惶恐, và tin chắc rằng bản bang dưới sự lãnh đạo của Thạch bang chủ, cùng với sự nỗ lực chung của các vị huynh đệ, việc phục hưng Cái Bang sắp đến rồi.\n\n    <color=green>Kèm theo thư là tâm pháp nhập môn của võ học thượng thừa của bản bang, ngươi phải chăm chỉ luyện tập, không được lơ là, sau này sẽ xem xét tiến bộ của ngươi để thăng cấp túi, ghi nhớ! Ghi nhớ!<color>\n\n    Ngoài ra nghe tin bang chủ Thiên Vương Bang Dương Anh sắp trở về Thiên Vương, người này là một nữ kiệt xuất, kiến thức cao xa, võ nghệ siêu phàm, nếu được bà ta chỉ điểm một hai, chắc chắn sẽ được lợi cả đời. Nếu ngươi không có việc gì quan trọng, nhất định phải đến Thiên Vương Bang, để chờ đợi cơ duyên.\n\n",
  },
  [Env.FACTION_ID_TIANREN] = {
    szTitle = "Giáo Chủ Thân Dụ", --(Thiên Nhẫn)
    szContent = "<Sender>Hoàn Nhan Tương<Sender>Các vị huynh đệ nghĩ đến Thiên Nhẫn giáo ta, cũng đã nhiều lần lập công lao hiển hách cho triều đình, nhưng vì giáo chủ tiền nhiệm chỉ huy không hiệu quả mà dẫn đến thảm bại ở Thái Thạch Kê, danh tiếng nhiều năm trôi theo dòng nước, than thay! Tiếc thay!\n\n    Nay, Hoàn Nhan Tương nhờ ơn hoàng thượng, gánh vác trọng trách phục hưng uy phong Thiên Nhẫn, lại được các vị huynh đệ không chê bai, gia nhập Thiên Nhẫn ta, ấy là trời giúp Thiên Nhẫn ta phục hưng.\n\n    Nay bản giáo chủ quyết định thay đổi quy củ cũ trong giáo, ra lệnh cho các huynh đệ trong giáo đều có thể tu luyện thần công vô thượng của bản giáo, lấy võ giao hữu, chọn ra người xuất sắc nhất.\n\n  <color=green>Vật này là tâm pháp nhập môn của thần công, các vị huynh đệ có thể chuyên tâm lĩnh hội, sẽ có những tiến bộ riêng. Đợi đến khi có chút thành tựu, sẽ tặng tâm pháp trung cấp.<color>\n\n",
  },
  [Env.FACTION_ID_WUDANG] = {
    szTitle = "Thư Tay của Động Hư", --(Võ Đang)
    szContent = "<Sender>Động Hư Chân Nhân<Sender>Ngươi vào Võ Đang ta, chắc cũng đã được vài tháng rồi nhỉ? Trong vài tháng qua, mọi hành động của ngươi đều có đệ tử tục gia của bản phái báo cáo cho chưởng môn. Chưởng môn rất khen ngợi ngươi, đặc biệt cho phép ngươi bắt đầu tu hành võ học thượng thừa của bản môn sớm hơn.\n\n    <color=green>Kèm theo thư là yếu quyết nhập môn của võ học thượng thừa của bản môn, ngươi phải用心 lĩnh hội, chuyên tâm khổ luyện.<color>\n\n    Đệ tử Võ Đang hành tẩu giang hồ, nhất định phải hành động đoan chính, ngồi ngay ngắn, không sợ cường quyền, không bị cám dỗ, cầm kiếm hành hiệp, cứu đời giúp người, mới là bản sắc của đạo môn ta!\n\n",
  },
  [Env.FACTION_ID_KUNLUN] = {
    szTitle = "Thư Mời Đại Lễ Hợp Tông", --(Côn Lôn)
    szContent = "<Sender>Tạ Vũ Điền<Sender>Gửi các đệ tử Côn Lôn:\n    Phái Côn Lôn ta, từ sau Thán Tức Lão Nhân đã rơi vào nhiều năm nội đấu. Trong mười mấy năm qua, mỗi lần nội đấu đều khiến cho nguyên khí Côn Lôn ta bị tổn thương nặng nề, thực sự là bất hạnh của Côn Lôn, bất hạnh của đệ tử Côn Lôn.\n\n    Nay dưới sự chủ trì mạnh mẽ của chưởng môn nhân Tống Thu Thạch, phái Côn Lôn ta cuối cùng đã chấm dứt nhiều năm tranh chấp nội đấu, trở lại thống nhất.\n\n    Ngày 9 tháng 9, bản phái sẽ tổ chức đại lễ hợp tông, quy tụ các phái, các hệ phái rải rác về một môn. Xin mời các đệ tử Côn Lôn đang ở bên ngoài đến lúc đó trở về Côn Lôn, nhận phái quy tông, thống nhất Côn Lôn.\n\n    <color=green>Ngoài ra, chưởng môn nhân xét thấy võ học của đệ tử bản môn phức tạp, sư thừa từ nhiều nhà, khó phát huy hết uy lực; đặc biệt viết một bản tâm pháp võ học, xin các đệ tử trong môn khổ tâm nghiên cứu, nhất định có thể dung hợp chân khí rải rác và võ học tạp nham thành một thể, tăng đại uy lực. Sách này là bí mật của bản môn, không được tiết lộ ra ngoài, ghi nhớ! Ghi nhớ!<color>\n\n",
  },
  [Env.FACTION_ID_MINGJIAO] = {
    szTitle = "Thiện Mẫu Lệnh", --(Minh Giáo)
    szContent = "<Sender>Thiện Mẫu<Sender>Gửi các giáo chúng:\n	Vào giáo ta, tức là huynh đệ của ta, đều được hưởng sự bảo hộ của giáo quy bình đẳng, đều được nhận thánh lệnh khai thị của Tông chủ. Nay tà giáo bốn phương nổi lên, mê hoặc dân chúng; các đại môn phái lại coi bản giáo là dị đoan, âm mưu bất chính. Đây là do sự thịnh vượng của Thánh giáo, cũng là nguyên nhân tu hành của các huynh đệ. <color=red>Bản tôn phụng thánh dụ của Tông chủ truyền cho các huynh đệ pháp môn hộ thân, cần phải chăm chỉ luyện tập, không được lơ là, sớm ngày cùng nhau trở về thế giới Đại Quang Minh.<color>\n",
  },
  [Env.FACTION_ID_DALIDUANSHI] = {
    szTitle = "Đoàn Thị Thủ Dụ", --(Đại Lý Đoàn Thị)
    szContent = "<Sender>Đoàn Trí Hưng<Sender>Thư gửi các đệ tử:\n	Các ngươi vì ngưỡng mộ võ học Đoàn thị của ta mà đến đây cầu học, tuy nhập môn chưa lâu, cũng nên biết sự gian khổ của việc học nghệ. Bản vương truyền nghệ không phân biệt thân sơ, chỉ dựa vào sự tự giác tự ngộ của các ngươi. <color=red>Nay đặc biệt ban cho một cuốn mật tịch sư môn, các ngươi phải tham khảo kỹ lưỡng, tĩnh tâm lĩnh hội,<color> chớ phụ lòng thành toàn của bản vương.\n",
  },
  [Env.FACTION_ID_GUMU] = {
    szTitle = "Cổ Mộ Dụ Lệnh", --(Cổ Mộ)
    szContent = "<Sender>Lâm Yên Khanh<Sender>Thư gửi các đệ tử:\n	Thiên đạo có lúc đầy lúc vơi, nhân sự nhiều gian truân. Ở nơi gian nguy, không thể tự mình cẩn trọng mà có thể cứu giúp người khác, thiên hạ không có chuyện đó. Muốn biết tự cẩn trọng, phải loại bỏ nó từ những điều nhỏ nhặt. <color=red>Tiên sư truyền lại một cuốn cổ kinh, thấy nhỏ biết lớn, cẩn trọng khi ở một mình để dưỡng đức.<color> Thản đãng giữa trời đất.\n",
  },
}

Mail.tbZhongJiMiJiMail = {
  szTitle = "Tu Luyện Mật Tịch Trung Cấp",
  tbItem = { 18, 1, 1844, 1 },
  szContent = [[
[Bách Xích Kinh] là một bộ võ kinh do một vị thiền sư có đại trí tuệ ngộ ra từ kinh Phật, là một cuốn sách kỳ lạ mà các phái võ lâm đều muốn mượn đọc. Trong những năm gần đây, vì nghĩa quân làm nhiều việc thiện, vị thiền sư này đã tặng Bách Xích Kinh cho nghĩa quân ta, hy vọng người có duyên trong tương lai có thể ngộ ra được sự huyền diệu trong đó. Ngươi đã giúp nghĩa quân và bá tánh làm nhiều việc có ý nghĩa, hy vọng ngươi có thể ngộ ra được sự huyền diệu trong cuốn mật tịch này, để võ nghệ tiến thêm một bậc.
Chúc mừng hiệp sĩ đã đạt cấp 70, bây giờ bạn có thể nhận trực tiếp Mật Tịch Trung Cấp từ thư này, mỗi nhánh của môn phái hiện tại một cuốn. Cần lưu ý rằng, chỉ có thể nhận một lần, tức là sau khi đã nhận Mật Tịch Trung Cấp của môn phái hiện tại, sẽ không thể nhận thêm Mật Tịch Trung Cấp của các môn phái đa tu khác. Vì vậy, hãy lựa chọn cẩn thận.
Một cuốn mật tịch không thể tu luyện đầy đủ kỹ năng mật tịch, có thể dùng Du Long Cổ Tệ để đổi thêm Mật Tịch Trung Cấp tại Long Ngũ Thái Gia.
]],
}

Mail.tbGaoJiMiJiMail = {
  szTitle = "Tu Luyện Mật Tịch Cao Cấp",
  tbItem = { 18, 1, 1845, 1 },
  szContent = [[
Đạo của trời, bớt chỗ thừa mà bù chỗ thiếu, cho nên hư thắng thực, thiếu thắng thừa.
Tu vi võ công của ngươi đã dần đạt đến cảnh giới tốt đẹp, Thu Di đã chuẩn bị sẵn cho ngươi kỹ năng võ học mới - Mật Tịch Cao Cấp. Chuyên tâm nghiên cứu, nếu muốn thấu triệt hoàn toàn diệu pháp trong đó, còn có thể vào Du Long Các để tìm hiểu hư thực, luyện thành võ công trong mật tịch, hành tẩu giang hồ, bảo vệ mình cứu người!
Chúc mừng hiệp sĩ đã đạt cấp 100, bây giờ bạn có thể nhận trực tiếp Mật Tịch Cao Cấp từ thư này, mỗi nhánh của môn phái hiện tại một cuốn. Cần lưu ý rằng, chỉ có thể nhận một lần, tức là sau khi đã nhận Mật Tịch Cao Cấp của môn phái hiện tại, sẽ không thể nhận thêm Mật Tịch Cao Cấp của các môn phái đa tu khác. Vì vậy, hãy lựa chọn cẩn thận.
Một cuốn mật tịch không thể tu luyện đầy đủ kỹ năng mật tịch, có thể dùng Du Long Cổ Tệ để đổi thêm Mật Tịch Cao Cấp tại Long Ngũ Thái Gia.
]],
}

local szSignetMailTitle = "Chưởng Môn Truyền Dụ"
local szSignetMail = [[
Thư gửi các đệ tử:

   Võ học các phái ẩn chứa ngũ hành, tương khắc lẫn nhau; nếu gặp ngũ hành tương khắc của bản môn thì thật may mắn, nhưng không tránh khỏi gặp phải cao thủ khắc chế ngũ hành của bản môn, chuốc lấy thất bại thảm hại. Nay đặc biệt ban cho các ngươi một "Ngũ Hành Ấn", đeo vật này có thể giải quyết nỗi lo tương sinh tương khắc. Vật này có hai công dụng kỳ diệu, nếu gặp ngũ hành tương khắc của bản môn, có thể làm cho uy lực võ học bản môn tăng vọt; nếu gặp khắc tinh của bản môn, lại có thể làm cho đệ tử bản môn ít bị tổn thương hơn, được may mắn sống sót.

   Các đệ tử được ban vật này, phải sử dụng cẩn thận, không được cậy nghĩa làm ác, gây hại cho sư môn.

                   Chưởng Môn Thủ Dụ
]]

local szYuanXiao09Mail = [[
<color=red>“Mừng Tết Nguyên Tiêu, hoạt động tri ân người chơi” chính thức khởi động<color>
<color=yellow>Thời gian hoạt động:<color>
  Sau bảo trì cập nhật ngày 6 tháng 2 ~ 0 giờ ngày 20 tháng 2
<color=yellow>Điều kiện cơ bản của hoạt động:<color>
  Nạp thẻ trong tháng 2 đạt 15 tệ hoặc Giang Hồ Uy Vọng của nhân vật đạt 200, cấp độ nhân vật trên 69.
<color=yellow>Hoạt động 1: Lễ Quan tặng quà Nguyên Tiêu<color>
  Trong thời gian hoạt động, mỗi nhân vật có thể đến Lễ Quan để nhận thưởng, phần thưởng có ba loại: Hộp Quà Tân Xuân, Bao Lì Xì Năm Mới, Túi Phúc Lớn Tân Xuân, mỗi loại có thể nhận một lần. Phần thưởng hậu hĩnh, không thể bỏ lỡ.
<color=yellow>Hoạt động 2: Lời chúc Tân Xuân<color>
  Trong thời gian hoạt động, mỗi nhân vật có 10 lần nhận được lời chúc của bạn bè. Người chơi cần tổ đội với người gửi lời chúc để đối thoại với Lễ Quan, sau khi thành công người được chúc phúc sẽ nhận được phần thưởng.
<color=yellow>Hoạt động 3: Quà của Yến Nhược Tuyết<color>
  Sau khi hoạt động năm mới kết thúc, 20 người chơi đứng đầu bảng xếp hạng vinh dự Phi Nhứ Nhai trong thời gian hoạt động có thể nhận được quà của Yến Nhược Tuyết.
	
Để biết thêm chi tiết, vui lòng hỏi Lễ Quan tại các Tân Thủ Thôn ở các thành phố lớn hoặc xem Cẩm Nang Trợ Giúp (F12).
]]

local szFuliMail = [[
  Người chơi thân mến, phúc lợi và đặc quyền của [Kiếm Hiệp Thế Giới] lại bắt đầu một đợt phát mới. <color=red>Phần thưởng độ năng động hàng ngày và phần thưởng độ năng động hàng tháng<color> miễn phí cố định cho phép bạn nhận thưởng không ngừng.
  Dưới đây là các cấp phúc lợi và đặc quyền, mức nạp thẻ cao hơn sẽ <color=red>tăng cường và giữ lại<color> tất cả các phúc lợi và đặc quyền của mức thấp hơn trước đó. Tất cả các phúc lợi và đặc quyền sẽ tự động được kích hoạt sau khi đạt điều kiện nạp thẻ, và có thể hưởng mỗi ngày cho đến cuối tháng.
  <color=red>Phúc lợi và đặc quyền cơ bản của hệ thống<color>
  1) Giới hạn mở Túi Phúc Hoàng Kim hàng ngày là 10 cái
  2) Thời gian tu luyện hàng ngày là 1.5 giờ
  3) Số lần cầu phúc hàng ngày là 1 lần
  <color=red>Phúc lợi và đặc quyền nạp 15 tệ<color>
  1) Phúc lợi và đặc quyền hệ thống
  2) Giới hạn mở Túi Phúc Hoàng Kim hàng ngày tăng thêm 10 cái
  3) Giang Hồ Uy Vọng hàng tuần nhận 10 điểm tại Lễ Quan
  4) Hàng ngày nhận 5 món ăn luyện cấp
  <color=red>Phúc lợi và đặc quyền nạp 50 tệ<color>
  1) Phúc lợi và đặc quyền hệ thống, 15 tệ
  2) Giang Hồ Uy Vọng hàng tuần nhận 20 điểm tại Lễ Quan
  3) Thời gian tu luyện hàng ngày tăng thêm 0.5 giờ
  4) Số lần cầu phúc tăng thêm 1 lần
  5) Càn Khôn Phù (10 lần) 1 cái (dịch chuyển đồng đội)
  6) Phù Dịch Chuyển Vô Hạn (30 ngày) 1 cái
  7) 4 đặc quyền lớn như mở từ xa sàn đấu giá, nền tảng nhiệm vụ, v.v.
  <color=red>Phúc lợi và đặc quyền nạp 100 tệ<color>
  1) Phúc lợi và đặc quyền hệ thống, 15 tệ, 50 tệ
  2) Mở Lò Luyện Huyền Tinh tùy thân để hợp Huyền Tinh
  3) Mở Rương Đồ Tùy Thân để cất và lấy vật phẩm
]]

local szHighbookMailTitle = "Tu Luyện Mật Tịch Cao Cấp"
local szHighbookMail = [[
Đạo của trời, bớt chỗ thừa mà bù chỗ thiếu, cho nên hư thắng thực, thiếu thắng thừa.
Tu vi võ công của ngươi đã dần đạt đến cảnh giới tốt đẹp, có thể đến chỗ Bạch Thu Lâm để tìm một cuốn Mật Tịch Cao Cấp, chuyên tâm nghiên cứu, nếu muốn thấu triệt hoàn toàn diệu pháp trong đó, còn có thể vào Du Long Các để tìm hiểu hư thực, luyện thành võ công trong mật tịch, hành tẩu giang hồ, bảo vệ mình cứu người!
Chúc mừng hiệp sĩ đã đạt cấp 100, bây giờ bạn có thể tìm Bạch Thu Lâm để nhận Mật Tịch Cao Cấp, mỗi nhánh của môn phái hiện tại một cuốn. Cần lưu ý rằng, chỉ có thể nhận một lần, tức là sau khi đã nhận Mật Tịch Cao Cấp của môn phái hiện tại, sẽ không thể nhận thêm Mật Tịch Cao Cấp của các môn phái đa tu khác. Vì vậy, hãy lựa chọn cẩn thận.
Một cuốn mật tịch không thể tu luyện đầy đủ kỹ năng mật tịch, có thể dùng Du Long Cổ Tệ để đổi thêm Mật Tịch Cao Cấp tại Long Ngũ Thái Gia.
]]

local szFightPowerMailTitle = "Mạnh? Mạnh hơn nữa!"
local szFightPowerMail = [[
Đường hẹp tương phùng dũng giả thắng!
Một hiệp sĩ thực thụ không chỉ cần dũng khí, mà còn phải có sức chiến đấu mạnh mẽ làm hậu thuẫn!
Nhấn <color=orange>“Y”<color> để xem <color=orange>sức chiến đấu<color> của bạn, cao thấp của nó sẽ ảnh hưởng đến sát thương bạn nhận được khi PK.
<color=orange>Xem thêm tại F12-Trợ giúp chi tiết-Sức chiến đấu<color>
]]

Mail.tbMailItem_Gumu_Horse = {
  [20] = {
    [1] = {
      szTitle = "[Kiếm Sơ] Lâm Yên Khanh thư gửi các đệ tử",
      szContent = "Phái Cổ Mộ không muốn dính líu đến giang hồ, nhưng thị phi khó lường, lại cuốn ta vào vòng tranh chấp giang hồ. Đã vào trần thế, tự nhiên không thể để người khác coi thường. Võ học phái Cổ Mộ lấy [Ngọc Nữ Tâm Kinh] làm thượng thừa, nhưng cũng sợ khi vận dụng nội lực, nhiệt khí tiêu tán gây tẩu hỏa nhập ma. Tặng ngươi Tuyết Sơn Bạch Lộc, có nó bầu bạn, kết hợp với pháp môn dưỡng sinh của bản phái, tự nhiên thân tâm thanh tịnh, giúp ích cho việc tu luyện.",
      [Env.SEX_MALE] = { 1, 12, 65, 1 },
      [Env.SEX_FEMALE] = { 1, 12, 65, 1 },
    },
    [2] = {
      szTitle = "[Châm Sơ] Lâm Yên Khanh thư gửi các đệ tử",
      szContent = "Phái Cổ Mộ không muốn dính líu đến giang hồ, nhưng thị phi khó lường, lại cuốn ta vào vòng tranh chấp giang hồ. Đã vào trần thế, tự nhiên không thể để người khác coi thường. Võ học phái Cổ Mộ lấy [Ngọc Nữ Tâm Kinh] làm thượng thừa, nhưng cũng sợ khi vận dụng nội lực, nhiệt khí tiêu tán gây tẩu hỏa nhập ma. Tặng ngươi Ngự Hồn Sa Lịch, dùng nó tương khắc, kết hợp với pháp môn dưỡng sinh của bản phái, tự nhiên thân tâm thanh tịnh, giúp ích cho việc tu luyện.",
      [Env.SEX_MALE] = { 1, 12, 66, 1 },
      [Env.SEX_FEMALE] = { 1, 12, 67, 1 },
    },
  },
  [50] = {
    [1] = {
      szTitle = "[Kiếm Trung] Lâm Yên Khanh thư gửi các đệ tử",
      szContent = "Phái Cổ Mộ không muốn dính líu đến giang hồ, nhưng thị phi khó lường, lại cuốn ta vào vòng tranh chấp giang hồ. Đã vào trần thế, tự nhiên không thể để người khác coi thường. Võ học phái Cổ Mộ lấy [Ngọc Nữ Tâm Kinh] làm thượng thừa, nhưng cũng sợ khi vận dụng nội lực, nhiệt khí tiêu tán gây tẩu hỏa nhập ma. Nay, ngươi học võ công Cổ Mộ đã được một thời gian, tặng ngươi Băng Nguyên Bạch Lộc, có nó bầu bạn, kết hợp với pháp môn dưỡng sinh của bản phái, tự nhiên thân tâm thanh tịnh, giúp ích cho việc tu luyện.",
      [Env.SEX_MALE] = { 1, 12, 65, 2 },
      [Env.SEX_FEMALE] = { 1, 12, 65, 2 },
    },
    [2] = {
      szTitle = "[Châm Trung] Lâm Yên Khanh thư gửi các đệ tử",
      szContent = "Phái Cổ Mộ không muốn dính líu đến giang hồ, nhưng thị phi khó lường, lại cuốn ta vào vòng tranh chấp giang hồ. Đã vào trần thế, tự nhiên không thể để người khác coi thường. Võ học phái Cổ Mộ lấy [Ngọc Nữ Tâm Kinh] làm thượng thừa, nhưng cũng sợ khi vận dụng nội lực, nhiệt khí tiêu tán gây tẩu hỏa nhập ma. Nay, ngươi học võ công Cổ Mộ đã được một thời gian, tặng ngươi Ngự Hồn Chi Thạch, dùng nó tương khắc, kết hợp với pháp môn dưỡng sinh của bản phái, tự nhiên thân tâm thanh tịnh, giúp ích cho việc tu luyện.",
      [Env.SEX_MALE] = { 1, 12, 66, 2 },
      [Env.SEX_FEMALE] = { 1, 12, 67, 2 },
    },
  },
  [100] = {
    [1] = {
      szTitle = "[Kiếm Cao] Lâm Yên Khanh thư gửi các đệ tử",
      szContent = "Phái Cổ Mộ không muốn dính líu đến giang hồ, nhưng thị phi khó lường, lại cuốn ta vào vòng tranh chấp giang hồ. Đã vào trần thế, tự nhiên không thể để người khác coi thường. Võ học phái Cổ Mộ lấy [Ngọc Nữ Tâm Kinh] làm thượng thừa, nhưng cũng sợ khi vận dụng nội lực, nhiệt khí tiêu tán gây tẩu hỏa nhập ma. Nay, ngươi học võ công Cổ Mộ đã đạt đến cảnh giới, có thể điều khiển Hàn Băng Bạch Lộc, có nó bầu bạn, kết hợp với pháp môn dưỡng sinh của bản phái, tự nhiên thân tâm thanh tịnh, giúp ích cho việc tu luyện.",
      [Env.SEX_MALE] = { 1, 12, 65, 3 },
      [Env.SEX_FEMALE] = { 1, 12, 65, 3 },
    },
    [2] = {
      szTitle = "[Châm Cao] Lâm Yên Khanh thư gửi các đệ tử",
      szContent = "Phái Cổ Mộ không muốn dính líu đến giang hồ, nhưng thị phi khó lường, lại cuốn ta vào vòng tranh chấp giang hồ. Đã vào trần thế, tự nhiên không thể để người khác coi thường. Võ học phái Cổ Mộ lấy [Ngọc Nữ Tâm Kinh] làm thượng thừa, nhưng cũng sợ khi vận dụng nội lực, nhiệt khí tiêu tán gây tẩu hỏa nhập ma. Nay, ngươi học võ công Cổ Mộ đã đạt đến cảnh giới, có thể điều khiển Ngự Hồn Chi Bội, dùng nó tương khắc, kết hợp với pháp môn dưỡng sinh của bản phái, tự nhiên thân tâm thanh tịnh, giúp ích cho việc tu luyện.",
      [Env.SEX_MALE] = { 1, 12, 66, 3 },
      [Env.SEX_FEMALE] = { 1, 12, 67, 3 },
    },
  },
}

function Mail:OnLevelUp(nLevel)
  --	if (nLevel == 20) then
  --		if(me.nFaction < 1 or me.nRouteId < 1) then
  --			Dbg:WriteLogEx(Dbg.LOG_ERROR, "Mail", "Lộ trình, môn phái không chính xác!");
  --			return;
  --		end
  --		local nMijiId = Npc.tbMenPaiNpc.tbFcts[me.nFaction].tbMiji[me.nRouteId];
  --
  --		if (not nMijiId) then
  --			Dbg:WriteLogEx(Dbg.LOG_ERROR, "Mail", "Lộ trình, môn phái không chính xác!");
  --			return;
  --		end
  --
  --		local tbMijiItem = { Item.EQUIP_GENERAL, 14, nMijiId, 1, -1 };
  --
  --
  --		local nRet = KPlayer.SendMail(me.szName, Mail.tbMail[me.nFaction].szTitle, Mail.tbMail[me.nFaction].szContent,
  --				0, 0, 1, unpack(tbMijiItem));
  --		if (nRet == 0) then
  --			Dbg:WriteLogEx(Dbg.LOG_ERROR, "Mail", "Gửi thư hệ thống thất bại!");
  --		end
  --	end

  if nLevel == 25 then
    local szMsg = [[    Chúc mừng hiệp sĩ đã đạt cấp 25, bạn hiện có thể thử thách phụ bản Tàng Bảo Đồ mới <color=yellow>[Bích Lạc Cốc]<color>! Bạn có thể nhấn phím “<color=yellow>K<color>” để mở cửa sổ lịch hoạt động, trong phần chức năng Tàng Bảo Đồ, chọn <color=yellow>nhận số lần thử thách Tàng Bảo Đồ của bạn<color>, mỗi ngày đều có thể nhận, đừng quên nhé! Sau đó, bạn có thể đến <color=yellow>Thôn Giang Tân, Trấn Vân Trung, Trấn Vĩnh Lạc<color>, tại <color=yellow>Quan Quân Nhu Tàng Bảo Đồ<color> để tra cứu cách sử dụng chức năng Tàng Bảo Đồ, và tổ đội báo danh tham gia <color=yellow>[Thử thách Bích Lạc Cốc]<color>!
Hãy sắp xếp hành trang của bạn, tập hợp đồng đội, cùng nhau khám phá bí mật của Bích Lạc Cốc!]]
    KPlayer.SendMail(me.szName, "Tàng Bảo Đồ mới mở, cấp 25 có thể thử thách!", szMsg)
  end

  if nLevel == 60 then
    -- Phát Ngũ Hành Ấn
    if me.nFaction < 1 then
      Dbg:WriteLogEx(Dbg.LOG_ERROR, "Mail", "Phát Ngũ Hành Ấn, môn phái không chính xác!")
      return
    end
    local tbSignet = { Item.EQUIP_GENERAL, 16, me.nFaction, 1, 0 }
    local nRet = KPlayer.SendMail(me.szName, szSignetMailTitle, szSignetMail, 0, 0, 1, unpack(tbSignet))
    if nRet == 0 then
      Dbg:WriteLogEx(Dbg.LOG_ERROR, "Mail", "Gửi thư hệ thống thất bại!")
    else
      me.SetTask(2023, 5, 1)
    end
  end

  if nLevel == 70 then
    local nRet = KPlayer.SendMail(me.szName, self.tbZhongJiMiJiMail.szTitle, self.tbZhongJiMiJiMail.szContent, 0, 0, 1, unpack(self.tbZhongJiMiJiMail.tbItem))
    if nRet == 0 then
      Dbg:WriteLogEx(Dbg.LOG_ERROR, "Mail", me.szName, "Gửi thư Mật Tịch Trung Cấp thất bại!")
    end
    me.SetTask(Npc.tbMenPaiNpc.nTaskGroup_Miji, Npc.tbMenPaiNpc.nTaskId_ZhongMiji, GetTime())
  end

  if nLevel == 100 then
    --KPlayer.SendMail(me.szName, szHighbookMailTitle, szHighbookMail);
    if Player.tbFightPower:IsFightPowerValid() == 1 then
      KPlayer.SendMail(me.szName, szFightPowerMailTitle, szFightPowerMail)
    end

    local nRet = KPlayer.SendMail(me.szName, self.tbGaoJiMiJiMail.szTitle, self.tbGaoJiMiJiMail.szContent, 0, 0, 1, unpack(self.tbGaoJiMiJiMail.tbItem))
    if nRet == 0 then
      Dbg:WriteLogEx(Dbg.LOG_ERROR, "Mail", me.szName, "Gửi thư Mật Tịch Cao Cấp thất bại!")
    end
    me.SetTask(Npc.tbMenPaiNpc.nTaskGroup_Miji, Npc.tbMenPaiNpc.nTaskId_GaoMiji, GetTime())
  end
  -- Thiết lập vị trí thập phân cho bảng xếp hạng cấp độ
  -- Máy chủ toàn cầu không áp dụng bảng xếp hạng cấp độ sức chiến đấu, máy chủ toàn cầu cũng không cần đồng bộ hóa tỷ lệ phần trăm kinh nghiệm
  if IsGlobalServer() == false then
    GCExecute({ "Player.tbFightPower:UpdatePlayerExp", me.nId, me.nLevel, me.GetExpPercent(0) })
  end

  self:SendGumuMail()
end

function Mail:SendGumuMail()
  if me.nFaction ~= Env.FACTION_ID_GUMU then
    return 0
  end

  local nLevel = me.nLevel
  local nRouteId = me.nRouteId
  if not self.tbMailItem_Gumu_Horse[nLevel] or not self.tbMailItem_Gumu_Horse[nLevel][nRouteId] then
    return 0
  end

  local tbHorse = self.tbMailItem_Gumu_Horse[nLevel][nRouteId][me.nSex]

  if not tbHorse then
    Dbg:WriteLogEx(Dbg.LOG_ERROR, "Mail", "Thư hệ thống phái Cổ Mộ không có vật phẩm", me.szName, me.nLevel, me.nFaction, me.nRouteId)
    return 0
  end

  local szMailContext = self.tbMailItem_Gumu_Horse[nLevel][nRouteId].szContent
  local szMailTitle = self.tbMailItem_Gumu_Horse[nLevel][nRouteId].szTitle
  local nRet = KPlayer.SendMail(me.szName, szMailTitle, szMailContext, 0, 0, 1, unpack(tbHorse))
  if nRet == 0 then
    Dbg:WriteLogEx(Dbg.LOG_ERROR, "Mail", "Gửi thư hệ thống phái Cổ Mộ thất bại!")
  end
  return 1
end

function Mail:_OnLogin()
  -- TODO Dùng cho bản thử nghiệm Tạm thời
  self:SendSystemMail()
end

function Mail:SendSystemMail()
  local bSend = me.GetTask(2023, 1) or 0
  local szTime = GetLocalDate("%y%m%d")

  -- Thư hoạt động Tết Nguyên Tiêu
  if szTime >= "090206" and szTime <= "090220" and me.GetTask(2023, 6) == 0 then
    KPlayer.SendMail(me.szName, "Hoạt động tri ân người chơi mừng Tết Nguyên Tiêu", szYuanXiao09Mail)
    me.SetTask(2023, 6, 1)
  end
  -- Phúc lợi Gửi một thư mỗi tháng

  local nMonth = tonumber(GetLocalDate("%m"))
  if me.GetTask(2023, 7) ~= nMonth then
    local nMoney = 12 * CoinExchange.__ExchangeRate_wellfare
    --KPlayer.SendMail(me.szName, "Phát phúc lợi lớn", string.format(szFuliMail, nMoney));
    KPlayer.SendMail(me.szName, "Hướng dẫn nhận phúc lợi và đặc quyền", szFuliMail)
    me.SetTask(2023, 7, nMonth)
  end

  bSend = me.GetTask(2023, 5) or 0
  if (0 == bSend) and me.nLevel >= 60 then
    -- Phát Ngũ Hành Ấn
    if me.nFaction < 1 then
      Dbg:WriteLogEx(Dbg.LOG_ERROR, "Mail", "Phát Ngũ Hành Ấn, môn phái không chính xác!")
      return
    end
    local tbSignet = { Item.EQUIP_GENERAL, 16, me.nFaction, 1, 0 }
    KPlayer.SendMail(me.szName, szSignetMailTitle, szSignetMail, 0, 0, 1, unpack(tbSignet))
    me.SetTask(2023, 5, 1)
  end
end

if MODULE_GAMESERVER then -- Dành riêng cho GS
  -- Đăng ký gọi lại sự kiện
  PlayerEvent:RegisterGlobal("OnLevelUp", Mail.OnLevelUp, Mail)
  PlayerEvent:RegisterGlobal("OnLoginOnly", Mail._OnLogin, Mail)
end
