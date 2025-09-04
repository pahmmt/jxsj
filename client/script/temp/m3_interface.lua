local m3_interface_test = Npc:GetClass("m3_test")

local m3_test = m3_interface_test

function m3_test:OnDialog()
  Dialog:Say("<pic:\\image\\ui\\temp\\say.spr><head:\\image\\icon\\npc\\portrait_default_female.spr>[Diện Đàm Diễn Thị]<enter><enter>Ngươi biết không, bên chân núi phía Tây của thôn có một loại hoa gọi là Hồng Ứng Tử, chỉ nở vào giờ Mão sáng ngày mồng 3 mỗi tháng, rồi lập tức tàn. Hiện tại, việc ngươi cần làm là đi hái cho ta ba đóa Hồng Ứng Tử, còn cách tính giờ thì có thể hỏi tiên sinh đoán mệnh trong thôn.<enter><enter>Ngươi chỉ cần biết việc này với ta rất trọng yếu, những chuyện khác ta không muốn nói nhiều, đi đi.", {
    { "Yên tâm, ta đi ngay", m3_test.exit },
    { "Ta muốn xem nhiệm vụ khác", m3_test.task },
    { "Ta muốn biết một số tin tức quanh đây", m3_test.exit },
    { "Tối nay có thể cùng nhau dùng bữa không?", m3_test.exit },
    { "Kết thúc đối thoại", m3_test.exit },
  })
end

function m3_test:exit() end
