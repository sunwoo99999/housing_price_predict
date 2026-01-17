%% 1. 초기화 및 데이터 로드 (강력한 에러 방지 적용)
clear; clc; close all;

filename = 'Housing.csv';

% 파일 선택 창 (파일 못 찾을 경우 대비)
if ~isfile(filename)
    fprintf('파일을 찾을 수 없습니다. 다운로드한 CSV 파일을 선택해주세요.\n');
    [file, path] = uigetfile('*.csv', 'Housing.csv 파일 선택');
    if isequal(file, 0), error('파일 선택 취소됨'); end
    filename = fullfile(path, file);
end

% 옵션: 변수명 원본 유지하며 읽기
data = readtable(filename, 'PreserveVariableNames', true);

% 데이터가 너무 작거나 잘못 읽혔는지 확인
if width(data) < 2
    error('데이터 컬럼이 부족합니다. CSV 파일이 올바른지 확인해주세요.');
end

disp('--- Raw Data Loaded ---');
disp(data(1:3, :));

%% 2. 변수명 정규화 (핵심 디버깅 포인트)
% 1. 모든 특수문자 제거 후 소문자로 변환 (Price, price, Price(USD) -> price)
original_names = data.Properties.VariableNames;
new_names = lower(regexprep(original_names, '\W', '')); % \W: 알파벳/숫자 외 제거
data.Properties.VariableNames = new_names;

% 2. 'price' 변수 찾기 (못 찾으면 첫 번째 컬럼을 가격으로 지정)
if ismember('price', data.Properties.VariableNames)
    target_var = 'price';
    fprintf('>> 타겟 변수 "price"를 찾았습니다.\n');
else
    % 만약 price가 없다면 첫 번째 컬럼을 price로 가정하고 이름 변경
    target_var = 'price';
    data.Properties.VariableNames{1} = target_var;
    fprintf('>> "price" 변수명을 찾지 못해, 첫 번째 컬럼("%s")을 "price"로 변경합니다.\n', original_names{1});
end

%% 3. 데이터 전처리 (Categorical -> Numeric)
% 텍스트('yes'/'no')를 숫자로 변환
cat_vars = {'mainroad', 'guestroom', 'basement', 'hotwaterheating', 'airconditioning', 'prefarea'};

for i = 1:length(cat_vars)
    var_name = cat_vars{i};
    if ismember(var_name, data.Properties.VariableNames)
        % 'yes' -> 1, 그 외 -> 0
        data.(var_name) = double(strcmp(data.(var_name), 'yes'));
    end
end

if ismember('furnishingstatus', data.Properties.VariableNames)
    data.furnishingstatus = double(categorical(data.furnishingstatus));
end

%% 4. 변수 간 상관관계 히트맵
figure('Name', 'Correlation Heatmap', 'Color', 'w');
numeric_data = data{:, varfun(@isnumeric, data, 'OutputFormat', 'uniform')};
corr_matrix = corr(numeric_data);
h = heatmap(data.Properties.VariableNames, data.Properties.VariableNames, corr_matrix);
h.Title = 'Variable Correlation Matrix';

%% 5. 다중회귀분석 (Error Fix: 안전한 구문 사용)
% 데이터 분할
cv = cvpartition(height(data), 'HoldOut', 0.2);
train_data = data(training(cv), :);
test_data = data(test(cv), :);

disp('--- Training Regression Model ---');

% [수정] 'price ~ .' 대신 명시적인 ResponseVar 옵션 사용
% 이렇게 하면 수식 파싱 에러(Unable to understand...)를 피할 수 있습니다.
mdl = fitlm(train_data, 'ResponseVar', target_var);

disp(mdl);

%% 6. 모델 성능 평가
y_true = test_data.(target_var);
y_pred = predict(mdl, test_data);

% R-Squared & RMSE
mse_val = mean((y_true - y_pred).^2);
rmse_val = sqrt(mse_val);
r2_val = mdl.Rsquared.Ordinary;

fprintf('\n>>> [Model Performance] <<<\n');
fprintf('1. R-Squared (Test) : %.4f\n', r2_val);
fprintf('2. RMSE             : %.2f\n', rmse_val);

%% 7. 결과 시각화
figure('Name', 'Regression Results', 'Color', 'w');
subplot(2,1,1);
scatter(y_true, y_pred, 50, 'b', 'filled', 'MarkerFaceAlpha', 0.5);
hold on;
plot([min(y_true) max(y_true)], [min(y_true) max(y_true)], 'r--', 'LineWidth', 2);
xlabel('Actual Price'); ylabel('Predicted Price');
title('Actual vs Predicted');
grid on;

subplot(2,1,2);
stem(y_true - y_pred, 'k', 'Marker', 'none');
title('Residuals (Errors)');
grid on;

