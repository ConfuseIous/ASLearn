 # ASLearn 
 
 ### ASLearn aims to teach American Sign Language in an interactive manner with the help of Machine Learning.
 ### Please note that this Playground has been designed for, tested on, and must be run on iPad.
 
 ## Resources 
 ### This project has multiple phases. 
 1. I obtained the [ASL Alphabet](https://www.kaggle.com/grassknoted/asl-alphabet) dataset from Kaggle, sourced under the [GPL 2 License](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html).
2. I found a [Python script](https://github.com/eugenesiow/practical-ml/blob/master/notebooks/Remove_Image_Background_DeepLabV3.ipynb) (used under the [MIT License](https://github.com/eugenesiow/practical-ml/blob/master/LICENSE)) leveraging the [deeplabv3_resnet101 Machine Learning Model](https://github.com/tensorflow/models/tree/master/research/deeplab) (used under the [Apache License](https://github.com/tensorflow/models/blob/master/LICENSE)) to remove the background of the provided image and modified it to remove the background of every image in the dataset.
3. 

### Summary: DeepLabV3, Remove_Image_Background_DeepLabV3.ipynb, (INSERT OTHER MODEL NAME HERE), and the Dataset used to train (INSERT OTHER MODEL NAME HERE) were all obtained under license as mentioned above. 
### My role was to modify Remove_Image_Background_DeepLabV3.ipynb to work with multiple images and folders at once, pre-process the dataset by removing backgrounds, train (INSERT OTHER MODEL NAME HERE), and build the ASLearn app.
