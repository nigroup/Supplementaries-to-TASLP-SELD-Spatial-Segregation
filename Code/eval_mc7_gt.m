function eval_mc7_gt( recreatePreload )

startTwoEars('util/tt_general.config.xml');
addpath( fullfile( pwd, 'util' ) );

%% load scene params

fprintf( '.' );

scp = getTestSceneParametersMc7();
bscp = getAnnotatedSegId_testSceneParams( scp );
cscp = getSceneIdxs_byParameter( scp );

%% load test mats

fprintf( '.' );

if (nargin >= 1 && recreatePreload) || ...
        ~exist( fullfile( pwd, '../evaldata', 'eval_mc7_gt.mat' ), 'file' )

    
tmpl = load( '../testdata/segId.on.segId_0-0.test.mat' );
fprintf( ':' );
rs_t = tmpl.rescMd_t.summarizeDown( ...
    [tmpl.rescMd_t.id.counts,tmpl.rescMd_t.id.classIdx,...
    tmpl.rescMd_t.id.nYp,tmpl.rescMd_t.id.posPresent,...
    tmpl.rescMd_t.id.azmErr,...
    tmpl.rescMd_t.id.scpId,tmpl.rescMd_t.id.scpIdExt,...
    tmpl.rescMd_t.id.fileId,tmpl.rescMd_t.id.fileClassId] );
fprintf( '.' );
rs_b = tmpl.rescMd_b.summarizeDown( ...
    [tmpl.rescMd_b.id.counts,tmpl.rescMd_b.id.classIdx,...
    tmpl.rescMd_b.id.nYp,tmpl.rescMd_b.id.posPresent,...
    tmpl.rescMd_b.id.azmErr,...
    tmpl.rescMd_b.id.estAzm,...
    tmpl.rescMd_b.id.scpId,tmpl.rescMd_b.id.scpIdExt,...
    tmpl.rescMd_b.id.fileId,tmpl.rescMd_b.id.fileClassId] );
fprintf( '.' );
clear tmpl;

tmpl = load( '../testdata/fullstream.test.mat' );
fprintf( ':' );
rs_fs = tmpl.rescMd_b.summarizeDown( ...
    [tmpl.rescMd_b.id.counts,tmpl.rescMd_b.id.classIdx,...
    tmpl.rescMd_b.id.scpId,tmpl.rescMd_b.id.scpIdExt,...
    tmpl.rescMd_b.id.fileId,tmpl.rescMd_b.id.fileClassId] );
fprintf( '.' );
clear tmpl;


%% subsets
 
rs_b_se = rs_b.filter( rs_b.id.counts, @(x)(x~=1 & x~=4) );
rs_b_pp = rs_b.filter( rs_b.id.posPresent, @(x)(x==1) );
rs_b_ppd = rs_b_pp.filter( rs_b_pp.id.nYp, @(x)(x==1) );
rs_b_npp = rs_b.filter( rs_b.id.posPresent, @(x)(x==2) );

rs_t_sp = rs_t.filter( rs_t.id.counts, @(x)(x~=2 & x~=3) );
rs_t_pp = rs_t.filter( rs_t.id.posPresent, @(x)(x==1) );
rs_t_ppd = rs_t_pp.filter( rs_t_pp.id.nYp, @(x)(x==1) );

rs_fs_sp = rs_fs.filter( rs_fs.id.counts, @(x)(x~=2 & x~=3) );
rs_fs_se = rs_fs.filter( rs_fs.id.counts, @(x)(x~=1 & x~=4) );

                             
%% performance over scp

scpid = 1:numel( scp );
scpb = min( scpid, 255 );
scpe = max( 1, scpid - 255 + 1 );
scpbe = sub2ind( [255,214], scpb, scpe );

%SENS
[sens_b] = getPerformanceDecorrMaximumSubset( rs_b_se, [rs_b_se.id.scpId,rs_b_se.id.scpIdExt] );
[sens_t] = getPerformanceDecorrMaximumSubset( rs_t_pp, [rs_t_pp.id.scpId,rs_t_pp.id.scpIdExt] );
[sens_fs] = getPerformanceDecorrMaximumSubset( rs_fs_se, [rs_fs_se.id.scpId,rs_fs_se.id.scpIdExt] );
sens_b = sens_b(scpbe);
sens_t = sens_t(scpbe);
sens_fs = sens_fs(scpbe);

%SPEC NPP
[~,spec_npp] = getPerformanceDecorrMaximumSubset( rs_b_npp, [rs_b_npp.id.scpId,rs_b_npp.id.scpIdExt] );
spec_npp = spec_npp(scpbe);

%SPEC PP
[~,spec_pp] = getPerformanceDecorrMaximumSubset( rs_b_pp, [rs_b_pp.id.scpId,rs_b_pp.id.scpIdExt] );
spec_pp = spec_pp(scpbe);

