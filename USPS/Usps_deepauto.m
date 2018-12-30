clc;
clear all;
close all;

maxepoch = 2000;
numhid = 500;

load usps;

batchdata = zeros(100, 256, 100);
batchtarget = zeros(100, 10, 100);
for i = 1 : 100
    temp1 = permute(data(:,(i-1)*10+1:i*10,:),[2 1 3]);
    temp2 = zeros(100, 256);
    for j = 1 : 10
        temp2((j-1)*10+1:j*10, :) = temp1(:,:,j)>127.5;
        batchtarget((j-1)*10+1:j*10, :, i) = repmat(bitget(2^(10-j),10:-1:1), 10, 1);
    end
    batchdata(:,:,i) = temp2;
end

testbatchdata = zeros(1000, 256);
testbatchtarget = zeros(1000, 10);
temp1 = permute(data(:,1001:1100,:),[2 1 3]);
temp2 = zeros(1000, 256);
for j = 1 : 10
    temp2((j-1)*100+1:j*100, :) = temp1(:,:,j)>127.5;
    testbatchtarget((j-1)*100+1:j*100, :) = repmat(bitget(2^(10-j),10:-1:1), 100, 1);
end
testbatchdata(:,:) = temp2;

[numcases numdims numbatches]=size(batchdata);

vishid0 = 0.01*randn(numdims,numhid);
hidbiases0  = zeros(1,numhid);
visbiases0  = zeros(1,numdims);

numlabel=10;
labhid0 = 0.01*randn(numlabel,numhid);
labbiases0  = zeros(1,numlabel);

rbm_cd;
save uspscd vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'b');
hold on;
figure(3);
plot(RBMClassification,'bo-');
hold on;

rbm_pcd;
save uspspcd vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'r');
hold on;
figure(3);
plot(RBMClassification,'rx-');
hold on;

rbm_fpcd;
save uspsfpcd vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'r');
hold on;
figure(3);
plot(RBMClassification,'r+-');
hold on;

rbm_pmcmc;
save uspspmcmc vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'k');
hold on;
figure(3);
plot(RBMClassification,'k*-');
hold on;

rbm_tmcmc;
save uspstmcmc vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'g');
hold on;
figure(3);
plot(RBMClassification,'gs-');
hold on;
    
rbm_amcmc;
save uspsamcmc vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'c');
hold on;
figure(3);
plot(RBMClassification,'cd-');
hold on;