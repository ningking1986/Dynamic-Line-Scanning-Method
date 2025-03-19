%% main.m
% Note: In this project, north-westward movement is considered positive, 
% and south-eastward movement is considered negative.

% Scanning method: Calculate the migration distance of isohyets across different time scales 
% (e.g., 1/10/20/30 years). Batch-read Shapefiles for two isohyets and perform angle scanning. 
% Use the Haversine formula to compute spherical distance for more accurate results.
%
% Usage:
%   1. Place this file in the same directory as read_shp.m, find_intersection.m, and haversine_distance.m.
%   2. Modify 'folder_path' to point to the actual path containing the .shp files.
%   3. Run this script directly.

close all; clc; clear;

%% [1] Specify the folder containing the target isohyets data
folder_path = "folder_path";  % <-- Change to your .shp folder path
folder_path = "F:\1论文--等降水线\提交版本\Data available\Eg Data"; 
file_list = dir(fullfile(folder_path, '*.shp'));
if isempty(file_list)
    error('No .shp files were found in the specified folder. Please check the path or filenames and try again.');
end

% Sort by file name to ensure chronological order
[~, sort_idx] = sort({file_list.name});
file_list = file_list(sort_idx);

num_files = length(file_list);

% Arrays to store the maximum angle and distance calculated for each time interval
max_angle_array = zeros(1, num_files - 1);
max_distance_array = zeros(1, num_files - 1);

%% [2] Process each interval
% Assume the files follow a continuous sequence of e.g., 1961,1962,1963,...
% Compare one file to the next to see how the isohyets have shifted.

for idx = 1:num_files-1
    
    % Read the isohyet data for the earlier period
    curve1_filepath = fullfile(folder_path, file_list(idx).name);
    a = read_shp(curve1_filepath);
    curve1_x = a.X;
    curve1_y = a.Y;
    
    % Read the isohyet data for the later period
    curve2_filepath = fullfile(folder_path, file_list(idx + 1).name);
    b = read_shp(curve2_filepath);
    curve2_x = b.X;
    curve2_y = b.Y;

    % Scan angle range from -60° to -30° (adjust as needed)
    theta_array = deg2rad(-60) : (pi/18000) : deg2rad(-30);
    num_thetas = length(theta_array);
    distance_array = zeros(1, num_thetas);

    % Pre-calculate the slope for each angle
    slopes = tan(theta_array);

    tic;  % measure execution time (for performance observation)
    for i = 1:num_thetas
        slope = slopes(i);

        % For each point on the first curve, compute the distance to the intersection 
        % with the second curve under the current angle
        cal_distance = zeros(1, length(curve1_x));
        for j = 1:length(curve1_x)
            x0 = curve1_x(j);
            y0 = curve1_y(j);

            % Construct the line function y = slope*(x - x0) + y0
            line_func = @(x) slope * (x - x0) + y0;

            % Find the intersection on the second curve
            intersection2 = find_intersection(curve2_x, curve2_y, line_func);

            % If the intersection exists, compute the spherical distance
            if ~isempty(intersection2)
                % Here, (curveX, curveY) is (longitude, latitude)
                d = haversine_distance(x0, y0, intersection2(1), intersection2(2));
                cal_distance(j) = d;
            end
        end

        % The average distance (excluding NaN values) for this angle
        distance_array(i) = mean(cal_distance, 'omitnan');
    end

    % Find the angle that yields the largest absolute migration distance
    theta_degrees = rad2deg(theta_array);
    [~, max_idx] = max(abs(distance_array));
    max_angle = theta_degrees(max_idx);
    max_distance = distance_array(max_idx);

    % Store the results
    max_angle_array(idx) = max_angle;
    max_distance_array(idx) = max_distance;

    elapsed_time = toc;
%     fprintf('%s relative to %s:\nMigration distance: %.2f km, Time taken: %.2f s\n\n',...
%         file_list(idx + 1).name, file_list(idx).name, ...
%         max_distance, elapsed_time);
end

%% [3] Summarize the results
fprintf('====================== Summary of Calculations ======================\n');
for idx = 1:num_files-1
    fprintf('File [%s] relative to [%s]\nMigration distance: %.2f km\n\n',...
        file_list(idx + 1).name, file_list(idx).name, ...
        max_distance_array(idx));
end
