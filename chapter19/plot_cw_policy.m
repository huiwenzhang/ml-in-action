function plot_cw_policy(pol_pi,CF,s_start,s_end)
[sideII,sideJJ]=size(pol_pi); 
IIdelims = 0:sideII; IIcents = 1:sideII;
JJdelims = 0:sideJJ; JJcents = 1:sideJJ;
% 画悬崖
figure('Position', [100 100 400 200]); 
imagesc( JJcents, IIcents, CF ); colorbar; hold on; 
set(gca, 'Ytick', [1 2 3 4 ], 'Xtick', [1:12], 'FontSize', 9);
% 画开始和结束点:
plot( s_start(2), s_start(1), '^', 'MarkerSize', 10, 'MarkerFaceColor', 'k' ); 
plot( s_end(2), s_end(1), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'k' ); 
axis normal

% fill the vectors:
px = zeros(size(pol_pi)); py = zeros(size(pol_pi)); 
for ii=1:sideII,
  for jj=1:sideJJ,
    switch pol_pi(ii,jj)
     case 1
      %
      % action = UP 
      %
      px(ii,jj) = 0;
      py(ii,jj) = 0.5; 
     case 2
      %
      % action = DOWN
      %
      px(ii,jj) = 0;
      py(ii,jj) = -0.5; 
     case 3
      %
      % action = RIGHT
      %
      px(ii,jj) = 0.5;
      py(ii,jj) = 0; 
     case 4
      %
      % action = LEFT 
      %
      px(ii,jj) = -0.5; 
      py(ii,jj) = 0; 
     case 5
      px(ii,jj) = -0.5; 
      py(ii,jj) = +0.5; 
     case 6
      px(ii,jj) = +0.5; 
      py(ii,jj) = +0.5; 
     case 7
      px(ii,jj) = +0.5; 
      py(ii,jj) = -0.5; 
     case 8
      px(ii,jj) = -0.5; 
      py(ii,jj) = -0.5; 
     otherwise
      error('unknown value of pol_pi(ii,jj)'); 
    end
  end
end

ind0 = find(CF(:)==0); px(ind0)=0; py(ind0)=0; px(sideII,sideJJ)=0; py(sideII,sideJJ)=0; 

%[jjM,iiM]=meshgrid(1:sideJJ,1:sideII);
[jjM,iiM]=meshgrid(JJcents,IIcents);

%quiver(iiM,jjM,px,py,0); 
quiver(jjM,iiM,px,-py,0, 'Color','r', 'LineWidth', 1.5); 