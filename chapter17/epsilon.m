function [Eps]=epsilon(x,k)  
  
% Function: [Eps]=epsilon(x,k)  
%  
% Aim:   
% Analytical way of estimating neighborhood radius for DBSCAN  
%  
% Input:   
% x - data matrix (m,n); m-objects, n-variables  
% k - number of objects in a neighborhood of an object  
% output:
%  radius calculate by given MinPts and dataset

[m,n]=size(x);  
Eps=((prod(max(x)-min(x))*k*gamma(.5*n+1))/(m*sqrt(pi.^n))).^(1/n);  