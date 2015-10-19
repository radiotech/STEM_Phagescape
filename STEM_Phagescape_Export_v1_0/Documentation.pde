/*
STEM Phagescape API Documentation v1.0
If you are in the STEM Game Design Club and wish to use Processing to build your game, please read the API documentation below. This documentation is divided into sections, such as entities, world, chat, etc.. Each section contains subsections for important concepts, functions, and variables. This API Documentation will be updated with each new API version. Please ensure that the API Version that you are using (first and last line of API file) matches the documentation version printed above. Please let me (AJ) know if you have any questions or find an error.

***** Section 1: World Generation (M_WGen) *****

Important Concepts:
The world is stored in a grid of integers. This grid is stored in wU (refer to Section 2). Each integer represents the block at that location. These numbers may only permanently range from 0 to 255. In special cases, however, these values may equal -1 for short periods of time. World generation deals with placing integers in this world grid in a specific and desirable way. In other words, world generation is placing the correct blocks in the correct places in the world. There are a number of functions that allow you to achieve this. All world generation functions that require length measures or coordinates as inputs receive these values in the world unit format (positions and dimensions are given in blocks).

Functions:
1. genRing(int x, int y, float w, float h, float weight, int b)

Input:
The input variables for this function are an x, y position, width, height values, a weight (thickness) values, and a block type

Description:
This function creates a ring of blocks in the world with a specified width and height and a specified center position. This function should not produce any gaps with a weight of 0 although it is recommended that you use a with of at least 1 to prevent users from passing through corners. When weight is large and the width and height are significantly different (stretched ellipses), the line thickness may noticeably vary between areas of the ring. This function does not fill the center of the ring with blocks. The weight of the ring, or thickness of the ellipse line, is distributed evenly between the inside and outside of the ellipse.

2. genCircle(float x, float y, float r, int b)

Input:
The input variables for this function are an x, y position, a radius value, and a fill block type

Description:
This function produces a circle of blocks in the world with a specified radius and a specified center position. This function checks each block in the world and fills all blocks that are within a certain distance (radius) of the provided center point with the provided block type. 

3. genLine(int x1, int y1, int x2, int y2, float weight, int b)

Input:
The input variables for this function are two x, y positions, a weight (thickness) value, and a block type

Description:
This function produces a line of blocks in the world with specified endpoints and a specified thickness. This function should not produce any gaps with a weight of 0 although it is recommended that you use a weight of at least 1 to prevent users from passing through corners.

4. genRect(float x, float y, float w, float h, int b)

Input:
The input variables for this function are an x, y position, width, height values, and a block type

Description:
This function produces a rectangle of blocks in the world with a specified upper left corner position and specified dimensions. This function fills a rectangular area with a particular block type.

5. genBox(float x, float y, float w, float h, float weight, int b)

Input:
The input variables for this function are an x, y position, width, height values, a weight (thickness) value, and a block type

Description:
This function places blocks in the world on lines with a specified weight along the edges of a rectangle with a specified upper left corner position and specified dimensions. This function draws lines around a rectangle with a particular block type.

6. genRoundRect(float x, float y, float w, float h, float rounding, int b)

Input:
The input variables for this function are an x, y position, width, height values, a rounding value, and a block type

Description:
This function produces a rounded rectangle of blocks in the world with a specified upper left corner position, specified rounding, and specified dimensions. This function fills a rounded rectangular area with a particular block type. The rounding value can be thought of as the number of blocks taken off of the width and height at each corner to allow for rounding. Alternatively, this value can be thought of as the radius of the rounded corners. Providing width and height values less than twice the rounding value may produce unexpected results.

7. genRandomProb(int[] from, int[] to, int[] prob)
ex.
int[] blocksArg = { 1, 2, 3 }; //blocks to be placed
float[] probArg = { 3, 1, 1 }; //probabilities for each block
genRandomProb(1,blocksArg,probArg); //will replace 1 with the blocks using the given probability

8. genFlood(float x, float y, int b) - start at a position and flood all of the same block with a different block

9. genReplace(int from, int to) - replace all of one block with another

10. genTestPathExists(float x1, float y1, float x2, float y2) - can the player or entities get from one point to another?

11. genSpread(int num, int from, int to) - spreads a certain "num"ber of the "to" block around the world, replacing the "from" block 

12. genCountBlock(int b)
*/