%SPEC_{tw}
[~,spec_t] = getPerformanceDecorrMaximumSubset( rs_t_sp, [rs_t_sp.id.scpId,rs_t_sp.id.scpIdExt] );
[~,spec_fs] = getPerformanceDecorrMaximumSubset( rs_fs_sp, [rs_fs_sp.id.scpId,rs_fs_sp.id.scpIdExt] );
spec_t = spec_t(scpbe);
spec_fs = spec_fs(scpbe);

spec_b = nanMean( [spec_pp;spec_npp], 1 );

%BAC
bac_t = nanMean( [sens_t;spec_t], 1 );
bac_b = nanMean( [sens_b;spec_b], 1 );
bac_fs = nanMean( [sens_fs;spec_fs], 1 );

%AZMERR
azmErr_ppd = getAttributeDecorrMaximumSubset( rs_t_ppd, rs_t_ppd.id.azmErr, ...
                                              [rs_t_ppd.id.scpId,rs_t_ppd.id.scpIdExt] );
azmErr_ppd = azmErr_ppd(scpbe);
azmErr_ppd = (azmErr_ppd-1)*5;

nyp_ppd = getAttributeDecorrMaximumSubset( rs_t_ppd, rs_t_ppd.id.nYp, ...
                                           [rs_t_ppd.id.scpId,rs_t_ppd.id.scpIdExt] );
nyp_ppd = nyp_ppd(scpbe);
nyp_ppd = nyp_ppd - 1;

%AZMDISTR
% conditioned on: positive present and detected
[llhPlacement_scp_azms_ppd, ~, ~,llhBestAsgn_scp_ppd] = getAzmPlacement( rs_b_ppd, rs_t_ppd, ...
                                                                         'estAzm', 0 );


%%
                                                         
if ~exist( fullfile( pwd, '../evaldata' ), 'dir' )
    mkdir( fullfile( pwd, '../evaldata' ) );
end
save( fullfile( pwd, '../evaldata', 'eval_mc7_gt.mat' ), ...
                                         'llhPlacement_scp_azms_ppd',...
                                         'llhBestAsgn_scp_ppd',...
                                         'azmErr_ppd',...
                                         'nyp_ppd',...
                                         'spec_npp', 'spec_pp', ...
                                         'bac_t', 'sens_t', 'spec_t',...
                                         'bac_b', 'sens_b', 'spec_b',...
                                         'bac_fs', 'sens_fs', 'spec_fs' );
else
    load( fullfile( pwd, '../evaldata', 'eval_mc7_gt.mat' ) );
end


%%

defaultColors = get( groot, 'FactoryAxesColorOrder' );
defaultColors(3,:) = defaultColors(3,:) - 0.125; % yellow, too bright
set( groot, 'DefaultAxesColorOrder', defaultColors );


%% azmDists TP placement distribution

nep = nyp_ppd - 1;

CIDX = 6; % arithmetic mean

lModeIdxs = union( union( cscp.scpMask_src1mode('L'), cscp.scpMask_ns(1) ), cscp.scpMask_spread(0) );
cModeIdxs = union( union( cscp.scpMask_src1mode('C'), cscp.scpMask_ns(1) ), cscp.scpMask_spread(0) );
noSpreadIdxs = union( cscp.scpMask_spread(0), cscp.scpMask_spread(360) );

% ==grand average==
scps_idxs = setdiff( union( lModeIdxs, cModeIdxs ), noSpreadIdxs );
[llhTPplacem_stats_avg,azmsInterp] = evalHlp_perfOverAzmDists2( llhPlacement_scp_azms_ppd, ...
                                                                scps_idxs, scp, cscp, ...
                                                                5, true, [], [], [], true );
figure;
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'YMinorGrid', 'on', 'Box', 'on' );
hold on;
patch( [azmsInterp, flip( azmsInterp )], [llhTPplacem_stats_avg(2,:), flip( llhTPplacem_stats_avg(3,:))], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(1,:) );
plot( azmsInterp, llhTPplacem_stats_avg(CIDX,:), 'DisplayName', 'median', 'LineWidth', 2 );
ylabel( 'Placement likelihood' );
ylim( [0 1] );
xlim( [0 180] );
xlabel( 'Distance to correct azimuth (°)' );
set( gca, 'XTick', [0,20,45,90,135,180] );


% ==averages for individual SNRs==
snrs = cell2mat( cscp.scpMask_snr.keys );
llhTPplacem_stats_avg_snr = zeros( 5, 6, 73 );
perfsT_stats_avg_snr = zeros( 5, 9, 11 );
azmsInterp = {};
for snr = snrs
    scps_idxs = setdiff( union( lModeIdxs, cModeIdxs ), noSpreadIdxs );
    scps_idxs = intersect( scps_idxs, cscp.scpMask_snr(snr) );
    [llhTPplacem_stats_avg_snr(snr==snrs,:,:),azmsInterp{snr==snrs}] = evalHlp_perfOverAzmDists2( ...
                                                                           llhPlacement_scp_azms_ppd, ...
                                                                           scps_idxs, scp, cscp, ...
                                                                           5, true, [], [], [], true );
    scps_idxs = setdiff( union( lModeIdxs, cModeIdxs ), cscp.scpMask_ns(1) );
    scps_idxs = intersect( scps_idxs, cscp.scpMask_snr(snr) );
    perfsT_stats_avg_snr(snr==snrs,:,:) = evalHlp_perfOverAzmDists( scps_idxs, cscp, ...
                                                                    sens_t, spec_t, ...
                                                                    spec_b, spec_npp, ...
                                                                    llhBestAsgn_scp_ppd, ...
                                                                    azmErr_ppd, nep, ...
                                                                    sens_fs, spec_fs );
