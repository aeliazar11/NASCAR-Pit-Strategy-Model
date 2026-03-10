%% =========================================================================
%  NASCAR PIT STRATEGY MODEL
%  =========================================================================
%  Author      : Eliazar Alvarez
%  Date        : May 2026
%  Institution : University of Texas at San Antonio
%  Description : Models pit stop strategy decisions for the Daytona 500.
%                Calculates fuel windows, compares 2-stop sequences,
%                and quantifies the time value of pitting under caution.
%                Directly applicable to NASCAR strategy engineering roles.
%  Race        : Daytona 500 — Daytona International Speedway (200 laps)
%  Tools       : MATLAB
%  GitHub      : github.com/aeliazar11/NASCAR-Pit-Strategy-Model
%% =========================================================================
%% --- HOUSEKEEPING ---
clear;
clc;
close all;

%% --- RACE PARAMETERS ---
total_laps      = 200;          % Daytona 500 total laps
lap_length_mi   = 2.5;          % Daytona International Speedway (miles)
race_distance   = total_laps * lap_length_mi;   % 500 miles total

fprintf('--- RACE OVERVIEW ---\n');
fprintf('Race: Daytona 500\n');
fprintf('Track: Daytona International Speedway\n');
fprintf('Laps: %d x %.1f miles = %.0f miles\n', ...
    total_laps, lap_length_mi, race_distance);

%% --- FUEL PARAMETERS ---
% NASCAR Cup Series Next Gen car
% Tank capacity: 18 gallons
% Fuel mileage: approximately 4.5 mpg at Daytona superspeedway
fuel_tank_gal       = 18;           % Tank capacity (gallons)
fuel_mileage_mpg    = 4.5;          % Fuel economy (miles per gallon)
fuel_reserve_gal    = 0.5;          % Safety reserve (gallons)

% Miles per tank and laps per tank
miles_per_tank  = (fuel_tank_gal - fuel_reserve_gal) * fuel_mileage_mpg;
laps_per_tank   = floor(miles_per_tank / lap_length_mi);

fprintf('\n--- FUEL WINDOW ---\n');
fprintf('Tank capacity: %.0f gallons\n', fuel_tank_gal);
fprintf('Fuel mileage: %.1f mpg\n', fuel_mileage_mpg);
fprintf('Miles per tank: %.1f miles\n', miles_per_tank);
fprintf('Maximum laps per tank: %d laps\n', laps_per_tank);

%% --- FUEL LOAD OVER RACE ---
laps        = 1:total_laps;
miles_per_lap = lap_length_mi;

% Fuel consumed each lap
fuel_consumed   = (miles_per_lap / fuel_mileage_mpg);   % gallons per lap
fuel_load       = fuel_tank_gal - (fuel_consumed .* laps);
fuel_load       = max(fuel_load, 0);

%% --- PLOT 1: Fuel Load vs Lap ---
figure(1);
plot(laps, fuel_load, 'b-', 'LineWidth', 2);
xlabel('Lap Number');
ylabel('Fuel Remaining (gallons)');
title('Fuel Load vs Lap — Daytona 500', 'Color', 'black');
yline(fuel_reserve_gal, 'r--', 'Minimum Reserve (0.5 gal)', 'LineWidth', 1.5);
xline(laps_per_tank, 'k--', 'Fuel Window Limit', 'LineWidth', 1.5);
grid on;
set(gcf, 'Color', 'white');
set(gca, 'Color', 'white');
xlim([1 total_laps]);
ylim([0 fuel_tank_gal + 1]);
%% =========================================================================
%  SECTION 2 — FULL RACE FUEL STRATEGY
%% =========================================================================

%% --- MODEL PIT STOP SEQUENCES ---
% A pit stop refuels the car back to full (18 gallons)
% We model where pit stops fall across 200 laps
% Pit stop costs approximately 12-14 seconds at Daytona

pit_stop_time   = 13;       % Time lost per pit stop (seconds)
green_lap_time  = 48.0;     % Average green flag lap time at Daytona (seconds)
caution_lap_time = 72.0;    % Average caution lap time (seconds)

% --- STRATEGY A: Pit every 30 laps (stay inside fuel window) ---
% Pit laps: 30, 60, 90, 120, 150, 180
pit_laps_A = 30:30:180;

% --- STRATEGY B: Stretch fuel to 35 laps (fuel saving mode) ---
% Only possible if driver saves fuel — fewer stops, better track position
% Pit laps: 35, 70, 105, 140, 175
pit_laps_B = 35:35:175;

fprintf('\n--- STRATEGY COMPARISON ---\n');
fprintf('Strategy A (30-lap stints): %d pit stops at laps ', length(pit_laps_A));
fprintf('%d ', pit_laps_A);
fprintf('\nStrategy B (35-lap stints): %d pit stops at laps ', length(pit_laps_B));
fprintf('%d ', pit_laps_B);
fprintf('\n');

