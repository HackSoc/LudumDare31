--wall {x=<n>, y=<n>, dir=<'v'|'h'>, len=<n>}
--gate {x=<n>, y=<n>, dir=<'v'|'h'>, len=<n>}
--turret {x=<n>, y=<n>, direction=<n*pi>, hx=<n>, hy=<n>, hw=<n>, hh=<n>}
--human {x=<n>, y=<n>}

-- Turret room 1
turret {x=275, y=225, dir=  math.pi/2, hx=250, hy=275, hw=100, hh= 25}
turret {x=175, y=325, dir=  math.pi/4, hx=225, hy=300, hw= 25, hh=100}
turret {x=275, y=425, dir=3*math.pi/2, hx=250, hy=400, hw=100, hh= 25}

wall {x=200, y=250, dir='h', len=200}
wall {x=200, y=250, dir='v', len=200}
wall {x=200, y=450, dir='h', len=203}
wall {x=400, y=250, dir='v', len= 80}
wall {x=400, y=370, dir='v', len= 80}

-- Turret room 2
turret {x= 955, y=225, dir=  math.pi/2, hx= 930, hy=275, hw=100, hh= 25}
turret {x=1055, y=325, dir=  math.pi,   hx=1030, hy=300, hw= 25, hh=100}
turret {x= 955, y=425, dir=3*math.pi/2, hx= 930, hy=400, hw=100, hh= 25}

wall {x= 880, y=250, dir='h', len=200}
wall {x=1080, y=250, dir='v', len=200}
wall {x= 880, y=450, dir='h', len=203}
wall {x= 880, y=250, dir='v', len= 80}
wall {x= 880, y=370, dir='v', len= 80}

-- Central room
wall {x=450, y=100, dir='h', len=126}
wall {x=702, y=100, dir='h', len=126}
wall {x=450, y=620, dir='h', len=126}
wall {x=702, y=620, dir='h', len=126}
wall {x=450, y=100, dir='v', len=230}
wall {x=450, y=370, dir='v', len=250}
wall {x=825, y=100, dir='v', len=230}
wall {x=825, y=370, dir='v', len=250}

-- Side corridors
wall {x=400, y=330, dir='h', len=53}
wall {x=400, y=370, dir='h', len=53}
wall {x=825, y=330, dir='h', len=58}
wall {x=825, y=370, dir='h', len=56}

-- Gates
gate {x=425, y=330, dir='v', len= 40}
gate {x=855, y=330, dir='v', len= 40}
gate {x=576, y= 99, dir='h', len=126}
gate {x=576, y=619, dir='h', len=126}

-- Starting humans
human {x=576, y=290}
human {x=576, y=330}
human {x=576, y=370}
human {x=576, y=410}
human {x=702, y=290}
human {x=702, y=330}
human {x=702, y=370}
human {x=702, y=410}