end

figure;
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );
hold on;
hpl = [];
ph = patch( [azmsInterp{+20==snrs}, flip( azmsInterp{+20==snrs} )], [squeeze( llhTPplacem_stats_avg_snr(+20==snrs,2,:) )', flip( squeeze( llhTPplacem_stats_avg_snr(+20==snrs,3,:) )' )], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(3,:) );
hatch( ph, 45, [1 1 1], '--', 12, 1.5 );
patch( [azmsInterp{0==snrs}, flip( azmsInterp{0==snrs} )], [squeeze( llhTPplacem_stats_avg_snr(0==snrs,2,:) )', flip( squeeze( llhTPplacem_stats_avg_snr(0==snrs,3,:) )' )], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(2,:) );
ph = patch( [azmsInterp{-20==snrs}, flip( azmsInterp{-20==snrs} )], [squeeze( llhTPplacem_stats_avg_snr(-20==snrs,2,:) )', flip( squeeze( llhTPplacem_stats_avg_snr(-20==snrs,3,:) )' )], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(1,:) );
hatch( ph, -45, [1 1 1], ':', 9, 1.2 );
hpl(1) = plot( azmsInterp{+20==snrs}, squeeze( llhTPplacem_stats_avg_snr(+20==snrs,CIDX,:) ), '--', 'DisplayName', '+20 dB', 'LineWidth', 2, 'MarkerSize', 5, 'color', defaultColors(3,:) );
hpl(2) = plot( azmsInterp{0==snrs}, squeeze( llhTPplacem_stats_avg_snr(0==snrs,CIDX,:) ), '-', 'DisplayName', '  0 dB', 'LineWidth', 2, 'MarkerSize', 5, 'color', defaultColors(2,:) );
hpl(3) = plot( azmsInterp{-20==snrs}, squeeze( llhTPplacem_stats_avg_snr(-20==snrs,CIDX,:) ), ':', 'DisplayName', '-20 dB', 'LineWidth', 2, 'MarkerSize', 5, 'color', defaultColors(1,:) );
ylabel( 'Placement likelihood' );
ylim( [0 1] );
xlim( [0 180] );
xlabel( 'Distance to correct azimuth (°)' );
set( gca, 'XTick', [0,20,45,90,135,180] );
legend( hpl, 'Location', 'Best' );

