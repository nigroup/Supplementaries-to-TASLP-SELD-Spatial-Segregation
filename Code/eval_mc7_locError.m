function eval_mc7_locError( recreatePreload )


%% load scene params

fprintf( '.' );

scp = getTestSceneParametersMc7();
bscp = getAnnotatedSegId_testSceneParams( scp );
cscp = getSceneIdxs_byParameter( scp );

maxCorrectAzmErr = 15;


%% load test mats

fprintf( '.' );

if (nargin >= 1 && recreatePreload) || ...
        ~exist( fullfile( pwd, '../evaldata', 'eval_mc7_locError.mat' ), 'file' )

    
if ~exist( fullfile( pwd, '../evaldata', 'eval_mc7_gt.mat' ), 'file' ) 
    error( 'run eval_mc7_gt' );
end
tmp = load( fullfile( pwd, '../evaldata', 'eval_mc7_gt.mat' ) );
llhPlacement_scp_azms_ppd_a0 = tmp.llhPlacement_scp_azms_ppd;
llhBestPlacement_scp_ppd_a0 = tmp.llhBestAsgn_scp_ppd;
azmErr_a0_ppd = tmp.azmErr_ppd;
nyp_a0_ppd = tmp.nyp_ppd;
spec_a0_npp = tmp.spec_npp;
sens_a0_t = tmp.sens_t;
spec_a0_t = tmp.spec_t;
sens_a0_b = tmp.sens_b;
spec_a0_b = tmp.spec_b;
sens_fs = tmp.sens_fs;
spec_fs = tmp.spec_fs;
clear tmp;
fprintf( ':' );

tmpl = load( '../testdata/segId.on.segId_45-0.test' );
tid = tmpl.rescMd_t.id;
dat45.rs_t = tmpl.rescMd_t.summarizeDown( ...
    [tid.counts,tid.classIdx,...
    tid.nYp,tid.posPresent,tid.azmErr,...
    tid.scpId,tid.scpIdExt,...
    tid.fileId,tid.fileClassId] );
fprintf( '.' );
tid = tmpl.rescMd_b.id;
dat45.rs_b = tmpl.rescMd_b.summarizeDown( ...
    [tid.counts,tid.classIdx,...
    tid.nYp,tid.posPresent,...
    tid.azmErr,tid.estAzm,...
    tid.scpId,tid.scpIdExt,...
    tid.fileId,tid.fileClassId] );
fprintf( '.' );

tmpl = load( '../testdata/segId.on.segId_5-0.test' );
tid = tmpl.rescMd_t.id;
dat5.rs_t = tmpl.rescMd_t.summarizeDown( ...
    [tid.counts,tid.classIdx,...
    tid.nYp,tid.posPresent,tid.azmErr,...
    tid.scpId,tid.scpIdExt,...
    tid.fileId,tid.fileClassId] );
fprintf( '.' );
tid = tmpl.rescMd_b.id;
dat5.rs_b = tmpl.rescMd_b.summarizeDown( ...
    [tid.counts,tid.classIdx,...
    tid.nYp,tid.posPresent,...
    tid.azmErr,tid.estAzm,...
    tid.scpId,tid.scpIdExt,...
    tid.fileId,tid.fileClassId] );
fprintf( '.' );

tmpl = load( '../testdata/segId.on.segId_10-0.test' );
tid = tmpl.rescMd_t.id;
dat10.rs_t = tmpl.rescMd_t.summarizeDown( ...
    [tid.counts,tid.classIdx,...
    tid.nYp,tid.posPresent,tid.azmErr,...
    tid.scpId,tid.scpIdExt,...
    tid.fileId,tid.fileClassId] );
fprintf( '.' );
tid = tmpl.rescMd_b.id;
dat10.rs_b = tmpl.rescMd_b.summarizeDown( ...
    [tid.counts,tid.classIdx,...
    tid.nYp,tid.posPresent,...
    tid.azmErr,tid.estAzm,...
    tid.scpId,tid.scpIdExt,...
    tid.fileId,tid.fileClassId] );
fprintf( '.' );

tmpl = load( '../testdata/segId.on.segId_20-0.test' );
tid = tmpl.rescMd_t.id;
dat20.rs_t = tmpl.rescMd_t.summarizeDown( ...
    [tid.counts,tid.classIdx,...
    tid.nYp,tid.posPresent,tid.azmErr,...
    tid.scpId,tid.scpIdExt,...
    tid.fileId,tid.fileClassId] );
fprintf( '.' );
tid = tmpl.rescMd_b.id;
dat20.rs_b = tmpl.rescMd_b.summarizeDown( ...
    [tid.counts,tid.classIdx,...
    tid.nYp,tid.posPresent,...
    tid.azmErr,tid.estAzm,...
    tid.scpId,tid.scpIdExt,...
    tid.fileId,tid.fileClassId] );
fprintf( '.' );

