########################################################################
# COMP1521 24T2 -- Assignment 1 -- Breakout!
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
# Instructions to configure your text editor can be found here:
#   https://cgi.cse.unsw.edu.au/~cs1521/24T2/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by Ryan Tchan (z5258155)
# on 18/06/2024
#
# Version 1.0 (2024-06-11): Team COMP1521 <cs1521@cse.unsw.edu.au>
#
########################################################################

#![tabsize(8)]

# ##########################################################
# ####################### Constants ########################
# ##########################################################

# C constants
FALSE = 0
TRUE  = 1

MAX_GRID_WIDTH = 60
MIN_GRID_WIDTH = 6
GRID_HEIGHT    = 12

BRICK_ROW_START = 2
BRICK_ROW_END   = 7
BRICK_WIDTH     = 3
PADDLE_WIDTH    = 6
PADDLE_ROW      = GRID_HEIGHT - 1

BALL_FRACTION  = 24
BALL_SIM_STEPS = 3
MAX_BALLS      = 3
BALL_NONE      = 'X'
BALL_NORMAL    = 'N'
BALL_SUPER     = 'S'

VERTICAL       = 0
HORIZONTAL     = 1

MAX_SCREEN_UPDATES = 24

KEY_LEFT        = 'a'
KEY_RIGHT       = 'd'
KEY_SUPER_LEFT  = 'A'
KEY_SUPER_RIGHT = 'D'
KEY_STEP        = '.'
KEY_BIG_STEP    = ';'
KEY_SMALL_STEP  = ','
KEY_DEBUG_INFO  = '?'
KEY_SCREEN_UPD  = 's'
KEY_HELP        = 'h'

# NULL is defined in <stdlib.h>
NULL  = 0

# Other useful constants
SIZEOF_CHAR = 1
SIZEOF_INT  = 4

BALL_X_OFFSET      = 0
BALL_Y_OFFSET      = 4
BALL_X_FRAC_OFFSET = 8
BALL_Y_FRAC_OFFSET = 12
BALL_DX_OFFSET     = 16
BALL_DY_OFFSET     = 20
BALL_STATE_OFFSET  = 24
# <implicit 3 bytes of padding>
SIZEOF_BALL = 28

SCREEN_UPDATE_X_OFFSET = 0
SCREEN_UPDATE_Y_OFFSET = 4
SIZEOF_SCREEN_UPDATE   = 8

MANY_BALL_CHAR = '#'
ONE_BALL_CHAR  = '*'
PADDLE_CHAR    = '-'
EMPTY_CHAR     = ' '
GRID_TOP_CHAR  = '='
GRID_SIDE_CHAR = '|'

	.data
# ##########################################################
# #################### Global variables ####################
# ##########################################################

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE DEFINITIONS !!!

grid_width:			# int grid_width;
	.word	0

balls:				# struct ball balls[MAX_BALLS];
	.byte	0:MAX_BALLS*SIZEOF_BALL

bricks:				# char bricks[GRID_HEIGHT][MAX_GRID_WIDTH];
	.byte	0:GRID_HEIGHT*MAX_GRID_WIDTH

bricks_destroyed:		# int bricks_destroyed;
	.word	0

total_bricks:			# int total_bricks;
	.word	0

paddle_x:			# int paddle_x;
	.word	0

score:				# int score;
	.word	0

combo_bonus:			# int combo_bonus;
	.word	0

screen_updates:			# struct screen_update screen_updates[MAX_SCREEN_UPDATES];
	.byte	0:MAX_SCREEN_UPDATES*SIZEOF_SCREEN_UPDATE

num_screen_updates:		# int num_screen_updates;
	.word	0

whole_screen_update_needed:	# int whole_screen_update_needed;
	.word	0

no_auto_print:			# int no_auto_print;
	.word	0


# ##########################################################
# ######################### Strings ########################
# ##########################################################

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE STRINGS !!!

str_print_welcome_1:
	.asciiz	"Welcome to 1521 breakout! In this game you control a "
str_print_welcome_2:
	.asciiz	"paddle (---) with\nthe "
str_print_welcome_3:	# note: this string is used twice
	.asciiz	" and "
str_print_welcome_4:
	.asciiz	" (or "
str_print_welcome_5:
	.asciiz	" for fast "
str_print_welcome_6:
	.asciiz	"movement) keys, and your goal is\nto bounce the ball ("
str_print_welcome_7:
	.asciiz	") off of the bricks (digits). Every ten "
str_print_welcome_8:
	.asciiz	"bricks\ndestroyed spawns an extra ball. The "
str_print_welcome_9:
	.asciiz	" key will advance time one step.\n\n"

str_read_grid_width_prompt:
	.asciiz	"Enter the width of the playing field: "
str_read_grid_width_out_of_bounds_1:
	.asciiz	"Bad input, the width must be between "
str_read_grid_width_out_of_bounds_2:
	.asciiz	" and "
str_read_grid_width_not_multiple:
	.asciiz	"Bad input, the grid width must be a multiple of "

str_game_loop_win:
	.asciiz	"\nYou win! Congratulations!\n"
str_game_loop_game_over:
	.asciiz	"Game over :(\n"
str_game_loop_final_score:
	.asciiz	"Final score: "

str_print_game_score:
	.asciiz	" SCORE: "

str_hit_brick_bonus_ball:
	.asciiz	"\n!! Bonus ball !!\n"

str_run_command_prompt:
	.asciiz	" >> "
str_run_command_bad_cmd_1:
	.asciiz	"Bad command: '"
str_run_command_bad_cmd_2:
	.asciiz	"'. Run `h` for help.\n"

str_print_debug_info_1:
	.asciiz	"      grid_width = "
str_print_debug_info_2:
	.asciiz	"        paddle_x = "
str_print_debug_info_3:
	.asciiz	"bricks_destroyed = "
str_print_debug_info_4:
	.asciiz	"    total_bricks = "
str_print_debug_info_5:
	.asciiz	"           score = "
str_print_debug_info_6:
	.asciiz	"     combo_bonus = "
str_print_debug_info_7:
	.asciiz	"        num_screen_updates = "
str_print_debug_info_8:
	.asciiz	"whole_screen_update_needed = "
str_print_debug_info_9:
	.asciiz	"ball["
str_print_debug_info_10:
	.asciiz	"  y: "
str_print_debug_info_11:
	.asciiz	", x: "
str_print_debug_info_12:
	.asciiz	"  x_fraction: "
str_print_debug_info_13:
	.asciiz	"  y_fraction: "
str_print_debug_info_14:
	.asciiz	"  dy: "
str_print_debug_info_15:
	.asciiz	", dx: "
str_print_debug_info_16:
	.asciiz	"  state: "
str_print_debug_info_17:
	.asciiz	" ("
str_print_debug_info_18:
	.asciiz	")\n"
str_print_debug_info_19:
	.asciiz	"\nbricks["
str_print_debug_info_20:
	.asciiz	"]: "
str_print_debug_info_21:
	.asciiz	"]:\n"

# !!! Reminder to not not add to or modify any of the above !!!
# !!! strings or any other part of the data segment.        !!!
# !!! If you add more strings you will likely break the     !!!
# !!! autotests and automarking.                            !!!


############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################

################################################################################
#
# Implement the following functions,
# and check these boxes as you finish implementing each function.
#
#  SUBSET 0
#  - [X] print_welcome
#  - [X] main
#  SUBSET 1
#  - [X] read_grid_width
#  - [X] game_loop
#  - [X] initialise_game
#  - [X] move_paddle
#  - [X] count_total_active_balls
#  - [X] print_cell
#  SUBSET 2
#  - [X] register_screen_update
#  - [X] count_balls_at_coordinate
#  - [X] print_game
#  - [X] spawn_new_ball
#  - [X] move_balls
#  SUBSET 3
#  - [X] move_ball_in_axis
#  - [in-progress] hit_brick
#  - [ ] check_ball_paddle_collision
#  - [ ] move_ball_one_cell
#  PROVIDED
#  - [X] print_debug_info
#  - [X] run_command
#  - [X] print_screen_updates


################################################################################
# .TEXT <print_welcome> : Print out information on how to play this game.
        .text
print_welcome:
	# Subset:   0
	#
	# Frame:    [$ra]   
	# Uses:     [$a0, $v0, $ra]
	# Clobbers: [$a0, $v0]
	#
	# Locals:
	#   - None
	#
	# Structure:
	#   print_welcome
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

print_welcome__prologue:
	push 	$ra								#


print_welcome__body:
	la	$a0, str_print_welcome_1					# load ("Welcome to 1521 breakout! In this game you control a ")
	li 	$v0, 4								# print string
	syscall									#

	la	$a0, str_print_welcome_2					# load ("paddle (---) with\nthe ")
	li 	$v0, 4								# print string
	syscall									#

	la	$a0, KEY_LEFT							# load ('a' command)
	li 	$v0, 11								# print char
	syscall									#

	la	$a0, str_print_welcome_3					# load (" and ")
	li 	$v0, 4								# print string
	syscall									#

	la	$a0, KEY_RIGHT							# load ('d' command)
	li 	$v0, 11								# print char
	syscall									#

	la	$a0, str_print_welcome_4					# load (" (or ")
	li 	$v0, 4								# print string
	syscall									#

	la	$a0, KEY_SUPER_LEFT						# load ('A' command)
	li 	$v0, 11								# print char
	syscall									#

	la	$a0, str_print_welcome_3					# load (" and ")
	li 	$v0, 4								# print string
	syscall									#

	la	$a0, KEY_SUPER_RIGHT						# load ('D' command)
	li 	$v0, 11								# print char
	syscall									#

	la	$a0, str_print_welcome_5					# load (" for fast ")
	li 	$v0, 4								# print string
	syscall									#

	la	$a0, str_print_welcome_6					# load ("movement) keys, and your goal is\nto bounce the ball (")
	li 	$v0, 4								# print string
	syscall									#

	la	$a0, ONE_BALL_CHAR						# load ('*' ball)
	li 	$v0, 11								# print char
	syscall									#

	la	$a0, str_print_welcome_7					# load (") off of the bricks (digits). Every ten ")
	li 	$v0, 4								# print string
	syscall									#

	la	$a0, str_print_welcome_8					# load ("bricks\ndestroyed spawns an extra ball. The ")
	li 	$v0, 4								# print string
	syscall									#

	la	$a0, KEY_STEP							# load ('.' command)
	li 	$v0, 11								# print char
	syscall									#

	la	$a0, str_print_welcome_9					# load (" key will advance time one step.\n\n")
	li 	$v0, 4								# print string
	syscall									#
	

