%% Initializing symmetric weights and biases.
vishid = vishid0;
hidbiases  = hidbiases0;
visbiases  = visbiases0;

poshidprobs = zeros(numcases,numhid);
neghidprobs = zeros(numcases,numhid);
posprods    = zeros(numdims,numhid);
negprods    = zeros(numdims,numhid);
vishidinc  = zeros(numdims,numhid);
hidbiasinc = zeros(1,numhid);
visbiasinc = zeros(1,numdims);
batchposhidprobs = zeros(numcases,numhid,numbatches);
Error = zeros(1,maxepoch);
Logprob = [];
Logprob2 = [];

nchain = 100;
negdata = zeros(nchain,numdims);
for i = 1 : 500
    neghidprobs = 1./(1 + exp(-negdata*vishid-repmat(hidbiases,nchain,1)));
    neghidstates = neghidprobs > rand(nchain,numhid);
    negdata=1./(1 + exp(-neghidstates*vishid'-repmat(visbiases,nchain,1)));
    negdata = negdata > rand(nchain,numdims);
end

for epoch = 1:maxepoch
    fprintf(1,'pcd - epoch %d\r',epoch);
    errsum = 0;
    temperature = 0.9 + 0.2*epoch/maxepoch;
    epsilonw      = 0.05/(1+epoch/300);
    epsilonvb     = 0.05/(1+epoch/300);
    epsilonhb     = 0.05/(1+epoch/300);
    for batch = 1:numbatches
        %%%%%%%%% START POSITIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        data = batchdata(:,:,batch);
        poshidprobs = 1./(1 + exp( - data*vishid - repmat(hidbiases,numcases,1)));
        batchposhidprobs(:,:,batch) = poshidprobs;
        posprods    = data' * poshidprobs;
        poshidact   = sum(poshidprobs);
        posvisact = sum(data);
        
        %%%%%%%%% END OF POSITIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        poshidstates = poshidprobs > rand(numcases,numhid);
        
        %%%%%%%%% START NEGATIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        neghidprobs = 1./(1 + exp( - negdata*(temperature*vishid) - repmat(temperature*hidbiases,nchain,1)));
        negprods  = negdata'*neghidprobs;
        neghidact = sum(neghidprobs);
        negvisact = sum(negdata);
        
        neghidstates = neghidprobs > rand(nchain,numhid);
        negdata = 1./(1 + exp( - neghidstates*(temperature*vishid') - repmat(temperature*visbiases,nchain,1)));
        negdata = negdata > rand(nchain,numdims);
        
        %%%%%%%%% END OF NEGATIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if epoch>maxepoch/2
            momentum=finalmomentum;
        else
            momentum=initialmomentum;
        end;
        
        %%%%%%%%% UPDATE WEIGHTS AND BIASES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        vishidinc = momentum*vishidinc + epsilonw*(posprods/numcases-negprods/nchain);
        visbiasinc = momentum*visbiasinc + epsilonvb*(posvisact/numcases-negvisact/nchain);
        hidbiasinc = momentum*hidbiasinc + epsilonhb*(poshidact/numcases-neghidact/nchain);
        
        vishid = vishid + vishidinc;
        visbiases = visbiases + visbiasinc;
        hidbiases = hidbiases + hidbiasinc;
        
        errsum = errsum + sum((data-(1./(1+exp(-poshidstates*vishid'-repmat(visbiases,numcases,1)))>rand(numcases,numdims))).^2,2);
    end
    Error(epoch) = mean(errsum/numbatches);
    if rem(log2(epoch),1) == 0
        figure(1);
        subplot(1,2,1);
        dispims(data',16,16);
        subplot(1,2,2);
        dispims(negdata',16,16);
        drawnow
        loglik_test_est = 0;
        loglik_test_est2 = 0;
        for i = 1 : 10
            logZZ_est = RBM_AIS(vishid,hidbiases,visbiases,numruns,beta);
            temp = calculate_logprob(vishid,hidbiases,visbiases,logZZ_est,testbatchdata);
            loglik_test_est = loglik_test_est + temp;
            temp = calculate_logprob(vishid,hidbiases,visbiases,logZZ_est,testbatchdata2);
            loglik_test_est2 = loglik_test_est2 + temp;
        end
        loglik_test_est = loglik_test_est/10;
        Logprob = [ Logprob loglik_test_est ];
        loglik_test_est2 = loglik_test_est2/10;
        Logprob2 = [ Logprob2 loglik_test_est2 ];
    end
end