tmpl = load( '../testdata/segId.on.segId_1000-0.test' );
tid = tmpl.rescMd_t.id;
dat1000.rs_t = tmpl.rescMd_t.summarizeDown( ...
    [tid.counts,tid.classIdx,...
    tid.nYp,tid.posPresent,tid.azmErr,...
    tid.scpId,tid.scpIdExt,...
    tid.fileId,tid.fileClassId] );
fprintf( '.' );
tid = tmpl.rescMd_b.id;
dat1000.rs_b = tmpl.rescMd_b.summarizeDown( ...
    [tid.counts,tid.classIdx,...
    tid.nYp,tid.posPresent,...
    tid.azmErr,tid.estAzm,...
    tid.scpId,tid.scpIdExt,...
    tid.fileId,tid.fileClassId] );
fprintf( '.' );
clear tmpl;

fprintf( '.;\n' );



%%
rs_a5_t = dat5.rs_t;
rs_a10_t = dat10.rs_t;
rs_a20_t = dat20.rs_t;
rs_a45_t = dat45.rs_t;
rs_a1000_t = dat1000.rs_t;

rs_a5_b = dat5.rs_b;
rs_a10_b = dat10.rs_b;
rs_a20_b = dat20.rs_b;
rs_a45_b = dat45.rs_b;
rs_a1000_b = dat1000.rs_b;

clear dat5 dat10 dat20 dat45 dat1000;


%% scps

scpid = 1:numel( scp );
scpb = min( scpid, 255 );
scpe = max( 1, scpid - 255 + 1 );
scpbe = sub2ind( [255,214], scpb, scpe );


%% a5

rs_a5_b_se = rs_a5_b.filter( rs_a5_b.id.counts, @(x)(x~=1 & x~=4) );
rs_a5_b_pp = rs_a5_b.filter( rs_a5_b.id.posPresent, @(x)(x==1) );
rs_a5_b_ppd = rs_a5_b_pp.filter( rs_a5_b_pp.id.nYp, @(x)(x==1) );
rs_a5_b_npp = rs_a5_b.filter( rs_a5_b.id.posPresent, @(x)(x==2) );
rs_a5_t_sp = rs_a5_t.filter( rs_a5_t.id.counts, @(x)(x~=2 & x~=3) );
rs_a5_t_pp = rs_a5_t.filter( rs_a5_t.id.posPresent, @(x)(x==1) );
rs_a5_t_ppd = rs_a5_t_pp.filter( rs_a5_t_pp.id.nYp, @(x)(x==1) );
clear rs_a5_b rs_a5_t;
fprintf( '.' );

[sens_a5_b] = getPerformanceDecorrMaximumSubset( rs_a5_b_se, ...
                                                 [rs_a5_b_se.id.scpId,rs_a5_b_se.id.scpIdExt] );
[sens_a5_t] = getPerformanceDecorrMaximumSubset( rs_a5_t_pp, ...
                                                 [rs_a5_t_pp.id.scpId,rs_a5_t_pp.id.scpIdExt] );
sens_a5_b = sens_a5_b(scpbe);
sens_a5_t = sens_a5_t(scpbe);

[~,spec_a5_npp] = getPerformanceDecorrMaximumSubset( rs_a5_b_npp, ...
                                                     [rs_a5_b_npp.id.scpId,rs_a5_b_npp.id.scpIdExt] );
spec_a5_npp = spec_a5_npp(scpbe);

[~,spec_a5_pp] = getPerformanceDecorrMaximumSubset( rs_a5_b_pp, ...
                                                    [rs_a5_b_pp.id.scpId,rs_a5_b_pp.id.scpIdExt] );
spec_a5_pp = spec_a5_pp(scpbe);

[~,spec_a5_t] = getPerformanceDecorrMaximumSubset( rs_a5_t_sp, ...
                                                   [rs_a5_t_sp.id.scpId,rs_a5_t_sp.id.scpIdExt] );
spec_a5_t = spec_a5_t(scpbe);
spec_a5_b = nanMean( [spec_a5_pp;spec_a5_npp], 1 );

azmErr_a5_ppd = getAttributeDecorrMaximumSubset( rs_a5_t_ppd, rs_a5_t_ppd.id.azmErr, ...
                                                 [rs_a5_t_ppd.id.scpId,rs_a5_t_ppd.id.scpIdExt] );
azmErr_a5_ppd = azmErr_a5_ppd(scpbe);
azmErr_a5_ppd = (azmErr_a5_ppd-1)*5;

nyp_a5_ppd = getAttributeDecorrMaximumSubset( rs_a5_t_ppd, rs_a5_t_ppd.id.nYp, ...
                                              [rs_a5_t_ppd.id.scpId,rs_a5_t_ppd.id.scpIdExt] );
nyp_a5_ppd = nyp_a5_ppd(scpbe);
nyp_a5_ppd = nyp_a5_ppd - 1;

[llhPlacement_scp_azms_ppd_a5,~,~,...
 llhBestPlacement_scp_ppd_a5] = getAzmPlacement( rs_a5_b_ppd, rs_a5_t_ppd, ...
                                                 'estAzm', maxCorrectAzmErr );

