% The function needs to include year info month info and the temperature
% info then the output must be energy demand
% Function must be mirrored according to Tb balance point
% The output will be ED electricity demand
% The inputs Y as year, M as month number, T as temperature mean
% The  constants are, A,B,C,D and Tb as balance point
% The function => ED = A*((Y-B)*12+M)+C*((Y-B)*12+M)*(T-Tb)^2+D
% mapping x(1)=A, x(2)=B, x(3)=C, x(4)=Tb, x(5)=D xdata(1)=Y, xdata(2)=M, xdata(3)=T,
% xdata(4)=ED

clear all
clc
xdata=dlmread('datas.csv','\t',1,0);
%xdata=xdata(127:end,:);%Cut Economical Crysis
Y=xdata(:,1);
M=xdata(:,2);
T=xdata(:,3);
ED=xdata(:,4);

fun = @(x,xdata) x(1).*((xdata(:,1)-x(2)).*12+xdata(:,2))+x(3).*((xdata(:,1)-x(2)).*12+xdata(:,2)).*(xdata(:,3)-x(4)).^2+x(5);
x0 = [1,1900,1,1,1];
lb = [];
ub = [];

%options = optimoptions(@lsqcurvefit,'Algorithm','levenberg-marquardt','MaxIterations',10000,'MaxFunctionEvaluations',10000,'FunctionTolerance',1e-12,'StepTolerance',1e-12)

options = optimset ('Algorithm','levenberg-marquardt','MaxIter',10000,'MaxFunEvals',10000,'TolFun',1e-12,'TolX',1e-12)

x = lsqcurvefit(fun,x0,xdata,ED,lb,ub,options);
disp(x)

t = 1:1:length(ED);
figure(1)
plot(t,ED,'k-',t,fun(x,xdata),'b-')
legend('Data','Fitted exponential')
title('Data and Fitted Curve')

mape=errperf(ED,fun(x,xdata),'mape')
rmse=errperf(ED,fun(x,xdata),'rmse')
