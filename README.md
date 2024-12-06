# CS-Breakout-MIPS-
A game of Breakout takes place on a 2D grid, where the player must move a paddle to bounce a ball (*) into a group of bricks (digits).  You can move the paddle left (a and A) and right (d and D).  Hitting bricks with the ball will destory the bricks, and reward the player with score points. 

breakout.s: The Assignment

Your task in this assignment is to implement breakout.s in MIPS assembly.

You have been provided with some assembly and some helpful information in breakout.s. Read through the provided code carefully, then add MIPS assembly so it executes exactly the same as breakout.c.

The functions run_command, print_deubg_info and print_screen_updates have already been translated to MIPS assembly for you.

You have to implement the following functions in MIPS assembly:

print_welcome
main
read_grid_width
game_loop
initialise_game
move_paddle
count_total_active_balls
print_cell
register_screen_update
count_balls_at_coordinate
print_game
spawn_new_ball
move_balls
move_ball_in_axis
hit_brick
check_ball_paddle_collision
move_ball_one_cell
You must translate each function separately to MIPS assembler, following the standard calling conventions used in lectures. When translating a function, you must not make any assumptions about the behaviour or side effects of any other function which is called.
