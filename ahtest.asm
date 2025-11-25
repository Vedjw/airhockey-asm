.data
  acc: 0
  width_lower_bound: 2
  width_upper_bound: 154
  height_lower_bound: 4
  height_upper_bound: 138
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
  jal gen_xy_puck
  jal gen_slope 
  jal main

case_00:    #slope +ve y +ve
  inc t1
  j cal_x_posi

case_01:     #slope +ve y -ve
  dec t1
  j cal_x_negi

case_10:    #slope -ve y +ve
  inc t1
  j cal_x_negi

case_11:    #slope -ve y -ve
  dec t1
  j cal_x_posi


cal_x_posi:
  li t4 100
  lw t5 acc
  gte t5 t4
  jz else1
  mod t5 t4
  inc t0
  else1:
    add t5 t3
  sw t5 acc
  j con

cal_x_negi:
  li t4 100
  lw t5 acc
  gte t5 t4
  jz else1
  mod t5 t4
  dec t0
  else1:
    add t5 t3
  sw t5 acc
  j con

gen_xy_puck:
  li a0 52    #gen rand x
  li a1 104
  sys rnd
  mov t0 rv

  li a0 46    #gen rand y
  li a1 93
  sys rnd
  mov t1 rv
  ret

gen_slope:
  li a0 -150
  li a1 150
  sys rnd
  mov t2 rv
  lti t2 0
  jz endif
    neg t2
    imm shl t2 2
    xori t2 0b0000_0010
    ret  
  endif:
    imm shl t2 2
    xori t2 0b0000_0000
  ret

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
   

collisionDetect:
  lw t3 width_lower_bound
  lte a0 t3
  jz endif1
    xori t2 0b0000_0010
  endif1:
  imm add t3 2
  lte a1 t3
  jz endif2
    xori t2 0b0000_0011
  endif2:
  lw t3 width_upper_bound
  gte a0 t3
  jz endif3
    xori t2 0b0000_0010
  endif3:
  imm sub t3 10
  imm sub t3 10
  gte a1 t3
  jz endif4
    xori t2 0b0000_0011
  endif4:
  ret

main:

  loop:
    sys fbreset
    mov a0 t0
    mov a1 t1       
    li a2 4     
    li a3 4     
    sys fbrect 
    sys fbflush
    jal collisionDetect
    jal cal_next_pos1
    con:
    li a0 10
    sys sleep
    j loop