print_welcome__epilogue:
	pop	$ra								#

	jr      $ra								# exit to main
################################################################################
# .TEXT <main> : Entry point to the game
        .text
main:
	# Subset:   0
	#
	# Frame:    [$ra]   <-- FILL THESE OUT!
	# Uses:     [$ra, $v0]
	# Clobbers: [$v0]
	#
	# Locals:
	#   - None
	#
	# Structure:
	#   main
	#   -> [prologue]
	#       -> body
	#	  -> print_welcome
	#	  -> read_grid_width
	#	  -> initialise_game
	#	  -> game_loop
	#   -> [epilogue]

main__prologue:
	push	$ra								#

main__body:
	main_print_welcome:			
	jal	print_welcome							# goto print_welcome

	main_read_grid_width:
	jal	read_grid_width							# goto read_grid_width

	main_initialise_game:
	jal	initialise_game							# goto initialise_game

	main_game_loop:
	jal	game_loop							# goto game_loop


main__epilogue:
	pop	$ra								#

	li	$v0, 0								# return 0
	jr	$ra								#

################################################################################
# .TEXT <read_grid_width> :  Read in and validate the grid width.
        .text
read_grid_width:
	# Subset:   1
	#
	# Frame:    [$ra]   
	# Uses:     [$ra, $t0, $t1, $a0, $v0]
	# Clobbers: [$t0, $a0, $v0]
	#
	# Locals:           
	#   - $t0 -> used to store grid_width % BRICK_WIDTH
	#   - $t1 -> move input value to global var grid_width
	#
	# Structure:        
	#   read_grid_width
	#   -> [prologue]
	#       -> body
	#	-> out_of_bounds
	#	  -> out_of_bounds_end
	#	-> not_a_multiple
	#	  -> not_a_multiple_end
	#   -> [epilogue]

read_grid_width__prologue:
	push	$ra								#

read_grid_width__body:
	la	$a0, str_read_grid_width_prompt					# load ("Enter the width of the playing field: ")
	li 	$v0, 4								# print string
	syscall									#

	li	$v0, 5								# scanf("%d", &grid_width);
	syscall									#

	lw	$t1, grid_width							# load address of global var grid_width
	move 	$t1, $v0							# move grid_width input to t1
	sw	$t1, grid_width							# save value of input grid_width to global var


read_grid_width__body_out_of_bounds:
	bgt	$t1, MAX_GRID_WIDTH, read_grid_width__body_out_of_bounds__end	# if grid_width > MAX_GRID_WIDTH
	blt	$t1, MIN_GRID_WIDTH, read_grid_width__body_out_of_bounds__end	# if grid_width < MIN_GRID_WIDTH
	b	read_grid_width__body_not_a_multiple				# goto if else condition

read_grid_width__body_out_of_bounds__end:
	la	$a0, str_read_grid_width_out_of_bounds_1			# load ("Bad input, the width must be between ")
	li 	$v0, 4								# print string
	syscall									#

	la	$a0, MIN_GRID_WIDTH						# load (MIN_GRID_WIDTH)
	li 	$v0, 1								# print int
	syscall									#

	la	$a0, str_read_grid_width_out_of_bounds_2			# load (" and ")
	li 	$v0, 4								# print string
	syscall

	la	$a0, MAX_GRID_WIDTH						# load (MAX_GRID_WIDTH)
	li 	$v0, 1								# print int
	syscall									#

	li	$v0, 11								# syscall 11: print_char
	li	$a0, '\n'							#
	syscall									# printf("%c", '\n');

	j	read_grid_width__body						# loop back to body	

read_grid_width__body_not_a_multiple:
	rem	$t0, $t1, BRICK_WIDTH						# $t0 = grid_width % BRICK_WIDTH
	bnez	$t0, read_grid_width__body_not_a_multiple__end			# if $t0 != 0 we want to loop back
	beqz	$t0, read_grid_width_epilogue					# if grid_width is between bounds and a multiple of brick, goto epilogue

read_grid_width__body_not_a_multiple__end:
	la	$a0, str_read_grid_width_not_multiple				# load ("Bad input, the grid width must be a multiple of ")
	li 	$v0, 4								# print string
	syscall

	la	$a0, BRICK_WIDTH						# load (BRICK_WIDTH)
	li 	$v0, 1								# print int 
	syscall									#

	li	$v0, 11								#   syscall 11: print_char
	li	$a0, '\n'							#
	syscall									#   printf("%c", '\n');

	j	read_grid_width__body						# loop back to body

read_grid_width_epilogue:
	li	$v0, 11								# syscall 11: print_char
	li	$a0, '\n'							#
	syscall									# printf("%c", '\n');

	pop 	$ra								#

	jr	$ra								# goto main

################################################################################
# .TEXT <game_loop> : Run the game loop: print out the game and read in and execute commands until the game is over.
        .text
game_loop:
	# Subset:   1
	#
	# Frame:    [$ra, $s0, $s1]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0, $s1, $t0, $t1, $t2, $a0, $v0]
	# Clobbers: [$t0, $t1, $t2, $a0, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $t0: value of count_total_active_balls
	#   - $t1: value of no_auto_print
	#   - $t2: value of run_command
	#   - $s0: value of bricks_destroyed
	#   - $s1: value of total bricks
	#
	# Structure:        <-- FILL THIS OUT!
	#   game_loop
	#   -> [prologue]
	#       -> body
	#	  -> initialize
	#	  -> cond_active_balls
	#	  -> continue_loop_if_cond
	#	  -> continue_loop_while_cond
	#	  -> exit_bricks_equal
	#	  -> exit_else_game_over
	#   -> [epilogue]

game_loop__prologue:
	push	$ra								#	
	push	$s0								#
	push	$s1								#

game_loop__body:
game_loop__initialize:
	lw	$s0, bricks_destroyed						# load value of bricks_destroyed into $s0
	lw	$s1, total_bricks						# load value of total_bricks into $s1

	blt 	$s0, $s1, game_loop__cond_active_balls				# goto count active balls cond if bricks destroyed < total
	beq	$s0, $s1, game_loop__exit_bricks_equal				# otherwise check if bricks destroyed = total
	j	game_loop__exit_else_game_over					# goto else game_over

game_loop__cond_active_balls:
	jal 	count_total_active_balls					# goto function count_total_active_balls
	move	$t0, $v0							# store value of function to $t0
	bgt	$t0, 0, game_loop__continue_loop_if_cond			# if active balls > 0 goto into while loop body
	j	game_loop__exit_bricks_equal					# otherwise exit game loop (body of while loop)

game_loop__continue_loop_if_cond:
	lw	$t1, no_auto_print						# load value of no_auto_print into $t1
	bnez	$t1, game_loop__continue_loop_while_cond 			# if no_auto_print == 1 (TRUE) then skip print_game()
	jal 	print_game							# goto print_game function if no_auto_print is false
	j 	game_loop__continue_loop_while_cond				# goto while (!run_command())

game_loop__continue_loop_while_cond:
	jal	run_command							# goto run_command function
	move	$t2, $v0							# move return value of run_command to $t2
	beqz	$t2, game_loop__continue_loop_while_cond 			# repeat until run_command != 0 (or until is true)
	j 	game_loop__initialize						# repeat while loop from initialisation 

game_loop__exit_bricks_equal:	
	bne	$s0, $s1, game_loop__exit_else_game_over			# check if bricks destroyed = total and goto game_over if false

	la	$a0, str_game_loop_win						# load ("You win! Congratulations!")
	li 	$v0, 4								# print string
	syscall									#

	j	game_loop__epilogue						# goto epilogue


game_loop__exit_else_game_over:
	la	$a0, str_game_loop_game_over					# load ("Game over :(")
	li 	$v0, 4								# print string
	syscall									#

	j 	game_loop__epilogue						# goto epilogue

game_loop__epilogue:
	la	$a0, str_game_loop_final_score					# load ("Final score: ")
	li 	$v0, 4								# print string
	syscall									#	

	lw	$t3, score							# load value of score
	move	$a0, $t3							# move value of score
	li 	$v0, 1								# print int
	syscall

	li	$v0, 11								# syscall 11: print_char
	li	$a0, '\n'							#
	syscall									# printf("%c", '\n');	

	pop	$s1								#
	pop	$s0								#
	pop	$ra								#

	jr	$ra								# goto main

################################################################################
# .TEXT <initialise_game> : Initialise the game state ready for a new game.
        .text
initialise_game:
	# Subset:   1
	#
	# Frame:    [$s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $ra]   
	# Uses:     [$t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $ra]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $t0: int row, value of grid_width
	#   - $t1: int col, value of paddle_x
	#   - $t2: value of grid_width, temporary value of 0
	#   - $t3: offset of bricks[row][col], value of total_bricks
	#   - $t4: address of bricks, temporary value of TRUE
	#   - $t5: value of bricks[row][col]
	#   - $t6: int i
	#   - $t7: address of balls
	#   - $t8: offset of balls
	#   - $t9: value of balls
	#   - $s0: address of paddle_x
	#   - $s1: address of score
	#   - $s2: address of bricks_destroyed
	#   - $s3: address of total_bricks
	#   - $s4: address of num_screen_updates 
	#   - $s5: address of whole_screen_updates
	#   - $s6: address of no_auto_print
	#
	# Structure:        <-- FILL THIS OUT!
	#   initialise_game
	#   -> [prologue]
	#       -> body
	#	   -> outer_loop_cond
	#          -> outer_loop_step
	#            -> inner_loop_cond
	#            -> inner_loop_body_init
	#              -> if_BRICK_conds
	#              -> if_BRICK_row_in_bounds
	#              -> else_cond
	#              -> inner_loop_step
	#          -> body_two_loop_init
	#            -> body_two_loop_cond
	#            -> body_two_loop_body
	#            -> body_two_loop_step
	#          -> spawn_new_ball
	#          -> paddle_and_grid
	#   -> [epilogue]

initialise_game__prologue:
	push 	$ra								#
	push	$s0								#
	push	$s1								#
	push	$s2								#
	push	$s3								#
	push	$s4								#
	push	$s5								#
	push	$s6								#
	push	$s7								#

initialise_game__body:
	li	$t0, 0 								# int row = 0

initialise_game__row_loop_cond:
	bge	$t0, GRID_HEIGHT, initialise_game__body_two_loop_init		# if row >= GRID_HEIGHT exit row loop

	li	$t1, 0								# int col = 0
	lw	$t2, grid_width							# load value of grid_width

