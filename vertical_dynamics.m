function dxdt = vertical_dynamics(t, x, aircraft, delta_e)

rho = aircraft.rho;
S = aircraft.S;
C_L0 = aircraft.C_L0;
C_L_alpha = aircraft.C_L_alpha;
C_D = aircraft.C_D;
m = aircraft.m;
g = aircraft.g;
T = aircraft.T;

K_delta = aircraft.K_delta;
K_theta = aircraft.K_theta;
K_q = aircraft.K_q;





h = x(1);
Va = x(2);
gamma = x(3);
theta = x(4);
pitch_r = x(5);


a = theta - gamma;
C_L = C_L0 + C_L_alpha * a;
L = 0.5 * rho * Va.^2 * S * C_L;
D = 0.5 * rho * Va.^2 * S * C_D;
W = m * g;

dtheta_dt = pitch_r;

dhdt = Va * sin(gamma);


dVadt = (T - D - W * sin(gamma)) / m;

dgammadt = (L - W * cos(gamma)) / (m * Va);

dpitch_r_dt = K_delta * delta_e - K_theta * theta - K_q * pitch_r;


dxdt = [dhdt; dVadt; dgammadt; dtheta_dt; dpitch_r_dt];

end