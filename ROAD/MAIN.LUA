----------------------------------------------
-- TUNNELS FOR DOS
--
-- Krzysztof Krystian Jankowski
-- 3.2022 P1X // http://bits.p1x.in
----------------------------------------------
local VER = 1

-- HISTORY
-- 02 // 
-- 01 // PoC
--
----------------------------------------------


-- VARIABLES
----------------------------------------------
local t = 0
local w = love.graphics.getWidth()
local h = love.graphics.getHeight()
local half_h = h*0.5
local half_w = w*0.5
local quater_w = w*0.25
local quater_h = h*0.25

local x = 0
local y = 0
local z = 150 
local horizon = 20
local phi = -1
local rotate_speed = 0.75
local move_speed = 30
local mx_speed = 0.15
local my_speed = 8
local deadzone = 32
local camera_height = 25

-- QUALITY SETTINGS
local max_lod = 0.8
local min_lod = 0.15
local lod = 0.5
local max_planes = 256
local first_step = 12
local min_step = 3
local vstep = 4
local fps = 15

local mx=0
local my=0
local last_mx = 0
local last_my = 0
local dmx = 0
local dmy = 0

-- GAME STATE
local state_intro = 0
local state_menu = 1
local state_game = 2
local state_end = 3
local state = state_intro


function love.load()
love.graphics.setBackgroundColor(100,100,100)
end


function drawHeader(title)
  love.graphics.setColor()
  love.graphics.print(title, 32,30)
  love.graphics.line(16,40,w-16,40)
end

function drawIntro()
  drawHeader("INTRO")
end

function drawOutro()
  drawHeader("OUTRO")
end

function drawMenu()
  love.graphics.setColor()
  love.graphics.print("TUNNELS Version/" .. VER, 32,30)
  love.graphics.line(16,40,w-16,40)
  love.graphics.print("Krzysztof Krystian Jankowski", 32,50)
 -- love.graphics.print("[O] [P] - Level of detail (LOD)", 32,h/2+10)
 -- love.graphics.print("[K] [L] - Vertical resolution skip", 32,h/2+20)
 -- love.graphics.print("[SPACE] - Demo mode", 32,h/2+30)
 -- love.graphics.print("[F] - Fly or Look mode", 32,h/2+40)
 -- love.graphics.print("[ESC] - Back to this screen", 32,h/2+50)
  love.graphics.setColor(255,255,255)
  love.graphics.rectangle("fill", 0,h-28,w,h)
  love.graphics.setColor(0,0,0)
  love.graphics.print("Press [SPACE] to start or [ESC] to quit", 8,h-18) 
end

function drawHorizon()
  love.graphics.setColor(65,191,221)
  love.graphics.rectangle("fill",0,0,w,horizon*0.35)
  love.graphics.setColor(147,191,221)
  love.graphics.rectangle("fill",0,horizon*0.35,w,horizon*0.75)
  love.graphics.setColor(201,191,221)
  love.graphics.rectangle("fill",0,horizon*0.75,w,half_h)
end

function drawGameFrame()
  p = 0
  step = 0.1
  plane_w=10
  plane_h=10
  max_planes = 80
  for plane=0,max_planes do
    new_x=( x + (math.sin((p*0.02)+t*.5)*(max_planes-plane))*math.sin(t*.1))
    new_y=( y + (math.sin((p*0.01)+t*.25)*(max_planes-plane))*math.sin(t*.05))
    
    screen_x=half_w+new_x-p
    screen_y=half_h+new_y+p*0.5
    if plane==0 then horizon=screen_y end
    plane_w=p*2
    plane_h=max_planes-plane
    c=p
    -- GROUND
    love.graphics.setColor(c*0.5,c*0.9,c*0.5)
    love.graphics.rectangle("fill",0,screen_y,w,plane_h)
    
    -- ASPHALT
    love.graphics.setColor(c,c,c)
    love.graphics.rectangle("fill",screen_x,screen_y,plane_w,plane_h)
    cc=math.min(c*2,255)
    love.graphics.setColor(cc,cc,cc)
    ww=0.2*plane
    love.graphics.rectangle("fill",screen_x,screen_y,ww,plane_h)
    love.graphics.rectangle("fill",screen_x+plane_w-ww,screen_y,ww,plane_h)
    
    -- ZEBRA
    if math.floor(p+t*10)%5~=0 then
     c = 250 
     love.graphics.setColor(c,c,c)
     love.graphics.rectangle("fill",screen_x+plane_w*0.5,screen_y,plane_w*.05,plane_h)
    end
    
    -- TREE
    if math.ceil(plane-t*10)%10==0 then
      love.graphics.setColor(math.min(32+cc,64),math.min(32+cc,128),30)
      ww= math.max(1, plane_w*0.1)
      hh = math.max(2,p*2)
      shift=plane_w*.2
      love.graphics.rectangle("fill",screen_x-shift,screen_y-hh*0.5,ww,hh)
      love.graphics.rectangle("fill",screen_x+shift+plane_w-ww,screen_y-hh*0.5,ww,hh)
    end
    
    -- CAR

 
       ww = half_w
       hh = 18
    love.graphics.setColor(220,30,30)
    love.graphics.rectangle("fill",
         half_w-ww*0.5, 
         h-hh,
         ww,hh)                

    love.graphics.setColor(20,20,20)
    love.graphics.rectangle("fill",
         half_w-ww*0.5+8, 
         h-hh+4,
         ww-16,hh-4)
    love.graphics.setColor(50,50,50)
    love.graphics.circle("fill",half_w-ww*.25,h-hh*0.75,18)

    step=step*1.1
    p=plane*step
  end
end

function drawGPS()
  getx=0
  gety=0
  xx = math.floor(getx)
  yy = math.floor(gety)
  zz = math.floor(z)
  love.graphics.print("GPS // "..xx.."x /"..yy.."y /"..zz.."z",8,8)
end

function drawGameHUD()
  love.graphics.print("FPS // "..fps, 8,h-18)

  --drawGPS()

  -- CROSSHAIR
  love.graphics.setColor(0,0,0)
  love.graphics.circle("line",half_w,half_h,6)
  love.graphics.setColor(255,255,255)
  love.graphics.point(half_w, half_h)
end

function love.draw()  
  if state==state_intro then
    drawIntro()
  end

  if state==state_menu then
    drawMenu()
  end

  if state==state_game then
    drawHorizon()
    drawGameFrame()
    drawGameHUD()
  end

  if state==state_end then
    drawOutro()
  end
end




function love.update(dt)
  -- TIMER AND FPS
  t=t+dt

  -- FPS
  if state>state_menu then
    fps_now = 1/dt
    fps_step = 0.25
    if fps_now>fps then fps = fps + fps_step end  
    if fps_now<fps then fps = fps - fps_step end
    
    --sinphi = math.sin(phi)
    --cosphi = math.cos(phi)
  end
  

  -- GAME
  if state==state_game then
    if love.keyboard.isDown("a") then
   x=x+dt*move_speed
    end
    if love.keyboard.isDown("d") then
   x=x-dt*move_speed
    end
if love.keyboard.isDown("w") then
   y=y+dt
    end
    if love.keyboard.isDown("s") then
   y=y-dt
    end
  end

end

function love.keypressed(key)
  if key == "escape" then
    if state > state_menu then
      state = state_menu
    else
      love.event.quit()
    end
  end
  if key == "space" then
    state = state + 1
    if state > state_end then state = state_intro end
  end
end