initialise_game_col_loop_cond:
	bge	$t1, $t2, initialise_game_row_loop_step				# if col >= grid_width exit col loop

initialise_game_col_loop_body:
	mul	$t3, $t0, MAX_GRID_WIDTH					# $t3 = row * MAX_GRID_WIDTH
	add	$t3, $t3, $t1							# $t3 = row * MAX_GRID_WIDTH + col
	la	$t4, bricks							# load base address of bricks
	add	$t4, $t4, $t3							# add offset to bricks address for bricks[row][col]

	blt	$t0, BRICK_ROW_START, initialise_game_col_loop_body_else	# if row < BRICK_ROW_START goto else cond
	bgt	$t0, BRICK_ROW_END, initialise_game_col_loop_body_else		# if row > BRICK_ROW_END goto else cond

	div	$t5, $t1, BRICK_WIDTH						# $t5 = col / BRICK_WIDTH
	rem	$t5, $t5, 10							# $t5 = (col / BRICK_WIDTH) % 10
	addi	$t5, $t5, 1							# $t5 = 1 + (col / BRICK_WIDTH) % 10

	sb	$t5, 0($t4)							# save value of $t5 to address stored in $t4

	j	initialise_game__col_loop_step					# goto col loop step

initialise_game_col_loop_body_else:
	li	$t5, 0								# $t6 = 0
	sb	$t5, 0($t4)							# save value of 0 to address stores in $t4

initialise_game__col_loop_step:
	addi	$t1, $t1, 1							# col++
	j	initialise_game_col_loop_cond					# repeat col for loop until exit

initialise_game_row_loop_step:
	addi	$t0, $t0, 1							# row++
	j	initialise_game__row_loop_cond					# repeat row for loop until exit

initialise_game__body_two_loop_init:
	li 	$t6, 0								# i = 0

initialise_game__body_two_loop_cond:
	blt 	$t6, MAX_BALLS, initialise_game__body_two_loop_body		# if i < MAX_BALLS goto body
	bge	$t6, MAX_BALLS,	initialise_game__spawn_new_ball			# goto spawn_new_ball() function if i >= MAX_BALLS

initialise_game__body_two_loop_body:
	la 	$t7, balls							# load address of balls into register $t4
	mul 	$t8, $t6, SIZEOF_BALL						# multiply i by the size of the struct 
	add	$t8, $t8, BALL_STATE_OFFSET					# add offset of balls.state
	add 	$t7, $t8, $t7							# add offset of balls[i].state to address of balls

	li 	$t9, BALL_NONE							# set BALL_NONE
	sw	$t9, 0($t7)							# save value at balls[i].state
	j	initialise_game_body_two_loop_step				# goto loop step
	
initialise_game_body_two_loop_step:
	addi	$t6, $t6, 1							# i++;
	j 	initialise_game__body_two_loop_cond				# goto body two cond i < MAX_BALLS

initialise_game__spawn_new_ball:
	jal 	spawn_new_ball							# goto spawn new ball function

initialise_game__paddle_and_grid:
	lw	$t0, grid_width							# assign $t0 as value of grid_width
	sub	$t1, $t0, PADDLE_WIDTH						# grid_width - PADDLE_WIDTH
	addi	$t1, $t1, 1							# grid_width - PADDLE_WIDTH + 1
	div	$t1, $t1, 2							# (grid_width - PADDLE_WIDTH + 1) / 2

	la	$s0, paddle_x							# load address of paddle_x
	sw	$t1, 0($s0)							# save $t1 as value of paddle_x

	li	$t2, 0								# load immediate $t2 = 0

	la	$s1, score							# load address of score
	sw	$t2, 0($s1)							# save score = 0

	la	$s2, bricks_destroyed						# load address of bricks_destroyed
	sw	$t2, 0($s2)							# save bricks_destroyed = 0

	la	$s3, total_bricks						# load address of total_bricks
	li	$t3, 1								# load immediate $t4 = 1
	add	$t3, $t3, BRICK_ROW_END						# $t4 = 1 + BRICK_ROW_END
	sub	$t3, $t3, BRICK_ROW_START					# $t4 = BRICK_ROW_END - BRICK_ROW_START + 1
	div	$t0, $t0, BRICK_WIDTH						# $t0 = grid_width / BRICK_WIDTH
	mul	$t3, $t3, $t0							# $t4 = (BRICK_ROW_END - BRICK_ROW_START + 1) * (grid_width / BRICK_WIDTH) 
	sw	$t3, 0($s3)							# save value of $t4 to total_bricks

	la	$s4, num_screen_updates						# load address of num_screen_updates
	sw	$t2, 0($s4)							# save num_screen_updates = 0

	li	$t4, TRUE							# load immediate $t5 = TRUE
	la	$s5, whole_screen_update_needed					# load address of whole_screen_update_needed
	sw	$t4, 0($s5)							# save whole_screen_update_needed = TRUE

	la	$s6, no_auto_print						# load address of no_auto_print
	sw	$t2, 0($s6)							# save no_auto_print = 0

initialise_game__epilogue:
	pop 	$s7								#
	pop	$s6								#
	pop	$s5								#
	pop	$s4								#
	pop	$s3								#
	pop	$s2								#
	pop	$s1								#
	pop	$s0								#
	pop	$ra								#

	jr	$ra								#


################################################################################
# .TEXT <move_paddle> : Move the paddle in target direction (right/left)
        .text
move_paddle:
	# Subset:   1
	#
	# Frame:    [$ra, $s0, $s1]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0, $s1, $t0, $t1, $t2, $t3, $t4, $a0, $a1]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $a0, $a1]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $t0: holds value of grid_width
	#   - $t1: holds value of PADDLE_WIDTH
	#   - $t2: direction_indicator
	#   - $t3: paddle_x - direction_indicator
	#   - $t4: paddle_x + PADDLE_WIDTH - direction_indicator
	#   - $s0: paddle_x
	#   - $s1: direction
	#
	# Structure:        <-- FILL THIS OUT!
	#   move_paddle
	#   -> [prologue]
	#       -> body
	#	  -> body_init
	#	  -> if_less_than_0_cond
	#	  -> if_greater_than_grid_width
	#	    -> if_cond_body
	#	  -> else_body
	#   -> [epilogue]

move_paddle__prologue:
	push	$ra								#
	push	$s0								#
	push	$s1								#

move_paddle__body:
move_paddle__body_init:
	lw	$s0, paddle_x							# load value of paddle_x
	move	$s1, $a0							# move direction to $s1

	add	$s0, $s0, $s1							# paddle += direction
	sw	$s0, paddle_x							# save value of paddle_x 

move_paddle__if_less_than_0_cond:
	lw	$s0, paddle_x							# load value of paddle_x
	bltz	$s0, move_paddle__if_cond_body					# if paddle < 0 goto body
	j	move_paddle__if_greater_than_grid_width				# otherwise check next if_cond

move_paddle__if_greater_than_grid_width:
	lw	$t0, grid_width							# load value of grid width
	add	$t1, $s0, PADDLE_WIDTH						# paddle_x + PADDLE_WIDTH
	bgtu	$t1, $t0, move_paddle__if_cond_body 				# goto if_cond_body if paddle_x + PADDLE_WIDTH > grid_width
	j	move_paddle_else_body						# otherwise goto else body

move_paddle__if_cond_body:
	sub	$s0, $s0, $s1							# paddle_x = paddle_x -= direction
	sw	$s0, paddle_x							# save value to paddle_x
	j	move_paddle__epilogue						# goto epilogue

move_paddle_else_body:
	jal	check_ball_paddle_collision					# goto check_ball_paddle_collision_function

	add	$t2, $s1, 2							# $t2 (direction_indicator) = direction + 2
	div	$t2, $t2, 2							# $t2 = (direction + 2) / 2

	sub	$t3, $s0, $t2							# paddle_x - direction_indicator
	move 	$a0, $t3							# load paddle_x - direction_indicator into $a0
	li	$a1, PADDLE_ROW							# load PADDLE_ROW into $a1
	jal	register_screen_update						# goto register_screen_update function with loaded variables

	add	$t2, $s1, 2							# $t2 (direction_indicator) = direction + 2
	div	$t2, $t2, 2							# $t2 = (direction + 2) / 2
	sub	$t3, $s0, $t2							# paddle_x - direction_indicator

	add	$t4, $t3, PADDLE_WIDTH						# paddle_x + PADDLE_WIDTH - direction_indicator
	move	$a0, $t4							# load $t4 into $a2
	li	$a1, PADDLE_ROW							# load PADDLE_ROW into $a2
	jal 	register_screen_update						# goto register_screen_update function wtih loaded variables

move_paddle__epilogue:
	pop 	$s1								#
	pop	$s0								#
	pop	$ra								#

	jr	$ra								# 


################################################################################
# .TEXT <count_total_active_balls> : Return the total number of active balls.
        .text
count_total_active_balls:
	# Subset:   1
	#
	# Frame:    [$ra, $s0, $s1]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0, $s1, $t0, $t1, $t2, $t3, $v0]
	# Clobbers: [$t0, $t1, $t2, $t3, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $s0: int count
	#   - $t0: int i
	#   - $t0: address of balls[i].state
	#   - $t1: offset of balls[i].state
	#   - $t2: value held at balls[i].state
	#   - $t3: BALL_NONE
	#
	# Structure:        <-- FILL THIS OUT!
	#   count_total_active_balls
	#   -> [prologue]
	#       -> body
	#	  -> loop_init
	#	  -> loop_cond
	#	  -> loop_body
	#	  -> loop_step
	#   -> [epilogue]

count_total_active_balls__prologue:
	push	$ra								#
	push	$s0								#
	push	$s1								#

count_total_active_balls__body:
count_total_active_balls__loop_init:
	li	$s0, 0 								# count = 0
	li	$s1, 0								# int i = 0

count_total_active_balls__loop_cond:
	bge 	$s1, MAX_BALLS, count_total_active_balls__epilogue 		# if i >= MAX_BALLS goto exit for loop

count_total_active_balls__loop_body:
	la	$t0, balls							# load address of balls to $t1
	mul	$t1, $s1, SIZEOF_BALL						# calculate offset of balls struct at i = SIZEOFBALL * i
	add	$t1, $t1, BALL_STATE_OFFSET				 	# add BALL_STATE_OFFSET	
	add	$t0, $t1, $t0 							# add offset of balls[i].state to address of balls
	lb	$t2, 0($t0)							# load value of balls[i].state held at address

	li	$t3, BALL_NONE
	beq	$t2, $t3, count_total_active_balls__loop_step			# if balls[i].state == BALL_NONE skip count++ step

	addi  	$s0, $s0, 1							# count++

