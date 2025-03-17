dt = 0.1;
E_rest = -65; % mV - resting potential

% 시뮬레이션 시간 설정
max_t = 1000;
t_range = 0:dt:max_t;

% 기본 입력 전류 설정
I_base = 0; % 기본 입력 전류 (mA)

% 표준편차(sig_I) 범위 설정
sig_I_min = 8; % 최소 표준편차
sig_I_max = 9; % 최대 표준편차
sig_I_step = 0.1; % 표준편차 간격
sig_I_range = sig_I_min:sig_I_step:sig_I_max;

% 시행 횟수 설정
num_trials = 100;

firing_rates = zeros(size(sig_I_range));

trial_firing_rates = zeros(num_trials, length(sig_I_range));

% 각 sig_I에 대해 시뮬레이션 실행
for i = 1:length(sig_I_range)
    sig_I = sig_I_range(i);

    % 각 시행에 대해 시뮬레이션 실행
    for trial = 1:num_trials
        % 각 시행마다 다른 랜덤 시드 사용
        rng(42 + trial); % 시행마다 다른 시드 사용

        % 정규 분포 노이즈를 가진 입력 전류 생성
        num_steps = length(t_range);
        I_noise = sig_I * randn(1, num_steps);
        I_inputs = I_base + I_noise;

        V_cur = E_rest;


        s_record = zeros(1, num_steps);

        for t_step = 1:num_steps
            I_input = I_inputs(t_step);

            [V_cur, V_spike] = EulerLIF(V_cur, I_input, dt);
            s_record(t_step) = V_spike;
        end

        trial_firing_rates(trial, i) = sum(s_record) / max_t * 1000;
    end

    firing_rates(i) = mean(trial_firing_rates(:, i));
end

figure;
hold on;
for trial = 1:num_trials
    plot(sig_I_range, trial_firing_rates(trial, :), 'b-', 'LineWidth', 0.5);
end
plot(sig_I_range, firing_rates, 'k+', 'LineWidth', 2, 'DisplayName', '평균');
xlabel('입력 전류 노이즈 표준편차 (sig_I)');
ylabel('발화율 (Hz)');
title('노이즈 표준편차에 따른 발화율 변화 - 개별 시행 및 평균');
grid on;