clear rs_a5_b_ppd rs_a5_b_pp rs_a5_b_npp rs_a5_b_se;
clear rs_a5_t_ppd rs_a5_t_sp rs_a5_t_ppd_nonPerfect rs_a5_t_pp rs_a5_t_sp_fp;
fprintf( ';\n' );


%% a10

rs_a10_b_se = rs_a10_b.filter( rs_a10_b.id.counts, @(x)(x~=1 & x~=4) );
rs_a10_b_pp = rs_a10_b.filter( rs_a10_b.id.posPresent, @(x)(x==1) );
rs_a10_b_ppd = rs_a10_b_pp.filter( rs_a10_b_pp.id.nYp, @(x)(x==1) );
rs_a10_b_npp = rs_a10_b.filter( rs_a10_b.id.posPresent, @(x)(x==2) );
rs_a10_t_sp = rs_a10_t.filter( rs_a10_t.id.counts, @(x)(x~=2 & x~=3) );
rs_a10_t_pp = rs_a10_t.filter( rs_a10_t.id.posPresent, @(x)(x==1) );
rs_a10_t_ppd = rs_a10_t_pp.filter( rs_a10_t_pp.id.nYp, @(x)(x==1) );
clear rs_a10_b rs_a10_t;
fprintf( '.' );

[sens_a10_b] = getPerformanceDecorrMaximumSubset( rs_a10_b_se, ...
                                                  [rs_a10_b_se.id.scpId,rs_a10_b_se.id.scpIdExt] );
[sens_a10_t] = getPerformanceDecorrMaximumSubset( rs_a10_t_pp, ...
                                                  [rs_a10_t_pp.id.scpId,rs_a10_t_pp.id.scpIdExt] );
sens_a10_b = sens_a10_b(scpbe);
sens_a10_t = sens_a10_t(scpbe);

[~,spec_a10_npp] = getPerformanceDecorrMaximumSubset( rs_a10_b_npp, ...
                                                      [rs_a10_b_npp.id.scpId,rs_a10_b_npp.id.scpIdExt] );
spec_a10_npp = spec_a10_npp(scpbe);

[~,spec_a10_pp] = getPerformanceDecorrMaximumSubset( rs_a10_b_pp, ...
                                                     [rs_a10_b_pp.id.scpId,rs_a10_b_pp.id.scpIdExt] );
spec_a10_pp = spec_a10_pp(scpbe);

[~,spec_a10_t] = getPerformanceDecorrMaximumSubset( rs_a10_t_sp, ...
                                                    [rs_a10_t_sp.id.scpId,rs_a10_t_sp.id.scpIdExt] );
spec_a10_t = spec_a10_t(scpbe);
spec_a10_b = nanMean( [spec_a10_pp;spec_a10_npp], 1 );

azmErr_a10_ppd = getAttributeDecorrMaximumSubset( rs_a10_t_ppd, rs_a10_t_ppd.id.azmErr, ...
                                                  [rs_a10_t_ppd.id.scpId,rs_a10_t_ppd.id.scpIdExt] );
azmErr_a10_ppd = azmErr_a10_ppd(scpbe);
azmErr_a10_ppd = (azmErr_a10_ppd-1)*5;

nyp_a10_ppd = getAttributeDecorrMaximumSubset(  rs_a10_t_ppd, rs_a10_t_ppd.id.nYp, ...
                                                [rs_a10_t_ppd.id.scpId,rs_a10_t_ppd.id.scpIdExt] );
nyp_a10_ppd = nyp_a10_ppd(scpbe);
nyp_a10_ppd = nyp_a10_ppd - 1;

[llhPlacement_scp_azms_ppd_a10,~,~,...
 llhBestPlacement_scp_ppd_a10] = getAzmPlacement( rs_a10_b_ppd, rs_a10_t_ppd, ...
                                                  'estAzm', maxCorrectAzmErr );

clear rs_a10_b_ppd rs_a10_b_pp rs_a10_b_npp rs_a10_b_se;
clear rs_a10_t_ppd rs_a10_t_sp rs_a10_t_ppd_nonPerfect rs_a10_t_pp rs_a10_t_sp_fp;
fprintf( ';\n' );


%% a20

rs_a20_b_se = rs_a20_b.filter( rs_a20_b.id.counts, @(x)(x~=1 & x~=4) );
rs_a20_b_pp = rs_a20_b.filter( rs_a20_b.id.posPresent, @(x)(x==1) );
rs_a20_b_ppd = rs_a20_b_pp.filter( rs_a20_b_pp.id.nYp, @(x)(x==1) );
rs_a20_b_npp = rs_a20_b.filter( rs_a20_b.id.posPresent, @(x)(x==2) );
rs_a20_t_sp = rs_a20_t.filter( rs_a20_t.id.counts, @(x)(x~=2 & x~=3) );
rs_a20_t_pp = rs_a20_t.filter( rs_a20_t.id.posPresent, @(x)(x==1) );
rs_a20_t_ppd = rs_a20_t_pp.filter( rs_a20_t_pp.id.nYp, @(x)(x==1) );
clear rs_a20_b rs_a20_t;
fprintf( '.' );

