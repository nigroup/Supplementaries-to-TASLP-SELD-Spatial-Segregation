function eval_mc7_nsrcsError( recreatePreload )


%% load scene params

fprintf( '.' );

scp = getTestSceneParametersMc7();
bscp = getAnnotatedSegId_testSceneParams( scp );
cscp = getSceneIdxs_byParameter( scp );

maxCorrectAzmErr = 15;


%% load test mats

fprintf( '.' );

if (nargin >= 1 && recreatePreload) || ...
        ~exist( fullfile( pwd, '../evaldata', 'eval_mc7_nsrcsError.mat' ), 'file' )

    
if ~exist( fullfile( pwd, '../evaldata', 'eval_mc7_gt.mat' ), 'file' ) 
    error( 'run eval_mc7_gt' );
end
tmp = load( fullfile( pwd, '../evaldata', 'eval_mc7_gt.mat' ) );
llhPlacement_scp_azms_ppd_n0 = tmp.llhPlacement_scp_azms_ppd;
llhBestPlacement_scp_ppd_n0 = tmp.llhBestAsgn_scp_ppd;
azmErr_n0_ppd = tmp.azmErr_ppd;
nyp_n0_ppd = tmp.nyp_ppd;
spec_n0_npp = tmp.spec_npp;
sens_n0_t = tmp.sens_t;
spec_n0_t = tmp.spec_t;
sens_n0_b = tmp.sens_b;
spec_n0_b = tmp.spec_b;
sens_fs = tmp.sens_fs;
spec_fs = tmp.spec_fs;
clear tmp;
fprintf( ':' );

tmpl = load( '../testdata/segId.on.segId_0--2.test' );
tid = tmpl.rescMd_t.id;
datm2.rs_t = tmpl.rescMd_t.summarizeDown( ...
    [tid.counts,tid.classIdx,...
     tid.nYp,tid.posPresent,tid.azmErr,...
     tid.scpId,tid.scpIdExt,...
     tid.fileId,tid.fileClassId] );
fprintf( '.' );
tid = tmpl.rescMd_b.id;
datm2.rs_b = tmpl.rescMd_b.summarizeDown( ...
    [tid.counts,tid.classIdx,...
     tid.nYp,tid.posPresent,...
     tid.azmErr,tid.estAzm,...
     tid.scpId,tid.scpIdExt,...
     tid.fileId,tid.fileClassId] );
fprintf( '.' );

tmpl = load( '../testdata/segId.on.segId_0--1.test' );
tid = tmpl.rescMd_t.id;
datm1.rs_t = tmpl.rescMd_t.summarizeDown( ...
    [tid.counts,tid.classIdx,...
     tid.nYp,tid.posPresent,tid.azmErr,...
     tid.scpId,tid.scpIdExt,...
     tid.fileId,tid.fileClassId] );
fprintf( '.' );
tid = tmpl.rescMd_b.id;
datm1.rs_b = tmpl.rescMd_b.summarizeDown( ...
    [tid.counts,tid.classIdx,...
     tid.nYp,tid.posPresent,...
     tid.azmErr,tid.estAzm,...
     tid.scpId,tid.scpIdExt,...
     tid.fileId,tid.fileClassId] );
fprintf( '.' );

tmpl = load( '../testdata/segId.on.segId_0-1.test' );
tid = tmpl.rescMd_t.id;
datp1.rs_t = tmpl.rescMd_t.summarizeDown( ...
    [tid.counts,tid.classIdx,...
     tid.nYp,tid.posPresent,tid.azmErr,...
     tid.scpId,tid.scpIdExt,...
     tid.fileId,tid.fileClassId] );
fprintf( '.' );
tid = tmpl.rescMd_b.id;
datp1.rs_b = tmpl.rescMd_b.summarizeDown( ...
    [tid.counts,tid.classIdx,...
     tid.nYp,tid.posPresent,...
     tid.azmErr,tid.estAzm,...
     tid.scpId,tid.scpIdExt,...
     tid.fileId,tid.fileClassId] );
fprintf( '.' );

