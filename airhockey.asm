.data
  width_lower_bound: 2
  width_upper_bound: 158
  height_lower_bound: 4
  height_upper_bound: 138

.text
  sys fbreset
  mov fp sp
  jal main

render_padding:
  li a0 0       # col/width
  li a1 0       # row/height
  li a2 2     # width
  li a3 144     # height
  sys fbrect   # draw
  
  li a0 158       
  li a1 0        
  sys fbrect 

  ret

main:
  li t0 69

  loop:
    sys joystick
    mov t2 rv

    mov t3 t2
    andi t3 0b0000_0001 # press 's' to terminate
    jz l1
      sys exit
    l1:

    mov t3 t2
    andi t3 0b1000_0000 # up
    jz l1
      # todo start
    l1:

    mov t3 t2
    andi t3 0b0100_0000 # down
    jz l2
      # todo pause
    l2:

    mov t3 t2
    andi t3 0b0010_0000 # left
    jz l3
      li t4 2
      lte t0 t4
      jnz loop
      dec t0 2
    l3:

    mov t3 t2
    andi t3 0b0001_0000 # right
    jz l4
      li t4 138
      gte t0 t4
      jnz loop
      inc t0 2
    l4:

    sys fbreset
    mov a0 t0   # paddle
    li a1 140
    li a2 20     
    li a3 2     
    sys fbrect  
    push a0 
    jal render_padding
    pop t0 
    sys fbflush

    li a0 25    # adjust paddle speed
    sys sleep    

    j loop       