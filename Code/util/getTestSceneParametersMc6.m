function scp = getTestSceneParametersMc6()

scp = struct( 'nSrcs', {}, 'snrs', {}, 'azms', {}, 'spread', {}, 'src1mode', {}, 'azmsMode', {}, 'targetFBcollisions', {}, 'canBeSideMirrored', {} );

% 1-src
  scp(end+1) = struct( 'nSrcs', 1, 'snrs', [0            ], 'azms', [   0                       ], 'spread', 360, 'src1mode', 'C', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 0 );
  scp(end+1) = struct( 'nSrcs', 1, 'snrs', [0            ], 'azms', [  45                       ], 'spread', 360, 'src1mode', 'C', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 0 );
  scp(end+1) = struct( 'nSrcs', 1, 'snrs', [0            ], 'azms', [  90                       ], 'spread', 360, 'src1mode', 'C', 'azmsMode', 4, 'targetFBcollisions', 0, 'canBeSideMirrored', 0 );

% 0°
  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [   0      0                ], 'spread', 0, 'src1mode', 'C', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 0 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [   0      0      0         ], 'spread', 0, 'src1mode', 'C', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 0 );
  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [   0      0      0      0  ], 'spread', 0, 'src1mode', 'C', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 0 );
                                                                                                
% 10° L                                                                                         
  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [  -5     +5                ], 'spread', 10, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [  -5     +5    +15         ], 'spread', 10, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [  -5     +5    +15    +25  ], 'spread', 10, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [   0    +10                ], 'spread', 10, 'src1mode', 'L', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [   0    +10    +20         ], 'spread', 10, 'src1mode', 'L', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [   0    +10    +20    +30  ], 'spread', 10, 'src1mode', 'L', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ +40    +50                ], 'spread', 10, 'src1mode', 'L', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +35    +45    +55         ], 'spread', 10, 'src1mode', 'L', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [ +30    +40    +50    +60  ], 'spread', 10, 'src1mode', 'L', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ +85    +95                ], 'spread', 10, 'src1mode', 'L', 'azmsMode', 4, 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +80    +90   +100         ], 'spread', 10, 'src1mode', 'L', 'azmsMode', 4, 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [ +75    +85    +95   +105  ], 'spread', 10, 'src1mode', 'L', 'azmsMode', 4, 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );

% 20° L                                                                                                        
  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ -10    +10                ], 'spread', 20, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ -10    +10    +30         ], 'spread', 20, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [ -10    +10    +30    +50  ], 'spread', 20, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [   0    +20                ], 'spread', 20, 'src1mode', 'L', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [   0    +20    +40         ], 'spread', 20, 'src1mode', 'L', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [   0    +20    +40    +60  ], 'spread', 20, 'src1mode', 'L', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ +35    +55                ], 'spread', 20, 'src1mode', 'L', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +25    +45    +65         ], 'spread', 20, 'src1mode', 'L', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [ +15    +35    +55    +75  ], 'spread', 20, 'src1mode', 'L', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ +80   +100                ], 'spread', 20, 'src1mode', 'L', 'azmsMode', 4, 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +70    +90   +110         ], 'spread', 20, 'src1mode', 'L', 'azmsMode', 4, 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [ +60    +80   +100   +120  ], 'spread', 20, 'src1mode', 'L', 'azmsMode', 4, 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );

% 45° L
  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ -22.5  +22.5              ], 'spread', 45, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ -22.5  +22.5  +67.5       ], 'spread', 45, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [ -22.5  +22.5  +67.5 +112.5], 'spread', 45, 'src1mode', 'L', 'azmsMode', [1,3], 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [   0    +45                ], 'spread', 45, 'src1mode', 'L', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [   0    +45    +90         ], 'spread', 45, 'src1mode', 'L', 'azmsMode', [2,3], 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [   0    +45    +90   +135  ], 'spread', 45, 'src1mode', 'L', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ +22.5  +67.5              ], 'spread', 45, 'src1mode', 'L', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ +67.5 +112.5              ], 'spread', 45, 'src1mode', 'L', 'azmsMode', 4, 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +45    +90   +135         ], 'spread', 45, 'src1mode', 'L', 'azmsMode', 4, 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [ +22.5  +65.5 +112.5 +157.5], 'spread', 45, 'src1mode', 'L', 'azmsMode', 4, 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );

