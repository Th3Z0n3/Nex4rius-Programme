local component = require("component")
local r = component.getPrimary("redstone")
local m = component.modem
local Richtung = 1
local run = true
local port = 1

function rot()
  print("rot")
  for i = 14, 10, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
  for i = 9, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function gelb()
  print("gelb")
  for i = 14, 4, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
  for i = 4, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function orange()
  print("orange")
  for i = 9, 14 do
    r.setBundledOutput(Richtung, i, 255)
  end
  for i = 8, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function gruen()
  print("grün")
  for i = 9, 5, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
  for i = 4, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
  for i = 14, 10, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function weiss()
  print("weiß")
  for i = 14, 0, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
end

function schwarz()
  print("schwarz")
  for i = 14, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function redstone()
  if r.getBundledInput(AusgangRichtung, 15) > 0 then
    run = false
    schwarz()
    return
  elseif iris == true then
    rot()
  elseif idc == true then
    gruen()
  elseif eingehend == true then
    orange()
  elseif verbunden == true then
    gruen()
  elseif notIdle == true
    gelb()
  else
    weiss()
  end
end

function dekodieren()
  if farbe == 0 then
    notIdle = zustand
  elseif farbe == 14 then
    eingehend = zustand
  elseif farbe == 4 then
    iris = zustand
  elseif farbe == 15 then
    idc = zustand
  elseif farbe == 13 then
    verbunden = zustand
  end
end

m.open(port)

while run do
  redstone()
  local _, _, _, _, _, farbe, zustand = event.pull("modem_message")
  dekodieren()
end
