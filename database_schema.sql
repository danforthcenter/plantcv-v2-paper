-- PlantCV results databases are created programmatically by plantcv-pipeline.py
-- The structure of the database outlined below is generally stable
-- However, the columns in the features table may change as new features are added
-- The schema below is valid for PlantCV v2.0

-- Table runinfo
-- Store each PlantCV command run against the given database
CREATE TABLE `runinfo` (
	`run_id` INTEGER PRIMARY KEY, 
	`datetime` INTEGER NOT NULL, 
	`command` TEXT NOT NULL
);

-- Table metadata
-- Store image and specimen metadata
CREATE TABLE `metadata` (
	`image_id` INTEGER PRIMARY KEY,
	`run_id` INTEGER NOT NULL, 
	`timestamp` TEXT NOT NULL,
	`frame` TEXT NOT NULL,
	`lifter` TEXT NOT NULL,
	`gain` TEXT NOT NULL,
	`measurementlabel` TEXT NOT NULL,
	`cartag` TEXT NOT NULL,
	`id` TEXT NOT NULL,
	`exposure` TEXT NOT NULL,
	`zoom` TEXT NOT NULL,
	`plantbarcode` TEXT NOT NULL,
	`camera` TEXT NOT NULL,
	`treatment` TEXT NOT NULL,
	`imgtype` TEXT NOT NULL,
	`other` TEXT NOT NULL,
	`image` TEXT NOT NULL
);

-- Table features
-- Store PlantCV output from shape and landmark analysis functions
CREATE TABLE `features` (
	`image_id` INTEGER PRIMARY KEY,
	`area` TEXT NOT NULL,
	`hull-area` TEXT NOT NULL,
	`solidity` TEXT NOT NULL,
	`perimeter` TEXT NOT NULL,
	`width` TEXT NOT NULL,
	`height` TEXT NOT NULL,
	`longest_axis` TEXT NOT NULL,
	`center-of-mass-x` TEXT NOT NULL,
	`center-of-mass-y` TEXT NOT NULL,
	`hull_vertices` TEXT NOT NULL,
	`in_bounds` TEXT NOT NULL,
	`ellipse_center_x` TEXT NOT NULL,
	`ellipse_center_y` TEXT NOT NULL,
	`ellipse_major_axis` TEXT NOT NULL,
	`ellipse_minor_axis` TEXT NOT NULL,
	`ellipse_angle` TEXT NOT NULL,
	`ellipse_eccentricity` TEXT NOT NULL,
	`y-position` TEXT NOT NULL,
	`height_above_bound` TEXT NOT NULL,
	`height_below_bound` TEXT NOT NULL,
	`above_bound_area` TEXT NOT NULL,
	`percent_above_bound_area` TEXT NOT NULL,
	`below_bound_area` TEXT NOT NULL,
	`percent_below_bound_area` TEXT NOT NULL,
	`marker_area` TEXT NOT NULL,
	`marker_major_axis_length` TEXT NOT NULL,
	`marker_minor_axis_length` TEXT NOT NULL,
	`marker_eccentricity` TEXT NOT NULL,
	`estimated_object_count` TEXT NOT NULL,
	`tip_points` TEXT NOT NULL,
	`tip_points_r` TEXT NOT NULL,
	`centroid_r` TEXT NOT NULL,
	`baseline_r` TEXT NOT NULL,
	`tip_number` TEXT NOT NULL,
	`vert_ave_c` TEXT NOT NULL,
	`hori_ave_c` TEXT NOT NULL,
	`euc_ave_c` TEXT NOT NULL,
	`ang_ave_c` TEXT NOT NULL,
	`vert_ave_b` TEXT NOT NULL,
	`hori_ave_b` TEXT NOT NULL,
	`euc_ave_b` TEXT NOT NULL,
	`ang_ave_b` TEXT NOT NULL,
	`left_lmk` TEXT NOT NULL,
	`right_lmk` TEXT NOT NULL,
	`center_h_lmk` TEXT NOT NULL,
	`left_lmk_r` TEXT NOT NULL,
	`right_lmk_r` TEXT NOT NULL,
	`center_h_lmk_r` TEXT NOT NULL,
	`top_lmk` TEXT NOT NULL,
	`bottom_lmk` TEXT NOT NULL,
	`center_v_lmk` TEXT NOT NULL,
	`top_lmk_r` TEXT NOT NULL,
	`bottom_lmk_r` TEXT NOT NULL,
	`center_v_lmk_r` TEXT NOT NULL
);

-- Table signal
-- Store PlantCV output from image signal (color, intensity, etc.) analysis functions
CREATE TABLE `signal` (
	`image_id` INTEGER NOT NULL,
	`bin-number` TEXT NOT NULL,
	`channel_name` TEXT NOT NULL,
	`values` TEXT NOT NULL,
	`bin_values` TEXT NOT NULL
);

-- Table analysis_images
-- Store the paths to all images output by PlantCV analysis functions
CREATE TABLE `analysis_images` (
	`image_id` INTEGER NOT NULL,
	`type` TEXT NOT NULL,
	`image_path` TEXT NOT NULL
);
