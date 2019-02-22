# Joining Sound Event Detection and Localization Through Spatial Segregation

Supplementary materials to  

Trowitzsch, Ivo, et al (2019), _"Joining Sound Event Detection and Localization Through Spatial Segregation"_, in prep., IEEE Transactions on Audio, Speech, Language Processing.

- Models
  - Fullstream sound event detection models
  - Segregated sound event detection models
  - Spatial segregation model
- Code
  - for training fullstream and segregated sound event detection models
  - for testing fullstream and segregated sound event detection models
  - for evaluating test results and plotting graphs
- Scene parameters lists
- Feature set descriptions

  
## Prerequisites for using the code

### Auditory Machine Learning Training and Testing Pipeline

The code needs the Auditory Machine Learning Training and Testing Pipeline (AMLTTP) installed to run, and AMLTTP makes use of other software modules of the Two!Ears Computational Framework. You will need to download 
- https://github.com/TWOEARS/Auditory-Machine-Learning-Training-and-Testing-Pipeline
- https://github.com/TWOEARS/blackboard-system
- https://github.com/TWOEARS/auditory-front-end
- https://github.com/TWOEARS/binaural-simulator
- https://github.com/TWOEARS/SOFA
- https://github.com/TWOEARS/main
- https://github.com/TWOEARS/stream-segregation-training-pipeline

In your Two!Ears-"main" directory, please first edit TwoEarsPath.xml to point to your 
respective directories.

Once Matlab opened, the Two!Ears main folder needs to be added to the Matlab path. 
This will be accomplished by executing the following command:
```Matlab
>> addpath( '<path-to-your-TwoEars-Main-directory>' )
```

### NIGENS sounds database

Training and testing is performed on the sounds of the NIGENS database. Please download it from  

NIGENS Zenodo


## Training models

First edit [train_fullstream](code/train_fullstream.m) and [train_segId](code/train_segId.m) to set `nigensPath` and `dataCachePath` (lines 5 and 6) to your respective pathes. Then training can be executed:

```Matlab
>> train_segId()
>> train_fullstream()
```

It is, computationally, reasonable to first execute `train_segId` and then `train_fullstream`. The other way around will take a bit longer (any direction actually will take _very long_ due to the necessary preprocessing: scene-rendering, segregation, feature construction, etc.; _and_ use a lot of disk space (a few terrabytes...) for the data cache...).

It is fine to cancel preprocessing of the data at any time. Due to the caching mechanism of AMLTTP, preprocessing will be continued next time.


### Code functionality check

To check that the code actually works without having to process all data and use so much disk space, execute
```Matlab
>> train_segId( 9:10, 1:4, [1,11,21,31] )
>> train_fullstream( 9:10, 1:4, [1,11,21,31] )
```

This will train on only ten sound files, only four scenes, and only four classes. Of course the obtained models are not able to generalize reasonably.


## Testing models

You either need to first train models (see above), or unzip our trained models (`fullstream_detection_models.zip` and `segregated_detection_models.zip`, extract to directories named as the archives).

Edit [gen_fullstream_testdata](code/gen_fullstream_testdata.m), [gen_segId_testdata](code/gen_segId_testdata.m), [test_fullstream](code/test_fullstream.m) and [test_on_segId](code/test_on_segId.m) to set `nigensPath` and `dataCachePath` to your respective pathes. Then testing can be executed:

