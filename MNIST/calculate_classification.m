function [classification_result] = calculate_classification(vishid,hidbiases,visbiases,labhid,labbiases,testbatchdata,testbatchtargets)
[numcases numdims numbatches] = size(testbatchdata);
result = zeros(1, numbatches);
for j = 1 : numbatches
    energy = zeros(numcases,1);
    rbm_class = zeros(numcases,10);
        for i = 1 : 10
            previous_energy = energy;
            previous_class = rbm_class;
            rbm_class = repmat(bitget(2^(10-i), 10:-1:1), numcases, 1);
            energy = testbatchdata(:,:,j)*visbiases'+rbm_class*labbiases'+sum(log(1+exp(repmat(hidbiases,numcases,1)+testbatchdata(:,:,j)*vishid+rbm_class*labhid)),2);
            swap_flag = energy > previous_energy;
            stay_flag = 1 - swap_flag;
            energy = swap_flag.*energy + stay_flag.*previous_energy;
            rbm_class = repmat(swap_flag,1,10).*rbm_class + repmat(stay_flag,1,10).*previous_class;
        end
    result(j) = sum(sum(abs(testbatchtargets(:,:,j) - rbm_class),2)==0,1)/numcases*100;
end
classification_result = mean(result);