[sens_a20_b] = getPerformanceDecorrMaximumSubset( rs_a20_b_se, ...
                                                  [rs_a20_b_se.id.scpId,rs_a20_b_se.id.scpIdExt] );
[sens_a20_t] = getPerformanceDecorrMaximumSubset( rs_a20_t_pp, ...
                                                  [rs_a20_t_pp.id.scpId,rs_a20_t_pp.id.scpIdExt] );
sens_a20_b = sens_a20_b(scpbe);
sens_a20_t = sens_a20_t(scpbe);

[~,spec_a20_npp] = getPerformanceDecorrMaximumSubset( rs_a20_b_npp, ...
                                                      [rs_a20_b_npp.id.scpId,rs_a20_b_npp.id.scpIdExt] );
spec_a20_npp = spec_a20_npp(scpbe);

[~,spec_a20_pp] = getPerformanceDecorrMaximumSubset( rs_a20_b_pp, ...
                                                     [rs_a20_b_pp.id.scpId,rs_a20_b_pp.id.scpIdExt] );
spec_a20_pp = spec_a20_pp(scpbe);

[~,spec_a20_t] = getPerformanceDecorrMaximumSubset( rs_a20_t_sp, ...
                                                    [rs_a20_t_sp.id.scpId,rs_a20_t_sp.id.scpIdExt] );
spec_a20_t = spec_a20_t(scpbe);
spec_a20_b = nanMean( [spec_a20_pp;spec_a20_npp], 1 );

azmErr_a20_ppd = getAttributeDecorrMaximumSubset( rs_a20_t_ppd, rs_a20_t_ppd.id.azmErr, ...
                                                  [rs_a20_t_ppd.id.scpId,rs_a20_t_ppd.id.scpIdExt] );
azmErr_a20_ppd = azmErr_a20_ppd(scpbe);
azmErr_a20_ppd = (azmErr_a20_ppd-1)*5;

nyp_a20_ppd = getAttributeDecorrMaximumSubset( rs_a20_t_ppd, rs_a20_t_ppd.id.nYp, ...
                                               [rs_a20_t_ppd.id.scpId,rs_a20_t_ppd.id.scpIdExt] );
nyp_a20_ppd = nyp_a20_ppd(scpbe);
nyp_a20_ppd = nyp_a20_ppd - 1;

[llhPlacement_scp_azms_ppd_a20,~,~,...
 llhBestPlacement_scp_ppd_a20] = getAzmPlacement( rs_a20_b_ppd, rs_a20_t_ppd, ...
                                                  'estAzm', maxCorrectAzmErr );

clear rs_a20_b_ppd rs_a20_b_pp rs_a20_b_npp rs_a20_b_se;
clear rs_a20_t_ppd rs_a20_t_sp rs_a20_t_ppd_nonPerfect rs_a20_t_pp rs_a20_t_sp_fp;
fprintf( ';\n' );


%% a45

rs_a45_b_se = rs_a45_b.filter( rs_a45_b.id.counts, @(x)(x~=1 & x~=4) );
rs_a45_b_pp = rs_a45_b.filter( rs_a45_b.id.posPresent, @(x)(x==1) );
rs_a45_b_ppd = rs_a45_b_pp.filter( rs_a45_b_pp.id.nYp, @(x)(x==1) );
rs_a45_b_npp = rs_a45_b.filter( rs_a45_b.id.posPresent, @(x)(x==2) );
rs_a45_t_sp = rs_a45_t.filter( rs_a45_t.id.counts, @(x)(x~=2 & x~=3) );
rs_a45_t_pp = rs_a45_t.filter( rs_a45_t.id.posPresent, @(x)(x==1) );
rs_a45_t_ppd = rs_a45_t_pp.filter( rs_a45_t_pp.id.nYp, @(x)(x==1) );
clear rs_a45_b rs_a45_t;
fprintf( '.' );

[sens_a45_b] = getPerformanceDecorrMaximumSubset( rs_a45_b_se, ...
                                                  [rs_a45_b_se.id.scpId,rs_a45_b_se.id.scpIdExt] );
[sens_a45_t] = getPerformanceDecorrMaximumSubset( rs_a45_t_pp, ...
                                                  [rs_a45_t_pp.id.scpId,rs_a45_t_pp.id.scpIdExt] );
sens_a45_b = sens_a45_b(scpbe);
sens_a45_t = sens_a45_t(scpbe);

[~,spec_a45_npp] = getPerformanceDecorrMaximumSubset( rs_a45_b_npp, ...
                                                      [rs_a45_b_npp.id.scpId,rs_a45_b_npp.id.scpIdExt] );
spec_a45_npp = spec_a45_npp(scpbe);

[~,spec_a45_pp] = getPerformanceDecorrMaximumSubset( rs_a45_b_pp, ...
                                                     [rs_a45_b_pp.id.scpId,rs_a45_b_pp.id.scpIdExt] );
spec_a45_pp = spec_a45_pp(scpbe);