count_total_active_balls__loop_step:
	addi	$s1, $s1, 1							# i++
	j 	count_total_active_balls__loop_cond				# goto for loop

count_total_active_balls__epilogue:	
	move	$v0, $s0							# move value of count to $v0
		
	pop	$s1								#
	pop	$s0								#
	pop	$ra								#

	jr	$ra								#


################################################################################
# .TEXT <print_cell> : Returns the appropriate character to print, for a given coordinate in the grid.
        .text
print_cell:
	# Subset:   1
	#
	# Frame:    [$ra, $s0, $s1]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0, $s1, $t0, $t1, $t2, $t3, $t4, $a0, $a1, $v0]
	# Clobbers: [$t0, $t1, $t2, $t3, $a0, $a1, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $s0: row
	#   - $s1: col 
	#   - $s2: ball_count
	#   - $t0: value of PADDLE_ROW
	#   - $t1: value of paddle_x
	#   - $t2: address of bricks array
	#   - $t3: bricks[row][col] offset
	#   - $t4: value held at bricks[row][col] offset
	#
	# Structure:        <-- FILL THIS OUT!
	#   print_cell
	#   -> [prologue]
	#       -> body
	#	  -> if_conditions
	#	  -> else_if_bricks_array
	#	-> return_MANY_BALL_CHAR
	#	-> return_ONE_BALL_CHAR
	#	-> return_PADDLE_CHAR
	# 	-> return_bricks_array
	#	-> return_EMPTY_CHAR
	#   -> [epilogue]

print_cell__prologue:
	push	$ra								#
	push	$s0								#
	push	$s1								#
	push	$s2								#

print_cell__body:
	move	$s0, $a0							# move row to $s0
	move 	$s1, $a1							# move col to $s1

	jal 	count_balls_at_coordinate					# call count_balls_at_coordinate function
	move	$s2, $v0							# move funcion return to $s2 as ball_count

print_cell__if_conditions:
	bgt	$s2, 1, print_cell__return_MANY_BALL_CHAR			# goto return MANY_BALL_CHAR if ball_count > 1

	beq	$s2, 1, print_cell__return_ONE_BALL_CHAR			# goto return ONE_BALL_CHAR if ball_count == 1

	li	$t0, PADDLE_ROW							# load value of PADDLE_ROW to $t0
	bne	$s0, $t0, print_cell_else_if_bricks_array			# goto bricks else if condition if row != PADDLE_ROW

	lw	$t1, paddle_x							# load address of paddle_x
	bgt	$t1, $s1, print_cell_else_if_bricks_array			# goto bricks_array condition if paddle_x > col

	add	$t1, $t1, PADDLE_WIDTH						# $t1 = paddle_x + PADDLE_WIDTH
	blt	$s1, $t1, print_cell__return_PADDLE_CHAR			# if col < $t1 goto return PADDLE_CHAR

print_cell_else_if_bricks_array:
	la 	$t2, bricks							# load bricks array into $t3
	mul	$t3, $s0, MAX_GRID_WIDTH					# calculate row offset
	add	$t3, $t3, $s1							# calculate column offset
	add	$t3, $t3, $t2							# add base address of bricks
	lb	$t4, 0($t3)							# load value at bricks[row][col] offset

	bnez	$t4, print_cell__return_bricks_array				# goto return bricks array if array != 0
	j 	print_cell__return_EMPTY_CHAR					# goto else return body

print_cell__return_MANY_BALL_CHAR:
	li 	$v0, MANY_BALL_CHAR						# return EMPTY_BALL_CHAR
	j	print_cell__epilogue						# goto epilogue

print_cell__return_ONE_BALL_CHAR:
	li 	$v0, ONE_BALL_CHAR						# return EMPTY_BALL_CHAR
	j	print_cell__epilogue						# goto epilogue
	
print_cell__return_PADDLE_CHAR:
	li 	$v0, PADDLE_CHAR						# return EMPTY_BALL_CHAR
	j	print_cell__epilogue						# goto epilogue
	
print_cell__return_bricks_array:
	sub	$t4, $t4, 1							# bricks[row][col] - 1
	li	$a2, '0'							# load '0' into $a0
	add	$v0, $a2, $t4							# '0' + (bricks[row][col] - 1)
	j	print_cell__epilogue						# goto epilogue
	
print_cell__return_EMPTY_CHAR:		
	li 	$v0, EMPTY_CHAR							# return EMPTY_BALL_CHAR
	j	print_cell__epilogue						# goto epilogue
	
print_cell__epilogue:
	pop	$s2								#
	pop	$s1								#
	pop	$s0								#
	pop	$ra								#

	jr	$ra								#


################################################################################
# .TEXT <register_screen_update> : Add a new coordinate to the list of (potentially) changed parts of the screen.
        .text
register_screen_update:
	# Subset:   2
	#
	# Frame:    [$ra, $s0, $s1]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0, $s1, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $a0, $a1]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $a0, $a1]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $s0: int x
	#   - $s1: int y
	#   - $t0: value of whole_screen_update_needed
	#   - $t1: temporary value of TRUE
	#   - $t2: value of num_screen_updates
	#   - $t3: address of whole_screen_update_needed
	#   - $t4: address of screen_updates
	#   - $t5: offset of screen_updates
	#   - $t6: offset of screen_updates[num_screens].x
	#   - $t7: offset of screen_updates[num_screens].y
	#
	# Structure:        <-- FILL THIS OUT!
	#   register_screen_update
	#   -> [prologue]
	#       -> body
	#         -> update_needed
	#   -> [epilogue]

register_screen_update__prologue:
	push	$ra								#		
	push	$s0								#
	push	$s1								#

register_screen_update__body:
	move	$s0, $a0							# move int x to $s0
	move	$s1, $a1							# move int y to $s1

	lw	$t0, whole_screen_update_needed					# load value of whole_screen_update_needed
	li	$t1, TRUE							# temporary value of FALSE
	beq	$t0, $t1, register_screen_update__epilogue			# if no update is needed return

	lw	$t2, num_screen_updates						# load value of num_screen_updates
	bge	$t2, MAX_SCREEN_UPDATES, register_screen_update__update_needed	# if num_screen_update >= MAX_SCREEN_UPDATES then update whole_screen

	la	$t4, screen_updates						# load address of struct screen_updates
	mul	$t5, $t2, SIZEOF_SCREEN_UPDATE					# offset of screen_updates[num_screen]
	add	$t5, $t5, $t4							# add offset to base address of screen_updates

	add	$t6, $t5, SCREEN_UPDATE_X_OFFSET				# offset of screen_updates[num_screen].x
	add	$t7, $t5, SCREEN_UPDATE_Y_OFFSET				# offset of screen_updates[num_screen].y

	sw	$s0, 0($t6)							# save int x to offset of screen_updates[num_screen].x
	sw	$s1, 0($t7)							# save int y to offset of screen_updates[num_screen].y

	addi	$t2, $t2, 1							# num_screen_updates++
	sw	$t2, num_screen_updates						# save value to address of num_screen_updates

	j	register_screen_update__epilogue				# goto epilogue

register_screen_update__update_needed:
	li	$t1, TRUE							# temporary value of TRUE
	la	$t3, whole_screen_update_needed					# address of whole_screen_update
	sw	$t1, 0($t3)							# whole_screen_update = TRUE

register_screen_update__epilogue:
	pop	$s1								#
	pop	$s0								#
	pop	$ra								#

	jr	$ra								#


################################################################################
# .TEXT <count_balls_at_coordinate> : Returns the total number of balls at a given coordinate in the grid. 
        .text
count_balls_at_coordinate:
	# Subset:   2
	#
	# Frame:    [$ra, $s0, $s1, $s2]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0, $s1, $s2, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9, $a0, $a1, $v0]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9, $a0, $a1, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $s0: int count
	#   - $s1: int row
	#   - $s2: int col
	#   - $t0: int i
	#   - $t1: address of balls[i]
	#   - $t2: offset of balls[i]
	#   - $t3: offset of balls[i].state
	#   - $t4: offset of balls[i].x
	#   - $t5: offset of balls[i].y
	#   - $t6: value of balls[i].state
	#   - $t7: value of BALL_NONE
	#   - $t8: value of balls[i].y
	#   - $t9: value of balls[i].x
	# Structure:        <-- FILL THIS OUT!
	#   count_balls_at_coordinate
	#   -> [prologue]
	#       -> body
	#     	  -> loop_cond
	#	    -> loop_body
	#	      -> loop_check_col
	#	    -> loop_step
	#	-> exit
	#   -> [epilogue]

count_balls_at_coordinate__prologue:
	push 	$ra								#
	push	$s0								#
	push 	$s1								#
	push 	$s2								#

count_balls_at_coordinate__body:
	li	$s0, 0								# int count = 0
	li	$t0, 0								# int i = 0

	move	$s1, $a0							# move int row to $s1
	move	$s2, $a1							# move int col to $s2

count_balls_at_coordinate__loop_cond:
	bge	$t0, MAX_BALLS, count_balls_at_coordinate__exit			# if i >= MAX_BALLS exit loop

count_balls_at_coordinate__loop_body:
	la	$t1, balls							# load address of balls
	mul	$t2, $t0, SIZEOF_BALL						# offset of balls[i]
	add	$t1, $t1, $t2							# add offset to address of balls

	add	$t3, $t1, BALL_STATE_OFFSET					# offset of balls[i].state
	add	$t4, $t1, BALL_X_OFFSET						# offset of balls[i].x
	add	$t5, $t1, BALL_Y_OFFSET						# offset of balls[i].y

	lb	$t6, 0($t3)							# load value of balls[i].state
	li	$t7, BALL_NONE							# load immediate value of BALL_NONE
	beq	$t6, $t7, count_balls_at_coordinate__loop_step			# if balls[i].state == BALL_NONE goto loop step

	lw	$t8, 0($t5)							# load value held at balls[i].y
	beq	$t8, $s1, count_balls_at_coordinate__loop_check_col		# if balls[i].y == row goto check col
	j	count_balls_at_coordinate__loop_step				# else goto loop step

count_balls_at_coordinate__loop_check_col:
	lw	$t9, 0($t4)							# load value held at balls[i].x
	bne	$t9, $s2, count_balls_at_coordinate__loop_step			# if balls[i].x != col goto loop step

	addi	$s0, $s0, 1							# count++

