--wall {x=<n>, y=<n>, dir=<'v'|'h'>, len=<n>}
--gate {x=<n>, y=<n>, dir=<'v'|'h'>, len=<n>}
--turret {x=<n>, y=<n>, direction=<n*pi>, hx=<n>, hy=<n>, hw=<n>, hh=<n>}
--human {x=<n>, y=<n>}

-- Turret room 1
turret {x=19, y=15, dir=  math.pi/2, hx=17, hy=18, hw=6, hh=1}
turret {x=13, y=21, dir=  math.pi/4, hx=16, hy=19, hw=1, hh=7}
turret {x=19, y=28, dir=0*math.pi/2, hx=17, hy=26, hw=6, hh=1}

wall {x=14, y=16, dir='h', len=13}
wall {x=14, y=16, dir='v', len=13}
wall {x=14, y=29, dir='h', len=13}
wall {x=27, y=16, dir='v', len=5}
wall {x=27, y=24, dir='v', len=5}

-- Turret room 2
turret {x=63, y=15, dir=  math.pi/2, hx=61, hy=18, hw=6, hh=1}
turret {x=69, y=21, dir=  math.pi,   hx=67, hy=19, hw=1, hh=7}
turret {x=63, y=28, dir=0*math.pi/2, hx=61, hy=26, hw=6, hh=1}

wall {x=57, y=16, dir='h', len=13}
wall {x=70, y=16, dir='v', len=13}
wall {x=57, y=29, dir='h', len=13}
wall {x=57, y=16, dir='v', len=5}
wall {x=57, y=24, dir='v', len=5}

-- Central room
wall {x=30, y=6,  dir='h', len=8}
wall {x=46, y=6,  dir='h', len=8}
wall {x=30, y=40, dir='h', len=8}
wall {x=46, y=40, dir='h', len=8}
wall {x=30, y=6,  dir='v', len=15}
wall {x=30, y=24, dir='v', len=16}
wall {x=54, y=6,  dir='v', len=15}
wall {x=54, y=24, dir='v', len=16}

-- Side corridors
wall {x=27, y=21, dir='h', len=3}
wall {x=27, y=24, dir='h', len=3}
wall {x=54, y=21, dir='h', len=3}
wall {x=54, y=24, dir='h', len=3}

-- Gates
gate {x=28, y=21, dir='v', len=3}
gate {x=56, y=21, dir='v', len=3}
gate {x=38, y=6,  dir='h', len=8}
gate {x=38, y=40, dir='h', len=8}

-- Starting humans
human {x=38, y=19}
human {x=38, y=22}
human {x=38, y=24}
human {x=38, y=27}
human {x=46, y=19}
human {x=46, y=22}
human {x=46, y=24}
human {x=46, y=27}
