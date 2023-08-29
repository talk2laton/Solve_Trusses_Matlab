%class definition
classdef Support < handle
    properties 
        Point
        Orientation
        Type
        GraphicHandle
    end

    methods
        function S = Support(point, orientation, type, graphichandle)
                S.Point = point;
                S.Orientation = orientation;
                S.Type = type;
                S.GraphicHandle = graphichandle;
        end
    end
end