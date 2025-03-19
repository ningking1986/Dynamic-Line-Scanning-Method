function d = haversine_distance(lon1, lat1, lon2, lat2)
% haversine_distance calculates the spherical distance between two points (in km)
%   d = haversine_distance(lon1, lat1, lon2, lat2)
%
% Parameters:
%   lon1, lat1 : longitude and latitude of point 1 (in degrees)
%   lon2, lat2 : longitude and latitude of point 2 (in degrees)
%
% Returns:
%   d : the spherical distance (in km) obtained using the Haversine formula;
%       if lat2 < lat1, the result is taken as a negative value
%
% Note:
%   The returned distance is signed, used to distinguish movement "toward the south/north."
%   If you do not need a sign or only care about absolute values, you can use abs(d) externally.

    % Average Earth radius (km). You can replace it with specific requirements 
    % or more accurate ellipsoid parameters.
    % Here, based on the typical latitudes (~30¡ãN¨C40¡ãN), an approximate radius is calculated as:
    %   R = 6378 - 21*sin(35) ¡Ö 6365 km 
    % where 6378 km is the equatorial radius.
    R = 6365;

    % Convert degrees to radians
    dLat = deg2rad(lat2 - lat1);
    dLon = deg2rad(lon2 - lon1);

    lat1 = deg2rad(lat1);
    lat2 = deg2rad(lat2);

    % Haversine formula
    a = sin(dLat/2).^2 + cos(lat1).*cos(lat2).*sin(dLon/2).^2;
    c = 2 * atan2(sqrt(a), sqrt(1 - a));

    % Return signed distance
    if lat2 < lat1
        d = -R * c;  % indicates movement toward the south
    else
        d = R * c;   % indicates movement toward the north
    end
end