tmpl = load( '../testdata/segId.on.segId_0-2.test' );
tid = tmpl.rescMd_t.id;
datp2.rs_t = tmpl.rescMd_t.summarizeDown( ...
    [tid.counts,tid.classIdx,...
     tid.nYp,tid.posPresent,tid.azmErr,...
     tid.scpId,tid.scpIdExt,...
     tid.fileId,tid.fileClassId] );
fprintf( '.' );
tid = tmpl.rescMd_b.id;
datp2.rs_b = tmpl.rescMd_b.summarizeDown( ...
    [tid.counts,tid.classIdx,...
     tid.nYp,tid.posPresent,...
     tid.azmErr,tid.estAzm,...
     tid.scpId,tid.scpIdExt,...
     tid.fileId,tid.fileClassId] );
fprintf( '.' );

clear tmpl;
fprintf( '.;\n' );

%%
rs_nm1_t = datm1.rs_t;
rs_np1_t = datp1.rs_t;
rs_np2_t = datp2.rs_t;
rs_nm2_t = datm2.rs_t;

rs_nm1_b = datm1.rs_b;
rs_np1_b = datp1.rs_b;
rs_np2_b = datp2.rs_b;
rs_nm2_b = datm2.rs_b;

clear datm2 datm1 datp1 datp2;

%% scps

scpid = 1:numel( scp );
scpb = min( scpid, 255 );
scpe = max( 1, scpid - 255 + 1 );
scpbe = sub2ind( [255,214], scpb, scpe );


%% nm1

rs_nm1_b_se = rs_nm1_b.filter( rs_nm1_b.id.counts, @(x)(x~=1 & x~=4) );
rs_nm1_b_pp = rs_nm1_b.filter( rs_nm1_b.id.posPresent, @(x)(x==1) );
rs_nm1_b_ppd = rs_nm1_b_pp.filter( rs_nm1_b_pp.id.nYp, @(x)(x==1) );
rs_nm1_b_npp = rs_nm1_b.filter( rs_nm1_b.id.posPresent, @(x)(x==2) );
rs_nm1_t_sp = rs_nm1_t.filter( rs_nm1_t.id.counts, @(x)(x~=2 & x~=3) );
rs_nm1_t_pp = rs_nm1_t.filter( rs_nm1_t.id.posPresent, @(x)(x==1) );
rs_nm1_t_ppd = rs_nm1_t_pp.filter( rs_nm1_t_pp.id.nYp, @(x)(x==1) );
clear rs_nm1_b rs_nm1_t;
fprintf( '.' );

[sens_nm1_b] = getPerformanceDecorrMaximumSubset( rs_nm1_b_se, ...
                                                  [rs_nm1_b_se.id.scpId,rs_nm1_b_se.id.scpIdExt] );
[sens_nm1_t] = getPerformanceDecorrMaximumSubset( rs_nm1_t_pp, ...
                                                  [rs_nm1_t_pp.id.scpId,rs_nm1_t_pp.id.scpIdExt] );
sens_nm1_b = sens_nm1_b(scpbe);
sens_nm1_t = sens_nm1_t(scpbe);

[~,spec_nm1_npp] = getPerformanceDecorrMaximumSubset( rs_nm1_b_npp, ...
                                                      [rs_nm1_b_npp.id.scpId,rs_nm1_b_npp.id.scpIdExt] );
spec_nm1_npp = spec_nm1_npp(scpbe);

[~,spec_nm1_pp] = getPerformanceDecorrMaximumSubset( rs_nm1_b_pp, ...
                                                     [rs_nm1_b_pp.id.scpId,rs_nm1_b_pp.id.scpIdExt] );
spec_nm1_pp = spec_nm1_pp(scpbe);

[~,spec_nm1_t] = getPerformanceDecorrMaximumSubset( rs_nm1_t_sp, ...
                                                    [rs_nm1_t_sp.id.scpId,rs_nm1_t_sp.id.scpIdExt] );
spec_nm1_t = spec_nm1_t(scpbe);
spec_nm1_b = nanMean( [spec_nm1_pp;spec_nm1_npp], 1 );

azmErr_nm1_ppd = getAttributeDecorrMaximumSubset( rs_nm1_t_ppd, rs_nm1_t_ppd.id.azmErr, ...
                                                  [rs_nm1_t_ppd.id.scpId,rs_nm1_t_ppd.id.scpIdExt] );