figure; 
subplot( 15, 100, [1 680] );
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'YMinorGrid', 'on', 'Box', 'on' );
hold on;
hpl = [];
hpl(end+1) = plot( snrs, squeeze( perfsT_stats_avg_snr(:,CIDX,1) ), '-o', 'DisplayName', 'DR_{tw}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
hpl(end+1) = plot( snrs, squeeze( perfsT_stats_avg_snr(:,CIDX,3) ), '--d', 'DisplayName', 'DR_{fs}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
hpl(end+1) = plot( snrs, squeeze( perfsT_stats_avg_snr(:,CIDX,2) ), '-x', 'DisplayName', 'SPEC_{tw}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
hpl(end+1) = plot( -30, -30, '-.*', 'DisplayName', 'SPEC_{npp}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
hpl(end+1) = plot( snrs, squeeze( perfsT_stats_avg_snr(:,CIDX,4) ), '--+', 'DisplayName', 'SPEC_{fs}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
hpl(end+1) = plot( snrs, squeeze( perfsT_stats_avg_snr(:,CIDX,7) ), ':o', 'DisplayName', 'BAPR', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(3,:) );
ylim( [0.2 1] );
ylabel( 'Performance' )
xlabel( 'SNR' );
set( gca, 'XTick', -20:10:+20 );
legend( hpl, 'Location', 'Best' );
subplot( 15, 100, [901 1480] );
hpl = [];
yyaxis left
hold on;
hpl(end+1) = plot( snrs, squeeze( perfsT_stats_avg_snr(:,CIDX,10) ), '-*', 'DisplayName', 'AzmErr', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );
ylabel( 'AzmErr/°' )
ylim( [10 30] );
set( gca, 'YTick', [10,20,30] );
yyaxis right
hold on;
hpl(end+1) = plot( snrs, squeeze( perfsT_stats_avg_snr(:,CIDX,11) ), '-^', 'DisplayName', 'NEP', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );
xlabel( 'SNR' );
set( gca, 'XTick', -20:10:+20 );
ylabel( 'NEP' )
ylim( [0.2 1] );
set( gca, 'YTick', [0.2,0.6,1] );
legend( hpl, 'Location', 'Best' );



% ==averages for individual nSrcs==
llhTPplacem_stats_avg_ns = cell( 3, 1 );
perfsT_stats_avg_ns = zeros( 4, 9, 11 );
azmsInterp = {};
for ns = 1:4
    scps_idxs = intersect( union( lModeIdxs, cModeIdxs ), cscp.scpMask_ns(ns) );
    perfsT_stats_avg_ns(ns,:,:) = evalHlp_perfOverAzmDists( scps_idxs, cscp, ...
                                                               sens_t, spec_t, ...
                                                               spec_b, spec_npp, ...
                                                               llhBestAsgn_scp_ppd, ...       
                                                               azmErr_ppd, nep, ...
                                                               sens_fs, spec_fs );
    if ns == 1, continue; end
    scps_idxs = setdiff( union( lModeIdxs, cModeIdxs ), noSpreadIdxs );
    scps_idxs = intersect( scps_idxs, cscp.scpMask_ns(ns) );
    [llhTPplacem_stats_avg_ns{ns-1},azmsInterp{ns-1}] = evalHlp_perfOverAzmDists2( ...
                                                               llhPlacement_scp_azms_ppd, ...
                                                               scps_idxs, scp, cscp, ...
                                                               5, true, [], [], [], true );
end

figure;
hold on;
hpl = [];
patch( [azmsInterp{1}, flip( azmsInterp{1} )], [squeeze( llhTPplacem_stats_avg_ns{1}(2,:) ), flip( squeeze( llhTPplacem_stats_avg_ns{1}(3,:) ) )], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(1,:) );
ph = patch( [azmsInterp{2}, flip( azmsInterp{2} )], [squeeze( llhTPplacem_stats_avg_ns{2}(2,:) ), flip( squeeze( llhTPplacem_stats_avg_ns{2}(3,:) ) )], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(2,:) );
hatch( ph, 45, [1 1 1], '-.', 12, 1.5 );
ph = patch( [azmsInterp{3}, flip( azmsInterp{3} )], [squeeze( llhTPplacem_stats_avg_ns{3}(2,:) ), flip( squeeze( llhTPplacem_stats_avg_ns{3}(3,:) ) )], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(3,:) );
hatch( ph, -45, [1 1 1], ':', 12, 1 );
hpl(1) = plot( azmsInterp{1}, squeeze( llhTPplacem_stats_avg_ns{1}(CIDX,:) ), '-', 'DisplayName', ['2 srcs'], 'LineWidth', 2, 'color', defaultColors(1,:));
hpl(2) = plot( azmsInterp{2}, squeeze( llhTPplacem_stats_avg_ns{2}(CIDX,:) ), '-.', 'DisplayName', ['3 srcs'], 'LineWidth', 2, 'color', defaultColors(2,:) );
hpl(3) = plot( azmsInterp{3}, squeeze( llhTPplacem_stats_avg_ns{3}(CIDX,:) ), ':', 'DisplayName', ['4 srcs'], 'LineWidth', 2, 'color', defaultColors(3,:) );
ylabel( 'Placement likelihood' );
ylim( [0 1] );
set( gca, 'XTick', [0,20,45,90,135,180] );
xlim( [0 180] );
xlabel( 'Distance to correct azimuth (°)' );
legend( hpl, 'Location', 'Best' );
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );

figure; 
subplot( 15, 100, [6 695] );
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'YMinorGrid', 'on', 'Box', 'on' );
hold on;
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,1) ), '-', 'DisplayName', 'DR_{tw}', 'LineWidth', 0.5, 'MarkerSize', 9, 'color', defaultColors(1,:) );
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,3) ), '--', 'DisplayName', 'DR_{fs}', 'LineWidth', 0.5, 'MarkerSize', 9, 'color', defaultColors(1,:) );
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,2) ), '-', 'DisplayName', 'SPEC_{tw}', 'LineWidth', 0.5, 'MarkerSize', 9, 'color', defaultColors(2,:) );
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,9) ), '-.', 'DisplayName', 'SPEC_{npp}', 'LineWidth', 0.5, 'MarkerSize', 9, 'color', defaultColors(2,:) );
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,4) ), '--', 'DisplayName', 'SPEC_{fs}', 'LineWidth', 0.5, 'MarkerSize', 9, 'color', defaultColors(2,:) );
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,7) ), ':', 'DisplayName', 'BAPR', 'LineWidth', 0.5, 'MarkerSize', 9, 'color', defaultColors(3,:) );
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,1) ), 'o', 'DisplayName', 'DR_{tw}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,3) ), 'd', 'DisplayName', 'DR_{fs}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,2) ), 'x', 'DisplayName', 'SPEC_{tw}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,9) ), '*', 'DisplayName', 'SPEC_{npp}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,4) ), '+', 'DisplayName', 'SPEC_{fs}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,7) ), 'o', 'DisplayName', 'BAPR', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(3,:) );
ylim( [0 1] );
ylabel( 'Performance' )
xlabel( 'Number of sources' );
set( gca, 'XTick', 1:4 );
subplot( 15, 100, [906 1495] );
yyaxis left
hold on;
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );
ylabel( 'AzmErr/°' )
ylim( [0 45] );
set( gca, 'YTick', [0,15,30,45] );
yyaxis right
hold on;
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,11) ), '-', 'DisplayName', 'NEP', 'LineWidth', 0.5, 'MarkerSize', 9, 'color', defaultColors(2,:) );
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,11) ), '^', 'DisplayName', 'NEP', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
ylim( [0 1.5] );
ylabel( 'NEP' )
yyaxis left
hold on;
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,10) ), '-', 'DisplayName', 'AzmErr', 'LineWidth', 0.5, 'MarkerSize', 9, 'color', defaultColors(1,:) );
plot( 1:4, squeeze( perfsT_stats_avg_ns(:,CIDX,10) ), '*', 'DisplayName', 'AzmErr', 'LineWidth', 2, 'MarkerSize', 12, 'color', defaultColors(1,:) );
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );
xlabel( 'Number of sources' );
set( gca, 'XTick', 1:4 );


