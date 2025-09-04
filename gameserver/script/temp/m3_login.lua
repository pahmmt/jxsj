M3_Test.szHead = "<head:\\image\\icon\\npc\\portrait_default_female.spr>"
M3_Test.tbSelect = { { "Trở về mục giới thiệu", "M3_Test:Main" }, { "Kết thúc đối thoại", "M3_Test:Exit" } }

function M3_Test:Main()
  local nSex = me.nSex
  local szSex = ""

  if nSex == 0 then
    szSex = "Công tử"
  else
    szSex = "Nữ hiệp"
  end

  Dialog:Say(self.szHead .. "Điệp Phiêu Phiêu: Vị " .. szSex .. " này, hoan nghênh ngài đến với thế giới kiếm hiệp kỳ diệu này, bây giờ ngài muốn tìm hiểu điều gì?", {
    { "Làm sao để nhận trang bị", "M3_Test:ShowEquip" },
    { "Làm sao để nhận kỹ năng", "M3_Test:ShowSkill" },
    { "Làm sao để nhận nhiệm vụ", "M3_Test:ShowTask" },
    { "Làm sao để tổ đội", "M3_Test:ShowTeam" },
    { "Làm sao để tham gia lôi đài", "M3_Test:Pk" },
    { "Vậy ta đi chơi trước đây", "M3_Test:Exit" },
  })
end

function M3_Test:ShowEquip()
  Dialog:Say(M3_Test.szHead .. "Điệp Phiêu Phiêu: Online là nhận ngay Gói Quà Trang Bị Lớn: Mở túi đồ, nhấp chuột phải vào Gói Quà Lớn là có thể nhận 10 món trang bị cực phẩm do Phàm Tử tài trợ. Tất cả đều đã được kích hoạt đó nha!", M3_Test.tbSelect)
end

function M3_Test:ShowTask()
  Dialog:Say(M3_Test.szHead .. "Điệp Phiêu Phiêu: Ở trong Long Tuyền Thôn tìm Quý Thúc Ban, đối thoại với ông ấy là có thể bắt đầu một câu chuyện chính tuyến đầy thăng trầm!", M3_Test.tbSelect)
end

function M3_Test:ShowTeam()
  Dialog:Say(M3_Test.szHead .. 'Điệp Phiêu Phiêu: Nhấn "P" để mở giao diện tổ đội, có thể mời người chơi gần đó vào đội hoặc gia nhập đội của người chơi khác, còn có thể đăng thông tin tìm đội và chiêu mộ đồng đội, cũng có thể tổ đội liên server đó!', M3_Test.tbSelect)
end

function M3_Test:ShowSkill()
  Dialog:Say(M3_Test.szHead .. "Điệp Phiêu Phiêu: Khi nhân vật đạt cấp 10, tại chỗ của Đường Quân Vinh ở Long Tuyền Thôn, chỗ của Tăng Mù ở Tân Thủ Thôn và các NPC khác đều có thể chọn gia nhập môn phái. Sau khi vào phái, sẽ nhận được kỹ năng các hướng của môn phái đó, chọn hướng yêu thích để học kỹ năng. Hiện tại đã mở 10 môn phái, 26 hướng.", M3_Test.tbSelect)
end

function M3_Test:Pk()
  Dialog:Say(M3_Test.szHead .. "Điệp Phiêu Phiêu: 1. Tại Long Tuyền Thôn tạo nhân vật mới, thông qua đối thoại với Nha Dịch, dịch chuyển đến bản đồ Lâm An Phủ hoặc nhập trực tiếp lệnh GM: <enter> ?gm ds NewWorld(29,1780,3508)<enter><enter>" .. "2. Tổ đội với người chơi khác, đội chỉ được 2 người, sau đó đội trưởng đối thoại với Công Bình Tử trong bản đồ Lâm An Phủ, chọn thi đấu lôi đài, cần chọn số người thi đấu hai bên và sân đấu, sau đó có thể vào sân lôi đài để tỷ võ.", M3_Test.tbSelect)
end

function M3_Test:Exit() end
