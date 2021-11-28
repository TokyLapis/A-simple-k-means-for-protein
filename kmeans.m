% my_kmeans
% By Chris, zchrissirhcz@gmail.com
% 2016年9月30日 19:13:43
clc
clear
% 簇心数目k
K = 4;

% 准备数据，假设是2维的,80条数据，从data.txt中读取
% data = zeros(100, 2);
load 'datata.txt'; % 直接存储到data变量中

x = datata(:,1);
y = datata(:,2);

% 绘制数据，2维散点图
% x,y: 要绘制的数据点  20:散点大小相同，均为20  'blue':散点颜色为蓝色
s = scatter(x, y, 20, 'blue');
title('Original data：Blue；Initial cluster center：Red');

% 初始化簇心
sample_num = size(datata, 1);       % 样本数量
sample_dimension = size(datata, 2); % 每个样本特征维度

% 暂且手动指定簇心初始位置
clusters = zeros(K, sample_dimension);
clusters(1,:) = [-1,2];
clusters(2,:) = [5,2];
clusters(3,:) = [-1,-0.5];
clusters(4,:) = [1,-4];

hold on; % 在上次绘图（散点图）基础上，准备下次绘图
% 绘制初始簇心
scatter(clusters(:,1), clusters(:,2), 'red', 'filled'); % 实心圆点，表示簇心初始位置

c = zeros(sample_num, 1); % 每个样本所属簇的编号

PRECISION = 0.0001;


iter = 5; % 假定最多迭代100次
for i=1:iter
    % 遍历所有样本数据，确定所属簇。公式1
    for j=1:sample_num
        %t = arrayfun(@(item) item
        %[min_val, idx] = min(t);
        gg = repmat(datata(j,:), K, 1);
        gg = gg - clusters;   % norm:计算向量模长
        tt = arrayfun(@(n) norm(gg(n,:)), (1:K));
        [minVal, minIdx] = min(tt);
        % data(j,:)的所属簇心，编号为minIdx
        c(j) = minIdx;
    end
    
%     times = zeros(4,1);
times = ["First";"Second";"Third";"Fourth";"Fifth"];
%     times(1) = 'First';
%     times(2) = 'Second';
%     times(3) = 'Third';
%     times(4) = 'Fourth';
    
    % 遍历所有样本数据，更新簇心。公式2
    convergence = 1;
    for j=1:K
        up = 0;
        down = 0;
        for k=1:sample_num
            up = up + (c(k)==j) * datata(k,:);
            down = down + (c(k)==j);
        end
        new_cluster = up/down;
        delta = clusters(j,:) - new_cluster;
        if (norm(delta) > PRECISION)
            convergence = 0;
        end
        clusters(j,:) = new_cluster;
    end
    figure;
    f = scatter(x, y, 20, 'blue');
    hold on;
    scatter(clusters(:,1), clusters(:,2), 'filled'); % 实心圆点，表示簇心初始位置
    title([ times(i), 'Iteration']);
    
    if (convergence)
        disp(['Converges to', times(i), 'Iteration']);
        break;
    end
end

disp('done');