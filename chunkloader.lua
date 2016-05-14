-- Robot programm to load the chunk on active redstone signal (eg. white signal from stargate programm)

component = require("component")
serverAddresse = "https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/"
versionTyp = "master/"

Pfad = serverAddresse .. versionTyp
os.execute("wget -f " .. Pfad .. "chunkloader.lua autorun.lua")

function main()
  print("Pruefe Komponenten\n")
  if component.isAvailable("chunkloader") then
    c = component.chunkloader
    chunkloaderstatus = true
    print("- ChunkLoader          ok")
  else
    chunkloaderstatus = false
    print("- ChunkLoader          fehlt")
  end
  if component.isAvailable("redstone") then
    r = component.getPrimary("redstone")
    redstonestatus = true
    print("- Redstone Card        ok")
  else
    print("- Redstone Card        fehlt")
  end
  if chunkloaderstatus == true and redstonestatus == true then
    loop()
  end
end

function loop()
  chunk = true
  aktiv = true
  while aktiv == true do
    if r.getBundledInput(1, 0) > 0 and chunk == true then
      c.setActive(true)
      print("Chunkloader An")
      chunk = false
    elseif r.getBundledInput(1, 0) == 0 and chunk == false then
      os.sleep(10)
      print("Chunkloader Aus")
      chunk = true
      c.setActive(false)
    end
  end
end

main()