%% --- CALCULATE TOTAL PIT TIME LOST ---
total_pit_time_A = length(pit_laps_A) * pit_stop_time;
total_pit_time_B = length(pit_laps_B) * pit_stop_time;

fprintf('\nTotal time lost in pits:\n');
fprintf('Strategy A: %d stops x %ds = %ds lost\n', ...
    length(pit_laps_A), pit_stop_time, total_pit_time_A);
fprintf('Strategy B: %d stops x %ds = %ds lost\n', ...
    length(pit_laps_B), pit_stop_time, total_pit_time_B);
fprintf('Time saved by Strategy B: %ds\n', ...
    total_pit_time_A - total_pit_time_B);

%% --- BUILD LAP TIME ARRAYS FOR EACH STRATEGY ---
% Each lap is either a normal green lap or a pit lap (green + pit time)
lap_times_A = ones(1, total_laps) * green_lap_time;
lap_times_B = ones(1, total_laps) * green_lap_time;

% Add pit stop time penalty on pit laps
lap_times_A(pit_laps_A) = green_lap_time + pit_stop_time;
lap_times_B(pit_laps_B) = green_lap_time + pit_stop_time;

% Cumulative race time for each strategy
cumtime_A = cumsum(lap_times_A);
cumtime_B = cumsum(lap_times_B);

fprintf('\nProjected finish times:\n');
fprintf('Strategy A: %.1f seconds (%.1f minutes)\n', ...
    cumtime_A(end), cumtime_A(end)/60);
fprintf('Strategy B: %.1f seconds (%.1f minutes)\n', ...
    cumtime_B(end), cumtime_B(end)/60);

%% --- PLOT 2: Cumulative Race Time Comparison ---
figure(2);
hold on;
plot(laps, cumtime_A/60, 'b-', 'LineWidth', 2, 'DisplayName', ...
    'Strategy A — 6 stops (every 30 laps)');
plot(laps, cumtime_B/60, 'r-', 'LineWidth', 2, 'DisplayName', ...
    'Strategy B — 5 stops (every 35 laps)');
hold off;

xlabel('Lap Number');
ylabel('Cumulative Race Time (minutes)');
legend('show', 'Location', 'northwest', 'TextColor', 'black', 'Color', 'white');
legend('show', 'Location', 'northwest');
grid on;
set(gcf, 'Color', 'white');
set(gca, 'Color', 'white');
xlim([1 total_laps]);
%% =========================================================================
%  SECTION 3 — STRATEGY DELTA AND CAUTION MODEL
%% =========================================================================

%% --- PLOT 3: Strategy Gap (much easier to read) ---
strategy_delta = cumtime_A - cumtime_B;   % Positive = A is slower than B

figure(3);
hold on;
fill([laps, fliplr(laps)], [strategy_delta, zeros(1,total_laps)], ...
    'red', 'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');
plot(laps, strategy_delta, 'r-', 'LineWidth', 2, ...
    'DisplayName', 'Time advantage of Strategy B over A');
yline(0, 'k--', 'LineWidth', 1, 'HandleVisibility', 'off');
hold off;

xlabel('Lap Number');
ylabel('Time Difference (seconds)');
title('Strategy B Advantage Over Strategy A — Daytona 500', 'Color', 'black');
legend('show', 'Location', 'northwest', 'TextColor', 'black', 'Color', 'white');
grid on;
set(gcf, 'Color', 'white');
set(gca, 'Color', 'white');
xlim([1 total_laps]);

%% --- SECTION 4: CAUTION PERIOD MODEL ---
% This is what makes NASCAR strategy unique vs F1
% Under caution, pit stops are essentially free — you lose no track position
% relative to other cars also pitting
% The crew chief must decide: pit now under caution or stay out?

% Simulate a caution period appearing at lap 45
% Strategy A pitted at lap 30 — still has fuel, could extend to lap 60
% Strategy B pitted at lap 35 — still has fuel, could extend to lap 70

caution_lap     = 45;       % Caution comes out at this lap
caution_length  = 8;        % Caution lasts this many laps

fprintf('\n--- CAUTION SCENARIO ---\n');
fprintf('Caution comes out at lap %d\n', caution_lap);
fprintf('Caution length: approximately %d laps\n', caution_length);
fprintf('\n');

% The crew chief's actual question:
% "If I pit this lap under caution, what do I save vs pitting next 
%  green flag lap?"

% Pitting under GREEN costs: one full fast green lap + pit service
cost_pit_green  = green_lap_time + pit_stop_time;   % 48 + 13 = 61s

% Pitting under CAUTION costs: one slow caution lap + pit service
% BUT you would have run that caution lap anyway
% So the TRUE cost is just the pit service on top of the caution lap
% compared to running a normal caution lap without pitting
cost_pit_caution = caution_lap_time + pit_stop_time; % 72 + 13 = 85s

% However the caution lap without pitting only costs 72s
% So NET extra cost of pitting under caution = 85 - 72 = 13s
net_cost_caution = cost_pit_caution - caution_lap_time;  % = 13s