% 90° L
  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ -45    +45                ], 'spread', 90, 'src1mode', 'L', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ -45    +45   +135         ], 'spread', 90, 'src1mode', 'L', 'azmsMode', [1,3], 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [ -45    +45   +135   +225  ], 'spread', 90, 'src1mode', 'L', 'azmsMode', [1,4], 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );

  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [   0    +90                ], 'spread', 90, 'src1mode', 'L', 'azmsMode', [2,3], 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [   0    +90   +180         ], 'spread', 90, 'src1mode', 'L', 'azmsMode', [4], 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [   0    +90   +180   +270  ], 'spread', 90, 'src1mode', 'L', 'azmsMode', 2, 'targetFBcollisions', 1, 'canBeSideMirrored', 0 );

  scp(end+1) = struct( 'nSrcs', 4, 'snrs', [0   0   0   0], 'azms', [ -90      0    +90   +180  ], 'spread', 90, 'src1mode', 'L', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

  scp(end+1) = struct( 'nSrcs', 2, 'snrs', [0   0        ], 'azms', [ +45   +135                ], 'spread', 90, 'src1mode', 'L', 'azmsMode', 4, 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );
  
% 10° C
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [  +5     -5    +15         ], 'spread', 10, 'src1mode', 'C', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [   0    -10    +10         ], 'spread', 10, 'src1mode', 'C', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 0 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +45    +35    +55         ], 'spread', 10, 'src1mode', 'C', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +90    +80   +100         ], 'spread', 10, 'src1mode', 'C', 'azmsMode', 4, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
                                                                                                
% 20° C                                                                                         
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +10    -10    +30         ], 'spread', 20, 'src1mode', 'C', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [   0    -20    +20         ], 'spread', 20, 'src1mode', 'C', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 0 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +45    +25    +65         ], 'spread', 20, 'src1mode', 'C', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +90    +70   +110         ], 'spread', 20, 'src1mode', 'C', 'azmsMode', 4, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  
% 45° C
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +22.5  -22.5  +67.5       ], 'spread', 45, 'src1mode', 'C', 'azmsMode', 1, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [   0    +45    -45         ], 'spread', 45, 'src1mode', 'C', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 0 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +45      0    +90         ], 'spread', 45, 'src1mode', 'C', 'azmsMode', 3, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +90    +45    +135        ], 'spread', 45, 'src1mode', 'C', 'azmsMode', 4, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );
  
% 90° C
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +45    -45   +135         ], 'spread', 90, 'src1mode', 'C', 'azmsMode', [1,3], 'targetFBcollisions', 1, 'canBeSideMirrored', 1 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [   0    -90    +90         ], 'spread', 90, 'src1mode', 'C', 'azmsMode', 2, 'targetFBcollisions', 0, 'canBeSideMirrored', 0 );
  scp(end+1) = struct( 'nSrcs', 3, 'snrs', [0   0   0    ], 'azms', [ +90      0   +180         ], 'spread', 90, 'src1mode', 'C', 'azmsMode', 4, 'targetFBcollisions', 0, 'canBeSideMirrored', 1 );

for ii = 1 : numel( scp )
    snrs = scp(ii).snrs;
    if numel( snrs ) > 1
        for ss = [-20,-10,10,20]
            snrs_ = snrs;
            snrs_(2:end) = ss;
            scp(end+1) = scp(ii);
            scp(end).snrs = snrs_;
        end
    end
end


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
