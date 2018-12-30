clear all;
close all;
clc;

maxepoch = 2000;
beta = 0:1/9999:1.0;
numruns = 100;
numhid = 500;

load usps;

batchdata = zeros(100, 256, 100);
batchtargets = zeros(100, 10, 100);
for i = 1 : 100
    temp1 = permute(data(:,(i-1)*10+1:i*10,:),[2 1 3]);
    temp2 = zeros(100, 256);
    for j = 1 : 10
        temp2((j-1)*10+1:j*10, :) = temp1(:,:,j)>127.5;
        batchtargets((j-1)*10+1:j*10, :, i) = repmat(bitget(2^(10-j),10:-1:1), 10, 1);
    end
    batchdata(:,:,i) = temp2;
end

testbatchdata = zeros(1000, 256);
testbatchtargets = zeros(1000, 10);
temp1 = permute(data(:,1001:1100,:),[2 1 3]);
temp2 = zeros(1000, 256);
for j = 1 : 10
    temp2((j-1)*100+1:j*100, :) = temp1(:,:,j)>127.5;
    testbatchtargets((j-1)*100+1:j*100, :) = repmat(bitget(2^(10-j),10:-1:1), 100, 1);
end
testbatchdata(:,:) = temp2;

testbatchdata2 = rand(1000, 256) > 0.5;

[numcases numdims numbatches]=size(batchdata);

vishid0 = 0.01*randn(numdims,numhid);
hidbiases0  = zeros(1,numhid);
visbiases0  = zeros(1,numdims);

rbm_rcd;
save optrcd vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'b');
hold on;
figure(3);
plot(Logprob,'bo-');
hold on;
figure(4);
plot(Logprob2,'bo-');
hold on;

rbm_rpcd;
save optrpcd vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'r');
hold on;
figure(3);
plot(Logprob,'rx-');
hold on;
figure(4);
plot(Logprob2,'rx-');
hold on;

rbm_rfpcd;
save optrfpcd vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'r');
hold on;
figure(3);
plot(Logprob,'r+-');
hold on;
figure(4);
plot(Logprob2,'r+-');
hold on;
    
rbm_rpmcmc;
save optrpmcmc vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'k');
hold on;
figure(3);
plot(Logprob,'k*-');
hold on;
figure(4);
plot(Logprob2,'k*-');
hold on;

rbm_rtmcmc;
save optrtmcmc vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'g');
hold on;
figure(3);
plot(Logprob,'gs-');
hold on;
figure(4);
plot(Logprob2,'gs-');
hold on;
    
rbm_ramcmc;
save optramcmc vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'c');
hold on;
figure(3);
plot(Logprob,'cd-');
hold on;
figure(4);
plot(Logprob2,'cd-');
hold on;

rbm_ramcmc;
save optramcmc vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'c');
hold on;
figure(3);
plot(Logprob,'cd-');
hold on;
figure(4);
plot(Logprob2,'cd-');
hold on;