count_balls_at_coordinate__loop_step:
	addi	$t0, $t0, 1							# i++
	j 	count_balls_at_coordinate__loop_cond				# goto loop cond

count_balls_at_coordinate__exit:
	move	$v0, $s0							# move count to $v0

count_balls_at_coordinate__epilogue:
	pop	$s2								#
	pop	$s1								#
	pop	$s0								#
	pop	$ra								#

	jr	$ra								#


################################################################################
# .TEXT <print_game> : Print out the full grid, as well as the current score.
        .text
print_game:
	# Subset:   2
	#
	# Frame:    [$ra, $s0, $s1]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0, $s1, $t0, $a0, $a1, $v0]
	# Clobbers: [$t0, $a0, $a1, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $s0: int row
	#   - $s1: int col
	#   - $t0: value of grid_width
	#
	# Structure:        <-- FILL THIS OUT!
	#   print_game
	#   -> [prologue]
	#       -> body
	# 	-> row_loop_cond
	# 	  -> row_loop_body
	# 	  -> col_loop_cond
	#	    -> col_loop_body
	#	       -> GRID_TOP_CHAR
	#	       -> GRID_SIDE_CHAR
	#	    -> col_loop_step
	#	-> col_loop_exit
	#   -> [epilogue]

print_game__prologue:
	push	$ra								#
	push	$s0								#
	push	$s1								#

print_game__body:	
	la	$a0, str_print_game_score					# load (" SCORE ")
	li 	$v0, 4								# print string
	syscall									#

	lw	$a0, score							# load value of score
	li 	$v0, 1								# print string
	syscall	

	li	$v0, 11								# syscall 11: print_char
	li	$a0, '\n'							#
	syscall									# printf("%c", '\n');

	li	$s0, -1								# int row = -1

print_game__body_row_loop_cond:
	bge	$s0, GRID_HEIGHT, print_game__epilogue				# if row >= GRID_HEIGHT exit row loop

print_game__body_row_loop_body:
	li	$s1, -1								# int col = -1

print_game__body_col_loop_cond:
	lw	$t0, grid_width							# load value of grid_width
	bgt	$s1, $t0, print_game__body_col_loop_exit			# if col > grid_width exit col loop

print_game__body_col_loop_body:
	beq	$s0, -1, print_game__body_GRID_TOP_CHAR				# if row == -1 goto print_game__body_GRID_TOP_CHAR

	beq	$s1, -1, print_game__body_GRID_SIDE_CHAR			# if col == -1 goto print_game__body_GRID_SIDE_CHAR
	beq	$s1, $t0, print_game__body_GRID_SIDE_CHAR			# if col == grid_width goto print_game__body_GRID_SIDE_CHAR

	move	$a0, $s0							# move row to $a0
	move	$a1, $s1							# move col to $a1

	jal 	print_cell							# gotofunction print_cell
	move 	$a0, $v0							# move function return value to $a0	
	li	$v0, 11								# syscall 11: print_char
	syscall									# printf("%c", print_cell(row,col))

	j	print_game_col_loop_step					# goto col loop step

print_game__body_GRID_TOP_CHAR:
	li	$v0, 11								# syscall 11: print_char
	li	$a0, GRID_TOP_CHAR						#
	syscall									# printf("%c", '=');

	j	print_game_col_loop_step					# goto col loop step

print_game__body_GRID_SIDE_CHAR:
	li	$v0, 11								# syscall 11: print_char
	li	$a0, GRID_SIDE_CHAR						#
	syscall									# printf("%c", '|');

	j	print_game_col_loop_step					# goto col loop step

print_game_col_loop_step:
	addi	$s1, $s1, 1							# col++
	j	print_game__body_col_loop_cond					# loop back to col cond

print_game__body_col_loop_exit:
	add	$s0, $s0, 1							# row++
	
	li	$v0, 11								# syscall 11: print_char
	li	$a0, '\n'							#
	syscall									# printf("%c", '\n');

	j	print_game__body_row_loop_cond					# loop back to row cond
print_game__epilogue:
	pop	$s1								#
	pop	$s0								#
	pop	$ra								#

	jr	$ra								#


################################################################################
# .TEXT <spawn_new_ball> : Add a new ball to the `balls` array. Returns TRUE if there was an unused 
#                          slot and FALSE if there wasn't, so no ball could be created.
        .text
spawn_new_ball:
	# Subset:   2
	#
	# Frame:    [$ra, $s0]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $a0, $a1, $v0]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $a0, $a1, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $s0: new_ball
	#   - $t0: int i, BALL_FRACTION
	#   - $t1: address of balls[i], - BALL_FRACTION
	#   - $t2: offset of balls[i], value of new_ball->dy
	#   - $t3: value of balls[i].state, value of new_ball->dx 
	#   - $t4: value of new_ball->state, value of grid_width
	#   - $t5: value of new_ball->y, value of new_ball->dx *= -1
	#   - $t6: value of new_ball->x
	#   - $t7: value of new_ball->x_fraction and new_ball->y_fraction
	#
	# Structure:        <-- FILL THIS OUT!
	#   spawn_new_ball
	#   -> [prologue]
	#       -> body
	# 	  -> loop
	# 	  -> loop_step
	# 	-> newball_parameters
	# 	-> newball_movement
	#	  -> exit_newball_TRUE
	#	  -> exit_newball_FALSE
	#   -> [epilogue]

spawn_new_ball__prologue:		
	push	$ra								#
	push	$s0								#

spawn_new_ball__body:
	li	$s0, NULL							# hold the value of new_ball
	li	$t0, 0								# int i = 0

spawn_new_ball__body_loop:
	bge	$t0, MAX_BALLS, spawn_new_ball__body_newball_parameters		# if i >= MAX_BALLS exit loop

	la	$t1, balls							# load address of balls
	mul	$t2, $t0, SIZEOF_BALL						# calculate offset of balls[i]
	add	$t1, $t2, $t1							# add offset to base address balls

	add	$t2, $t1, BALL_STATE_OFFSET					# add offset of balls.state to balls[i]
	lb	$t3, 0($t2)							# load value held at balls[i].state

	bne	$t3, BALL_NONE, spawn_new_ball__body_loop_step			# if balls[i].state != BALL_NONE goto loop step

	move	$s0, $t1							# save the address of balls[i] to new_ball

	j	spawn_new_ball__body_newball_parameters				# break out of loop

spawn_new_ball__body_loop_step:
	addi	$t0, $t0, 1							# i++
	j	spawn_new_ball__body_loop					# loop back to condition

spawn_new_ball__body_newball_parameters:
	beq	$s0, NULL, spawn_new_ball__body_exit_newball_FALSE		# if new_ball == NULL goto exit function as FALSE

	li	$t4, BALL_NORMAL						# load immediate $t4 as BALL_NOPRMAL
	sb	$t4, BALL_STATE_OFFSET($s0)					# save $t4 as new_ball->state

	li	$t5, PADDLE_ROW							# load immediate $t5 as PADDLE_ROW
	sub	$t5, $t5, 1							# PADDLE_ROW--
	sw	$t5, BALL_Y_OFFSET($s0)						# save value of $t4 to new_ball->y

	lw	$t6, grid_width							# load vale $t6 as grid_width
	div	$t6, $t6, 2							# grid_width / 2
	sw	$t6, BALL_X_OFFSET($s0)						# save value of $t6 to new_ball->x

	li	$t7, BALL_FRACTION						# load immediate $t7 as BALL_FRACTION
	div	$t7, $t7, 2							# BALL_FRACTION / 2

	sw	$t7, BALL_X_FRAC_OFFSET($s0)					# save value of $t7 to new_ball->x_fraction
	sw	$t7, BALL_Y_FRAC_OFFSET($s0)					# save value of $t7 to new_ball->y_fraction

	move	$a0, $t6							# move new_ball->x to $a0
	move	$a1, $t5							# move new_ball->y to $a1
	jal	register_screen_update						# call function register_screen_update

spawn_new_ball__body_newball_movement:
	li	$t0, BALL_FRACTION						# load immediate $t0 = BALL_FRACTION
	neg	$t1, $t0							# - BALL_FRACTION
	div	$t2, $t1, BALL_SIM_STEPS					# - BALL_FRACTION / BALL_SIM_STEPS

	sw	$t2, BALL_DY_OFFSET($s0)					# new_ball->dy = - BALL_FRACTION / BALL_SIM_STEPS

	div	$t3, $t0, BALL_SIM_STEPS					# BALL_FRACTION / BALL_SIM_STEPS
	div	$t3, $t3, 4							# BALL_FRACTION / BALL_SIM_STEPS / 4

	sw	$t3, BALL_DX_OFFSET($s0)					# new_ball->dx = BALL_FRACTION / BALL_SIM_STEPS / 4

	lw	$t4, grid_width							# load value of grid_width
	rem	$t4, $t4, 2							# grid_width % 2
	bnez	$t4, spawn_new_ball__body_exit_newball_TRUE			# if grid_width % 2 != 0 skip new_ball->dx *= -1

	lw	$t5, BALL_DX_OFFSET($s0)					# load value of new_ball->dx
	mul	$t5, $t5, -1							# *= -1
	sw	$t5, BALL_DX_OFFSET($s0)					# save value of new_ball->dx

spawn_new_ball__body_exit_newball_TRUE:
	li	$v0, TRUE							# load immediate $v0 as TRUE
	j	spawn_new_ball__epilogue					# goto epilogue

spawn_new_ball__body_exit_newball_FALSE:
	li	$v0, FALSE							# load immediate $v0 as FALSE

spawn_new_ball__epilogue:
	pop	$s0								#
	pop	$ra								#

	jr	$ra								#


################################################################################
# .TEXT <move_balls> : Handle the movement of all balls in both axis for `sim_steps` steps.
        .text
move_balls:
	# Subset:   2
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0, $s1, $s2, $s3, $t0, $t1, $t2, $t3, $t4, $t5, $a0, $a1, $s2, $s3]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $t5, $a0, $a1, $s2, $s3]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $s0: int step
	#   - $s1: int sim_steps
	#   - $s2: int i
	#   - $s3: struct ball *ball 
	#   - $t1: address of balls
	#   - $t2: offset of balls[i]
	#   - $t3: value of balls[i].state
	#   - $t4: value of ball->y
	#   - $t5: value of BALL_NONE for ball->state
	# Structure:        <-- FILL THIS OUT!
	#   move_balls
	#   -> [prologue]
	#       -> body
	# 	  -> step_loop_cond
	# 	    -> inner_loop_init
	# 	    -> inner_loop_cond
	# 	    -> inner_loop_step
	# 	  -> step_loop_step
	#   -> [epilogue]