[~,spec_a45_t] = getPerformanceDecorrMaximumSubset( rs_a45_t_sp, ...
                                                    [rs_a45_t_sp.id.scpId,rs_a45_t_sp.id.scpIdExt] );
spec_a45_t = spec_a45_t(scpbe);
spec_a45_b = nanMean( [spec_a45_pp;spec_a45_npp], 1 );

azmErr_a45_ppd = getAttributeDecorrMaximumSubset( rs_a45_t_ppd, rs_a45_t_ppd.id.azmErr, ...
                                                  [rs_a45_t_ppd.id.scpId,rs_a45_t_ppd.id.scpIdExt] );
azmErr_a45_ppd = azmErr_a45_ppd(scpbe);
azmErr_a45_ppd = (azmErr_a45_ppd-1)*5;

nyp_a45_ppd = getAttributeDecorrMaximumSubset( rs_a45_t_ppd, rs_a45_t_ppd.id.nYp, ...
                                               [rs_a45_t_ppd.id.scpId,rs_a45_t_ppd.id.scpIdExt] );
nyp_a45_ppd = nyp_a45_ppd(scpbe);
nyp_a45_ppd = nyp_a45_ppd - 1;

[llhPlacement_scp_azms_ppd_a45,~,~,...
 llhBestPlacement_scp_ppd_a45] = getAzmPlacement( rs_a45_b_ppd, rs_a45_t_ppd, ...
                                                  'estAzm', maxCorrectAzmErr );

clear rs_a45_b_ppd rs_a45_b_pp rs_a45_b_npp rs_a45_b_se;
clear rs_a45_t_ppd rs_a45_t_sp rs_a45_t_ppd_nonPerfect rs_a45_t_pp rs_a45_t_sp_fp;
fprintf( ';\n' );


%% a1000

rs_a1000_b_se = rs_a1000_b.filter( rs_a1000_b.id.counts, @(x)(x~=1 & x~=4) );
rs_a1000_b_pp = rs_a1000_b.filter( rs_a1000_b.id.posPresent, @(x)(x==1) );
rs_a1000_b_ppd = rs_a1000_b_pp.filter( rs_a1000_b_pp.id.nYp, @(x)(x==1) );
rs_a1000_b_npp = rs_a1000_b.filter( rs_a1000_b.id.posPresent, @(x)(x==2) );
rs_a1000_t_sp = rs_a1000_t.filter( rs_a1000_t.id.counts, @(x)(x~=2 & x~=3) );
rs_a1000_t_pp = rs_a1000_t.filter( rs_a1000_t.id.posPresent, @(x)(x==1) );
rs_a1000_t_ppd = rs_a1000_t_pp.filter( rs_a1000_t_pp.id.nYp, @(x)(x==1) );
clear rs_a1000_b rs_a1000_t;
fprintf( '.' );

[sens_a1000_b] = getPerformanceDecorrMaximumSubset( rs_a1000_b_se, ...
                                                    [rs_a1000_b_se.id.scpId,rs_a1000_b_se.id.scpIdExt]);
[sens_a1000_t] = getPerformanceDecorrMaximumSubset( rs_a1000_t_pp, ...
                                                    [rs_a1000_t_pp.id.scpId,rs_a1000_t_pp.id.scpIdExt] );
sens_a1000_b = sens_a1000_b(scpbe);
sens_a1000_t = sens_a1000_t(scpbe);

[~,spec_a1000_npp] = getPerformanceDecorrMaximumSubset( rs_a1000_b_npp, ...
                                                        [rs_a1000_b_npp.id.scpId,rs_a1000_b_npp.id.scpIdExt] );
spec_a1000_npp = spec_a1000_npp(scpbe);

[~,spec_a1000_pp] = getPerformanceDecorrMaximumSubset( rs_a1000_b_pp, ...
                                                       [rs_a1000_b_pp.id.scpId,rs_a1000_b_pp.id.scpIdExt] );
spec_a1000_pp = spec_a1000_pp(scpbe);
spec_a1000_b = nanMean( [spec_a1000_pp;spec_a1000_npp], 1 );

[~,spec_a1000_t] = getPerformanceDecorrMaximumSubset( rs_a1000_t_sp, ...
                                                      [rs_a1000_t_sp.id.scpId,rs_a1000_t_sp.id.scpIdExt] );
spec_a1000_t = spec_a1000_t(scpbe);

azmErr_a1000_ppd = getAttributeDecorrMaximumSubset( rs_a1000_t_ppd, rs_a1000_t_ppd.id.azmErr, ...
                                                    [rs_a1000_t_ppd.id.scpId,rs_a1000_t_ppd.id.scpIdExt] );
azmErr_a1000_ppd = azmErr_a1000_ppd(scpbe);
azmErr_a1000_ppd = (azmErr_a1000_ppd-1)*5;

nyp_a1000_ppd = getAttributeDecorrMaximumSubset( rs_a1000_t_ppd, rs_a1000_t_ppd.id.nYp, ...
                                                 [rs_a1000_t_ppd.id.scpId,rs_a1000_t_ppd.id.scpIdExt] );