azmErr_nm1_ppd = azmErr_nm1_ppd(scpbe);
azmErr_nm1_ppd = (azmErr_nm1_ppd-1)*5;

nyp_nm1_ppd = getAttributeDecorrMaximumSubset( rs_nm1_t_ppd, rs_nm1_t_ppd.id.nYp, ...
                                               [rs_nm1_t_ppd.id.scpId,rs_nm1_t_ppd.id.scpIdExt] );
nyp_nm1_ppd = nyp_nm1_ppd(scpbe);
nyp_nm1_ppd = nyp_nm1_ppd - 1;

[llhPlacement_scp_azms_ppd_nm1,~,~,...
 llhBestPlacement_scp_ppd_nm1] = getAzmPlacement( rs_nm1_b_ppd, rs_nm1_t_ppd, ...
                                                  'estAzm', maxCorrectAzmErr );

clear rs_nm1_b_ppd rs_nm1_b_pp rs_nm1_b_npp rs_nm1_b_se;
clear rs_nm1_t_ppd rs_nm1_t_sp rs_nm1_t_ppd_nonPerfect rs_nm1_t_pp rs_nm1_t_sp_fp;
fprintf( ';\n' );


%% np1

rs_np1_b_se = rs_np1_b.filter( rs_np1_b.id.counts, @(x)(x~=1 & x~=4) );
rs_np1_b_pp = rs_np1_b.filter( rs_np1_b.id.posPresent, @(x)(x==1) );
rs_np1_b_ppd = rs_np1_b_pp.filter( rs_np1_b_pp.id.nYp, @(x)(x==1) );
rs_np1_b_npp = rs_np1_b.filter( rs_np1_b.id.posPresent, @(x)(x==2) );
rs_np1_t_sp = rs_np1_t.filter( rs_np1_t.id.counts, @(x)(x~=2 & x~=3) );
rs_np1_t_pp = rs_np1_t.filter( rs_np1_t.id.posPresent, @(x)(x==1) );
rs_np1_t_ppd = rs_np1_t_pp.filter( rs_np1_t_pp.id.nYp, @(x)(x==1) );
clear rs_np1_b rs_np1_t;
fprintf( '.' );

[sens_np1_b] = getPerformanceDecorrMaximumSubset( rs_np1_b_se, ...
                                                  [rs_np1_b_se.id.scpId,rs_np1_b_se.id.scpIdExt] );
[sens_np1_t] = getPerformanceDecorrMaximumSubset( rs_np1_t_pp, ...
                                                  [rs_np1_t_pp.id.scpId,rs_np1_t_pp.id.scpIdExt] );
sens_np1_b = sens_np1_b(scpbe);
sens_np1_t = sens_np1_t(scpbe);

[~,spec_np1_npp] = getPerformanceDecorrMaximumSubset( rs_np1_b_npp, ...
                                                      [rs_np1_b_npp.id.scpId,rs_np1_b_npp.id.scpIdExt] );
spec_np1_npp = spec_np1_npp(scpbe);

[~,spec_np1_pp] = getPerformanceDecorrMaximumSubset( rs_np1_b_pp, ...
                                                     [rs_np1_b_pp.id.scpId,rs_np1_b_pp.id.scpIdExt] );
spec_np1_pp = spec_np1_pp(scpbe);

[~,spec_np1_t] = getPerformanceDecorrMaximumSubset( rs_np1_t_sp, ...
                                                    [rs_np1_t_sp.id.scpId,rs_np1_t_sp.id.scpIdExt] );
spec_np1_t = spec_np1_t(scpbe);
spec_np1_b = nanMean( [spec_np1_pp;spec_np1_npp], 1 );

azmErr_np1_ppd = getAttributeDecorrMaximumSubset( rs_np1_t_ppd, rs_np1_t_ppd.id.azmErr, ...
                                                  [rs_np1_t_ppd.id.scpId,rs_np1_t_ppd.id.scpIdExt] );
azmErr_np1_ppd = azmErr_np1_ppd(scpbe);
azmErr_np1_ppd = (azmErr_np1_ppd-1)*5;

