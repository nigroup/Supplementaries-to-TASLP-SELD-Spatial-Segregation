function testEval_collect( testmat, cc )

startTwoEars('util/tt_segmented.config.xml');
addpath( fullfile( pwd, 'util' ) );

classes = {{'alarm'},{'baby'},{'femaleSpeech'},{'fire'},{'crash'},{'dog'},...
           {'engine'},{'footsteps'},{'knock'},{'phone'},{'piano'},...
           {'maleSpeech'},{'femaleScream','maleScream'}};
if nargin < 2 || isempty( cc ), cc = 1 : numel( classes ); end

rescMd_b = RescSparse( 'uint32', 'uint8' );
rescMd_t = RescSparse( 'uint32', 'uint8' );
rescMd_t2 = RescSparse( 'uint32', 'uint8' );

if exist( [testmat '.mat'], 'file' )
    fprintf( '-' );
    load( [testmat '.mat'] );
    
    if ~isempty( rescMd_b.data )
        prefOrder = [rescMd_b.id.classIdx,rescMd_b.id.scpId,rescMd_b.id.scpIdExt,rescMd_b.id.counts,...
                     allIdsBut( rescMd_b.id, {'counts','classIdx','scpId','scpIdExt'})'];
        if ~issorted( prefOrder )
            fprintf( '-' );
            rescMd_b = rescMd_b.summarizeDown( prefOrder );
        end
    end
    if ~isempty( rescMd_t.data )
        prefOrder = [rescMd_t.id.classIdx,rescMd_t.id.scpId,rescMd_t.id.scpIdExt,rescMd_t.id.counts,...
                     allIdsBut( rescMd_t.id, {'counts','classIdx','scpId','scpIdExt'})'];
        if ~issorted( prefOrder )
            fprintf( '-' );
            rescMd_t = rescMd_t.summarizeDown( prefOrder );
        end
    end
    if ~isempty( rescMd_t2.data )
        prefOrder = [rescMd_t2.id.classIdx,rescMd_t2.id.scpId,rescMd_t2.id.scpIdExt,rescMd_t2.id.counts,...
                     allIdsBut( rescMd_t2.id, {'counts','classIdx','scpId','scpIdExt'})'];
        if ~issorted( prefOrder )
            fprintf( '-' );
            rescMd_t2 = rescMd_t2.summarizeDown( prefOrder );
        end
    end
    fprintf( '#\n' );
else
    error( 'Test mat file not found' );
end

scps = unique( cellfun( @(c)(c(2)), doneCfgsTest ) );

for ll = cc
    
rescMd_b_tmp = RescSparse( 'uint32', 'uint8' );
rescMd_t_tmp = RescSparse( 'uint32', 'uint8' );
rescMd_t2_tmp = RescSparse( 'uint32', 'uint8' );

dcll = cellfun( @(x)(x(1) == ll), doneCfgsTest );
teCfgs = doneCfgsTest(dcll);

if isempty( teCfgs ), continue; end

for dcidx = 1 : numel( teCfgs )

    dc = teCfgs{dcidx};
    scp = dc(2);
    if ~ismember( scp, scps ), continue; end

    fprintf( '\n============== testEval_collect %s; ll = %d, scp = %d ==============\n', ...
        testmat, ll, scp );
    
    mp = pathInsert( modelpathes_test{ll,scp}, 'testRuns', 0 );
    mt = load( fullfile( mp, [strcat(classes{ll}{:}) '.model.mat'] ) );
    
    scpBase = min( scp, 255 );
    scpExt = max( 1, scp - 255 + 1 );
%     if ~isempty( rescMd_b.dataIdxs ) && ...
%             any( all( unique( rescMd_b.dataIdxs(:,[rescMd_b.id.classIdx,rescMd_b.id.scpId,rescMd_b.id.scpIdExt]), 'rows' ) == [ll,scpBase,scpExt], 2 ) )
%         fprintf( '.' );
%         continue;
%     end
    fprintf( '*' );
    
    if ~isprop( mt.testPerfresults, 'resc_b' )
        assert( false );
    else
        if ~isempty( mt.testPerfresults.resc_b.data )
            mtResc_b = mt.testPerfresults.resc_b;
            mtResc_b.dataIdxs(:,mtResc_b.id.scpId) = scpBase;
            if ~isfield( mtResc_b.id, 'scpIdExt' )
                mtResc_b.id.scpIdExt = size( mtResc_b.dataIdxs, 2 ) + 1;
            end
            mtResc_b.dataIdxs(:,mtResc_b.id.scpIdExt) = scpExt;
            mtResc_b.dataIdxs(:,mtResc_b.id.classIdx) = ll;
            prefOrder = [mtResc_b.id.classIdx,mtResc_b.id.scpId,mtResc_b.id.scpIdExt,mtResc_b.id.counts,...
                         allIdsBut( mtResc_b.id, {'counts','classIdx','scpId','scpIdExt'})'];
            if ~issorted( prefOrder )
                fprintf( '.' );
                mtResc_b = mtResc_b.summarizeDown( prefOrder );
            end
            if ~isempty( rescMd_b_tmp.data )
                mtidfs = fieldnames( mtResc_b.id );
                mdidfs = fieldnames( rescMd_b_tmp.id );
                ids_inMtNotMd = setdiff( mtidfs, mdidfs );
                if ~isempty( ids_inMtNotMd )
                    fprintf( '.' );
                    mtResc_b = mtResc_b.summarizeDown( allIdsBut( mtResc_b.id, ids_inMtNotMd' ) );
                end
                ids_inMdNotMt = setdiff( mdidfs, mtidfs );
                if ~isempty( ids_inMdNotMt )
                    fprintf( '.' );
                    rescMd_b_tmp = rescMd_b_tmp.summarizeDown( allIdsBut( rescMd_b_tmp.id, ids_inMdNotMt' ) );
                end
                mtidfs = fieldnames( mtResc_b.id );
                mdidfs = fieldnames( rescMd_b_tmp.id );
                if ~isequal( mtidfs, mdidfs )
                    error( 'Resc structures not equal.' );
                end
            else
                rescMd_b_tmp.id = mtResc_b.id;
            end
            fprintf( ':' );
            rescMd_b_tmp = rescMd_b_tmp.addData( mtResc_b.dataIdxs, mtResc_b.data, true );
        end
        fprintf( '*' );
        if ~isempty( mt.testPerfresults.resc_t.data )
            mtResc_t = mt.testPerfresults.resc_t;
            mtResc_t.dataIdxs(:,mtResc_t.id.scpId) = scpBase;
            if ~isfield( mtResc_t.id, 'scpIdExt' )
                mtResc_t.id.scpIdExt = size( mtResc_t.dataIdxs, 2 ) + 1;
            end
            mtResc_t.dataIdxs(:,mtResc_t.id.scpIdExt) = scpExt;
            mtResc_t.dataIdxs(:,mtResc_t.id.classIdx) = ll;
            prefOrder = [mtResc_t.id.classIdx,mtResc_t.id.scpId,mtResc_t.id.scpIdExt,mtResc_t.id.counts,...
                         allIdsBut( mtResc_t.id, {'counts','classIdx','scpId','scpIdExt'})'];
            if ~issorted( prefOrder )
                fprintf( '.' );
                mtResc_t = mtResc_t.summarizeDown( prefOrder );
            end
            if ~isempty( rescMd_t_tmp.data )
                mtidfs = fieldnames( mtResc_t.id );
                mdidfs = fieldnames( rescMd_t_tmp.id );
                ids_inMtNotMd = setdiff( mtidfs, mdidfs );
                if ~isempty( ids_inMtNotMd )
                    fprintf( '.' );
                    mtResc_t = mtResc_t.summarizeDown( allIdsBut( mtResc_t.id, ids_inMtNotMd' ) );
                end
                ids_inMdNotMt = setdiff( mdidfs, mtidfs );
                if ~isempty( ids_inMdNotMt )
                    fprintf( '.' );
                    rescMd_t_tmp = rescMd_t_tmp.summarizeDown( allIdsBut( rescMd_t_tmp.id, ids_inMdNotMt' ) );
                end
                mtidfs = fieldnames( mtResc_t.id );
                mdidfs = fieldnames( rescMd_t_tmp.id );
                if ~isequal( mtidfs, mdidfs )
                    error( 'Resc structures not equal.' );
                end
            else
                rescMd_t_tmp.id = mtResc_t.id;
            end
            fprintf( ':' );
            rescMd_t_tmp = rescMd_t_tmp.addData( mtResc_t.dataIdxs, mtResc_t.data, true );
        end
        fprintf( '*' );
        if ~isempty( mt.testPerfresults.resc_t2.data )
            mtResc_t2 = mt.testPerfresults.resc_t2;
            mtResc_t2.dataIdxs(:,mtResc_t2.id.scpId) = scpBase;
            if ~isfield( mtResc_t2.id, 'scpIdExt' )
                mtResc_t2.id.scpIdExt = size( mtResc_t2.dataIdxs, 2 ) + 1;
            end
            mtResc_t2.dataIdxs(:,mtResc_t2.id.scpIdExt) = scpExt;
            mtResc_t2.dataIdxs(:,mtResc_t2.id.classIdx) = ll;
            prefOrder = [mtResc_t2.id.classIdx,mtResc_t2.id.scpId,mtResc_t2.id.scpIdExt,mtResc_t2.id.counts,...
                         allIdsBut( mtResc_t2.id, {'counts','classIdx','scpId','scpIdExt'})'];
            if ~issorted( prefOrder )
                fprintf( '.' );
                mtResc_t2 = mtResc_t2.summarizeDown( prefOrder );
            end
            if ~isempty( rescMd_t2_tmp.data )
                mtidfs = fieldnames( mtResc_t2.id );
                mdidfs = fieldnames( rescMd_t2_tmp.id );
                ids_inMtNotMd = setdiff( mtidfs, mdidfs );
                if ~isempty( ids_inMtNotMd )
                    fprintf( '.' );
                    mtResc_t2 = mtResc_t2.summarizeDown( allIdsBut( mtResc_t2.id, ids_inMtNotMd' ) );
                end
                ids_inMdNotMt = setdiff( mdidfs, mtidfs );
                if ~isempty( ids_inMdNotMt )
                    fprintf( '.' );
                    rescMd_t2_tmp = rescMd_t2_tmp.summarizeDown( allIdsBut( rescMd_t2_tmp.id, ids_inMdNotMt' ) );
                end
                mtidfs = fieldnames( mtResc_t2.id );
                mdidfs = fieldnames( rescMd_t2_tmp.id );
                if ~isequal( mtidfs, mdidfs )
                    error( 'Resc structures not equal.' );
                end
            else
                rescMd_t2_tmp.id = mtResc_t2.id;
            end
            fprintf( ':' );
            rescMd_t2_tmp = rescMd_t2_tmp.addData( mtResc_t2.dataIdxs, mtResc_t2.data, true );
        end
        fprintf( '*' );
    end
      
end % for dcidx

fprintf( '-' );
rescMd_b = rescMd_b.addData( rescMd_b_tmp.dataIdxs, rescMd_b_tmp.data, true );
rescMd_b.id = rescMd_b_tmp.id;
fprintf( '-' );
rescMd_t = rescMd_t.addData( rescMd_t_tmp.dataIdxs, rescMd_t_tmp.data, true );
rescMd_t.id = rescMd_t_tmp.id;
fprintf( '-' );
rescMd_t2 = rescMd_t2.addData( rescMd_t2_tmp.dataIdxs, rescMd_t2_tmp.data, true );
rescMd_t2.id = rescMd_t2_tmp.id;

save( [testmat '.mat'], ...
      'doneCfgsTest', 'modelpathes_test',...
      'rescMd_t','rescMd_t2','rescMd_b', ...
      'test_performances_b', ...
      '-v7.3' );
fprintf( ';\n' );

end % for ll

end % function
