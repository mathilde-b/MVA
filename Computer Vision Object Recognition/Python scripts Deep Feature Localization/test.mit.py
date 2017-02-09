import scipy.io as sio
import tensorflow as tf
import pandas as pd
import numpy as np
import test
import _pickle  as cPickle

import detector
from detector import Detector
from util import load_image

import skimage.io
import matplotlib.pyplot as plt
import matplotlib.image as mpimg

import os
import ipdb

testset_path = '/Users/mathildebateson/Documents/MVA/Recvis/Project/Data/test.pickle'

weight_path = '/Users/mathildebateson/Documents/MVA/Recvis/Caltech/caffe_layers_value.pickle'
model_path = '/Users/mathildebateson/Documents/MVA/Recvis/Project/Data/model-2'
label_dict_path = '/Users/mathildebateson/Documents/MVA/Recvis/Project/Data/label_dict.pickle'
path_ori='/Users/mathildebateson/Documents/MVA/Recvis/Project/Data/ArrowDataAll'
batch_size = 1

#testset = pd.read_pickle( testset_path )[::-1][:20]
testset = pd.read_pickle( testset_path )
label_dict = pd.read_pickle( label_dict_path )
n_labels = len( label_dict )

images_tf = tf.placeholder( tf.float32, [None, 224, 224, 3], name="images")
labels_tf = tf.placeholder( tf.int64, [None], name='labels')
pretrained_weights = cPickle.load(open(weight_path, 'rb'),encoding='bytes',fix_imports=True, errors='strict')

detector = Detector( weight_path, n_labels )

rgb=images_tf
bgr=images_tf
bottom=bgr
#namerelu="conv1_1"
#name=b'conv1_1'
image_mean = [103.939, 116.779, 123.68]

#c1,c2,c3,c4,conv5, conv6, gap, output = detector.inference( images_tf )
p1,p2,p3,p4,conv5, conv6, gap, output =pool1, pool2, pool3, pool4, relu5_3, conv6, gap, output # fetch in test.py

classmap = detector.get_classmap( labels_tf, conv6 )

sess = tf.InteractiveSession()
saver = tf.train.Saver()

saver.restore( sess, model_path )

for start, end in zip(
    reversed(range( 0, len(testset)-batch_size, batch_size)),
    reversed(range(batch_size, len(testset), batch_size))):

    print(start)
    current_data = testset[start:end]
    current_image_paths = current_data['image_path'].values
    current_images = list(map(lambda x: load_image(x), current_image_paths))

    current_images_ori = list(map(lambda x: load_image(x), current_image_paths))
    current_image_names = list(map(lambda x: x.split('/')[-1], current_image_paths))
    current_video_names = list(map(lambda x: x.split('.')[1][0:14], current_image_names)) ### 13 for forward 14 for backward
    current_image_numbers=list(map(lambda x: x.split('.')[2], current_image_names))
    nzerostoadd='0'*(8-len(current_image_numbers[0]))
    current_image_paths_ori=path_ori+'/'+current_video_names[0]+'/im'+nzerostoadd+current_image_numbers[0]+'.jpeg' #WARNING only works when batch size is 1
    current_images_ori = list(map(lambda x: load_image(x), current_image_paths_ori))
    current_images_ori=load_image(current_image_paths_ori)

    #good_index = np.array(map(lambda x: x is not None, current_images))

    #current_data = current_data[good_index]
    #current_image_paths = current_image_paths[good_index]
    #current_images = np.stack(current_images[good_index])
    if current_images_ori!=None:
        current_labels = current_data['label'].values
        current_label_names = current_data['label_name'].values

        conv6_val, output_val = sess.run(
                [conv6, output],
                feed_dict={
                    images_tf: current_images
                    })

        label_predictions = output_val.argmax( axis=1 )
        acc = (label_predictions == current_labels).sum()

        classmap_vals = sess.run(
                classmap,
                feed_dict={
                    labels_tf: label_predictions,
                    conv6: conv6_val
                    })

        classmap_answer = sess.run(
                classmap,
                feed_dict={
                    labels_tf: current_labels,
                    conv6: conv6_val
                    })

        classmap_vis = list(map(lambda x: ((x-x.min())/(x.max()-x.min())), classmap_answer))[0]

        #for vis, ori,ori_path, l_name in zip(classmap_vis, current_images_ori, current_image_paths, current_label_names):
        tempname=current_image_paths[0].split('/')[-1]
        vis_dir='/Users/mathildebateson/Documents/MVA/Recvis/Project/Data/results/'+ tempname.split('.')[1]+'/'
        vis_path = vis_dir+tempname.split('.')[2]
        if not os.path.exists(vis_dir):
            os.makedirs(vis_dir)
        plt.imshow( current_images_ori )
        plt.imshow( classmap_vis, cmap=plt.cm.jet, alpha=0.5, interpolation='nearest' )
        plt.savefig(vis_path)
        skimage.io.imsave(vis_path+'.visN.jpg', classmap_vis)
            #vis_path_ori = '/Users/mathildebateson/Documents/MVA/Recvis/Project/Data/ArrowDataAll'+tempname+'.ori.jpg'
            #skimage.io.imsave( vis_path, vis )
            #skimage.io.imsave( vis_path_ori, ori )

