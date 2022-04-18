 # ASLearn 
 
 ### ASLearn aims to teach American Sign Language in an interactive manner with the help of Machine Learning.
 ### Please note that this Playground has been designed for, tested on, and must be run on iPad.
 
 ## Resources 
 ### This project has multiple phases. 
 ### Training Phase
 1. I obtained the [ASL Alphabet](https://www.kaggle.com/grassknoted/asl-alphabet) dataset from Kaggle, sourced under the [GPL 2 License](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html).
2. I found and modified a [Python script](https://github.com/eugenesiow/practical-ml/blob/master/notebooks/Remove_Image_Background_DeepLabV3.ipynb) (used under the [MIT License](https://github.com/eugenesiow/practical-ml/blob/master/LICENSE)) leveraging the [deeplabv3_resnet101 Machine Learning Model](https://github.com/tensorflow/models/tree/master/research/deeplab) (used under the [Apache License](https://github.com/tensorflow/models/blob/master/LICENSE)) to remove the background of the provided image and modified it to remove the background of every image in the dataset. 
3. I trained an Image Classifier using CreateML and the dataset sans background.
* I also built my own Image Classifier using Tensorflow but achieved higher accuracy with CreateML and thus used that instead. I do plan to refine my Image Classifier in the future and make ASLearn available on the App Store.
### Actual Usage
1. ASLearn takes a picture of the user's hand gesture
2. The hand gesture is provided to [DeepLabV3](https://developer.apple.com/machine-learning/models/) and a result without a background is obtained.
3. The result is provided to ASL_Classifier (described in Step 3 of the Training Phase) and a prediction is received. 

### Summary: DeepLabV3, Remove_Image_Background_DeepLabV3.ipynb, and the Dataset used to train the Create ML Image Classifier, were all obtained under license as mentioned above. 
### My role was to modify Remove_Image_Background_DeepLabV3.ipynb to work with multiple images and folders at once, pre-process the dataset by removing backgrounds, train CreateML's Image Classifier, and build the ASLearn app.
