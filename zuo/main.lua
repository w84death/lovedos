----------------------------------------------
-- Vertex Space implemented in LoveDOS (LUA)
--
-- Krzysztof Krystian Jankowski
-- 2.2022 P1X // http://bits.p1x.in
----------------------------------------------
local VER = 0.3

-- VARIABLES
----------------------------------------------
local t = 0
local w = love.graphics.getWidth()
local h = love.graphics.getHeight()
local x = -100
local y = 0
local z = 150 
local phi = -1
local last_phi = 0
local camera_far = 140
local scale_height = 40
local horizon = 20
local half_h = h*0.5
local half_w = w*0.5
local quater_h = w*0.25
local state = 0
local map_h = love.graphics.newImage('map2_h.png')
local map_c = love.graphics.newImage('map2_c.png')
local min_step = 0.75
local lod = 0.575
local vstep = 4
local phi_speed = 0.75
local move_speed = 30
local fps = 15

function love.load()
end

function love.draw()  
  renderTerrain()
end

function renderTerrain()
  if state==0 then
    love.graphics.setColor()
    love.graphics.print("P1X MSDOS DEMO V/" .. VER, 32,h/2-30)
    love.graphics.line(16,h/2-20,160,h/2-20)
    love.graphics.print("[O]/[P] - Level of detail (LOD)", 32,h/2+10)
    love.graphics.print("[K]/[L] - Vertical resolution skip", 32,h/2+20)
    love.graphics.print("PRESS [SPACE] TO START", 32,h-20)	
  end

  if state==1 or state==2 then

  love.graphics.setColor(180,180,220)
  love.graphics.rectangle("fill",0,0,w,horizon*0.75)
  love.graphics.setColor(220,220,240)
  love.graphics.rectangle("fill",0,horizon*0.75,w,horizon*2)
  love.graphics.setColor(255,200,220)
  love.graphics.rectangle("fill",0,horizon*2,w,half_h)
  p = camera_far
  step = 10
  while p > 1 do

    pleft_x  = (-cosphi*p - sinphi*p)+x
    pleft_y  = ( sinphi*p - cosphi*p)+y
    pright_x = (cosphi*p - sinphi*p)+x
    pright_y = (-sinphi*p - cosphi*p)+y

    dx = (pright_x - pleft_x) / w
    dy = (pright_y - pleft_y) / w
    
    for i=0,w,vstep do
      getx=pleft_x%512
      gety=pleft_y%512
    
      hmap = map_h:getPixel(getx, gety)
      r, g, b = map_c:getPixel(getx, gety)

      h_screen = (z - hmap) / p * scale_height + horizon
	
      love.graphics.setColor(r, g, b)
      love.graphics.rectangle("fill",i,h_screen,vstep,quater_h)
      pleft_x = pleft_x+dx*vstep
      pleft_y = pleft_y+dy*vstep
    end
    p = p - step
    if (step < min_step) then step = min_step else step = step - lod end
  end

    if state==1 then
      love.graphics.setColor(255,255,255)
      love.graphics.print("DEMO // PRESS [SPACE] TO FLY!", 8,h-18)	
    end

    if state==2 then
      love.graphics.setColor(255,255,255)
      love.graphics.print("[WSAD] TO FLY, [SPACE] TO BACK, [ESC] TO QUIT", 8,h-18)	
    end

    --STATS
    if state==2 then
      love.graphics.setColor(0,0,0)
      love.graphics.print("FPS/"..fps,2,2)
      love.graphics.print("LOD/"..lod,2,12)
      love.graphics.print("VSTEP/"..vstep,2,22)
    end
  end
end

function love.update(dt)
  t=t+dt

  fps_now = 1/dt
  if fps_now>fps then fps = fps + 0.25 end  
  if fps_now<fps then fps = fps - 0.25 end

  sinphi = math.sin(phi)
  cosphi = math.cos(phi)

  if love.keyboard.isDown("p") then
    lod = lod + 0.01
  end
  if love.keyboard.isDown("o") then
    if lod > 0 then
      lod = lod - 0.01
    end
  end
  if love.keyboard.isDown("k") then
    if vstep>1 then
      vstep = vstep - 1 
    end
  end
  if love.keyboard.isDown("l") then
    if vstep < 16 then
      vstep = vstep + 1
    end
  end

-- DEMO
  if state==1 then
    phi = last_phi - math.sin(0.01*t)
    horizon = 20 +math.sin(0.5*t)*20
    z = 150 + (50+math.sin(0.5*t)*50)
    x = x - sinphi * move_speed * dt
    y = y - cosphi * move_speed * dt
  end

-- PLAYABLE  
  if state==2 then

    if love.keyboard.isDown("a") then
     phi = phi + phi_speed*dt
    end
    if love.keyboard.isDown("d") then
      phi = phi - phi_speed*dt
    end    

    cor=0
    if love.keyboard.isDown("s") then
      x = x + sinphi * move_speed * dt
      y = y + cosphi * move_speed * dt

    end
    if love.keyboard.isDown("w") then 
      x = x - sinphi * move_speed * dt
      y = y - cosphi * move_speed * dt
    end

  end

  if state > 2 then
    last_phi = phi
    state = 1
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "space" then
    state = state+1
  end
end