nyp_np1_ppd = getAttributeDecorrMaximumSubset( rs_np1_t_ppd, rs_np1_t_ppd.id.nYp, ...
                                               [rs_np1_t_ppd.id.scpId,rs_np1_t_ppd.id.scpIdExt] );
nyp_np1_ppd = nyp_np1_ppd(scpbe);
nyp_np1_ppd = nyp_np1_ppd - 1;

[llhPlacement_scp_azms_ppd_np1,~,~,...
 llhBestPlacement_scp_ppd_np1] = getAzmPlacement( rs_np1_b_ppd, rs_np1_t_ppd, ...
                                                  'estAzm', maxCorrectAzmErr );

clear rs_np1_b_ppd rs_np1_b_pp rs_np1_b_npp rs_np1_b_se;
clear rs_np1_t_ppd rs_np1_t_sp rs_np1_t_ppd_nonPerfect rs_np1_t_pp rs_np1_t_sp_fp;
fprintf( ';\n' );


%% np2

rs_np2_b_se = rs_np2_b.filter( rs_np2_b.id.counts, @(x)(x~=1 & x~=4) );
rs_np2_b_pp = rs_np2_b.filter( rs_np2_b.id.posPresent, @(x)(x==1) );
rs_np2_b_ppd = rs_np2_b_pp.filter( rs_np2_b_pp.id.nYp, @(x)(x==1) );
rs_np2_b_npp = rs_np2_b.filter( rs_np2_b.id.posPresent, @(x)(x==2) );
rs_np2_t_sp = rs_np2_t.filter( rs_np2_t.id.counts, @(x)(x~=2 & x~=3) );
rs_np2_t_pp = rs_np2_t.filter( rs_np2_t.id.posPresent, @(x)(x==1) );
rs_np2_t_ppd = rs_np2_t_pp.filter( rs_np2_t_pp.id.nYp, @(x)(x==1) );
clear rs_np2_b rs_np2_t;
fprintf( '.' );

[sens_np2_b] = getPerformanceDecorrMaximumSubset( rs_np2_b_se, ...
                                                  [rs_np2_b_se.id.scpId,rs_np2_b_se.id.scpIdExt] );
[sens_np2_t] = getPerformanceDecorrMaximumSubset( rs_np2_t_pp, ...
                                                  [rs_np2_t_pp.id.scpId,rs_np2_t_pp.id.scpIdExt] );
sens_np2_b = sens_np2_b(scpbe);
sens_np2_t = sens_np2_t(scpbe);

[~,spec_np2_npp] = getPerformanceDecorrMaximumSubset( rs_np2_b_npp, ...
                                                      [rs_np2_b_npp.id.scpId,rs_np2_b_npp.id.scpIdExt] );
spec_np2_npp = spec_np2_npp(scpbe);

[~,spec_np2_pp] = getPerformanceDecorrMaximumSubset( rs_np2_b_pp, ...
                                                     [rs_np2_b_pp.id.scpId,rs_np2_b_pp.id.scpIdExt] );
spec_np2_pp = spec_np2_pp(scpbe);

[~,spec_np2_t] = getPerformanceDecorrMaximumSubset( rs_np2_t_sp, ...
                                                    [rs_np2_t_sp.id.scpId,rs_np2_t_sp.id.scpIdExt] );
spec_np2_t = spec_np2_t(scpbe);
spec_np2_b = nanMean( [spec_np2_pp;spec_np2_npp], 1 );

azmErr_np2_ppd = getAttributeDecorrMaximumSubset( rs_np2_t_ppd, rs_np2_t_ppd.id.azmErr, ...
                                                  [rs_np2_t_ppd.id.scpId,rs_np2_t_ppd.id.scpIdExt] );
azmErr_np2_ppd = azmErr_np2_ppd(scpbe);
azmErr_np2_ppd = (azmErr_np2_ppd-1)*5;

nyp_np2_ppd = getAttributeDecorrMaximumSubset( rs_np2_t_ppd, rs_np2_t_ppd.id.nYp, ...
                                               [rs_np2_t_ppd.id.scpId,rs_np2_t_ppd.id.scpIdExt] );
