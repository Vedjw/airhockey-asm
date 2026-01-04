.data
  #gameOverImage: .image "gameOver.jpg"
  acc: 0
  userPaddlePosition: 69
  widthLowerBound: 2
  widthUpperBound: 154
  jumptable: .int 4

.text
  mov fp sp
  la t0 jumptable
  la t1 case_00
  swo t1 t0 0
  la t1 case_01
  swo t1 t0 2
  la t1 case_10
  swo t1 t0 4
  la t1 case_11
  swo t1 t0 6
  jal render_padding
  jal gen_xy_puck
  jal gen_slope
  jal loop

render_padding:
  li a0 0       # col/x
  li a1 0       # row/y
  li a2 2       # object width
  li a3 144     # object height
  sys fbrect

  li a0 158
  li a1 0
  sys fbrect
  ret

gen_xy_puck:
  li a0 52    #gen rand x
  li a1 104
  sys rnd
  mov t0 rv

  li a0 20    #gen rand y
  li a1 40
  sys rnd
  mov t1 rv
  ret

gen_slope:
  li a0 -150
  li a1 150
  sys rnd
  mov t2 rv
  lti t2 0
  jz l0
    neg t2
    imm shl t2 2
    xori t2 0b0000_0010
    ret
  l0:
    imm shl t2 2
    xori t2 0b0000_0000
  ret

pause_game:
  sys joystick
  mov t3 rv
  mov t4 t3
  andi t4 0b0000_0001 # press 's' to terminate
  jz ln
    sys exit
  ln:
  mov t4 t3
  andi t4 0b1000_0000 # up
  jz pause_game
    j get_user_input

get_user_input:
  sys joystick
  mov t3 rv

  mov t4 t3
  andi t4 0b0000_0001 # press 's' to terminate
  jz l1
    sys exit
  l1:

  mov t4 t3
  andi t4 0b0100_0000 # down
  jz l2
    j pause_game
  l2:

  mov t4 t3
  andi t4 0b0010_0000 # left
  jz l3
    li t4 2
    lw t3 userPaddlePosition
    lte t3 t4
    jz l31
      ret
    l31:
    dec t3 2
    sw t3 userPaddlePosition
    ret
  l3:

  mov t4 t3
  andi t4 0b0001_0000 # right
  jz l4
    li t4 138
    lw t3 userPaddlePosition
    gte t3 t4
    jz l41
      ret
    l41:
    inc t3 2
    sw t3 userPaddlePosition
    ret
  l4:
  ret

render_user_paddle:
  lw t3 userPaddlePosition
  sys fbreset
  mov a0 t3
  li a1 140
  li a2 20
  li a3 2
  sys fbrect
  ret

render_comp_paddle:
  mov t3 t0
  subi t3 8
  ltei t3 2
  jz l5
    li t3 2
  l5:
  li t4 138
  gte t3 t4
  jz l6
    li t3 138
  l6:
  mov a0 t3
  li a1 2
  li a2 20
  li a3 2
  sys fbrect
  ret

case_00:    #slope +ve y +ve
  inc t1 2
  j cal_x_posi

case_01:     #slope +ve y -ve
  dec t1 2
  j cal_x_negi

case_10:    #slope -ve y +ve
  inc t1 2
  j cal_x_negi

case_11:    #slope -ve y -ve
  dec t1 2
  j cal_x_posi

cal_x_posi:
  li t4 100
  lw t5 acc
  gte t5 t4
  jz l7
  mod t5 t4
  inc t0
  l7:
    add t5 t3
  sw t5 acc
  j con

cal_x_negi:
  li t4 100
  lw t5 acc
  gte t5 t4
  jz l8
  mod t5 t4
  dec t0
  l8:
    add t5 t3
  sw t5 acc
  j con

cal_next_pos1:
  mov t3 t2
  andi t3 0b0000_0011
  imm shl t3 1
  la t4 jumptable
  add t4 t3
  mov t3 t2
  imm shr t3 2
  lwo t5 t4 0
  jr t5
  return:
  ret

collision_detect:
  lw t3 widthLowerBound
  lte t0 t3
  jz l9
    xori t2 0b0000_0010 # left collision
  l9:
  imm add t3 2
  lte t1 t3
  jz l10
    xori t2 0b0000_0011 # top collision
  l10:
  lw t3 widthUpperBound
  gte t0 t3
  jz l11
    xori t2 0b0000_0010 # right collision
  l11:
  imm sub t3 14
  imm sub t3 4
  gte t1 t3
  jz l12
    xori t2 0b0000_0011 # bottom collision
    lw t3 userPaddlePosition
    subi t3 2
    lt t0 t3
    jz l121
      #lw a0 gameOverImage
      #li a1 0
      #li a2 0
      #sys drawimg
      sys exit
    l121:
    li t4 20
    add t3 t4
    gt t0 t3
    jz l122
      #lw a0 gameOverImage
      #li a1 0
      #li a2 0
      #sys drawimg
      sys exit
    l122:
  l12:
  ret

loop:
  sys fbreset
  jal get_user_input
  jal render_user_paddle
  jal render_comp_paddle
  jal render_padding
  mov a0 t0
  mov a1 t1
  li a2 4
  li a3 4
  sys fbrect
  sys fbflush   # call fbflush only once to render the entire frame
  jal collision_detect
  jal cal_next_pos1
  con:
  li a0 20
  sys sleep
  j loop