% ==averages for individual scene modes==
sceneModes = 1:4;
llhTPplacem_stats_avg_sm = cell( sceneModes(end), 1 );
perfsT_stats_avg_sm = zeros( sceneModes(end), 9, 11 );
azmsInterp = {};
scps_idxs = setdiff( union( lModeIdxs, cModeIdxs ), noSpreadIdxs );
scpIdxs_sceneModes = {};
scpIdxs_sceneModes{4} = scps_idxs(0 == cellfun( @(c)(std(sign( wrapTo180( c - 0.001*c) + 0.001*mean(sign(wrapTo180(c - 0.001*c))) ))), {scp(scps_idxs).azms} ));
scpIdxs_sceneModes{4} = intersect( scpIdxs_sceneModes{4}, cscp.scpMask_azmsMode(4) );
scpIdxs_sceneModes{2} = intersect( scps_idxs, cscp.scpMask_azmsMode(2) );
scpIdxs_sceneModes{1} = scps_idxs(arrayfun( @(b,e)(b == 1), [bscp(scps_idxs).percentageSrc1Bisects], [bscp(scps_idxs).percentageEarsects] ));
scpIdxs_sceneModes{3} = setdiff( scps_idxs, union( scpIdxs_sceneModes{1}, union( scpIdxs_sceneModes{2}, scpIdxs_sceneModes{4} ) ) );
for sm = sceneModes
    scps_idxs = setdiff( union( lModeIdxs, cModeIdxs ), noSpreadIdxs );
    scps_idxs = intersect( scps_idxs, scpIdxs_sceneModes{sm} );
    perfsT_stats_avg_sm(sm==sceneModes,:,:) = evalHlp_perfOverAzmDists( scps_idxs, cscp, ...
                                                                        sens_t, spec_t, ...
                                                                        spec_b, spec_npp, ...
                                                                        llhBestAsgn_scp_ppd, ...
                                                                        azmErr_ppd, nep, ...
                                                                        sens_fs, spec_fs );
    [llhTPplacem_stats_avg_sm{sm==sceneModes},azmsInterp{sm==sceneModes}] = evalHlp_perfOverAzmDists2( ...
                                                                                llhPlacement_scp_azms_ppd, ...
                                                                                scps_idxs, scp, cscp, ...
                                                                                5, true, [], [], [], true );
end

figure;
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );
hold on;
hpl = [];
patch( [azmsInterp{1}, flip( azmsInterp{1} )], [squeeze( llhTPplacem_stats_avg_sm{1}(2,:) ), flip( squeeze( llhTPplacem_stats_avg_sm{1}(3,:) ) )], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(1,:) );
ph = patch( [azmsInterp{2}, flip( azmsInterp{2} )], [squeeze( llhTPplacem_stats_avg_sm{2}(2,:) ), flip( squeeze( llhTPplacem_stats_avg_sm{2}(3,:) ) )], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(2,:) );
hatch( ph, 45, [1 1 1], '--', 12, 1 );
ph = patch( [azmsInterp{3}, flip( azmsInterp{3} )], [squeeze( llhTPplacem_stats_avg_sm{3}(2,:) ), flip( squeeze( llhTPplacem_stats_avg_sm{3}(3,:) ) )], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(3,:) );
hatch( ph, -45, [1 1 1], '-.', 12, 1 );
ph = patch( [azmsInterp{4}, flip( azmsInterp{4} )], [squeeze( llhTPplacem_stats_avg_sm{4}(2,:) ), flip( squeeze( llhTPplacem_stats_avg_sm{4}(3,:) ) )], 1, 'facealpha', 0.1, 'edgecolor', 'none', 'facecolor', defaultColors(4,:) );
hatch( ph, 80, [1 1 1], ':', 12, 1.2 );
hpl(end+1) = plot( azmsInterp{1}, squeeze( llhTPplacem_stats_avg_sm{1}(CIDX,:) ), '-', 'DisplayName', 'Bisected', 'LineWidth', 2, 'color', defaultColors(1,:) );
hpl(end+1) = plot( azmsInterp{2}, squeeze( llhTPplacem_stats_avg_sm{2}(CIDX,:) ), '--', 'DisplayName', 'Target @ 0°', 'LineWidth', 2, 'color', defaultColors(2,:) );
hpl(end+1) = plot( azmsInterp{3}, squeeze( llhTPplacem_stats_avg_sm{3}(CIDX,:) ), '-.', 'DisplayName', 'Front/Left', 'LineWidth', 2, 'color', defaultColors(3,:) );
hpl(end+1) = plot( azmsInterp{4}, squeeze( llhTPplacem_stats_avg_sm{4}(CIDX,:) ), ':', 'DisplayName', 'Ear-centered single-hemisphere', 'LineWidth', 2, 'color', defaultColors(4,:) );
ylabel( 'Placement likelihood' );
ylim( [0 1] );
xlim( [0 180] );
set( gca, 'XTick', [0,20,45,90,135,180] );
xlabel( 'Distance to correct azimuth (°)' );
legend( hpl, 'Location', 'Best' );