nyp_np2_ppd = nyp_np2_ppd(scpbe);
nyp_np2_ppd = nyp_np2_ppd - 1;

[llhPlacement_scp_azms_ppd_np2,~,~,...
 llhBestPlacement_scp_ppd_np2] = getAzmPlacement( rs_np2_b_ppd, rs_np2_t_ppd, ...
                                                  'estAzm', maxCorrectAzmErr );

clear rs_np2_b_ppd rs_np2_b_pp rs_np2_b_npp rs_np2_b_se;
clear rs_np2_t_ppd rs_np2_t_sp rs_np2_t_ppd_nonPerfect rs_np2_t_pp rs_np2_t_sp_fp;
fprintf( ';\n' );


%% nm2

rs_nm2_b_se = rs_nm2_b.filter( rs_nm2_b.id.counts, @(x)(x~=1 & x~=4) );
rs_nm2_b_pp = rs_nm2_b.filter( rs_nm2_b.id.posPresent, @(x)(x==1) );
rs_nm2_b_ppd = rs_nm2_b_pp.filter( rs_nm2_b_pp.id.nYp, @(x)(x==1) );
rs_nm2_b_npp = rs_nm2_b.filter( rs_nm2_b.id.posPresent, @(x)(x==2) );
rs_nm2_t_sp = rs_nm2_t.filter( rs_nm2_t.id.counts, @(x)(x~=2 & x~=3) );
rs_nm2_t_pp = rs_nm2_t.filter( rs_nm2_t.id.posPresent, @(x)(x==1) );
rs_nm2_t_ppd = rs_nm2_t_pp.filter( rs_nm2_t_pp.id.nYp, @(x)(x==1) );
clear rs_nm2_b rs_nm2_t;
fprintf( '.' );

[sens_nm2_b] = getPerformanceDecorrMaximumSubset( rs_nm2_b_se, ...
                                                  [rs_nm2_b_se.id.scpId,rs_nm2_b_se.id.scpIdExt] );
[sens_nm2_t] = getPerformanceDecorrMaximumSubset( rs_nm2_t_pp, ...
                                                  [rs_nm2_t_pp.id.scpId,rs_nm2_t_pp.id.scpIdExt] );
sens_nm2_b = sens_nm2_b(scpbe);
sens_nm2_t = sens_nm2_t(scpbe);

[~,spec_nm2_npp] = getPerformanceDecorrMaximumSubset( rs_nm2_b_npp, ...
                                                      [rs_nm2_b_npp.id.scpId,rs_nm2_b_npp.id.scpIdExt] );
spec_nm2_npp = spec_nm2_npp(scpbe);

[~,spec_nm2_pp] = getPerformanceDecorrMaximumSubset( rs_nm2_b_pp, ...
                                                     [rs_nm2_b_pp.id.scpId,rs_nm2_b_pp.id.scpIdExt] );
spec_nm2_pp = spec_nm2_pp(scpbe);

[~,spec_nm2_t] = getPerformanceDecorrMaximumSubset( rs_nm2_t_sp, ...
                                                    [rs_nm2_t_sp.id.scpId,rs_nm2_t_sp.id.scpIdExt] );
spec_nm2_t = spec_nm2_t(scpbe);
spec_nm2_b = nanMean( [spec_nm2_pp;spec_nm2_npp], 1 );

azmErr_nm2_ppd = getAttributeDecorrMaximumSubset( rs_nm2_t_ppd, rs_nm2_t_ppd.id.azmErr, ...
                                                  [rs_nm2_t_ppd.id.scpId,rs_nm2_t_ppd.id.scpIdExt] );
azmErr_nm2_ppd = azmErr_nm2_ppd(scpbe);
azmErr_nm2_ppd = (azmErr_nm2_ppd-1)*5;

nyp_nm2_ppd = getAttributeDecorrMaximumSubset( rs_nm2_t_ppd, rs_nm2_t_ppd.id.nYp, ...
                                               [rs_nm2_t_ppd.id.scpId,rs_nm2_t_ppd.id.scpIdExt] );
nyp_nm2_ppd = nyp_nm2_ppd(scpbe);
nyp_nm2_ppd = nyp_nm2_ppd - 1;

