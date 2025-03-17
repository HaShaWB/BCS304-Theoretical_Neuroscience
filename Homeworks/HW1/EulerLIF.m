% EulerLIF.m
    function [V_next, V_spike] = EulerLIF(V_cur, I_input, dt)
    E_rest = -65; % mV - resting potential
    tau = 20; % ms - fire 후 다시 resting potential으로 돌아가는데 걸리는 시간에 비례하는 모델링 상의 상수
    R = 10; % Ohm - 막 사이의 저항
    V_threshold = -55; % mV - fire가 일어나는 threshold

    dV_dt = ((E_rest - V_cur) + R * I_input) / tau;
    deltaV = dV_dt * dt;
    V_next = V_cur + deltaV;

    % Matlab이 어색해서 그냥 If문으로 처리함

    if V_next >= V_threshold
        V_next = E_rest;
        V_spike = 1;
    else
        V_spike = 0;

    end
end