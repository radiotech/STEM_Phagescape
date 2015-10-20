//STEM Phagescape API Documentation v1.1

/*
If you are in the STEM Game Design Club and wish to use Processing to build your game, please read the API documentation 
below. This documentation is divided into sections, such as entities, world, chat, etc.. Each section contains subsections 
for important concepts, functions, and variables. This API Documentation will be updated with each new API version. Please 
ensure that the API Version that you are using (first and last line of API file) matches the documentation version printed 
above. Please let me (AJ) know if you have any questions or find an error.

***** Section 1: General API (M_API) ***** (WIP)

Important Concepts:
WIP

Variables:
1. int wSize - Size of the world
2. float gSize - Size of the screen view
3. int[][] gU - 2D array of blocks on the screen in grid coordinates
4. int[][] gM - 2D array of blocks, block edges, and block corners on the screen - depreciated
5. int[][] wU - 2D array of blocks in the world in pos coordinates
6. int[][] wUDamage - 2D array of block damage values in the world in pos coordinates
7. boolean[][] wUText - 2D array of boolean values that store the status of text displaying associated with each block
8. float gScale - Width of each block on the screen in pixels or screen coordinates
9. float wPhase - Current phase, or animation position, of all waves in the world
10. ArrayList wL - List of all waves or block edges in the world
11. PVector wView - Current corner position of the world view
12. PVector wViewLast - Corner position of the world view last update cycle
13. int[] pKeys - Keys that the player is currently pressing
14. Entity player - The player entity
15. boolean menu - Is a menu currently open - depreciated
16. ArrayList entities - List of all entities in the world
17. color[] gBColor - General block color or the color of each block type
18. boolean[] gBIsSolid - General block is solid value or the true/false solidity of each block type
19. int[] gBStrength - General block strength or the number of hits-1 required to break each block type
20. boolean[] sBHasImage - Special block has image value or the true/false value for each block type representing whether 
each block type has an image
21. PImage[] sBImage - Special block image or the image of each block type, if the HasImage value is true
22. int[] sBImageDrawType - Special block image draw type or the way that the image of each block type should be drawn, if 
the HasImage value is true
23. boolean[] sBHasText - Special block has text value or the true/false value for each block type representing whether each 
block type has text
24. String[] sBText - Special block text or the text of each block type, if the HasText value is true
25. int[] sBTextDrawType - Special block text draw type or the way that the text of each block type should be drawn, if the 
HasText value is true
26. PVector moveToAnimateStart - Start position of the current move to animation
27. PVector moveToAnimateEnd - End position of the current move to animation
28. PVector moveToAnimateTime - Start and end times of the current move to animation
29. PVector wViewCenter - Current center position of the world view
30. int asyncC - Number of times that asynchronous events have taken place in the past
31. int asyncT - Next time, in milliseconds, that an asynchronous event will take place

Functions:
1. void M_Setup()
2. void draw()
3. void keyPressed()
4. void keyReleased()
5. void mousePressed()
6. float pointDir(PVector v1,PVector v2)
7. float pointDistance(PVector v1,PVector v2)
8. float turnWithSpeed(float tA, float tB, float tSpeed)
9. float angleDif(float tA, float tB)
10. float angleDir(float tA, float tB)
11. float posMod(float tA, float tB)
12. void aSS(int[][] tMat, float tA, float tB, int tValue)
13. void aSS2DB(boolean[][] tMat, float tA, float tB, boolean tValue)
14. int aGS(int[][] tMat, float tA, float tB)
15. int aGS1D(int[] tMat, float tA)
16. boolean aGS1DB(boolean[] tMat, float tA)
17. color aGS1DC(color[] tMat, float tA)
18. boolean aGS2DB(boolean[][] tMat, float tA, float tB)
19. int[] aGAS(int[][] tMat, float tA, float tB)
20. float maxAbs(float tA, float tB)
21. float minAbs(float tA, float tB)
22. PImage resizeImage(PImage tImg, int tw, int th)
23. void manageAsync()
24. float mDis(float x1,float y1,float x2,float y2)

***** Section 2: World (M_World) ***** (WIP)

Important Concepts:
WIP

Functions:
1. void addGeneralBlock(int tIndex, color tColor, boolean tIsSolid, int tStrength)

Input:
The input variables for this function are 

Description:
This function 

2. void addImageSpecialBlock(int tIndex, PImage tImage, int tImageDrawType)

Input:
The input variables for this function are 

Description:
This function 

3. void addTextSpecialBlock(int tIndex, String tText, int tTextDrawType)

Input:
The input variables for this function are 

Description:
This function 

4. void scaleView(float tGSize)

Input:
The input variables for this function are 

Description:
This function 

5. void centerView(float ta, float tb)

Input:
The input variables for this function are 

Description:
This function 

6. void setupWorld()

Input:
The input variables for this function are 

Description:
This function 

7. void refreshWorld()

Input:
The input variables for this function are 

Description:
This function 

8. PVector screen2Pos(PVector tA)

Input:
The input variables for this function are 

Description:
This function 

9. PVector pos2Screen(PVector tA)

Input:
The input variables for this function are 

Description:
This function 

10. PVector grid2Pos(PVector tA)

Input:
The input variables for this function are 

Description:
This function 

11. PVector blockNear(PVector eV,int tBlock, float tChance)

Input:
The input variables for this function are 

Description:
This function 

12. PVector blockNearCasting(PVector eV,int tBlock)

Input:
The input variables for this function are 

Description:
This function 

13. boolean rayCast(int x0, int y0, int x1, int y1)

Input:
The input variables for this function are 

Description:
This function 

14. PVector moveInWorld(PVector tV, PVector tS, float tw, float th)

Input:
The input variables for this function are 

Description:
This function 

15. void moveToAnimate(PVector tV, float tTime)

Input:
The input variables for this function are 

Description:
This function 

Background Functions:
1. void animate() - Called in the background to animate the world
2. void updateWorld() - Called in the background to update the world
3. void drawWorld() - Called in the background to draw the world

***** Section 3: World Generation (M_WGen) *****

Important Concepts:
The world is stored in a grid of integers. This grid is stored in wU (refer to Section 2). Each integer represents the block 
at that location. These numbers may only permanently range from 0 to 255. In special cases, however, these values may equal 
-1 for short periods of time. World generation deals with placing integers in this world grid in a specific and desirable 
way. In other words, world generation is placing the correct blocks in the correct places in the world. There are a number 
of functions that allow you to achieve this. All world generation functions that require length measures or coordinates as 
inputs receive these values in the world unit format (positions and dimensions are given in blocks).

Functions:
1. void genRing(int x, int y, float w, float h, float weight, int b)

Input:
The input variables for this function are an x, y position, width, height values, a weight (thickness) values, and a block 
type

Description:
This function creates a ring of blocks in the world with a specified width and height and a specified center position. This 
function should not produce any gaps with a weight of 0 although it is recommended that you use a with of at least 1 to prevent 
users from passing through corners. When weight is large and the width and height are significantly different (stretched 
ellipses), the line thickness may noticeably vary between areas of the ring. This function does not fill the center of the 
ring with blocks. The weight of the ring, or thickness of the ellipse line, is distributed evenly between the inside and 
outside of the ellipse.

2. void genArc(float rStart, float rEnd, int x, int y, float w, float h, float weight, int b)

Input:
The input variables for this function are start and end angles in radians (0,PI,2*PI,etc.), an x, y position, width, height 
values, a weight (thickness) values, and a block type

Description:
This function creates an arc of blocks in the world with specified angles, a specified width and height and a specified center 
position. This function does the same thing as genRing, but you are able to specify the start and end angles for the ring. 
This function should not produce any gaps with a weight of 0 although it is recommended that you use a with of at least 1 
to prevent users from passing through corners. When weight is large and the width and height are significantly different 
(stretched ellipses), the line thickness may noticeably vary between areas of the arc. This function does not fill the center 
of the arc with blocks. The weight of the arc, or thickness of the arc line, is distributed evenly between the inside and 
outside of the arc.

3. void genCircle(float x, float y, float r, int b)

Input:
The input variables for this function are an x, y position, a radius value, and a fill block type

Description:
This function produces a circle of blocks in the world with a specified radius and a specified center position. This function 
checks each block in the world and fills all blocks that are within a certain distance (radius) of the provided center point 
with the provided block type. 

4. void genLine(int x1, int y1, int x2, int y2, float weight, int b)

Input:
The input variables for this function are two x, y positions, a weight (thickness) value, and a block type

Description:
This function produces a line of blocks in the world with specified endpoints and a specified thickness. This function should 
not produce any gaps with a weight of 0 although it is recommended that you use a weight of at least 1 to prevent users from 
passing through corners.

5. void genRect(float x, float y, float w, float h, int b)

Input:
The input variables for this function are an x, y position, width, height values, and a block type

Description:
This function produces a rectangle of blocks in the world with a specified upper left corner position and specified dimensions. 
This function fills a rectangular area with a particular block type.

6. void genBox(float x, float y, float w, float h, float weight, int b)

Input:
The input variables for this function are an x, y position, width, height values, a weight (thickness) value, and a block 
type

Description:
This function places blocks in the world on lines with a specified weight along the edges of a rectangle with a specified 
upper left corner position and specified dimensions. This function draws lines around a rectangle with a particular block 
type.

7. void genRoundRect(float x, float y, float w, float h, float rounding, int b)

Input:
The input variables for this function are an x, y position, width, height values, a rounding value, and a block type

Description:
This function produces a rounded rectangle of blocks in the world with a specified upper left corner position, specified 
rounding, and specified dimensions. This function fills a rounded rectangular area with a particular block type. The rounding 
value can be thought of as the number of blocks taken off of the width and height at each corner to allow for rounding. Alternatively, 
this value can be thought of as the radius of the rounded corners. Providing width and height values less than twice the 
rounding value may produce unexpected results.

8. void genRandomProb(int from, int[] to, int[] prob)

Input:
The input variables for this function are a from block type, a list of to block types, and a list of probabilities for each 
of these to block types

Description:
This function searches the world and replaces all from blocks with a to block. Each block is selected based upon its probability 
with respect to all of the given probabilities. If your blocks are 1, 2, and 3, and your probabilities are 3, 4, and 5, the 
total probability for all blocks is 3+4+5=12 so the chance of block 1 being placed is 3/12, the chance of block 2 being placed 
is 4/12, and the chance of block 3 being placed is 5/12. There may be some rounding errors that result in slightly increased 
or decreased probabilities for the blocks on the ends of the list (1 and 3 may be slightly more or less probable than 3/12 
and 5/12).

Example Syntax:
int[] blocksArg = { 1, 2, 3 }; //blocks to be placed
float[] probArg = { 3, 4, 5 }; //probabilities for each block
genRandomProb(1,blocksArg,probArg); //will replace 1 with the blocks using the given probability

9. void genFlood(float x, float y, int b)

Input:
The input variables for this function are an x, y position, and a block type

Description:
This function starts at a position and replaces all blocks of the same type as the block at this position with the block 
type. This is similar to the fill function in paint or photoshop.

10. void genReplace(int from, int to)

Input:
The input variables for this function are a from block type and a to block type

Description:
This function searches the world and replaces all of the from blocks with the to blocks

11. boolean genTestPathExists(float x1, float y1, float x2, float y2)

Input:
The input variables for this function are two x, y positions

Description:
This function will return true if the player can get from point a to point b without breaking any blocks and false if not. 
This function tests weather a path exists between the two points through only non-solid blocks. Whether the blocks at the 
beginning and end are solid or not does not matter. If both the start and end blocks are solid, it may still be possible 
to form a path between those blocks. This function may be useful in level generation to determine weather a user can pass 
through a maze or randomly generated landscape. If it would not be possible for the player to pass through, the level can 
be generated again and tested again until the level is possible.

12. boolean genSpread(int num, int from, int to)

Input:
The input variables for this function are a number of blocks, a from block type, and a to block type

Description:
This function searches the entire world and replaces a certain number of the from blocks with the to blocks. This is useful 
for spreading out a certain number of resources in the map. In some cases, there may not be enough from blocks to place the 
specified number of to blocks. For example, if there are 10 from blocks in the world and you try to place 15 to blocks. In 
this cases, the function will return false but will still place as many blocks as possible. So all 10 from blocks will be 
replaced with the to block and the function will return false. If all of the specified number of blocks are able to be placed, 
the function will return true. This may be useful in determining whether a certain number of blocks were actually placed 
in the world. If they were not, you may want to count the number that were placed successfully and place more to reach a 
goal number of resources.

13. int genCountBlock(int b)

Input:
The input variable for this function is a block type

Description:
This function counts the number of times a specific block occurs in the world. This may be useful in resource spreading.
*/

//STEM Phagescape API Documentation v(see above)