[llhPlacement_scp_azms_ppd_nm2,~,~,...
 llhBestPlacement_scp_ppd_nm2] = getAzmPlacement( rs_nm2_b_ppd, rs_nm2_t_ppd, ...
                                                  'estAzm', maxCorrectAzmErr );

clear rs_nm2_b_ppd rs_nm2_b_pp rs_nm2_b_npp rs_nm2_b_se;
clear rs_nm2_t_ppd rs_nm2_t_sp rs_nm2_t_ppd_nonPerfect rs_nm2_t_pp rs_nm2_t_sp_fp;
fprintf( ';\n' );


%% save
                                                         
if ~exist( fullfile( pwd, '../evaldata' ), 'dir' )
    mkdir( fullfile( pwd, '../evaldata' ) );
end
save( fullfile( pwd, '../evaldata', 'eval_mc7_nsrcsError.mat' ), ...
                                         'llhPlacement_scp_azms_ppd_n0',...
                                         'llhBestPlacement_scp_ppd_n0',...
                                         'azmErr_n0_ppd', 'nyp_n0_ppd',...
                                         'spec_n0_npp',...
                                         'sens_n0_t', 'spec_n0_t',...
                                         'sens_n0_b', 'spec_n0_b',...
                                         'sens_fs', 'spec_fs',...
                                         'llhPlacement_scp_azms_ppd_nm2',...
                                         'llhBestPlacement_scp_ppd_nm2',...
                                         'azmErr_nm2_ppd', 'nyp_nm2_ppd',...
                                         'spec_nm2_npp', 'azmErr_nm2_ppd',...
                                         'sens_nm2_t', 'spec_nm2_t',...
                                         'sens_nm2_b', 'spec_nm2_b',...
                                         'llhPlacement_scp_azms_ppd_nm1',...
                                         'llhBestPlacement_scp_ppd_nm1',...
                                         'azmErr_nm1_ppd', 'nyp_nm1_ppd',...
                                         'spec_nm1_npp', 'azmErr_nm1_ppd',...
                                         'sens_nm1_t', 'spec_nm1_t',...
                                         'sens_nm1_b', 'spec_nm1_b',...
                                         'llhPlacement_scp_azms_ppd_np1',...
                                         'llhBestPlacement_scp_ppd_np1',...
                                         'azmErr_np1_ppd', 'nyp_np1_ppd',...
                                         'spec_np1_npp', 'azmErr_np1_ppd',...
                                         'sens_np1_t', 'spec_np1_t',...
                                         'sens_np1_b', 'spec_np1_b',...
                                         'llhPlacement_scp_azms_ppd_np2',...
                                         'llhBestPlacement_scp_ppd_np2',...
                                         'azmErr_np2_ppd', 'nyp_np2_ppd',...
                                         'spec_np2_npp', 'azmErr_np2_ppd',...
                                         'sens_np2_t', 'spec_np2_t',...
                                         'sens_np2_b', 'spec_np2_b' );
else
    load( fullfile( pwd, '../evaldata', 'eval_mc7_nsrcsError.mat' ) );
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

