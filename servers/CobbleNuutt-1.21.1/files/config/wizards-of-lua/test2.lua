WizardsOfLua.setCommand( {
  id      = "cobblenuutt.genderswap.self",
  level   = 2,
  pattern = "genderswarp p:%player%",
  code    = [[
    local player = args.p
    spell:execute("/pokeeditother ",p," 1 gender=female")
  ]]
})