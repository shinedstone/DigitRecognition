clc;
clear all;
close all;

maxepoch = 3000;
numhid = 100;

f = fopen('optdigitstra.tra','r');
batchdata = zeros(100,64,38);
batchtarget = zeros(100,10,38);
for j = 1 : 38
    for i = 1 : 100
        temp = str2num(fgetl(f));
        batchdata(i,:,j) = temp(1:end-1)>8;
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

[numcases numdims numbatches]=size(batchdata);

vishid0 = 0.01*randn(numdims,numhid);
hidbiases0  = zeros(1,numhid);
visbiases0  = zeros(1,numdims);

numlabel=10;
labhid0 = 0.01*randn(numlabel,numhid);
labbiases0  = zeros(1,numlabel);

rbm_cd;
save optcd vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'b-');
hold on;
figure(3);
plot(RBMClassification,'bo-');
hold on;

rbm_pcd;
save optpcd vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'r-');
hold on;
figure(3);
plot(RBMClassification,'rx-');
hold on;

rbm_fpcd;
save optfpcd vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'r-');
hold on;
figure(3);
plot(RBMClassification,'r+-');
hold on;

rbm_pmcmc;
save optpmcmc vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'k-');
hold on;
figure(3);
plot(RBMClassification,'k*-');
hold on;

rbm_tmcmc;
save opttmcmc vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'g-');
hold on;
figure(3);
plot(RBMClassification,'gs-');
hold on;

rbm_amcmc;
save optamcmc vishid hidbiases visbiases labhid labbiases Error RBMClassification;

figure(2);
plot(Error,'c-');
hold on;
figure(3);
plot(RBMClassification,'cd-');
hold on;