# caffe-mnist-hdf5


The original Caffe-MNIST example accepts data in the LMDB format. It uses convert_mnist_data.cpp to convert data into LMDB.
If you want to use the original Caffe-MNIST example for your specific task and data, you need to constumozie convert_mnist_data.cpp to convert your data into the LMDB format, which is not straightforward. 

However, Caffe accepts the HDF5 format as well, which is easier to convert. Here, we changed the mnist example to work with HDF5 format. Note that you should obtain the same accuarcy (around 0.99) with HDF5 as in LMDB.

To convert the mnist data to HDF5 format, a MATLAB code is used. Note that reshape and permutation are crucial.

----------------------------------------------------------------------------
% train-images.idx3-ubyte / train-labels.idx1-ubyte

images = loadMNISTImages('train-images-idx3-ubyte');

labels = loadMNISTLabels('train-labels-idx1-ubyte');
 
% reshape images to 4-D: [rows,col,channel,numbers]

trainData=reshape(images,[28 28 1 size(images,2)]);

% permute to [cols,rows,channel,numbers]

trainData=permute(trainData,[2 1 3 4]);

% permute lables to [labels, number of labels ]

trainLabels=permute(labels,[2,1]);

% create database

h5create('train.hdf5','/data',size(trainData),'Datatype','double');

h5create('train.hdf5','/label',size(trainLabels),'Datatype','double');

h5write('train.hdf5','/data',trainData);

h5write('train.hdf5','/label',trainLabels);

% same for test data

--------------------------------------------------------------------------------------
Then only change lenet_train_test.prototxt as below. The rest of the files in mnist example remain the same.
Note that "source" is a text file, which contains the address of your training and test data in HDF5 format.


name: "LeNet"

layer {

  name: "mnist"

  type: "HDF5Data"

  top: "data"

  top: "label"

  include {

    phase: TRAIN

  }

  hdf5_data_param {

    source: "examples/mnist/mnist_train_hdf/train_loc.txt"

    batch_size: 64

  }

}

layer {

  name: "mnist"

  type: "HDF5Data"

  top: "data"

  top: "label"

  include {

    phase: TEST

  }

  hdf5_data_param {

    source: "examples/mnist/mnist_test_hdf/test_loc.txt"

    batch_size: 100

  }

}




