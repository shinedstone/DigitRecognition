clear all;
close all;
clc;

maxepoch = 3000;
beta = 0:1/4999:1.0;
numruns = 100;
numhid = 100;

f = fopen('optdigitstra.tra','r');
batchdata = zeros(100,64,38);
batchtarget = zeros(100,10,38);
for j = 1 : 38
    for i = 1 : 100
        temp = str2num(fgetl(f));
        batchdata(i,:,j) = temp(1:end-1) > 8;
        if temp(end) == 0
            batchtarget(i,:,j) = [1 0 0 0 0 0 0 0 0 0];
        elseif temp(end) == 1
            batchtarget(i,:,j) = [0 1 0 0 0 0 0 0 0 0];
        elseif temp(end) == 2
            batchtarget(i,:,j) = [0 0 1 0 0 0 0 0 0 0];
        elseif temp(end) == 3
            batchtarget(i,:,j) = [0 0 0 1 0 0 0 0 0 0];
        elseif temp(end) == 4
            batchtarget(i,:,j) = [0 0 0 0 1 0 0 0 0 0];
        elseif temp(end) == 5
            batchtarget(i,:,j) = [0 0 0 0 0 1 0 0 0 0];
        elseif temp(end) == 6
            batchtarget(i,:,j) = [0 0 0 0 0 0 1 0 0 0];
        elseif temp(end) == 7
            batchtarget(i,:,j) = [0 0 0 0 0 0 0 1 0 0];
        elseif temp(end) == 8
            batchtarget(i,:,j) = [0 0 0 0 0 0 0 0 1 0];
        elseif temp(end) == 9
            batchtarget(i,:,j) = [0 0 0 0 0 0 0 0 0 1];
        end
    end
end

g = fopen('optdigitstra.tra','r');
testbatchdata = zeros(1800,64);
testbatchtarget = zeros(1800,10);
for i = 1 : 1800
    temp = str2num(fgetl(g));
    testbatchdata(i,1:64) = temp(1:end-1)>8;
    if temp(end) == 0
        testbatchtarget(i,:) = [1 0 0 0 0 0 0 0 0 0];
    elseif temp(end) == 1
        testbatchtarget(i,:) = [0 1 0 0 0 0 0 0 0 0];
    elseif temp(end) == 2
        testbatchtarget(i,:) = [0 0 1 0 0 0 0 0 0 0];
    elseif temp(end) == 3
        testbatchtarget(i,:) = [0 0 0 1 0 0 0 0 0 0];
    elseif temp(end) == 4
        testbatchtarget(i,:) = [0 0 0 0 1 0 0 0 0 0];
    elseif temp(end) == 5
        testbatchtarget(i,:) = [0 0 0 0 0 1 0 0 0 0];
    elseif temp(end) == 6
        testbatchtarget(i,:) = [0 0 0 0 0 0 1 0 0 0];
    elseif temp(end) == 7
        testbatchtarget(i,:) = [0 0 0 0 0 0 0 1 0 0];
    elseif temp(end) == 8
        testbatchtarget(i,:) = [0 0 0 0 0 0 0 0 1 0];
    elseif temp(end) == 9
        testbatchtarget(i,:) = [0 0 0 0 0 0 0 0 0 1];
    end
end

testbatchdata2 = rand(1800,64) > rand(1800,64);

[numcases numdims numbatches]=size(batchdata);

vishid0 = 0.01*randn(numdims,numhid);
hidbiases0  = zeros(1,numhid);
visbiases0  = zeros(1,numdims);

tic
rbm_rcd;
toc
save optrcd vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'b-');
hold on;
figure(3);
plot(Logprob,'bo-');
hold on;
figure(4);
plot(Logprob2,'bo-');
hold on;

tic
rbm_rpcd;
toc
save optrpcd vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'r-');
hold on;
figure(3);
plot(Logprob,'rx-');
hold on;
figure(4);
plot(Logprob2,'rx-');
hold on;

tic
rbm_rfpcd;
toc
save optrfpcd vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'r-');
hold on;
figure(3);
plot(Logprob,'r+-');
hold on;
figure(4);
plot(Logprob2,'r+-');
hold on;
    
tic
rbm_rpmcmc;
toc
save optrpmcmc vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'k-');
hold on;
figure(3);
plot(Logprob,'k*-');
hold on;
figure(4);
plot(Logprob2,'k*-');
hold on;

tic
rbm_rtmcmc;
toc
save optrtmcmc vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'g-');
hold on;
figure(3);
plot(Logprob,'gs-');
hold on;
figure(4);
plot(Logprob2,'gs-');
hold on;

tic
rbm_ramcmc;
toc
save optramcmc vishid hidbiases visbiases Error Logprob Logprob2;

figure(2);
plot(Error,'c-');
hold on;
figure(3);
plot(Logprob,'cd-');
hold on;
figure(4);
plot(Logprob2,'cd-');
hold on;