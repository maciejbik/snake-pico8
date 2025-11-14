pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
menu=1
function _init()
	--walls
	wall={}
	init_wall()
	--snake
	first={x=3,y=7}
	dir={x=1,y=0} --prawo
	ndir={x=dir.x,y=dir.y}
	sn={}
	init_sn()
	tim=0
	igncol=0 --ignore collision
	--apples
	a={}
	add_apple()
	--bg
	bg={}
	for i=0,256 do
			add(bg,ceil(rnd(3))+3)
	end
end
-->8
function _draw()	
	bgi=0
	for i=0,16 do
		for j=0,16 do
			spr(bg[bgi],i*8,j*8)
			bgi+=1
		end
	end
	draw_wall()
	draw_apple()
	draw_sn()
	--print(dir.x,0,0)
	--print(dir.y,10,0)
	if menu==1 or menu==2 then
		cls(3)
		print("snake",52,63)
		print("press any",45,80)
		print("⬆️⬇️⬅️➡️",46,86)
	end
	if menu==2 then
		print("you win!",47,55,9)
	end
end
function _update()
	if menu==1 or menu==2 then
		if btn(⬅️) or
		btn(➡️) or btn(⬆️) or
		btn(⬇️) then
		menu=0
		end
	end
	if menu==0 then
	tim+=1
	if btn(⬅️) and dir.x!=1
	then ndir={x=-1,y=0} end
	if btn(➡️) and dir.x!=-1
	then ndir={x=1,y=0} end
	if btn(⬆️) and dir.y!=1
	then ndir={x=0,y=-1} end
	if btn(⬇️) and dir.y!=-1
	then ndir={x=0,y=1} end
	
	
	if tim%10==0 then
	dir.x=ndir.x
	dir.y=ndir.y
	move_sn() end
	
	detect_apple()
	detect_col()
	end
end
-->8
--wall
function draw_wall()
	for i in all(wall) do
			spr(1,i.x*8,i.y*8)
	end
end
function init_wall()
	for i=0,15 do
		for j=0,15 do
			if 
				i==0 or i==15 or
				j==0 or j==15 then
					add(wall,{x=i,y=j})	
			end	
		end	
	end
end
-->8
--snake
function init_sn()
	add(sn,{x=first.x,y=first.y})
	add(sn,{x=first.x-1,y=first.y})
	add(sn,{x=first.x-2,y=first.y})
end
function draw_sn()
	for i in all(sn) do
		spr(2,i.x*8,i.y*8)
	end
	if dir.y==0 then
		circ(first.x*8+4,first.y*8+1,0,7)
		circ(first.x*8+4,first.y*8+6,0,7)
	else
		circ(first.x*8+1,first.y*8+4,0,7)
		circ(first.x*8+6,first.y*8+4,0,7)
	end
end
function move_sn()
	local old={x=sn[1].x,y=sn[1].y}
	sn[1].x+=dir.x
	sn[1].y+=dir.y
	for i=2,count(sn) do
		local swp = sn[i]
		sn[i] = old
		old = swp
	end
	first=sn[1]
	igncol=0
end
function add_sn()
	sfx(0)
	add(sn,{x=first.x,y=first.y})
	first.x = sn[1].x
	first.y = sn[1].y
	igncol=1
	if count(sn)>=225 then
		sfx(1)
		menu=2
		_init()
	end
end
function detect_apple()
	for i in all(sn) do
		for j in all(a) do
			if i.x==j.x and i.y==j.y 
			then
				del(a,j)
				add_sn()
				add_apple()
				return true
			end
		end
	end
	return false
end
function detect_col()
	if first.x<=0 or first.x>=15
	or	first.y<=0 or first.y>=15
	then
		_init()
	end
	for i=2,count(sn) do
		if igncol!=1 and 
		sn[i].x==first.x and
		sn[i].y==first.y 
		then
			_init()
		end
	end
end

-->8
--apple
function add_apple()
	local ax
	local ay
	local bad=1
	while bad==1 do
		bad=0
		ax = flr(rnd(14))+1
		ay = flr(rnd(14))+1
		for i in all(snake) do
			if i.x==ax or i.y==ay then
				bad=1
			end
		end
	end
	add(a,{
	x=ax,
	y=ay})	
end
function draw_apple()
	for i in all(a) do
		spr(3,i.x*8,i.y*8)
	end
end
__gfx__
00000000011111100eeeeee000b00000333333333333333333333333000000000000000000000000000000000000000000000000000000000000000000000000
0000000011dddd11eeeeeeee0b0b0000333333333333333333333b33000000000000000000000000000000000000000000000000000000000000000000000000
007007001d1111d1eeeeeeee0003b0003b33333339333333333333b3000000000000000000000000000000000000000000000000000000000000000000000000
000770001d1111d1eeeeeeee00888800333333333333339333333333000000000000000000000000000000000000000000000000000000000000000000000000
000770001d1111d1eeeeeeee08878880333333b33333333333333333000000000000000000000000000000000000000000000000000000000000000000000000
007007001d1111d1eeeeeeee088888e033333b333333333333833333000000000000000000000000000000000000000000000000000000000000000000000000
0000000011dddd11eeeeeeee00888e00333333b33333333333333333000000000000000000000000000000000000000000000000000000000000000000000000
00000000011111100eeeeee000000000333333333333333333333333000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400002e05032000330500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c0000000000c0500e05010050110501305015050170501805021000180501a050180501a050180500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7924000023050000002305024050260500000023050000002405000000240502605021050000001a0502300023050000002305024050260500000037050340003405000000000000000032050000000000000000
