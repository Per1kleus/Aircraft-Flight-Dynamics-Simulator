
%% Parameter Input
clc;
clear;
close all;

choice = menu('Choose the Aircraft Parameters', 'Default', 'Custom');

if choice == 1
    aircraft = aircraft_parameters();
elseif choice == 2
    disp('Enter custom aircraft parameters:')
    
    % Input Parameter Validation
    
    % Mass
    while true
        aircraft.m = input('Mass [kg]: ');
        if aircraft.m > 0
            break
        end
        disp('Invalid value. Mass must be greater than 0.')
    end
    
    % Wing area
    while true
        aircraft.S = input('Wing area [m^2]: ');
        if aircraft.S > 0
            break
        end
        disp('Invalid value. Wing area must be greater than 0.')
    end
    
    % Zero-angle lift coefficient
    aircraft.C_L0 = input('Zero-angle lift coefficient C_L0: ');
    
    % Lift curve slope
    while true
        aircraft.C_L_alpha = input('Lift curve slope C_L_alpha [1/rad]: ');
        if aircraft.C_L_alpha > 0
            break
        end
        disp('Invalid value. C_L_alpha must be greater than 0.')
    end
    
    while true
        aircraft.alpha_trim = input('Trim angle of attack [deg]: ');

        if aircraft.alpha_trim > -90 && aircraft.alpha_trim < 90
            aircraft.alpha_trim = deg2rad(aircraft.alpha_trim);
            break
        end

        disp('Invalid value. Trim angle of attack must be between -90 and 90 degrees.')
    end

    % Drag coefficient
    while true
        aircraft.C_D = input('Drag coefficient C_D: ');
        if aircraft.C_D > 0
            break
        end
        disp('Invalid value. C_D must be greater than 0.')
    end
    
    % Air density
    while true
        aircraft.rho = input('Air density [kg/m^3]: ');
        if aircraft.rho > 0
            break
        end
        disp('Invalid value. Air density must be greater than 0.')
    end
    
    % Gravity
    while true
        aircraft.g = input('Gravity [m/s^2]: ');
        if aircraft.g > 0
            break
        end
        disp('Invalid value. Gravity must be greater than 0.')
    end
    
    % Thrust
    while true
        aircraft.T = input('Thrust [N]: ');
        if aircraft.T >= 0
            break
        end
        disp('Invalid value. Thrust cannot be negative.')
    end
    
    % Elevator control gain
    while true
        aircraft.K_delta = input('Elevator control gain K_delta: ');
        if aircraft.K_delta > 0
            break
        end
        disp('Invalid value. K_delta must be greater than 0.')
    end
    
    % Pitch angle damping
    while true
        aircraft.K_theta = input('Pitch angle damping K_theta: ');
        if aircraft.K_theta > 0
            break
        end
        disp('Invalid value. K_theta must be greater than 0.')
    end
    
    % Pitch rate damping
    while true
        aircraft.K_q = input('Pitch rate damping K_q: ');
        if aircraft.K_q > 0
            break
        end
        disp('Invalid value. K_q must be greater than 0.')
    end


end


%Initial Airspeed 
while true

    Va0_input = input('Give Multiple (more than 2) Initial airspeeds [m/s]: ', 's');

    try
        Va0_values = eval(Va0_input);

        if isnumeric(Va0_values) && ...
                isvector(Va0_values) && ...
                all(Va0_values > 0)

            V = Va0_values(:).';

            break
        end

    catch
    end

    disp('Invalid input. Enter a value, range, or vector.')
    disp('Examples: 67    5:1:10    [10 17 19 35]')
end

[aircraft.q, aircraft.L, aircraft.D, aircraft.W, aircraft.Veq] = aerodynamic_calc(aircraft,V);

%% Basic Plots

figure(Name="Lift and Drag Plots")

tiledlayout(1,2)

nexttile;
plot(V, aircraft.L, 'LineWidth', 1.5);
hold on;
yline(aircraft.W,'-g')
hold off;
grid on;
xlabel('Velocity');
ylabel('Lift');
title('Lift vs. Velocity');
legend("Lift","Weight",Location="best")

nexttile;
plot(V, aircraft.D, 'LineWidth', 1.5);
grid on;
xlabel('Velocity');
ylabel('Drag');
title('Drag vs. Velocity');

