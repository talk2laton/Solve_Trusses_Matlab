%class definition
classdef Load < handle
    properties 
        Value
        Point
        Orientation
        GraphicHandle
    end

    methods
        function L = Load(value, point, orientation, graphichandle)
                L.Value = value;
                L.Point = point;
                L.Orientation = orientation;
                L.GraphicHandle = graphichandle;
        end
    end
end