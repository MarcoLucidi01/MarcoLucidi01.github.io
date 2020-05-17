2017-07-27

# a tetris clone

this is my first """big""" project in C, made after reading the bible [K&R
Second Edition][1] and after taking the Harvard course [CS50][2].

actually I consider this as my "final project" for CS50: I enjoy C so much that
I had to choose it as the main tool for the project.

here a [demo video][3] and here the [**source code**][4].

## why tetris?

well, first because I like it: I used to play **A LOT** when I was a kid on a
"chinese fake GameBoy" I had and more recently on my smartphone. and then
because I wanted to do something simple within my reach, but at the same time a
bit challenging, considering the language I chose.

also it is often considered as an "Hello, World!" to game development so once in
my life I had to do it.

## the game

I tried to stick with the classic *Tetris*, so no "wall kick", no "hold piece",
no "ghost piece", but I applied some "new" features that I like: "soft drop"
(without adding points) and this [random generator][5] so that I don't have to
swear to get an *I*.

keys to control what's on the screen are straightforward:

- **LEFT / DOWN / UP / RIGHT** performs classical movements;
- **H / J / K / L** also performs classical movements. did you recognize them?
  they are those of [vim][6]! I'm a vim addicted and I thought it would be
  nice if I could use vim keys to play Tetris =).
- **SPACE** performs "hard drop".
- **P** pause or unpause the game.
- **E** ends the game when it is paused.
- **N** starts a new game when the previous is over.
- **Q** close the program when the game is over.

after the end of each game, it saves the level, score and lines along with the
current date and the time spent playing (including pause time) in a text file
called "scores.txt" within the folder in which the executable resides.

for now, there isn't a way to add a nickname (because you know, probably I will
be the only player...).

## the program

if you haven't notice yet, I used the [ncurses][7] library.

two "design choices" I made (I know I probably screw up somewhere) were: write
"reusable" code (in part) and split different things in different files.

here the files tree and a bit of explanation:

    project/
            Makefile
            include/
                    actions.h
                    colors.h
                    controller.h
                    drawer.h
                    game.h
                    grid.h
                    helpers.h
                    tetramino.h
            src/
                    controller.c
                    drawer.c
                    game.c
                    grid.c
                    helpers.c
                    main.c
                    tetramino.c

for the first time in my three months adventure with C, I felt the need to use a
[`Makefile`][8] and it turned out to be veeery useful of course.

in [`helpers.c`][9] there are some helpers functions (youdontsay.jpg). there is
for example a "`malloc` wrapper" who calls `exit(EXIT_FAILURE)` if it was not
possible allocate memory. I call it (the wrapper) every time I need memory.

[`grid.c`][10] contains functions to handle guess what? right, the game grid on
which put blocks.

[`actions.h`][11] contains an enum of "actions" i.e. commands that modify the
current state of the game. I think their names are self-explanatory.

the "magic" happens in the files [`main.c`][12] and [`game.c`][13]: they handle
the game flow.

[`tetramino.c`][14] defines all you need to create a [`tetramino`][15], rotate
or change its shape and blindly put / remove it on / from a grid if it is not
locked.

with [`controller.c`][16] instead, you can perform "actions" on a tetramino only
if that action is allowed, depending on the current state of the grid.

that is, to move, rotate or drop a piece, `game.c` relies on the functions in
`controller.c` who relies on the "raw" functions in `tetramino.c` after some
tests.

[`drawer.c`][17] takes care of the "ncurses part" drawing the grid, the edges
and some informations. it has a function, `refresh_scene()`, which is called in
`game.c` to update what is on the screen when it's time to do so.

`grid.c` and even `drawer.c` could be easily reused in other projects, e.g. in a
snake clone, tic-tac-toe, ..., basically anything who requires a simple grid,
because I made them "not Tetris specific".

I tried to keep things as simple as possible (I always try to do this). for
example, I hard coded all possible rotations for each piece in `tetramino.c`
since in total they are only *4 x 7 = 28*. in this way I don't have to call a
function to rotate a matrix and sometimes rotate it backwards, but my functions
simply increment or decrement an index in range *\[0,3\]*. of course I did this
because the amount of memory used is very low.

## conclusion

at the end of the day, the main goals of this project were:

- learn something new;
- get a "working" Tetris clone;
- get my feet wet with ncurses;
- have some fun.

and I guess I've achieved them all. even if it was not a big deal, it was my
first time with many things: a multiple files program (in C), a Makefile,
ncurses and small "tricks" I used in the code.

so it was worth it!

thank you for reading up to here, if you have any comment / suggestion or if you
found a bug, please contact me via email. bye.

[1]: https://en.wikipedia.org/wiki/The_C_Programming_Language
[2]: https://cs50.harvard.edu/
[3]: https://www.youtube.com/watch?v=HRttr5_LnvI
[4]: https://github.com/MarcoLucidi01/tetris_clone
[5]: http://tetris.wikia.com/wiki/Random_Generator
[6]: http://www.vim.org/
[7]: https://en.wikipedia.org/wiki/Ncurses
[8]: https://github.com/MarcoLucidi01/tetris_clone/blob/master/Makefile
[9]: https://github.com/MarcoLucidi01/tetris_clone/blob/master/src/helpers.c
[10]: https://github.com/MarcoLucidi01/tetris_clone/blob/master/src/grid.c
[11]: https://github.com/MarcoLucidi01/tetris_clone/blob/master/include/actions.h
[12]: https://github.com/MarcoLucidi01/tetris_clone/blob/master/src/main.c
[13]: https://github.com/MarcoLucidi01/tetris_clone/blob/master/src/game.c
[14]: https://github.com/MarcoLucidi01/tetris_clone/blob/master/src/tetramino.c
[15]: https://en.wikipedia.org/wiki/Tetromino
[16]: https://github.com/MarcoLucidi01/tetris_clone/blob/master/src/controller.c
[17]: https://github.com/MarcoLucidi01/tetris_clone/blob/master/src/drawer.c