%% Analyze the Equilibrium condition


F_v = aircraft.L - aircraft.W;

figure(Name="F Vertical")

plot(V,F_v);
hold on
yline(0,'--g');
hold off;
grid on;
xlabel('Velocity');
ylabel('L - W');
title('Vertical Force Equilibrium');
legend('L - W','Equilibrium','Location','best');

%% Vertical Acceleration

a_v = F_v / aircraft.m;

figure(Name="Vertical Acceleration");


plot(V, a_v, 'LineWidth', 1.5);
grid on;
xlabel('Velocity');
ylabel('Vertical Acceleration');
title('Vertical Acceleration vs. Velocity');


%% Simulation Inputs


fprintf('\n------ Simulation Inputs ------\n')

% Initial altitude
while true
    h0 = input('Initial altitude [m]: ');

    if h0 >= 0
        break
    end

    disp('Invalid value. Altitude cannot be negative.')
end


% Initial flight-path angle
while true
    gamma0_deg = input('Initial flight-path angle [deg]: ');

    if gamma0_deg > -90 && gamma0_deg < 90
        break
    end

    disp('Invalid value. Angle must be between -90 and 90 degrees.')
end

gamma0 = deg2rad(gamma0_deg);

% Initial pitch angle
theta0 = gamma0 + aircraft.alpha_trim;

% Initial pitch rate
pitch_r0 = 0;


%Initial Airspeed 
while true

    Va0_input = input('Initial airspeed(s) [m/s]: ', 's');

    try
        Va0_values = eval(Va0_input);

        if isnumeric(Va0_values) && ...
                isvector(Va0_values) && ...
                all(Va0_values > 0)

            Va0_values = Va0_values(:).';

            break
        end

    catch
    end

    disp('Invalid input. Enter a value, range, or vector.')
    disp('Examples: 67    5:1:10    [10 17 19 35]')
end


% Simulation time
while true
    t_final = input('Simulation time [s]: ');

    if t_final > 0
        break
    end

    disp('Invalid value. Simulation time must be greater than 0.')
end

% Elevator deflection
while true

    delta_e_input = input('Elevator deflection(s) [deg]: ', 's');

    try
        delta_e_values_deg = eval(delta_e_input);

        if isnumeric(delta_e_values_deg) && ...
                isvector(delta_e_values_deg) && ...
                all(delta_e_values_deg >= -30) && ...
                all(delta_e_values_deg <= 30)

            delta_e_values_deg = delta_e_values_deg(:).';

            break
        end

    catch
    end

    disp('Invalid input. Enter a value, range, or vector.')
    disp('Examples: 5    -5:5:10    [-10 0 5 10]')
end

delta_e_values = deg2rad(delta_e_values_deg);

% Initial state vector
t_span = [0 t_final];


vl = length(Va0_values);
dl = length(delta_e_values);



%% Run each initial airspeed and elevator-deflection combination

% Different line styles for different elevator deflections
color_choices = {'-b', '-r', '-g', '-c', '-m', '-y'};

% Store handles for every subplot
ax_handles = gobjects(vl, 6);

%% Print simulation cases in Command Window

fprintf('\n========== Simulation Cases ==========\n')

fprintf('\nInitial Airspeeds:\n')
for i = 1:vl
    fprintf('%d -> Va0 = %.2f m/s\n', i, Va0_values(i))
end

fprintf('\nElevator Deflections:\n')
for j = 1:dl
    fprintf('%d -> delta_e = %.2f deg\n', j, delta_e_values_deg(j))
end

fprintf('======================================\n\n')

%% Create ONE figure for all initial speeds

fig = figure(Name="Aircraft State Response", NumberTitle="off");
set(fig, 'Position', [50 100 1800 800]);

