# NASCAR Pit Strategy Model

MATLAB model simulating pit stop strategy decisions for the 
Daytona 500. Models fuel consumption, strategy comparison, 
and caution period decision logic.

## What This Project Models
- Fuel consumption and pit window calculation for a NASCAR Cup car
- Two-strategy comparison: 6-stop vs 5-stop across 200 laps
- Caution period analysis — quantifies time saved pitting under 
  caution vs green flag (48 seconds at Daytona)
- Full race fuel map showing fuel levels, pit stop timing, 
  and caution windows across all 200 laps

## Key Results
- Strategy B (5 stops, 35-lap stints) saves 13 seconds over 
  Strategy A (6 stops, 30-lap stints) in pure pit time
- Pitting under caution saves approximately 48 seconds vs 
  pitting under green flag — the dominant strategic factor
- At caution lap 45, both strategies had sufficient fuel to 
  extend stints, recommending staying out for track position

## Tools
- MATLAB

## Background
Built as part of a motorsports engineering portfolio targeting 
NASCAR, IndyCar, and IMSA strategy engineering roles. 
Caution period modeling is specific to NASCAR and directly 
reflects real crew chief decision-making at superspeedway events.

## Author
Eliazar Alvarez — Mechanical Engineering, UTSA