nyp_a1000_ppd = nyp_a1000_ppd(scpbe);
nyp_a1000_ppd = nyp_a1000_ppd - 1;

[llhPlacement_scp_azms_ppd_a1000,~,~,...
 llhBestPlacement_scp_ppd_a1000] = getAzmPlacement( rs_a1000_b_ppd, rs_a1000_t_ppd, ...
                                                    'estAzm', maxCorrectAzmErr );

clear rs_a1000_b_ppd rs_a1000_b_pp rs_a1000_b_npp rs_a1000_b_se;
clear rs_a1000_t_ppd rs_a1000_t_sp rs_a1000_t_ppd_nonPerfect rs_a1000_t_pp rs_a1000_t_sp_fp;
fprintf( ';\n' );


%% save
                                                         
if ~exist( fullfile( pwd, '../evaldata' ), 'dir' )
    mkdir( fullfile( pwd, '../evaldata' ) );
end
save( fullfile( pwd, '../evaldata', 'eval_mc7_locError.mat' ), ...
                                         'llhPlacement_scp_azms_ppd_a0',...
                                         'llhBestPlacement_scp_ppd_a0',...
                                         'azmErr_a0_ppd', 'nyp_a0_ppd',...
                                         'spec_a0_npp',...
                                         'sens_a0_t', 'spec_a0_t',...
                                         'sens_a0_b', 'spec_a0_b',...
                                         'sens_fs', 'spec_fs',...
                                         'llhPlacement_scp_azms_ppd_a5',...
                                         'llhBestPlacement_scp_ppd_a5',...
                                         'azmErr_a5_ppd', 'nyp_a5_ppd',...
                                         'spec_a5_npp', 'azmErr_a5_ppd',...
                                         'sens_a5_t', 'spec_a5_t',...
                                         'sens_a5_b', 'spec_a5_b',...
                                         'llhPlacement_scp_azms_ppd_a10',...
                                         'llhBestPlacement_scp_ppd_a10',...
                                         'azmErr_a10_ppd', 'nyp_a10_ppd',...
                                         'spec_a10_npp', 'azmErr_a10_ppd',...
                                         'sens_a10_t', 'spec_a10_t',...
                                         'sens_a10_b', 'spec_a10_b',...
                                         'llhPlacement_scp_azms_ppd_a20',...
                                         'llhBestPlacement_scp_ppd_a20',...
                                         'azmErr_a20_ppd', 'nyp_a20_ppd',...
                                         'spec_a20_npp', 'azmErr_a20_ppd',...
                                         'sens_a20_t', 'spec_a20_t',...
                                         'sens_a20_b', 'spec_a20_b',...
                                         'llhPlacement_scp_azms_ppd_a45',...
                                         'llhBestPlacement_scp_ppd_a45',...
                                         'azmErr_a45_ppd', 'nyp_a45_ppd',...
                                         'spec_a45_npp', 'azmErr_a45_ppd',...
                                         'sens_a45_t', 'spec_a45_t',...
                                         'sens_a45_b', 'spec_a45_b',...
                                         'llhPlacement_scp_azms_ppd_a1000',...
                                         'llhBestPlacement_scp_ppd_a1000',...
                                         'azmErr_a1000_ppd', 'nyp_a1000_ppd',...
                                         'spec_a1000_npp', 'azmErr_a1000_ppd',...
                                         'sens_a1000_t', 'spec_a1000_t',...
                                         'sens_a1000_b', 'spec_a1000_b' );
else
    load( fullfile( pwd, '../evaldata', 'eval_mc7_locError.mat' ) );
end


%%

defaultColors = get( groot, 'FactoryAxesColorOrder' );
defaultColors(3,:) = defaultColors(3,:) - 0.125; % yellow, too bright
set( groot, 'DefaultAxesColorOrder', defaultColors );


%% azmDists TP placement distribution

CIDX = 6; % arithmetic mean

lModeIdxs = union( union( cscp.scpMask_src1mode('L'), cscp.scpMask_ns(1) ), cscp.scpMask_spread(0) );
cModeIdxs = union( union( cscp.scpMask_src1mode('C'), cscp.scpMask_ns(1) ), cscp.scpMask_spread(0) );
noSpreadIdxs = union( cscp.scpMask_spread(0), cscp.scpMask_spread(360) );

