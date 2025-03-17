dt = 0.1;
E_rest = -65; % mV - resting potential (EulerLIF 함수에서 사용되는 값)

% 시뮬레이션 시간 설정
max_t = 1000;
t_range = 0:dt:max_t;

% 기본 입력 전류 설정
I_base = 0; % 기본 입력 전류 (mA)

% 표준편차(sig_I) 범위 설정
sig_I_min = 0; % 최소 표준편차
sig_I_max = 10; % 최대 표준편차
sig_I_step = 0.1; % 표준편차 간격
sig_I_range = sig_I_min:sig_I_step:sig_I_max;

% 시행 횟수 설정
num_trials = 5;

% 각 sig_I에 대한 발화율을 저장할 배열
firing_rates = zeros(size(sig_I_range));
% 각 시행의 발화율을 저장할 배열
trial_firing_rates = zeros(num_trials, length(sig_I_range));
% 각 sig_I에 대한 발화율의 분산을 저장할 배열
firing_variances = zeros(size(sig_I_range));

% 각 sig_I에 대해 시뮬레이션 실행
for i = 1:length(sig_I_range)
    sig_I = sig_I_range(i);

    % 각 시행에 대해 시뮬레이션 실행
    for trial = 1:num_trials
        % 각 시행마다 다른 랜덤 시드 사용
        rng(42 + trial); % 시행마다 다른 시드 사용

        % 정규 분포 노이즈를 가진 입력 전류 생성
        num_steps = length(t_range);
        I_noise = sig_I * randn(1, num_steps); % 평균 0, 표준편차 sig_I인 정규 분포 노이즈
        I_inputs = I_base + I_noise; % 기본 전류에 노이즈 추가

        % 시뮬레이션 초기화
        V_cur = E_rest;

        % 스파이크 기록을 위한 배열 사전 할당
        s_record = zeros(1, num_steps);

        % 주어진 sig_I에 대해 시뮬레이션 실행
        for t_step = 1:num_steps
            % 현재 시간 단계의 입력 전류 사용
            I_input = I_inputs(t_step);

            % 음수 전류는 0으로 처리 (선택적)
            if I_input < 0
                I_input = 0;
            end

            [V_cur, V_spike] = EulerLIF(V_cur, I_input, dt);
            s_record(t_step) = V_spike;
        end

        % 발화율 계산 (Hz)
        trial_firing_rates(trial, i) = sum(s_record) / max_t * 1000;
    end

    % 발화율의 평균 계산
    firing_rates(i) = mean(trial_firing_rates(:, i));
    % 발화율의 분산 계산
    firing_variances(i) = var(trial_firing_rates(:, i));
end

% 각 시행의 결과도 함께 표시
figure;
hold on;
for trial = 1:num_trials
    plot(sig_I_range, trial_firing_rates(trial, :), 'b-', 'LineWidth', 0.5);
end
plot(sig_I_range, firing_rates, 'k+', 'LineWidth', 2, 'DisplayName', '평균');

% 분산을 표시하는 두 번째 y축 생성
yyaxis right;
plot(sig_I_range, firing_variances, 'r-', 'LineWidth', 2, 'DisplayName', '분산');
ylabel('발화율 분산');

% 범례 추가
legend('개별 시행', '평균', '분산');

xlabel('입력 전류 노이즈 표준편차 (sig_I)');
yyaxis left;
ylabel('발화율 (Hz)');
title('노이즈 표준편차에 따른 발화율 변화 - 개별 시행, 평균 및 분산');
grid on;


