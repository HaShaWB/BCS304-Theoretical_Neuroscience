dt = 0.1;
E_rest = -65; % mV - resting potential

% 시뮬레이션 시간 설정
max_t = 1000;
t_range = 0:dt:max_t;

% 입력 전류 평균값 범위 설정 (새로 추가)
I_mean_min = 0;
I_mean_max = 1.5;
I_mean_step = 0.05;
I_mean_range = I_mean_min:I_mean_step:I_mean_max;

% 표준편차(sig_I) 범위 설정
sig_I_min = 0; % 최소 표준편차
sig_I_max = 4; % 최대 표준편차
sig_I_step = 0.05; % 표준편차 간격
sig_I_range = sig_I_min:sig_I_step:sig_I_max;

% 시행 횟수 설정
num_trials = 100;

% 최초 발화 시간을 저장할 배열 초기화 (2차원으로 확장)
mean_first_spike_times = zeros(length(I_mean_range), length(sig_I_range));
std_first_spike_times = zeros(length(I_mean_range), length(sig_I_range));
firing_probability = zeros(length(I_mean_range), length(sig_I_range));

% 각 I_mean과 sig_I 조합에 대해 시뮬레이션 실행
for m = 1:length(I_mean_range)
    I_base = I_mean_range(m); % 평균 입력 전류 설정

    for i = 1:length(sig_I_range)
        % 1. 시간 간격의 영향을 줄이기 위해 표준편차 조정
        sig_I = sig_I_range(i) / (dt); % 시간 간격에 따른 표준편차 조정

        % 각 시행의 최초 발화 시간을 저장할 배열
        trial_first_spike_times = zeros(1, num_trials);

        % 각 시행에 대해 시뮬레이션 실행
        for trial = 1:num_trials
            % 각 시행마다 다른 랜덤 시드 사용
            rng(42 + trial + (m-1)*100); % 시행과 평균 전류에 따라 다른 시드 사용

            % 정규 분포 노이즈를 가진 입력 전류 생성
            num_steps = length(t_range);
            I_noise = sig_I * randn(1, num_steps) * sqrt(dt); % 시간 간격 고려한 노이즈 생성
            I_inputs = I_base + I_noise;

            V_cur = E_rest;
            s_record = zeros(1, num_steps);

            % 발화 여부를 추적하는 플래그
            spike_found = false;
            first_spike_time = max_t; % 발화가 없는 경우 -> 최댓값 처리

            for t_step = 1:num_steps
                I_input = I_inputs(t_step);

                [V_cur, V_spike] = EulerLIF(V_cur, I_input, dt);
                s_record(t_step) = V_spike;

                % 최초 발화 시간 기록
                if V_spike == 1 && ~spike_found
                    first_spike_time = t_range(t_step);
                    spike_found = true;
                    break; % 최초 발화 시간을 찾았으므로 시뮬레이션 종료
                end
            end

            % 최초 발화 시간 저장
            trial_first_spike_times(trial) = first_spike_time;
        end

        % 2. 기하분포 아이디어를 차용한 최초 발화 시간 통계 계산
        valid_times = trial_first_spike_times(~isnan(trial_first_spike_times));

        if ~isempty(valid_times)
            mean_first_spike_times(m, i) = mean(valid_times);
            std_first_spike_times(m, i) = std(valid_times);
            firing_probability(m, i) = length(valid_times) / num_trials;
        else
            mean_first_spike_times(m, i) = NaN;
            std_first_spike_times(m, i) = NaN;
            firing_probability(m, i) = 0;
        end
    end
end

% 3. 2차원 히트맵 그리기
figure('Position', [100, 100, 1200, 400]);

imagesc(I_mean_range, sig_I_range, mean_first_spike_times');
colormap(flipud(jet));
colorbar;
xlabel('입력 전류 평균 (I_{mean})');
ylabel('입력 전류 노이즈 표준편차 (sig_I)');
title('평균 최초 발화 시간 (ms)');
set(gca, 'YDir', 'normal');
axis square;  % 히트맵을 정사각형으로 만듦
