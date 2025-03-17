dt = 0.001;

del_I = 1e-12;


% I_input 범위 설정
I_min = 1+4e-11; % 최소 입력 전류 (mA)
I_max = 1+4e-11+del_I; % 최대 입력 전류 (mA)
I_step = del_I / 10; % 입력 전류 간격 (mA)
I_range = I_min:I_step:I_max;

% 시뮬레이션 시간 설정
max_t = 10000;
t_range = 0:dt:max_t;

% 각 I_input에 대한 발화율을 저장할 배열
firing_rates = zeros(size(I_range));

% 각 I_input에 대해 시뮬레이션 실행
for i = 1:length(I_range)
    I_input = I_range(i);
    V_cur = E_rest;
    t_step = 1;  % 0에서 1로 변경

    % 배열 사전 할당
    num_steps = length(t_range);
    s_record = zeros(1, num_steps);

    % 주어진 I_input에 대해 시뮬레이션 실행
    for t = t_range
        [V_cur, V_spike] = EulerLIF(V_cur, I_input, dt);
        s_record(t_step) = V_spike;
        t_step = t_step + 1;
    end

    % 발화율 계산 (Hz)
    firing_rates(i) = sum(s_record) / max_t * 1000;
end

% I-F curve 그리기
figure;
plot(I_range, firing_rates, 'b-', 'LineWidth', 2);
xlabel('입력 전류 (mA)');
ylabel('발화율 (Hz)');
title('I-F Curve - LIF 모델');
grid on;

