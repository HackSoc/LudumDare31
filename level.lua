--wall {x=<n>, y=<n>, dir=<'v'|'h'>, len=<n>}
--gate {x=<n>, y=<n>, dir=<'v'|'h'>, len=<n>}
--turret {x=<n>, y=<n>, direction=<n*pi>, hx=<n>, hy=<n>, hw=<n>, hh=<n>}
--human {x=<n>, y=<n>}

-- Turret room 1
turret {x=22, y=7,  dir=math.pi/4,   hx=24, hy=9, hw=2, hh=2}
turret {x=22, y=20, dir=7*math.pi/4, hx=24, hy=18, hw=2, hh=2}

wall   {x=23, y=8, dir='h', len=7}
wall   {x=23, y=8, dir='v', len=5}
window {x=23, y=13, dir='v', len=3}
wall   {x=23, y=16, dir='v', len=5}
wall   {x=23, y=21, dir='h', len=7}
gate   {x=30, y=15, dir='v', len=3}


-- Turret room 2


turret {x=60, y=22, dir=3*math.pi/4,   hx=58, hy=24, hw=2, hh=2}
turret {x=60, y=35, dir=5*math.pi/4, hx=58, hy=33, hw=2, hh=2}

wall {x=54, y=23, dir='h', len=7}
wall {x=61, y=23, dir='v', len=13}
gate {x=54, y=26, dir='v', len=3}
wall {x=54, y=29, dir='v', len=4}
gate {x=54, y=33, dir='v', len=2}
wall {x=54, y=36, dir='h', len=7}


-- Central room
wall   {x=30, y=8,  dir='h', len=12}
wall   {x=30, y=8,  dir='v', len=1}
gate   {x=42, y=8,  dir='h', len=4}
gate   {x=30, y=9,  dir='v', len=2}
wall   {x=30, y=11, dir='v', len=4}
wall   {x=46, y=8,  dir='h', len=8}
wall   {x=30, y=36, dir='h', len=12}
gate   {x=42, y=36, dir='h', len=4}
wall   {x=46, y=36, dir='h', len=8}
wall   {x=30, y=18, dir='v', len=14}
window {x=30, y=32, dir='v', len=2}
wall   {x=30, y=34, dir='v', len=2}
wall   {x=54, y=8,  dir='v', len=18}
wall   {x=54, y=35, dir='v', len=1}

-- Interior walls
wall {x=30, y=12, dir='h', len=8}
wall {x=38, y=8,  dir='v', len=1}
gate {x=38, y=9,  dir='v', len=2}
wall {x=38, y=11, dir='v', len=1}
wall {x=38, y=12, dir='v', len=1}
gate {x=38, y=13, dir='v', len=2}
wall {x=38, y=15, dir='v', len=1}
wall {x=38, y=16, dir='h', len=6}
gate {x=44, y=16, dir='h', len=4}
wall {x=48, y=16, dir='h', len=6}

wall {x=30, y=22, dir='h', len=4}
gate {x=34, y=22, dir='h', len=2}
wall {x=36, y=22, dir='h', len=6}

wall {x=30, y=28, dir='h', len=8}
wall {x=38, y=28, dir='v', len=4}
gate {x=38, y=32, dir='v', len=2}
wall {x=38, y=34, dir='v', len=2}

wall {x=42, y=16, dir='v', len=2}
gate {x=42, y=18, dir='v', len=2}
wall {x=42, y=20, dir='v', len=4}
gate {x=42, y=24, dir='v', len=3}
wall {x=42, y=27, dir='v', len=4}

wall {x=38, y=31, dir='h', len=8}
gate {x=46, y=31, dir='h', len=3}
wall {x=49, y=31, dir='h', len=5}

-- Starting humans
human {x=44, y=24}
human {x=46, y=24}
human {x=48, y=24}
human {x=50, y=24}
human {x=44, y=26}
human {x=46, y=26}
human {x=48, y=26}
human {x=50, y=26}

-- features
helipad {x=48, y=17, hx=52, hy=17, hw=1, hh=3}
