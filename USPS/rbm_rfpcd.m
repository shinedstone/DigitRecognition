%% Initializing symmetric weights and biases.
vishid = vishid0;
hidbiases  = hidbiases0;
visbiases  = visbiases0;
fastvishid = zeros(numdims, numhid);
fasthidbiases  = zeros(1, numhid);
fastvisbiases  = zeros(1, numdims);

poshidprobs = zeros(numcases,numhid);
neghidprobs = zeros(numcases,numhid);
posprods    = zeros(numdims,numhid);
negprods    = zeros(numdims,numhid);
vishidinc  = zeros(numdims,numhid);
hidbiasinc = zeros(1,numhid);
visbiasinc = zeros(1,numdims);
fastvishidinc  = zeros(numdims,numhid);
fasthidbiasinc = zeros(1,numhid);
fastvisbiasinc = zeros(1,numdims);
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
    fprintf(1,'fpcd - epoch %d\r',epoch);
    errsum = 0;
    epsilonw      = 0.01/(1+epoch/1000);
    epsilonvb     = 0.01/(1+epoch/1000);
    epsilonhb     = 0.01/(1+epoch/1000);
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
        neghidprobs = 1./(1 + exp( - negdata*(vishid+fastvishid) - repmat(hidbiases+fasthidbiases,nchain,1)));
        negprods  = negdata'*neghidprobs;
        neghidact = sum(neghidprobs);
        negvisact = sum(negdata);
        
        neghidstates = neghidprobs > rand(nchain,numhid);
        negdata = 1./(1 + exp( - neghidstates*(vishid+fastvishid)' - repmat(visbiases+fastvisbiases,nchain,1)));
        negdata = negdata > rand(nchain,numdims);
        
        %%%%%%%%% END OF NEGATIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%% UPDATE WEIGHTS AND BIASES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        vishidinc = posprods/numcases-negprods/nchain;
        visbiasinc = posvisact/numcases-negvisact/nchain;
        hidbiasinc = poshidact/numcases-neghidact/nchain;
        
        vishid = vishid + epsilonw*vishidinc;
        visbiases = visbiases + epsilonvb*visbiasinc;
        hidbiases = hidbiases + epsilonhb*hidbiasinc;
        
        fastvishid = 0.95*fastvishid + vishidinc;
        fastvisbiases = 0.95*fastvisbiases + visbiasinc;
        fasthidbiases = 0.95*fasthidbiases + hidbiasinc;
        
        errsum = errsum + sum((data-(1./(1+exp(-poshidstates*vishid'-repmat(visbiases,numcases,1)))>rand(numcases,numdims))).^2,2);
    end
    Error(epoch) = mean(errsum/numbatches);
    if rem(epoch,100) == 0
        figure(1);
        subplot(1,2,1);
        dispims(data',16,16);
        subplot(1,2,2);
        dispims(negdata',16,16);
        drawnow
        logZZ_est = 0;
        for i = 1 : 10
            logZZ_est = logZZ_est + RBM_AIS(vishid,hidbiases,visbiases,numruns,beta);
        end
        logZZ_est = logZZ_est/10;
        Logprob = [ Logprob calculate_logprob(vishid,hidbiases,visbiases,logZZ_est,testbatchdata) ];
        Logprob2 = [ Logprob2 calculate_logprob(vishid,hidbiases,visbiases,logZZ_est,testbatchdata2) ];
    end
end