local component = require("component")
local term = require("term")
local event = require("event")
local c = require("computer")
local m = component.modem
local port = 70
local maxzeit = 15
local reichweite = 400
local zeit = maxzeit
local tank = {}
local tankalt, adresse, empfangen
tank[1] = {}

function check()
  tank, tankalt = {}, tank
  local i = 1
  for adresse, name in pairs(component.list("tank_controller")) do
    for side = 0, 5 do
      for a, b in pairs(component.proxy(adresse).getFluidInTank(side)) do
        if type(a) == "number" then
          local dazu = true
          local c
          for j, k in pairs(tank) do
            if b.name == k.name then
              dazu = false
              c = j
              break
            end
          end
          if dazu then
            tank[i] = {}
            tank[i].name = b.name
            tank[i].label = b.label
            tank[i].menge = b.amount
            tank[i].maxmenge = b.capacity
            i = i + 1
          else
            tank[c].menge = tank[c].menge + b.amount
            tank[c].maxmenge = tank[c].maxmenge + b.capacity
          end
        end
      end
    end
  end
  term.clear()
  for i in pairs(tank) do
    print(string.format("%s --- %s: %s/%s %.1f%%", tank[i].name, tank[i].label, tank[i].menge, tank[i].maxmenge, tank[i].maxmenge / tank[i].menge))
  end
  return anders(tank, tankalt), tank
end

function anders(tank, tankalt)
  for i in pairs(tank) do
    if type(tank[i]) == "table" and type(tankalt[i]) == "table" then
      if tank[i].menge ~= tankalt[i].menge then
        return true
      end
    else
      return true
    end
  end
  return false
end

function serialize(a)
  if type(a) == "table" then
    local ausgabe = ""
    for k in pairs(a) do
      ausgabe = string.format([[%s{name="%s", label="%s", menge="%s", maxmenge="%s"}, ]], ausgabe, a[k].name, a[k].label, a[k].menge, a[k].maxmenge)
    end
    return "{" .. ausgabe .. "}"
  end
end

function senden(warten, nachricht)
  if type(empfangen) == "table" then
    if empfangen[6] == "update" then
      adresse = empfangen[3]
      if type(empfangen[5]) == "number" then
        m.setStrength(empfangen[5])
      end
    end
  end
  if adresse then
    m.send(adresse, port, serialize(nachricht))
  else
    m.broadcast(port, serialize(nachricht))
  end
  return warten
end

function main()
  m.setStrength(reichweite)
  m.open(port)
  while true do
    zeit = maxzeit
    if senden(check()) then
      zeit = 1
    end
    os.sleep(zeit / 10)
    empfangen = {event.pull(zeit, "modem_message")}
  end
end

main()