move_balls__prologue:
	push	$ra								#
	push	$s0								#
	push	$s1								#
	push	$s2								#
	push	$s3								#

move_balls__body:
	li	$s0, 0								# int step = 0
	move	$s1, $a0							# move sim_steps to s1

move_balls__body_step_loop_cond:
	bge	$s0, $s1, move_balls__epilogue					# if step >= sim_steps exit for loop

move_balls__body_inner_loop_init:
	li	$s2, 0								# int i = 0

move_balls__body_inner_loop_cond:
	bge	$s2, MAX_BALLS, move_balls__body_step_loop_step			# if i >= MAX_BALLS goto outer loop step

	la	$t1, balls							# load address of balls
	mul	$t2, $s2, SIZEOF_BALL						# offset of i * SIZEOF_BALL
	add	$t1, $t2, $t1							# offset of ball[i]

	move	$s3, $t1							# struct ball *ball = &balls[i]

	lb	$t3, BALL_STATE_OFFSET($s3)					# load value of ball[i].state
	beq	$t3, BALL_NONE, move_balls__body_inner_loop_step		# continue to outer loop step if balls[i].state == BALL_NONE

	move	$a0, $s3							# move ball to $a0
	li	$a1, VERTICAL							# load immediate value of VERTICAL
	la	$a2, BALL_Y_FRAC_OFFSET($s3)					# load ball->y_fraction
	lw	$a3, BALL_DY_OFFSET($s3)					# load ball->dy
	jal	move_ball_in_axis						# call function move_ball_in_axis

	move	$a0, $s3							# move ball to $a0
	li	$a1, HORIZONTAL							# load immediate value of HORIZONTAL
	la	$a2, BALL_X_FRAC_OFFSET($s3)					# load ball->x_fraction
	lw	$a3, BALL_DX_OFFSET($s3)					# load ball->dx
	jal	move_ball_in_axis						# call function move_ball_in_axis

	lw	$t4, BALL_Y_OFFSET($s3)						# load ball->y to $t4
	ble	$t4, GRID_HEIGHT, move_balls__body_inner_loop_step		# if ball->y <= GRID_HEIGHT goto loop step

	li	$t5, BALL_NONE							# load value of BALL_NONE
	sb	$t5, BALL_STATE_OFFSET($s3)					# save byte to ball->state 

move_balls__body_inner_loop_step:
	addi	$s2, $s2, 1							# i++
	j 	move_balls__body_inner_loop_cond				# loop back to inner loop cond

move_balls__body_step_loop_step:
	addi	$s0, $s0, 1							# step++
	j	move_balls__body_step_loop_cond					# loop back to outer loop cond

move_balls__epilogue:	
	pop	$s3								#
	pop	$s2								#
	pop	$s1								#
	pop	$s0								#
	pop	$ra								#

	jr	$ra								#


################################################################################
# .TEXT <move_ball_in_axis> : Handle all the movement of the ball in one axis (HORIZONTAL/VERTICAL) by `delta` amount.
        .text
move_ball_in_axis:
	# Subset:   3
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0, $s1, $s2, $s3, $t0, $t1, $t2, $a0, $a1, $a2, $a3]
	# Clobbers: [$t0, $t1, $t2, $a0, $a1, $a2, $a3]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $s0: struct ball *ball
	#   - $s1: int axis
	#   - $s2: int *fraction
	#   - $s3: int delta
	#   - $t0: value of *fraction += delta
	#   - $t1: value of *fraction += BALL_FRACTION
	#   - $t2: value of *fraction -= BALL_FRACTION
	#
	# Structure:        <-- FILL THIS OUT!
	#   move_ball_in_axis
	#   -> [prologue]
	#       -> body
	# 	  -> if
	# 	  -> else_if
	#   -> [epilogue]

move_ball_in_axis__prologue:
	push	$ra								#
	push	$s0								#
	push	$s1								#
	push	$s2								#

move_ball_in_axis__body:
	move	$s0, $a0							# move struct ball *ball into $s0
	move	$s1, $a1							# move axis into $s1
	move	$s2, $a2							# move *fraction into $s2
	move 	$s3, $a3							# move delta into $s3

	lw	$t0, 0($s2)							# load the value of fraction to $t0
	add	$t0, $t0, $s3							# *fraction += delta
	sw	$t0, 0($s2)							# save delta to the *fraction

move_ball_in_axis__body_if:
	lw	$t1, 0($s2)							# load the value of fraction
	bgez	$t1, move_ball_in_axis__body_else_if				# if *fraction >= 0 goto else if condition

	add	$t1, $t1, BALL_FRACTION						# *fraction += BALL_FRACTION
	sw	$t1, 0($s2)							# save *fraction += BALL_FRACTION to *fraction

	move	$a0, $s0							# load ball to $a0
	move	$a1, $s1							# load axis to $a1
	li	$a2, -1								# load -1 to $a2
	jal	move_ball_one_cell						# function call move_ball_one_cell

	j	move_ball_in_axis__body_if					# goto loop start of loop

move_ball_in_axis__body_else_if:
	lw	$t2, 0($s2)							# load the value of fraction
	blt	$t2, BALL_FRACTION, move_ball_in_axis__epilogue			# if *fraction < BALL_FRACTION goto else condition

	sub	$t2, $t2, BALL_FRACTION						# *fraction -= BALL_FRACTION
	sw	$t2, 0($s2)							# save *fraction -= BALL_FRACTION to *fraction

	move	$a0, $s0							# load ball to $a0
	move	$a1, $s1							# load axis to $a1
	li	$a2, 1								# load 1 to $a2
	jal	move_ball_one_cell						# function call move_ball_one_cell

	j	move_ball_in_axis__body_if					# goto loop increment

move_ball_in_axis__epilogue:
	pop	$s2								#
	pop	$s1								#
	pop	$s0								#
	pop	$ra								#

	jr	$ra								#


################################################################################
# .TEXT <hit_brick> : Handle the actions needed when a ball collides with a brick.
        .text
hit_brick:
	# Subset:   3
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3, $s4, $s5]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0, $s1, $s2, $s3, $s4, $s5, $t0, $t1, $t2, $t3, $t3, $t4, $a0, $a1, $v0]
	# Clobbers: [$t0, $t1, $t2, $t3, $t3, $t4, $a0, $a1, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $s0: original_col
	#   - $s1: row
	#   - $s2: brick_num
	#   - $s3: col
	#   - $s4: bricks_destroyed 
	#   - $s5: grid_width
	#   - $t0: address of bricks
	#   - $t1: bricks offset
	#   - $t2: value at bricks[row][col]
	#   - $t3: immediate value of 0
	#   - $t4: temporary value of bricks_destroyed % 10
	#
	# Structure:        <-- FILL THIS OUT!
	#   hit_brick
	#   -> [prologue]
	#       -> body
	# 	  -> right_loop_init
	# 	    -> right_loop_cond
	# 	    -> right_loop_body
	# 	    -> right_loop_step
	# 	  -> left_loop_init
	# 	    -> left_loop_cond
	# 	    -> left_loop_body
	# 	    -> left_loop_step
	# 	  -> loop_exit
	# 	  -> spawn_new_ball
	#   -> [epilogue]

hit_brick__prologue:
	push	$ra								#
	push	$s0								#
	push	$s1								#
	push	$s2								#
	push	$s3								#
	push	$s4								#
	push	$s5

hit_brick__body:
	move	$s0, $a0							# move original_col into $s0
	move	$s1, $a1							# move row into $s1

	la	$t0, bricks							# load address of bricks
	lw	$s5, grid_width							# load value of grid_width
	mul	$t1, $s1, $s5							# offset of bricks[row]
	add	$t1, $t1, $s0							# offset of bricks[row][original_col]
	add	$t0, $t1, $t0							# add offset to base address
	lb	$t2, 0($t0)							# load value of bricks[row][original_col]

	move	$s2, $t2							# int brick_num = bricks[row][original_col]

hit_brick__right_loop_init:
	move	$s3, $s0							# col = original_col

hit_brick__right_loop_cond:
	bge	$s3, $s5, hit_brick__left_loop_init				# if col >= grid_width exit loop and goto next loop

	la	$t0, bricks							# load address of bricks
	mul	$t1, $s1, MAX_GRID_WIDTH					# calculate offset of bricks[row]
	add	$t1, $t1, $s3							# offset of bricks[row][col]
	add	$t0, $t1, $t0							# add offset to base address
	lb	$t2, 0($t0)							# load value at bricks[row][col]

	bne	$t2, $s2, hit_brick__left_loop_init				# if bricks[row][col] != brick_num goto next loop
	j	hit_brick__right_loop_body					# else continue to right loop body

hit_brick__right_loop_body:
	li	$t3, 0								# load immediate $t3 = 0
	sb	$t3, 0($t0)							# save bricks[row][col] = 0

	move	$a0, $s3							# move value of col to $a0
	move	$a1, $s1							# move value of row to $a1
	jal	register_screen_update						# goto function call register_screen_update

hit_brick__right_loop_step:
	addi	$s3, $s3, 1							# col++

	j	hit_brick__right_loop_cond					# loop through right loop cond

hit_brick__left_loop_init:
	add	$s3, $s0, -1							# col = original_col - 1

hit_brick__left_loop_cond:
	bltz	$s3, hit_brick__loop_exit					# if col < 0 exit loop 

	la	$t0, bricks							# load address of bricks
	mul	$t1, $s1, MAX_GRID_WIDTH					# calculate offset of bricks[row]
	add	$t1, $t1, $s3							# offset of bricks[row][col]
	add	$t0, $t1, $t0							# add offset to base address
	lb	$t2, 0($t0)							# load value at bricks[row][col]

	bne	$t2, $s2, hit_brick__loop_exit					# if bricks[row][col] != brick_num exit loop
	j	hit_brick__left_loop_body					# else continue to right loop body

hit_brick__left_loop_body:
	li	$t3, 0								# load immediate $t3 = 0
	sb	$t3, 0($t0)							# save bricks[row][col] = 0

	move	$a0, $s3							# move value of col to $a0
	move	$a1, $s1							# move value of row to $a1
	jal	register_screen_update						# goto function call register_screen_update

hit_brick__left_loop_step:
	addi	$s3, $s3, -1							# col--

	j	hit_brick__left_loop_cond					# loop through left loop cond

