function precipitation_data = read_shp(filepath)
% read_shp reads a Shapefile
%   precipitation_data = read_shp(filepath)
%
% Reads the .shp file at the specified path and returns a structure 
% containing fields X and Y.
% If the read fails, returns an empty structure and displays a warning.
%
% Notes:
%   1. The shaperead function in MATLAB requires the Mapping Toolbox.
%   2. If the Shapefile's coordinate system is not geographic (WGS84), 
%      you need to do a projection conversion beforehand or ensure 
%      the coordinate system aligns with this code's logic.

    if exist(filepath, 'file') ~= 2
        warning('File not found: %s', filepath);
        precipitation_data = struct('X', [], 'Y', []);
        return;
    end

    try
        % MATLAB built-in shaperead function to read Shapefiles
        data = shaperead(filepath);

        % Here we assume only the first geometry object is needed. 
        % If there are multiple objects, handle them as needed.
        precipitation_data.X = data.X;
        precipitation_data.Y = data.Y;
    catch ME
        warning('Failed to read Shapefile: %s', ME.message);
        precipitation_data = struct('X', [], 'Y', []);
    end
end
