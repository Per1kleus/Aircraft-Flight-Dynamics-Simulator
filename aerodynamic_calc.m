function [q ,L ,D ,W ,V_equilibrium] = aerodynamic_calc(aircraft,V)

alpha_trim = aircraft.alpha_trim;

C_L_trim = aircraft.C_L0 + aircraft.C_L_alpha * alpha_trim;

q = 0.5 * aircraft.rho .* V.^2;
L = q .* aircraft.S .* C_L_trim;
D = q .* aircraft.S .* aircraft.C_D;
W = aircraft.m * aircraft.g;

F = L - W;

idx = find(F(1:end-1) .* F(2:end) <= 0, 1);

V_low = V(idx);
V_high = V(idx + 1);

V_equilibrium = fzero(@(V) ...
    0.5 * aircraft.rho * V^2 * aircraft.S * C_L_trim - W, ...
    [V_low V_high]);
end