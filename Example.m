% This file explains how to use the program SolveTrusses and displays the
% force in each member on them. C implies compression while T means
% tension
% The function is called with 4 arguments: Members, Loads, Supports, Name.
% SolveTrusses(Members, Loads, Supports, Name)
%% Input1 : Members
% Members is a cell array containing 2by2 matrices. Each 2by2 matrix
% represent a member, with each row representing each end of the member. 
% eg: Members = {[0,0;400,0], [0,0;900,375],[400,0;900,375]};
%% Input2 : Loads
% Loads is a cell array containing row vectors of length 4. The first two
% elements represent the coordinate of the point of application of the
% load, while the third element represent the maginitude of the load, and
% the last element is the angular orientation of the load measured from the
% positive x axis. eg: A download load of 200N applied at point (3,5) is
% represented as [3,5,2000,-pi/2] or [3,5,2000,3*pi/2];
%% Input3 : Supports
% Supports is a cell array containing row vectors of length4. The first
% element represent the type of the support (1 for pin, 2 for roller). The
% second and third elements represent the x and y coordinate of the
% support, and the last element represent the orientation of its normal 
% measured from positive y axis. The orientation is in multiples of 
% 90 degrees. This is important for the roller, not important for pin, but 
% must be stated for the drawing to be rendered correctly. For example, a
% roller at point (3,4) with normal rotated 90 degrees from positive y axis
% is stated as [2,3,4,1];
%% Example1
Members = {[0,8;6,0], [0,8;12,8],[12,8;24,8],[24,8;18,0],[18,0;12,8],[12,8;6,0],[6,0;18,0]};
Loads = {[0, 8, 2000, -pi/2], [12,8, 1000, -pi/2]};
Supports = {[2, 18, 0, 0], [1, 24, 8, 1]};
SolveTrusses(Members, Loads, Supports);
%% Example2
Members = {[0,0;4,-3], [0,0;12,0],[4,-3;12,0]};
Loads = {[4,-3, 1800, -pi/2]};
Supports = {[1, 0, 0, 0], [2, 12, 0, 0]};
SolveTrusses(Members, Loads, Supports);
%% Example3
Members = {[0,0;400,0], [0,0;900,375],[400,0;900,375]};
Loads = {[900,375, 1200, -pi/2]};
Supports = {[1, 0,0, 0], [2, 400,0, 0]};
SolveTrusses(Members, Loads, Supports);
%% Example4
Members = {[12,0;12,15],[24,5;24,15],[36,10;36,15],[12,15;24,15],....
           [24,15;36,15],[36,15;48,15],[12,0;24,5],[24,5;36,10],....
           [36,10;48,15],[0,0;12,15],[0,0;12,0],[12,0;24,15],[24, 5;36,15]};
Loads = {[48, 15, 15, -pi/2]};
Supports = {[2, 12, 0, 0], [1, 0, 0, 0]};
SolveTrusses(Members, Loads, Supports);
%% Example5
Members = {[0,4.5;4,4.5],[4,4.5;8,4.5],[8,4.5;12,4.5],[12,4.5;16,4.5],....
           [0,4.5;4,3.0],[4,3.0;8,1.5],[8,1.5;12,0.0],[12,0.0;16,4.5],....
           [4,3.0;4,4.5],[8,1.5;8,4.5],[12,0.0;12,4.5],[4,4.5;8,1.5],[8,4.5;12,0.0]};
Loads = {[0, 4.5, 48, -pi/2]};
Supports = {[2, 12, 0, 0], [1, 16, 4.5, 1]};
SolveTrusses(Members, Loads, Supports);
%% Example6
Members = {[0,0;2,1],[2,1;4,2],[4,2;6,3],[6,3;8,2],[8,2;10,1],[10,1;12,0],....
           [0,0;2,2],[2,2;4,4],[4,4;6,5],[6,5;8,4],[8,4;10,2],[10,2;12,0],....
           [2,1;2,2],[4,2;4,4],[6,3;6,5],[8,2;8,4],[10,1;10,2],[2,2;4,2],....
           [8,2;10,2], [4,4;6,3],[6,3;8,4]};
Loads = {[0,0,1,-pi/2],[2,2,2,-pi/2],[4,4,2,-pi/2],[6,5,1,-pi/2]};
Supports = {[1, 0, 0, 0], [2, 12, 0, 0]};
SolveTrusses(Members, Loads, Supports);
