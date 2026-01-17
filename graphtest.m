x = 0:0.1:10;       % 0부터 10까지 0.1 간격으로 생성
y = sin(x);
y = y + 0.5;
figure;             % 새 창 띄우기
plot(x, y, 'r');  % x축, y축, 빨간 점선(r--)
title('Sine Wave'); 
xlabel('Time'); ylabel('Value');
grid on;     
