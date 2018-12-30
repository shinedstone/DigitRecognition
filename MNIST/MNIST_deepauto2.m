clc;
clear all;
close all;

maxepoch = 2^10;
beta = [0:1/1000:0.5 0.5:1/10000:0.9 0.9:1/10000:1.0];
numruns = 100;

converter;
makebatches;

numhid = 500;
[numcases numdims numbatches]=size(batchdata);

testbatchdata2 = rand(10000, numdims) > 0.5;

vishid0 = 0.01*randn(numdims, numhid);
hidbiases0  = zeros(1, numhid);
visbiases0  = zeros(1, numdims);

rbm_rcd;

save mnistrcd vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'b-');
hold on;
figure(3);
plot(Logprob,'bo-');
hold on;
figure(4);
plot(Logprob2,'bo-');
hold on;


rbm_rpcd;

save mnistrpcd vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'r-');
hold on;
figure(3);
plot(Logprob,'rx-');
hold on;
figure(4);
plot(Logprob2,'rx-');
hold on;

rbm_rfpcd;

save mnistrfpcd vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'r-');
hold on;
figure(3);
plot(Logprob,'r+-');
hold on;
figure(4);
plot(Logprob2,'r+-');
hold on;

rbm_rpmcmc;

save mnistrpmcmc vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'k-');
hold on;
figure(3);
plot(Logprob,'k*-');
hold on;
figure(4);
plot(Logprob2,'k*-');
hold on;

rbm_rtmcmc;

save mnistrtmcmc vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'g-');
hold on;
figure(3);
plot(Logprob,'gs-');
hold on;
figure(4);
plot(Logprob2,'gs-');
hold on;

rbm_ramcmc;

save mnistramcmc vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'c-');
hold on;
figure(3);
plot(Logprob,'cd-');
hold on;
figure(4);
plot(Logprob2,'cd-');
hold on;