hit_brick__loop_exit:
	lw	$s4, bricks_destroyed						# load address of bricks_destroyed
	addi	$s4, $s4, 1							# brick_destroyed++
	sw	$s4, bricks_destroyed						# save value of bricks_destroyed

	rem	$t4, $s4, 10							# bricks_destroyed % 10
	beqz	$t4, hit_brick__spawn_new_ball					# if bricks_destroyed % 10 == 0 goto spawn new ball

	j 	hit_brick__epilogue						# else goto epilogue

hit_brick__spawn_new_ball:
	jal	spawn_new_ball							# goto function call spawn_new_ball
	beq	$v0, TRUE, hit_brick__epilogue					# if spawn_new_ball() == FALSE goto epilogue

	li	$v0, 11								# syscall 11: print_char
	li	$a0, '\n'							#
	syscall									# printf("%c", '\n');

	la	$a0, str_hit_brick_bonus_ball					# load ("\n!! Bonus ball !!\n")
	li 	$v0, 4								# print string
	syscall

	li	$v0, 11								# syscall 11: print_char
	li	$a0, '\n'							#
	syscall									# printf("%c", '\n');

hit_brick__epilogue:
	pop	$s5								#
	pop	$s4								#
	pop	$s3								#
	pop	$s2								#
	pop	$s1								#
	pop	$s0								#
	pop	$ra								#

	jr	$ra								#


################################################################################
# .TEXT <check_ball_paddle_collision>
        .text
check_ball_paddle_collision:
	# Subset:   3
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   check_ball_paddle_collision
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

check_ball_paddle_collision__prologue:

check_ball_paddle_collision__body:

check_ball_paddle_collision__epilogue:
	jr	$ra


################################################################################
# .TEXT <move_ball_one_cell>
        .text
move_ball_one_cell:
	# Subset:   3
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   move_ball_one_cell
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

move_ball_one_cell__prologue:

move_ball_one_cell__body:

move_ball_one_cell__epilogue:
	jr	$ra


################################################################################
################################################################################
###                   PROVIDED FUNCTIONS — DO NOT CHANGE                     ###
################################################################################
################################################################################

################################################################################
# .TEXT <run_command>
        .text
run_command:
	# Provided
	#
	# Frame:    [$ra]
	# Uses:     [$ra, $t0, $a0, $v0]
	# Clobbers: [$t0, $a0, $v0]
	#
	# Locals:
	#   - $t0: char command
	#
	# Structure:
	#   run_command
	#   -> [prologue]
	#     -> body
	#       -> cmd_a
	#       -> cmd_d
	#       -> cmd_A
	#       -> cmd_D
	#       -> cmd_dot
	#       -> cmd_semicolon
	#       -> cmd_comma
	#       -> cmd_question_mark
	#       -> cmd_s
	#       -> cmd_h
	#       -> cmd_p
	#       -> cmd_q
	#       -> bad_cmd
	#       -> ret_true
	#   -> [epilogue]

run_command__prologue:
	push	$ra

run_command__body:
	li	$v0, 4						# syscall 4: print_string
	li	$a0, str_run_command_prompt			# " >> "
	syscall							# printf(" >> ");

	li	$v0, 12						# syscall 4: read_character
	syscall							# scanf(" %c",
	move	$t0, $v0					#              &command);

	beq	$t0, 'a', run_command__cmd_a			# if (command == 'a') { ...
	beq	$t0, 'd', run_command__cmd_d			# } else if (command == 'd') { ...
	beq	$t0, 'A', run_command__cmd_A			# } else if (command == 'A') { ...
	beq	$t0, 'D', run_command__cmd_D			# } else if (command == 'D') { ...
	beq	$t0, '.', run_command__cmd_dot			# } else if (command == '.') { ...
	beq	$t0, ';', run_command__cmd_semicolon		# } else if (command == ';') { ...
	beq	$t0, ',', run_command__cmd_comma		# } else if (command == ',') { ...
	beq	$t0, '?', run_command__cmd_question_mark	# } else if (command == '?') { ...
	beq	$t0, 's', run_command__cmd_s			# } else if (command == 's') { ...
	beq	$t0, 'h', run_command__cmd_h			# } else if (command == 'h') { ...
	beq	$t0, 'p', run_command__cmd_p			# } else if (command == 'p') { ...
	beq	$t0, 'q', run_command__cmd_q			# } else if (command == 'q') { ...
	b	run_command__bad_cmd				# } else { ...

run_command__cmd_a:						# if (command == 'a') {
	li	$a0, -1
	jal	move_paddle					#   move_paddle(-1);
	b	run_command__ret_true

run_command__cmd_d:						# } else if (command == 'd') { ...
	li	$a0, 1
	jal	move_paddle					#   move_paddle(1);
	b	run_command__ret_true

run_command__cmd_A:						# } else if (command == 'A') { ...
	li	$a0, -1
	jal	move_paddle					#   move_paddle(-1);
	li	$a0, -1
	jal	move_paddle					#   move_paddle(-1);
	li	$a0, -1
	jal	move_paddle					#   move_paddle(-1);
	b	run_command__ret_true

run_command__cmd_D:						# } else if (command == 'D') { ...
	li	$a0, 1
	jal	move_paddle					#   move_paddle(1);
	li	$a0, 1
	jal	move_paddle					#   move_paddle(1);
	li	$a0, 1
	jal	move_paddle					#   move_paddle(1);
	b	run_command__ret_true

run_command__cmd_dot:						# } else if (command == '.') { ...
	li	$a0, BALL_SIM_STEPS
	jal	move_balls					#   move_balls(BALL_SIM_STEPS);
	b	run_command__ret_true

run_command__cmd_semicolon:					# } else if (command == ';') { ...
	li	$a0, BALL_SIM_STEPS
	mul	$a0, $a0, 3					#   BALL_SIM_STEPS * 3
	jal	move_balls					#   move_balls(BALL_SIM_STEPS * 3);
	b	run_command__ret_true

run_command__cmd_comma:						# } else if (command == ',') { ...
	li	$a0, 1
	jal	move_balls					#   move_balls(1);
	b	run_command__ret_true

run_command__cmd_question_mark:					# } else if (command == '?') { ...
	jal	print_debug_info				#   print_debug_info();
	b	run_command__ret_true

run_command__cmd_s:						# } else if (command == 's') { ...
	jal	print_screen_updates				#   print_screen_updates();
	b	run_command__ret_true

run_command__cmd_h:						# } else if (command == 'h') { ...
	jal	print_welcome					#   print_welcome();
	b	run_command__ret_true

run_command__cmd_p:						# } else if (command == 'p') { ...
	li	$a0, TRUE
	sw	$a0, no_auto_print				#   no_auto_print = 1;
	jal	print_game					#   print_game();
	b	run_command__ret_true

run_command__cmd_q:						# } else if (command == 'q') { ...
	li	$v0, 10						#   syscall 10: exit
	syscall							#   exit(0);

run_command__bad_cmd:						# } else { ...

	li	$v0, 4						#   syscall 4: print_string
	li	$a0, str_run_command_bad_cmd_1			#   "Bad command: '"
	syscall							#   printf("Bad command: '");

	li	$v0, 11						#   syscall 11: print_character
	move	$a0, $t0					#           command
	syscall							#   putchar(       );

	li	$v0, 4						#   syscall 4: print_string
	li	$a0, str_run_command_bad_cmd_2			#   "'. Run `h` for help.\n"
	syscall							#   printf("'. Run `h` for help.\n");

	li	$v0, FALSE
	b	run_command__epilogue				#   return FALSE;

run_command__ret_true:						# }
	li	$v0, TRUE					# return TRUE;

run_command__epilogue:
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <print_debug_info>
        .text
print_debug_info:
	# Provided
	#
	# Frame:    []
	# Uses:     [$v0, $a0, $t0, $t1, $t2, $t3]
	# Clobbers: [$v0, $a0, $t0, $t1, $t2, $t3]
	#
	# Locals:
	#   - $t0: int i, int row
	#   - $t1: struct ball *ball, int col
	#   - $t2: temporary copy of grid_width
	#   - $t3: temporary bricks[row][col] address calculations
	#
	# Structure:
	#   print_debug_info
	#   -> [prologue]
	#     -> body
	#       -> ball_loop_init
	#       -> ball_loop_cond
	#       -> ball_loop_body
	#       -> ball_loop_step
	#       -> row_loop_init
	#       -> row_loop_cond
	#       -> row_loop_body
	#         -> row_loop_init
	#         -> row_loop_cond
	#         -> row_loop_body
	#         -> row_loop_step
	#         -> row_loop_end
	#       -> row_loop_step
	#       -> row_loop_end
	#   -> [epilogue]

print_debug_info__prologue:

print_debug_info__body:
	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_1	# "      grid_width = "
	syscall					# printf("      grid_width = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, grid_width			#              grid_width
	syscall					# printf("%d",           );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_2	# "        paddle_x = "
	syscall					# printf("        paddle_x = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, paddle_x			#              paddle_x
	syscall					# printf("%d",         );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_3	# "bricks_destroyed = "
	syscall					# printf("bricks_destroyed = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, bricks_destroyed		#              bricks_destroyed
	syscall					# printf("%d",                 );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_4	# "    total_bricks = "
	syscall					# printf("    total_bricks = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, total_bricks		#              total_bricks
	syscall					# printf("%d",             );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_5	# "           score = "
	syscall					# printf("           score = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, score			#              score
	syscall					# printf("%d",      );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_6	# "     combo_bonus = "
	syscall					# printf("     combo_bonus = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, combo_bonus		#              combo_bonus
	syscall					# printf("%d",            );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_7	# "        num_screen_updates = "
	syscall					# printf("        num_screen_updates = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, num_screen_updates		#              num_screen_updates
	syscall					# printf("%d",                   );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_8	# "whole_screen_update_needed = "
	syscall					# printf("whole_screen_update_needed = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, whole_screen_update_needed	#              whole_screen_update_needed
	syscall					# printf("%d",                           );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');
	syscall					# putchar('\n');

print_debug_info__ball_loop_init:
	li	$t0, 0				# int i = 0;

print_debug_info__ball_loop_cond:		# while (i < MAX_BALLS) {
	bge	$t0, MAX_BALLS, print_debug_info__ball_loop_end