```Matlab
>> gen_segId_testdata()
>> gen_fullstream_testdata`()
>> test_fullstream()
>> test_on_segId()
>> 
>> % Testing also with loc-error and nsrcs-error, if wanted:
>> gen_segId_testdata( [], [], [], 5, 0 )    % 5deg sigma location error
>> test_on_segId( [], [], [], 5, 0 )
>> gen_segId_testdata( [], [], [], 10, 0 )   % 10deg sigma location error
>> test_on_segId( [], [], [], 10, 0 )
>> gen_segId_testdata( [], [], [], 20, 0 )   % 20deg sigma location error
>> test_on_segId( [], [], [], 20, 0 )
>> gen_segId_testdata( [], [], [], 45, 0 )   % 45deg sigma location error
>> test_on_segId( [], [], [], 45, 0 )
>> gen_segId_testdata( [], [], [], 1000, 0 ) % random localization
>> test_on_segId( [], [], [], 1000, 0 )
>> gen_segId_testdata( [], [], [], 0, -1 )   % source count error := -1
>> test_on_segId( [], [], [], 0, -1 )
>> gen_segId_testdata( [], [], [], 0, -2 )   % source count error := -2
>> test_on_segId( [], [], [], 0, -2 )
>> gen_segId_testdata( [], [], [], 0, +1 )   % source count error := +1
>> test_on_segId( [], [], [], 0, +1 )
>> gen_segId_testdata( [], [], [], 0, +2 )   % source count error := +2
>> test_on_segId( [], [], [], 0, +2 )
```

It is, computationally, reasonable to first execute `gen_segId_testdata` and then `gen_fullstream_testdata`. The other way around will take a bit longer (any direction actually will take _very long_ due to the necessary preprocessing: scene-rendering, segregation, feature construction, etc.; _and_ use a lot of disk space (a few terrabytes...) for the data cache...).

It is fine to cancel preprocessing of the data at any time. Due to the caching mechanism of AMLTTP, preprocessing will be continued next time.


### Code functionality check

To check that the code actually works without having to process all data and use so much disk space, execute
```Matlab
>> gen_segId_testdata( 11, 1:4, [1,11,21,31] )
>> gen_fullstream_testdata`( 11, 1:4, [1,11,21,31] )
>> test_on_segId( 11, 1:4, [1,11,21,31])
>> test_fullstream( 11, 1:4, [1,11,21,31] )
```

This will test on only five sound files, only four scenes, and only four classes.

## Evaluation

To run evaluation directly on the test data produced by us, just run:
```Matlab
>> eval_mc7_gt()
>> eval_mc7_locError()
>> eval_mc7_nsrcsError()
```

To run evaluation on test data produced by you (be it from our or your trained models)(but it must be on test data of all test scenes, not only the functionality check one from above), run:
```Matlab
>> testEval_collect( '../testdata/fullstream.test' )
>> testEval_collect( '../testdata/segId.on.segId_0-0.test' )
>> eval_mc7_gt( true )
>> % The following requires having tested also with loc-error and nsrcs-error.
>> testEval_collect( '../testdata/segId.on.segId_5-0.test' )
>> testEval_collect( '../testdata/segId.on.segId_10-0.test' )
>> testEval_collect( '../testdata/segId.on.segId_20-0.test' )
>> testEval_collect( '../testdata/segId.on.segId_45-0.test' )
>> testEval_collect( '../testdata/segId.on.segId_1000-0.test' )
>> testEval_collect( '../testdata/segId.on.segId_0--1.test' )
>> testEval_collect( '../testdata/segId.on.segId_0--2.test' )
>> testEval_collect( '../testdata/segId.on.segId_0-1.test' )
>> testEval_collect( '../testdata/segId.on.segId_0-2.test' )
>> eval_mc7_locError( true )
>> eval_mc7_nsrcsError( true )
```

After the first run of `eval_mc7_gt` on your data, the "true" parameter can be left away.


## Credits

If you use any contained material for your own work, please acknowledge our work by citing as  

Trowitzsch, Ivo, et al (2019), _"Joining Sound Event Detection and Localization Through Spatial Segregation"_, in prep., IEEE Transactions on Audio, Speech, Language Processing.

Furthermore, if you change the code and use subsequent results, please additionally cite  

Trowitzsch, Ivo, et al (2019). Auditory Machine Learning Training and Testing Pipeline: AMLTTP v3.0. Zenodo. http://doi.org/10.5281/zenodo.2575086

Thank you.