aas = [0,5,10,20,45,1000];
for aa = aas
    
    llhPlacement_scp_azms = eval( ['llhPlacement_scp_azms_ppd_a' num2str( aa )] );
    bapr_scp = eval( ['llhBestPlacement_scp_ppd_a' num2str( aa )] );
    sens_t = eval( ['sens_a' num2str( aa ) '_t'] );
    spec_t = eval( ['spec_a' num2str( aa ) '_t'] );
    spec_b = eval( ['spec_a' num2str( aa ) '_b'] );
    spec_npp = eval( ['spec_a' num2str( aa ) '_npp'] );
    azmErr = eval( ['azmErr_a' num2str( aa ) '_ppd'] );
    nep = eval( ['nyp_a' num2str( aa ) '_ppd'] ) - 1;
    aaidx = find( aa == aas );

    % ==grand average==
    scps_idxs = union( lModeIdxs, cModeIdxs );
    perfsT_stats_avg{aaidx} = evalHlp_perfOverAzmDists( scps_idxs, ...
                                                        cscp, ...
                                                        sens_t, spec_t, ...
                                                        spec_b, spec_npp, ...
                                                        bapr_scp, ...
                                                        azmErr, nep, ...
                                                        sens_fs, spec_fs );

    scps_idxs = setdiff( union( lModeIdxs, cModeIdxs ), noSpreadIdxs );
    [llhTPplacem_stats_avg{aaidx},azmsInterp_avg{aaidx}] = evalHlp_perfOverAzmDists2( ...
                                                               llhPlacement_scp_azms, ...
                                                               scps_idxs, scp, cscp, ...
                                                               5, true, [], [], [], aa==0 );


    % ==averages for individual bisect modes==
    sceneModes = 1:4;
    perfsT_stats_avg_sm{aaidx} = zeros( sceneModes(end), 9, 11 );
    scps_idxs = setdiff( union( lModeIdxs, cModeIdxs ), noSpreadIdxs );
    scpMask_azmsTypes = {};
    scpMask_azmsTypes{4} = scps_idxs(0 == cellfun( @(c)(std(sign( wrapTo180( c - 0.001*c) + 0.001*mean(sign(wrapTo180(c - 0.001*c))) ))), {scp(scps_idxs).azms} ));
    scpMask_azmsTypes{4} = intersect( scpMask_azmsTypes{4}, cscp.scpMask_azmsMode(4) );
    scpMask_azmsTypes{2} = intersect( scps_idxs, cscp.scpMask_azmsMode(2) );
    scpMask_azmsTypes{1} = scps_idxs(arrayfun( @(b,e)(b == 1), [bscp(scps_idxs).percentageSrc1Bisects], [bscp(scps_idxs).percentageEarsects] ));
    scpMask_azmsTypes{3} = setdiff( scps_idxs, union( scpMask_azmsTypes{1}, union( scpMask_azmsTypes{2}, scpMask_azmsTypes{4} ) ) );
    for sm = sceneModes
        scps_idxs = setdiff( union( lModeIdxs, cModeIdxs ), noSpreadIdxs );
        scps_idxs = intersect( scps_idxs, scpMask_azmsTypes{sm} );
        perfsT_stats_avg_sm{aaidx}(sm==sceneModes,:,:) = evalHlp_perfOverAzmDists( scps_idxs, ...
                                                                                   cscp, ...
                                                                                   sens_t, spec_t, ...
                                                                                   spec_b, spec_npp, ...
                                                                                   bapr_scp, ...
                                                                                   azmErr, nep, ...
                                                                                   sens_fs, spec_fs );
    end

end

%% ==grand average==
                                                       
