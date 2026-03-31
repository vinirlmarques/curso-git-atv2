local goblinConfig = {
  spawnName = "goblin_knife",
  name = "Goblin",
  race = "blood",
  tags = { "goblin", "goblin_knife", "goblinmob", "goblins" },
  lookType = 58,
  groupId = "goblins",

  speed = 300,
  healthFactor = 1,
  weakFromPower = 680,

  colorMapBaseName = "goblin",
  randomColorMapChance = 70,

  targetDistance = 1,

  walkSounds = 'regular',

  deathAnimation = 2,

  loot = {
    { itemId = 515 },
  },

  attacks = {
    { target = true, cooldown = 2000, chance = 100, subname = "basic", range = 1, script = "goblins/goblin_knife_basic.lua", attackPercent = 20 },
    { target = true, cooldown = 4000, chance = 50, subname = "special", range = 1, script = "goblins/goblin_knife_special.lua", attackPercent = 30 }
  }
}

function init()
  g_game.loadMonster(goblinConfig)
end
