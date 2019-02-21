function [cscp,scpFactors] = getSceneIdxs_byParameter( scp )

cscp.scpMask_ns = containers.Map( 'KeyType', 'double', 'ValueType', 'any' );
cscp.scpMask_ns(1) = find([scp.nSrcs] == 1);
cscp.scpMask_ns(2) = find([scp.nSrcs] == 2);
cscp.scpMask_ns(3) = find([scp.nSrcs] == 3);
cscp.scpMask_ns(4) = find([scp.nSrcs] == 4);

cscp.scpMask_snr = containers.Map( 'KeyType', 'double', 'ValueType', 'any' );
cscp.scpMask_snr(-20) = find(cellfun( @(c)(c(end)), {scp.snrs} ) == -20);
cscp.scpMask_snr(-10) = find(cellfun( @(c)(c(end)), {scp.snrs} ) == -10);
cscp.scpMask_snr(0) = find(cellfun( @(c)(c(end)), {scp.snrs} ) == 0);
cscp.scpMask_snr(+10) = find(cellfun( @(c)(c(end)), {scp.snrs} ) == +10);
cscp.scpMask_snr(+20) = find(cellfun( @(c)(c(end)), {scp.snrs} ) == +20);

cscp.scpMask_spread = containers.Map( 'KeyType', 'double', 'ValueType', 'any' );
cscp.scpMask_spread(360) = find([scp.spread] == 360);
cscp.scpMask_spread(0) = find([scp.spread] == 0);
cscp.scpMask_spread(10) = find([scp.spread] == 10);
cscp.scpMask_spread(20) = find([scp.spread] == 20);
cscp.scpMask_spread(45) = find([scp.spread] == 45);
cscp.scpMask_spread(60) = find([scp.spread] == 60);
cscp.scpMask_spread(90) = find([scp.spread] == 90);
cscp.scpMask_spread(120) = find([scp.spread] == 120);
cscp.scpMask_spread(180) = find([scp.spread] == 180);

cscp.scpMask_src1mode = containers.Map( 'KeyType', 'char', 'ValueType', 'any' );
cscp.scpMask_src1mode('L') = find([scp.src1mode] == 'L');
cscp.scpMask_src1mode('C') = find([scp.src1mode] == 'C');

cscp.scpMask_fbcollisions = containers.Map( 'KeyType', 'double', 'ValueType', 'any' );
cscp.scpMask_fbcollisions(0) = find([scp.targetFBcollisions] == 0);
cscp.scpMask_fbcollisions(1) = find([scp.targetFBcollisions] == 1);

cscp.scpMask_sideMirrorable = containers.Map( 'KeyType', 'double', 'ValueType', 'any' );
cscp.scpMask_sideMirrorable(0) = find([scp.canBeSideMirrored] == 0);
cscp.scpMask_sideMirrorable(1) = find([scp.canBeSideMirrored] == 1);

cscp.scpMask_azmsMode = containers.Map( 'KeyType', 'double', 'ValueType', 'any' );
cscp.scpMask_azmsMode(1) = find( cellfun( @(c)(ismember( 1, c )), {scp.azmsMode} ) );
cscp.scpMask_azmsMode(2) = find( cellfun( @(c)(ismember( 2, c )), {scp.azmsMode} ) );
cscp.scpMask_azmsMode(3) = find( cellfun( @(c)(ismember( 3, c )), {scp.azmsMode} ) );
cscp.scpMask_azmsMode(4) = find( cellfun( @(c)(ismember( 4, c )), {scp.azmsMode} ) );

amScps = [cscp.scpMask_azmsMode(1) cscp.scpMask_azmsMode(2) cscp.scpMask_azmsMode(3) cscp.scpMask_azmsMode(4)];
scpFactors = arrayfun( @(a)(sum(a==amScps)), 1:numel( scp ) );

end