for i = 1:vl

    Va0 = Va0_values(i);

    for j = 1:dl

        delta_e = delta_e_values(j);

        result = mod(j - 1, 6) + 1;

        x0 = [h0; Va0; gamma0; theta0; pitch_r0];

        [t, x] = ode45(@(t,x) ...
            vertical_dynamics(t, x, aircraft, delta_e), ...
            t_span, x0);

        % States
        h       = x(:,1);
        Va      = x(:,2);
        gamma   = x(:,3);
        theta   = x(:,4);
        pitch_r = x(:,5);

        % Convert angles
        gamma_deg = rad2deg(gamma);
        theta_deg = rad2deg(theta);
        alpha_deg = theta_deg - gamma_deg;

        %% Plot 1 - Altitude
        ax_handles(i,1) = subplot(vl,6,(i-1)*6+1);
        hold on
        plot(t, h, color_choices{result}, 'LineWidth', 1.5)
        grid on
        xlabel('Time [s]')
        ylabel('Altitude [m]')
        title('Altitude')

        %% Plot 2 - Airspeed
        ax_handles(i,2) = subplot(vl,6,(i-1)*6+2);
        hold on
        plot(t, Va, color_choices{result}, 'LineWidth', 1.5)
        grid on
        xlabel('Time [s]')
        ylabel('Airspeed [m/s]')
        title('Airspeed')

        %% Plot 3 - Flight-path angle
        ax_handles(i,3) = subplot(vl,6,(i-1)*6+3);
        hold on
        plot(t, gamma_deg, color_choices{result}, 'LineWidth', 1.5)
        grid on
        xlabel('Time [s]')
        ylabel('\gamma [deg]')
        title('Flight-Path Angle')

        %% Plot 4 - Pitch angle
        ax_handles(i,4) = subplot(vl,6,(i-1)*6+4);
        hold on
        plot(t, theta_deg, color_choices{result}, 'LineWidth', 1.5)
        grid on
        xlabel('Time [s]')
        ylabel('\theta [deg]')
        title('Pitch Angle')

        %% Plot 5 - Angle of attack
        ax_handles(i,5) = subplot(vl,6,(i-1)*6+5);
        hold on
        plot(t, alpha_deg, color_choices{result}, 'LineWidth', 1.5)
        grid on
        xlabel('Time [s]')
        ylabel('\alpha [deg]')
        title('Angle of Attack')

        %% Plot 6 - Pitch rate
        ax_handles(i,6) = subplot(vl,6,(i-1)*6+6);
        hold on
        plot(t, pitch_r, color_choices{result}, 'LineWidth', 1.5)
        grid on
        xlabel('Time [s]')
        ylabel('q [rad/s]')
        title('Pitch Rate')

    end
end

%% Save original positions

original_positions = cell(vl,6);

for i = 1:vl
    for k = 1:6
        original_positions{i,k} = ax_handles(i,k).Position;
    end
end

%% Store information needed by the callback

fig.UserData.ax_handles = ax_handles;
fig.UserData.original_positions = original_positions;
fig.UserData.enlarged = false;
fig.UserData.selected_axes = [];

%% Enable click-to-enlarge

fig.WindowButtonDownFcn = @toggle_axes_size;

%% Overall figure title

sgtitle('Aircraft State Response — Different Initial Airspeeds')


%% Click-to-enlarge callback

function toggle_axes_size(fig, ~)

    % Find the graphics object that was clicked
    clicked_object = hittest(fig);

    % Find the axes containing that object
    clicked_axes = ancestor(clicked_object, 'axes');

    % Ignore clicks outside the plots
    if isempty(clicked_axes)
        return
    end

    %% If a plot is already enlarged -> restore it

    if fig.UserData.enlarged

        selected_axes = fig.UserData.selected_axes;

        % Restore original position
        selected_axes.Position = ...
            fig.UserData.original_positions{selected_axes.UserData.row, ...
                                             selected_axes.UserData.column};

        % Restore normal axes stacking
        selected_axes.Layer = 'bottom';

        fig.UserData.enlarged = false;
        fig.UserData.selected_axes = [];

        return
    end

    %% Find which subplot was clicked

    ax_handles = fig.UserData.ax_handles;

    [row, column] = find(ax_handles == clicked_axes);

    % Safety check
    if isempty(row)
        return
    end

    %% Save its location information

    clicked_axes.UserData.row = row;
    clicked_axes.UserData.column = column;

    %% Enlarge selected plot

    clicked_axes.Position = [0.08 0.12 0.86 0.78];

    % Bring the selected axes visually to the front
    uistack(clicked_axes, "top");

    % Remember selected axes
    fig.UserData.enlarged = true;
    fig.UserData.selected_axes = clicked_axes;

end