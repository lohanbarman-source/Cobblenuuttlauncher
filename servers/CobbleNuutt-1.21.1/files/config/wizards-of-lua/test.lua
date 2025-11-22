local player = spell.owner
local genderStr = player:evaluate("%cobblemon:party_gender 1%") == "Male"
local pname = player.name

  if genderStr then
    print("/gsmale "..pname)
end