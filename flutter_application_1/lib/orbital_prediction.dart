import 'dart:math';

class OrbitalPrediction {
  double G = 0;
  
  double W0 = 0;
  double R0 = 0;
  double THETA0 = 0;

  double ME = 0;
  double XE = 0;
  double YE = 0;

  double MM = 0;
  double XM = 0;
  double YM = 0;

  double M = 0;
  double FT = 0;

  OrbitalPrediction(this.W0, this.R0, this.THETA0, this.ME, this.XE, this.YE, this.MM, this.XM, this.YM, this.M, this.FT);

  List<List<double>> calculatePath(int steps, double dt) {
    List<List<double>> path = [];
    double vx0 = W0 * R0 * -sin(THETA0);
    double vy0 = W0 * R0 * cos(THETA0);
    double thetaR = THETA0 + pi / 2;
    path.add([R0*cos(THETA0), R0*sin(THETA0)]);

    for (int i = 0; i < steps; i++) {
      double axT = FT*cos(thetaR)/M;
      double axE = -G*ME/( (pow(path[i][0], 2)+pow(path[i][1], 2)) * pow(cos(atan2( path[i][1]-YE, path[i][0]-XE )), 2) );
      double axM = -G*MM/( (pow(path[i][0], 2)+pow(path[i][1], 2)) * pow(cos(atan2( path[i][1]-YM, path[i][0]-XM )), 2) );
      double x = path[i][0] + dt*(i+1)*(axT + axE + axM) + vx0;

      double ayT = FT*sin(thetaR)/M;
      double ayE = -G*ME/( (pow(path[i][0], 2)+pow(path[i][1], 2)) * pow(sin(atan2( path[i][1]-YE, path[i][0]-XE )), 2) );
      double ayM = -G*MM/( (pow(path[i][0], 2)+pow(path[i][1], 2)) * pow(sin(atan2( path[i][1]-YM, path[i][0]-XM )), 2) );
      double y = path[i][1] + dt*(i+1)*(ayT + ayE + ayM) + vy0;

      path.add([x, y]);

      thetaR = atan2(y-path[i][1], x-path[i][0]);
    }

    return path;
  }
}