sleep(1)

WizardsOfLua.setCommand( {
  id      = "gender.swap.self",
  level   = 2,
  pattern = "genderswap n:%s",
  code    = [[
    local player = spell.owner
    local name = args.n
    local gender = player:evaluate("%cobblemon:party_gender 1%") == "Male"
      if gender then
        print(gender)
    end
  ]]
})

sleep(1)