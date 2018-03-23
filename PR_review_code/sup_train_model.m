function  [model, train_time] = sup_train_model(s,KernelTrain, Ytrain,C)

% C=[0.001 0.005 0.01 0.02 0.05 0.08 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2  1.5 2 4 6  8 10 15 20 50 100 500 1000];
% C = [0.001 0.08 0.1 0.6 0.7 1.5 2 20 50 100 1000];
train_time = zeros(length(C),1);
model = cell(length(C),1);
for t = 1:length(C);
    c = C(t);
    tic;
    model{t} = train(Ytrain,KernelTrain,['-c ' num2str(c) ' -s ' num2str(s) ]);
    train_time(t) = toc;    
end