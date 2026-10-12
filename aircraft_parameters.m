function aircraft = aircraft_parameters()

aircraft.m = 1100;
aircraft.S = 16.2;

aircraft.C_L0 = 0.2;
aircraft.C_L_alpha = 5.0;
aircraft.alpha_trim = deg2rad(2.865);

aircraft.C_D = 0.035;

aircraft.rho = 1.225;
aircraft.g = 9.81;
aircraft.T = 2000;

aircraft.K_delta = 2.0;
aircraft.K_theta = 1.0;
aircraft.K_q = 0.8;
end