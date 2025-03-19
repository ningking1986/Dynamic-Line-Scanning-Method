function intersection = find_intersection(curve_x, curve_y, line_func)
% find_intersection finds an approximate intersection between a curve and a given line
%   intersection = find_intersection(curve_x, curve_y, line_func)
%
% Parameters:
%   curve_x, curve_y : coordinate sequences of the isohyet (assumed to be longitude and latitude)
%   line_func        : an anonymous function defined as y = slope * (x - x0) + y0
%
% Returns:
%   intersection : [x_intersect, y_intersect]
%                  returns an empty array [] if no intersection is found or 
%                  if the curve coordinates are empty
%
% Note:
%   This function does not strictly compute a true geometric intersection. 
%   Instead, it finds the segment on the curve with the minimum "residual" 
%   to the line, and then performs a linear interpolation in that neighborhood 
%   to obtain an approximate intersection point.
%   If the curve has few points or is discontinuous, consider refining the interpolation method.

    % If the curve coordinates are empty, return immediately
    if isempty(curve_x) || isempty(curve_y)
        intersection = [];
        return;
    end

    % (1) Compute the vertical distance (residual) of each point on the curve from the line
    residuals = abs(curve_y - line_func(curve_x));

    % (2) Find the index of the point with the smallest residual
    [~, idx_min] = min(residuals);

    % (3) If this point is in the middle, use interpolation for further refinement
    if idx_min > 1 && idx_min < length(curve_x)
        x1 = curve_x(idx_min - 1);
        y1 = curve_y(idx_min - 1);
        x2 = curve_x(idx_min + 1);
        y2 = curve_y(idx_min + 1);

        % Slope and intercept of the curve segment
        slope_curve = (y2 - y1) / (x2 - x1);
        intercept_curve = y1 - slope_curve * x1;

        % Slope of the line (obtained by line_func(1) - line_func(0))
        slope_line = line_func(1) - line_func(0);
        intercept_line = line_func(0);

        denom = slope_curve - slope_line;

        if abs(denom) < 1e-12
            % The two lines are nearly parallel, take the point of smallest residual as approximation
            x_intersect = curve_x(idx_min);
            y_intersect = curve_y(idx_min);
        else
            % Calculate the intersection
            x_intersect = (intercept_line - intercept_curve) / denom;
            y_intersect = slope_curve * x_intersect + intercept_curve;

            % If the intersection's x-coordinate is out of [x1, x2], fallback to the smallest-residual point
            if x_intersect < min(x1, x2) || x_intersect > max(x1, x2)
                x_intersect = curve_x(idx_min);
                y_intersect = curve_y(idx_min);
            end
        end
    else
        % If the smallest-residual point is at a boundary (first or last point), do not interpolate
        x_intersect = curve_x(idx_min);
        y_intersect = curve_y(idx_min);
    end

    % Return the result
    intersection = [x_intersect, y_intersect];
end