print_debug_info__ball_loop_body:
	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_9	#   "ball["
	syscall					#   printf("ball[");

	li	$v0, 1				#   sycall 1: print_int
	move	$a0, $t0			#                i
	syscall					#   printf("%d",  );

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_21	#   "]:\n"
	syscall					#   printf("]:\n");

	mul	$t1, $t0, SIZEOF_BALL		#   i * sizeof(struct ball)
	addi	$t1, $t1, balls			#   ball = &balls[i]

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_10	#   "  y: "
	syscall					#   printf("  y: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_Y_OFFSET($t1)		#   ball->y
	syscall					#   printf("%d", ball->y);

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_11	#   "  x: "
	syscall					#   printf("  x: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_X_OFFSET($t1)		#   ball->x
	syscall					#   printf("%d", ball->x);

	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_12	#   "  x_fraction: "
	syscall					#   printf("  x_fraction: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_X_FRAC_OFFSET($t1)	#   ball->x_fraction
	syscall					#   printf("%d", ball->x_fraction);

	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_13	#   "  y_fraction: "
	syscall					#   printf("  y_fraction: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_Y_FRAC_OFFSET($t1)	#   ball->y_fraction
	syscall					#   printf("%d", ball->y_fraction);

	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_14	#   "  dy: "
	syscall					#   printf("  dy: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_DY_OFFSET($t1)	#   ball->dy
	syscall					#   printf("%d", ball->dy);

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_15	#   "  dx: "
	syscall					#   printf("  dx: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_DX_OFFSET($t1)	#   ball->dx
	syscall					#   printf("%d", ball->dx);

	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_16	#   "  state: "
	syscall					#   printf("  state: ");

	li	$v0, 1				#   sycall 1: print_int
	lb	$a0, BALL_STATE_OFFSET($t1)	#   ball->state
	syscall					#   printf("%d", ball->state);

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_17	#   " ("
	syscall					#   printf(" (");

	li	$v0, 11				#   sycall 11: print_character
	lb	$a0, BALL_STATE_OFFSET($t1)	#   ball->state
	syscall					#   printf("%c", ball->state);

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_18	#   ")\n"
	syscall					#   printf(")\n");

print_debug_info__ball_loop_step:
	addi	$t0, $t0, 1			#   i++;
	b	print_debug_info__ball_loop_cond

print_debug_info__ball_loop_end:		# }


print_debug_info__row_loop_init:
	li	$t0, 0				# int row = 0;

print_debug_info__row_loop_cond:		# while (row < GRID_HEIGHT) {
	bge	$t0, GRID_HEIGHT, print_debug_info__row_loop_end

print_debug_info__row_loop_body:
	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_19	#   "\nbricks["
	syscall					#   printf("\nbricks[");

	li	$v0, 1				#   sycall 1: print_int
	move	$a0, $t0			#                i
	syscall					#   printf("%d",  );

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_20	#   "]: "
	syscall					#   printf("]: ");

print_debug_info__col_loop_init:
	li	$t1, 0				#   int col = 0;

print_debug_info__col_loop_cond:		#   while (col < grid_width) {
	lw	$t2, grid_width
	bge	$t1, $t2, print_debug_info__col_loop_end

print_debug_info__col_loop_body:
	mul	$t3, $t0, MAX_GRID_WIDTH	#     row * MAX_GRID_WIDTH
	add	$t3, $t3, $t1			#     row * MAX_GRID_WIDTH + row
	addi	$t3, $t3, bricks		#     &bricks[row][col]

	li	$v0, 1				#     sycall 1: print_int
	lb	$a0, ($t3)			#     bricks[row][col]
	syscall					#     printf("%d", bricks[row][col]);

	li	$v0, 11				#     sycall 11: print_character
	li	$a0, ' '
	syscall					#     printf(" ");

print_debug_info__col_loop_step:
	addi	$t1, $t1, 1			#     row++;
	b	print_debug_info__col_loop_cond

print_debug_info__col_loop_end:			#   }

print_debug_info__row_loop_step:
	addi	$t0, $t0, 1			#   row++;
	b	print_debug_info__row_loop_cond

print_debug_info__row_loop_end:			# }
	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

print_debug_info__epilogue:
	jr	$ra


################################################################################
# .TEXT <print_screen_updates>
        .text
print_screen_updates:
	# Provided
	#
	# Frame:    [$ra, $s0, $s1, $s2]
	# Uses:     [$ra, $s0, $s1, $s2, $t0, $t1, $t2, $t3, $t4, $v0, $a0]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $v0, $a0]
	#
	# Locals:
	#   - $t0: print_cell return value, temporary screen_updates address calculations
	#   - $t1: copy of num_screen_updates
	#   - $t2: copy of whole_screen_update_needed
	#   - $t3: copy of grid_width
	#   - $t4: FALSE/0
	#   - $s0: int row, int i
	#   - $s1: int col, int y
	#   - $s2: int x
	#
	# Structure:
	#   print_screen_updates
	#   -> [prologue]
	#       -> body
	#       -> whole_screen
	#         -> row_loop_init
	#         -> row_loop_cond
	#         -> row_loop_body
	#           -> col_loop_init
	#           -> col_loop_cond
	#           -> col_loop_body
	#           -> col_loop_step
	#           -> col_loop_end
	#         -> row_loop_step
	#         -> row_loop_end
	#       -> not_whole_screen
	#         -> update_loop_init
	#         -> update_loop_cond
	#         -> update_loop_body
	#         -> update_loop_step
	#         -> update_loop_end
	#       -> final_newline
	#   -> [epilogue]

print_screen_updates__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2

print_screen_updates__body:
	li	$v0, 11							# sycall 11: print_character
	li	$a0, '&'
	syscall								# putchar('&');

	li	$v0, 1							#   syscall 1: print_int
	lw	$a0, score						#                score
	syscall								#   printf("%d",      );

	lw	$t2, whole_screen_update_needed

	beqz	$t2, print_screen_updates__not_whole_screen		# if (whole_screen_update_needed) {

print_screen_updates__whole_screen:
print_screen_updates__row_loop_init:
	li	$s0, 0							#   int row = 0;

print_screen_updates__row_loop_cond:
	bge	$s0, GRID_HEIGHT, print_screen_updates__row_loop_end	#   while (row < GRID_HEIGHT) {

print_screen_updates__row_loop_body:
print_screen_updates__col_loop_init:
	li	$s1, 0							#     int col = 0;

print_screen_updates__col_loop_cond:
	lw	$t3, grid_width
	bge	$s1, $t3, print_screen_updates__col_loop_end		#     while (col < grid_width) {

print_screen_updates__col_loop_body:
	move	$a0, $s0						#       row
	move	$a1, $s1						#       col
	jal	print_cell						#       print_cell(row, col);
	move	$t0, $v0

	li	$v0, 11							#       sycall 11: print_character
	li	$a0, ' '
	syscall								#       printf(" ");

	li	$v0, 1							#       sycall 1: print_int
	move	$a0, $s0						#                    row
	syscall								#       printf("%d",    );

	li	$v0, 11							#       sycall 11: print_character
	li	$a0, ' '
	syscall								#       printf(" ");

	li	$v0, 1							#       sycall 1: print_int
	move	$a0, $s1						#                    col
	syscall								#       printf("%d",    );

	li	$v0, 11							#       sycall 11: print_character
	li	$a0, ' '
	syscall								#       printf(" ");

	li	$v0, 1							#       sycall 1: print_int
	move	$a0, $t0						#                    print_cell(...)
	syscall								#       printf("%d",                );

print_screen_updates__col_loop_step:

	addi	$s1, $s1, 1						#       col++;
	b	print_screen_updates__col_loop_cond			#     }

print_screen_updates__col_loop_end:
print_screen_updates__row_loop_step:
	addi	$s0, $s0, 1						#     row++;
	b	print_screen_updates__row_loop_cond			#   }


print_screen_updates__row_loop_end:
	b	print_screen_updates__final_newline			# } else {

print_screen_updates__not_whole_screen:
print_screen_updates__update_loop_init:
	li	$s0, 0							#   int i = 0;

print_screen_updates__update_loop_cond:
	lw	$t1, num_screen_updates
	bge	$s0, $t1, print_screen_updates__update_loop_end		#   while (i < num_screen_updates) {

print_screen_updates__update_loop_body:
	mul	$t0, $s0, SIZEOF_SCREEN_UPDATE				#     i * sizeof(struct screen_update)
	addi	$t0, $t0, screen_updates				#     &screen_updates[i]

	lw	$s1, SCREEN_UPDATE_Y_OFFSET($t0)			#     int y = screen_updates[i].y;
	lw	$s2, SCREEN_UPDATE_X_OFFSET($t0)			#     int x = screen_updates[i].x;

									#     if (y >= GRID_HEIGHT) continue;
	bge	$s1, GRID_HEIGHT, print_screen_updates__update_loop_step

	bltz	$s2, print_screen_updates__update_loop_step		#     if (x < 0) continue;

									#     if (x >= MAX_GRID_WIDTH) continue;
	bge	$s2, MAX_GRID_WIDTH, print_screen_updates__update_loop_step

	move	$a0, $s1						#     y
	move	$a1, $s2						#     x
	jal	print_cell						#     print_cell(y, x);
	move	$t0, $v0

	li	$v0, 11							#     sycall 11: print_character
	li	$a0, ' '
	syscall								#     printf(" ");

	li	$v0, 1							#     sycall 1: print_int
	move	$a0, $s1						#                  y
	syscall								#     printf("%d",  );

	li	$v0, 11							#     sycall 11: print_character
	li	$a0, ' '
	syscall								#     printf(" ");

	li	$v0, 1							#     sycall 1: print_int
	move	$a0, $s2						#                  x
	syscall								#     printf("%d",  );

	li	$v0, 11							#     sycall 11: print_character
	li	$a0, ' '
	syscall								#     printf(" ");

	li	$v0, 1							#     sycall 1: print_int
	move	$a0, $t0						#                  print_cell(...)
	syscall								#     printf("%d",                );

print_screen_updates__update_loop_step:
	addi	$s0, $s0, 1						#     col++;
	b	print_screen_updates__update_loop_cond			#   }

print_screen_updates__update_loop_end:
print_screen_updates__final_newline:					# }
	li	$v0, 11							# syscall 11: print_character
	li	$a0, '\n'
	syscall								# putchar('\n');

	li	$t4, FALSE
	sw	$t4, whole_screen_update_needed				# whole_screen_update_needed = FALSE;

	li	$t4, 0
	sw	$t4, num_screen_updates					# num_screen_updates = 0;

print_screen_updates__epilogue:
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra

	jr	$ra
