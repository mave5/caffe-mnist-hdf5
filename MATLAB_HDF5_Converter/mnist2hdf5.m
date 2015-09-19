clc
close all
clear all
%%

addpath mnistHelper;
addpath datasets;

% train-images.idx3-ubyte / train-labels.idx1-ubyte
images = loadMNISTImages('train-images-idx3-ubyte');
labels = loadMNISTLabels('train-labels-idx1-ubyte');
 
% reshape images to 4-D: [rows,col,channel,numbers]
trainData=reshape(images,[28 28 1 size(images,2)]);

% permute to [cols,rows,channel,numbers]
trainData=permute(trainData,[2 1 3 4]);

% permute lables to [labels, number of labels ]
trainLabels=permute(labels,[2,1]);

h5create('train.hdf5','/data',size(trainData),'Datatype','double');
h5create('train.hdf5','/label',size(trainLabels),'Datatype','double');

h5write('train.hdf5','/data',trainData);
h5write('train.hdf5','/label',trainLabels);

%%
% test images
images = loadMNISTImages('t10k-images-idx3-ubyte');
labels = loadMNISTLabels('t10k-labels-idx1-ubyte');
 
% reshape images to 4-D: [rows,col,channel,numbers]
testData=reshape(images,[28 28 1 size(images,2)]);

% permute to [cols,rows,channel,numbers]
testData=permute(testData,[2 1 3 4]);

% permute lables to [labels, number of labels ]
testLabels=permute(labels,[2,1]);

h5create('test.hdf5','/data',size(testData),'Datatype','double');
h5create('test.hdf5','/label',size(testLabels),'Datatype','double');

h5write('test.hdf5','/data',testData);
h5write('test.hdf5','/label',testLabels);