figure; 
subplot( 10, 100, [2 495] );
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'YMinorGrid', 'on', 'Box', 'on' );
hold on;
hpl = [];
hpl(end+1) = plot( (1:4) - 0.1, squeeze( perfsT_stats_avg_sm(:,CIDX,1) )', 'o', 'DisplayName', 'DR_{tw}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
hpl(end+1) = plot( (1:4) + 0.1, squeeze( perfsT_stats_avg_sm(:,CIDX,3) )', 'd', 'DisplayName', 'DR_{fs}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
hpl(end+1) = plot( (5 + (1:4)) - 0.1, squeeze( perfsT_stats_avg_sm(:,CIDX,2) )', 'x', 'DisplayName', 'SPEC_{tw}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
hpl(end+1) = plot( (5 + (1:4)) + 0.1, squeeze( perfsT_stats_avg_sm(:,CIDX,4) )', '+', 'DisplayName', 'SPEC_{fs}', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
hpl(end+1) = plot( (1:4) - 0.1, squeeze( perfsT_stats_avg_sm(:,CIDX,7) )', '*', 'DisplayName', 'BAPR', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(3,:) );
for ii = 1:4
plot( [ii - 0.1,ii - 0.1], squeeze( perfsT_stats_avg_sm(ii,2:3,1) ), ':', 'DisplayName', '25%-75% quantiles SE', 'LineWidth', 1, 'color', defaultColors(1,:) );
plot( [ii + 0.1,ii + 0.1], squeeze( perfsT_stats_avg_sm(ii,2:3,3) ), ':', 'DisplayName', '25%-75% quantiles SE FS', 'LineWidth', 1, 'color', defaultColors(1,:) );
plot( [5 + ii - 0.1,5 + ii - 0.1], squeeze( perfsT_stats_avg_sm(ii,2:3,2) ), ':', 'DisplayName', '25%-75% quantiles SPEC FS', 'LineWidth', 1, 'color', defaultColors(2,:) );
plot( [5 + ii + 0.1,5 + ii + 0.1], squeeze( perfsT_stats_avg_sm(ii,2:3,4) ), ':', 'DisplayName', '25%-75% quantiles SPEC FS', 'LineWidth', 1, 'color', defaultColors(2,:) );
plot( [ii - 0.1,ii - 0.1], squeeze( perfsT_stats_avg_sm(ii,2:3,7) ), ':', 'DisplayName', '25%-75% quantiles SPEC', 'LineWidth', 1, 'color', defaultColors(3,:) );
end
xlim( [0.2 9.8] );
set( gca, 'XTick', [1:4,6:9,11:14], 'XTickLabel', repmat( {'bis','t0','f-l','earc'}, 1, 3 ), 'XTickLabelRotation', 45 );
ylabel( 'Performance' )
legend( hpl, 'Location', 'Best' );
subplot( 10, 100, [602 995] );
yyaxis left
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'YMinorGrid', 'off', 'Box', 'on' );
hold on;
hpl = [];
hpl(end+1) = plot( (1:4), squeeze( perfsT_stats_avg_sm(:,CIDX,10) ), '*', 'DisplayName', 'AzmErr', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(1,:) );
for ii = 1:4
plot( [ii,ii], squeeze( perfsT_stats_avg_sm(ii,2:3,10) ), ':', 'DisplayName', '25%-75% quantiles SE', 'LineWidth', 1, 'color', defaultColors(1,:) );
end
ylabel( 'AzmErr/°' )
ylim( [0 75] );
set( gca, 'YTick', [0,25,50,75] );
yyaxis right
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'YMinorGrid', 'off', 'Box', 'on' );
hold on;
hpl(end+1) = plot( (6:9), squeeze( perfsT_stats_avg_sm(:,CIDX,11) ), '^', 'DisplayName', 'NEP', 'LineWidth', 2, 'MarkerSize', 9, 'color', defaultColors(2,:) );
for ii = 1:4
plot( [5 + ii,5 + ii], squeeze( perfsT_stats_avg_sm(ii,2:3,11) ), ':', 'DisplayName', '25%-75% quantiles SPEC', 'LineWidth', 1, 'color', defaultColors(2,:) );
end
ylabel( 'NEP' )
ylim( [0 1.5] );
set( gca, 'YTick', [0,0.5,1,1.5] );
xlim( [0.2 9.8] );
set( gca, 'XTick', [1:4,6:9,11:14], 'XTickLabel', repmat( {'bis','t0','f-l','earc'}, 1, 3 ), 'XTickLabelRotation', 45 );
legend( hpl, 'Location', 'Best' );


scp_ = scp;
for ii = 1 : numel( scp_ )
    scp_(ii).azms(end) = scp_(ii).azms(end) - 0.01;
end
for ii = sceneModes
    am_idxs = intersect( scpIdxs_sceneModes{ii}, cscp.scpMask_snr(0) );
    if ii == 1
    for tt = find( arrayfun( @(a)(a.azms(1) > 0), scp_(am_idxs) ) )
        scp_(am_idxs(tt)).azms = scp_(am_idxs(tt)).azms * -1;
    end
    end
    [~,sidxs] = sortrows( [[scp(am_idxs).spread]' .* ([scp(am_idxs).nSrcs]-1)',cellfun( @mean, {scp(am_idxs).azms} )'], [1,2], 'descend' );
    polarplot_scenes( scp_, am_idxs(sidxs), true )
end



%% configuration rank

snr0idxs_spreaded = setdiff( cscp.scpMask_snr(0), noSpreadIdxs );
numAzms_spreaded = numel( snr0idxs_spreaded ); 
bac_b_azms = zeros( 1, numAzms_spreaded );
bapr_azms = zeros( 1, numAzms_spreaded );
sens_t_azms = zeros( 1, numAzms_spreaded );
spec_t_azms = zeros( 1, numAzms_spreaded );
bac_t_azms = zeros( 1, numAzms_spreaded );
azmerr_azms = zeros( 1, numAzms_spreaded );
azms = cell( 1, numAzms_spreaded );
for ii = 1 : numAzms_spreaded
    azms{ii} = scp(snr0idxs_spreaded(ii)).azms;
    scp_mask = cellfun( @(c)(isequal( scp(snr0idxs_spreaded(ii)).azms, c )), {scp.azms} );
    bac_b_azms(ii) = nanMean( bac_b(scp_mask) );
    bapr_azms(ii) = nanMean( llhBestAsgn_scp_ppd(scp_mask) );
    sens_t_azms(ii) = nanMean( sens_t(scp_mask) );
    spec_t_azms(ii) = nanMean( spec_t(scp_mask) );
    bac_t_azms(ii) = nanMean( bac_t(scp_mask) );
    azmerr_azms(ii) = nanMean( azmErr_ppd(scp_mask) );
end

[bac_b_azms,sidx] = sort( bac_b_azms, 'descend' );
bapr_azms = bapr_azms(sidx);
sens_t_azms = sens_t_azms(sidx);
spec_t_azms = spec_t_azms(sidx);
bac_t_azms = bac_t_azms(sidx);
azmerr_azms = azmerr_azms(sidx);
azms = azms(sidx);

fprintf( '\n\nAzimuth configurations'' performances\n' );
fprintf(     '===============================================================\n' );
fprintf( 'rank.) BAPR / BAC_b (AZMERR)(SENS_t,SPEC_t/BAC_t):\t\tazm cfg\n' );
fprintf(     '===============================================================\n' );
for ii = 1 : numel( azms )
    fprintf( '%d.) %.2f / %.2f (%.0f°)(%.2f,%.2f/%.2f):\t\t', ii, bapr_azms(ii), bac_b_azms(ii), azmerr_azms(ii), sens_t_azms(ii), spec_t_azms(ii), bac_t_azms(ii) );
    for jj = 1 : numel( azms{ii} )
        if mod( azms{ii}(jj), 1 ) ~= 0
            fprintf( '%.1f ', azms{ii}(jj) );
        else
            fprintf( '%d ', azms{ii}(jj) );
        end
    end
    fprintf( '\n' );
end

           
%% all scenes

figure;
boxplot_performance( ...
    '',...
    {'DR_{tw}','BAPR'},...
    [1 2],...
    {    'notch', 'on', ...
         'whisker', inf, ...
         'widths', 0.2,...
         },'fid',gcf,......
    sens_t, llhBestAsgn_scp_ppd' ...
    );
ylabel( 'Performance' );
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );

figure;
boxplot_performance( ...
    '',...
    {'NEP'},...
    [1],...
    {    'notch', 'on', ...
         'whisker', inf, ...
         'widths', 0.2,...
         },'fid',gcf,......
    nep ...
    );
ylabel( 'Performance' );
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );

figure;
boxplot_performance( ...
    '',...
    {'AzmErr'},...
    [1],...
    {    'notch', 'on', ...
         'whisker', inf, ...
         'widths', 0.2,...
         },'fid',gcf,......
    azmErr_ppd ...
    );
ylabel( 'Performance' );
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );

figure;
boxplot_performance( ...
    '',...
    {'BAC_{tw}','BAC_{fs}','DR_{tw}','DR_{fs}','SPEC_{tw}','SPEC_{fs}','SPEC_{npp}'},...
    [1 1 2 2 3 3 3],...
    {    'notch', 'on', ...
         'whisker', inf, ...
         'widths', 0.2,...
         },'fid',gcf,......
    bac_t, bac_fs, sens_t, sens_fs, spec_t, spec_fs, spec_npp ...
    );
ylabel( 'Performance' );
set( gca, 'FontSize',11, 'Layer','top', 'YGrid', 'on', 'Box', 'on' );

s_bac_b = sort( bac_b );
s_bac_t = sort( bac_t );
s_bac_fs = sort( bac_fs );
s_sens = sort( sens_b );
s_spec_pp = sort( spec_pp );
s_spec_npp = sort( spec_npp );
fprintf( 'BAC_{sw}: mean %.3f +- %.3f\n', ...
    mean( s_bac_b ), 1.96*std( s_bac_b )/sqrt( numel(s_bac_b) ) );
fprintf( 'DR_{sw}:       mean %.3f +- %.3f\n', ...
    mean( s_sens ), 1.96*std( s_sens )/sqrt( numel(s_sens) ) );
fprintf( 'SPEC_{pp}:  mean %.3f +- %.3f\n', ...
    nanMean( s_spec_pp ), 1.96*nanstd( s_spec_pp )/sqrt( numel(s_spec_pp) ) );
fprintf( 'BAC_{sw}: median 95%% CI [%.3f,%.3f]\n', ...
    s_bac_b(floor( numel(s_bac_b)/2 - 1.96*sqrt(numel(s_bac_b))/2 )),...
    s_bac_b(ceil( 1 + numel(s_bac_b)/2 + 1.96*sqrt(numel(s_bac_b))/2 )) );
fprintf( 'DR_{sw}:       median 95%% CI [%.3f,%.3f]\n', ...
    s_sens(floor( numel(s_sens)/2 - 1.96*sqrt(numel(s_sens))/2 )),...
    s_sens(ceil( 1 + numel(s_sens)/2 + 1.96*sqrt(numel(s_sens))/2 )) );
fprintf( 'SPEC_{pp}:  median 95%% CI [%.3f,%.3f]\n', ...
    s_spec_pp(floor( numel(s_spec_pp)/2 - 1.96*sqrt(numel(s_spec_pp))/2 )),...
    s_spec_pp(ceil( 1 + numel(s_spec_pp)/2 + 1.96*sqrt(numel(s_spec_pp))/2 )) );
fprintf( 'SPEC_{npp}: median 95%% CI [%.3f,%.3f]\n', ...
    s_spec_npp(floor( numel(s_spec_npp)/2 - 1.96*sqrt(numel(s_spec_npp))/2 )),...
    s_spec_npp(ceil( 1 + numel(s_spec_npp)/2 + 1.96*sqrt(numel(s_spec_npp))/2 )) );
fprintf( 'BAC_{tw}: median 95%% CI [%.3f,%.3f]\n', ...
    s_bac_t(floor( numel(s_bac_t)/2 - 1.96*sqrt(numel(s_bac_t))/2 )),...
    s_bac_t(ceil( 1 + numel(s_bac_t)/2 + 1.96*sqrt(numel(s_bac_t))/2 )) );
fprintf( 'BAC_{fs}: median 95%% CI [%.3f,%.3f]\n', ...
    s_bac_fs(floor( numel(s_bac_fs)/2 - 1.96*sqrt(numel(s_bac_fs))/2 )),...
    s_bac_fs(ceil( 1 + numel(s_bac_fs)/2 + 1.96*sqrt(numel(s_bac_fs))/2 )) );

% ns-weighted
for nn = 1:4
    scps_idxs = intersect( union( lModeIdxs, cModeIdxs ), cscp.scpMask_ns(nn) );
    bac_b_nn(nn) = nanMean( bac_b(scps_idxs) );
    sens_b_nn(nn) = nanMean( sens_b(scps_idxs) );
    specpp_b_nn(nn) = nanMean( spec_pp(scps_idxs) );
    specnpp_b_nn(nn) = nanMean( spec_npp(scps_idxs) );
end
fprintf( 'BAC_{sw} test set ns-weighted mean: %.3f\n', nanMean( bac_b_nn ) );
fprintf( 'SENS_{sw} test set ns-weighted mean: %.3f\n', nanMean( sens_b_nn ) );
fprintf( 'SPEC_pp_{sw} test set ns-weighted mean: %.3f\n', nanMean( specpp_b_nn ) );
fprintf( 'SPEC_npp_{sw} test set ns-weighted mean: %.3f\n', nanMean( specnpp_b_nn ) );

end

