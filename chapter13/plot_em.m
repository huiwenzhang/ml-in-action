function plot_em(iter, data, mu, sigma)
% figure;
scatter(data(1:200,1),data(1:200,2),15,'ro','filled');
hold on; box on
scatter(data(201:end,1),data(201:end,2),15,'bo','filled');
% set(gcf, 'Position', [100 100 400 350]);
plotGMM(mu, sigma, [.8 0 0], .5);
title(['EMÀ„∑®(iteration='  num2str(iter) ')']);
hold off
end