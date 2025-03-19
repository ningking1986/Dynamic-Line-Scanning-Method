# Isohyet Migration Distance Calculation Tool

This project contains four main MATLAB scripts/functions to batch-compute the migration of isohyets for multiple years (or periods) and perform angle scanning to find the maximum migration distance and its corresponding direction.

---

## Overview of Features

1. **main.m**  
   - Batch-read all `.shp` files in a specified folder (assuming they represent isohyets for different time periods).  
   - Compare them pairwise: scan a specified angle range and calculate the spherical distance between curves.  
   - Output the maximum migration distance and corresponding angle for each calculation.

2. **read_shp.m**  
   - Uses MATLAB's `shaperead` function to load a Shapefile and returns the `X`, `Y` attributes.  
   - Returns an empty structure and shows a warning if reading fails.

3. **find_intersection.m**  
   - Given a curve (`curve_x, curve_y`) and a line function (`line_func`), finds the “closest intersection” between the two.  
   - Algorithm: locate the point on the curve that yields the smallest residual to the line, then perform local linear interpolation to get an approximate intersection.

4. **haversine_distance.m**  
   - Computes the great-circle distance between two points using the Haversine formula (in km).  
   - In this project, it returns a signed distance to distinguish “northward positive, southward negative.” If you only need an absolute value, use `abs()`.

---

## File Structure

- **main.m**  
- **read_shp.m**  
- **find_intersection.m**  
- **haversine_distance.m**  
- **Your .shp files**  

(Adjust as needed based on your own organization.)

---

## Usage Steps

1. **Preparation**  
   - Install MATLAB and ensure it supports `Mapping Toolbox` (needed for `shaperead`).  
   - Place the four `.m` files and your `.shp` files in the same directory (or adjust `folder_path` inside `main.m`).

2. **Modify File Path**  
   - In `main.m`, change `folder_path` to your actual `.shp` file directory.

3. **Run the Script**  
   - Open MATLAB, switch the current path to the directory with the `.m` files.  
   - Run `main.m`. The script automatically reads `.shp` files, does angle scanning, and prints out the maximum migration distance and angle for each time interval.

4. **Result Interpretation**  
   - The script might print lines like:  
     ```
     line2 relative to line1:
     Maximum angle: xx, Maximum distance: xx km, Time taken: xx s
     ```
     indicating that, within the -60° to -30° scan range, the maximum migration distance is about xx km, around angle xx (which you can interpret as a certain directional shift).  
   - Finally, it shows a summary of all intervals in the console.

5. **Notes**  
   - If the Shapefile’s coordinate system is not WGS84 (geographic coordinates), do a projection conversion first to ensure accurate Haversine distances.  
   - If you do not need signed distances, simply apply `abs()` in `main.m`.  
   - To scan other angle ranges or change the step size, adjust the `theta_array` in `main.m`.

---

## License

No special license is declared. Feel free to use or modify this code, subject to any licenses from third-party libraries.

---

## Contact

If you have questions or suggestions, feel free to open an Issue on GitHub or contact the author.
