// This file is part of the DerpVision Project.
// Licensing information can be found in the LICENSE file.
// (C) 2015 Group 13. All rights reserved.

#include "core/Projection.h"

using namespace dv::core::projection;


cv::Point2f project(
    const cv::Mat& camera,
    float k1,
    float k2,
    const cv::Point3f& point)
{
  const float xp = point.x / point.z;
  const float yp = point.y / point.z;

  const float fx = camera.at<float>(0, 0);
  const float fy = camera.at<float>(1, 1);
  const float cx = camera.at<float>(0, 2);
  const float cy = camera.at<float>(1, 2);

  const float r2 = xp * xp + yp * yp;
  const float d = 1 + k1 * r2 + k2 * r2 * r2;

  const float xpp = xp * d;
  const float ypp = yp * d;

  const float u = fx * xpp + cx;
  const float v = fy * ypp + cy;

  return cv::Point2f(u, v);
}