figure; 
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );
hold on;
hpl = [];
hpl(end+1) = plot( [0,5,10,20,45,90], cellfun( @(c)(c(CIDX,1)), perfsT_stats_avg ), '-o', 'DisplayName', 'DR_{tw}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
hpl(end+1) = plot( [0,90], cellfun( @(c)(c(CIDX,3)), perfsT_stats_avg([1,end]) ), '--d', 'DisplayName', 'DR_{fs}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
hpl(end+1) = plot( [0,5,10,20,45,90], cellfun( @(c)(c(CIDX,2)), perfsT_stats_avg ), '-x', 'DisplayName', 'SPEC_{tw}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
hpl(end+1) = plot( [0,90], cellfun( @(c)(c(CIDX,4)), perfsT_stats_avg([1,end]) ), '--+', 'DisplayName', 'SPEC_{fs}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
hpl(end+1) = plot( [0,5,10,20,45,90], cellfun( @(c)(c(CIDX,5)), perfsT_stats_avg ), '-^', 'DisplayName', 'BAC_{tw}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(3,:) );
hpl(end+1) = plot( [0,90], cellfun( @(c)(c(CIDX,6)), perfsT_stats_avg([1,end]) ), '--v', 'DisplayName', 'BAC_{fs}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(3,:) );
set( gca, 'XTick', [0,5,10,20,45,90], 'XTickLabel', {'0°','5°','10°','20°','45°','rnd'}, 'XTickLabelRotation', 45, 'YGrid', 'on', 'Box', 'on' );
xlim( [0 90] );
xlabel( 'Localization error' );
ylabel( 'Performance' )
legend( hpl, 'Location', 'Best' );

figure; 
hold on;
hpl = [];
yyaxis left
ylabel( 'AzmErr/°' )
patch( [0,5,10,20,45,90,90,45,20,10,5,0], [cellfun( @(c)(c(2,10)), perfsT_stats_avg ), flip( cellfun( @(c)(c(3,10)), perfsT_stats_avg ))], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(1,:) );
yyaxis right
ylabel( 'NEP' )
patch( [0,5,10,20,45,90,90,45,20,10,5,0], [cellfun( @(c)(c(2,11)), perfsT_stats_avg ), flip( cellfun( @(c)(c(3,11)), perfsT_stats_avg ))], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(2,:) );
yyaxis left
hpl(end+1) = plot( [0,5,10,20,45,90], cellfun( @(c)(c(CIDX,10)), perfsT_stats_avg ), '-', 'DisplayName', 'AzmErr', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
ylim( [0 100] );
yyaxis right
hpl(end+1) = plot( [0,5,10,20,45,90], cellfun( @(c)(c(CIDX,11)), perfsT_stats_avg ), '--', 'DisplayName', 'NEP', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
set( gca, 'FontSize', 11, 'Layer', 'top', 'YGrid', 'on', 'Box', 'on' );
set( gca, 'XTick', [0,5,10,20,45,90], 'XTickLabel', {'0°','5°','10°','20°','45°','rnd'}, 'XTickLabelRotation', 45 );
xlim( [0 90] );
xlabel( 'Localization error' );
legend( hpl, 'Location', 'Best' );

figure;
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );
hold on;
hpl = [];
hpl(end+1) = plot( azmsInterp_avg{1}, llhTPplacem_stats_avg{1}(CIDX,:), '-', 'DisplayName', '0° locErr', 'LineWidth', 2, 'color', defaultColors(1,:) );
hpl(end+1) = plot( azmsInterp_avg{3}, llhTPplacem_stats_avg{3}(CIDX,:), '--', 'DisplayName', '10° locErr', 'LineWidth', 2, 'color', defaultColors(3,:) );
hpl(end+1) = plot( azmsInterp_avg{4}, llhTPplacem_stats_avg{4}(CIDX,:), '-.', 'DisplayName', '20° locErr', 'LineWidth', 2, 'color', defaultColors(4,:) );
hpl(end+1) = plot( azmsInterp_avg{6}, llhTPplacem_stats_avg{6}(CIDX,:), ':', 'DisplayName', 'random locs', 'LineWidth', 2, 'color', defaultColors(6,:) );
ylabel( 'Placement likelihood' );
ylim( [0 1] );
xlim( [0 180] );
xlabel( 'Distance to correct azimuth (°)' );
set( gca, 'XTick', [0,20,45,90,135,180] );
legend( hpl, 'Location', 'Best' );


%% ==averages for individual bisect modes==

figure; 
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );
hold on;
hpl = [];
patch( [0,5,10,20,45,90,90,45,20,10,5,0], [cellfun( @(c)(c(1,2,7)), perfsT_stats_avg_sm ), flip( cellfun( @(c)(c(1,3,7)), perfsT_stats_avg_sm ))], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(1,:) );
ph = patch( [0,5,10,20,45,90,90,45,20,10,5,0], [cellfun( @(c)(c(2,2,7)), perfsT_stats_avg_sm ), flip( cellfun( @(c)(c(2,3,7)), perfsT_stats_avg_sm ))], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(2,:) );
hatch( ph, 45, [1 1 1], '--', 12, 0.7 );
ph = patch( [0,5,10,20,45,90,90,45,20,10,5,0], [cellfun( @(c)(c(3,2,7)), perfsT_stats_avg_sm ), flip( cellfun( @(c)(c(3,3,7)), perfsT_stats_avg_sm ))], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(3,:) );
hatch( ph, -45, [1 1 1], '-.', 12, 0.7 );
patch( [0,5,10,20,45,90,90,45,20,10,5,0], [cellfun( @(c)(c(4,2,7)), perfsT_stats_avg_sm ), flip( cellfun( @(c)(c(4,3,7)), perfsT_stats_avg_sm ))], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(4,:) );
hpl(end+1) = plot( [0,5,10,20,45,90], cellfun( @(c)(c(1,CIDX,7)), perfsT_stats_avg_sm ), '-', 'DisplayName', 'Bisected', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
hpl(end+1) = plot( [0,5,10,20,45,90], cellfun( @(c)(c(2,CIDX,7)), perfsT_stats_avg_sm ), '--', 'DisplayName', 'Target @ 0°', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
hpl(end+1) = plot( [0,5,10,20,45,90], cellfun( @(c)(c(3,CIDX,7)), perfsT_stats_avg_sm ), '-.', 'DisplayName', 'Front/Left', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(3,:) );
hpl(end+1) = plot( [0,5,10,20,45,90], cellfun( @(c)(c(4,CIDX,7)), perfsT_stats_avg_sm ), ':', 'DisplayName', 'Ear-centered single-hemisphere', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(4,:) );
set( gca, 'XTick', [0,5,10,20,45,90], 'XTickLabel', {'0°','5°','10°','20°','45°','rnd'}, 'XTickLabelRotation', 45, 'YGrid', 'on', 'Box', 'on' );
ylim( [0 0.9] );
xlim( [0 90] );
xlabel( 'Localization error' );
ylabel( 'BAPR' )
legend( hpl, 'Location', 'Best' );

end

