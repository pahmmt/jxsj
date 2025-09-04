Require("\\script\\fightskill\\enchant\\enchant.lua")

local tb = {
  --中级秘籍：含沙射影
  hanshasheyingadd = {
    {
      RelatedSkillId = 64, --迷影纵
      magic = {
        skill_param1_v = {
          value1 = { SkillEnchant.OP_MUL, { { 1, 20 }, { 10, 50 }, { 12, 55 } } },
        },
      },
    },

    {
      RelatedSkillId = 72, --小李飞刀
      magic = {
        skill_attackradius = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 30 }, { 10, 80 }, { 12, 88 } } },
        },
        missile_range = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 1 }, { 10, 3 }, { 11, 3 } } },
          value3 = { SkillEnchant.OP_ADD, { { 1, 1 }, { 10, 3 }, { 11, 3 } } },
        },
      },
    },

    {
      RelatedSkillId = 69, --毒刺骨
      magic = {
        skill_mintimepercast_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -9 }, { 5, -18 }, { 10, -27 }, { 11, -27 } } },
        },
      },
    },

    {
      RelatedSkillId = 73, --缠身刺
      magic = {
        skill_mintimepercast_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -9 }, { 5, -18 }, { 10, -27 }, { 11, -27 } } },
        },
      },
    },

    {
      RelatedSkillId = 71, --勾魂阱
      magic = {
        skill_mintimepercast_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -9 }, { 5, -18 }, { 10, -27 }, { 11, -27 } } },
        },
      },
    },

    {
      RelatedSkillId = 263, --吸星阵
      magic = {
        skill_mintimepercast_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -9 }, { 5, -18 }, { 10, -27 }, { 11, -27 } } },
        },
      },
    },

    {
      RelatedSkillId = 74, --乱环击
      magic = {
        skill_mintimepercast_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -9 }, { 5, -18 }, { 10, -27 }, { 11, -27 } } },
        },
      },
    },
  },

  --中级秘籍：漫天花雨
  mantianhuayuadd = {
    {
      RelatedSkillId = 64, --迷影纵
      magic = {
        skill_param1_v = {
          value1 = { SkillEnchant.OP_MUL, { { 1, 5 }, { 10, 50 }, { 12, 55 } } },
        },
        skill_mintimepercastonhorse_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -9 }, { 10, -2 * 18 }, { 11, -2 * 18 } } },
        },
      },
    },

    --[[
		{
			RelatedSkillId = 266,--断筋刃
			magic = 
			{
				missile_speed_v = 
				{
					value1 = {SkillEnchant.OP_ADD, {{1,6}, {10, 15}, {11, 15}}},
				},
				skill_missilenum_v = 
				{
					value1 = {SkillEnchant.OP_ADD, {{1,2}, {4,2}, {5,4},{10, 4}}},
				},
				skill_mintimepercast_v = 
				{
					value1 = {SkillEnchant.OP_ADD, {{1,-18}, {10, -18*5}, {12, -18*5.5}}},
				},
				skill_mintimepercastonhorse_v = 
				{
					value1 = {SkillEnchant.OP_ADD, {{1,-18}, {10, -18*5}, {12, -18*5.5}}},
				},
			},
		},
		
		{
			RelatedSkillId = 63,
			magic = 
			{
				missile_speed_v = 
				{
					value1 = {SkillEnchant.OP_ADD, {{1,4}, {10, 10}, {11, 11}}},
				},
				missile_range = 
				{
					value1 = {SkillEnchant.OP_ADD,  {{1,1}, {10, 1}}},
					value3 = {SkillEnchant.OP_ADD,  {{1,1}, {10, 1}}},
				},
			},
		},]]
  },

  --机关秘术
  jiguanmishuadd = {
    {
      RelatedSkillId = 69, --毒刺骨
      magic = {
        skill_maxmissile = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 1 }, { 6, 2 }, { 10, 2 }, { 11, 2 } } },
        },
        missile_lifetime_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 10 * 18 }, { 10, 20 * 18 }, { 12, 22 * 18 } } },
        },
      },
    },
    {
      RelatedSkillId = 71, --勾魂阱
      magic = {
        skill_maxmissile = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 0 }, { 2, 1 }, { 7, 2 }, { 10, 2 }, { 11, 2 } } },
        },
        missile_lifetime_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 0 * 18 }, { 2, 10 * 18 }, { 10, 20 * 18 }, { 12, 22 * 18 } } },
        },
      },
    },
    {
      RelatedSkillId = 883, --勾魂阱子
      magic = {
        skill_maxmissile = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 0 }, { 2, 1 }, { 7, 2 }, { 10, 2 }, { 11, 2 } } },
        },
      },
    },
    {
      RelatedSkillId = 263, --吸星阵
      magic = {
        skill_maxmissile = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 0 }, { 2, 0 }, { 3, 1 }, { 8, 2 }, { 10, 2 }, { 11, 2 } } },
        },
        missile_lifetime_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 0 * 18 }, { 2, 0 * 18 }, { 3, 10 * 18 }, { 10, 20 * 18 }, { 12, 22 * 18 } } },
        },
      },
    },
    {
      RelatedSkillId = 73, --缠身刺
      magic = {
        skill_maxmissile = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 0 }, { 3, 0 }, { 4, 1 }, { 9, 2 }, { 10, 2 }, { 11, 2 } } },
        },
        missile_lifetime_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 0 * 18 }, { 3, 0 * 18 }, { 4, 10 * 18 }, { 10, 20 * 18 }, { 12, 22 * 18 } } },
        },
      },
    },
    {
      RelatedSkillId = 74, --乱环击
      magic = {
        skill_maxmissile = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 0 }, { 4, 0 }, { 5, 1 }, { 10, 2 }, { 11, 2 } } },
        },
        missile_lifetime_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 0 * 18 }, { 4, 0 * 18 }, { 5, 10 * 18 }, { 10, 20 * 18 }, { 12, 22 * 18 } } },
        },
      },
    },
  },
  --陷阱120
  xianjing120add = {
    {
      RelatedSkillId = 64,
      magic = {
        skill_param1_v = {
          value1 = { SkillEnchant.OP_MUL, { { 1, 50 }, { 10, 50 } } },
        },
        skill_mintimepercast_v = {
          value1 = { SkillEnchant.OP_MUL, { { 1, -90 }, { 10, -90 } } },
        },
      },
    },
  },
}

SkillEnchant:AddBooksInfo(tb)
