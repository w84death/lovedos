----------------------------------------------
-- Vertex Space implemented in LoveDOS (LUA)
--
-- Krzysztof Krystian Jankowski
-- 2.2022 P1X // http://bits.p1x.in
----------------------------------------------
local VER = 4

-- VARIABLES
----------------------------------------------
local t = 0
local w = love.graphics.getWidth()
local h = love.graphics.getHeight()
local half_h = h*0.5
local half_w = w*0.5
local quater_h = h*0.25
local quater_w = w*0.25

local heightmap = love.graphics.newImage('map2_h.png')
local colormap = love.graphics.newImage('map2_c.png')
local scale_height = 40

local x = -100
local y = 0
local z = 150 
local horizon = 20
local phi = -1
local rotate_speed = 0.75
local move_speed = 30
 
-- QUALITY SETTINGS
local max_planes = 140
local plane_step = 10
local min_lod = 0.75
local lod = 0.575
local vstep = 4
local fps = 15

-- GAME STATE
local state = 0

function love.load()
end

function love.draw()  
  renderTerrain()
end

function renderTerrain()
  if state==0 then
    love.graphics.setColor()
    love.graphics.print("P1X MSDOS DEMO Version/" .. VER, 32,30)
    love.graphics.line(16,40,w-16,40)
    love.graphics.print("Krzysztof Krystian Jankowski", 32,50)
    love.graphics.print("[O] [P] - Level of detail (LOD)", 32,h/2+10)
    love.graphics.print("[K] [L] - Vertical resolution skip", 32,h/2+20)
    love.graphics.print("[SPACE] - Change modes", 32,h/2+30)
    love.graphics.print("[ESC] - Back to this screen", 32,h/2+40)
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill", 0,h-28,w,h)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Press [SPACE] to start demo or [ESC] to quit", 8,h-18)	
  end

  if state==1 or state==2 then

    -- FAKE HORIZONT
    love.graphics.setColor(180,180,220)
    love.graphics.rectangle("fill",0,0,w,horizon*0.75)
    love.graphics.setColor(220,220,240)
    love.graphics.rectangle("fill",0,horizon*0.75,w,horizon*2)
    love.graphics.setColor(255,200,220)
    love.graphics.rectangle("fill",0,horizon*2,w,half_h)

    -- RENDER LOOP
    p = max_planes
    step = plane_step
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
      
        hmap = heightmap:getPixel(getx, gety)
        r, g, b = colormap:getPixel(getx, gety)

        h_screen = (z - hmap) / p * scale_height + horizon
    
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("fill",i,h_screen,vstep,quater_h)
        pleft_x = pleft_x+dx*vstep
        pleft_y = pleft_y+dy*vstep
      end
      p = p - step
      if (step < min_lod) then step = min_lod else step = step - lod end
    end

    if state==1 then
      love.graphics.setColor(255,255,255)
      love.graphics.print("DEMO // "..fps, 8,h-18)	
    end

    if state==2 then
      love.graphics.setColor(255,255,255)
      love.graphics.print("FLY // "..fps, 8,h-18)	
      
      love.graphics.print("LOD / "..lod,w-200,h-18)
      love.graphics.print("VSTEP / "..vstep,w-100,h-18)
      
    end
  end
end

function love.update(dt)
  -- TIMER AND FPS
  t=t+dt
  if state>0 then
    fps_now = 1/dt
    if fps_now>fps then fps = fps + 0.25 end  
    if fps_now<fps then fps = fps - 0.25 end
    
    sinphi = math.sin(phi)
    cosphi = math.cos(phi)
  end
  
-- DEMO
  if state==1 then
    phi = -math.sin(0.1*t)*2
    horizon = 20 +math.sin(0.5*t)*20
    z = 150 + (50+math.sin(0.5*t)*50)
    x = x - sinphi * move_speed * dt
    y = y - cosphi * move_speed * dt
  end

  -- FLY 
  if state==2 then
    if love.keyboard.isDown("a") then
     phi = phi + rotate_speed*dt
    end
    if love.keyboard.isDown("d") then
      phi = phi - rotate_speed*dt
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

    -- SETTINGS
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
end

function love.keypressed(key)
  if key == "escape" then
    if state > 0 then
      state = 0
    else
      love.event.quit()
    end
  end
  if key == "space" then
    state = state + 1
    if state > 2 then state = 1 end
  end
end
