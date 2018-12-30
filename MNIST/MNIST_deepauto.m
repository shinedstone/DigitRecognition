clc;
clear all;
close all;

maxepoch=2^10;

converter;
makebatches;

numhid = 500;
numdims = 784;
numcases = 100;
numbatches = 600;
numlabel = 10;

vishid0 = 0.01*randn(numdims,numhid);
hidbiases0  = zeros(1,numhid);
visbiases0  = zeros(1,numdims);

labhid0 = 0.01*randn(numlabel, numhid);
labbiases0 = zeros(1, numlabel);

tic
rbm_cd;
toc
save mnistcd vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'b-');
hold on;
figure(3);
plot(RBMClassification,'bo-');
hold on;

tic
rbm_pcd;
toc
save mnistpcd vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'r-');
hold on;
figure(3);
plot(RBMClassification,'rx-');
hold on;

tic
rbm_fpcd;
toc
save mnistfpcd vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'r-');
hold on;
figure(3);
plot(RBMClassification,'r+-');
hold on;

tic
rbm_pmcmc;
toc
save mnistpmcmc vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'k-');
hold on;
figure(3);
plot(RBMClassification,'k*-');
hold on;

tic
rbm_tmcmc;
toc
save mnisttmcmc vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'g-');
hold on;
figure(3);
plot(RBMClassification,'gs-');
hold on;

tic
rbm_amcmc;
toc
save mnistamcmc vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'c-');
hold on;
figure(3);
plot(RBMClassification,'cd-');
hold on;