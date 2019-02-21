%% evalHlp_perfOverAzms
function perfsT_stats_avgNsp = evalHlp_perfOverAzmDists( scps_idxs, cscp, ...
                                                         sens_t, spec_t, ...
                                                         spec_b, spec_npp, ...
                                                         bapr_scp, ...
                                                         azmErr_scp, nyp_scp, ...
                                                         sens_fs, spec_fs )


perfsT = cell( 1, 11 );
for aa = 1:4
for cbsm = 0:1    
    scpIdxs = intersect( cscp.scpMask_azmsMode(aa), scps_idxs );
    if cbsm == 1
        scpIdxs = intersect( cscp.scpMask_sideMirrorable(cbsm), scpIdxs );
    end
    ses = sens_t(scpIdxs);
    sps = spec_t(scpIdxs);
    bapr = bapr_scp(scpIdxs)';
    sesFs = sens_fs(scpIdxs);
    spsFs = spec_fs(scpIdxs);
    spsB = spec_b(scpIdxs);
    spsnpp = spec_npp(scpIdxs);
    bac = 0.5*ses + 0.5*sps;
    bacFs = 0.5*sesFs + 0.5*spsFs;
    perfsT{1,1} = [perfsT{1,1} ses];
    perfsT{1,2} = [perfsT{1,2} sps];
    perfsT{1,3} = [perfsT{1,3} sesFs];
    perfsT{1,4} = [perfsT{1,4} spsFs];
    perfsT{1,5} = [perfsT{1,5} bac];
    perfsT{1,6} = [perfsT{1,6} bacFs];
    perfsT{1,7} = [perfsT{1,7} bapr];
    perfsT{1,8} = [perfsT{1,8} spsB];
    perfsT{1,9} = [perfsT{1,9} spsnpp];
    perfsT{1,10} = [perfsT{1,10} azmErr_scp(scpIdxs)];
    perfsT{1,11} = [perfsT{1,11} nyp_scp(scpIdxs)];
end
end
perfsT_stats_avgNsp(1,:) = cellfun( @(c)( median( c, 'omitnan' ) ), perfsT );
perfsT_stats_avgNsp(2,:) = cellfun( @(c)( quantile( c, 0.75 ) ), perfsT );
perfsT_stats_avgNsp(3,:) = cellfun( @(c)( quantile( c, 0.25 ) ), perfsT );
sPerfsT = cellfun( @sort, perfsT, 'Un', false );
perfsT_stats_avgNsp(4,:) = cellfun( @(c)(c(min(numel(c),ceil( 1 + numel(c)/2 + 1.96*sqrt( numel(c) )/2 )))), sPerfsT );
perfsT_stats_avgNsp(5,:) = cellfun( @(c)(c(max(1,floor( numel(c)/2 - 1.96*sqrt( numel(c) )/2 )))), sPerfsT );
perfsT = cellfun( @(c)(c(~isnan(c))), perfsT, 'un', false );
[mtmp,stmp,ctmp] = cellfun( @(c)( normfit( c ) ), perfsT, 'un', false );
perfsT_stats_avgNsp(6,:) = cell2mat( mtmp );
perfsT_stats_avgNsp(7,:) = cell2mat( stmp );
perfsT_stats_avgNsp([9,8],:) = cell2mat( ctmp );
end