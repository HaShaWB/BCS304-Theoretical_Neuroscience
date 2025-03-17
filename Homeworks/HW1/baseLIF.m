% baseLIF.m

V_cur = -65;

I_input = 1.25; %mA
t_step = 1;
max_t = 100;
% 배열 사전 할당
num_steps = length(0:dt:max_t);
v_record = zeros(1, num_steps);
t_record = zeros(1, num_steps);
s_record = zeros(1, num_steps);

for t=0:dt:max_t
    [V_cur, V_spike] = EulerLIF(V_cur, I_input);

    v_record(t_step) = V_cur;
    t_record(t_step) = t;
    s_record(t_step) = V_spike;
    t_step = t_step + 1;
end

Firing_Hz = sum(s_record) / max_t * 1000

figure;
hold on;

plot(t_record, v_record, 'b', 'DisplayName', '전압(V)');
xlabel('시간 (ms)');
ylabel('전압 (mV)');
title('LIF Model');
legend show;

plot(t_record, s_record, 'r.', 'DisplayName', '스파이크');
hold off;
