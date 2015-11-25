// This file is part of the Group 13 Project.
// Licensing information can be found in the LICENSE file.
// (C) 2015 Group 13. All rights reserved.

namespace cpp dv


struct Resolution {
  1: i16 width;
  2: i16 height;
}

/**
 * Camera matrix.
 *
 * (fx, fy) - camera focal lengths
 * (cx, cy) - principal point
 */
struct CameraMatrix {
  1: double fx;
  2: double fy;
  3: double cx;
  4: double cy;
}

/**
 * Distortion coefficients.
 *
 * k - radial distortion
 * p - tangential distortion
 */
struct DistCoef {
  1: double k1;
  2: double k2;
  3: double p1;
  4: double p2;
  5: double k3;
}

/**
 * Camera parameters.
 */
struct CameraParams {
  1: CameraMatrix colorCamMat;
  2: CameraMatrix irCamMat;
  3: DistCoef irDist;
}

struct DisplayParams {
  1: Resolution actualRes;
  2: Resolution effectiveRes;
  3: i32 latency;
}

struct ProCamParam {
  1: CameraParams camera;
  2: DisplayParams display;
}

struct Frame {
  1: i32 rows;
  2: i32 cols;
  3: i64 format;
  4: string data;
}

enum Orientation {
  HORIZONTAL = 0,
  VERTICAL   = 1
}

/**
 * Laser position coordinates
 */
struct Point {
  1: double x;
  2: double y;
  3: double z;
}

/**
 * Definition of the API exposed by the ProCam unit.
 */
service ProCam {
  /**
   * Retrieves the parameters of the Color and IR cameras and the display.
   */
  ProCamParam getParam(),

  /**
   * Retrieves the BGR image (1920x1080).
   */
  Frame getColorImage(),

  /**
   * Retrieves the undistorted depth image (512x424).
   */
  Frame getDepthImage(),

  /**
   * Retrieves the BGR image for depth data (512x424).
   */
  Frame getUndistortedColorImage(),

  /**
   * Retireves the color baseline.
   */
  Frame getColorBaseline();

  /**
   * Retrieves the depth baseline.
   */
  Frame getDepthBaseline(),

  /**
   * Retrieves the depth variance.
   */
  Frame getDepthVariance(),

  /**
   * Displays the specified gray code pattern.
   */
  void displayGrayCode(
      1: Orientation orientation,
      2: i16 level,
      3: bool invertedGrayCode),

  /**
   * Display a white image on projector.
   */
  void displayWhite();

  /**
   * Clears the display (sets it to a black image).
   */
  void clearDisplay();

  /**
   * Closes the procam app.
   */
  oneway void close();

  /**
   * Undistorts provided HD image using Kinect's parameters and depth baseline.
   */
  Frame undistort(1: Frame inputHDImageThrift);
}

/**
 * Definition of the API exposed by the Server.
 */
service Master {
  /**
   * Send Procam's IP to master node.
   */
  bool ping()

  /**
   * Sends a new laser position to master.
   */
  void detectedLaser(1: Point point 2: i64 color);
}
