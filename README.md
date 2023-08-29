# Solve_Trusses_Matlab
The project present a method to solve trusses using Matlab interactively.

## How to load the application 
1. Download this file from [Matlab file exchange](https://www.mathworks.com/matlabcentral/fileexchange/134451-interactive-truss-solver) or clone from this github repository
2. Extract the zip file if you downloaded from Matlab file exchange
3. Run the "TrussesSolver.mlapp" to get the user interface
   ![alt text](https://github.com/talk2laton/Solve_Trusses_Matlab/blob/main/fresh%20page.png)

## How to solve a truss using this application
1. We shall use [problem 3.7 (2 d) from this page](https://learnaboutstructures.com/Chapter-3-Practice-Problems) to demonstrate how to use this aplication ![alt text](https://github.com/talk2laton/Solve_Trusses_Matlab/blob/main/Problem-3-2.png)
2. Enter the incremental xtick positions for the nodes on the structure in the xTicks field and click on the UIAxis for update. For this problem, thats "1.5,0.5,1,2,2,2,2". ![alt text](https://github.com/talk2laton/Solve_Trusses_Matlab/blob/main/xtick.png)
3. Enter the incremental ytick positions for the nodes on the structure in the yTicks field and click on the UIAxis for update. For this problem, thats "1,1.75,0.25,1.5,1". ![alt text](https://github.com/talk2laton/Solve_Trusses_Matlab/blob/main/ytick.png)
4. Click the "Add Point" botton and continue to click the points you want to add on the UIAxis  ![alt text](https://github.com/talk2laton/Solve_Trusses_Matlab/blob/main/add%20point.png) then click the addpoint again to stop adding point.
5. Then click "Connect Points" button to connect the points. ![alt text](https://github.com/talk2laton/Solve_Trusses_Matlab/blob/main/connect%20points.png) This function uses delauney triangulation to connect the points. Some of the members created might not appear in the original problem, so you can use the "Delete Unwanted Edges" function to delete them and you can also add new edges using the "Add New Edges" botton.
6. Looking at the problem, we can see two edges that are not part of the original problem, so click the "Delete Unwanted Edges" botton and then click on each member that you want to delete. ![alt text](https://github.com/talk2laton/Solve_Trusses_Matlab/blob/main/delete%20unwanted%20edge.png) once you are done deleting unwated edges, you should select the botton again to stop deleting edges.
7. To add support, you select the kind of support from dropdown, and the oriantation from another dropdown menu. Then you select the "Add Support" button, then click on the point on the structure, that you want the support to be attached t. ![alt text](https://github.com/talk2laton/Solve_Trusses_Matlab/blob/main/add%support1.png) and  ![alt text](https://github.com/talk2laton/Solve_Trusses_Matlab/blob/main/add%support2.png)
8. 
   
