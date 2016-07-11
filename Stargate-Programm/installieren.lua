-- pastebin run -f wLK1gCKt
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm/tree/master/Stargate-Programm

print(versionTyp)

local versionTyp  = require("shell").parse(...)[1]
local fs          = require("filesystem")
local wget        = loadfile("/bin/wget.lua")
local move        = loadfile("/bin/mv.lua")

print(versionTyp)

if fs.exists("/stargate/Sicherungsdatei.lua") then
  local IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate = loadfile("/stargate/Sicherungsdatei.lua")()
else
  local Sprache = ""
  local installieren = false
  local control = "On"
  local autoUpdate = false
end

if fs.exists("/stargate/sprache/" .. Sprache .. ".lua") then
  local sprachen = loadfile("/stargate/sprache/" .. Sprache .. ".lua")()
end

local function Pfad(versionTyp)
  if versionTyp then
    return "https://raw.githubusercontent.com/Nex4rius/Stargate-Programm/" .. versionTyp .. "/Stargate-Programm/"
  else
    return "https://raw.githubusercontent.com/Nex4rius/Stargate-Programm/master/Stargate-Programm/"
  end
end

local function installieren(versionTyp)
  fs.makeDirectory("/update/stargate/sprache")
  local updateKomplett = false
  local update = {}
  print(versionTyp)
  update[1] = wget("-f", Pfad(versionTyp) .. "autorun.lua",                        "/update/autorun.lua")
  update[2] = wget("-f", Pfad(versionTyp) .. "stargate/check.lua",                 "/update/stargate/check.lua")
  update[3] = wget("-f", Pfad(versionTyp) .. "stargate/version.txt",               "/update/stargate/version.txt")
  update[4] = wget("-f", Pfad(versionTyp) .. "stargate/adressen.lua",              "/update/stargate/adressen.lua")
  update[5] = wget("-f", Pfad(versionTyp) .. "stargate/Sicherungsdatei.lua",       "/update/stargate/Sicherungsdatei.lua")
  update[6] = wget("-f", Pfad(versionTyp) .. "stargate/Kontrollprogramm.lua",      "/update/stargate/Kontrollprogramm.lua")
  update[7] = wget("-f", Pfad(versionTyp) .. "stargate/schreibSicherungsdatei.lua","/update/stargate/schreibSicherungsdatei.lua")
  update[8] = wget("-f", Pfad(versionTyp) .. "stargate/sprache/deutsch.lua",       "/update/stargate/sprache/deutsch.lua")
  update[9] = wget("-f", Pfad(versionTyp) .. "stargate/sprache/english.lua",       "/update/stargate/sprache/english.lua")
  update[10]= wget("-f", Pfad(versionTyp) .. "stargate/sprache/ersetzen.lua",      "/update/stargate/sprache/ersetzen.lua")
  for i = 1, 10 do
    if update[i] == true then
      updateKomplett = true
    else
      updateKomplett = false
      if sprachen then
        print(sprachen.fehlerName .. i)
      end
      f = io.open ("/autorun.lua", "w")
      f:write('-- pastebin run -f wLK1gCKt\n')
      f:write('-- von Nex4rius\n')
      f:write('-- https://github.com/Nex4rius/Stargate-Programm/tree/master/Stargate-Programm\n\n')
      f:write('local args = require("shell").parse(...)[1]\n\n')
      f:write('if type(args) == "string" then\n')
      f:write('  loadfile("/stargate/check.lua")(args)\n')
      f:write('else\n')
      f:write('  loadfile("/stargate/check.lua")()\n')
      f:write('end\n\n')
      f:close()
      os.sleep(5)
      break
    end
  end
  if updateKomplett then
    print("Update komplett")
    fs.makeDirectory("/stargate/sprache")
    move("-f", "/update/autorun.lua",                         "/autorun.lua")
    move("-f", "/update/stargate/check.lua",                  "/stargate/check.lua")
    move("-f", "/update/stargate/version.txt",                "/stargate/version.txt")
    if fs.exists("/stargate/adressen.lua") == false then
      move(    "/update/stargate/adressen.lua",               "/stargate/adressen.lua")
    end
    if fs.exists("/stargate/Sicherungsdatei.lua") == false then
      move(    "/update/stargate/Sicherungsdatei.lua",        "/stargate/Sicherungsdatei.lua")
    end
    move("-f", "/update/stargate/Kontrollprogramm.lua",       "/stargate/Kontrollprogramm.lua")
    move("-f", "/update/stargate/schreibSicherungsdatei.lua", "/stargate/schreibSicherungsdatei.lua")
    move("-f", "/update/stargate/sprache/deutsch.lua",        "/stargate/sprache/deutsch.lua")
    move("-f", "/update/stargate/sprache/english.lua",        "/stargate/sprache/english.lua")
    move("-f", "/update/stargate/sprache/ersetzen.lua",       "/stargate/sprache/ersetzen.lua")
    print()
    if versionTyp == "beta" then
      f = io.open ("/stargate/version.txt", "r")
      version = f:read()
      print(version)
      f:close()
      f = io.open ("/stargate/version.txt", "w")
      f:write(version .. " BETA")
      f:close()
    end
  end
  installieren = true
  loadfile("/stargate/schreibSicherungsdatei.lua")(IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate)
  loadfile("/bin/rm.lua")("-v", "/update")
  loadfile("/bin/rm.lua")("-v", "/installieren.lua")
  --loadfile("/autorun.lua")("no")
  --os.exit()
  require("computer").shutdown(true)
end

installieren(versionTyp)