% NET extra cost of pitting under green = 61s (you lose the whole lap)
net_cost_green   = cost_pit_green;                       % = 61s

% Time saved by pitting under caution instead of waiting for green
time_saved_caution = net_cost_green - net_cost_caution;


% Fuel remaining at caution lap for each strategy
% Strategy A pitted last at lap 30
laps_since_pit_A = caution_lap - 30;
fuel_remaining_A = fuel_tank_gal - (laps_since_pit_A * fuel_consumed);

% Strategy B pitted last at lap 35
laps_since_pit_B = caution_lap - 35;
fuel_remaining_B = fuel_tank_gal - (laps_since_pit_B * fuel_consumed);

fprintf('\nAt caution lap %d:\n', caution_lap);
fprintf('Strategy A — laps since last pit: %d | Fuel remaining: %.1f gal\n', ...
    laps_since_pit_A, fuel_remaining_A);
fprintf('Strategy B — laps since last pit: %d | Fuel remaining: %.1f gal\n', ...
    laps_since_pit_B, fuel_remaining_B);
fprintf('\n');

% Decision logic
fprintf('--- PIT CALL RECOMMENDATION ---\n');
if fuel_remaining_A > 2
    fprintf('Strategy A: STAY OUT — enough fuel to extend, rejoin on fresher cycle\n');
else
    fprintf('Strategy A: PIT NOW — fuel too low to risk staying out\n');
end

if fuel_remaining_B > 2
    fprintf('Strategy B: STAY OUT — enough fuel to extend, rejoin on fresher cycle\n');
else
    fprintf('Strategy B: PIT NOW — fuel too low to risk staying out\n');
end
%% =========================================================================
%  SECTION 5 — CAUTION WINDOW VISUALIZATION
%% =========================================================================
% This plot shows a crew chief's view of the race:
% - Fuel windows for each strategy
% - Where the caution falls
% - Whether each car should pit or stay out

figure(4);
hold on;

%% --- BUILD FUEL LEVEL ACROSS FULL RACE FOR EACH STRATEGY ---
% Tracks actual fuel level accounting for pit stops (refuel to full)
fuel_A = zeros(1, total_laps);
fuel_B = zeros(1, total_laps);

current_fuel_A = fuel_tank_gal;
current_fuel_B = fuel_tank_gal;

for i = 1:total_laps
    % Burn fuel this lap
    current_fuel_A = current_fuel_A - fuel_consumed;
    current_fuel_B = current_fuel_B - fuel_consumed;

    % If this is a pit lap, refuel to full
    if ismember(i, pit_laps_A)
        current_fuel_A = fuel_tank_gal;
    end
    if ismember(i, pit_laps_B)
        current_fuel_B = fuel_tank_gal;
    end

    % Store fuel level
    fuel_A(i) = max(current_fuel_A, 0);
    fuel_B(i) = max(current_fuel_B, 0);
end

%% --- PLOT FUEL LEVELS ---
plot(laps, fuel_A, 'b-', 'LineWidth', 2, ...
    'DisplayName', 'Strategy A fuel (6 stops)');
plot(laps, fuel_B, 'r-', 'LineWidth', 2, ...
    'DisplayName', 'Strategy B fuel (5 stops)');

%% --- ADD CAUTION WINDOW ---
% Shade the caution period
caution_end = caution_lap + caution_length;
xregion(caution_lap, caution_end, 'FaceColor', 'yellow', ...
    'FaceAlpha', 0.3, 'EdgeColor', 'none', 'HandleVisibility', 'off');
text(caution_lap + 1, 16, 'CAUTION', 'FontSize', 9, ...
    'FontWeight', 'bold', 'Color', [0.8 0.6 0]);

%% --- ADD MINIMUM FUEL LINE ---
yline(fuel_reserve_gal, 'k--', 'Min Reserve', ...
    'LineWidth', 1.5, 'HandleVisibility', 'off');

%% --- ADD PIT STOP MARKERS ---
% Blue triangles for Strategy A pit laps
for i = 1:length(pit_laps_A)
    plot(pit_laps_A(i), fuel_tank_gal, 'bv', ...
        'MarkerSize', 8, 'MarkerFaceColor', 'blue', ...
        'HandleVisibility', 'off');
end

% Red triangles for Strategy B pit laps
for i = 1:length(pit_laps_B)
    plot(pit_laps_B(i), fuel_tank_gal - 0.8, 'rv', ...
        'MarkerSize', 8, 'MarkerFaceColor', 'red', ...
        'HandleVisibility', 'off');
end

hold off;

xlabel('Lap Number');
ylabel('Fuel Remaining (gallons)');
title('Fuel Strategy Map — Daytona 500', 'Color', 'black');
legend('show', 'Location', 'northeast', ...
    'TextColor', 'black', 'Color', 'white');
grid on;
set(gcf, 'Color', 'white');
set(gca, 'Color', 'white');
xlim([1 total_laps]);
ylim([0 fuel_tank_gal + 1]);