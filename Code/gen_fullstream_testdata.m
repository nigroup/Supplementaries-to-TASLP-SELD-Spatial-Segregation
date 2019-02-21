function gen_fullstream_testdata( dd, cc, scps )

startTwoEars('util/tt_general.config.xml');
addpath( fullfile( pwd, 'util' ) );

nigensPath = 'twoears/NIGENS'; % TODO: put your own NIGENS path
dataCachePath = 'twoears/idPipeCache'; % TODO: put your own (absolute!) AMLTTP cache path

datasets = {fullfile( nigensPath, 'NIGENS_8-foldSplit_fold1_wo_timit.flist' ),...
            fullfile( nigensPath, 'NIGENS_8-foldSplit_fold2_wo_timit.flist' ),...
            fullfile( nigensPath, 'NIGENS_8-foldSplit_fold3_wo_timit.flist' ),...
            fullfile( nigensPath, 'NIGENS_8-foldSplit_fold4_wo_timit.flist' ),...
            fullfile( nigensPath, 'NIGENS_8-foldSplit_fold5_wo_timit.flist' ),...
            fullfile( nigensPath, 'NIGENS_8-foldSplit_fold6_wo_timit.flist' ),...
            fullfile( nigensPath, 'NIGENS_8-foldSplit_fold7_wo_timit.flist' ),...
            fullfile( nigensPath, 'NIGENS_8-foldSplit_fold8_wo_timit.flist' ),...
            fullfile( nigensPath, 'NIGENS_minidebug_8-foldSplit_fold1_wo_timit.flist' ),...
            fullfile( nigensPath, 'NIGENS_minidebug_8-foldSplit_fold2_wo_timit.flist' ),...
            fullfile( nigensPath, 'NIGENS_minidebug_8-foldSplit_fold7_wo_timit.flist' )};
if nargin < 1 || isempty( dd )
    dd = 7:8;
end

classes = {{'alarm'},{'baby'},{'femaleSpeech'},{'fire'},{'crash'},{'dog'},...
           {'engine'},{'footsteps'},{'knock'},{'phone'},{'piano'},...
           {'maleSpeech'},{'femaleScream','maleScream'}};
           
for ii = 1 : numel( classes )
    labelCreators{ii,1} = 'LabelCreators.MultiEventTypeLabeler'; %#ok<AGROW>
    labelCreators{ii,2} = {'types', classes(ii), 'negOut', 'rest', ...
                           'removeUnclearBlocks', 'block-wise',...
                           'srcTypeFilterOut', [2,1;3,1;4,1]}; %#ok<AGROW> % target sounds only on source 1
end
if nargin < 2 || isempty( cc ), cc = 1 : size( labelCreators, 1 ); end
           
scc = getTestSceneParametersMc7();
if nargin < 3 || isempty( scps ), scps = 1 : numel( scc ); end


lcs = {};
for ll = cc
    lcs{end+1} = feval( labelCreators{ll,1}, labelCreators{ll,2}{:} ); %#ok<AGROW>
end

fprintf( '\n\n============== gen fullstream mc7 %s %s data; dataset = %s, fc = %d ==============\n\n', ...
    strcat(classes{ll}{:}), num2str( dd ) );

pipe = TwoEarsIdTrainPipe( 'cacheSystemDir', dataCachePath );
pipe.blockCreator = BlockCreators.MeanStandardBlockCreator( 0.5, 1./3 );
pipe.featureCreator = FeatureCreators.FeatureSet5cBlockmean();
pipe.labelCreator = LabelCreators.MultiExecuteLabeler( lcs );
pipe.modelCreator = ModelTrainers.LoadModelNoopTrainer( 'noop' );
pipe.setTrainset( datasets(dd) );
pipe.setupData();

sc = SceneConfig.SceneConfiguration.empty;
for scp = scps
    sc(end+1) = SceneConfig.SceneConfiguration(); %#ok<AGROW>
    sc(end).addSource( SceneConfig.PointSource( ...
        'azimuth',SceneConfig.ValGen('manual',scc(scp).azms(1)), ...
        'data', SceneConfig.FileListValGen( 'pipeInput' ) )...
        );
    for jj = 2 : scc(scp).nSrcs
        sc(end).addSource( SceneConfig.PointSource( ...
            'azimuth',SceneConfig.ValGen('manual',scc(scp).azms(jj)), ...
            'data', SceneConfig.MultiFileListValGen( pipe.srcDataSpec ),...
            'offset', SceneConfig.ValGen( 'manual', 0.25 ) ), ...
            'snr', SceneConfig.ValGen( 'manual', scc(scp).snrs(jj) ),...
            'loop', 'randomSeq' ...
            );
    end
    sc(end).setLengthRef( 'source', 1, 'min', 30 );
    sc(end).setSceneNormalization( true, 1 );
end
pipe.init( sc, 'gatherFeaturesProc', false, 'fs', 16000, 'loadBlockAnnotations', true, ...
    'classesOnMultipleSourcesFilter', classes );

pipe.pipeline.dataPipeProcs{1}.dataFileProcessor.procCacheFolderNames = 'mc_test';
pipe.pipeline.dataPipeProcs{2}.dataFileProcessor.procCacheFolderNames = 'mc_test';
pipe.pipeline.dataPipeProcs{4}.dataFileProcessor.procCacheFolderNames = 'mc_fullstream_test';
pipe.pipeline.dataPipeProcs{5}.dataFileProcessor.procCacheFolderNames = 'mc_fullstream_fc5c_test';


pipe.pipeline.run( 'modelPath', ['dataGen_fs' buildCurrentTimeString()], ...
    'runOption', 'onlyGenCache' );



end
