function scp = getTestSceneParametersMc7()

scp7 = struct( 'nSrcs', {}, 'snrs', {}, 'azms', {}, 'spread', {}, 'src1mode', {}, 'azmsMode', {}, 'targetFBcollisions', {}, 'canBeSideMirrored', {} );


% 60° L
  scp7(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ -30    +30                ], 'spread', 60, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ -30    +30    +90         ], 'spread', 60, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [ -30    +30    +90   +150  ], 'spread', 60, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

  scp7(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [   0    +60                ], 'spread', 60, 'src1mode', 'L', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [   0    +60   +120         ], 'spread', 60, 'src1mode', 'L', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [   0    +60   +120   +180  ], 'spread', 60, 'src1mode', 'L', 'azmsMode', [4], 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );

  scp7(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ +15    +75                ], 'spread', 60, 'src1mode', 'L', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ -15    +45   +105         ], 'spread', 60, 'src1mode', 'L', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [ -45    +15    +75   +135  ], 'spread', 60, 'src1mode', 'L', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

  scp7(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ +60   +120                ], 'spread', 60, 'src1mode', 'L', 'azmsMode', 4, 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +30    +90   +150         ], 'spread', 60, 'src1mode', 'L', 'azmsMode', 4, 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );


% 120° L
  scp7(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ -60    +60                ], 'spread', 120, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ -60    +60    180         ], 'spread', 120, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

  scp7(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [   0   +120                ], 'spread', 120, 'src1mode', 'L', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [   0   +120   -120         ], 'spread', 120, 'src1mode', 'L', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 0 );

  scp7(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ -15   +105                ], 'spread', 120, 'src1mode', 'L', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ -75    +45    165         ], 'spread', 120, 'src1mode', 'L', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

  scp7(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [  30   +150                ], 'spread', 120, 'src1mode', 'L', 'azmsMode', 4, 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ -30    +90   -150         ], 'spread', 120, 'src1mode', 'L', 'azmsMode', 4, 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );

% 180° L
  scp7(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ -90    +90                ], 'spread', 180, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [   0   +180                ], 'spread', 180, 'src1mode', 'L', 'azmsMode', [4], 'targetFBcollisions', 1, 'canBeSideMirrored', 0 );
  scp7(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ -45   +135                ], 'spread', 180, 'src1mode', 'L', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  

% 60° C
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +30    -30    +90         ], 'spread', 60, 'src1mode', 'C', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [   0    +60    -60         ], 'spread', 60, 'src1mode', 'C', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 0 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +45    -15   +105         ], 'spread', 60, 'src1mode', 'C', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +90    +30   +150         ], 'spread', 60, 'src1mode', 'C', 'azmsMode', 4, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );


% 120° C
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +60    -60   +180         ], 'spread', 120, 'src1mode', 'C', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [   0   -120   +120         ], 'spread', 120, 'src1mode', 'C', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 0 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +45    -75   +165         ], 'spread', 120, 'src1mode', 'C', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +90    -30   -150         ], 'spread', 120, 'src1mode', 'C', 'azmsMode', 4, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

% 180° C
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +45   -135   -130         ], 'spread', 180, 'src1mode', 'C', 'azmsMode', [1,3], 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [   0   +180   +175         ], 'spread', 180, 'src1mode', 'C', 'azmsMode', 2, 'targetFBcollisions', 1, 'canBeSideMirrored', 0 );
  scp7(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +90    -90    -85         ], 'spread', 180, 'src1mode', 'C', 'azmsMode', 4, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

for ii = 1 : numel( scp7 )
    snrs = scp7(ii).snrs;
    if numel( snrs ) > 1
        for ss = [-20,-10,10,20]
            snrs_ = snrs;
            snrs_(2:end) = ss;
            scp7(end+1) = scp7(ii);
            scp7(end).snrs = snrs_;
        end
    end
end

scp6 = getTestSceneParametersMc6();

scp = [scp6, scp7];

% ascp = getAnnotatedSegId_mc5_testSceneParams( scp );
% 
% fascp = fieldnames( ascp );
% getFieldNames = {'nSrc','maxSnr','isnrStd','percentageBisects','avgMinDist','si2_src1','si2','ahos','si2_src1Norm','si2Norm','ahosNorm','src1Azm'};
% fascp_but_gfn = {};
% for ii = 1 : numel( fascp )
%     if ~any( strcmpi( fascp{ii}, getFieldNames ) )
%         fascp_but_gfn(end+1) = fascp(ii);
%     end
% end
% 
% ascp_ = rmfield( ascp, fascp_but_gfn );
% [ascp_(:).snrs] = deal( scp.snrs );
% [ascp_(:).azms] = deal( scp.azms );


end