nns_ = {'nm2','nm1','n0','np1','np2'};
nns = [-2,-1,0,+1,+2];
for nn = nns
    
    nnidx = find( nn == nns );
    llhPlacement_scp_azms = eval( ['llhPlacement_scp_azms_ppd_' nns_{nnidx}] );
    bapr_scp = eval( ['llhBestPlacement_scp_ppd_' nns_{nnidx}] );
    sens_t = eval( ['sens_' nns_{nnidx} '_t'] );
    spec_t = eval( ['spec_' nns_{nnidx} '_t'] );
    spec_b = eval( ['spec_' nns_{nnidx} '_b'] );
    spec_npp = eval( ['spec_' nns_{nnidx} '_npp'] );
    azmErr = eval( ['azmErr_' nns_{nnidx} '_ppd'] );
    nep = eval( ['nyp_' nns_{nnidx} '_ppd'] ) - 1;

    % ==grand average==
    scps_idxs = union( lModeIdxs, cModeIdxs );
    perfsT_stats_avg{nnidx} = evalHlp_perfOverAzmDists( scps_idxs, ...
                                                        cscp, ...
                                                        sens_t, spec_t, ...
                                                        spec_b, spec_npp, ...
                                                        bapr_scp, ...
                                                        azmErr, nep, ...
                                                        sens_fs, spec_fs );
    scps_idxs = setdiff( union( lModeIdxs, cModeIdxs ), noSpreadIdxs );
    [llhTPplacem_stats_avg{nnidx},azmsInterp_avg{nnidx}] = evalHlp_perfOverAzmDists2( ...
                                                               llhPlacement_scp_azms, ...
                                                               scps_idxs, scp, cscp, ...
                                                               5, true, [], [], [], true );


    % ==averages for individual bisect modes==
    sceneModes = 1:4;
    perfsT_stats_avg_sm{nnidx} = zeros( sceneModes(end), 9, 11 );
    scps_idxs = setdiff( union( lModeIdxs, cModeIdxs ), noSpreadIdxs );
    scpMask_sceneModes = {};
    scpMask_sceneModes{4} = scps_idxs(0 == cellfun( @(c)(std(sign( wrapTo180( c - 0.001*c) + 0.001*mean(sign(wrapTo180(c - 0.001*c))) ))), {scp(scps_idxs).azms} ));
    scpMask_sceneModes{4} = intersect( scpMask_sceneModes{4}, cscp.scpMask_azmsMode(4) );
    scpMask_sceneModes{2} = intersect( scps_idxs, cscp.scpMask_azmsMode(2) );
    scpMask_sceneModes{1} = scps_idxs(arrayfun( @(b,e)(b == 1), [bscp(scps_idxs).percentageSrc1Bisects], [bscp(scps_idxs).percentageEarsects] ));
    scpMask_sceneModes{3} = setdiff( scps_idxs, union( scpMask_sceneModes{1}, union( scpMask_sceneModes{2}, scpMask_sceneModes{4} ) ) );
    for sm = sceneModes
        scps_idxs = setdiff( union( lModeIdxs, cModeIdxs ), noSpreadIdxs );
        scps_idxs = intersect( scps_idxs, scpMask_sceneModes{sm} );
        perfsT_stats_avg_sm{nnidx}(sm==sceneModes,:,:) = evalHlp_perfOverAzmDists( scps_idxs, ...
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
hpl(end+1) = plot( nns, cellfun( @(c)(c(CIDX,1)), perfsT_stats_avg ), '-o', 'DisplayName', 'DR_{tw}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
hpl(end+1) = plot( [-2,2], cellfun( @(c)(c(CIDX,3)), perfsT_stats_avg([1,5]) ), '--d', 'DisplayName', 'DR_{fs}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
hpl(end+1) = plot( nns, cellfun( @(c)(c(CIDX,2)), perfsT_stats_avg ), '-x', 'DisplayName', 'SPEC_{tw}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
hpl(end+1) = plot( [-2,2], cellfun( @(c)(c(CIDX,4)), perfsT_stats_avg([1,5]) ), '--+', 'DisplayName', 'SPEC_{fs}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
hpl(end+1) = plot( nns, cellfun( @(c)(c(CIDX,5)), perfsT_stats_avg ), '-^', 'DisplayName', 'BAC_{tw}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(3,:) );
hpl(end+1) = plot( [-2,2], cellfun( @(c)(c(CIDX,6)), perfsT_stats_avg([1,5]) ), '--v', 'DisplayName', 'BAC_{fs}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(3,:) );
set( gca, 'XTick', nns,  'YGrid', 'on', 'Box', 'on' );
xlim( [-2 2] );
xlabel( 'SourceCount error' );
ylabel( 'Performance' )
legend( hpl, 'Location', 'Best' );

figure; 
hold on;
hpl = [];
yyaxis left
ylabel( 'AzmErr/°' )
patch( [nns,flip( nns )], [cellfun( @(c)(c(2,10)), perfsT_stats_avg ), flip( cellfun( @(c)(c(3,10)), perfsT_stats_avg ))], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(1,:) );
yyaxis right
ylabel( 'NEP' )
patch( [nns,flip( nns )], [cellfun( @(c)(c(2,11)), perfsT_stats_avg ), flip( cellfun( @(c)(c(3,11)), perfsT_stats_avg ))], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(2,:) );
yyaxis left
hpl(end+1) = plot( nns, cellfun( @(c)(c(CIDX,10)), perfsT_stats_avg ), '-', 'DisplayName', 'AzmErr', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
ylim( [0 75] );
set( gca, 'YTick', [0:15:75] );
yyaxis right
hpl(end+1) = plot( nns, cellfun( @(c)(c(CIDX,11)), perfsT_stats_avg ), '--', 'DisplayName', 'NEP', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
set( gca, 'FontSize', 11, 'Layer', 'top', 'YGrid', 'on', 'Box', 'on' );
set( gca, 'XTick', nns );
xlim( [-2 2] );
xlabel( 'SourceCount error' );
legend( hpl, 'Location', 'Best' );

figure;
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );
hold on;
hpl = [];
hpl(end+1) = plot( azmsInterp_avg{1}, llhTPplacem_stats_avg{1}(CIDX,:), '-.', 'DisplayName', '-2', 'LineWidth', 1, 'color', defaultColors(1,:) );
hpl(end+1) = plot( azmsInterp_avg{2}, llhTPplacem_stats_avg{2}(CIDX,:), ':', 'DisplayName', '-1', 'LineWidth', 2, 'color', defaultColors(2,:) );
hpl(end+1) = plot( azmsInterp_avg{3}, llhTPplacem_stats_avg{3}(CIDX,:), '-', 'DisplayName', '0', 'LineWidth', 2, 'color', defaultColors(3,:) );
hpl(end+1) = plot( azmsInterp_avg{4}, llhTPplacem_stats_avg{4}(CIDX,:), '--', 'DisplayName', '+1', 'LineWidth', 2, 'color', defaultColors(4,:) );
hpl(end+1) = plot( azmsInterp_avg{5}, llhTPplacem_stats_avg{5}(CIDX,:), '-.', 'DisplayName', '+2', 'LineWidth', 2, 'color', defaultColors(5,:) );
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
patch( [nns,flip( nns )], [cellfun( @(c)(c(1,2,7)), perfsT_stats_avg_sm ), flip( cellfun( @(c)(c(1,3,7)), perfsT_stats_avg_sm ))], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(1,:) );
ph = patch( [nns,flip( nns )], [cellfun( @(c)(c(2,2,7)), perfsT_stats_avg_sm ), flip( cellfun( @(c)(c(2,3,7)), perfsT_stats_avg_sm ))], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(2,:) );
hatch( ph, 45, [1 1 1], '--', 12, 0.7 );
ph = patch( [nns,flip( nns )], [cellfun( @(c)(c(3,2,7)), perfsT_stats_avg_sm ), flip( cellfun( @(c)(c(3,3,7)), perfsT_stats_avg_sm ))], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(3,:) );
hatch( ph, -45, [1 1 1], '-.', 12, 0.7 );
patch( [nns,flip( nns )], [cellfun( @(c)(c(4,2,7)), perfsT_stats_avg_sm ), flip( cellfun( @(c)(c(4,3,7)), perfsT_stats_avg_sm ))], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(4,:) );
hpl(end+1) = plot( nns, cellfun( @(c)(c(1,CIDX,7)), perfsT_stats_avg_sm ), '-', 'DisplayName', 'Bisected', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
hpl(end+1) = plot( nns, cellfun( @(c)(c(2,CIDX,7)), perfsT_stats_avg_sm ), '--', 'DisplayName', 'Target @ 0°', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
hpl(end+1) = plot( nns, cellfun( @(c)(c(3,CIDX,7)), perfsT_stats_avg_sm ), '-.', 'DisplayName', 'Front/Left', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(3,:) );
hpl(end+1) = plot( nns, cellfun( @(c)(c(4,CIDX,7)), perfsT_stats_avg_sm ), ':', 'DisplayName', 'Ear-centered single-hemisphere', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(4,:) );
set( gca, 'XTick', nns, 'YGrid', 'on', 'Box', 'on' );
xlim( [-2 2] );
xlabel( 'SourceCount error' );
ylabel( 'BAPR' )
legend( hpl, 'Location', 'Best' );

end

